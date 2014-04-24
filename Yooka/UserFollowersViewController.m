//
//  UserFollowersViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 3/3/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "UserFollowersViewController.h"
#import "BDViewController2.h"
#import <AsyncImageDownloader.h>
#import <Reachability.h>
#import "UIImageView+WebCache.h"

@interface UserFollowersViewController ()

@end

@implementation UserFollowersViewController

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
    j=0;
    [self.navigationItem setTitle:@"FOLLOWERS"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _followersPicUrls = [NSMutableArray new];
    _followersFullNames = [NSMutableArray new];
    _followersData = [NSMutableArray new];
    
    //    NSLog(@"%@",_followingUsers);
    
    //    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 65, 280, 45)];
    //    _textField.borderStyle = UITextBorderStyleRoundedRect;
    //    _textField.font = [UIFont fontWithName:@"UbuntuTitling-Bold" size:23];
    //    _textField.textColor = [UIColor lightGrayColor];
    //    UIColor *color = [UIColor lightGrayColor];
    //    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"             🔍 Find a user" attributes:@{NSForegroundColorAttributeName: color}];
    //    _textField.backgroundColor = [UIColor whiteColor];
    //    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    //    _textField.keyboardType = UIKeyboardTypeDefault;
    //    _textField.returnKeyType = UIReturnKeySearch;
    //    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [_textField addTarget:self
    //                   action:@selector(textFieldDone:)
    //         forControlEvents:UIControlEventEditingDidEndOnExit];
    //    [self.view addSubview:_textField];
    
    self.followerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height)];
    self.followerTableView.delegate = self;
    self.followerTableView.dataSource = self;
    [self.followerTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    //    _locationTableView.backgroundColor = [UIColor blackColor];
    //    [_locationTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:self.followerTableView];
    
    //    self.followingSearch = [[UISearchBar alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
    //    self.followingSearch.showsCancelButton = NO;
    //    self.followingSearch.delegate = self;
    //    self.followingSearch.placeholder = @"Find a user";
    //    self.followingSearch.autocorrectionType=UITextAutocorrectionTypeNo;
    //    self.followingSearch.autocapitalizationType=UITextAutocapitalizationTypeNone;
    //    self.followingTableView.tableHeaderView = self.followingSearch;
    //    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.followingSearch contentsController:self];
    //    searchDisplayController.delegate = self;
    //    searchDisplayController.searchResultsDataSource = self;
    //    [searchDisplayController setSearchResultsDelegate:self];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    [self findFollowers];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (void)findFollowers{
    
    if (j<_followers.count) {
//        NSLog(@"j = %d",j);
        
        _followerEmail = _followers[j];
//        NSLog(@"email = %@",_followerEmail);
        _collectionName1 = @"userPicture";
        _customEndpoint1 = @"NewsFeed";
        _dict = [[NSDictionary alloc]initWithObjectsAndKeys:_followerEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
//                NSLog(@"Results = \n %@",results);
                NSMutableArray *results_array = [NSMutableArray arrayWithArray:results];
                if (results_array && results_array.count) {
                    _followerFullName = [results[0] objectForKey:@"userFullName"];
                    _followerPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                    [_followersData addObject:results];
                    [_followersFullNames addObject:_followerFullName];
                    [_followersPicUrls addObject:_followerPicUrl];
                    [self.followerTableView reloadData];
                    [self.followerTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    j++;
                    [self findFollowers];
                }else{
                    j++;
                    [self findFollowers];
                }
                
            }else{
                j++;
                [self findFollowers];
            }
        }];
        
    }
    
    if (j==_followers.count) {
        
//        NSLog(@"array = %@, array 2 = %@, array3 = %@",_followersData,_followersFullNames,_followersPicUrls);
        [self.followerTableView reloadData];
        [self.followerTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }
    
}

