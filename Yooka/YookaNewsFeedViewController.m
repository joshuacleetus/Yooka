//
//  YookaNewsFeedViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 11/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaNewsFeedViewController.h"
#import "YookaProfileViewController.h"
#import "YookaAppDelegate.h"
#import "YookaBackend.h"
#import <AsyncImageDownloader.h>
#import <QuartzCore/QuartzCore.h>
#import "BDViewController2.h"
#import "YookaHuntRestaurantViewController.h"
#import "YookaPostViewController.h"
#import <Reachability.h>
#import "Haneke.h"
#import "UIImageView+WebCache.h"
#import "AsynchronousFreeloader.h"
#import "LRImageManager.h"
#import "UIImageView+LRNetworking.h"
#import "UIImageView+LRNetworking.h"
#import "LRImagePresenter.h"
#import <objc/runtime.h>

const NSInteger yookaThumbnailWidth3 = 320;
const NSInteger yookaThumbnailHeight3 = 415;
const NSInteger yookaImagesPerRow3 = 1;
const NSInteger yookaThumbnailSpace3 = 5;

@interface YookaNewsFeedViewController ()

@end

@implementation YookaNewsFeedViewController

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
    i=0;
    j=0;
    skip = 15;
    _userEmail = [KCSUser activeUser].email;
    _following_users = [NSMutableArray new];
    _queryArray = [NSArray new];
    _newsFeed = [NSMutableArray new];
    _thumbnails = [NSMutableArray new];
    _likesData = [NSMutableArray new];
    _likersData = [NSMutableArray new];
    _userNames = [NSMutableArray new];
    _userEmails = [NSMutableArray new];
    _userPicUrls = [NSMutableArray new];
    contentSize = 0;
    
//    [self showActivityIndicator];
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yooka.png"]];
    

    [_gridScrollView removeFromSuperview];
    
    
    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    _gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
    _gridScrollView.contentSize= self.view.bounds.size;
    _gridScrollView.frame = CGRectMake(0.f, 2.f, 320.f, self.view.frame.size.height);
    [self.view addSubview:_gridScrollView];

    
//    if ([[UIScreen mainScreen] bounds].size.height == 568) {
//        [_gridScrollView setContentSize:CGSizeMake(320, 500)];
//    }else{
//        [_gridScrollView setContentSize:CGSizeMake(320, 500)];
//    }
    
//    _subTitleView = [[UIImageView alloc]initWithFrame:CGRectMake(130, 30, 60, 15)];
//    _subTitleView.image = [UIImage imageNamed:@"yooka@2x.png"];
//    [self.view addSubview:_subTitleView];
    
    [self setupNewsFeed];
    
//    _postsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height)];
//    _postsTableView.delegate = self;
//    _postsTableView.dataSource = self;
//    [_postsTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
//    //    _locationTableView.backgroundColor = [UIColor blackColor];
//    [_postsTableView setSeparatorColor:[UIColor whiteColor]];
//    [self.view addSubview:_postsTableView];
    
}


- (void)showReloadButton {
    UIBarButtonItem * reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadView)];
    reloadButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = reloadButton;
    
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

- (void)findFollowingUsers
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store loadObjectWithID:_userEmail withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            YookaBackend *backendObject = objectsOrNil[0];
            _following_users = [NSMutableArray arrayWithArray:backendObject.following_users];
            [_following_users addObject:_userEmail];
            _queryArray = [NSArray arrayWithArray:_following_users];
//            NSLog(@"successful reload: %@", _following_users[0]); // event updated

        } else {
//            NSLog(@"error occurred: %@", errorOrNil);
        }
    } withProgressBlock:nil];
    
}

- (void)reloadView
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    [_gridScrollView removeFromSuperview];
    
    
    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    _gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
    _gridScrollView.contentSize= self.view.bounds.size;
    _gridScrollView.frame = CGRectMake(0.f, 65.f, 320.f, self.view.frame.size.height);
    [self.view addSubview:_gridScrollView];
    
    contentSize = 130;
    
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

