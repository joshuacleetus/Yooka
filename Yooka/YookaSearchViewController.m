//
//  YookaSearchViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 12/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaSearchViewController.h"
#import "YookaViewController.h"
#import "YookaAppDelegate.h"
#import "UserFollowingViewController.h"
#import "UserFollowersViewController.h"
#import "BDViewController2.h"
#import <AsyncImageDownloader.h>
#import "YookaBackend.h"
#import <Reachability.h>
#import "UIImageView+WebCache.h"
#import "Foursquare2.h"
#import "FSQView/FSVenue.h"
#import "FSQView/FSConverter.h"
#import "YookaHuntRestaurantViewController.h"
#import "YookaRestaurantViewController.h"
#import "YookaClickProfileViewController.h"
#import "MainViewController.h"
#import "YookaProfileNewViewController.h"
#import "YookaClickProfileViewController.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)
@interface YookaSearchViewController ()

@end

@implementation YookaSearchViewController

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
    
    self.peopleArray = [NSMutableArray new];

    // Do any additional setup after loading the view.

    j=0;
    k=0;
    
    NSArray *tips;
    tips = [NSArray arrayWithObjects:
            @"10",
            @"20",
            @"270",
            @"240",
            @"50",
            @"280",
            @"70",
            @"80",
            @"90",
            @"100",
            @"290",
            @"120",
            @"130",
            @"140",
            @"210",
            @"160",
            @"170",
            @"180",
            @"190",
            @"200",
            nil];
    NSUInteger randomIndex = arc4random() % [tips count];
    
    _tryl = [tips objectAtIndex:randomIndex];
    [self Load100Users];
    
    UIColor * color2 = [UIColor colorWithRed:244/255.0f green:243/255.0f blue:243/255.0f alpha:1.0f];
    [self.view setBackgroundColor:color2];

    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    _userFollowingPicture = [NSMutableArray new];
    _userEmail = [KCSUser activeUser].username;
    _firstName = [KCSUser activeUser].givenName;
    _lastName = [KCSUser activeUser].surname;
    _userFullName = [NSString stringWithFormat:@"%@ %@",_firstName,_lastName];
//    NSLog(@"%@ %@ %@ %@",_userEmail,_firstName,_lastName,_userFullName);
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationItem setTitle:@"Users"];
    
    UIImageView *whitebg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    whitebg.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:whitebg];
    
    UIImageView *topBgImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 60, 280, 40)];
    //    topBgImage.image = [UIImage imageNamed:@"search_bar_new.png"];
    [topBgImage setBackgroundColor:[UIColor whiteColor]];
   // [self.view addSubview:topBgImage];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, 280, 40)];
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.font = [UIFont fontWithName:@"OpenSans-Regular" size:16];
    _textField.textColor = [UIColor lightGrayColor];
    UIColor *color1 = [UIColor lightGrayColor];
    self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"SEARCH" attributes:@{NSForegroundColorAttributeName: color1}];
//    UIColor * color3 = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textField addTarget:self
                   action:@selector(textFieldDone:)
         forControlEvents:UIControlEventEditingDidEndOnExit];
    [_textField addTarget:self action:@selector(keyboardAppeared:) forControlEvents:UIControlEventEditingDidBegin];
    [self.view addSubview:_textField];
    
    UIImageView *fb_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 53, 20, 20)];
    fb_icon.image = [UIImage imageNamed:@"facebook-icon.png"];
    [self.view addSubview:fb_icon];
    
    UILabel *fbLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 53, 250, 20)];
    fbLabel.textColor = [UIColor lightGrayColor];
    fbLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:15.0];
    fbLabel.text = @"INVITE FACEBOOK FRIENDS";
    fbLabel.textAlignment = NSTextAlignmentLeft;
    fbLabel.backgroundColor =[UIColor whiteColor];
    [self.view addSubview:fbLabel];
    
    UIButton *fbButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fbButton setFrame:CGRectMake(0, 40, 320, 50)];
    [fbButton setBackgroundColor:[UIColor clearColor]];
    [fbButton addTarget:self action:@selector(ShowFriendDialog:) forControlEvents:UIControlEventTouchUpInside];
    [fbButton setEnabled:YES];
    [self.view addSubview:fbButton];
    
