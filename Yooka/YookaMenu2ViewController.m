//
//  YookaMenu2ViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 3/12/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaMenu2ViewController.h"
#import "YookaPostViewController.h"
#import <Foursquare2.h>
#import "FSConverter.h"
#import "FSVenue.h"
#import <Reachability.h>

@interface YookaMenu2ViewController ()

@end

@implementation YookaMenu2ViewController

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
    
    _menuObjects = [[NSMutableArray alloc]init];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Menu" style:UIBarButtonItemStylePlain target:self action:@selector(addMenu)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    NSLog(@"venue id = %@",_venueID);
    _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height)];
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    [_menuTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    //    _locationTableView.backgroundColor = [UIColor blackColor];
    //    [_locationTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:_menuTableView];
    
    self.menuSearch = [[UISearchBar alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
    self.menuSearch.showsCancelButton = NO;
    self.menuSearch.delegate = self;
    self.menuSearch.placeholder = @"Search Menu";
    self.menuSearch.autocorrectionType=UITextAutocorrectionTypeNo;
    self.menuSearch.autocapitalizationType=UITextAutocapitalizationTypeNone;
    self.menuTableView.tableHeaderView = self.menuSearch;
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

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        if (_menuObjects.count==1) {
            _menuObjects = [NSMutableArray new];
        }
        NSString *entered = [alertView textFieldAtIndex:0].text;
        NSLog(@"entered = %@",entered);
        [self.menuObjects insertObject:entered atIndex:0];
        [self.menuTableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:_venueSelected];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredArray count];
    } else {
        return self.menuObjects.count;
    }}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (self.filteredArray.count) {
            return 1;
        }
    } else {
        if (self.menuObjects.count) {
            return 1;
        }    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_menuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    
//    YookaPostViewController *media = [[YookaPostViewController alloc]init];
//    NSLog(@"venue id = %@",_venueID);
//    NSLog(@"venue name = %@",_venueSelected);
//    media.venueID = _venueID;
//    media.venueSelected = _venueSelected;
//    media.menuSelected = _menuSelected;
//    media.huntName = _huntName;
//    media.venueAddress = _venueAddress;
//    media.venueCc = _venueCc;
//    media.venueCity = _venueCity;
//    media.venueCountry = _venueCountry;
//    media.venueState = _venueState;
//    media.venuePostalCode = _venuePostalCode;
//    [self.navigationController pushViewController:media animated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSLog(@"did select row 2");
        
        // keep track of the last selected cell
        self.lastSelected = indexPath;
        NSLog(@"index 1 %@", indexPath);
        _menuSelected = self.filteredArray[indexPath.row];
        
    }else{
        
        //        if (self.lastSelected==indexPath) return; // nothing to do
        
        // keep track of the last selected cell
        self.lastSelected = indexPath;
        NSLog(@"index 1 %@", indexPath);
        _menuSelected = self.menuObjects[indexPath.row];
    }
    if ([_menuSelected isEqualToString:@"No menu items found. Add one."]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Please add a menu item", @"title")
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK!", @"OK!")
                                              otherButtonTitles:nil];
        alert.tag=0;
        [alert show];
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
                                          NSLog(@"dic = %@",dic);
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          FSConverter *converter = [[FSConverter alloc]init];
                                          self.menu = [converter convertToObjects:venues];
                                          [_menuTableView reloadData];
                                          //                                          [self proccessAnnotations];
                                          
                                      }
                                  }];
}

- (void)getMenuForVenue {
    [Foursquare2 venueGetMenus:_venueID
                      callback:^(BOOL success, id result){
                          if (success) {
                              NSDictionary *dic = result;
                              NSLog(@"menu data 1 = %@",dic);
                              NSString *menus = [dic valueForKeyPath:@"response.menu.menus.count"];
                              NSLog(@"menu data 2 = %@",menus);
                              
                              if (!([menus isEqual:0])) {
                                  
                                  NSString *menu1 = [result valueForKeyPath:@"response.menu.menus.items.entries.items.entries.items.name"];
                                  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:menu1 options:NSJSONWritingPrettyPrinted error:nil];
                                  NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                  NSLog(@"menu 1 = %@",jsonString);
                                  
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
                                  
                                  if (_menuObjects.count==0) {
                                      NSString *string = @"No menu items found. Add one.";
                                      [_menuObjects insertObject:string atIndex:0];
                                  }
                                  
                                  [_menuTableView reloadData];
                                  
                              }
                              
                          }
                      }];
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

@end