- (void)setupNewsFeed
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    i=0;
    j=0;
    k=0;
        
    _userEmails = [NSMutableArray new];
    
    [self showActivityIndicator];
    
    _userNames = [NSMutableArray new];
    _newsFeed = [NSMutableArray new];
    _thumbnails = [NSMutableArray new];
    _likesData = [NSMutableArray new];
    _likersData = [NSMutableArray new];
    _userEmails = [NSMutableArray new];
    _userPicUrls = [NSMutableArray new];
    _collectionName1 = @"yookaPosts2";
    _customEndpoint1 = @"Posts";
    _fieldName1 = @"postDate";
    _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
    
    [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
        if (results) {
            if ([results isKindOfClass:[NSArray class]]) {
                _newsFeed = [NSMutableArray arrayWithArray:results];
                if (_newsFeed && _newsFeed.count) {
//                    NSLog(@"%@",_newsFeed);
                    
                    [self fillPictures];
                    
//                    [self loadImages2];
                    
                    
                }else{
                    //                NSLog(@"User Search Results = \n %@",results);
                    [self stopActivityIndicator];
                }
                
            }else{
                [self stopActivityIndicator];
            }
        }else{
            [self stopActivityIndicator];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    
    if (self.navigationController.viewControllers.count>1 && [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] isKindOfClass:[YookaPostViewController class]]) {
        
        [self reloadView];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkForLikers
{
    
}

- (void)fillPictures
{
//    NSLog(@"FILL PICTURES");
    item = 0;
    row = 0;
    col = 0;
    for (item=0;item<self.newsFeed.count;item++) {
        
        UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
//        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
        UITapGestureRecognizer *tapTrice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapThrice:)];
        
        tapOnce.numberOfTapsRequired = 1;
//        tapTwice.numberOfTapsRequired = 2;
        tapTrice.numberOfTapsRequired = 3;
        //stops tapOnce from overriding tapTwice
        [tapOnce requireGestureRecognizerToFail:tapTrice];
//        [tapTwice requireGestureRecognizerToFail:tapTrice];
        
        _button = [[UIButton alloc] initWithFrame:CGRectMake(col*yookaThumbnailWidth3,
                                                                      (row*yookaThumbnailHeight3),
                                                                      yookaThumbnailWidth3,
                                                                      yookaThumbnailHeight3)];
        contentSize += (yookaThumbnailHeight3);
        _button.tag = item;
        _button.userInteractionEnabled = YES;
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_button addGestureRecognizer:tapOnce]; //remove the other button action which calls method `button`
//        [_button addGestureRecognizer:tapTwice];
        [_button addGestureRecognizer:tapTrice];

        ++col;
        
        if (col >= yookaImagesPerRow3) {
            row++;
            col = 0;
        }
        
        [self.gridScrollView addSubview:_button];
        [self.thumbnails addObject:_button];
    }
    
    [_gridScrollView setContentSize:CGSizeMake(320, contentSize)];
    
    [self loadImages];
}

- (void)tapOnce:(id)sender
{
//    NSLog(@"Tap once");
}

