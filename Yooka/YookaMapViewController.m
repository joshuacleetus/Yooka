//
//  YookaMapViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 7/17/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaMapViewController.h"
#import "AddressAnnotation.h"
#import "BridgeAnnotation.h"
#import "SFAnnotation.h"
#import "CustomAnnotationView.h"
#import "CustomMapItem.h"
#import "BridgeAnnotation.h"
#import "Reachability.h"
#import "YookaBackend.h"

@interface YookaMapViewController ()

@end

@implementation YookaMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton3  setFrame:CGRectMake(0, 0, 60, 70)];
    [self.navButton3 setBackgroundColor:[UIColor clearColor]];
    [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navButton3.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
    self.navButton3.tag = 1;
    self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton3];
    
    self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton  setFrame:CGRectMake(10, 23, 25, 21)];
    [self.navButton setBackgroundColor:[UIColor clearColor]];
    [self.navButton setBackgroundImage:[[UIImage imageNamed:@"menubar_white.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
    [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
    self.navButton.tag = 1;
    self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton];
    
    self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton2  setFrame:CGRectMake(0, 63, 60, 520)];
    [self.navButton2 setBackgroundColor:[UIColor clearColor]];
    [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
    self.navButton2.tag = 0;
    self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton2];
    
    [self.navButton2 setHidden:YES];
    
    
        if (([CLLocationManager locationServicesEnabled] == YES) && [CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied) {
            _locationManager = [[CLLocationManager alloc] init];
            //... set up CLLocationManager and start updates
            _currentLocation = _locationManager.location;
            //            NSLog(@"current location = %f",_currentLocation.coordinate.longitude);
            [self beginUpdatingLocation];
            
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Switch on location service for best results."
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            
            [alert show];
        }
        
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 60, 400, 600)];
    //Always center the dot and zoom in to an apropriate zoom level when position changes
    //        [_mapView setUserTrackingMode:MKUserTrackingModeFollow];
    self.mapView.delegate = self;
    
    // set Span
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = _currentLocation.coordinate.latitude;
    newRegion.center.longitude = _currentLocation.coordinate.longitude;
    
    //    NSLog(@"%f",_currentLocation.coordinate.latitude);
    //    NSLog(@"%f",_currentLocation.coordinate.longitude);
    //    newRegion.center.latitude = [_latitude doubleValue];
    //    newRegion.center.longitude = [_longitude doubleValue];
    
    newRegion.span.latitudeDelta = 0.122872;
    newRegion.span.longitudeDelta = 0.119863;
    
    [self.mapView setRegion:newRegion animated:YES];
    [self.mapView setShowsUserLocation:YES];
    [self.view addSubview:_mapView];
    
        [self getFeaturedRestaurants];
    
//        CLLocationCoordinate2D  ctrpoint;
//        ctrpoint.latitude = _currentLocation.coordinate.latitude;
//        ctrpoint.longitude =_currentLocation.coordinate.longitude;
//        AddressAnnotation *addAnnotation = [[AddressAnnotation alloc]initWithCoordinate:ctrpoint];
//        [self.mapView addAnnotation:addAnnotation];
    
}

- (void)getFeaturedRestaurants
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"ListRestaurants" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery query];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            
        } else {
            //got all events back from server -- update table view
            //            NSLog(@"featured restaurant = %@",objectsOrNil);
            _featuredRestaurants = [NSArray arrayWithArray:objectsOrNil];
            [self addAnnotation];
            
        }
    } withProgressBlock:nil];
}

