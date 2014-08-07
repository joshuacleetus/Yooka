//
//  YookaHuntRestaurantViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 3/8/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaHuntRestaurantViewController.h"
#import "YookaBackend.h"
#import <Reachability.h>
#import "AddressAnnotation.h"
#import "BridgeAnnotation.h"
#import "SFAnnotation.h"
#import "CustomAnnotationView.h"
#import "CustomMapItem.h"
#import "BridgeAnnotation.h"
#import "SFAnnotation.h"
#import "YookaMenu2ViewController.h"
#import "YookaAppDelegate.h"
#import <AsyncImageDownloader.h>
#import <QuartzCore/QuartzCore.h>
#import "FSQView/FSVenue.h"
#import "FSQView/FSConverter.h"
#import "YookaLocation2ViewController.h"
#import "UIImageView+WebCache.h"
#import "BDViewController2.h"
#import "Foursquare2.h"

const NSInteger yookaThumbnailWidth4 = 320;
const NSInteger yookaThumbnailHeight4 = 415;
const NSInteger yookaImagesPerRow4 = 1;
const NSInteger yookaThumbnailSpace4 = 5;

@interface YookaHuntRestaurantViewController ()

@end

@implementation YookaHuntRestaurantViewController

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _selectedHunt = [NSString new];
    _yookaObjects = [NSMutableArray new];
    _mapAnnotations = [NSMutableArray new];
    _newsFeed = [NSMutableArray new];
    _thumbnails = [NSMutableArray new];
    _likesData = [NSMutableArray new];
    _likersData = [NSMutableArray new];
    _userEmail = [KCSUser activeUser].email;
    i=0;
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    //    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yooka.png"]];
    
    [self.navigationItem setTitle:_selectedRestaurantName];
    //    NSLog(@"%@",_huntTitle);
    
    //    NSLog(@"rest name = %@",_selectedRestaurantName);
    
    KCSCollection* collection = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
    self.updateStore2 = [KCSLinkedAppdataStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:collection, KCSStoreKeyResource, [NSNumber numberWithInt:KCSCachePolicyBoth], KCSStoreKeyCachePolicy, nil]];
    
    KCSCollection* collection2 = [KCSCollection collectionFromString:@"userPicture2" ofClass:[YookaBackend class]];
    self.updateStore3 = [KCSLinkedAppdataStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:collection2, KCSStoreKeyResource, [NSNumber numberWithInt:KCSCachePolicyBoth], KCSStoreKeyCachePolicy, nil]];
    
    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    _gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
    _gridScrollView.contentSize= self.view.bounds.size;
    _gridScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    [self.view addSubview:_gridScrollView];
    
    //    _panelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(13, 268, 295, 28)];
    //    _panelImageView.image = [UIImage imageNamed:@"restaurant_panel.png"];
    //    [self.gridScrollView addSubview:_panelImageView];
    
    //    self.phoneCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.phoneCallButton  setFrame:CGRectMake(10, 267, 97, 30)];
    //    [self.phoneCallButton setBackgroundColor:[UIColor clearColor]];
    //    [self.phoneCallButton addTarget:self action:@selector(phoneCallAction) forControlEvents:UIControlEventTouchUpInside];
    //    [self.gridScrollView addSubview:self.phoneCallButton];
    //
    //    self.hoursButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.hoursButton  setFrame:CGRectMake(177, 267, 131, 30)];
    //    [self.hoursButton setBackgroundColor:[UIColor clearColor]];
    //    [self.hoursButton addTarget:self action:@selector(hoursbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.gridScrollView addSubview:self.hoursButton];
    
    //    [self addAnnotation];
    
    //    CLLocationCoordinate2D  ctrpoint;
    //    ctrpoint.latitude = [_latitude doubleValue];
    //    ctrpoint.longitude =[_longitude doubleValue];
    //    AddressAnnotation *addAnnotation = [[AddressAnnotation alloc]initWithCoordinate:ctrpoint];
    //    [self.mapView addAnnotation:addAnnotation];
    
    self.whiteBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 125, 320, 75)];
    self.whiteBg.image = [UIImage imageNamed:@"White_transulentback.png"];
    [self.gridScrollView addSubview:self.whiteBg];
    
    _phoneLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(110, 222, 100, 21)];
    _phoneLabel2.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
    _phoneLabel2.textAlignment = NSTextAlignmentLeft;
    _phoneLabel2.text = @"Telephone:";
    _phoneLabel2.textColor = [UIColor colorFromHexCode:@"3d3d3d"];
    [self.gridScrollView addSubview:_phoneLabel2];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 265, 210, 21)];
    _priceLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    _priceLabel.text = @"Price:            $3.00 - $105.00";
    _priceLabel.textColor = [UIColor colorFromHexCode:@"3d3d3d"];
    [self.gridScrollView addSubview:_priceLabel];
    
    _hoursLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 245, 210, 21)];
    _hoursLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
    _hoursLabel.textAlignment = NSTextAlignmentLeft;
    _hoursLabel.text = @"Hours:    10:00AM - 11:00PM";
    _hoursLabel.textColor = [UIColor colorFromHexCode:@"3d3d3d"];
    [self.gridScrollView addSubview:_hoursLabel];
    
    //    self.hoursButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self.hoursButton  setFrame:CGRectMake(110, 265, 52, 21)];
    //    [self.hoursButton setBackgroundColor:[UIColor redColor]];
    //    [self.hoursButton addTarget:self action:@selector(hoursbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.gridScrollView addSubview:self.hoursButton];
    
    self.restaurantNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 10, 295, 15)];
    _restaurantNameLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:16.0];
    _restaurantNameLabel.textAlignment = NSTextAlignmentLeft;
    _restaurantNameLabel.textColor = [UIColor colorFromHexCode:@"ff7e00"];
    _restaurantNameLabel.text = [_selectedRestaurantName uppercaseString];
    _restaurantNameLabel.adjustsFontSizeToFitWidth = YES;
    [self.whiteBg addSubview:_restaurantNameLabel];
    
//    UIImageView *restaurantImageBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 310, 320, 300)];
//    [restaurantImageBg setBackgroundColor:[UIColor darkGrayColor]];
//    [self.gridScrollView addSubview:restaurantImageBg];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        [self getRestaurantDetails];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        [self setupNewsFeed];
        
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
    [super viewWillDisappear:animated];
    self.working = NO;
    [_delegate sendrestaurantDataToA:_huntTitle];

}

- (void)phoneCallAction
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *cleanedString = [[_phoneLabel componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",telURL]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.working = YES;    
}

- (void)showTabBar:(UITabBarController *) tabbarcontroller
{
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            if([UIScreen mainScreen].bounds.size.height==568)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 519, view.frame.size.width, view.frame.size.height)];
            }
            else
            {
                [view setFrame:CGRectMake(view.frame.origin.x, 431, view.frame.size.width, view.frame.size.height)];
            }
        }
        else
        {
            if([UIScreen mainScreen].bounds.size.height==568)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 519)];
            }
            else
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, 431)];
            }
        }
    }
}

- (void)showReloadButton {
    i=0;
    UIBarButtonItem * reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(setupNewsFeed)];
    reloadButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = reloadButton;
    
}

- (void)reloadView
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        [self showActivityIndicator];
        
        KCSQuery* query = [KCSQuery queryOnField:@"venueName" withExactMatchForValue:_selectedRestaurantName];
        KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"postDate" inDirection:kKCSDescending];
        [query addSortModifier:sortByDate]; //sort the return by the date field
        [query setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:15]]; //just get back 10 results
        [self.updateStore2 queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            //        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0]; //too fast transition feels weird
            //            [self.refreshControl endRefreshing];
            if (objectsOrNil && objectsOrNil.count) {
                
                //                NSLog(@"newfeed= %@",objectsOrNil);
                //                NSLog(@"try = %@",objectsOrNil[0]);
                //                YookaBackend *try = objectsOrNil[1];
                //                NSLog(@"try 2 = %@",try.dishImage);
                _newsFeed2 = [NSMutableArray arrayWithArray:objectsOrNil];
                YookaBackend *yooka = _newsFeed2[0];
                NSString *kinveyId = [_newsFeed[0] objectForKey:@"_id"];
                
                if ([kinveyId isEqualToString:yooka.kinveyId]) {
                    NSLog(@"same");
                    k=0;
                    [self loadlikes];
                    
                }else{
                    NSLog(@"not same");
                    [_gridScrollView removeFromSuperview];
                    
                    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
                    _gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
                    _gridScrollView.contentSize= self.view.bounds.size;
                    _gridScrollView.frame = CGRectMake(0.f, 65.f, 320.f, self.view.frame.size.height);
                    [self.view addSubview:_gridScrollView];
                    
                    contentSize = 130;
                    
                    [self setupNewsFeed];
                    
                }
                
            }else{
                NSLog(@"newfeed= %@",errorOrNil);
                
                [self stopActivityIndicator];
            }
        } withProgressBlock:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}


- (void)showActivityIndicator {
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(285, 9, 27, 27)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

- (void)stopActivityIndicator {
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(285, 9, 27, 27)];
    [activityIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = nil;
    [self showReloadButton];
}

- (void)setupNewsFeed
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
    [self showActivityIndicator];
    _collectionName1 = @"yookaPosts2";
    _customEndpoint1 = @"VenueImage";
    _fieldName1 = @"postDate";
    //NSLog(@"selected restaurant = %@",_selectedRestaurantName);
    _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_collectionName1,@"collectionName",_fieldName1,@"fieldName",_selectedRestaurantName,@"venueName", nil];
    
    [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){

        if ([results isKindOfClass:[NSArray class]]) {
            _newsFeed = [NSMutableArray arrayWithArray:results];
            if (_newsFeed && _newsFeed.count) {
                
//                 NSLog(@"%@",_newsFeed);
                
                [self fillPictures];
                
            }else{
//                 NSLog(@"User Search Results = \n %@",results);
                [self stopActivityIndicator];
            }
            
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

- (void)fillPictures
{
    //    NSLog(@"FILL PICTURES");
    item = 0;
    row = 0;
    col = 0;
    contentSize = 300;
    for (item=0;item<self.newsFeed.count;item++) {
        
        UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
        UITapGestureRecognizer *tapTrice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapThrice:)];
        
        tapOnce.numberOfTapsRequired = 1;
        tapTwice.numberOfTapsRequired = 2;
        tapTrice.numberOfTapsRequired = 3;
        //stops tapOnce from overriding tapTwice
        [tapOnce requireGestureRecognizerToFail:tapTwice];
        [tapTwice requireGestureRecognizerToFail:tapTrice];
        
        _button = [[UIButton alloc] initWithFrame:CGRectMake(col*yookaThumbnailWidth4,
                                                             (row*yookaThumbnailHeight4)+310.f,
                                                             yookaThumbnailWidth4,
                                                             yookaThumbnailHeight4)];
        contentSize += yookaThumbnailHeight4;
        _button.tag = item;
        _button.userInteractionEnabled = YES;
        //        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_button addGestureRecognizer:tapOnce]; //remove the other button action which calls method `button`
        [_button addGestureRecognizer:tapTwice];
        [_button addGestureRecognizer:tapTrice];
        
        ++col;
        
        if (col >= yookaImagesPerRow4) {
            row++;
            col = 0;
        }
        
        [self.gridScrollView addSubview:_button];
        [self.thumbnails addObject:_button];
    }
    
    [_gridScrollView setContentSize:CGSizeMake(320, contentSize+35)];
    
    [self loadImages];
}