- (void)tapTwice:(UIGestureRecognizer *)sender
{
    
////    [self.gridScrollView setUserInteractionEnabled:NO];
////    NSLog(@"Tap twice");
//    UIView * view = sender.view;
////    NSLog(@"%ld",(long)view.tag);
////    NSLog(@"post data = %@",_newsFeed[view.tag]);
////    NSLog(@"likes data = %@",_likesData);
////    NSLog(@"likers data = %@",_likersData);
//    _postLikers = [NSMutableArray new];
//    
//    UIButton* button = [self.thumbnails objectAtIndex:view.tag];
//
//    _postId = [_newsFeed[view.tag] objectForKey:@"_id"];
////    NSLog(@"post id = %@",_postId);
//    _postHuntName = [_newsFeed[view.tag] objectForKey:@"HuntName"];
////    NSLog(@"hunt name = %@",_postHuntName);
//    _postCaption = [_newsFeed[view.tag] objectForKey:@"caption"];
////    NSLog(@"caption = %@",_postCaption);
//    _postDishImageUrl = [[_newsFeed[view.tag] objectForKey:@"dishImage"]objectForKey:@"_downloadURL"];
////    NSLog(@"dish image url = %@",_postDishImageUrl);
//    _postDishName = [_newsFeed[view.tag] objectForKey:@"dishName"];
////    NSLog(@"dish name = %@",_postDishName);
//    
//    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
//    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
//    
//    [store loadObjectWithID:_postId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//        if (errorOrNil == nil) {
//            if (objectsOrNil && objectsOrNil.count) {
//                
//                YookaBackend *backendObject = objectsOrNil[0];
//                _postLikers = [NSMutableArray arrayWithArray:backendObject.likers];
//                _postLikes = backendObject.likes;
//                
//                if ([_postLikes intValue]==0) {
//                    _likeStatus = @"NO";
//                }
////                NSLog(@"likes = %@",_postLikes);
//                
//                if (!(_postLikers == (id)[NSNull null])) {
//                    if ([_postLikers containsObject:_userEmail]) {
//                        _likeStatus = @"YES";
//                    }else{
//                        _likeStatus = @"NO";
//                    }
//                }else{
//                    _likeStatus = @"NO";
//                    //        NSLog(@"try try try");
//                }
//                
//                //    NSLog(@"like status = %@",_likeStatus);
//                
//                
//                if ([_likeStatus isEqualToString:@"YES"]) {
//                    
//                    int post_likes = [_postLikes intValue];
//                    post_likes = post_likes-1;
//                    _postLikes = [NSString stringWithFormat:@"%d",post_likes];
//                    
//                    if (_postLikers==(id)[NSNull null]) {
////                        [_likersData replaceObjectAtIndex:view.tag withObject:[NSNull null]];
//                    }else{
//                        [_postLikers removeObject:_userEmail];
//                    }
//                    
//                    //        NSLog(@"likes data 2 = %@",_likesData);
//                    //        NSLog(@"likers data 2 = %@",_likersData);
//                    
//                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
//                    likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
//                    [button addSubview:likesImageView];
//                    
//                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
//                    likesLabel.textColor = [UIColor orangeColor];
//                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
//                    likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
//                    likesLabel.textAlignment = NSTextAlignmentCenter;
//                    likesLabel.adjustsFontSizeToFitWidth = YES;
//                    [likesImageView addSubview:likesLabel];
//                    
//                    //                [self saveSelectedPost];
//                    [self saveLikes];
//                    _likeStatus = @"NO";
//                    
//                }else{
//                    
//                    if (_postLikers == (id)[NSNull null]) {
//                        //            NSLog(@"post likers 2 = %@",_postLikers);
//                        _postLikers = [NSMutableArray arrayWithObject:_userEmail];
////                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
//                        
//                    }else{
//                        //            NSLog(@"post likers 3 = %@",_postLikers);
//                        
//                        [_postLikers addObject:_userEmail];
////                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
//                        
//                    }
//                    
//                    int post_likes = [_postLikes intValue];
//                    post_likes=post_likes+1;
//                    _postLikes = [NSString stringWithFormat:@"%d",post_likes];
////                    [_likesData replaceObjectAtIndex:view.tag withObject:_postLikes];
//                    
//                    //        NSLog(@"likes data 2 = %@",_likesData);
//                    //        NSLog(@"likers data 2 = %@",_likersData);
//                    
//                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
//                    likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
//                    [button addSubview:likesImageView];
//                    
//                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
//                    likesLabel.textColor = [UIColor whiteColor];
//                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
//                    likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
//                    likesLabel.textAlignment = NSTextAlignmentCenter;
//                    likesLabel.adjustsFontSizeToFitWidth = YES;
//                    [likesImageView addSubview:likesLabel];
//                    
//                    //                [self saveSelectedPost];
//                    [self saveLikes];
//                    _likeStatus = @"YES";
//                    
//                }
//
//                
//            }else{
//                
//                _postLikes = @"0";
//                
//                _likeStatus = @"NO";
////                NSLog(@"likes = %@",_postLikes);
//                
//                _postLikers = [NSMutableArray arrayWithObject:_userEmail];
//                
//                    
//                    int post_likes = [_postLikes intValue];
//                    post_likes=post_likes+1;
//                    _postLikes = [NSString stringWithFormat:@"%d",post_likes];
//                
//                    //        NSLog(@"likes data 2 = %@",_likesData);
//                    //        NSLog(@"likers data 2 = %@",_likersData);
//                    
//                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
//                    likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
//                    [button addSubview:likesImageView];
//                    
//                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
//                    likesLabel.textColor = [UIColor whiteColor];
//                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
//                    likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
//                    likesLabel.textAlignment = NSTextAlignmentCenter;
//                    likesLabel.adjustsFontSizeToFitWidth = YES;
//                    [likesImageView addSubview:likesLabel];
//                    
//                    //                [self saveSelectedPost];
//                    [self saveLikes];
//                    _likeStatus = @"YES";
//                
//            }
//            
//        }else{
//            
//            _postLikes = @"0";
//            
//            _likeStatus = @"NO";
//            NSLog(@"likes = %@",_postLikes);
//            
//            _postLikers = [NSMutableArray arrayWithObject:_userEmail];
//            
//            
//            int post_likes = [_postLikes intValue];
//            post_likes=post_likes+1;
//            _postLikes = [NSString stringWithFormat:@"%d",post_likes];
//            
//            //        NSLog(@"likes data 2 = %@",_likesData);
//            //        NSLog(@"likers data 2 = %@",_likersData);
//            
//            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(255, 260, 50, 45)];
//            likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
//            [button addSubview:likesImageView];
//            
//            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 17, 42, 15)];
//            likesLabel.textColor = [UIColor whiteColor];
//            [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
//            likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
//            likesLabel.textAlignment = NSTextAlignmentCenter;
//            likesLabel.adjustsFontSizeToFitWidth = YES;
//            [likesImageView addSubview:likesLabel];
//            
//            //                [self saveSelectedPost];
//            [self saveLikes];
//            _likeStatus = @"YES";
//            
//        }
//        
//    } withProgressBlock:nil];
    
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

- (void)loadImages
{

//    NSLog(@"load images");
    if (i<_newsFeed.count) {
        //        NSLog(@"hahahah");
        NSString *dishPicUrl = [[_newsFeed[i] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
        NSString *userId = [_newsFeed[i] objectForKey:@"userEmail"];
        [_userEmails addObject:userId];
//        NSLog(@"hahahaha = %@",userId);
        NSString *dishName = [_newsFeed[i] objectForKey:@"dishName"];
        NSString *venueName = [_newsFeed[i] objectForKey:@"venueName"];
        NSString *venueAddress = [_newsFeed[i] objectForKey:@"venueAddress"];
        NSString *caption = [_newsFeed[i] objectForKey:@"caption"];
        NSString *post_vote = [_newsFeed[i] objectForKey:@"postVote"];
        
//        UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
//        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
//        UITapGestureRecognizer *tapTrice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapThrice:)];
//        
//        tapOnce.numberOfTapsRequired = 1;
//        tapTwice.numberOfTapsRequired = 2;
//        tapTrice.numberOfTapsRequired = 3;
//        //stops tapOnce from overriding tapTwice
//        [tapOnce requireGestureRecognizerToFail:tapTwice];
//        [tapTwice requireGestureRecognizerToFail:tapTrice];
//        
//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
//                                                                      (i*yookaThumbnailHeight3),
//                                                                      310,
//                                                                      415)];
//        contentSize += (yookaThumbnailHeight3);
//        
//        [_gridScrollView setContentSize:CGSizeMake(320, contentSize)];
//        
//        button.tag = i;
//        
//        button.userInteractionEnabled = YES;
//        //        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [button addGestureRecognizer:tapOnce]; //remove the other button action which calls method `button`
//        [button addGestureRecognizer:tapTwice];
//        [button addGestureRecognizer:tapTrice];
//        [_gridScrollView addSubview:button];
//        [self.thumbnails addObject:button];
        
        UIButton *button = [self.thumbnails objectAtIndex:i];
        
        UIImageView *buttonImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 310, 310)];
        //                [buttonImage2 setBackgroundColor:[UIColor redColor]];
        buttonImage2.image = [UIImage imageNamed:@"YookaPostsBg.png"];
        [button addSubview:buttonImage2];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:dishPicUrl]
                                                            options:0
                                                           progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                                                          completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
         {
             if (image)
             {
                 // do something with image

                 
                 UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 304, 304)];
                 [buttonImage setBackgroundColor:[UIColor clearColor]];
                 buttonImage.contentMode = UIViewContentModeScaleAspectFill;
                 buttonImage.clipsToBounds = YES;
                 [buttonImage setImage:image];
                 [button addSubview:buttonImage];
                 
                 UIImageView *buttonImage3 = [[UIImageView alloc]initWithFrame:CGRectMake( 20, 260, 76, 78)];
                 buttonImage3.image = [UIImage imageNamed:@"YookaProfilePicbg.png"];
                 [button addSubview:buttonImage3];
                
                 [_gridScrollView addSubview:button];
                 
                 //                                    [self loadImages2];
                 
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
                 
                 UIButton *restaurant_button = [UIButton buttonWithType:UIButtonTypeCustom];
                 [restaurant_button  setFrame:CGRectMake(100, 315, 155, 30)];
                 [restaurant_button setBackgroundColor:[UIColor clearColor]];
                 restaurant_button.tag = i;
                 [restaurant_button addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
                 [button addSubview:restaurant_button];
                 
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
                 captionLabel.textColor = [UIColor lightGrayColor];
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
                 //                                    [self.view addSubview:_gridScrollView];
                 
                 i++;
                 [self loadImages];

             }
         }];
        
    }
    
    if (i==1) {
        [self loadImages2];
    }
    
}

