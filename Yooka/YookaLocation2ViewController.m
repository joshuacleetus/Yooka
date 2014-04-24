//
//  YookaLocation2ViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 4/5/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaLocation2ViewController.h"
#import "FSQView/FSVenue.h"
#import "FSQView/FSConverter.h"
#import "YookaHuntRestaurantViewController.h"
#import <Reachability.h>

@interface YookaLocation2ViewController ()

@end

@implementation YookaLocation2ViewController

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
    
    _nearbyVenues = [NSMutableArray new];
    _filteredArray = [NSMutableArray new];
    _locationObjects = [NSMutableArray new];
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationItem setTitle:@"Restaurants"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.toolbar.translucent = NO;
    
    
    //    http://api.locu.com/v1_0/venue/insight/?api_key=1b9372a2c73e41794633a4a59e77c8716e8cec81&dimension=new+york+city
    //    http://api.locu.com/v1_0/venue/search/?api_key=1b9372a2c73e41794633a4a59e77c8716e8cec81&street_address=prince+street
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 70, 300, 30)];
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    _textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    _textField.textColor = [UIColor darkGrayColor];
    UIColor *color1 = [UIColor grayColor];
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"                🔍 Find a restaurant" attributes:@{NSForegroundColorAttributeName: color1}];
    UIColor * color3 = [UIColor colorWithRed:221/255.0f green:221/255.0f blue:221/255.0f alpha:1.0f];
    _textField.backgroundColor = color3;
    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    _textField.keyboardType = UIKeyboardTypeDefault;
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_textField addTarget:self
                   action:@selector(textFieldDone:)
         forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:_textField];
    
    _locationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 110.f, 320.f, self.view.bounds.size.height - 160.0)];
    //    _locationTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height)];
    _locationTableView.delegate = self;
    _locationTableView.dataSource = self;
    //    [_locationTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    //    _locationTableView.backgroundColor = [UIColor blackColor];
    //    [_locationTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:_locationTableView];
    
    //    self.locationSearch = [[UISearchBar alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
    //    self.locationSearch.showsCancelButton = NO;
    //    self.locationSearch.delegate = self;
    //    self.locationSearch.placeholder = @"Search Location";
    //    self.locationSearch.autocorrectionType=UITextAutocorrectionTypeNo;
    //    self.locationSearch.autocapitalizationType=UITextAutocapitalizationTypeNone;
    //    self.locationTableView.tableHeaderView = self.locationSearch;
    //    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.locationSearch contentsController:self];
    //    searchDisplayController.delegate = self;
    //    searchDisplayController.searchResultsDataSource = self;
    //    [searchDisplayController setSearchResultsDelegate:self];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
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
                                          //                                          NSLog(@"%@",self.nearbyVenues);
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
    [super viewWillDisappear:animated];
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
    //    [self setupMapForLocatoion:newLocation];
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
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, 240.0, 40.0)];
        [_descriptionLabel setTag:1];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        _descriptionLabel.textColor = [UIColor grayColor];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        [_descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:_descriptionLabel];
        
    }
    
    //    cell.textLabel.text = [self.nearbyVenues[indexPath.row] name];
    FSVenue *venue = self.nearbyVenues[indexPath.row];
    if (venue.location.address) {
        //        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m, %@",
        //                                     venue.location.distance,
        //                                     venue.location.address];
    } else {
        //        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
        //                                     venue.location.distance];
    }
    
    
    [(UILabel *)[cell.contentView viewWithTag:1] setText:[self.nearbyVenues[indexPath.row] name]];
    
    //    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(20,6, 30, 31)];
    //    imv.image=[UIImage imageNamed:@"check_box.jpeg"];
    //    [cell.contentView addSubview:imv];
    
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
    
    YookaHuntRestaurantViewController *media = [[YookaHuntRestaurantViewController alloc]init];
    media.venueId = _venueId;
    media.selectedRestaurantName = _venueSelected;
    NSString *lat = [NSString stringWithFormat:@"%f",self.selected.location.coordinate.latitude];
    if ([lat length] >= 20) lat = [lat substringToIndex:20];
    media.latitude = lat;
    NSString *lon = [NSString stringWithFormat:@"%f",self.selected.location.coordinate.longitude];
    media.longitude = lon;
    [self.navigationController pushViewController:media animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    //    [_textField resignFirstResponder];
    
    // keep track of the last selected cell
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
    
    [self userDidSelectVenue];
    
    [tableView reloadData];
    
    
}

- (void)getVenuesForLocation:(CLLocation *)location {
    
    [Foursquare2 venueSearchNearByLatitude:@(location.coordinate.latitude)
                                 longitude:@(location.coordinate.longitude)
                                     query:nil
                                     limit:@(100)
                                    intent:intentBrowse
                                    radius:@(5000)
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
}


- (void)backAction {
    NSLog(@"back action");
}

@end