//    self.inviteButton = [[FUIButton alloc]initWithFrame:CGRectMake(35, 107.5, 250, 25)];
//    UIColor * color4 = [UIColor colorWithRed:245/255.0f green:135/255.0f blue:77/255.0f alpha:1.0f];
//    self.inviteButton.buttonColor = color4;
//    UIColor * color5 = [UIColor colorWithRed:221/255.0f green:117/255.0f blue:62/255.0f alpha:1.0f];
//    self.inviteButton.shadowColor = color5;
//    self.inviteButton.shadowHeight = 3.0f;
//    self.inviteButton.cornerRadius = 6.0f;
//    self.inviteButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0];
//    [self.inviteButton setTitle:@"Invite Facebook Friends" forState:UIControlStateNormal];
//    [self.inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.inviteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    [self.inviteButton addTarget:self action:@selector(ShowFriendDialog:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:self.inviteButton];
    
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 89.f, 320.f, self.view.bounds.size.height-140.f)];
    _searchTableView.delegate = self;
    _searchTableView.dataSource = self;
    [_searchTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    //    _locationTableView.backgroundColor = [UIColor blackColor];
    //    [_locationTableView setSeparatorColor:[UIColor whiteColor]];
    [self.searchTableView setTag:0];
    [self.view addSubview:_searchTableView];
    
    self.locationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 586)];
    [self.locationView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.locationView];

    [self.locationView setHidden:YES];
    [self.view setUserInteractionEnabled:YES];
    
    //extends the lines in the table view fully
    [_searchTableView setSeparatorInset:UIEdgeInsetsZero];

    UIImageView *search_icon = [[UIImageView alloc]initWithFrame:CGRectMake(280, 0, 40, 40)];
    search_icon.image = [UIImage imageNamed:@"search_button_blue.png"];
    [self.view addSubview:search_icon];
    
    self.horz_line3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 82, 320, 11)];
    self.horz_line3.image = [UIImage imageNamed:@"lines.png"];
    [self.view addSubview:self.horz_line3];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 120, 40)];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:20.0];
    //self.titleLabel.text = @"PEOPLE";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
    self.titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 120, 40)];
    self.titleLabel2.textColor = [UIColor grayColor];
    self.titleLabel2.font = [UIFont fontWithName:@"OpenSans-Regular" size:20.0];
   // self.titleLabel2.text = @"PLACES";
    self.titleLabel2.textAlignment = NSTextAlignmentCenter;
    [self.titleLabel2 setBackgroundColor:[UIColor clearColor]];
    [self.locationView addSubview:self.titleLabel2];
    
    self.location_textField = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, 280, 40)];
    self.location_textField.borderStyle = UITextBorderStyleNone;
    self.location_textField.font = [UIFont fontWithName:@"OpenSans-Regular" size:16];
    self.location_textField.textColor = [UIColor lightGrayColor];
    UIColor *color10 = [UIColor lightGrayColor];
    self.location_textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"SEARCH" attributes:@{NSForegroundColorAttributeName: color10}];
    //    UIColor * color3 = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];
    self.location_textField.backgroundColor = [UIColor whiteColor];
    self.location_textField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.location_textField.keyboardType = UIKeyboardTypeDefault;
    self.location_textField.returnKeyType = UIReturnKeySearch;
    self.location_textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.location_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.location_textField addTarget:self
                   action:@selector(textFieldDone2:)
         forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.location_textField addTarget:self action:@selector(keyboardAppeared:) forControlEvents:UIControlEventEditingDidBegin];
    [self.locationView addSubview:self.location_textField];
    
    //PLACES
    
    _locationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 45.f, 320.f, self.view.frame.size.height-95)];
    //    _locationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height)];
    _locationTableView.delegate = self;
    _locationTableView.dataSource = self;
    [self.locationTableView setTag:1];
    //    [_locationTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    //    _locationTableView.backgroundColor = [UIColor blackColor];
    //    [_locationTableView setSeparatorColor:[UIColor whiteColor]];
    [self.locationView addSubview:_locationTableView];
    
    //extends the lines in the table view fully
    [_locationTableView setSeparatorInset:UIEdgeInsetsZero];
    
    
    
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
    
    UIImageView *corline = [[UIImageView alloc]initWithFrame:CGRectMake(0,515, 320, 50)];
    corline.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:corline];
    
    self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton3  setFrame:CGRectMake(0, 0, 45, 45)];
    [self.navButton3 setBackgroundColor:[UIColor clearColor]];
    [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navButton3.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:18]];
    self.navButton3.tag = 1;
    self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton3];
    
    self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton  setFrame:CGRectMake(10, 11, 25, 21)];
    [self.navButton setBackgroundColor:[UIColor clearColor]];
    [self.navButton setBackgroundImage:[[UIImage imageNamed:@"grey_menu.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
    [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:18]];
    self.navButton.tag = 1;
    self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton];
    
    self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton2  setFrame:CGRectMake(0, 63, 45, 520)];
    [self.navButton2 setBackgroundColor:[UIColor clearColor]];
    [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navButton2.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:18]];
    self.navButton2.tag = 0;
    self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton2];
    
    [self.navButton2 setHidden:YES];
    
    self.peopleSearch = [[UIImageView alloc]initWithFrame:CGRectMake(75, 520, 173,38)];
    [self.peopleSearch setImage:[UIImage imageNamed:@"people.png"]];
    [self.view addSubview:self.peopleSearch];
    
    self.placesSearch = [[UIImageView alloc]initWithFrame:CGRectMake(80, 525, 160, 37)];
    [self.placesSearch setImage:[UIImage imageNamed:@"placestab_2.png"]];
    [self.view addSubview:self.placesSearch];
    
    [self.placesSearch setHidden:YES];
    
    UIButton *peopleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [peopleButton setFrame:CGRectMake(80, 520, 80, 40)];
    [peopleButton setBackgroundColor:[UIColor clearColor]];
    [peopleButton addTarget:self action:@selector(showPeople:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:peopleButton];
    
    UIButton *placesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [placesButton setFrame:CGRectMake(160, 520, 80, 40)];
    [placesButton setBackgroundColor:[UIColor clearColor]];
    [placesButton addTarget:self action:@selector(showPlaces:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:placesButton];
    
    [self setupGestures];
    
    self.tap_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tap_button  setFrame:CGRectMake(0, 40, 320, 310)];
    [self.tap_button setBackgroundColor:[UIColor clearColor]];
    [self.tap_button addTarget:self action:@selector(dismissKeyboard2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tap_button];
    [self.tap_button setHidden:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

}

- (BOOL)prefersStatusBarHidden {
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
    
    NSLog(@"button index = %ld",(long)buttonIndex);
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    [self.locationManager stopUpdatingLocation];
    [self getVenuesForLocation:newLocation];
    //    [self setupMapForLocatoion:newLocation];
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
                                          self.nearbyVenues = [converter convertToObjects:venues];
                                          [self.locationTableView reloadData];
                                          
                                      }
                                  }];
}

