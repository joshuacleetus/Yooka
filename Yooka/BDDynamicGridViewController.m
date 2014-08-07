//
//  BDDynamicGridViewController.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/23/12.
//
//  Copyright (c) 2012, Norsez Orankijanan (Bluedot) All Rights Reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, 
//  this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, 
//  this list of conditions and the following disclaimer in the documentation 
//  and/or other materials provided with the distribution.
//
//  3. Neither the name of Bluedot nor the names of its contributors may be used 
//  to endorse or promote products derived from this software without specific
//  prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//  POSSIBILITY OF SUCH DAMAGE.

#import "BDDynamicGridViewController.h"
#import "BDDynamicGridCell.h"
#import "BDRowInfo.h"
#import <AsyncImageDownloader.h>
#import "UserFollowingViewController.h"
#import "UserFollowersViewController.h"
#import "YookaBackend.h"
#import "UIImageView+WebCache.h"

#define kDefaultBorderWidth 5



@interface BDDynamicGridViewController  () <UITableViewDelegate, UITableViewDataSource,UIScrollViewAccessibilityDelegate,UIScrollViewDelegate>{
    UITableView *_tableView;
    NSArray *_rowInfos;
}
@end

@implementation BDDynamicGridViewController
- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {}
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
//    _gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
//    _gridScrollView.contentSize= self.view.bounds.size;
//    _gridScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
//    [self.view addSubview:_gridScrollView];
//    
//    if ([[UIScreen mainScreen] bounds].size.height == 568) {
//        [_gridScrollView setContentSize:CGSizeMake(320, 700)];
//    }else{
//        [_gridScrollView setContentSize:CGSizeMake(320, 500)];
//    }
    
    self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{
                                                                 KCSStoreKeyCollectionName : @"userPicture",
                                                                 KCSStoreKeyCollectionTemplateClass : [YookaBackend class]}];
    
    _userEmail = [[KCSUser activeUser] email];

    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.borderWidth = kDefaultBorderWidth;
    self.view.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view insertSubview:_tableView atIndex:0];
    _tableView.frame = self.view.bounds;
    
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 213)];
    
    _profile_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 208)];
    [self.profile_bg setImage:[self blur:[UIImage imageNamed:@"profile_bg@2x.png"]]];
    [_headerView addSubview:_profile_bg];
    
    _profileLbl1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 176, 320, 32)];
    [_profileLbl1 setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [_headerView addSubview:_profileLbl1];
    
    _profile_bg1 = [[UIImageView alloc]initWithFrame:CGRectMake(9, 187, 228, 9)];
    _profile_bg1.image = [UIImage imageNamed:@"profile_icons.png"];
    [_headerView addSubview:_profile_bg1];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData* imageData = [ud objectForKey:@"MyProfilePic"];
    UIImage *image = [UIImage imageWithData:imageData];
    
    _userView = [[UIImageView alloc]initWithFrame:CGRectMake(115, 29, 90, 90)];
    self.userView.layer.cornerRadius = self.userView.frame.size.height / 2;
    [self.userView.layer setBorderWidth:4.0];
    [self.userView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.userView setContentMode:UIViewContentModeScaleAspectFill];
    [self.userView setClipsToBounds:YES];
    if (image) {
        [self.userView setImage:image];
    }
    [_headerView addSubview:_userView];
    
    self.circle_one = [[UIView alloc]initWithFrame:CGRectMake(105, 19, 110, 110)];
    self.circle_one.layer.cornerRadius = self.circle_one.frame.size.height / 2;
    [self.circle_one.layer setBorderWidth:4.0];
    [self.circle_one.layer setBorderColor:[[[UIColor whiteColor]colorWithAlphaComponent:0.10f] CGColor]];
    [_headerView addSubview:self.circle_one];
    
    self.circle_two = [[UIView alloc]initWithFrame:CGRectMake(95, 9, 130, 130)];
    self.circle_two.layer.cornerRadius = self.circle_two.frame.size.height / 2;
    [self.circle_two.layer setBorderWidth:4.0];
    [self.circle_two.layer setBorderColor:[[[UIColor whiteColor]colorWithAlphaComponent:0.10f] CGColor]];
    [_headerView addSubview:self.circle_two];
    
    _usernameLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 142, 280, 24)];
    _usernameLbl.textColor = [UIColor whiteColor];
    _usernameLbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    _usernameLbl.text = _userFullName;
    _usernameLbl.textAlignment = NSTextAlignmentCenter;
    [_headerView addSubview:_usernameLbl];
    
    _cacheFollowingUsers = [NSMutableArray new];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _cacheFollowingUsers = [[defaults objectForKey:@"followingUserNames"]mutableCopy];
    
    _userFollowingLbl = [[UILabel alloc]initWithFrame:CGRectMake(26, 183, 85, 17)];
    _userFollowingLbl.textColor = [UIColor whiteColor];
    if (_cacheFollowingUsers.count>0) {
        NSString *following_count = [NSString stringWithFormat:@"%lu Following",(unsigned long)_cacheFollowingUsers.count];
        _userFollowingLbl.text = following_count;
        [self findFollowingUsers];
    }else{
        _userFollowingLbl.text = @"0 Following";
    }
    _userFollowingLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
    _userFollowingLbl.textAlignment = NSTextAlignmentLeft;
    [_headerView addSubview:_userFollowingLbl];
    
    _userpicturesLbl = [[UILabel alloc]initWithFrame:CGRectMake(137, 183, 85, 17)];
    _userpicturesLbl.textColor = [UIColor whiteColor];
    _userpicturesLbl.text = @"0 Pictures";
    _userpicturesLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
    _userpicturesLbl.textAlignment = NSTextAlignmentLeft;
    [_headerView addSubview:_userpicturesLbl];
    
    _cacheFollowers = [NSMutableArray new];
    _cacheFollowers = [[defaults objectForKey:@"followers"]mutableCopy];
    
    _userFollowersLbl = [[UILabel alloc]initWithFrame:CGRectMake(245, 183, 85, 17)];
    _userFollowersLbl.textColor = [UIColor whiteColor];
    if (_cacheFollowers.count>0) {
        NSString *followers_count = [NSString stringWithFormat:@"%lu Followers",(unsigned long)_cacheFollowers.count];
        _userFollowersLbl.text = followers_count;
    }else{
        _userFollowersLbl.text = @"0 Followers";
    }
    _userFollowersLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
    _userFollowersLbl.textAlignment = NSTextAlignmentLeft;
    [_headerView addSubview:_userFollowersLbl];
    
    _tableView.tableHeaderView = _headerView;
    
    [self reloadData];
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.isOpen) {
        //        NSLog(@"Found a cached session");
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 //                      NSLog(@"username = %@",user.name);
                 //                      NSLog(@"user email = %@",[user objectForKey:@"email"]);
                 _userName = user.username;
                 _userFullName = user.name;
                 [self.navigationItem setTitle:[_userFullName uppercaseString]];
                 _userPicUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", _userName];
                 _userEmail = [user objectForKey:@"email"];
                 //                      NSLog(@"user pic url = %@",_userPicUrl);
                 [self getUserImage];
                 
                 _usernameLbl.text = _userFullName;
                 
             }
         }];
        
        // If there's no cached session, we will show a login button
    } else {
        //        NSLog(@"Cannot found a cached session");
        _userEmail = [[KCSUser activeUser] email];
        _userFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
        _usernameLbl.text = _userFullName;
        [self.navigationItem setTitle:[_userFullName uppercaseString]];
        _collectionName1 = @"userPicture";
        _customEndpoint1 = @"NewsFeed";
        _fieldName1 = @"_id";
        _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
                
                NSArray *results_array = [NSArray arrayWithArray:results];
                
                if (results_array && results_array.count) {
                    //                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                    _userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                    
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
                            _userImage = image;
                            _userView.image = image;
                             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                             [defaults setObject:UIImagePNGRepresentation(image) forKey:@"MyProfilePic"];
                             [defaults synchronize];
                            [_headerView addSubview:_userView];
                            //                            NSLog(@"profile image");
                            
                         }
                     }];
                    
                }else{
                    
                    _userPicUrl = @"http://s25.postimg.org/4qq1lj6nj/minion.jpg";
                    
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
                            _userImage = image;
                            _userView.image = image;
                             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                             [defaults setObject:UIImagePNGRepresentation(image) forKey:@"MyProfilePic"];
                             [defaults synchronize];
                            [_headerView addSubview:_userView];
                            //                            NSLog(@"profile image");
                            
                         }
                     }];
                    
                }
                
            }else{
                
                _userPicUrl = @"http://s25.postimg.org/4qq1lj6nj/minion.jpg";

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
                        _userImage = image;
                        _userView.image = image;
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         [defaults setObject:UIImagePNGRepresentation(image) forKey:@"MyProfilePic"];
                         [defaults synchronize];
                        [_headerView addSubview:_userView];
                        //                            NSLog(@"profile image");
                        
                     }
                 }];
            }
        }];
        
    }
    
    _userFollowingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userFollowingBtn  setFrame:CGRectMake(9, 179, 95, 25)];
    [_userFollowingBtn setBackgroundColor:[UIColor clearColor]];
    [_userFollowingBtn addTarget:self action:@selector(userFollowing:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:_userFollowingBtn];
    
    _userFollowersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userFollowersBtn  setFrame:CGRectMake(225, 179, 90, 25)];
    [_userFollowersBtn setBackgroundColor:[UIColor clearColor]];
    [_userFollowersBtn addTarget:self action:@selector(userFollowers:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:_userFollowersBtn];
    
    [self getFollowingUsers];
    [self getFollowerUsers];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _tableView = nil;
}

