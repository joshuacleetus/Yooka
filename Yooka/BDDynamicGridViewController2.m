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

#import "BDDynamicGridViewController2.h"
#import "BDDynamicGridCell2.h"
#import "BDRowInfo2.h"
#import <AsyncImageDownloader.h>
#import "UserFollowingViewController.h"
#import "UserFollowersViewController.h"
#import "YookaBackend.h"
#import "UIImageView+WebCache.h"

#define kDefaultBorderWidth 5


@interface BDDynamicGridViewController2  () <UITableViewDelegate, UITableViewDataSource>{
    UITableView *_tableView;
    NSArray *_rowInfos;
}
@end

@implementation BDDynamicGridViewController2
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
    
    _myEmail = [[KCSUser activeUser] email];
    
    _myFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
    
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
    
    _userView = [[UIImageView alloc]initWithFrame:CGRectMake(115, 29, 90, 90)];
    self.userView.layer.cornerRadius = self.userView.frame.size.height / 2;
    [self.userView.layer setBorderWidth:4.0];
    [self.userView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.userView setContentMode:UIViewContentModeScaleAspectFill];
    [self.userView setClipsToBounds:YES];
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
    
    _userFollowingLbl = [[UILabel alloc]initWithFrame:CGRectMake(26, 183, 85, 17)];
    _userFollowingLbl.textColor = [UIColor whiteColor];
    _userFollowingLbl.text = @"0 Following";
    _userFollowingLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
    _userFollowingLbl.textAlignment = NSTextAlignmentLeft;
    [_headerView addSubview:_userFollowingLbl];
    
    _userpicturesLbl = [[UILabel alloc]initWithFrame:CGRectMake(137, 183, 85, 17)];
    _userpicturesLbl.textColor = [UIColor whiteColor];
    _userpicturesLbl.text = @"0 Pictures";
    _userpicturesLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
    _userpicturesLbl.textAlignment = NSTextAlignmentLeft;
    [_headerView addSubview:_userpicturesLbl];
    
    _userFollowersLbl = [[UILabel alloc]initWithFrame:CGRectMake(245, 183, 85, 17)];
    _userFollowersLbl.textColor = [UIColor whiteColor];
    _userFollowersLbl.text = @"0 Followers";
    _userFollowersLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
    _userFollowersLbl.textAlignment = NSTextAlignmentLeft;
    [_headerView addSubview:_userFollowersLbl];
    
    _tableView.tableHeaderView = _headerView;
    
    [self reloadData];
    
    _usernameLbl.text = _userFullName;
    [self.navigationItem setTitle:[_userFullName uppercaseString]];
    
    if (_userPicUrl) {
        
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
                 [self checkforUserFollowers];

             }
         }];
    
    }else{
        
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
                            //                        [self.userView.layer setCornerRadius:self.userView.frame.size.width/2];
                            //                        [self.userView setClipsToBounds:YES];
                            [_headerView addSubview:_userView];
                            //                            NSLog(@"profile image");
                            [self checkforUserFollowers];
                            
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
                            //                        [self.userView.layer setCornerRadius:self.userView.frame.size.width/2];
                            //                        [self.userView setClipsToBounds:YES];
                            [_headerView addSubview:_userView];
                            //                            NSLog(@"profile image");
                            [self checkforUserFollowers];
                            
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
                        //                        [self.userView.layer setCornerRadius:self.userView.frame.size.width/2];
                        //                        [self.userView setClipsToBounds:YES];
                        [_headerView addSubview:_userView];
                        //                            NSLog(@"profile image");
                        [self checkforUserFollowers];
                        
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

- (void)checkforUserFollowing
{
    if ([_userEmail isEqualToString:_myEmail]) {
        //do nothing
    }else{
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        [store loadObjectWithID:_myEmail withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                if (objectsOrNil && objectsOrNil.count) {
                    YookaBackend *backendObject = objectsOrNil[0];
                    _following_users = [NSMutableArray arrayWithArray:backendObject.following_users];
                    
                    NSLog(@"successful reload: %@", backendObject.following_users); // event updated
                }else{
                    [self showFollowBtn];
                }
                
            } else {
                NSLog(@"error occurred: %@", errorOrNil);
                [self showFollowBtn];
            }
        } withProgressBlock:nil];
    }
    
}