- (void)showPeople:(id)sender {
    
    [self.horz_line3 setHidden:NO];
    
    [self.peopleSearch setHidden:NO];
    [self.placesSearch setHidden:YES];
    [self.searchTableView setHidden:NO];
    [self.textField setHidden:NO];
    [self.inviteButton setHidden:NO];
    [self.locationView setHidden:YES];
    [self.titleLabel setHidden:NO];
}

- (void)showPlaces:(id)sender {
    
    [self.horz_line3 setHidden:YES];
    
    [self.peopleSearch setHidden:YES];
    [self.placesSearch setHidden:NO];
    [self.searchTableView setHidden:YES];
    [self.textField setHidden:YES];
    [self.inviteButton setHidden:YES];
    [self.locationView setHidden:NO];
    [self.titleLabel setHidden:YES];
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
            [self dismissKeyboard];
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

-(void)Load100Users
{
    self.peopleArray = [NSMutableArray new];
    _collectionName2 = @"userPicture";
    _customEndpoint2 = @"NewsFeed";
    _fieldName2 = nil;
    skip = [_tryl intValue];

    _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:@"searchName",@"searchName2",_collectionName2,@"collectionName",[NSNumber numberWithInt:skip],@"skip", nil];

    [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
        
        if ([results isKindOfClass:[NSArray class]]){
            self.peopleArray = [NSMutableArray arrayWithArray:results];
        }
        
        if (self.peopleArray.count>0) {
            [self.searchTableView reloadData];
            [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }
        
    }];

}