- (void)getUserImage
{
    [[[AsyncImageDownloader alloc] initWithMediaURL:_userPicUrl successBlock:^(UIImage *image)  {
        
        _userImage = image;
        _userView.image = image;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:UIImagePNGRepresentation(image) forKey:@"MyProfilePic"];
        [defaults synchronize];
        
        //        [self.userView.layer setCornerRadius:self.userView.frame.size.width/2];
        //        [self.userView setClipsToBounds:YES];
        [self.gridScrollView addSubview:_userView];
        //        NSLog(@"profile image");
        [self saveUserImage];
    } failBlock:^(NSError *error) {
        //        NSLog(@"Failed to download image due to %@!", error);
    }] startDownload];
}

- (void)saveUserImage
{
    
    //NSLog(@"profile image");
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _userEmail;
    if (_userImage) {
        yookaObject.userImage = _userImage;
    }else{
        yookaObject.userImage = [UIImage imageNamed:@"minion.jpg"];
    }
    yookaObject.userFullName = _userFullName;
    yookaObject.userEmail = _userEmail;
    
    //Kinvey use code: add a new update to the updates collection
    [self.updateStore saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            //NSLog(@"saved successfully");
        } else {
            //NSLog(@"save failed %@",errorOrNil);
        }
    } withProgressBlock:nil];
    
    
}