- (void) checkforUserFollowers
{
    if ([_userEmail isEqualToString:_myEmail]) {
        //do nothing
    }else{
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        [store loadObjectWithID:_userEmail withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                if (objectsOrNil && objectsOrNil.count) {
                    YookaBackend *backendObject = objectsOrNil[0];
                    _followers = [NSMutableArray arrayWithArray:backendObject.followers];
                    [self checkUserInMyArray];

                    NSLog(@"successful reload: %@", backendObject.followers); // event updated
                }else{
                    [self showFollowBtn];
                }
                
            } else {
                NSLog(@"error occurred: %@", errorOrNil);
                [self showFollowBtn];
            }
        } withProgressBlock:nil];
    }
}

- (void)checkUserInMyArray
{
    if ([_followers containsObject:_myEmail]) {
        [self showUnfollowBtn];
    }else{
        [self showFollowBtn];
    }
}

- (void)showFollowBtn
{
    [self.unFollowBtn setHidden:YES];
    
    self.followBtn = [[FUIButton alloc]initWithFrame:CGRectMake(104, 109, 110, 24)];
    UIColor * color4 = [UIColor colorWithRed:245/255.0f green:135/255.0f blue:77/255.0f alpha:1.0f];
    self.followBtn.buttonColor = color4;
    UIColor * color5 = [UIColor colorWithRed:221/255.0f green:117/255.0f blue:62/255.0f alpha:1.0f];
    self.followBtn.shadowColor = color5;
    self.followBtn.shadowHeight = 3.0f;
    self.followBtn.cornerRadius = 6.0f;
    self.followBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
    [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.followBtn addTarget:self action:@selector(followBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.followBtn];
    
}

- (void)followBtnTouched:(id)sender
{
    NSLog(@"Follow button pressed");
          
    [self.followBtn setHidden:YES];
    [self.unFollowBtn setEnabled:NO];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:_userEmail];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            [_followers addObject:_myEmail];
            [self saveFollowers];
            [self showUnfollowBtn];
            
            [self modifyFollowing];
        } else {
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
                
                [_followers addObject:_myEmail];
                [self saveFollowers];
                [self showUnfollowBtn];
                
                [self modifyFollowing];
                
            } else {
                YookaBackend *yooka = objectsOrNil[0];
                
                _followers = [NSMutableArray arrayWithArray:yooka.followers];
                [_followers addObject:_myEmail];
                
                [_userFollowersLbl removeFromSuperview];
                
                _userFollowersLbl = [[UILabel alloc]initWithFrame:CGRectMake(245, 183, 85, 17)];
                _userFollowersLbl.textColor = [UIColor whiteColor];
                NSString *followerCount = [NSString stringWithFormat:@"%lu Followers",(unsigned long)_followers.count];
                _userFollowersLbl.text = followerCount;
                _userFollowersLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
                _userFollowersLbl.textAlignment = NSTextAlignmentLeft;
                [_headerView addSubview:_userFollowersLbl];
                
                [self saveFollowers];
                [self showUnfollowBtn];
                
                [self modifyFollowing];
            }
            
        }
    } withProgressBlock:nil];
    
}

- (void)modifyFollowing
{
    KCSCollection *yookaObjects2 = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store2 = [KCSAppdataStore storeWithCollection:yookaObjects2 options:nil];
    
    [store2 loadObjectWithID:_myEmail withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            if (objectsOrNil && objectsOrNil.count) {
                YookaBackend *backendObject = objectsOrNil[0];
                _following_users = [NSMutableArray arrayWithArray:backendObject.following_users];
                if ([_following_users containsObject:_userEmail]) {
                    
                }else{
                    [_following_users addObject:_userEmail];
                }
                [self savefollowingUsers];
                
                NSLog(@"successful reload: %@", backendObject.followers); // event updated
            }else{
                [_following_users addObject:_userEmail];
                [self savefollowingUsers];
            }
            
        } else {
            NSLog(@"error occurred: %@", errorOrNil);
            [_following_users addObject:_userEmail];
            [self savefollowingUsers];
            
        }
    } withProgressBlock:nil];
}

- (void)savefollowingUsers
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _myEmail;
    yookaObject.userFullName = _myFullName;
    yookaObject.following_users = _following_users;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
            [self.unFollowBtn setEnabled:YES];
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            [self.unFollowBtn setEnabled:YES];

            }
        }
    } withProgressBlock:nil];
}

- (void)savefollowingUsers2
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _myEmail;
    yookaObject.userFullName = _myFullName;
    yookaObject.following_users = _following_users2;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
            
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            }
        }
    } withProgressBlock:nil];
}