-(void)dismissKeyboard {
    [self.tap_button setHidden:YES];
    [_textField resignFirstResponder];
    [self.location_textField resignFirstResponder];
}

-(void)dismissKeyboard2:(id)sender {
    [self.tap_button setHidden:YES];
    [_textField resignFirstResponder];
    [self.location_textField resignFirstResponder];
}

-(void)keyboardAppeared:(id)sender {
    [self.tap_button setHidden:NO];
}

-(IBAction)textFieldDone:(id)sender
{
    [self.tap_button setHidden:YES];
    self.peopleArray = [NSMutableArray new];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    NSString *s = [[_textField text]capitalizedString];
        
        if ([s length]>0) {
            
            self.peopleArray = [NSMutableArray new];
            [self.searchTableView reloadData];
            
            NSArray* firstLastStrings = [s componentsSeparatedByString:@" "];
            
            [_textField resignFirstResponder];
            
            _userFollowingEmail = [NSMutableArray new];
            _userFollowingPicture = [NSMutableArray new];
            _userFollowingPictureUrl = [NSMutableArray new];
            _userFollowingFullName = [NSMutableArray new];
            
            if (firstLastStrings.count>1) {
                
                _firstName = [[firstLastStrings objectAtIndex:0]capitalizedString];
                _lastName = [[firstLastStrings objectAtIndex:1]capitalizedString];
                
                _collectionName2 = @"userPicture";
                _customEndpoint2 = @"NewsFeed";
                _fieldName2 = nil;
                _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:s,@"searchName",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
                //        NSLog(@"user name = %@, j=%d",_userEmail,j);
                [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
                    
                    self.peopleArray = [NSMutableArray new];
                    
                    if ([results isKindOfClass:[NSArray class]]){
                        self.peopleArray = [NSMutableArray arrayWithArray:results];
                    }
                    
                    if (results) {
                        if (self.peopleArray.count>0) {
                            [self.searchTableView reloadData];
                            [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                        }else{
                            [self.searchTableView reloadData];
                            [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                        }
                    }else{
                        NSLog(@"no result");
                        self.peopleArray = [NSMutableArray new];
                        [self.searchTableView reloadData];
                        [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    }
                    
                }];

            }else{
                
                _firstName = s;
                _lastName=nil;
                
                _collectionName2 = @"userPicture";
                _customEndpoint2 = @"NewsFeed";
                _fieldName2 = nil;
                _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:s,@"searchName",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
                //        NSLog(@"user name = %@, j=%d",_userEmail,j);
                [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
                    
                    self.peopleArray = [NSMutableArray new];

                    if ([results isKindOfClass:[NSArray class]]){
                        self.peopleArray = [NSMutableArray arrayWithArray:results];
                    }
                    
                    if (results) {
                        if (self.peopleArray.count>0) {
                            [self.searchTableView reloadData];
                            [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                        }else{
                            [self.searchTableView reloadData];
                            [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                        }
                    }else{
                        [self.searchTableView reloadData];
                        [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    }
                    
                }];
            
            }
            
        }else{
            
            [self Load100Users];
            
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

-(IBAction)textFieldDone2:(id)sender {
    
    [self.tap_button setHidden:YES];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        NSString *s = [_location_textField text];
        
        if ([CLLocationManager locationServicesEnabled] == YES) {
            CLLocationManager* manager = [[CLLocationManager alloc] init];
            //... set up CLLocationManager and start updates
            _currentLocation = manager.location;
            //            NSLog(@"current location = %f",_currentLocation.coordinate.longitude);
            
        }
        
        [Foursquare2 venueSearchNearByLatitude:@(_currentLocation.coordinate.latitude)
                                     longitude:@(_currentLocation.coordinate.longitude)
                                         query:s
                                         limit:nil
                                        intent:intentBrowse
                                        radius:@(1000)
                                    categoryId:nil
                                      callback:^(BOOL success, id result){
                                          if (success) {
                                              NSDictionary *dic = result;
                                              NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                              FSConverter *converter = [[FSConverter alloc]init];
                                              self.nearbyVenues = [converter convertToObjects:venues];
                                              [self.locationTableView reloadData];
                                              
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

- (void)userSearchNames
{
    int i;
    j=0;
    _userFollowingEmail = [NSMutableArray new];
    _userFollowingPicture = [NSMutableArray new];
    _userFollowingPictureUrl = [NSMutableArray new];
    _userFollowingFullName = [NSMutableArray new];
    
    for (i=0; i<_results.count; i++) {
        
        KCSUser *user = _results[i];
        [_userFollowingEmail addObject:user.username];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",user.givenName,user.surname];
        [_userFollowingFullName addObject:fullName];
        NSLog(@"%@ %@",_userFollowingEmail,_userFollowingFullName);
        
        if (_userFollowingFullName.count == _results.count) {
            [self getUserPictures];
//            [self.searchTableView reloadData];
//            [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }else{
//            [self.searchTableView reloadData];
//            [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        }

    }
    
}

- (void)userSearchNames2
{

    _userFollowingEmail = [NSMutableArray new];
    _userFollowingPicture = [NSMutableArray new];
    _userFollowingPictureUrl = [NSMutableArray new];
    _userFollowingFullName = [NSMutableArray new];
    [_userFollowingEmail addObjectsFromArray:@[@"thomasmaking@gmail.com",@"jeff@getyooka.com",@"joshua.cleetus@gmail.com",@"wbracket@gmail.com",@"eunycekim@gmail.com",@"janice.an@gmail.com",@"bl1164a@american.edu",@"andrewhg1@aol.com"]];

    [_userFollowingFullName addObjectsFromArray:@[@"Thomas Noh",@"Jeffrey Oh",@"Joshua Cleetus",@"Will Brackett",@"Eunyce Kîm",@"Janice An",@"Bryan Liborio",@"Andrew Gross"]];

    [self getUserPictures];
    
//            [self.searchTableView reloadData];
//            [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
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

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return self.nearbyVenues.count;
    }
    if (tableView.tag == 0) {
        if (self.peopleArray.count) {
            return self.peopleArray.count;
        }else{
            return 1;
        }
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    if (tableView.tag == 0) {
        
        
        UITableViewCell *cell = [_searchTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor whiteColor];
        
        // create a custom label:                                        x    y   width  height
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(55.0, 0.0, 240.0, 40.0)];
        [_descriptionLabel setTag:1];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        _descriptionLabel.textColor = [UIColor grayColor];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        [_descriptionLabel setFont:[UIFont systemFontOfSize:16.0]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:_descriptionLabel];
            
        }
        
        if (self.peopleArray.count>0) {
            NSString *userFullName = [self.peopleArray[indexPath.row] objectForKey:@"userFullName"];
            
            if (userFullName) {
                [(UILabel *)[cell.contentView viewWithTag:1] setText:userFullName];
            }
            
            NSString *userPicUrl = [[self.peopleArray[indexPath.row] objectForKey:@"userImage"] objectForKey:@"_downloadURL"];
            
            if (userPicUrl) {
                
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadWithURL:[NSURL URLWithString:userPicUrl]
                                 options:0
                                progress:^(NSInteger receivedSize, NSInteger expectedSize)
                 {
                     // progression tracking code
                 }
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                 {
                     if (image)
                     {
                         // do something with image
                         UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10,5, 35, 35)];
                         [imv.layer setCornerRadius:imv.frame.size.width/2];
                         [imv setClipsToBounds:YES];
                         [imv setContentMode:UIViewContentModeScaleAspectFill];
                         imv.image = image;
                         [cell.contentView addSubview:imv];
                         
                     }else{
                         
                         UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10,5, 35, 35)];
                         [imv.layer setCornerRadius:imv.frame.size.width/2];
                         [imv setClipsToBounds:YES];
                         imv.image=[UIImage imageNamed:@"minion.jpg"];
                         [imv setContentMode:UIViewContentModeScaleAspectFill];
                         [cell.contentView addSubview:imv];
                         
                     }
                     
                 }];
                
            }else{
                
                
            }
        }else{
            
            [(UILabel *)[cell.contentView viewWithTag:1] setText:@"        No users found."];
            
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10,5, 35, 35)];
            [imv setBackgroundColor:[UIColor whiteColor]];
            [cell.contentView addSubview:imv];
            
        }
        
        return cell;
        
    }else{
        
        UITableViewCell *cell = [self.locationTableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor whiteColor];

            // create a custom label:                                        x    y   width  height
            _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, -5.0, 270.0, 40.0)];
            [_descriptionLabel setTag:1];
            [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
            _descriptionLabel.textColor = [UIColor lightGrayColor];
            _descriptionLabel.textAlignment = NSTextAlignmentLeft;
            [_descriptionLabel setFont:[UIFont systemFontOfSize:16.0]];
           [_descriptionLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:23]];
            // custom views should be added as subviews of the cell's contentView:
            [cell.contentView addSubview:_descriptionLabel];
            
            // create a custom label:                                        x    y   width  height
            self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 25, 270.0, 10.0)];
            [self.detailLabel setTag:2];
            [self.detailLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
            self.detailLabel.textColor = [UIColor lightGrayColor];
            self.detailLabel.textAlignment = NSTextAlignmentLeft;
            [self.detailLabel setFont:[UIFont systemFontOfSize:10.0]];
            //[_descriptionLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:23]];
            // custom views should be added as subviews of the cell's contentView:
            [cell.contentView addSubview:self.detailLabel];
            
        }
        
        if (self.lastSelected)
        {
            
        }
        
        //    cell.textLabel.text = [self.nearbyVenues[indexPath.row] name];
        FSVenue *venue = self.nearbyVenues[indexPath.row];
        if (venue.location.address) {
            [(UILabel *)[cell.contentView viewWithTag:2] setText:[NSString stringWithFormat:@"%@, %@ m",
                                                 venue.location.address,
                                                 venue.location.distance]];

            
        } else {
                    [(UILabel *)[cell.contentView viewWithTag:2] setText:[NSString stringWithFormat:@"%@ m",
                                                 venue.location.distance]];
        }
        
        //    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"check_box.jpeg"];
        [(UILabel *)[cell.contentView viewWithTag:1] setText:[self.nearbyVenues[indexPath.row] name]];
        