- (void)userFollowing:(id)sender
{
    //NSLog(@"Following Button pressed");
    UserFollowingViewController *media = [[UserFollowingViewController alloc]init];
    //    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //    self.navigationItem.backBarButtonItem = backBtn;
    //    [self.navigationItem setBackBarButtonItem: backBtn];
    media.userFullName = _userFullName;
    media.followingUsers = _followingUsers;
    [self.navigationController pushViewController:media animated:YES];
}

- (void)userFollowers:(id)sender
{
    //NSLog(@"Followers Button pressed");
    UserFollowersViewController *media = [[UserFollowersViewController alloc]init];
    //    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //    self.navigationItem.backBarButtonItem = backBtn;
    //    [self.navigationItem setBackBarButtonItem: backBtn];
    media.userFullName = _userFullName;
    media.followers = _followerUsers;
    [self.navigationController pushViewController:media animated:YES];
}

- (void)getFollowingUsers
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:_userEmail];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            //            _unsubscribedHunts = _featuredHunts;
            //            [self modifyFeaturedHunts];
        } else {
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
                
            } else {
                YookaBackend *yooka = objectsOrNil[0];
                
                _followingUsers = [NSMutableArray arrayWithArray:yooka.following_users];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_followingUsers forKey:@"followingUserNames"];
                [defaults synchronize];
                [_userFollowingLbl removeFromSuperview];
                _cacheFollowingUsers = _followingUsers;
                l=0;
                _userFollowingLbl = [[UILabel alloc]initWithFrame:CGRectMake(26, 183, 85, 17)];
                _userFollowingLbl.textColor = [UIColor whiteColor];
                NSString *followingCount = [NSString stringWithFormat:@"%lu Following",(unsigned long)_followingUsers.count];
                _userFollowingLbl.text = followingCount;
                _userFollowingLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
                _userFollowingLbl.textAlignment = NSTextAlignmentLeft;
                [_headerView addSubview:_userFollowingLbl];
            }
            
        }
    } withProgressBlock:nil];
}