- (void)tapOnce:(id)sender
{
    //NSLog(@"Tap once");
}

- (void)tapTwice:(UIGestureRecognizer *)sender
{
    [self.gridScrollView setUserInteractionEnabled:NO];
//    NSLog(@"Tap twice");
    UIView * view = sender.view;
    
    _postLikers = [NSMutableArray new];
    
    UIButton* button = [self.thumbnails objectAtIndex:view.tag];
    
    _postId = [_newsFeed[view.tag] objectForKey:@"_id"];
    //    NSLog(@"post id = %@",_postId);
    _postHuntName = [_newsFeed[view.tag] objectForKey:@"HuntName"];
    //    NSLog(@"hunt name = %@",_postHuntName);
    _postCaption = [_newsFeed[view.tag] objectForKey:@"caption"];
    //    NSLog(@"caption = %@",_postCaption);
    _postDishImageUrl = [[_newsFeed[view.tag] objectForKey:@"dishImage"]objectForKey:@"_downloadURL"];
    //    NSLog(@"dish image url = %@",_postDishImageUrl);
    _postDishName = [_newsFeed[view.tag] objectForKey:@"dishName"];
    //    NSLog(@"dish name = %@",_postDishName);
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store loadObjectWithID:_postId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            if (objectsOrNil && objectsOrNil.count) {
                
                YookaBackend *backendObject = objectsOrNil[0];
                _postLikers = [NSMutableArray arrayWithArray:backendObject.likers];
                _postLikes = backendObject.likes;
                
                if ([_postLikes intValue]==0) {
                    _likeStatus = @"NO";
                }
//                NSLog(@"likes = %@",_postLikes);
                
                if (!(_postLikers == (id)[NSNull null])) {
                    if ([_postLikers containsObject:_userEmail]) {
                        _likeStatus = @"YES";
                    }else{
                        _likeStatus = @"NO";
                    }
                }else{
                    _likeStatus = @"NO";
                    //        NSLog(@"try try try");
                }
                
                //    NSLog(@"like status = %@",_likeStatus);
                
                
                if ([_likeStatus isEqualToString:@"YES"]) {
                    
                    int post_likes = [_postLikes intValue];
                    post_likes = post_likes-1;
                    _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                    
                    if (_postLikers==(id)[NSNull null]) {
                        //                        [_likersData replaceObjectAtIndex:view.tag withObject:[NSNull null]];
                    }else{
                        [_postLikers removeObject:_userEmail];
                    }
                    
                    //        NSLog(@"likes data 2 = %@",_likesData);
                    //        NSLog(@"likers data 2 = %@",_likersData);
                    
                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
                    likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                    [button addSubview:likesImageView];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
                    likesLabel.textColor = [UIColor orangeColor];
                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
                    likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                    likesLabel.textAlignment = NSTextAlignmentCenter;
                    likesLabel.adjustsFontSizeToFitWidth = YES;
                    [likesImageView addSubview:likesLabel];
                    
                    //                [self saveSelectedPost];
                    [self saveLikes];
                    _likeStatus = @"NO";
                    
                }else{
                    
                    if (_postLikers == (id)[NSNull null]) {
                        //            NSLog(@"post likers 2 = %@",_postLikers);
                        _postLikers = [NSMutableArray arrayWithObject:_userEmail];
                        //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                        
                    }else{
                        //            NSLog(@"post likers 3 = %@",_postLikers);
                        
                        [_postLikers addObject:_userEmail];
                        //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                        
                    }
                    
                    int post_likes = [_postLikes intValue];
                    post_likes=post_likes+1;
                    _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                    
                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
                    likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
                    [button addSubview:likesImageView];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
                    likesLabel.textColor = [UIColor whiteColor];
                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
                    likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                    likesLabel.textAlignment = NSTextAlignmentCenter;
                    likesLabel.adjustsFontSizeToFitWidth = YES;
                    [likesImageView addSubview:likesLabel];
                    
                    //                [self saveSelectedPost];
                    [self saveLikes];
                    _likeStatus = @"YES";
                    
                }
                
            }else{
                
                _postLikes = @"0";
                
                _likeStatus = @"NO";
//                NSLog(@"likes = %@",_postLikes);
                
                _postLikers = [NSMutableArray arrayWithObject:_userEmail];
                
                int post_likes = [_postLikes intValue];
                post_likes=post_likes+1;
                _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                
                //        NSLog(@"likes data 2 = %@",_likesData);
                //        NSLog(@"likers data 2 = %@",_likersData);
                
                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
                likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
                [button addSubview:likesImageView];
                
                UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
                likesLabel.textColor = [UIColor whiteColor];
                [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
                likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                likesLabel.textAlignment = NSTextAlignmentCenter;
                likesLabel.adjustsFontSizeToFitWidth = YES;
                [likesImageView addSubview:likesLabel];
                
                //                [self saveSelectedPost];
                [self saveLikes];
                _likeStatus = @"YES";
                
            }
            
        }else{
            
            _postLikes = @"0";
            
            _likeStatus = @"NO";
//            NSLog(@"likes = %@",_postLikes);
            
            _postLikers = [NSMutableArray arrayWithObject:_userEmail];
            
            
            int post_likes = [_postLikes intValue];
            post_likes=post_likes+1;
            _postLikes = [NSString stringWithFormat:@"%d",post_likes];
            
            //        NSLog(@"likes data 2 = %@",_likesData);
            //        NSLog(@"likers data 2 = %@",_likersData);
            
            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
            likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
            [button addSubview:likesImageView];
            
            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
            likesLabel.textColor = [UIColor whiteColor];
            [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
            likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
            likesLabel.textAlignment = NSTextAlignmentCenter;
            likesLabel.adjustsFontSizeToFitWidth = YES;
            [likesImageView addSubview:likesLabel];
            
            //                [self saveSelectedPost];
            [self saveLikes];
            _likeStatus = @"YES";
            
        }
        
    } withProgressBlock:nil];
    
}

- (void)saveLikes
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _postId;
    yookaObject.likes = _postLikes;
    yookaObject.likers = _postLikers;
    [yookaObject.meta setGloballyReadable:YES];
    [yookaObject.meta setGloballyWritable:YES];
    
    KCSUser* myFriend = [KCSUser activeUser];
    [yookaObject.meta.readers addObject:myFriend.userId];
    //add 'myFriend' to the writers list as well
    [yookaObject.meta.writers addObject:myFriend.userId];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            //            NSLog(@"Not saved event (error= %@).",errorOrNil);
            
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                //                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                [self.gridScrollView setUserInteractionEnabled:YES];
                
            }
        }
    } withProgressBlock:nil];
}

- (void)tapThrice:(id)sender
{
    //    NSLog(@"Tap thrice");
}

- (void)tapTwice2:(id)sender
{
    //    [self.gridScrollView setUserInteractionEnabled:NO];
    //    NSLog(@"Tap twice");
    UIButton* button1 = sender;
    NSUInteger b = button1.tag;
    //    NSLog(@"post data = %@",_newsFeed[view.tag]);
    //    NSLog(@"likes data = %@",_likesData);
    //    NSLog(@"likers data = %@",_likersData);
    _postLikers = [NSMutableArray new];
    
    UIButton* button = [self.thumbnails objectAtIndex:b];
    
    _postId = [_newsFeed[b] objectForKey:@"_id"];
    //    NSLog(@"post id = %@",_postId);
    _postHuntName = [_newsFeed[b] objectForKey:@"HuntName"];
    //    NSLog(@"hunt name = %@",_postHuntName);
    _postCaption = [_newsFeed[b] objectForKey:@"caption"];
    //    NSLog(@"caption = %@",_postCaption);
    _postDishImageUrl = [[_newsFeed[b] objectForKey:@"dishImage"]objectForKey:@"_downloadURL"];
    //    NSLog(@"dish image url = %@",_postDishImageUrl);
    _postDishName = [_newsFeed[b] objectForKey:@"dishName"];
    //    NSLog(@"dish name = %@",_postDishName);
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store loadObjectWithID:_postId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            if (objectsOrNil && objectsOrNil.count) {
                
                YookaBackend *backendObject = objectsOrNil[0];
                _postLikers = [NSMutableArray arrayWithArray:backendObject.likers];
                _postLikes = backendObject.likes;
                
                if ([_postLikes intValue]==0) {
                    _likeStatus = @"NO";
                }
                //                NSLog(@"likes = %@",_postLikes);
                
                if (!(_postLikers == (id)[NSNull null])) {
                    if ([_postLikers containsObject:_userEmail]) {
                        _likeStatus = @"YES";
                    }else{
                        _likeStatus = @"NO";
                    }
                }else{
                    _likeStatus = @"NO";
                    //        NSLog(@"try try try");
                }
                
                //    NSLog(@"like status = %@",_likeStatus);
                
                if ([_likeStatus isEqualToString:@"YES"]) {
                    
                    int post_likes = [_postLikes intValue];
                    post_likes = post_likes-1;
                    _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                    
                    if (_postLikers==(id)[NSNull null]) {
                        //                        [_likersData replaceObjectAtIndex:view.tag withObject:[NSNull null]];
                    }else{
                        [_postLikers removeObject:_userEmail];
                    }
                    
                    //        NSLog(@"likes data 2 = %@",_likesData);
                    //        NSLog(@"likers data 2 = %@",_likersData);
                    
                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
                    likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                    [button addSubview:likesImageView];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
                    likesLabel.textColor = [UIColor orangeColor];
                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
                    likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                    likesLabel.textAlignment = NSTextAlignmentCenter;
                    likesLabel.adjustsFontSizeToFitWidth = YES;
                    [likesImageView addSubview:likesLabel];
                    
                    //                [self saveSelectedPost];
                    [self saveLikes];
                    _likeStatus = @"NO";
                    
                }else{
                    
                    if (_postLikers == (id)[NSNull null]) {
                        //            NSLog(@"post likers 2 = %@",_postLikers);
                        _postLikers = [NSMutableArray arrayWithObject:_userEmail];
                        //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                        
                    }else{
                        //            NSLog(@"post likers 3 = %@",_postLikers);
                        
                        [_postLikers addObject:_userEmail];
                        //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                        
                    }
                    
                    int post_likes = [_postLikes intValue];
                    post_likes=post_likes+1;
                    _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                    //                    [_likesData replaceObjectAtIndex:view.tag withObject:_postLikes];
                    
                    //        NSLog(@"likes data 2 = %@",_likesData);
                    //        NSLog(@"likers data 2 = %@",_likersData);
                    
                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
                    likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
                    [button addSubview:likesImageView];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
                    likesLabel.textColor = [UIColor whiteColor];
                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
                    likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                    likesLabel.textAlignment = NSTextAlignmentCenter;
                    likesLabel.adjustsFontSizeToFitWidth = YES;
                    [likesImageView addSubview:likesLabel];
                    
                    //                [self saveSelectedPost];
                    [self saveLikes];
                    _likeStatus = @"YES";
                    
                }
                
                
            }else{
                
                _postLikes = @"0";
                
                _likeStatus = @"NO";
                //                NSLog(@"likes = %@",_postLikes);
                
                _postLikers = [NSMutableArray arrayWithObject:_userEmail];
                
                
                int post_likes = [_postLikes intValue];
                post_likes=post_likes+1;
                _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                
                //        NSLog(@"likes data 2 = %@",_likesData);
                //        NSLog(@"likers data 2 = %@",_likersData);
                
                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
                likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
                [button addSubview:likesImageView];
                
                UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
                likesLabel.textColor = [UIColor whiteColor];
                [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
                likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                likesLabel.textAlignment = NSTextAlignmentCenter;
                likesLabel.adjustsFontSizeToFitWidth = YES;
                [likesImageView addSubview:likesLabel];
                
                //                [self saveSelectedPost];
                [self saveLikes];
                _likeStatus = @"YES";
                
            }
            
        }else{
            
            _postLikes = @"0";
            
            _likeStatus = @"NO";
            //            NSLog(@"likes = %@",_postLikes);
            
            _postLikers = [NSMutableArray arrayWithObject:_userEmail];
            
            
            int post_likes = [_postLikes intValue];
            post_likes=post_likes+1;
            _postLikes = [NSString stringWithFormat:@"%d",post_likes];
            
            //        NSLog(@"likes data 2 = %@",_likesData);
            //        NSLog(@"likers data 2 = %@",_likersData);
            
            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
            likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
            [button addSubview:likesImageView];
            
            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
            likesLabel.textColor = [UIColor whiteColor];
            [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
            likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
            likesLabel.textAlignment = NSTextAlignmentCenter;
            likesLabel.adjustsFontSizeToFitWidth = YES;
            [likesImageView addSubview:likesLabel];
            
            //                [self saveSelectedPost];
            [self saveLikes];
            _likeStatus = @"YES";
            
        }
        
    } withProgressBlock:nil];
    
    
}

