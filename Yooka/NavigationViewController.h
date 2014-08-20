//
//  NavigationViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 5/28/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelDelegate.h"
#import <KinveyKit/KinveyKit.h>
#import <FacebookSDK.h>

@interface NavigationViewController : UIViewController

@property (nonatomic, assign) id<PanelDelegate> delegate;
@property (nonatomic, strong) IBOutlet UIImageView *bgImage;

@property (nonatomic, strong) IBOutlet UIButton *profileButton;
@property (nonatomic, strong) IBOutlet UIButton *homeButton;
@property (nonatomic, strong) IBOutlet UIButton *uploadPhotoButton;
@property (nonatomic, strong) IBOutlet UIButton *newsFeedButton;
@property (nonatomic, strong) IBOutlet UIButton *searchButton;
@property (nonatomic, strong) IBOutlet UIButton *logoutButton;
@property (nonatomic, strong) IBOutlet UIButton *mapButton;

@property (nonatomic, strong) IBOutlet UIImageView *homeImageView;
@property (nonatomic, strong) IBOutlet UIImageView *homeImage;
@property (nonatomic, strong) IBOutlet UILabel *homeLabel;

@property (nonatomic, strong) IBOutlet UIImageView *uploadImageView;
@property (nonatomic, strong) IBOutlet UIImageView *newsFeedImageView;

@property (nonatomic, strong) IBOutlet UIImageView *userView;

@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) IBOutlet UILabel *usernameLbl;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;
@property (nonatomic, strong) NSDictionary *dict1;
@property (nonatomic, strong) UIImage* userImage;
@property (nonatomic, strong) NSURLConnection* connection;

@property (nonatomic, retain) id<KCSStore> updateStore;

- (IBAction)homeButtonClicked:(id)sender;
- (IBAction)uploadPhotoButtonClicked:(id)sender;
- (IBAction)newsFeedButtonClicked:(id)sender;
- (IBAction)profileButtonClicked:(id)sender;

@end