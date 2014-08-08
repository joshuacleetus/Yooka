//
//  UserFollowingViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 3/3/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "UserFollowingViewController.h"
#import "BDViewController2.h"
#import <AsyncImageDownloader.h>
#import <Reachability.h>
#import "UIImageView+WebCache.h"
#import "YookaClickProfileViewController.h"
#import "YookaProfileNewViewController.h"

@interface UserFollowingViewController ()

@end

@implementation UserFollowingViewController

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
    [self.navigationItem setTitle:@"FOLLOWING"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 15, 220, 40)];
    self.titleLabel.textColor = [UIColor grayColor];
    self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:20.0];
    self.titleLabel.text = @"FOLLOWING";
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.titleLabel];
    
    _followingUsersPicUrls = [NSMutableArray new];
    _followingUsersFullNames = [NSMutableArray new];
    _followingUsersData = [NSMutableArray new];
    
    _backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 20, 25, 25)];
    _backBtnImage.image = [UIImage imageNamed:@"back_artisse_3.png"];
    [self.view addSubview:_backBtnImage];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setFrame:CGRectMake(10, 20, 40, 40)];
    [_backBtn setTitle:@"" forState:UIControlStateNormal];
    [_backBtn setBackgroundColor:[UIColor clearColor]];
    //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
    self.followingTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 60.f, 320.f, self.view.frame.size.height-60)];
    self.followingTableView.delegate = self;
    self.followingTableView.dataSource = self;
    [self.followingTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    //    _locationTableView.backgroundColor = [UIColor blackColor];
    //    [_locationTableView setSeparatorColor:[UIColor whiteColor]];
    [self.view addSubview:self.followingTableView];
    
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
        
            [self findFollowingUsers];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (void)back
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    // NSLog(@"%s: controller.view.window=%@", _func_, controller.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)findFollowingUsers{
    
    self.userFollowing = [NSMutableArray new];
    
        _collectionName1 = @"userPicture";
        _customEndpoint1 = @"NewsFeed";
        _fieldName1 = nil;
        self.userEmail = [KCSUser activeUser].email;

        _dict = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",self.followingUsers,@"followingUsers",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
    
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict completionBlock:^(id results, NSError *error){
            
            if (results) {
                
                if ([results isKindOfClass:[NSArray class]]){
                     self.userFollowing = [NSMutableArray arrayWithArray:results];

                }
                
                if (self.userFollowing.count>0) {
                    [self.followingTableView reloadData];
                    [self.followingTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                }

            }
            
        }];

    
}

- (void)findFollowingUsers2{
    
    if (j<_followingUsers.count) {
        //NSLog(@"j = %d",j);
        
        _followingUserEmail = _followingUsers[j];
        //NSLog(@"email = %@",_followingUserEmail);
        _collectionName1 = @"userPicture";
        _customEndpoint1 = @"NewsFeed";
        _dict = [[NSDictionary alloc]initWithObjectsAndKeys:_followingUserEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
                //NSLog(@"Results = \n %@",results);
                NSMutableArray *results_array = [NSMutableArray arrayWithArray:results];
                if (results_array && results_array.count) {
                    _followingUserFullName = [results[0] objectForKey:@"userFullName"];
                    _followingUserPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                    [_followingUsersData addObject:results];
                    [_followingUsersFullNames addObject:_followingUserFullName];
                
                    if (_followingUserPicUrl) {
                        [_followingUsersPicUrls addObject:_followingUserPicUrl];
                    }else{
                        NSString *url = [NSString stringWithFormat:@"http://s25.postimg.org/4qq1lj6nj/minion.jpg"];
                        [_followingUsersPicUrls addObject:url];
                    }
                    [self.followingTableView reloadData];
                    [self.followingTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
                    j++;
                    [self findFollowingUsers2];
                }else{
                    j++;
                    [self findFollowingUsers2];
                }
                
            }else{
                j++;
                [self findFollowingUsers2];
            }
        }];
        
    }
    
    if (j==_followingUsers.count) {
        
        // NSLog(@"array = %@, array 2 = %@, array3 = %@",_followingUsersData,_followingUsersFullNames,_followingUsersPicUrls);
        [self.followingTableView reloadData];
        [self.followingTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
        
    }
    
}