- (void)loadImages
{
    
    //    NSLog(@"load images");
    if (i<_newsFeed.count&& self.working==YES) {
        //    for(i=0;i<_newsFeed.count;i++){
        
        //        NSLog(@"hahahah");
        
        //        YookaBackend *yooka = _newsFeed[i];
        
        NSString *dishPicUrl = [[_newsFeed[i] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
        NSString *userId = [_newsFeed[i] objectForKey:@"userEmail"];
        [_userEmails addObject:userId];
        //        NSLog(@"hahahaha = %@",userId);
        NSString *dishName = [_newsFeed[i] objectForKey:@"dishName"];
        NSString *venueName = [_newsFeed[i] objectForKey:@"venueName"];
        NSString *venueAddress = [_newsFeed[i] objectForKey:@"venueAddress"];
        NSString *caption = [_newsFeed[i] objectForKey:@"caption"];
        NSString *post_vote = [_newsFeed[i] objectForKey:@"postVote"];
        NSString *kinveyId = [_newsFeed[i] objectForKey:@"_id"];
        
        UIButton *button = [self.thumbnails objectAtIndex:i];
        
        //        if (i==1) {
        //            [self loadImages2];
        //        }
        
        UIImageView *buttonImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 310, 310)];
        //                [buttonImage2 setBackgroundColor:[UIColor redColor]];
        buttonImage2.image = [UIImage imageNamed:@"YookaPostsBg.png"];
        [button addSubview:buttonImage2];
        
        UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 304, 304)];
        [buttonImage setBackgroundColor:[UIColor clearColor]];
        buttonImage.contentMode = UIViewContentModeScaleAspectFill;
        buttonImage.clipsToBounds = YES;
        buttonImage.opaque = YES;
        buttonImage.image = nil;
        
//        [[SDImageCache sharedImageCache] queryDiskCacheForKey:kinveyId done:^(UIImage *image, SDImageCacheType cacheType)
//         {
//             // image is not nil if image was found
//             if (image) {
//                 
//                 NSLog(@"found cache");
//                 
//                 [buttonImage setImage:image];
//                 [button addSubview:buttonImage];
//                 
//                 UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 290, 45)];
//                 dishLabel.textColor = [UIColor whiteColor];
//                 [dishLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:30]];
//                 dishLabel.text = [dishName uppercaseString];
//                 dishLabel.textAlignment = NSTextAlignmentLeft;
//                 dishLabel.adjustsFontSizeToFitWidth = YES;
//                 dishLabel.numberOfLines = 0;
//                 [dishLabel sizeToFit];
//                 dishLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
//                 dishLabel.layer.shadowRadius = 1;
//                 dishLabel.layer.shadowOpacity = 1;
//                 dishLabel.layer.shadowOffset = CGSizeMake(2.0, 5.0);
//                 dishLabel.layer.masksToBounds = NO;
//                 [button addSubview:dishLabel];
//                 
//                 UILabel *venueLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 315, 155, 30)];
//                 venueLabel.textColor = [UIColor orangeColor];
//                 [venueLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:20]];
//                 venueLabel.text = venueName;
//                 venueLabel.textAlignment = NSTextAlignmentCenter;
//                 venueLabel.adjustsFontSizeToFitWidth = YES;
//                 [button addSubview:venueLabel];
//                 
////                 UIButton *restaurant_button = [UIButton buttonWithType:UIButtonTypeCustom];
////                 [restaurant_button  setFrame:CGRectMake(100, 315, 155, 30)];
////                 [restaurant_button setBackgroundColor:[UIColor clearColor]];
////                 restaurant_button.tag = i;
////                 [restaurant_button addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
////                 [button addSubview:restaurant_button];
//                 
//                 UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 345, 90, 12)];
//                 addressLabel.textColor = [UIColor lightGrayColor];
//                 [addressLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//                 addressLabel.text = venueAddress;
//                 addressLabel.textAlignment = NSTextAlignmentRight;
//                 addressLabel.adjustsFontSizeToFitWidth = NO;
//                 [button addSubview:addressLabel];
//                 
//                 NSDate *createddate = [_newsFeed[i] objectForKey:@"postDate"];
//                 NSDate *now = [NSDate date];
//                 NSString *str;
//                 NSMutableString *myString = [NSMutableString string];
//                 
//                 NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createddate];
//                 if (secondsBetween<60) {
//                     int duration = secondsBetween;
//                     str = [NSString stringWithFormat:@"%ds",duration]; //%d or %i both is ok.
//                     [myString appendString:str];
//                 }else if (secondsBetween<3600) {
//                     int duration = secondsBetween / 60;
//                     str = [NSString stringWithFormat:@"%dm",duration]; //%d or %i both is ok.
//                     [myString appendString:str];
//                 }else if (secondsBetween<86400){
//                     int duration = secondsBetween / 3600;
//                     str = [NSString stringWithFormat:@"%dh",duration]; //%d or %i both is ok.
//                     [myString appendString:str];
//                 }else if (secondsBetween<604800){
//                     int duration = secondsBetween / 86400;
//                     str = [NSString stringWithFormat:@"%dd",duration]; //%d or %i both is ok.
//                     [myString appendString:str];
//                 }else {
//                     int duration = secondsBetween / 604800;
//                     str = [NSString stringWithFormat:@"%dw",duration]; //%d or %i both is ok.
//                     [myString appendString:str];
//                 }
//                 
//                 UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(240, 330, 70, 12)];
//                 time_label.text = [NSString stringWithFormat:@"%@",myString];
//                 time_label.textColor = [UIColor grayColor];
//                 [time_label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//                 time_label.textAlignment = NSTextAlignmentRight;
//                 [button addSubview:time_label];
//                 
//                 UILabel *captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 370, 310, 18)];
//                 captionLabel.textColor = [UIColor darkGrayColor];
//                 [captionLabel setFont:[UIFont fontWithName:@"Helvetica-LightOblique" size:15]];
//                 captionLabel.text = [NSString stringWithFormat:@"\"%@\"",caption];
//                 captionLabel.textAlignment = NSTextAlignmentCenter;
//                 captionLabel.adjustsFontSizeToFitWidth = YES;
//                 [button addSubview:captionLabel];
//                 
//                 //                                    KCSCollection *yookaObjects2 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
//                 //                                    KCSAppdataStore *store2 = [KCSAppdataStore storeWithCollection:yookaObjects2 options:nil];
//                 //
//                 //                                    KCSQuery* query4 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
//                 //                                    KCSQuery* query5 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YAY"];
//                 ////                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
//                 //                                    KCSQuery* query7 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query4,query5, nil];
//                 //
//                 //                                    [store2 queryWithQuery:query7 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//                 //                                        if (errorOrNil == nil) {
//                 //
//                 //                                            _yayVote = [NSNumber numberWithInteger:objectsOrNil.count];
//                 ////                                            NSLog(@"TRY 1 postVote = %@",_yayVote);
//                 //
//                 //                                            KCSCollection *yookaObjects3 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
//                 //                                            KCSAppdataStore *store3 = [KCSAppdataStore storeWithCollection:yookaObjects3 options:nil];
//                 //
//                 //                                            KCSQuery* query8 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
//                 //                                            KCSQuery* query9 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"NAY"];
//                 //                                            //                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
//                 //                                            KCSQuery* query10 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query8,query9, nil];
//                 //
//                 //                                            [store3 queryWithQuery:query10 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//                 //                                                if (errorOrNil == nil) {
//                 //                                                    _nayVote = [NSNumber numberWithInteger:objectsOrNil.count];
//                 ////                                                    NSLog(@"venue name = %@",dishName);
//                 ////                                                    NSLog(@"TRY 3 postVote = %@",_nayVote);
//                 ////                                                    NSLog(@"yay = %@",_yayVote);
//                 ////                                                    NSLog(@"nay = %@",_nayVote);
//                 //
//                 //                                                    CGFloat percent = [_yayVote floatValue]/([_yayVote doubleValue]+[_nayVote doubleValue]);
//                 ////                                                    NSLog(@"percentage = %f",percent);
//                 //
//                 //                                                    // Calculate this somehow
//                 //                                                    UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
//                 //                                                    barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
//                 //                                                    [button addSubview:barImage];
//                 //
//                 //                                                    UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
//                 //                                                    barPercentage.image = [UIImage imageNamed:@"100.png"];
//                 //                                                    [button addSubview:barPercentage];
//                 //
//                 //                                                    UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
//                 //                                                    voteLabel.textColor = [UIColor whiteColor];
//                 //                                                    [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
//                 //                                                    voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
//                 //                                                    voteLabel.textAlignment = NSTextAlignmentCenter;
//                 //                                                    voteLabel.adjustsFontSizeToFitWidth = NO;
//                 //                                                    [button addSubview:voteLabel];
//                 //
//                 //                                                    [_gridScrollView addSubview:button];
//                 //
//                 //                                                    i++;
//                 //                                                    [self loadImages];
//                 //
//                 //                                                }else{
//                 ////                                                    NSLog(@"TRY 4 ");
//                 //                                                    [_gridScrollView addSubview:button];
//                 //
//                 //                                                    i++;
//                 //                                                    [self loadImages];
//                 //                                                }
//                 //
//                 //                                            } withProgressBlock:nil];
//                 //
//                 //                                        }else{
//                 //
//                 ////                                            NSLog(@"TRY 2 ");
//                 //                                            KCSCollection *yookaObjects3 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
//                 //                                            KCSAppdataStore *store3 = [KCSAppdataStore storeWithCollection:yookaObjects3 options:nil];
//                 //
//                 //                                            KCSQuery* query8 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
//                 //                                            KCSQuery* query9 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"NAY"];
//                 //                                            //                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
//                 //                                            KCSQuery* query10 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query8,query9, nil];
//                 //
//                 //                                            [store3 queryWithQuery:query10 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//                 //                                                if (errorOrNil == nil) {
//                 //
//                 //                                                    _nayVote = [NSNumber numberWithInteger:objectsOrNil.count];
//                 ////                                                    NSLog(@"venue name = %@",dishName);
//                 ////                                                    NSLog(@"TRY 3 postVote = %@",_nayVote);
//                 ////                                                    NSLog(@"yay = %@",_yayVote);
//                 ////                                                    NSLog(@"nay = %@",_nayVote);
//                 //
//                 //                                                    CGFloat percent = [_yayVote floatValue]/([_yayVote doubleValue]+[_nayVote doubleValue]);
//                 ////                                                    NSLog(@"percentage = %f",percent);
//                 //
//                 //                                                    // Calculate this somehow
//                 //                                                    UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
//                 //                                                    barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
//                 //                                                    [button addSubview:barImage];
//                 //
//                 //                                                    UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
//                 //                                                    barPercentage.image = [UIImage imageNamed:@"100.png"];
//                 //                                                    [button addSubview:barPercentage];
//                 //
//                 //                                                    UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
//                 //                                                    voteLabel.textColor = [UIColor whiteColor];
//                 //                                                    [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
//                 //                                                    voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
//                 //                                                    voteLabel.textAlignment = NSTextAlignmentCenter;
//                 //                                                    voteLabel.adjustsFontSizeToFitWidth = NO;
//                 //                                                    [button addSubview:voteLabel];
//                 //
//                 //                                                    [_gridScrollView addSubview:button];
//                 //
//                 //                                                    i++;
//                 //                                                    [self loadImages];
//                 //
//                 //                                                }else{
//                 ////                                                    NSLog(@"TRY 4 ");
//                 //                                                    [_gridScrollView addSubview:button];
//                 //
//                 //                                                    i++;
//                 //                                                    [self loadImages];
//                 //                                                }
//                 //
//                 //                                            } withProgressBlock:nil];
//                 //                                        }
//                 //
//                 //                                    } withProgressBlock:nil];
//                 
//                 if ([post_vote isEqualToString:@"YAY"]) {
//                     CGFloat percent = 1.0;
//                     // Calculate this somehow
//                     UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
//                     barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
//                     [button addSubview:barImage];
//                     
//                     UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
//                     barPercentage.image = [UIImage imageNamed:@"100.png"];
//                     [button addSubview:barPercentage];
//                     
//                     UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
//                     voteLabel.textColor = [UIColor whiteColor];
//                     [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
//                     voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
//                     voteLabel.textAlignment = NSTextAlignmentCenter;
//                     voteLabel.adjustsFontSizeToFitWidth = NO;
//                     [button addSubview:voteLabel];
//                 }else{
//                     CGFloat percent = 0.0;
//                     // Calculate this somehow
//                     UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
//                     barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
//                     [button addSubview:barImage];
//                     
//                     UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
//                     barPercentage.image = [UIImage imageNamed:@"100.png"];
//                     [button addSubview:barPercentage];
//                     
//                     UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
//                     voteLabel.textColor = [UIColor whiteColor];
//                     [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
//                     voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
//                     voteLabel.textAlignment = NSTextAlignmentCenter;
//                     voteLabel.adjustsFontSizeToFitWidth = NO;
//                     [button addSubview:voteLabel];
//                 }
//                 //                                                    NSLog(@"percentage = %f",percent);
//                 
//                 [_gridScrollView addSubview:button];
//                 
//                 i++;
//                 if (i==_newsFeed.count) {
//                     [self loadImages2];
//                 }
//                 [self loadImages];
//                 
//             }else{
//                 
//                 NSLog(@"no cache");
        
                 [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:dishPicUrl]
                                                                     options:0
                                                                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
                  {
                      // progression tracking code
                  }
                                                                   completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                  {
                      if (image && finished)
                      {
                          NSLog(@"found image");
                          [[SDImageCache sharedImageCache] storeImage:image forKey:kinveyId];
                          NSLog(@"stored cache");
                          
                          
                          buttonImage.image = image;
                          [button addSubview:buttonImage];
                          
                          UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 290, 45)];
                          dishLabel.textColor = [UIColor whiteColor];
                          [dishLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:30]];
                          dishLabel.text = [dishName uppercaseString];
                          dishLabel.textAlignment = NSTextAlignmentLeft;
                          dishLabel.adjustsFontSizeToFitWidth = YES;
                          dishLabel.numberOfLines = 0;
                          [dishLabel sizeToFit];
                          dishLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
                          dishLabel.layer.shadowRadius = 1;
                          dishLabel.layer.shadowOpacity = 1;
                          dishLabel.layer.shadowOffset = CGSizeMake(2.0, 5.0);
                          dishLabel.layer.masksToBounds = NO;
                          [button addSubview:dishLabel];
                          
                          UILabel *venueLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 315, 155, 30)];
                          venueLabel.textColor = [UIColor orangeColor];
                          [venueLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:20]];
                          venueLabel.text = venueName;
                          venueLabel.textAlignment = NSTextAlignmentCenter;
                          venueLabel.adjustsFontSizeToFitWidth = YES;
                          [button addSubview:venueLabel];
                          
