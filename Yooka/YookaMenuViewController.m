//
//  YookaMenuViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 19/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaMenuViewController.h"
#import "YookaPostViewController.h"
#import "Foursquare2.h"
#import "FSConverter.h"
#import "FSVenue.h"
#import <Reachability.h>
#import "YookaBackend.h"


@interface YookaMenuViewController ()

@end

@implementation YookaMenuViewController

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
    
    _menuObjects = [[NSMutableArray alloc]init];
    _filteredArray = [[NSMutableArray alloc]init];
    
//    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Menu" style:UIBarButtonItemStylePlain target:self action:@selector(addMenu)];
//    self.navigationItem.rightBarButtonItem = anotherButton;
    
//    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
//    [self.view setBackgroundColor:color];
//    [self.navigationController.navigationBar setBarTintColor:color];
//    [self.navigationItem setTitle:@"Menu"];
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UIImageView *whitebg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
    whitebg.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:whitebg];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 120, 40)];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:20.0];
    //titleLabel.text = @"LOCATION";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setFrame:CGRectMake(0, 0, 40, 40)];
    
    self.cancelBtn.backgroundColor= [UIColor whiteColor];
    //[self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //            [editProfileBtn setBackgroundImage:[[UIImage imageNamed:@"logoutbtn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
    UIImageView *cancel_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    cancel_icon.image = [UIImage imageNamed:@"x_close"];
    [self.view addSubview:cancel_icon];

    
    UIImageView *addBtn2 = [[UIImageView alloc]initWithFrame:CGRectMake(70, 30, 140, 60)];
    addBtn2.image = [UIImage imageNamed:@"add_to_menu.png"];
    addBtn2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addBtn2];
    
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
    
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setFrame:CGRectMake(0, 40, 320, 40)];
//    [self.addBtn setTitle:@"Add Menu" forState:UIControlStateNormal];
//    [self.addBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
   // [self.addBtn setBackgroundImage:[[UIImage imageNamed:@"add_to_menu.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addBtn];

    //NSLog(@"venue id = %@",_venueID);
    _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(-20.f, 80.f, 340.f, self.view.frame.size.height-80)];
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    [_menuTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    //    _locationTableView.backgroundColor = [UIColor blackColor];
    //    [_locationTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:_menuTableView];
    
    self.menuSearch = [[UISearchBar alloc]initWithFrame:CGRectMake(40.f, 0.f, 235.f, 30.f)];
    self.menuSearch.showsCancelButton = NO;
    self.menuSearch.tintColor=[UIColor clearColor];
    self.menuSearch.barTintColor=[UIColor clearColor];
    self.menuSearch.translucent=YES;
    self.menuSearch.backgroundColor=[UIColor clearColor];
    self.menuSearch.backgroundImage=nil;
    self.menuSearch.delegate = self;
    self.menuSearch.searchBarStyle= UISearchBarStyleMinimal;
    self.menuSearch.placeholder = @"SEARCH";
    self.menuSearch.autocorrectionType=UITextAutocorrectionTypeNo;
    self.menuSearch.autocapitalizationType=UITextAutocapitalizationTypeNone;
    self.menuSearch.clipsToBounds = YES;
    [self.view addSubview:self.menuSearch];
    
    UITextField *txfSearchField = [self.menuSearch valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor whiteColor]];
    [txfSearchField setLeftViewMode:UITextFieldViewModeNever];
    [txfSearchField setRightViewMode:UITextFieldViewModeNever];
    [txfSearchField setBackground:[UIImage imageNamed:@"Captionbar.png"]];
    [txfSearchField setBorderStyle:UITextBorderStyleNone];
    //txfSearchField.layer.borderWidth = 8.0f;
    //txfSearchField.layer.cornerRadius = 10.0f;
    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;
    txfSearchField.clearButtonMode=UITextFieldViewModeNever;
    txfSearchField.clipsToBounds = YES;

    self.menuTableView.tableHeaderView = nil;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.menuSearch contentsController:self];
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    [searchDisplayController setSearchResultsDelegate:self];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    [self getMenuForVenue];
        
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

- (void)addMenu
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add a Menu", @"title")
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                          otherButtonTitles:@"Submit",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

- (void)cancelBtnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {

        NSString *entered = [alertView textFieldAtIndex:0].text;
        //NSLog(@"entered = %@",entered);
        if (![self.menuObjects containsObject:entered]) {
            [self.menuObjects insertObject:entered atIndex:0];
        }
        [self.menuTableView reloadData];
        [self saveMenu];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Check to see whether the normal table or search results table is being displayed and return the count from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredArray count];
    } else {
        return self.menuObjects.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (self.filteredArray.count) {
            return 1;
        }
    } else {
        if (self.menuObjects.count) {
            return 1;
        }
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_menuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    } else {
//
//    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.tag = indexPath.row;
        
        // create a custom label:                                        x    y   width  height
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 0.0, 240.0, 40.0)];
        [_descriptionLabel setTag:1];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        _descriptionLabel.textColor = [UIColor grayColor];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        [_descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:_descriptionLabel];
        
    }
    
//    cell.textLabel.text = self.menuObjects[indexPath.row];
//    FSVenue *venue = self.nearbyVenues[indexPath.row];
//    if (venue.location.address) {
//        //        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m, %@",
//        //                                     venue.location.distance,
//        //                                     venue.location.address];
//    } else {
//        //        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
//        //                                     venue.location.distance];
//    }
    
    //    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"check_box.jpeg"];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [(UILabel *)[cell.contentView viewWithTag:1] setText:self.filteredArray[indexPath.row]];
    } else {
        [(UILabel *)[cell.contentView viewWithTag:1] setText:self.menuObjects[indexPath.row]];
    }
    
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
    
