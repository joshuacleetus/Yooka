//
//  YookaLocationViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 16/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaLocationViewController.h"
#import "YookaPostViewController.h"
#import "FSQView/FSVenue.h"
#import "FSQView/FSConverter.h"
#import <Reachability.h>
#import "Foursquare2.h"

@interface YookaLocationViewController ()

@end

@implementation YookaLocationViewController

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
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];

    
    _nearbyVenues = [NSMutableArray new];
    _filteredArray = [NSMutableArray new];
    _locationObjects = [NSMutableArray new];


//    http://api.locu.com/v1_0/venue/insight/?api_key=1b9372a2c73e41794633a4a59e77c8716e8cec81&dimension=new+york+city
//    http://api.locu.com/v1_0/venue/search/?api_key=1b9372a2c73e41794633a4a59e77c8716e8cec81&street_address=prince+street
    
    UIImageView *whitebg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    whitebg.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:whitebg];
    
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 120, 40)];
//    titleLabel.textColor = [UIColor grayColor];
//    titleLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:20.0];
//    //titleLabel.text = @"LOCATION";
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:titleLabel];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setFrame:CGRectMake(0, 0, 40, 40)];

    self.cancelBtn.backgroundColor= [UIColor whiteColor];
//    [self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
    UIImageView *cancel_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    cancel_icon.image = [UIImage imageNamed:@"x_close"];
    [self.view addSubview:cancel_icon];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, 240, 40)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = [UIFont fontWithName:@"OpenSans-Regular" size:16];
    _textField.textColor = [UIColor lightGrayColor];
    UIColor *color1 = [UIColor lightGrayColor];
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"  SEARCH" attributes:@{NSForegroundColorAttributeName: color1}];
//    UIColor * color3 = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textField addTarget:self
                   action:@selector(textFieldEditingBegan:)
         forControlEvents:UIControlEventEditingChanged];
    [_textField addTarget:self
                   action:@selector(textFieldDone:)
         forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_textField];
    
    UIImageView *gps_icon = [[UIImageView alloc]initWithFrame:CGRectMake(280, 0, 40, 40)];
    gps_icon.image = [UIImage imageNamed:@"search_button_blue.png"];
    [self.view addSubview:gps_icon];
    
    UIImageView *ver_line = [[UIImageView alloc]initWithFrame:CGRectMake(35, 0, 10, 40)];
    ver_line.image = [UIImage imageNamed:@"horizontal_line.png"];
    [self.view addSubview:ver_line];
    
    UIView *whiteline =[[UIView alloc]initWithFrame:CGRectMake(20, 39, 30, 1)];
    whiteline.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteline];
    
    UIImageView *horz_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 27, 320, 20)];
    horz_line.image = [UIImage imageNamed:@"lines.png"];
    [self.view addSubview:horz_line];
    
    UIImageView *horz_line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -25, 320, 41)];
    horz_line2.image = [UIImage imageNamed:@"lines.png"];
    [self.view addSubview:horz_line2];
    
    _locationTableView = [[UITableView alloc]initWithFrame:CGRectMake(-20.f, 45.f, 340.f, self.view.frame.size.height-50)];
//    _locationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height)];
    _locationTableView.delegate = self;
    _locationTableView.dataSource = self;
//    [_locationTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
//    _locationTableView.backgroundColor = [UIColor blackColor];
//    [_locationTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:_locationTableView];
    
    UIButton *search_button_top = [UIButton buttonWithType:UIButtonTypeCustom];
    [search_button_top setFrame:CGRectMake(280, 0, 40, 40)];
    [search_button_top setBackgroundColor:[UIColor clearColor]];
    [search_button_top addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:search_button_top];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        if ([CLLocationManager locationServicesEnabled] == YES) {
            
            self.locationManager = [[CLLocationManager alloc]init];
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            self.locationManager.delegate = self;
            [self.locationManager startUpdatingLocation];
            
            CLLocationManager* manager = [[CLLocationManager alloc] init];
            //... set up CLLocationManager and start updates
            _currentLocation = manager.location;
            //            NSLog(@"current location = %f",_currentLocation.coordinate.longitude);
        }else{
            [self showLocationAlert];
        }
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void) showLocationAlert {
    
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorized) {
        
        //Check whether Settings page is openable (iOS 5.1 not allows Settings page to be opened via openURL:)
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must enable location service,Turn on location service to allow \"YourApp\" to determine your location" delegate:self cancelButtonTitle:@"Settings" otherButtonTitles:@"Cancel", nil];
            [alert show];
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"You must enable location service" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  {
    if (buttonIndex == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    }
    
}