//                          UIButton *restaurant_button = [UIButton buttonWithType:UIButtonTypeCustom];
//                          [restaurant_button  setFrame:CGRectMake(100, 315, 155, 30)];
//                          [restaurant_button setBackgroundColor:[UIColor clearColor]];
//                          restaurant_button.tag = i;
//                          [restaurant_button addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
//                          [button addSubview:restaurant_button];
                          
                          UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 345, 90, 12)];
                          addressLabel.textColor = [UIColor lightGrayColor];
                          [addressLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
                          addressLabel.text = venueAddress;
                          addressLabel.textAlignment = NSTextAlignmentRight;
                          addressLabel.adjustsFontSizeToFitWidth = NO;
                          [button addSubview:addressLabel];
                          
                          NSDate *createddate = [_newsFeed[i] objectForKey:@"postDate"];
                          NSDate *now = [NSDate date];
                          NSString *str;
                          NSMutableString *myString = [NSMutableString string];
                          
                          NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createddate];
                          if (secondsBetween<60) {
                              int duration = secondsBetween;
                              str = [NSString stringWithFormat:@"%ds",duration]; //%d or %i both is ok.
                              [myString appendString:str];
                          }else if (secondsBetween<3600) {
                              int duration = secondsBetween / 60;
                              str = [NSString stringWithFormat:@"%dm",duration]; //%d or %i both is ok.
                              [myString appendString:str];
                          }else if (secondsBetween<86400){
                              int duration = secondsBetween / 3600;
                              str = [NSString stringWithFormat:@"%dh",duration]; //%d or %i both is ok.
                              [myString appendString:str];
                          }else if (secondsBetween<604800){
                              int duration = secondsBetween / 86400;
                              str = [NSString stringWithFormat:@"%dd",duration]; //%d or %i both is ok.
                              [myString appendString:str];
                          }else {
                              int duration = secondsBetween / 604800;
                              str = [NSString stringWithFormat:@"%dw",duration]; //%d or %i both is ok.
                              [myString appendString:str];
                          }
                          
                          UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(240, 330, 70, 12)];
                          time_label.text = [NSString stringWithFormat:@"%@",myString];
                          time_label.textColor = [UIColor grayColor];
                          [time_label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
                          time_label.textAlignment = NSTextAlignmentRight;
                          [button addSubview:time_label];
                          
                          UILabel *captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 370, 310, 18)];
                          captionLabel.textColor = [UIColor darkGrayColor];
                          [captionLabel setFont:[UIFont fontWithName:@"Helvetica-LightOblique" size:15]];
                          captionLabel.text = [NSString stringWithFormat:@"\"%@\"",caption];
                          captionLabel.textAlignment = NSTextAlignmentCenter;
                          captionLabel.adjustsFontSizeToFitWidth = YES;
                          [button addSubview:captionLabel];
                          
                          //                                    KCSCollection *yookaObjects2 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
                          //                                    KCSAppdataStore *store2 = [KCSAppdataStore storeWithCollection:yookaObjects2 options:nil];
                          //
                          //                                    KCSQuery* query4 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
                          //                                    KCSQuery* query5 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YAY"];
                          ////                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
                          //                                    KCSQuery* query7 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query4,query5, nil];
                          //
                          //                                    [store2 queryWithQuery:query7 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                          //                                        if (errorOrNil == nil) {
                          //
                          //                                            _yayVote = [NSNumber numberWithInteger:objectsOrNil.count];
                          ////                                            NSLog(@"TRY 1 postVote = %@",_yayVote);
                          //
                          //                                            KCSCollection *yookaObjects3 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
                          //                                            KCSAppdataStore *store3 = [KCSAppdataStore storeWithCollection:yookaObjects3 options:nil];
                          //
                          //                                            KCSQuery* query8 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
                          //                                            KCSQuery* query9 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"NAY"];
                          //                                            //                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
                          //                                            KCSQuery* query10 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query8,query9, nil];
                          //
                          //                                            [store3 queryWithQuery:query10 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                          //                                                if (errorOrNil == nil) {
                          //                                                    _nayVote = [NSNumber numberWithInteger:objectsOrNil.count];
                          ////                                                    NSLog(@"venue name = %@",dishName);
                          ////                                                    NSLog(@"TRY 3 postVote = %@",_nayVote);
                          ////                                                    NSLog(@"yay = %@",_yayVote);
                          ////                                                    NSLog(@"nay = %@",_nayVote);
                          //
                          //                                                    CGFloat percent = [_yayVote floatValue]/([_yayVote doubleValue]+[_nayVote doubleValue]);
                          ////                                                    NSLog(@"percentage = %f",percent);
                          //
                          //                                                    // Calculate this somehow
                          //                                                    UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
                          //                                                    barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
                          //                                                    [button addSubview:barImage];
                          //
                          //                                                    UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
                          //                                                    barPercentage.image = [UIImage imageNamed:@"100.png"];
                          //                                                    [button addSubview:barPercentage];
                          //
                          //                                                    UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
                          //                                                    voteLabel.textColor = [UIColor whiteColor];
                          //                                                    [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
                          //                                                    voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
                          //                                                    voteLabel.textAlignment = NSTextAlignmentCenter;
                          //                                                    voteLabel.adjustsFontSizeToFitWidth = NO;
                          //                                                    [button addSubview:voteLabel];
                          //
                          //                                                    [_gridScrollView addSubview:button];
                          //
                          //                                                    i++;
                          //                                                    [self loadImages];
                          //
                          //                                                }else{
                          ////                                                    NSLog(@"TRY 4 ");
                          //                                                    [_gridScrollView addSubview:button];
                          //
                          //                                                    i++;
                          //                                                    [self loadImages];
                          //                                                }
                          //
                          //                                            } withProgressBlock:nil];
                          //
                          //                                        }else{
                          //
                          ////                                            NSLog(@"TRY 2 ");
                          //                                            KCSCollection *yookaObjects3 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
                          //                                            KCSAppdataStore *store3 = [KCSAppdataStore storeWithCollection:yookaObjects3 options:nil];
                          //
                          //                                            KCSQuery* query8 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
                          //                                            KCSQuery* query9 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"NAY"];
                          //                                            //                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
                          //                                            KCSQuery* query10 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query8,query9, nil];
                          //
                          //                                            [store3 queryWithQuery:query10 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                          //                                                if (errorOrNil == nil) {
                          //
                          //                                                    _nayVote = [NSNumber numberWithInteger:objectsOrNil.count];
                          ////                                                    NSLog(@"venue name = %@",dishName);
                          ////                                                    NSLog(@"TRY 3 postVote = %@",_nayVote);
                          ////                                                    NSLog(@"yay = %@",_yayVote);
                          ////                                                    NSLog(@"nay = %@",_nayVote);
                          //
                          //                                                    CGFloat percent = [_yayVote floatValue]/([_yayVote doubleValue]+[_nayVote doubleValue]);
                          ////                                                    NSLog(@"percentage = %f",percent);
                          //
                          //                                                    // Calculate this somehow
                          //                                                    UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
                          //                                                    barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
                          //                                                    [button addSubview:barImage];
                          //
                          //                                                    UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
                          //                                                    barPercentage.image = [UIImage imageNamed:@"100.png"];
                          //                                                    [button addSubview:barPercentage];
                          //
                          //                                                    UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
                          //                                                    voteLabel.textColor = [UIColor whiteColor];
                          //                                                    [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
                          //                                                    voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
                          //                                                    voteLabel.textAlignment = NSTextAlignmentCenter;
                          //                                                    voteLabel.adjustsFontSizeToFitWidth = NO;
                          //                                                    [button addSubview:voteLabel];
                          //
                          //                                                    [_gridScrollView addSubview:button];
                          //
                          //                                                    i++;
                          //                                                    [self loadImages];
                          //
                          //                                                }else{
                          ////                                                    NSLog(@"TRY 4 ");
                          //                                                    [_gridScrollView addSubview:button];
                          //
                          //                                                    i++;
                          //                                                    [self loadImages];
                          //                                                }
                          //
                          //                                            } withProgressBlock:nil];
                          //                                        }
                          //
                          //                                    } withProgressBlock:nil];
                          
                          if ([post_vote isEqualToString:@"YAY"]) {
                              CGFloat percent = 1.0;
                              // Calculate this somehow
                              UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
                              barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
                              [button addSubview:barImage];
                              
                              UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
                              barPercentage.image = [UIImage imageNamed:@"100.png"];
                              [button addSubview:barPercentage];
                              
                              UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
                              voteLabel.textColor = [UIColor whiteColor];
                              [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
                              voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
                              voteLabel.textAlignment = NSTextAlignmentCenter;
                              voteLabel.adjustsFontSizeToFitWidth = NO;
                              [button addSubview:voteLabel];
                          }else{
                              CGFloat percent = 0.0;
                              // Calculate this somehow
                              UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
                              barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
                              [button addSubview:barImage];
                              
                              UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
                              barPercentage.image = [UIImage imageNamed:@"100.png"];
                              [button addSubview:barPercentage];
                              
                              UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
                              voteLabel.textColor = [UIColor whiteColor];
                              [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
                              voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
                              voteLabel.textAlignment = NSTextAlignmentCenter;
                              voteLabel.adjustsFontSizeToFitWidth = NO;
                              [button addSubview:voteLabel];
                          }
                          //                                                    NSLog(@"percentage = %f",percent);
                          
                          [_gridScrollView addSubview:button];
                          
                          i++;
                          
                          if (i==_newsFeed.count) {
                              [self loadImages2];
                          }
                          
                          [self loadImages];
                      }else{
                          i++;
                          
                          if (i==_newsFeed.count) {
                              [self loadImages2];
                          }
                          
                          [self loadImages];
                      }
                  }];
                 