- (void)getFollowerUsers
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:_userEmail];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            //            _unsubscribedHunts = _featuredHunts;
            //            [self modifyFeaturedHunts];
        } else {
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
                
            } else {
                YookaBackend *yooka = objectsOrNil[0];
                
                _followerUsers = [NSMutableArray arrayWithArray:yooka.followers];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_followerUsers forKey:@"followers"];
                [defaults synchronize];
                _cacheFollowers = _followerUsers;
                [_userFollowersLbl removeFromSuperview];
                
                _userFollowersLbl = [[UILabel alloc]initWithFrame:CGRectMake(245, 183, 85, 17)];
                _userFollowersLbl.textColor = [UIColor whiteColor];
                NSString *followersCount = [NSString stringWithFormat:@"%lu Followers",(unsigned long)_followerUsers.count];
                _userFollowersLbl.text = followersCount;
                _userFollowersLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
                _userFollowersLbl.textAlignment = NSTextAlignmentLeft;
                [_headerView addSubview:_userFollowersLbl];
            }
            
        }
    } withProgressBlock:nil];
}

- (void)getMyPosts
{
    _collectionName1 = @"yookaPosts";
    _customEndpoint1 = @"NewsFeed";
    _fieldName1 = @"postDate";
    //    NSString *huntName = @"";
    //    NSString *venueName = @"";
    //    huntName,@"huntName",venueName,@"venueName"
    _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
    
    [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
        if ([results isKindOfClass:[NSArray class]]) {
            _myPosts = [NSMutableArray arrayWithArray:results];
            if (_myPosts && _myPosts.count) {
                //                NSLog(@"%@",_myPosts);
                
//                [self fillPictures];
                
            }else{
                //                NSLog(@"User Search Results = \n %@",results);
                
            }
            
        }
    }];
}

- (void)findFollowingUsers{
    
    if (l<_cacheFollowingUsers.count) {
        
        NSString *followingUserEmail = _cacheFollowingUsers[j];
        NSString *collection_name = @"userPicture";
        NSString *custom_endpoint = @"NewsFeed";
        NSDictionary *_dict = [[NSDictionary alloc]initWithObjectsAndKeys:followingUserEmail,@"userEmail",collection_name,@"collectionName",_fieldName1,@"fieldName", nil];
        
        [KCSCustomEndpoints callEndpoint:custom_endpoint params:_dict completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
                //NSLog(@"Results = \n %@",results);
                NSMutableArray *results_array = [NSMutableArray arrayWithArray:results];
                if (results_array && results_array.count) {
                    NSString *user_full_name = [results[0] objectForKey:@"userFullName"];
                    NSString *user_pic_url = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                    
                    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:user_pic_url]
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
                             NSLog(@"yes.... image....");
                             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                             [defaults setObject:user_full_name forKey:_cacheFollowingUsers[l]];
                             NSString *userId3 = [NSString stringWithFormat:@"%@%@%@",_cacheFollowingUsers[l],_cacheFollowingUsers[l],_cacheFollowingUsers[l]];
                             [defaults setObject:UIImagePNGRepresentation(image) forKey:userId3];
                             [defaults synchronize];
                             
                             l++;
                             [self findFollowingUsers];
                             
                         }else{
                             l++;
                             [self findFollowingUsers];
                         }
                     }];
                    

                    
                }else{
                    
                    l++;
                    [self findFollowingUsers];
                    
                }
                
            }else{
                
                l++;
                [self findFollowingUsers];
                
            }
        }];
        
    }
    
    if (j==_followingUsers.count) {
        

        
    }
    
}

