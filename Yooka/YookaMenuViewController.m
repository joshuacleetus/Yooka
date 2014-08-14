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
    
    self.menuObjects = [[NSMutableArray alloc]init];
    self.filteredArray = [[NSMutableArray alloc]init];
    self.searchData = [NSMutableArray new];
    
    UIImageView *whitebg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
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
    //[self.cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //            [editProfileBtn setBackgroundImage:[[UIImage imageNamed:@"logoutbtn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
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
    
    UIImageView *cancel_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    cancel_icon.image = [UIImage imageNamed:@"x_close"];
    [self.view addSubview:cancel_icon];
    
    UIImageView *gps_icon = [[UIImageView alloc]initWithFrame:CGRectMake(275, -5, 48, 45)];
    gps_icon.image = [UIImage imageNamed:@"search_grey.png"];
    [self.view addSubview:gps_icon];
    
    UIButton *search_button_top = [UIButton buttonWithType:UIButtonTypeCustom];
    [search_button_top setFrame:CGRectMake(280, 0, 40, 40)];
    [search_button_top setBackgroundColor:[UIColor clearColor]];
    [search_button_top addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:search_button_top];
    
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
    
    UIImageView *addBtn2 = [[UIImageView alloc]initWithFrame:CGRectMake(-2, 36, 70, 70)];
    addBtn2.image = [UIImage imageNamed:@"add_grey.png"];
    addBtn2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:addBtn2];
    
    UILabel *add_dish_label = [[UILabel alloc]initWithFrame:CGRectMake(65, 39, 255, 64.5)];
    add_dish_label.textColor = [UIColor whiteColor];
    add_dish_label.font = [UIFont fontWithName:@"OpenSans-Bold" size:22];
    add_dish_label.textAlignment = NSTextAlignmentCenter;
    [add_dish_label setBackgroundColor:[self colorWithHexString:@"c8c9c9"]];
    [self.view addSubview:add_dish_label];
    
    UILabel *add_dish_label2 = [[UILabel alloc]initWithFrame:CGRectMake(100, 39, 220, 65)];
    [add_dish_label2 setText:@"ADD A DISH"];
    add_dish_label2.textColor = [UIColor whiteColor];
    add_dish_label2.font = [UIFont fontWithName:@"OpenSans-Bold" size:20];
    add_dish_label2.textAlignment = NSTextAlignmentLeft;
    [add_dish_label2 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:add_dish_label2];
    
    self.addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBtn setFrame:CGRectMake(0, 40, 320, 65)];
    [self.addBtn addTarget:self action:@selector(addMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addBtn];

    //NSLog(@"venue id = %@",_venueID);
    _menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(-20.f, 105.f, 340.f, self.view.frame.size.height-80)];
    _menuTableView.delegate = self;
    _menuTableView.dataSource = self;
    [_menuTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [self.view addSubview:_menuTableView];
    
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

- (void)searchButtonClicked:(id)sender
{
    [self.textField resignFirstResponder];
    NSString *s = self.textField.text;
    if ([s length]==0) {
        self.searchData = self.menuObjects;
        [self.menuTableView reloadData];
    }else{
        NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",s];
        NSArray *filtered =  [self.menuObjects filteredArrayUsingPredicate:sPredicate];
        self.searchData = [NSMutableArray arrayWithArray:filtered];
        [self.menuTableView reloadData];
    }
}

-(IBAction)textFieldEditingBegan:(UITextField *)sender
{
    NSString *s = self.textField.text;
    if ([s length]==0) {
        self.searchData = self.menuObjects;
        [self.menuTableView reloadData];
    }else{
        NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",s];
        NSArray *filtered =  [self.menuObjects filteredArrayUsingPredicate:sPredicate];
        self.searchData = [NSMutableArray arrayWithArray:filtered];

    [self.menuTableView reloadData];
    }
}

-(IBAction)textFieldDone:(UITextField *)sender
{
    NSString *s = self.textField.text;
    if ([s length]==0) {
        self.searchData = self.menuObjects;
        [self.menuTableView reloadData];
    }else{
        NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",s];
        NSArray *filtered =  [self.menuObjects filteredArrayUsingPredicate:sPredicate];
        self.searchData = [NSMutableArray arrayWithArray:filtered];
        [self.menuTableView reloadData];
    }

}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
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
        self.searchData = self.menuObjects;
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
    if (self.searchData.count) {
        return self.searchData.count;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_menuTableView dequeueReusableCellWithIdentifier:CellIdentifier];

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
    
    
    //    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"check_box.jpeg"];
    if (self.searchData.count) {
        [(UILabel *)[cell.contentView viewWithTag:1] setText:self.searchData[indexPath.row]];
    }
    
    return cell;
}

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
    
    if (self.searchData.count) {
        
        // keep track of the last selected cell
        self.lastSelected = indexPath;
        _menuSelected = self.searchData[indexPath.row];
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
                                        NSString *menus = [dic valueForKeyPath:@"response.menu.menus.count"];
                              
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
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            [_menuTableView reloadData];

        } else {
            
            //got all events back from server -- update table view

            NSMutableArray *array1 = [NSMutableArray new];
            
            if (objectsOrNil.count>0) {
                YookaBackend *yooka = objectsOrNil[0];
                array1 = [NSMutableArray arrayWithArray:yooka.menu_list];
                [array1 addObjectsFromArray:self.menuObjects];
                self.menuObjects = array1;
                self.searchData = self.menuObjects;
                
                NSLog(@"array 1 = %@",self.searchData);
                
                [self.menuTableView reloadData];
            }else{
                self.searchData = self.menuObjects;
                NSLog(@"array 2 = %@",self.searchData);

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