//        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(20,6, 30, 31)];
//        imv.image=[UIImage imageNamed:@"check_box.jpeg"];
//        [cell.contentView addSubview:imv];
        
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 0) {
        
        // keep track of the last selected cell
        self.lastSelected = indexPath;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.textField resignFirstResponder];
        
        if (self.peopleArray.count) {
            _userFullNameSelected = [self.peopleArray[indexPath.row] objectForKey:@"userFullName"];
        }
        NSLog(@"%@",_userFullNameSelected);
        if (_userFullNameSelected) {
            _userEmailSelected = [self.peopleArray[indexPath.row] objectForKey:@"userEmail"];
            _userPicUrlSelected = [[self.peopleArray[indexPath.row] objectForKey:@"userImage"] objectForKey:@"_downloadURL"];
            if (_userPicUrlSelected) {
                _userPicUrl=_userPicUrlSelected;
            }else{
                _userPicUrl=nil;
            }
            [self userDidSelectUser];
            
        }else{
            _userFullNameSelected = nil;
            _userPicUrl = nil;
        }
        
    }else{
        
        self.lastSelected = indexPath;
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.selected = self.nearbyVenues[indexPath.row];
        _venueSelected = [self.nearbyVenues[indexPath.row]name];
        _venueId = self.selected.venueId;
        _venueAddress = self.selected.location.address;
        _venueCc = self.selected.location.cc;
        _venueCity = self.selected.location.city;
        _venueState = self.selected.location.state;
        _venueCountry = self.selected.location.country;
        _venuePostalCode = [NSString stringWithFormat:@"%@",self.selected.location.postalCode];
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.35;
        transition.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        
        // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
        UIView *containerView = self.view.window;
        [containerView.layer addAnimation:transition forKey:nil];
        
        YookaRestaurantViewController *media = [[YookaRestaurantViewController alloc]init];
        media.venueId = _venueId;
        media.selectedRestaurantName = _venueSelected;
        NSString *lat = [NSString stringWithFormat:@"%f",self.selected.location.coordinate.latitude];
        if ([lat length] >= 20) lat = [lat substringToIndex:20];
        media.latitude = lat;
        NSString *lon = [NSString stringWithFormat:@"%f",self.selected.location.coordinate.longitude];
        media.longitude = lon;
        [self presentViewController:media animated:NO completion:nil];
    }
    
}