- (IBAction)textFieldDone:(id)sender
{
    NSString *s = [_textField text];
//    NSLog(@"search %@",s);
    
    NSArray* firstLastStrings = [s componentsSeparatedByString:@" "];
    
    if (firstLastStrings.count>1) {
        _firstName = [firstLastStrings objectAtIndex:0];
        _lastName = [firstLastStrings objectAtIndex:1];
        
        [KCSUserDiscovery lookupUsersForFieldsAndValues:@{ KCSUserAttributeGivenname : _firstName,KCSUserAttributeSurname : _lastName}
                                        completionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                            if (errorOrNil == nil) {
                                                //array of matching KCSUser objects
//                                                NSLog(@"Found %lu Joshua", (unsigned long)objectsOrNil.count);
                                                if (objectsOrNil && objectsOrNil.count) {
                                                    _userFollowing = [NSMutableArray arrayWithArray:objectsOrNil];
                                                }
//                                                KCSUser *user = _userFollowing[0];
//                                                NSLog(@"Found users = %@ %@", user.givenName,user.surname);
                                                
                                            } else {
//                                                NSLog(@"Got An error: %@", errorOrNil);
                                            }
                                        }
                                          progressBlock:nil];
    }else{
        _firstName = s;
        _lastName=nil;
        
        [KCSUserDiscovery lookupUsersForFieldsAndValues:@{ KCSUserAttributeGivenname : _firstName}
                                        completionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                            if (errorOrNil == nil) {
                                                if (objectsOrNil && objectsOrNil.count) {
                                                    //array of matching KCSUser objects
//                                                    NSLog(@"Found %lu %@", (unsigned long)objectsOrNil.count,s);
                                                    _results = [NSMutableArray arrayWithArray:objectsOrNil];
                                                    if (_results && _results.count) {
                                                        [self userSearchNames];
                                                    }
//                                                    NSLog(@"Found users = %@", _userFollowing);
                                                }

                                            } else {
//                                                NSLog(@"Got An error: %@", errorOrNil);
                                            }
                                        }
                                          progressBlock:nil];
    }
    
}

- (void)userSearchNames
{
    for (int i=0; i<_results.count; i++) {
        
        KCSUser *user = _userFollowing[i];
        [_userFollowingEmail addObject:user.username];
        NSString *fullName = [NSString stringWithFormat:@"%@ %@",user.givenName,user.surname];
        [_userFollowingFullName addObject:fullName];
        
    }
    
    [self.followerTableView reloadData];
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
    if (self.followersData.count) {
        return self.followersData.count;
    }else{
        return 0;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.followerTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        // create a custom label:                                        x    y   width  height
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake( 55.0, 0.0, 240.0, 50.0)];
        [_descriptionLabel setTag:1];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        _descriptionLabel.textColor = [UIColor grayColor];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        [_descriptionLabel setFont:[UIFont systemFontOfSize:16.0]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:_descriptionLabel];
        
    }
    
    [(UILabel *)[cell.contentView viewWithTag:1] setText:self.followersFullNames[indexPath.row]];
    
    _userPicUrl = _followersPicUrls[indexPath.row];
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:_userPicUrl]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
     }
                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
     {
         if (image && finished)
         {
             // do something with image
        CGSize size = CGSizeMake(40.0, 40.0);
        UIGraphicsBeginImageContext( size );
        [image drawInRect:CGRectMake(0,0,size.width,size.height)];
        UIImage* thumb = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10.0,5.0, 40.0, 40.0)];
        imv.image=thumb;
        [imv.layer setCornerRadius:imv.frame.size.width/2];
        [imv setClipsToBounds:YES];
        [imv setContentMode:UIViewContentModeCenter];
        [cell.contentView addSubview:imv];
        //        NSLog(@"profile image");
             
         }
     }];
    
    return cell;
    
    [self.followerTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (self.lastSelected==indexPath) return; // nothing to do
    //
    //    // deselect old
    //    UITableViewCell *old = [locationTableView cellForRowAtIndexPath:self.lastSelected];
    //    old.accessoryType = UITableViewCellAccessoryNone;
    //    old.backgroundColor = [UIColor blackColor];
    //    [old setSelected:FALSE animated:TRUE];
    //
    //    // select new
    //    UITableViewCell *cell = [locationTableView cellForRowAtIndexPath:indexPath];
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //    cell.backgroundColor = [UIColor purpleColor];
    //    [cell setSelected:TRUE animated:TRUE];
    
    [_textField resignFirstResponder];
    
    // keep track of the last selected cell
    self.lastSelected = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _userEmailSelected = _followers[indexPath.row];
    _userFullNameSelected = _followersFullNames[indexPath.row];
    _userPicUrlSelected = _followersPicUrls[indexPath.row];
    
    [self userDidSelectUser];
    
    [_followerTableView reloadData];
    
}

- (void)userDidSelectUser
{
    BDViewController2 *media = [[BDViewController2 alloc]init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationItem setBackBarButtonItem: backBtn];
    media.userFullName = _userFullNameSelected;
    media.userEmail = _userEmailSelected;
    media.userPicUrl = _userPicUrlSelected;
    [self.navigationController pushViewController:media animated:YES];
}

- (void)backAction
{
    NSLog(@"BACK BUTTON");
}

@end