- (void)addAnnotation
{
    self.mapAnnotations = [[NSMutableArray alloc] init];
    
    NSLog(@"count = %lu",(unsigned long)_featuredRestaurants.count);
    
    for (i=0; i<_featuredRestaurants.count; i++) {
        
        YookaBackend *yooka = _featuredRestaurants[i];
        
        NSString *lat = yooka.latitude;
        NSString *lon = yooka.longitude;
        NSString *pinTitle = yooka.Restaurant;
        NSLog(@"lat = %@, lon = %@, rest = %@",lat,lon,pinTitle);
        SFAnnotation *item1 = [[SFAnnotation alloc] init];
        item1.latitude = lat;
        item1.longitude = lon;
        item1.pinTitle = pinTitle;
        item1.secondtag = [NSString stringWithFormat:@"%d",i+1];
        if (i==310) {
            NSLog(@"id = %@",yooka.kinveyId);
            NSLog(@"id = %@",yooka.Hood);

        }
        
        [self.mapAnnotations addObject:item1];
        
    }
    
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    [self.mapView addAnnotations:self.mapAnnotations];
    [self zoomToFitMapAnnotations:self.mapView];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    //
    //    // etc...
    //     return nil;
    
    // handle our three custom annotations
    //
    if ([annotation isKindOfClass:[BridgeAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString *BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorGreen;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: when the detail disclosure button is tapped, we respond to it via:
            //       calloutAccessoryControlTapped delegate method
            //
            // by using "calloutAccessoryControlTapped", it's a convenient way to find out which annotation was tapped
            //
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    else if ([annotation isKindOfClass:[SFAnnotation class]])   // for City of San Francisco
    {
        static NSString *SFAnnotationIdentifier = @"SFAnnotationIdentifier";
        
        MKAnnotationView *flagAnnotationView =
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
        if (flagAnnotationView == nil)
        {
            flagAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:SFAnnotationIdentifier];
            flagAnnotationView.canShowCallout = YES;
            
            SFAnnotation *myAnn = (SFAnnotation *)annotation;
            
            NSLog(@"tag = %@",myAnn.secondtag);
            
            if ([myAnn.tag isEqualToString:@"1"]) {
                
                UIImage *flagImage = [UIImage imageNamed:@"tealpin.png"];
                // size the flag down to the appropriate size
                CGRect resizeRect;
                
                //            resizeRect.size = flagImage.size;
                //            CGSize maxSize = CGRectInset(self.view.bounds,
                //                                         [YookaHuntVenuesViewController annotationPadding],
                //                                         [YookaHuntVenuesViewController annotationPadding]).size;
                //            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [YookaHuntVenuesViewController calloutHeight];
                //            if (resizeRect.size.width > maxSize.width)
                //                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
                //            if (resizeRect.size.height > maxSize.height)
                //                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
                
                resizeRect = CGRectMake(0.f, 0.f, 30.f, 45.f);
                
                resizeRect.origin = CGPointMake(0.0, 0.0);
                UIGraphicsBeginImageContext(resizeRect.size);
                [flagImage drawInRect:resizeRect];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                flagAnnotationView.image = resizedImage;
                flagAnnotationView.opaque = NO;
                
                //            UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
                //            annotationView.leftCalloutAccessoryView = sfIconView;
                
                UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 22, 22)];
                tagLabel.textColor = [UIColor blackColor];
                tagLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:18.0];
                tagLabel.textAlignment = NSTextAlignmentCenter;
                tagLabel.tag = 42;
                [flagAnnotationView addSubview:tagLabel];
                
            }else if ([myAnn.tag isEqualToString:@"2"]){
                
                UIImage *flagImage = [UIImage imageNamed:@"tealpin.png"];
                // size the flag down to the appropriate size
                CGRect resizeRect;
                
                //            resizeRect.size = flagImage.size;
                //            CGSize maxSize = CGRectInset(self.view.bounds,
                //                                         [YookaHuntVenuesViewController annotationPadding],
                //                                         [YookaHuntVenuesViewController annotationPadding]).size;
                //            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [YookaHuntVenuesViewController calloutHeight];
                //            if (resizeRect.size.width > maxSize.width)
                //                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
                //            if (resizeRect.size.height > maxSize.height)
                //                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
                
                resizeRect = CGRectMake(0.f, 0.f, 20.f, 35.f);
                
                resizeRect.origin = CGPointMake(0.0, 0.0);
                UIGraphicsBeginImageContext(resizeRect.size);
                [flagImage drawInRect:resizeRect];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                flagAnnotationView.image = resizedImage;
                flagAnnotationView.opaque = NO;
                
                //            UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
                //            annotationView.leftCalloutAccessoryView = sfIconView;
                
                UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 5, 15, 22)];
                tagLabel.textColor = [UIColor blackColor];
                tagLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:10.0];
                tagLabel.textAlignment = NSTextAlignmentCenter;
                tagLabel.tag = 42;
                [flagAnnotationView addSubview:tagLabel];
                
            }else{
                
                UIImage *flagImage = [UIImage imageNamed:@"pin_artisse.png"];
                
                // size the flag down to the appropriate size
                CGRect resizeRect;
                
                //            resizeRect.size = flagImage.size;
                //            CGSize maxSize = CGRectInset(self.view.bounds,
                //                                         [YookaHuntVenuesViewController annotationPadding],
                //                                         [YookaHuntVenuesViewController annotationPadding]).size;
                //            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [YookaHuntVenuesViewController calloutHeight];
                //            if (resizeRect.size.width > maxSize.width)
                //                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
                //            if (resizeRect.size.height > maxSize.height)
                //                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
                
                resizeRect = CGRectMake(0.f, 0.f, 45.f, 45.f);
                
                resizeRect.origin = CGPointMake(0.0, 0.0);
                UIGraphicsBeginImageContext(resizeRect.size);
                [flagImage drawInRect:resizeRect];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                flagAnnotationView.image = resizedImage;
                flagAnnotationView.opaque = NO;
                
                //            UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
                //            annotationView.leftCalloutAccessoryView = sfIconView;
                
                UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 45, 22)];
                tagLabel.textColor = [UIColor darkGrayColor];
                tagLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:18.0];
                tagLabel.textAlignment = NSTextAlignmentCenter;
                tagLabel.tag = 42;
                [flagAnnotationView addSubview:tagLabel];
                
            }
            
            // offset the flag annotation so that the flag pole rests on the map coordinate
            flagAnnotationView.centerOffset = CGPointMake( flagAnnotationView.centerOffset.x + flagAnnotationView.image.size.width/2, flagAnnotationView.centerOffset.y - flagAnnotationView.image.size.height/2 );
            
        }
        else
        {
            flagAnnotationView.annotation = annotation;
        }
        
        SFAnnotation *myAnn = (SFAnnotation *)annotation;
        
        NSLog(@"view = %@",[flagAnnotationView viewWithTag:42]);
        
        UILabel *tagLabel = (UILabel *)[flagAnnotationView viewWithTag:42];
        tagLabel.text = [NSString stringWithFormat:@"%@",myAnn.secondtag];
        
        return flagAnnotationView;
    }
    else if ([annotation isKindOfClass:[CustomMapItem class]])  // for Japanese Tea Garden
    {
        static NSString *TeaGardenAnnotationIdentifier = @"TeaGardenAnnotationIdentifier";
        
        CustomAnnotationView *annotationView =
        (CustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:TeaGardenAnnotationIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:TeaGardenAnnotationIdentifier];
            
        }
        
        return annotationView;
    }
    
    return nil;
}