- (void)cancelBtnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)textFieldEditingBegan:(UITextField *)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    NSString *s = sender.text;
//    NSLog(@"search %@",s);
    if ([CLLocationManager locationServicesEnabled] == YES) {
        CLLocationManager* manager = [[CLLocationManager alloc] init];
        //... set up CLLocationManager and start updates
        _currentLocation = manager.location;
//            NSLog(@"current location = %f",_currentLocation.coordinate.longitude);
    }
    
    [Foursquare2 venueSearchNearByLatitude:@(_currentLocation.coordinate.latitude)
                                 longitude:@(_currentLocation.coordinate.longitude)
                                     query:s
                                     limit:@(100)
                                    intent:intentBrowse
                                    radius:@(50000)
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          NSDictionary *dic = result;
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          FSConverter *converter = [[FSConverter alloc]init];
                                          self.nearbyVenues =[NSMutableArray arrayWithArray:[converter convertToObjects:venues]];
                                          NSLog(@"%@",self.nearbyVenues);
                                          [_locationTableView reloadData];
                                      }
                                  }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

-(IBAction)textFieldDone:(UITextField *)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        NSString *s = sender.text;
        //    NSLog(@"search %@",s);
        if ([CLLocationManager locationServicesEnabled] == YES) {
            CLLocationManager* manager = [[CLLocationManager alloc] init];
            //... set up CLLocationManager and start updates
            _currentLocation = manager.location;
            //            NSLog(@"current location = %f",_currentLocation.coordinate.longitude);
        }
        
        [Foursquare2 venueSearchNearByLatitude:@(_currentLocation.coordinate.latitude)
                                     longitude:@(_currentLocation.coordinate.longitude)
                                         query:s
                                         limit:@(100)
                                        intent:intentBrowse
                                        radius:@(50000)
                                    categoryId:nil
                                      callback:^(BOOL success, id result){
                                          if (success) {
                                              NSDictionary *dic = result;
                                              NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                              FSConverter *converter = [[FSConverter alloc]init];
                                              self.nearbyVenues =[NSMutableArray arrayWithArray:[converter convertToObjects:venues]];
                                              NSLog(@"%@",self.nearbyVenues);
                                              [_locationTableView reloadData];
                                          }
                                      }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (void)searchButtonClicked:(id)sender
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    [self.textField resignFirstResponder];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        NSString *s = self.textField.text;
        //    NSLog(@"search %@",s);
        if ([CLLocationManager locationServicesEnabled] == YES) {
            CLLocationManager* manager = [[CLLocationManager alloc] init];
            //... set up CLLocationManager and start updates
            _currentLocation = manager.location;
            //            NSLog(@"current location = %f",_currentLocation.coordinate.longitude);
        }
        
        [Foursquare2 venueSearchNearByLatitude:@(_currentLocation.coordinate.latitude)
                                     longitude:@(_currentLocation.coordinate.longitude)
                                         query:s
                                         limit:@(100)
                                        intent:intentBrowse
                                        radius:@(50000)
                                    categoryId:nil
                                      callback:^(BOOL success, id result){
                                          if (success) {
                                              NSDictionary *dic = result;
                                              NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                              FSConverter *converter = [[FSConverter alloc]init];
                                              self.nearbyVenues =[NSMutableArray arrayWithArray:[converter convertToObjects:venues]];
                                              NSLog(@"%@",self.nearbyVenues);
                                              [_locationTableView reloadData];
                                          }
                                      }];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    _locationSelected = [NSMutableArray new];
//    _locationSelected = [NSArray arrayWithObjects:self.selected.venueId,self.venueSelected,self.venueAddress,self.venueCc,self.venueCity,self.venueState,self.venueCountry,self.venuePostalCode, nil];
    if (self.selected.venueId) {
        [_locationSelected addObject:self.selected.venueId];
    }else{
        [_locationSelected addObject:[NSNull null]];
    }
    if (self.venueSelected) {
        [_locationSelected addObject:self.venueSelected];
    }else{
        [_locationSelected addObject:[NSNull null]];
    }
    if (self.venueAddress) {
        [_locationSelected addObject:self.venueAddress];
    }else{
        [_locationSelected addObject:[NSNull null]];
    }
    if (self.venueCc) {
        [_locationSelected addObject:self.venueCc];
    }else{
        [_locationSelected addObject:[NSNull null]];
    }
    if (self.venueCity) {
        [_locationSelected addObject:self.venueCity];
    }else{
        [_locationSelected addObject:[NSNull null]];
    }
    if (self.venueState) {
        [_locationSelected addObject:self.venueState];
    }else{
        [_locationSelected addObject:[NSNull null]];
    }
    if (self.venueCountry) {
        [_locationSelected addObject:self.venueCountry];
    }else{
        [_locationSelected addObject:[NSNull null]];
    }
    if (self.venuePostalCode) {
        [_locationSelected addObject:self.venuePostalCode];
    }else{
        [_locationSelected addObject:[NSNull null]];
    }
    [_delegate sendLocationDataToA:_locationSelected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    [self getVenuesForLocation:newLocation];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

        return self.nearbyVenues.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
        if (self.nearbyVenues.count) {
            return 1;
        }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

            return 40.0; // all other rows are 40px high
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_locationTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        // create a custom label:                                        x    y   width  height
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, -7.0, 240.0, 40.0)];
        [_descriptionLabel setTag:1];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        _descriptionLabel.textColor = [UIColor grayColor];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        [_descriptionLabel setFont:[UIFont fontWithName:@"OpenSans" size:16]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:_descriptionLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 26, 270.0, 10.0)];
        [self.detailLabel setTag:2];
        [self.detailLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        self.detailLabel.textColor = [UIColor lightGrayColor];
        self.detailLabel.textAlignment = NSTextAlignmentLeft;
        [self.detailLabel setFont:[UIFont systemFontOfSize:10.0]];
        //            [_descriptionLabel setFont:[UIFont fontWithName:@"UbuntuTitling-Bold" size:23]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:self.detailLabel];
        


        
//        FSVenue *venue = self.nearbyVenues[indexPath.row];
//        if (venue.location.address) {
//            [(UILabel *)[cell.contentView viewWithTag:2] setText:[NSString stringWithFormat:@"%@, %@ m",
//                                                                  venue.location.address,
//                                                                  venue.location.distance]];
//            
//            
//        } else {
//            [(UILabel *)[cell.contentView viewWithTag:2] setText:[NSString stringWithFormat:@"%@ m",
//                                                                  venue.location.distance]];
//        }
        

    }
    
    //    cell.textLabel.text = [self.nearbyVenues[indexPath.row] name];
    FSVenue *venue = self.nearbyVenues[indexPath.row];
    if (venue.location.address) {
        [(UILabel *)[cell.contentView viewWithTag:2] setText:[NSString stringWithFormat:@"%@, %@ m",
                                                              venue.location.address,
                                                              venue.location.distance]];
    } else {
        
        [(UILabel *)[cell.contentView viewWithTag:2] setText:[NSString stringWithFormat:@"%@m", venue.location.distance]];
    }
    

        [(UILabel *)[cell.contentView viewWithTag:1] setText:[self.nearbyVenues[indexPath.row] name]];
    
        // [(UILabel *)[cell.contentView viewWithTag:2] setText:[NSString stringWithFormat:@"%@, %@ m",
                                                         // venue.location.address,
                                                         // venue.location.distance]];
    
    return cell;
}