- (BOOL)shouldAutorotate
{
    [_tableView reloadData];
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    [_tableView reloadData];
    return [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)setBackgroundColor:(UIColor *)color
{
    _tableView.backgroundColor = color;
}

- (UIImage*) blur:(UIImage*)theImage
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    return [UIImage imageWithCGImage:cgImage];
    
    // if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

#pragma mark - Table view data source

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIImage *myImage = [UIImage imageNamed:@"loginHeader.png"];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:myImage];
//    imageView.frame = CGRectMake(10,10,300,100);
//    
//    return imageView;
//    
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowInfos.count;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 213;
//}

- (NSArray *)rowInfos
{
    NSArray *result = [NSArray array];
    for (BDRowInfo* rowInfo in _rowInfos) {
        result = [result arrayByAddingObject:[rowInfo copy]];
    }
    return _rowInfos;
}

- (NSArray *)visibleRowInfos
{
    NSArray *indexPaths = [_tableView indexPathsForVisibleRows];
    NSArray *result = [NSArray array];
    for (NSIndexPath *idp in indexPaths) {
        BDRowInfo *rowInfo = [_rowInfos objectAtIndex:idp.row];
        result = [result arrayByAddingObject:[rowInfo copy]];
    }
    return result;
}

- (void)reloadRows:(NSArray *)rowInfos
{
    NSArray *indexPaths = [NSArray array];
    for (BDRowInfo *row in rowInfos) {
        indexPaths = [indexPaths arrayByAddingObject: [NSIndexPath indexPathForRow:row.order inSection:0]];
    }
    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadData
{
    if (self.delegate == nil) {
        return;
    }
    
    if (![self.delegate respondsToSelector:@selector(customLayout)]) {
        //rearrange views on the table by recalculating row infos
        _rowInfos = [NSArray new];
        NSUInteger accumNumOfViews = 0;
        BDRowInfo * ri;
        NSUInteger kMaxViewsPerCell = self.delegate.maximumViewsPerCell;
        NSAssert(kMaxViewsPerCell>0, @"Maximum number of views per cell must be greater than zero");
        NSUInteger kMinViewsPerCell = 1;
        
        if ([self.delegate respondsToSelector:@selector(minimumViewsPerCell)]) {
            kMinViewsPerCell = self.delegate.minimumViewsPerCell==0?1:self.delegate.minimumViewsPerCell;
        }
        
        NSAssert(kMinViewsPerCell <= kMaxViewsPerCell, @"Minimum number of views per row cannot be greater than maximum number of views per row.");
        
        while (accumNumOfViews < self.delegate.numberOfViews) {
            NSUInteger numOfViews = (arc4random() % kMaxViewsPerCell) + kMinViewsPerCell;
            if (numOfViews > kMaxViewsPerCell) {
                numOfViews = kMaxViewsPerCell;
            }
            numOfViews = (accumNumOfViews+numOfViews <= self.delegate.numberOfViews)?numOfViews:(self.delegate.numberOfViews-accumNumOfViews);
            ri = [BDRowInfo new];
            ri.order = _rowInfos.count;
            ri.accumulatedViews = accumNumOfViews;
            ri.viewsPerCell = numOfViews;
            accumNumOfViews = accumNumOfViews + numOfViews;
            _rowInfos = [_rowInfos arrayByAddingObject:ri];
        }
        ri.isLastCell = YES;
        NSAssert(accumNumOfViews == self.delegate.numberOfViews, @"wrong accum %lu ", (unsigned long)ri.accumulatedViews);
    }else{
        _rowInfos = [self.delegate customLayout];
    }
    [_tableView reloadData];
}

- (void)reloadDataWithGridPattern:(NSArray *)gridPattern
{
    if  (gridPattern.count == 0){
        [self reloadData];
        return;
    }else {
        //rearrange views on the table by recalculating row infos
        _rowInfos = [NSArray new];
        NSUInteger accumNumOfViews = 0;
        BDRowInfo * ri;
        
        int patternIndex = 0;
        while (accumNumOfViews < self.delegate.numberOfViews) {
            NSNumber* number  = [gridPattern objectAtIndex:(patternIndex++)%gridPattern.count];
            NSAssert(number.integerValue != 0, @"Grid pattern can't contains a zero size row.");
            NSUInteger numOfViews = number.integerValue;
            numOfViews = (accumNumOfViews+numOfViews <= self.delegate.numberOfViews)?numOfViews:(self.delegate.numberOfViews-accumNumOfViews);
            ri = [BDRowInfo new];
            ri.order = _rowInfos.count;
            ri.accumulatedViews = accumNumOfViews;
            ri.viewsPerCell = numOfViews;
            accumNumOfViews = accumNumOfViews + numOfViews;
            _rowInfos = [_rowInfos arrayByAddingObject:ri];
        }
        ri.isLastCell = YES;
        NSAssert(accumNumOfViews == self.delegate.numberOfViews, @"wrong accum %lu ", (unsigned long)ri.accumulatedViews);
        [_tableView reloadData];
    }
}


- (void)updateLayoutWithRow:(BDRowInfo *)rowInfo animiated:(BOOL)animated
{
    BDDynamicGridCell *cell = (BDDynamicGridCell*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowInfo.order inSection:0]];
    [cell layoutSubviewsAnimated:animated];
}