- (void)saveFollowers
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _userEmail;
    yookaObject.userFullName = _userFullName;
    yookaObject.followers = _followers;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
            [self.unFollowBtn setEnabled:YES];

        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                [self.unFollowBtn setEnabled:YES];
            }
        }
    } withProgressBlock:nil];
    _userFollowersLbl.text = [NSString stringWithFormat:@"%lu Followers",(unsigned long)_following_users.count];
}

- (void)saveFollowers2
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _userEmail;
    yookaObject.userFullName = _userFullName;
    yookaObject.followers = _followers2;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
            [self.followBtn setEnabled:YES];

        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            }
            [self.followBtn setEnabled:YES];

        }
    } withProgressBlock:nil];
    _userFollowersLbl.text = [NSString stringWithFormat:@"%lu Followers",(unsigned long)_following_users.count];
}

- (void)showUnfollowBtn
{
    self.unFollowBtn = [[FUIButton alloc]initWithFrame:CGRectMake(104, 109, 110, 24)];
    UIColor * color4 = [UIColor colorWithRed:67/255.0f green:125/255.0f blue:162/255.0f alpha:1.0f];
    self.unFollowBtn.buttonColor = color4;
    UIColor * color5 = [UIColor colorWithRed:45/255.0f green:93/255.0f blue:124/255.0f alpha:1.0f];
    self.unFollowBtn.shadowColor = color5;
    self.unFollowBtn.shadowHeight = 3.0f;
    self.unFollowBtn.cornerRadius = 6.0f;
    self.unFollowBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
    [self.unFollowBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
    [self.unFollowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.unFollowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.unFollowBtn addTarget:self action:@selector(unFollowBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.unFollowBtn];
}

- (void)unFollowBtnTouched:(id)sender
{
    NSLog(@"UnFollow button pressed");
    [self.unFollowBtn setHidden:YES];
    [self showFollowBtn];
    [self.followBtn setEnabled:NO];
    [self unFollowUser];
    [self removeFollowing2];
}

- (void)unFollowUser
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
                
                _followers2 = [NSMutableArray arrayWithArray:yooka.followers];
                if ([_followers2 containsObject:_myEmail]) {
                    [_followers2 removeObject:_myEmail];
                    [self saveFollowers2];
                }else{
                    
                }
                _userFollowersLbl = [[UILabel alloc]initWithFrame:CGRectMake(245, 183, 85, 17)];
                _userFollowersLbl.textColor = [UIColor whiteColor];
                NSString *followerCount = [NSString stringWithFormat:@"%lu Followers",(unsigned long)_followers2.count];
                _userFollowersLbl.text = followerCount;
                _userFollowersLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
                _userFollowersLbl.textAlignment = NSTextAlignmentLeft;
                [_headerView addSubview:_userFollowersLbl];
                
            }
            
        }
    } withProgressBlock:nil];
    

}

- (void)removeFollowing2
{
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store loadObjectWithID:_myEmail withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            if (objectsOrNil && objectsOrNil.count) {
                [_followers removeAllObjects];
                YookaBackend *backendObject = objectsOrNil[0];
                _following_users2 = [NSMutableArray arrayWithArray:backendObject.following_users];
                if ([_following_users2 containsObject:_userEmail]) {
                    [_following_users2 removeObject:_userEmail];
                    [self savefollowingUsers2];
                }else{

                }

                NSLog(@"successful reload: %@", backendObject.followers); // event updated
            }
            
        } else {
            NSLog(@"error occurred: %@", errorOrNil);
            [self showFollowBtn];
        }
    } withProgressBlock:nil];
}


- (void)userFollowing:(id)sender
{
    NSLog(@"Following Button pressed");
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
    NSLog(@"Followers Button pressed");
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
                
                [_userFollowingLbl removeFromSuperview];
                
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    _tableView = nil;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _rowInfos.count;
}


- (NSArray *)rowInfos
{
    NSArray *result = [NSArray array];
    for (BDRowInfo2* rowInfo in _rowInfos) {
        result = [result arrayByAddingObject:[rowInfo copy]];
    }
    return _rowInfos;
}