//             }
//         }];
        
        
        
        //             }
        //         }];
        
        //        UIButton *button = [self.thumbnails objectAtIndex:i];
        //
        //        UIImageView *buttonImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 310, 310)];
        //        //                [buttonImage2 setBackgroundColor:[UIColor redColor]];
        //        buttonImage2.image = [UIImage imageNamed:@"YookaPostsBg.png"];
        //        [button addSubview:buttonImage2];
        //
        //        UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 304, 304)];
        //        [buttonImage setBackgroundColor:[UIColor clearColor]];
        //        buttonImage.contentMode = UIViewContentModeScaleAspectFill;
        //        buttonImage.clipsToBounds = YES;
        //        [button addSubview:buttonImage];
        //
        //        [buttonImage setImageWithURL:[NSURL URLWithString:dishPicUrl]
        //                       placeholderImage:nil
        //                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        //
        //                                  UIImageView *buttonImage3 = [[UIImageView alloc]initWithFrame:CGRectMake( 20, 260, 76, 78)];
        //                                  buttonImage3.image = [UIImage imageNamed:@"YookaProfilePicbg.png"];
        //                                  [button addSubview:buttonImage3];
        //
        //
        //                                  UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 290, 45)];
        //                                  dishLabel.textColor = [UIColor whiteColor];
        //                                  [dishLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:30]];
        //                                  dishLabel.text = [dishName uppercaseString];
        //                                  dishLabel.textAlignment = NSTextAlignmentLeft;
        //                                  dishLabel.adjustsFontSizeToFitWidth = YES;
        //                                  dishLabel.numberOfLines = 0;
        //                                  [dishLabel sizeToFit];
        //                                  dishLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        //                                  dishLabel.layer.shadowRadius = 1;
        //                                  dishLabel.layer.shadowOpacity = 1;
        //                                  dishLabel.layer.shadowOffset = CGSizeMake(2.0, 5.0);
        //                                  dishLabel.layer.masksToBounds = NO;
        //                                  [button addSubview:dishLabel];
        //
        //                                  UILabel *venueLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 315, 155, 30)];
        //                                  venueLabel.textColor = [UIColor orangeColor];
        //                                  [venueLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:20]];
        //                                  venueLabel.text = venueName;
        //                                  venueLabel.textAlignment = NSTextAlignmentCenter;
        //                                  venueLabel.adjustsFontSizeToFitWidth = YES;
        //                                  [button addSubview:venueLabel];
        //
        //                                  UIButton *restaurant_button = [UIButton buttonWithType:UIButtonTypeCustom];
        //                                  [restaurant_button  setFrame:CGRectMake(100, 315, 155, 30)];
        //                                  [restaurant_button setBackgroundColor:[UIColor clearColor]];
        //                                  restaurant_button.tag = i;
        //                                  [restaurant_button addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
        //                                  [button addSubview:restaurant_button];
        //
        //                                  UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 345, 90, 12)];
        //                                  addressLabel.textColor = [UIColor lightGrayColor];
        //                                  [addressLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        //                                  addressLabel.text = venueAddress;
        //                                  addressLabel.textAlignment = NSTextAlignmentRight;
        //                                  addressLabel.adjustsFontSizeToFitWidth = NO;
        //                                  [button addSubview:addressLabel];
        //
        //                                  NSDate *createddate = [_newsFeed[i] objectForKey:@"postDate"];
        //                                  NSDate *now = [NSDate date];
        //                                  NSString *str;
        //                                  NSMutableString *myString = [NSMutableString string];
        //
        //                                  NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createddate];
        //                                  if (secondsBetween<60) {
        //                                      int duration = secondsBetween;
        //                                      str = [NSString stringWithFormat:@"%ds",duration]; //%d or %i both is ok.
        //                                      [myString appendString:str];
        //                                  }else if (secondsBetween<3600) {
        //                                      int duration = secondsBetween / 60;
        //                                      str = [NSString stringWithFormat:@"%dm",duration]; //%d or %i both is ok.
        //                                      [myString appendString:str];
        //                                  }else if (secondsBetween<86400){
        //                                      int duration = secondsBetween / 3600;
        //                                      str = [NSString stringWithFormat:@"%dh",duration]; //%d or %i both is ok.
        //                                      [myString appendString:str];
        //                                  }else if (secondsBetween<604800){
        //                                      int duration = secondsBetween / 86400;
        //                                      str = [NSString stringWithFormat:@"%dd",duration]; //%d or %i both is ok.
        //                                      [myString appendString:str];
        //                                  }else {
        //                                      int duration = secondsBetween / 604800;
        //                                      str = [NSString stringWithFormat:@"%dw",duration]; //%d or %i both is ok.
        //                                      [myString appendString:str];
        //                                  }
        //
        //                                  UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(240, 330, 70, 12)];
        //                                  time_label.text = [NSString stringWithFormat:@"%@",myString];
        //                                  time_label.textColor = [UIColor grayColor];
        //                                  [time_label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
        //                                  time_label.textAlignment = NSTextAlignmentRight;
        //                                  [button addSubview:time_label];
        //
        //                                  UILabel *captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 370, 310, 18)];
        //                                  captionLabel.textColor = [UIColor darkGrayColor];
        //                                  [captionLabel setFont:[UIFont fontWithName:@"Helvetica-LightOblique" size:15]];
        //                                  captionLabel.text = [NSString stringWithFormat:@"\"%@\"",caption];
        //                                  captionLabel.textAlignment = NSTextAlignmentCenter;
        //                                  captionLabel.adjustsFontSizeToFitWidth = YES;
        //                                  [button addSubview:captionLabel];
        //
        //                                  //                                    KCSCollection *yookaObjects2 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
        //                                  //                                    KCSAppdataStore *store2 = [KCSAppdataStore storeWithCollection:yookaObjects2 options:nil];
        //                                  //
        //                                  //                                    KCSQuery* query4 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
        //                                  //                                    KCSQuery* query5 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YAY"];
        //                                  ////                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
        //                                  //                                    KCSQuery* query7 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query4,query5, nil];
        //                                  //
        //                                  //                                    [store2 queryWithQuery:query7 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        //                                  //                                        if (errorOrNil == nil) {
        //                                  //
        //                                  //                                            _yayVote = [NSNumber numberWithInteger:objectsOrNil.count];
        //                                  ////                                            NSLog(@"TRY 1 postVote = %@",_yayVote);
        //                                  //
        //                                  //                                            KCSCollection *yookaObjects3 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
        //                                  //                                            KCSAppdataStore *store3 = [KCSAppdataStore storeWithCollection:yookaObjects3 options:nil];
        //                                  //
        //                                  //                                            KCSQuery* query8 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
        //                                  //                                            KCSQuery* query9 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"NAY"];
        //                                  //                                            //                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
        //                                  //                                            KCSQuery* query10 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query8,query9, nil];
        //                                  //
        //                                  //                                            [store3 queryWithQuery:query10 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        //                                  //                                                if (errorOrNil == nil) {
        //                                  //                                                    _nayVote = [NSNumber numberWithInteger:objectsOrNil.count];
        //                                  ////                                                    NSLog(@"venue name = %@",dishName);
        //                                  ////                                                    NSLog(@"TRY 3 postVote = %@",_nayVote);
        //                                  ////                                                    NSLog(@"yay = %@",_yayVote);
        //                                  ////                                                    NSLog(@"nay = %@",_nayVote);
        //                                  //
        //                                  //                                                    CGFloat percent = [_yayVote floatValue]/([_yayVote doubleValue]+[_nayVote doubleValue]);
        //                                  ////                                                    NSLog(@"percentage = %f",percent);
        //                                  //
        //                                  //                                                    // Calculate this somehow
        //                                  //                                                    UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
        //                                  //                                                    barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
        //                                  //                                                    [button addSubview:barImage];
        //                                  //
        //                                  //                                                    UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
        //                                  //                                                    barPercentage.image = [UIImage imageNamed:@"100.png"];
        //                                  //                                                    [button addSubview:barPercentage];
        //                                  //
        //                                  //                                                    UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
        //                                  //                                                    voteLabel.textColor = [UIColor whiteColor];
        //                                  //                                                    [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
        //                                  //                                                    voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
        //                                  //                                                    voteLabel.textAlignment = NSTextAlignmentCenter;
        //                                  //                                                    voteLabel.adjustsFontSizeToFitWidth = NO;
        //                                  //                                                    [button addSubview:voteLabel];
        //                                  //
        //                                  //                                                    [_gridScrollView addSubview:button];
        //                                  //
        //                                  //                                                    i++;
        //                                  //                                                    [self loadImages];
        //                                  //
        //                                  //                                                }else{
        //                                  ////                                                    NSLog(@"TRY 4 ");
        //                                  //                                                    [_gridScrollView addSubview:button];
        //                                  //
        //                                  //                                                    i++;
        //                                  //                                                    [self loadImages];
        //                                  //                                                }
        //                                  //
        //                                  //                                            } withProgressBlock:nil];
        //                                  //
        //                                  //                                        }else{
        //                                  //
        //                                  ////                                            NSLog(@"TRY 2 ");
        //                                  //                                            KCSCollection *yookaObjects3 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
        //                                  //                                            KCSAppdataStore *store3 = [KCSAppdataStore storeWithCollection:yookaObjects3 options:nil];
        //                                  //
        //                                  //                                            KCSQuery* query8 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
        //                                  //                                            KCSQuery* query9 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"NAY"];
        //                                  //                                            //                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
        //                                  //                                            KCSQuery* query10 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query8,query9, nil];
        //                                  //
        //                                  //                                            [store3 queryWithQuery:query10 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        //                                  //                                                if (errorOrNil == nil) {
        //                                  //
        //                                  //                                                    _nayVote = [NSNumber numberWithInteger:objectsOrNil.count];
        //                                  ////                                                    NSLog(@"venue name = %@",dishName);
        //                                  ////                                                    NSLog(@"TRY 3 postVote = %@",_nayVote);
        //                                  ////                                                    NSLog(@"yay = %@",_yayVote);
        //                                  ////                                                    NSLog(@"nay = %@",_nayVote);
        //                                  //
        //                                  //                                                    CGFloat percent = [_yayVote floatValue]/([_yayVote doubleValue]+[_nayVote doubleValue]);
        //                                  ////                                                    NSLog(@"percentage = %f",percent);
        //                                  //
        //                                  //                                                    // Calculate this somehow
        //                                  //                                                    UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
        //                                  //                                                    barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
        //                                  //                                                    [button addSubview:barImage];
        //                                  //
        //                                  //                                                    UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
        //                                  //                                                    barPercentage.image = [UIImage imageNamed:@"100.png"];
        //                                  //                                                    [button addSubview:barPercentage];
        //                                  //
        //                                  //                                                    UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
        //                                  //                                                    voteLabel.textColor = [UIColor whiteColor];
        //                                  //                                                    [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
        //                                  //                                                    voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
        //                                  //                                                    voteLabel.textAlignment = NSTextAlignmentCenter;
        //                                  //                                                    voteLabel.adjustsFontSizeToFitWidth = NO;
        //                                  //                                                    [button addSubview:voteLabel];
        //                                  //
        //                                  //                                                    [_gridScrollView addSubview:button];
        //                                  //
        //                                  //                                                    i++;
        //                                  //                                                    [self loadImages];
        //                                  //
        //                                  //                                                }else{
        //                                  ////                                                    NSLog(@"TRY 4 ");
        //                                  //                                                    [_gridScrollView addSubview:button];
        //                                  //
        //                                  //                                                    i++;
        //                                  //                                                    [self loadImages];
        //                                  //                                                }
        //                                  //
        //                                  //                                            } withProgressBlock:nil];
        //                                  //                                        }
        //                                  //
        //                                  //                                    } withProgressBlock:nil];
        //
        //                                  if ([post_vote isEqualToString:@"YAY"]) {
        //                                      CGFloat percent = 1.0;
        //                                      // Calculate this somehow
        //                                      UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
        //                                      barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
        //                                      [button addSubview:barImage];
        //
        //                                      UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
        //                                      barPercentage.image = [UIImage imageNamed:@"100.png"];
        //                                      [button addSubview:barPercentage];
        //
        //                                      UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
        //                                      voteLabel.textColor = [UIColor whiteColor];
        //                                      [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
        //                                      voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
        //                                      voteLabel.textAlignment = NSTextAlignmentCenter;
        //                                      voteLabel.adjustsFontSizeToFitWidth = NO;
        //                                      [button addSubview:voteLabel];
        //                                  }else{
        //                                      CGFloat percent = 0.0;
        //                                      // Calculate this somehow
        //                                      UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
        //                                      barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
        //                                      [button addSubview:barImage];
        //
        //                                      UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
        //                                      barPercentage.image = [UIImage imageNamed:@"100.png"];
        //                                      [button addSubview:barPercentage];
        //
        //                                      UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
        //                                      voteLabel.textColor = [UIColor whiteColor];
        //                                      [voteLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
        //                                      voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
        //                                      voteLabel.textAlignment = NSTextAlignmentCenter;
        //                                      voteLabel.adjustsFontSizeToFitWidth = NO;
        //                                      [button addSubview:voteLabel];
        //                                  }
        //                                  //                                                    NSLog(@"percentage = %f",percent);
        //
        //                                  [_gridScrollView addSubview:button];
        //
        //
        //                                  if (i==1) {
        //                                      [self loadImages2];
        //                                  }
        //
        //                                  i++;
        //                                  [self loadImages];
        //
        //                              }];
        
    }
    
    
}