//    NSLog(@"1234");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    _menuData = [NSMutableArray new];
//    _menuData = [NSArray arrayWithObjects:_venueID,_venueSelected,_menuSelected, nil];
    if (self.venueID) {
        [_menuData addObject:self.venueID];
    }else{
        [_menuData addObject:[NSNull null]];
    }
    if (self.venueSelected) {
        [_menuData addObject:self.venueSelected];
    }else{
        [_menuData addObject:[NSNull null]];
    }
    if (self.menuSelected) {
        [_menuData addObject:self.menuSelected];
    }else{
        [_menuData addObject:[NSNull null]];
    }
    [_delegate sendMenuDataToA:_menuData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //NSLog(@"did select row");

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        //NSLog(@"did select row 2");

                // keep track of the last selected cell
        self.lastSelected = indexPath;
        //NSLog(@"index 1 %@", indexPath);
        _menuSelected = self.filteredArray[indexPath.row];
        
    }else{
        
//        if (self.lastSelected==indexPath) return; // nothing to do
        
        // keep track of the last selected cell
        self.lastSelected = indexPath;
        //NSLog(@"index 1 %@", indexPath);
        _menuSelected = self.menuObjects[indexPath.row];
    }
    if ([_menuSelected isEqualToString:@"Add a Menu"]) {
        
        [self addMenu];
        
    }else{
    [self userDidSelectVenue];

    }
    
}


- (void)getVenuesForLocation:(CLLocation *)location {
    
    [Foursquare2 venueSearchNearByLatitude:@(location.coordinate.latitude)
                                 longitude:@(location.coordinate.longitude)
                                     query:@"restaurant"
                                     limit:@(100)
                                    intent:intentBrowse
                                    radius:@(1000)
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          NSDictionary *dic = result;
                                          //NSLog(@"dic = %@",dic);
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          FSConverter *converter = [[FSConverter alloc]init];
                                          self.menu = [converter convertToObjects:venues];
                                          [_menuTableView reloadData];
//                                          [self proccessAnnotations];
                                          
                                      }
                                  }];
}

- (void)getMenuForVenue {

    [Foursquare2 venueGetMenu:_venueID
                      callback:^(BOOL success, id result){
                          if (success) {
                              
                                        NSDictionary *dic = result;
                                        NSLog(@"menu data 1 = %@",dic);
                                        NSString *menus = [dic valueForKeyPath:@"response.menu.menus.count"];
                                        NSLog(@"menu data 2 = %@",menus);
                              
                              if ([[dic valueForKeyPath:@"response.menu.menus.count"]integerValue]>0) {
                                  
                                  NSString *menu1 = [result valueForKeyPath:@"response.menu.menus.items.entries.items.entries.items.name"];
                                  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:menu1 options:NSJSONWritingPrettyPrinted error:nil];
                                  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                  //NSLog(@"menu 1 = %@",jsonString);
                                  
                                  _menuObjects = [NSMutableArray array];
                                  NSScanner *scanner = [NSScanner scannerWithString:jsonString];
                                  NSString *tmp;
                                  
                                  while ([scanner isAtEnd] == NO)
                                  {
                                      [scanner scanUpToString:@"\"" intoString:NULL];
                                      [scanner scanString:@"\"" intoString:NULL];
                                      [scanner scanString:@"\\" intoString:NULL];
                                      [scanner scanUpToString:@"\"" intoString:&tmp];
                                      if ([scanner isAtEnd] == NO)
                                          [_menuObjects addObject:tmp];
                                      [scanner scanString:@"\"" intoString:NULL];
                                  }
                                  
                                  [self getYookaMenuForVenue];

                              }else{
                                  [self getYookaMenuForVenue];
                              }
                              
                          }
                      }];
}

- (void)getYookaMenuForVenue{
//    NSString *string = @"Add a Menu";
//    [_menuObjects insertObject:string atIndex:0];
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaMenuDB" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery* query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:self.venueID];
//    KCSQuery* query2 = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:_cachesubscribedHuntNames[j]];
//    KCSQuery* query3 = [KCSQuery queryOnField:@"postType" usingConditional:kKCSNotEqual forValue:@"started hunt"];
//    KCSQuery* query4 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2,query3, nil];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //                         NSLog(@"An error occurred on fetch: %@", errorOrNil);
            [_menuTableView reloadData];

        } else {
            
            //got all events back from server -- update table view
            NSLog(@"featured hunt count = %lu",(unsigned long)objectsOrNil.count);
            NSMutableArray *array1 = [NSMutableArray new];
            
            if (objectsOrNil.count>0) {
                YookaBackend *yooka = objectsOrNil[0];
                array1 = [NSMutableArray arrayWithArray:yooka.menu_list];
                [array1 addObjectsFromArray:self.menuObjects];
                self.menuObjects = array1;
                [self.menuTableView reloadData];
            }else{
                [self.menuTableView reloadData];
            }
            
        }
    } withProgressBlock:nil];
    
}

- (void)saveMenu
{
    YookaBackend *yooka = [[YookaBackend alloc]init];
    yooka.kinveyId = self.venueID;
    yooka.menu_list = self.menuObjects;
    [yooka.meta setGloballyReadable:YES];
    [yooka.meta setGloballyWritable:YES];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaMenuDB" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store saveObject:yooka withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
        } else {
            //save was successful
            NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
        }
    } withProgressBlock:nil];
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    self.filteredArray = [NSMutableArray arrayWithArray:[self.menuObjects filteredArrayUsingPredicate:predicate]];
    [self.menuTableView reloadData];
    
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    
    return YES;
}

-(void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
}

@end
