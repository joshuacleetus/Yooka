//
//  YookaAppDelegate.h
//  Yooka
//
//  Created by Joshua Cleetus on 09/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <KinveyKit/KinveyKit.h>

#import "YookaViewController.h"

@class MainViewController;

@interface YookaAppDelegate : UIResponder <UIApplicationDelegate,UIScrollViewDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)userLoggedIn;
- (void)userLoggedOut;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *fbuserName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) UIImage* userImage;
@property (nonatomic, retain) UITabBarController *yookaTabBar;
@property (nonatomic, retain) id<KCSStore> updateStore;
@property (nonatomic, retain) id<KCSStore> updateStore2;

@property (strong,nonatomic) IBOutlet UIImageView* imageView;
@property (strong, nonatomic) MainViewController *viewController;

@end