- (void)loadImages2
{
    //    NSLog(@"load images");
    if (j<_newsFeed.count && self.working==YES) {
        //        NSLog(@"hahahah");
        //        NSString *dishPicUrl = [[_newsFeed[i] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
        
        UIButton* button = [self.thumbnails objectAtIndex:j];
        //        KCSQuery* query = [KCSQuery query];
        //        KCSQuery* query = [KCSQuery queryOnField:@"location" withExactMatchForValue:@"Mike's House"];
        //        [query addSortModifier:sortByDate]; //sort the return by the date field
        //        [query setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:10]]; //just get back 10 results
        
        NSString *userId = [_newsFeed[j] objectForKey:@"userEmail"];
        NSLog(@"hahahaha = %@",userId);
        //                NSString *dishName = [_newsFeed[j] objectForKey:@"dishName"];
        //                NSString *venueName = [_newsFeed[j] objectForKey:@"venueName"];
        //                NSString *venueAddress = [_newsFeed[j] objectForKey:@"venueAddress"];
        //                NSString *caption = [_newsFeed[j] objectForKey:@"caption"];
        //                NSString *kinveyId = [_newsFeed[j] objectForKey:@"_id"];
        //                NSString *post_vote = [_newsFeed[j] objectForKey:@"postVote"];
        
//        [[SDImageCache sharedImageCache] queryDiskCacheForKey:userId done:^(UIImage *image, SDImageCacheType cacheType)
//         {
//             if(image){
//                 NSLog(@"found cache");
//                 
//                 UIImageView *buttonImage3 = [[UIImageView alloc]initWithFrame:CGRectMake( 20, 260, 76, 78)];
//                 buttonImage3.image = [UIImage imageNamed:@"YookaProfilePicbg.png"];
//                 [button addSubview:buttonImage3];
//                 
//                 UIImageView *buttonImage4 = [[UIImageView alloc]initWithFrame:CGRectMake( 24, 264, 66, 68)];
//                 buttonImage4.layer.cornerRadius = 5.f;
//                 [buttonImage4 setContentMode:UIViewContentModeScaleAspectFill];
//                 buttonImage4.clipsToBounds = YES;
//                 buttonImage4.image = nil;
//                 buttonImage4.opaque = YES;
//                 
//                 buttonImage4.image = image;
//                 [button addSubview:buttonImage4];
//                 
//                 UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
//                 [user_button  setFrame:CGRectMake(20, 260, 76, 78)];
//                 [user_button setBackgroundColor:[UIColor clearColor]];
//                 user_button.tag = j;
//                 [user_button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
//                 [button addSubview:user_button];
//                 
//                 NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                 NSString *userFullName = [ud objectForKey:userId];
//                 
//                 if (userFullName) {
//                     UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 340, 100, 30)];
//                     userLabel.textColor = [UIColor blackColor];
//                     userLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
//                     NSArray* firstLastStrings = [userFullName componentsSeparatedByString:@" "];
//                     NSString *firstName = [firstLastStrings objectAtIndex:0];
//                     if (firstLastStrings.count>1) {
//                         NSString *lastName =[firstLastStrings objectAtIndex:1];
//                         userLabel.text = [NSString stringWithFormat:@"%@\n%@",firstName,lastName];
//                         
//                     }else{
//                         userLabel.text = [NSString stringWithFormat:@"%@",firstName];
//                         
//                     }
//                     userLabel.textAlignment = NSTextAlignmentCenter;
//                     userLabel.adjustsFontSizeToFitWidth = YES;
//                     userLabel.numberOfLines = 0;
//                     [button addSubview:userLabel];
//                 }
//                 [_gridScrollView addSubview:button];
//                 
//                 j++;
//                 if (j == _newsFeed.count) {
//                     
//                     [self loadlikes];
//                 }
//                 
//                 [self loadImages2];
//                 
//             }else{
                 NSLog(@"no cache");
                 _collectionName2 = @"userPicture";
                 _customEndpoint2 = @"NewsFeed";
                 _fieldName2 = @"_id";
                 _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"userEmail",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
                 
                 //        [[button subviews]
                 //         makeObjectsPerformSelector:@selector(removeFromSuperview)];
                 
                 [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
                     if ([results isKindOfClass:[NSArray class]]) {
                         NSArray *results_array = [NSArray arrayWithArray:results];
                         if (results_array && results_array.count) {
                             //                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                             NSString *userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                             [_userPicUrls addObject:userPicUrl];
                             NSString *userFullName = [results[0] objectForKey:@"userFullName"];
                             [_userNames addObject:userFullName];
                             
                             if (userPicUrl) {
                                 
                                 //                                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                                 //                                [manager downloadWithURL:[NSURL URLWithString:userPicUrl]
                                 //
                                 //                                                 options:0
                                 //                                                progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                 //                                 {
                                 //                                     // progression tracking code
                                 //                                 }
                                 //                                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                                 //                                 {
                                 //                                     if (image)
                                 //                                     {
                                 // do something with image
                                 UIImageView *buttonImage4 = [[UIImageView alloc]initWithFrame:CGRectMake( 24, 264, 66, 68)];
                                 buttonImage4.layer.cornerRadius = 5.f;
                                 [buttonImage4 setContentMode:UIViewContentModeScaleAspectFill];
                                 buttonImage4.clipsToBounds = YES;
                                 buttonImage4.image = nil;
                                 buttonImage4.opaque = YES;
                                 [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:userPicUrl]
                                                                                     options:0
                                                                                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                  {
                                      // progression tracking code
                                  }
                                                                                   completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                                  {
                                      if (image && finished)
                                      {
                                          NSLog(@"found image");
                                          [[SDImageCache sharedImageCache] storeImage:image forKey:userId];
                                          NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                          [ud setObject:userFullName forKey:userId];
                                          NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
                                          [ud setObject:userPicUrl forKey:userId2];
                                          [ud synchronize];
                                          NSLog(@"stored cache");
                                          //                                     }else{
                                          //                                         NSLog(@"no image");
                                          //                                     }
                                          
                                          buttonImage4.image = image;
                                          [button addSubview:buttonImage4];
                                          
                                          UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                          [user_button  setFrame:CGRectMake(20, 260, 76, 78)];
                                          [user_button setBackgroundColor:[UIColor clearColor]];
                                          user_button.tag = j;
                                          [user_button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
                                          [button addSubview:user_button];
                                          
                                          UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 340, 100, 30)];
                                          userLabel.textColor = [UIColor blackColor];
                                          userLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
                                          NSArray* firstLastStrings = [userFullName componentsSeparatedByString:@" "];
                                          NSString *firstName = [firstLastStrings objectAtIndex:0];
                                          if (firstLastStrings.count>1) {
                                              NSString *lastName =[firstLastStrings objectAtIndex:1];
                                              userLabel.text = [NSString stringWithFormat:@"%@\n%@",firstName,lastName];
                                              
                                          }else{
                                              userLabel.text = [NSString stringWithFormat:@"%@",firstName];
                                              
                                          }
                                          userLabel.textAlignment = NSTextAlignmentCenter;
                                          userLabel.adjustsFontSizeToFitWidth = YES;
                                          userLabel.numberOfLines = 0;
                                          [button addSubview:userLabel];
                                          
                                          [_gridScrollView addSubview:button];
                                          
                                          j++;
                                          if (j == _newsFeed.count) {
                                              
                                              [self loadlikes];
                                          }
                                          
                                          [self loadImages2];
                                      }else{
                                          j++;
                                          if (j == _newsFeed.count) {
                                              
                                              [self loadlikes];
                                          }
                                          
                                          [self loadImages2];
                                      }
                                      
                                  }];
                                 
                                 //                                     }
                                 //                                 }];
                                 
                             }else{
                                 
                                 //                        NSLog(@"fail 3");
                                 j++;
                                 if (j == _newsFeed.count) {
                                     
                                     [self loadlikes];
                                     
                                     //                                    [self stopActivityIndicator];
                                     //        NSLog(@"user pic url = %@",_userPicUrls);
                                     
                                 }
                                 
                                 [self loadImages2];
                                 
                             }
                             
                             
                         }else{
                             //                    NSLog(@"fail 1");
                             j++;
                             if (j == _newsFeed.count) {
                                 
                                 [self loadlikes];
                                 
                                 //                                [self stopActivityIndicator];
                                 //        NSLog(@"user pic url = %@",_userPicUrls);
                                 
                             }
                             
                             [self loadImages2];
                         }
                         
                     }else{
                         //                NSLog(@"fail 2");
                         j++;
                         if (j == _newsFeed.count) {
                             
                             [self loadlikes];
                             
                             //                            [self stopActivityIndicator];
                             //        NSLog(@"user pic url = %@",_userPicUrls);
                             
                         }
                         
                         [self loadImages2];
                     }
                 }];
                 