- (void)userDidSelectUser
{
    [self dismissKeyboard];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    

//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *userId = _userEmailSelected;
    NSString *userFullName = _userFullNameSelected;
    NSString *userPicUrl = _userPicUrl;
    
    self.myEmail = [[KCSUser activeUser] email];
    
    if ([self.myEmail isEqual:userId]){
        YookaProfileNewViewController *media2 = [[YookaProfileNewViewController alloc]init];
        [self presentViewController:media2 animated:NO completion:nil];
        
    }
    else{
        
        YookaClickProfileViewController *media = [[YookaClickProfileViewController alloc]init];
        media.userFullName = userFullName;
        media.myEmail = userId;
        media.myURL =userPicUrl;
        [self presentViewController:media animated:NO completion:nil];
        
    }
    
}

- (void)backAction
{
//    NSLog(@"BACK BUTTON");
}

- (void)getUserPictures
{
    if (j<_userFollowingEmail.count) {
        
        _userEmail = _userFollowingEmail[j];
        _collectionName1 = @"userPicture";
        _customEndpoint1 = @"NewsFeed";
        _fieldName1 = @"_id";
        _dict = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
//        NSLog(@"user name = %@, j=%d",_userEmail,j);
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
                NSArray *results_array = [NSArray arrayWithArray:results];
                if (results_array && results_array.count) {
//                    NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                    _userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
//                    NSLog(@"user pic url = %@",_userPicUrl);
                    if (_userPicUrl) {
                        [_userFollowingPictureUrl addObject:_userPicUrl];
                    }else{
                        NSString *url = [NSString stringWithFormat:@"http://s25.postimg.org/4qq1lj6nj/minion.jpg"];
                        [_userFollowingPictureUrl addObject:url];
                    }
                    
                    j=j+1;
                    [self getUserPictures];
//                    [self.searchTableView reloadData];
//                    [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                }else{
                    
                    NSString *url = [NSString stringWithFormat:@"http://s25.postimg.org/4qq1lj6nj/minion.jpg"];
                    [_userFollowingPictureUrl addObject:url];
                    
                    j=j+1;
                    [self getUserPictures];
//                    [self.searchTableView reloadData];
//                    [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                }

            }else{
                [_userFollowingPictureUrl addObject:@"http://s25.postimg.org/4qq1lj6nj/minion.jpg"];
                
                j=j+1;
                [self getUserPictures];
//                [self.searchTableView reloadData];
//                [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
            }
        }];

    }
    if (j==_userFollowingEmail.count) {
        
//        NSLog(@"array = %@",_userFollowingPictureUrl);
        [self.searchTableView reloadData];
        [self.searchTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }
}