- (NSArray *)visibleRowInfos
{
    NSArray *indexPaths = [_tableView indexPathsForVisibleRows];
    NSArray *result = [NSArray array];
    for (NSIndexPath *idp in indexPaths) {
        BDRowInfo2 *rowInfo = [_rowInfos objectAtIndex:idp.row];
        result = [result arrayByAddingObject:[rowInfo copy]];
    }
    return result;
}

- (void)reloadRows:(NSArray *)rowInfos
{
    NSArray *indexPaths = [NSArray array];
    for (BDRowInfo2 *row in rowInfos) {
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
        BDRowInfo2 * ri;
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
            ri = [BDRowInfo2 new];
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
        BDRowInfo2 * ri;
        
        int patternIndex = 0;
        while (accumNumOfViews < self.delegate.numberOfViews) {
            NSNumber* number  = [gridPattern objectAtIndex:(patternIndex++)%gridPattern.count];
            NSAssert(number.integerValue != 0, @"Grid pattern can't contains a zero size row.");
            NSUInteger numOfViews = number.integerValue;
            numOfViews = (accumNumOfViews+numOfViews <= self.delegate.numberOfViews)?numOfViews:(self.delegate.numberOfViews-accumNumOfViews);
            ri = [BDRowInfo2 new];
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


- (void)updateLayoutWithRow:(BDRowInfo2 *)rowInfo animiated:(BOOL)animated
{
    BDDynamicGridCell2 *cell = (BDDynamicGridCell2*) [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowInfo.order inSection:0]];
    [cell layoutSubviewsAnimated:animated];
}

- (void)scrollToRow:(BDRowInfo2 *)row atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated
{
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:row.order
                                                         inSection:0]
                      atScrollPosition:scrollPosition animated:animated];
}

- (UIView*)viewAtIndex:(NSUInteger)index
{
    UIView *view = nil;
    BDRowInfo2 *findRow = [[BDRowInfo2 alloc] init];
    findRow.accumulatedViews = index ;
    
    if (_rowInfos.count == 0) {
        return nil;
    }
    
    //use binary search for the cell that contains the specified index
    NSUInteger indexOfRow = [_rowInfos indexOfObject:findRow
               inSortedRange:(NSRange){0, _rowInfos.count  -1}
                     options:NSBinarySearchingInsertionIndex|NSBinarySearchingLastEqual
             usingComparator:^NSComparisonResult(id obj1, id obj2) {
                 BDRowInfo2 *r1 = obj1;
                 BDRowInfo2 *r2 = obj2;
                 return (r1.accumulatedViews+r1.viewsPerCell) - (r2.accumulatedViews + r2.viewsPerCell);
             }];
    BDRowInfo2 *rowInfo = [_rowInfos objectAtIndex:indexOfRow];
    
    BDDynamicGridCell2 *cell =  (BDDynamicGridCell2*)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowInfo.order inSection:0]];
    NSUInteger realIndex = index - rowInfo.accumulatedViews;
    view = [cell.gridContainerView.subviews objectAtIndex:realIndex];
    
    return view;
}

- (NSArray *)visibleViews
{
    NSArray* cells = [_tableView visibleCells];
    NSArray* visibleViews = [[NSArray alloc] init];
    for (BDDynamicGridCell2 *cell in cells) {
        visibleViews = [visibleViews arrayByAddingObjectsFromArray:cell.gridContainerView.subviews];
    }
    return visibleViews;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDRowInfo2 *ri = [_rowInfos objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"Cell";
    BDDynamicGridCell2 *cell = [tableView dequeueReusableCellWithIdentifier:[CellIdentifier stringByAppendingFormat:@"_viewCount%lu", (unsigned long)ri.viewsPerCell]];
    
    if (!cell) {
        cell = [[BDDynamicGridCell2 alloc] initWithLayoutStyle:BDDynamicGridCellLayoutStyleFill
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
        BDRowInfo2 *rowInfo = [_rowInfos objectAtIndex:indexPath.row];
        return [self.delegate rowHeightForRowInfo:rowInfo];
    }else{
        return tableView.rowHeight;
    }
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(willDisplayRow:)]) {
        BDRowInfo2 *rowInfo = [_rowInfos objectAtIndex:indexPath.row];
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
    while (v && ![v isKindOfClass:[BDDynamicGridCell2 class]]) v = v.superview;
    BDDynamicGridCell2 *cell = (BDDynamicGridCell2 *) v;
    
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

@synthesize borderWidth;
@synthesize delegate;
@synthesize onLongPress;
@synthesize onDoubleTap;
@synthesize onSingleTap;
@end