- (void)scrollToRow:(BDRowInfo *)row atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row.order
                                                         inSection:0]
                      atScrollPosition:scrollPosition animated:animated];
}

- (UIView*)viewAtIndex:(NSUInteger)index
{
    UIView *view = nil;
    BDRowInfo *findRow = [[BDRowInfo alloc] init];
    findRow.accumulatedViews = index ;
    
    if (_rowInfos.count == 0) {
        return nil;
    }
    
    //use binary search for the cell that contains the specified index
    NSUInteger indexOfRow = [_rowInfos indexOfObject:findRow
               inSortedRange:(NSRange){0, _rowInfos.count  -1}
                     options:NSBinarySearchingInsertionIndex|NSBinarySearchingLastEqual
             usingComparator:^NSComparisonResult(id obj1, id obj2) {
                 BDRowInfo *r1 = obj1;
                 BDRowInfo *r2 = obj2;
                 return (r1.accumulatedViews+r1.viewsPerCell) - (r2.accumulatedViews + r2.viewsPerCell);
             }];
    BDRowInfo *rowInfo = [_rowInfos objectAtIndex:indexOfRow];
    
    BDDynamicGridCell *cell =  (BDDynamicGridCell*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowInfo.order inSection:0]];
    NSUInteger realIndex = index - rowInfo.accumulatedViews;
    view = [cell.gridContainerView.subviews objectAtIndex:realIndex];
    
    return view;
}