-(IBAction)ShowFriendDialog:(id)sender
{
    
    if (FBSession.activeSession.isOpen) {
        
        NSDictionary *parameters = @{@"to":@""};
        
        [FBWebDialogs presentRequestsDialogModallyWithSession:FBSession.activeSession
                                                      message:@"my message"
                                                        title:@"my title"
                                                   parameters:parameters
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error)
         {
             if(error)
             {
                 NSLog(@"Some errorr: %@", [error description]);
                 UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Invitiation Sending Failed" message:@"Unable to send inviation at this Moment, please make sure your are connected with internet" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alrt show];
                 //[alrt release];
             }
             else
             {
                 if (![resultURL query])
                 {
                     return;
                 }
                 
                 NSDictionary *params = [self parseURLParams:[resultURL query]];
                 NSMutableArray *recipientIDs = [[NSMutableArray alloc] init];
                 for (NSString *paramKey in params)
                 {
                     if ([paramKey hasPrefix:@"to["])
                     {
                         [recipientIDs addObject:[params objectForKey:paramKey]];
                     }
                 }
                 if ([params objectForKey:@"request"])
                 {
                     NSLog(@"Request ID: %@", [params objectForKey:@"request"]);
                 }
                 if ([recipientIDs count] > 0)
                 {
                     //[self showMessage:@"Sent request successfully."];
                     //NSLog(@"Recipient ID(s): %@", recipientIDs);
                     UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"Invitation(s) sent successfuly!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [alrt show];
                     //[alrt release];
                 }
                 
             }
         }friendCache:nil];
        
    }
    
}