- (void)loadImages2
{
    //    NSLog(@"load images");
    if (j<_newsFeed.count) {
        //        NSLog(@"hahahah");
//        NSString *dishPicUrl = [[_newsFeed[i] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
        NSString *userId = [_newsFeed[j] objectForKey:@"userEmail"];
//        NSLog(@"hahahaha = %@",userId);
//        NSString *dishName = [_newsFeed[j] objectForKey:@"dishName"];
//        NSString *venueName = [_newsFeed[j] objectForKey:@"venueName"];
//        NSString *venueAddress = [_newsFeed[j] objectForKey:@"venueAddress"];
//        NSString *caption = [_newsFeed[j] objectForKey:@"caption"];
//        NSString *kinveyId = [_newsFeed[j] objectForKey:@"_id"];
//        NSString *post_vote = [_newsFeed[j] objectForKey:@"postVote"];
        
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
                        
//                        NSLog(@"J=%d",j);
                        
                                 // do something with image
                        UIButton* button = [self.thumbnails objectAtIndex:j];
                        
                        UIImageView *buttonImage4 = [[UIImageView alloc]initWithFrame:CGRectMake( 24, 264, 66, 68)];
                        buttonImage4.layer.cornerRadius = 5.f;
                        [buttonImage4 setContentMode:UIViewContentModeScaleAspectFill];
                        buttonImage4.clipsToBounds = YES;
                        [button addSubview:buttonImage4];
                        
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

                                 [buttonImage4 setImage:image];
                                 
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
                                 [self loadImages2];

                             }
                         }];
                        