//-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSIndexPath *oldIndex = [locationTableView indexPathForSelectedRow];
//    [locationTableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
//    [locationTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//    [locationTableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor purpleColor];
//    return indexPath;
//}

#pragma mark - Table view delegate

- (void)checkin {
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //    CheckinViewController *checkin = [storyboard instantiateViewControllerWithIdentifier:@"CheckinVC"];
    //    checkin.venue = self.selected;
    //    [self.navigationController pushViewController:checkin animated:YES];
}

- (void)userDidSelectVenue {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
//    [_textField resignFirstResponder];
    
    // keep track of the last selected cell
    self.lastSelected = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selected = self.nearbyVenues[indexPath.row];
    _venueSelected = [self.nearbyVenues[indexPath.row]name];
    NSLog(@"%@",_venueSelected);
    _venueAddress = self.selected.location.address;
    NSLog(@"%@",_venueAddress);
    _venueCc = self.selected.location.cc;
    NSLog(@"%@",_venueCc);
    _venueCity = self.selected.location.city;
    NSLog(@"%@",_venueCity);
    _venueState = self.selected.location.state;
    NSLog(@"%@",_venueState);
    _venueCountry = self.selected.location.country;
    NSLog(@"%@",_venueCountry);
    if (self.selected.location.postalCode) {
        _venuePostalCode = [NSString stringWithFormat:@"%@",self.selected.location.postalCode];
//        NSLog(@"%lu",(unsigned long)[_venuePostalCode length]);
    }


    [self userDidSelectVenue];
    
    [tableView reloadData];
    
    
}

- (void)getVenuesForLocation:(CLLocation *)location {
    
    [Foursquare2 venueSearchNearByLatitude:@(location.coordinate.latitude)
                                 longitude:@(location.coordinate.longitude)
                                     query:nil
                                     limit:nil
                                    intent:intentCheckin
                                    radius:@(1000)
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          NSDictionary *dic = result;
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          FSConverter *converter = [[FSConverter alloc]init];
                                          self.nearbyVenues =[NSMutableArray arrayWithArray:[converter convertToObjects:venues]];
                                          [self.locationTableView reloadData];
                                          
                                          
                                      }
                                  }];
}


- (void)backAction {
    //NSLog(@"back action");
}


@end