- (NSDictionary *)parseURLParams:(NSString *)query
{
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs)
    {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        
        [params setObject:[[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                   forKey:[[kv objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    return params;
}


- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    
//    UITouch *touch = [touches anyObject];
//    NSLog(@"* * * * * * * * *ViewControllerBase touchesBegan");
//
//    
//    if (![[touch view] isKindOfClass:[UITextField class]]) {
//        [self.view endEditing:YES];
//    }
//    [super touchesBegan:touches withEvent:event];
//}

-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:panRecognizer];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate methods

// This is where we can slide the active panel from left to right and back again,
// endlessly, for great fun!
-(void)movePanel:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    
    //    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    // Stop the main panel from being dragged to the left if it's not already dragged to the right
    //    if ((velocity.x < 0) && (activeViewController.view.frame.origin.x == 0)) {
    //        return;
    //    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        if(velocity.x > 0) {
            _showPanel = YES;
        }
        else {
            _showPanel = NO;
        }
    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        // If we stopped dragging the panel somewhere between the left and right
        // edges of the screen, these will animate it to its final position.
        if (!_showPanel) {
            [_delegate movePanelToOriginalPosition];
            _panelMovedRight = NO;
            [self.navButton2 setHidden:YES];
            self.navButton3.tag = 1;
            self.navButton.tag = 1;
            self.navButton2.tag = 1;
        } else {
            [self dismissKeyboard];
            [self.navButton2 setHidden:NO];
            self.navButton2.tag = 0;
            self.navButton3.tag = 0;
            self.navButton.tag = 0;
            [_delegate movePanelRight];
            _panelMovedRight = YES;
        }
    }
    //pm
    //added reappeared button2, reset tags
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            _showPanel = YES;
        }
        else {
            _showPanel = NO;
        }
        
        // Set the new x coord of the active panel...
        //        activeViewController.view.center = CGPointMake(activeViewController.view.center.x + translatedPoint.x, activeViewController.view.center.y);
        
        // ...and move it there
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

@end