//                             }
//                         }];
                    
                    }else{
                        
//                        NSLog(@"fail 3");
                        j++;
                        [self loadImages2];
                        
                    }
                            
                    
                }else{
//                    NSLog(@"fail 1");
                    j++;
                    [self loadImages2];
                }
                
            }else{
//                NSLog(@"fail 2");
                j++;
                [self loadImages2];
            }
        }];
        
    }

    if (j == _newsFeed.count-1) {
        
        [self loadlikes];
        
        [self stopActivityIndicator];
//        NSLog(@"user pic url = %@",_userPicUrls);
        
    }
}

- (void)loadlikes
{
    if(k<_newsFeed.count){
        
        NSString *kinveyId = [_newsFeed[k] objectForKey:@"_id"];
        
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
            }
        } withProgressBlock:nil];
        
        UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [like_button  setFrame:CGRectMake(255, 260, 50, 45)];
        [like_button setBackgroundColor:[UIColor clearColor]];
        like_button.tag = k;
        [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:like_button];
        
        k++;
        [self loadlikes];

    }
    

}

- (void)buttonAction:(id)sender
{
//    UIButton* button = sender;
//    NSUInteger b = button.tag;
//    NSLog(@"button %lu pressed",(unsigned long)b);
    
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
    media.userFullName = _userNames[b];
    media.userEmail = _userEmails[b];
    media.userPicUrl = _userPicUrls[b];
//    NSLog(@"userpicurl = %@",_userEmails[b]);

    [self.navigationController pushViewController:media animated:YES];
}