//             }
//         }];
        
    }
    
}

- (void)loadlikes
{
    if(k<_newsFeed.count && self.working==YES){
        
        //        YookaBackend *yooka4 = _newsFeed[k];
        
        NSString *kinveyId = [_newsFeed[k] objectForKey:@"_id"];
        //        NSLog(@"kinveyId = %@",kinveyId);
        
        UIButton* button = [self.thumbnails objectAtIndex:k];
        
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        [store loadObjectWithID:kinveyId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                if (objectsOrNil && objectsOrNil.count) {
                    
                    YookaBackend *backendObject = objectsOrNil[0];
                    NSMutableArray *myArray = [NSMutableArray arrayWithArray:backendObject.likers];
                    _likes = backendObject.likes;
                    
                    
                    
                    if ([_likes integerValue]>0) {
                        
                        [_likesData addObject:_likes];
                        [_likersData addObject:myArray];
                        
                        if([myArray containsObject:_userEmail]){
                            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
                            likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
                            [button addSubview:likesImageView];
                            
                            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
                            likesLabel.textColor = [UIColor whiteColor];
                            [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
                            likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                            likesLabel.textAlignment = NSTextAlignmentCenter;
                            likesLabel.adjustsFontSizeToFitWidth = YES;
                            [likesImageView addSubview:likesLabel];
                            
                            UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                            [like_button  setFrame:CGRectMake(255, 260, 50, 45)];
                            [like_button setBackgroundColor:[UIColor clearColor]];
                            like_button.tag = k;
                            [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                            [button addSubview:like_button];
                            k++;
                            if (k==_newsFeed.count) {
                                [self stopActivityIndicator];
                            }
                            [self loadlikes];
                            
                            
                            
                        }else{
                            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
                            likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                            [button addSubview:likesImageView];
                            
                            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
                            likesLabel.textColor = [UIColor orangeColor];
                            [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
                            likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                            likesLabel.textAlignment = NSTextAlignmentCenter;
                            likesLabel.adjustsFontSizeToFitWidth = YES;
                            [likesImageView addSubview:likesLabel];
                            [_likesData addObject:@"0"];
                            [_likersData addObject:[NSNull null]];
                            
                            UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                            [like_button  setFrame:CGRectMake(255, 260, 50, 45)];
                            [like_button setBackgroundColor:[UIColor clearColor]];
                            like_button.tag = k;
                            [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                            [button addSubview:like_button];
                            k++;
                            if (k==_newsFeed.count) {
                                [self stopActivityIndicator];
                            }
                            [self loadlikes];
                            
                            
                        }
                        
                    }else{
                        
                        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
                        likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                        [button addSubview:likesImageView];
                        
                        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
                        likesLabel.textColor = [UIColor orangeColor];
                        [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
                        likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                        likesLabel.textAlignment = NSTextAlignmentCenter;
                        likesLabel.adjustsFontSizeToFitWidth = YES;
                        [likesImageView addSubview:likesLabel];
                        [_likesData addObject:@"0"];
                        [_likersData addObject:[NSNull null]];
                        
                        UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                        [like_button  setFrame:CGRectMake(255, 260, 50, 45)];
                        [like_button setBackgroundColor:[UIColor clearColor]];
                        like_button.tag = k;
                        [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                        [button addSubview:like_button];
                        k++;
                        if (k==_newsFeed.count) {
                            [self stopActivityIndicator];
                        }
                        [self loadlikes];
                        
                        
                    }
                    
                    //                                                NSLog(@"successful reload: %@", backendObject.likers); // event updated
                    //                                                NSLog(@"successful reload: %@", backendObject.likes); // event updated
                    
                }else{
                    
                    _likes = @"0";
                    [_likesData addObject:_likes];
                    [_likersData addObject:[NSNull null]];
                    
                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
                    likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                    [button addSubview:likesImageView];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
                    likesLabel.textColor = [UIColor orangeColor];
                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
                    likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                    likesLabel.textAlignment = NSTextAlignmentCenter;
                    likesLabel.adjustsFontSizeToFitWidth = YES;
                    [likesImageView addSubview:likesLabel];
                    
                    UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [like_button  setFrame:CGRectMake(255, 260, 50, 45)];
                    [like_button setBackgroundColor:[UIColor clearColor]];
                    like_button.tag = k;
                    [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                    [button addSubview:like_button];
                    k++;
                    if (k==_newsFeed.count) {
                        [self stopActivityIndicator];
                    }
                    [self loadlikes];
                    
                }
                
            } else {
                
                //                                            NSLog(@"error occurred: %@", errorOrNil);
                _likes = @"0";
                [_likesData addObject:_likes];
                [_likersData addObject:[NSNull null]];
                
                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
                likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                [button addSubview:likesImageView];
                
                UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
                likesLabel.textColor = [UIColor orangeColor];
                [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
                likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                likesLabel.textAlignment = NSTextAlignmentCenter;
                likesLabel.adjustsFontSizeToFitWidth = YES;
                [likesImageView addSubview:likesLabel];
                
                UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                [like_button  setFrame:CGRectMake(255, 260, 50, 45)];
                [like_button setBackgroundColor:[UIColor clearColor]];
                like_button.tag = k;
                [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                [button addSubview:like_button];
                k++;
                if (k==_newsFeed.count) {
                    [self stopActivityIndicator];
                }
                [self loadlikes];
                
            }
        } withProgressBlock:nil];
        
    }
    
}


- (void)hoursbuttonAction:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@"Open Hours"
                                message:_openHours
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)buttonAction2:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    //        NSLog(@"button %lu pressed",(unsigned long)b);
    BDViewController2 *media = [[BDViewController2 alloc]init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationItem setBackBarButtonItem: backBtn];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userId = [_newsFeed[b] objectForKey:@"userEmail"];
    NSString *userFullName = [ud objectForKey:userId];
    NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
    NSString *userPicUrl = [ud objectForKey:userId2];
    media.userFullName = userFullName;
    media.userEmail = userId;
    media.userPicUrl = userPicUrl;
    //    NSLog(@"userpicurl = %@",_userEmails[b]);
    
    [self.navigationController pushViewController:media animated:YES];
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
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                            reuseIdentifier:SFAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            

                UIImage *flagImage = [UIImage imageNamed:@"pin.png"];
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
                
                annotationView.image = resizedImage;
                annotationView.opaque = NO;
                
                //            UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
                //            annotationView.leftCalloutAccessoryView = sfIconView;
                
//                UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 22, 22)];
//                tagLabel.textColor = [UIColor blackColor];
//                tagLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:18.0];
//                tagLabel.textAlignment = NSTextAlignmentCenter;
//                tagLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[_mapAnnotations indexOfObject:annotation]+1];
//                [annotationView addSubview:tagLabel];
            
            // offset the flag annotation so that the flag pole rests on the map coordinate
            annotationView.centerOffset = CGPointMake( annotationView.centerOffset.x + annotationView.image.size.width/2, annotationView.centerOffset.y - annotationView.image.size.height/2 );
            
            return annotationView;
        }
        else
        {
            flagAnnotationView.annotation = annotation;
            //            SFAnnotation *myAnn = (SFAnnotation *)annotation;
            
            //            NSLog(@"tag = %@",myAnn.tag);
        }
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
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.85; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.85; // Add a little extra space on the sides
    
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

- (void)getRestaurantDetails
{

    [Foursquare2 venueGetDetail:_venueId callback:^(BOOL success, id result){
        
        if (success) {
            NSDictionary *dic = result;
            //            NSLog(@"venue data 1 = %@", dic);
            //            NSLog(@"venue data 1 = %@",[dic valueForKeyPath:@"response.venue.hours.timeframes.open.renderedTime"]);
            
            //            NSLog(@"venue data 2 = %@",[dic valueForKeyPath:@"response.venue.location.address"]);
            _venueAddress = [dic valueForKeyPath:@"response.venue.location.address"];
            //            NSLog(@"venue data 3 = %@",[dic valueForKeyPath:@"response.venue.location.cc"]);
            _venueCc = [dic valueForKeyPath:@"response.venue.location.cc"];
            //            NSLog(@"venue data 4 = %@",[dic valueForKeyPath:@"response.venue.location.city"]);
            _venueCity = [dic valueForKeyPath:@"response.venue.location.city"];
            //            NSLog(@"venue data 5 = %@",[dic valueForKeyPath:@"response.venue.location.country"]);
            _venueCountry = [dic valueForKeyPath:@"response.venue.location.country"];
            //            NSLog(@"venue data 6 = %@",[dic valueForKeyPath:@"response.venue.location.crossStreet"]);
            
            //            NSLog(@"venue data 7 = %@",[dic valueForKeyPath:@"response.venue.location.lat"]);
            //            _latitude = [dic valueForKeyPath:@"response.venue.location.lat"];
            //            NSLog(@"venue data 8 = %@",[dic valueForKeyPath:@"response.venue.location.lng"]);
            //            _longitude = [dic valueForKeyPath:@"response.venue.location.lng"];
            //            NSLog(@"venue data 9 = %@",[dic valueForKeyPath:@"response.venue.location.postalCode"]);
            _venuePostalCode = [dic valueForKeyPath:@"response.venue.location.postalCode"];
            //            NSLog(@"venue data 10 = %@",[dic valueForKeyPath:@"response.venue.location.state"]);
            _venueState = [dic valueForKeyPath:@"response.venue.location.state"];
            
            //            NSString *menus = [dic valueForKeyPath:@"response.menu.menus.count"];
            //            NSLog(@"venue data 2 = %@",menus);
            //            NSLog(@"venue data 10 = %@",[dic valueForKeyPath:@"response.venue.location"]);
            _phoneLabel = [dic valueForKeyPath:@"response.venue.contact.formattedPhone"];
            _latitude = [NSString stringWithFormat:@"%@",[dic valueForKeyPath:@"response.venue.location.lat"]];
            _longitude = [NSString stringWithFormat:@"%@",[dic valueForKeyPath:@"response.venue.location.lng"]];
            
            _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
            //Always center the dot and zoom in to an apropriate zoom level when position changes
            //        [_mapView setUserTrackingMode:MKUserTrackingModeFollow];
            _mapView.delegate = self;
            
            // set Span
            // start off by default in San Francisco
            MKCoordinateRegion newRegion;
            newRegion.center.latitude = [_latitude doubleValue];
            newRegion.center.longitude = [_longitude doubleValue];
            //        NSLog(@"%f",_currentLocation.coordinate.latitude);
            //        NSLog(@"%f",_currentLocation.coordinate.longitude);
            //    newRegion.center.latitude = [_latitude doubleValue];
            //    newRegion.center.longitude = [_longitude doubleValue];
            newRegion.span.latitudeDelta = 0.00312872;
            newRegion.span.longitudeDelta = 0.00309863;
            
            [self.mapView setRegion:newRegion animated:YES];
            [self.mapView setShowsUserLocation:NO];
            [self.gridScrollView addSubview:_mapView];
            
            [self addAnnotation];
            
            self.whiteBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 125, 320, 75)];
            self.whiteBg.image = [UIImage imageNamed:@"White_transulentback.png"];
            [self.gridScrollView addSubview:self.whiteBg];
            
            _phoneLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(110, 222, 100, 21)];
            _phoneLabel2.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
            _phoneLabel2.textAlignment = NSTextAlignmentLeft;
            _phoneLabel2.text = @"Telephone:";
            _phoneLabel2.textColor = [UIColor colorFromHexCode:@"3d3d3d"];
            [self.gridScrollView addSubview:_phoneLabel2];
            
            _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 265, 210, 21)];
            _priceLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
            _priceLabel.textAlignment = NSTextAlignmentLeft;
            _priceLabel.text = @"Price:            $3.00 - $105.00";
            _priceLabel.textColor = [UIColor colorFromHexCode:@"3d3d3d"];
            [self.gridScrollView addSubview:_priceLabel];
            
            _hoursLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 245, 210, 21)];
            _hoursLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:15.0];
            _hoursLabel.textAlignment = NSTextAlignmentLeft;
            _hoursLabel.text = @"Hours:    10:00AM - 11:00PM";
            _hoursLabel.textColor = [UIColor colorFromHexCode:@"3d3d3d"];
            [self.gridScrollView addSubview:_hoursLabel];
            
            //    self.hoursButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //    [self.hoursButton  setFrame:CGRectMake(110, 265, 52, 21)];
            //    [self.hoursButton setBackgroundColor:[UIColor redColor]];
            //    [self.hoursButton addTarget:self action:@selector(hoursbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.gridScrollView addSubview:self.hoursButton];
            
            self.restaurantNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 10, 295, 15)];
            _restaurantNameLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:16.0];
            _restaurantNameLabel.textAlignment = NSTextAlignmentLeft;
            _restaurantNameLabel.textColor = [UIColor colorFromHexCode:@"ff7e00"];
            _restaurantNameLabel.text = [_selectedRestaurantName uppercaseString];
            _restaurantNameLabel.adjustsFontSizeToFitWidth = YES;
            [self.whiteBg addSubview:_restaurantNameLabel];
            
            //            UIImageView *restaurantImageBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 310, 320, 300)];
            //            [restaurantImageBg setBackgroundColor:[UIColor darkGrayColor]];
            //            [self.gridScrollView addSubview:restaurantImageBg];
            
            self.phoneCallButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.phoneCallButton  setFrame:CGRectMake(190, 220, 120, 25)];
            [self.phoneCallButton setBackgroundColor:[UIColor clearColor]];
            [self.phoneCallButton setBackgroundImage:[[UIImage imageNamed:@"telephoneback.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.phoneCallButton addTarget:self action:@selector(phoneCallAction) forControlEvents:UIControlEventTouchUpInside];
            [self.phoneCallButton setTitle:[dic valueForKeyPath:@"response.venue.contact.formattedPhone"] forState:UIControlStateNormal];
            self.phoneCallButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
            [self.gridScrollView addSubview:self.phoneCallButton];
            
            self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 27, 220, 39)];
            self.addressLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16.0];
            self.addressLabel.textAlignment = NSTextAlignmentLeft;
            self.addressLabel.text = [NSString stringWithFormat:@"%@\n%@",_venueAddress,_venueCity];
            self.addressLabel.textColor = [UIColor colorFromHexCode:@"3d3d3d"];
            self.addressLabel.adjustsFontSizeToFitWidth = YES;
            self.addressLabel.numberOfLines = 0;
            [self.whiteBg addSubview:_addressLabel];
            
            self.menuButton= [UIButton buttonWithType:UIButtonTypeCustom];
            [self.menuButton  setFrame:CGRectMake(13, 220, 80, 80)];
            [self.menuButton setBackgroundColor:[UIColor clearColor]];
            [self.menuButton setBackgroundImage:[[UIImage imageNamed:@"menu-button.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.menuButton addTarget:self action:@selector(gotoMenu) forControlEvents:UIControlEventTouchUpInside];
            [self.menuButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:18]];
            self.menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.menuButton setTitle:@"MENU" forState:UIControlStateNormal];
            [self.gridScrollView addSubview:self.menuButton];
            
            
        }
        
    }];
    
    
}