-(void)zoomToFitMapAnnotations:(MKMapView*)aMapView
{
    if([aMapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(MKPointAnnotation *annotation in _mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 2.25;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 1.25;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 5.75;
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 3.75;
    // Add a little extra space on the sides
    
    region = [aMapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
}

- (void)beginUpdatingLocation
{
    _locationManager.distanceFilter = 1000;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [_locationManager startUpdatingLocation];
    
    self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(stopUpdatingLocation) userInfo:nil repeats:NO];
}

- (void)stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
    [self.locationTimer invalidate];
}

//listen for the new location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* newLocation = [locations lastObject];
    
    NSTimeInterval age = -[newLocation.timestamp timeIntervalSinceNow];
    
    if (age>120) return; // ignore old (cached) updates
    
    if (newLocation.horizontalAccuracy < 0) return; // ignore invalid updates
    
    // need a valid oldLocation to be able to compute distance
    if (self.oldLocation == nil || self.oldLocation.horizontalAccuracy < 0) {
        self.oldLocation = newLocation;
        return;
    }
    
    //    CLLocationDistance distance = [newLocation distanceFromLocation:_oldLocation];
    
    self.oldLocation = newLocation; // save new location for next time
    
}

- (IBAction)navButtonClicked:(id)sender {
    
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            self.navButton.tag = 1;
            self.navButton2.tag = 1;
            self.navButton3.tag = 1;
            [self.navButton2 setHidden:YES];
            [_delegate movePanelToOriginalPosition];
            
            break;
        }
            
        case 1: {
            self.navButton.tag = 0;
            self.navButton3.tag = 0;
            self.navButton2.tag = 0;
            [_delegate movePanelRight];
            [self.navButton2 setHidden:NO];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