- (IBAction)textFieldDone:(id)sender
{
    NSString *s = [_textField text];
    //NSLog(@"search %@",s);
    
    NSArray* firstLastStrings = [s componentsSeparatedByString:@" "];
    
    if (firstLastStrings.count>1) {
        _firstName = [firstLastStrings objectAtIndex:0];
        _lastName = [firstLastStrings objectAtIndex:1];
        
        [KCSUserDiscovery lookupUsersForFieldsAndValues:@{ KCSUserAttributeGivenname : _firstName,KCSUserAttributeSurname : _lastName}
                                        completionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                                            if (errorOrNil == nil) {
                                                //array of matching KCSUser objects
                                                if (objectsOrNil && objectsOrNil.count) {
                                                    //NSLog(@"Found %lu Joshua", (unsigned long)objectsOrNil.count);
                                                    _userFollowing = [NSMutableArray arrayWithArray:objectsOrNil];
                                                    //KCSUser *user = _userFollowing[0];
                                                   // NSLog(@"Found users = %@ %@", user.givenName,user.surname);
                                                }

                                            } else {
                                                //NSLog(@"Got An error: %@", errorOrNil);
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
                                                    //NSLog(@"Found %lu %@", (unsigned long)objectsOrNil.count,s);
                                                    _results = [NSMutableArray arrayWithArray:objectsOrNil];
                                                    if (_results && _results.count) {
                                                        [self userSearchNames];
                                                    }
                                                    //NSLog(@"Found users = %@", _userFollowing);
                                                }

                                            } else {
                                                //NSLog(@"Got An error: %@", errorOrNil);
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
    
    [self.followingTableView reloadData];
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
    if (self.userFollowing.count>0) {
        return self.userFollowing.count;
    }
    return 1;
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
    UITableViewCell *cell = [self.followingTableView dequeueReusableCellWithIdentifier:CellIdentifier];

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
    
    if (self.userFollowing.count>0 && (indexPath.row<self.userFollowing.count)) {
        
        
        NSString *user_fullname;
        NSString *userPicUrl;
        
            user_fullname = [self.userFollowing[indexPath.row] objectForKey:@"userFullName"];
            userPicUrl = [[self.userFollowing[indexPath.row] objectForKey:@"userImage"] objectForKey:@"_downloadURL"];
        
        if (user_fullname) {
            [(UILabel *)[cell.contentView viewWithTag:1] setText:user_fullname];
        }
        
        
        if (userPicUrl) {
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
                     // do something with image
//                     CGSize size = CGSizeMake(35.0, 35.0);
//                     UIGraphicsBeginImageContext( size );
//                     [image drawInRect:CGRectMake(0,0,size.width,size.height)];
//                     UIImage* thumb = UIGraphicsGetImageFromCurrentImageContext();
//                     UIGraphicsEndImageContext();
                     
                     UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10.0,5.0, 35.0, 35.0)];
                     imv.image=image;
                     [imv.layer setCornerRadius:imv.frame.size.width/2];
                     [imv setClipsToBounds:YES];
                     [imv setContentMode:UIViewContentModeScaleAspectFill];
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
        }

    }else{
        [(UILabel *)[cell.contentView viewWithTag:1] setText:@"        No users found."];
        
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10,5, 35, 35)];
        [imv setBackgroundColor:[UIColor whiteColor]];
        [cell.contentView addSubview:imv];
    }
    
    return cell;
    
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
    
        _userEmailSelected = [self.userFollowing[indexPath.row] objectForKey:@"userEmail"];
        _userFullNameSelected = [self.userFollowing[indexPath.row] objectForKey:@"userFullName"];
        _userPicUrlSelected = [[self.userFollowing[indexPath.row] objectForKey:@"userImage"] objectForKey:@"_downloadURL"];
        [self userDidSelectUser];
    
}

- (void)userDidSelectUser
{
    
    NSString *userId = _userEmailSelected;
    NSString *userFullName = _userFullNameSelected;
    NSString *userPicUrl = _userPicUrlSelected;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    if ([userId isEqual:[KCSUser activeUser].email]){
        
        YookaProfileNewViewController *media2 = [[YookaProfileNewViewController alloc]init];
        media2.userEmail = [KCSUser activeUser].email;
        media2.myEmail = [KCSUser activeUser].email;
        media2.userPicUrl = userPicUrl;
        [self presentViewController:media2 animated:NO completion:nil];
        
    }else{
        
        YookaClickProfileViewController *media = [[YookaClickProfileViewController alloc]init];
        media.userFullName = userFullName;
        media.myEmail = userId;
        media.myURL =userPicUrl;
        [self presentViewController:media animated:NO completion:nil];
        
    }
    
}

- (void)backAction
{
    //NSLog(@"BACK BUTTON");
}


@end