- (NSArray *)visibleViews
{
    NSArray* cells = [_tableView visibleCells];
    NSArray* visibleViews = [[NSArray alloc] init];
    for (BDDynamicGridCell *cell in cells) {
        visibleViews = [visibleViews arrayByAddingObjectsFromArray:cell.gridContainerView.subviews];
    }
    return visibleViews;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDRowInfo *ri = [_rowInfos objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    BDDynamicGridCell *cell = [tableView dequeueReusableCellWithIdentifier:[CellIdentifier stringByAppendingFormat:@"_viewCount%lu", (unsigned long)ri.viewsPerCell]];
    
    if (!cell) {
        cell = [[BDDynamicGridCell alloc] initWithLayoutStyle:BDDynamicGridCellLayoutStyleFill
                                              reuseIdentifier:CellIdentifier];
        
        cell.viewBorderWidth = 1;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
        longPress.numberOfTouchesRequired = 1;
        [cell.gridContainerView addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        doubleTap.delaysTouchesBegan = YES;
        [cell.gridContainerView addGestureRecognizer:doubleTap];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.delaysTouchesBegan = YES;
        [cell.gridContainerView addGestureRecognizer:singleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    
    //clear for updated list of views
    [cell setViews:nil];
    cell.viewBorderWidth = self.borderWidth;

    cell.rowInfo = ri;
    NSArray * viewsForRow = [NSArray array];
    for (int i=0; i<ri.viewsPerCell; i++) {
        viewsForRow = [viewsForRow arrayByAddingObject:[self.delegate viewAtIndex:i + ri.accumulatedViews rowInfo:ri]];
    }
    NSAssert(viewsForRow.count > 0, @"number of views per row must be greater than 0");
    [cell setViews:viewsForRow];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(rowHeightForRowInfo:)]) {
        BDRowInfo *rowInfo = [_rowInfos objectAtIndex:indexPath.row];
        return [self.delegate rowHeightForRowInfo:rowInfo];
    }else{
        return tableView.rowHeight;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(willDisplayRow:)]) {
        BDRowInfo *rowInfo = [_rowInfos objectAtIndex:indexPath.row];
        return [self.delegate willDisplayRow:rowInfo];
    }
}

- (UITableView *)tableView
{
    return _tableView;
}

#pragma mark - scrolling
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    DLog(@"willdecelerate %d", decelerate);
    if([self.delegate respondsToSelector:@selector(gridViewWillEndScrolling)]){
        [self.delegate gridViewWillEndScrolling];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    DLog(@"did end decel");
    if([self.delegate respondsToSelector:@selector(gridViewDidEndScrolling)]){
        [self.delegate gridViewDidEndScrolling];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView 
                     withVelocity:(CGPoint)velocity 
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
//    DLog(@"will end dragging vel: %@", NSStringFromCGPoint(velocity));
    if (velocity.y > 1.5) {
        if ([self.delegate respondsToSelector:@selector(gridViewWillStartScrolling)]) {
            [self.delegate gridViewWillStartScrolling];
        }
    }
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    _tableView.contentInset = contentInset;
}

-(UIEdgeInsets)contentInset
{
    return _tableView.contentInset;
}

#pragma mark - events

- (void)gesture:(UIGestureRecognizer*)gesture view:(UIView**)view viewIndex:(NSInteger*)viewIndex
{
    UIView *v = gesture.view;
    while (v && ![v isKindOfClass:[BDDynamicGridCell class]]) v = v.superview;
    BDDynamicGridCell *cell = (BDDynamicGridCell *) v;
    
    CGPoint locationInGridContainer = [gesture locationInView:gesture.view];    
    for (int i=0; i < cell.gridContainerView.subviews.count; i++){
        UIView *subview = [cell.gridContainerView.subviews objectAtIndex:i];
        CGRect vincinityRect = CGRectMake(subview.frame.origin.x - self.borderWidth, 
                                         0, 
                                         subview.frame.size.width + (self.borderWidth * 2), 
                                         cell.gridContainerView.frame.size.height);
        
        if(CGRectContainsPoint(vincinityRect, locationInGridContainer)){
            *view = subview;
            *viewIndex = ((cell.rowInfo.accumulatedViews) + i );
            break;
        }
    }
}

- (void)didLongPress:(UILongPressGestureRecognizer*)longPress
{
    
    UIView *view = nil;
    NSInteger viewIndex = -1;
    [self gesture:longPress view:&view viewIndex:&viewIndex];
    
    
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(longPressDidBeginAtView:index:)]) {
            [self.delegate longPressDidBeginAtView:view index:viewIndex];
        }
    }else if (longPress.state == UIGestureRecognizerStateRecognized) {
        
        if ([self.delegate respondsToSelector:@selector(longPressDidEndAtView:index:)]) {
            [self.delegate longPressDidEndAtView:view index:viewIndex];
        }
        
        if (self.onLongPress) {
            self.onLongPress(view, viewIndex);
        }
        
    }
}

- (void)didDoubleTap:(UITapGestureRecognizer*)doubleTap
{
    if (doubleTap.state == UIGestureRecognizerStateRecognized) {
        UIView *view = nil;
        NSInteger viewIndex = -1;
        [self gesture:doubleTap view:&view viewIndex:&viewIndex];
        if (self.onDoubleTap) {
            self.onDoubleTap(view, viewIndex);
        }
    }

}


- (void)didSingleTap:(UITapGestureRecognizer*)singleTap
{
    if (singleTap.state == UIGestureRecognizerStateRecognized) {
        UIView *view = nil;
        NSInteger viewIndex = -1;
        //DLog(@"view %@, viewIndex %d", view, viewIndex);
        [self gesture:singleTap view:&view viewIndex:&viewIndex];
        if (self.onSingleTap) {
            self.onSingleTap(view, viewIndex);
        }
    }
}

@synthesize borderWidth;
@synthesize delegate;
@synthesize onLongPress;
@synthesize onDoubleTap;
@synthesize onSingleTap;
@end