- (void)gotoRestaurant:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    NSLog(@"button %lu pressed",(unsigned long)b);

    NSString *venueId = [_newsFeed[b] objectForKey:@"venueId"];
    NSLog(@"venue id = %@",venueId);
    NSString *venueName = [_newsFeed[b] objectForKey:@"venueName"];
    
    YookaHuntRestaurantViewController *media = [[YookaHuntRestaurantViewController alloc]init];
    media.venueId = venueId;
    media.selectedRestaurantName = venueName;
    [self.navigationController pushViewController:media animated:YES];

}

- (void)backAction
{
    //    NSLog(@"back button pressed");
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _postsData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.postsData) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 370;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_postsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        // create a custom label:                                        x    y   width  height
//        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 320.0)];
//        [_descriptionLabel setTag:1];
//        [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
//        _descriptionLabel.textColor = [UIColor grayColor];
//        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
//        [_descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
//        // custom views should be added as subviews of the cell's contentView:
//        [cell.contentView addSubview:_descriptionLabel];
        
    }
    
    //    cell.textLabel.text = [self.nearbyVenues[indexPath.row] name];
    
    //    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"check_box.jpeg"];
//    [(UILabel *)[cell.contentView viewWithTag:1] setText:[self.nearbyVenues[indexPath.row] name]];
    
    NSString *postPicUrl = [[_postsData[indexPath.row] objectForKey:@"dishImage"]objectForKey:@"_downloadURL"];
//    NSLog(@"profile image = %@",postPicUrl);
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        /* Fetch the image from the server... */
        NSURL *url = [NSURL URLWithString:postPicUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /* This is the main thread again, where we set the tableView's image to
             be what we just fetched. */
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 300, 300)];
            imv.image=img;
            [cell.contentView addSubview:imv];;
//            NSLog(@"profile image");
            
        });
    });
    
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
    
//    [_textField resignFirstResponder];
    
    // keep track of the last selected cell
    self.lastSelected = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.selected = self.postsData[indexPath.row];
    //    if (self.selected.location.address) {
    //        _venueAddress = self.selected.location.address;
    //    }
    //    if (self.selected.location.cc) {
    //        _venueCc = self.selected.location.cc;
    //    }
    //    if (self.selected.location.city) {
    //        _venueCity = self.selected.location.city;
    //    }
    //    if (self.selected.location.country) {
    //        _venueCountry = self.selected.location.country;
    //    }
    //    if ([self.selected.location.postalCode stringValue]) {
    //        _venuePostalCode = [self.selected.location.postalCode stringValue];
    //    }
    //    if (self.selected.location.state) {
    //        _venueState = self.selected.location.state;
    //    }
    [self userDidSelectVenue];
    
    [_postsTableView reloadData];
    [self.postsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

@end