- (void)gotoMenu
{
//    YookaBackend *yooka = _yookaObjects[0];
    YookaMenu2ViewController *media = [[YookaMenu2ViewController alloc]init];
//    NSLog(@"venue name = %@",yooka.name);
//    NSLog(@"hunt name = %@",_huntTitle);
    media.venueID = _venueId;
    media.venueAddress = _venueAddress;
    media.venueCc = _venueCc;
    media.venueCity = _venueCity;
    media.venueCountry = _venueCountry;
    media.venueState = _venueState;
    media.venuePostalCode = _venuePostalCode;
    media.venueSelected = _selectedRestaurantName;
    media.huntName = _huntTitle;
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationItem setBackBarButtonItem: backBtn];
    [self.navigationController pushViewController:media animated:YES];
}

- (void)backAction
{
    
}

- (void)addAnnotation
{
    self.mapAnnotations = [[NSMutableArray alloc] init];
    
    
        NSString *lat = _latitude;
        NSString *lon = _longitude;
        NSString *pinTitle = _selectedRestaurantName;
//        NSLog(@"lat = %@, lon = %@, rest = %@",lat,lon,pinTitle);
    SFAnnotation *item1 = [[SFAnnotation alloc] init];
    item1.latitude = lat;
    item1.longitude = lon;
    item1.pinTitle = pinTitle;
    
        [self.mapAnnotations insertObject:item1 atIndex:0];
    
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    [self.mapView addAnnotations:self.mapAnnotations];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    NSUserDefaults * myNSUserDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary * dict = [myNSUserDefaults dictionaryRepresentation];
    for (id key in dict) {
        
        //heck the keys if u need
        [myNSUserDefaults removeObjectForKey:key];
    }
    [myNSUserDefaults synchronize];
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
