//
//  YookaProfileNewViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 6/3/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelDelegate.h"
#import <KinveyKit/KinveyKit.h>
#import <FacebookSDK.h>
#import <FlatUIKit.h>
#import "YookaButton.h"

@interface YookaProfileNewViewController : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,UITabBarControllerDelegate,UIAlertViewDelegate,KCSOfflineUpdateDelegate, NSURLConnectionDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate> {
    int i;
    int j;
    int j2;
    int k;
    int l;
    int m;
    int n;
    int p;
    int q;
    int maincontentSize;
    int row, col, contentSize;
    int row2, col2, contentSize2;
    int row3, col3, contentSize3;
    int item;
    // this array keeps track of which picture's comments are displayed
    NSInteger toggle[25];
}

@property (nonatomic, assign) id<PanelDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *navButton;
@property (strong, nonatomic) IBOutlet UIButton *navButton2;
@property (strong, nonatomic) IBOutlet UIButton *navButton3;

@property (strong, nonatomic) IBOutlet UIButton *navButtonc;
@property (strong, nonatomic) IBOutlet UIButton *navButton2c;
@property (strong, nonatomic) IBOutlet UIButton *navButton3c;

@property (nonatomic, strong) IBOutlet UIButton *pickImageBtn;

@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) BOOL panelMovedRight;

@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;
@property (nonatomic, strong) IBOutlet UIImageView *bgImageView2;

@property (nonatomic, strong) IBOutlet UIImageView *progressImageView;
@property (nonatomic, strong) IBOutlet UIImageView *completedImageView;
@property (nonatomic, strong) IBOutlet UIImageView *feedImageView;
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView3;
@property (nonatomic, strong) IBOutlet UIImageView *profileShadowImageView;

@property (nonatomic, strong) IBOutlet UIImageView *dialImageView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIImageView* backBtnImage;

@property (strong, nonatomic) UIButton *backBtn3;
@property (strong, nonatomic) IBOutlet UIImageView* backBtnImage3;
@property (strong, nonatomic) IBOutlet UILabel* categoryLabel;
@property (strong, nonatomic) IBOutlet UILabel* titleLabel;
@property (strong, nonatomic) IBOutlet UILabel* profileLabel;
@property (strong, nonatomic) IBOutlet UILabel* profileLabel3;

@property (nonatomic, strong) NSString *userFullName;

@property (strong, nonatomic) IBOutlet UIImageView* settingsImage;
@property (strong, nonatomic) IBOutlet UILabel* editLabel;
@property (strong, nonatomic) IBOutlet UILabel* listLabel;
@property (strong, nonatomic) IBOutlet UILabel* listCountLabel;
@property (strong, nonatomic) IBOutlet UILabel* followersLabel;
@property (strong, nonatomic) IBOutlet UILabel* followersCountLabel;
@property (strong, nonatomic) IBOutlet UILabel* followingLabel;
@property (strong, nonatomic) IBOutlet UILabel* followingCountLabel;

@property (strong, nonatomic) IBOutlet UILabel* listLabel3;
@property (strong, nonatomic) IBOutlet UILabel* listCountLabel3;
@property (strong, nonatomic) IBOutlet UILabel* followersLabel3;
@property (strong, nonatomic) IBOutlet UILabel* followersCountLabel3;
@property (strong, nonatomic) IBOutlet UILabel* followingLabel3;
@property (strong, nonatomic) IBOutlet UILabel* followingCountLabel3;

@property (strong, nonatomic) IBOutlet UIView* progressView;
@property (strong, nonatomic) IBOutlet UIView* completedView;
@property (strong, nonatomic) IBOutlet UIView* feedView;

@property (strong, nonatomic) IBOutlet UILabel* progressLabel;
@property (strong, nonatomic) IBOutlet UILabel* completedLabel;
@property (strong, nonatomic) IBOutlet UILabel* feedLabel;

@property (strong, nonatomic) IBOutlet UIButton *progressButton;
@property (strong, nonatomic) IBOutlet UIButton *completedButton;
@property (strong, nonatomic) IBOutlet UIButton *feedButton;

@property (nonatomic, strong) UIScrollView* gridScrollView;
@property (nonatomic, strong) UIScrollView* progressScrollView;
@property (nonatomic, strong) UIScrollView* completedScrollView;
@property (nonatomic, strong) UIScrollView* feedScrollView;
@property (nonatomic, strong) UIScrollView* profileScrollView;

@property (nonatomic, strong) NSMutableArray *myPosts;
@property (nonatomic, strong) NSMutableArray *yookaImages;
@property (nonatomic, strong) NSMutableArray *thumbnails;
@property (nonatomic, strong) NSMutableArray *thumbnails2;
@property (nonatomic, strong) NSMutableArray *thumbnails3;

@property (nonatomic, strong) NSMutableArray *subscribedHunts;
@property (nonatomic, strong) NSMutableArray *unSubscribedHunts;

@property (nonatomic, strong) NSMutableArray *followingUsers;
@property (nonatomic, strong) NSMutableArray *followerUsers;

@property (nonatomic, strong) NSDictionary *dict1;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;

@property (nonatomic, strong) NSDictionary *dict2;
@property (nonatomic, strong) NSString *collectionName2;
@property (nonatomic, strong) NSString *customEndpoint2;
@property (nonatomic, strong) NSString *fieldName2;

@property (nonatomic, strong) NSString *myEmail;

@property (nonatomic, strong) NSMutableArray *cachesubscribedHuntNames;
@property (nonatomic, strong) NSMutableArray *cacheUnSubscribedHuntNames;

@property (nonatomic, strong) NSString *huntCount;
@property (nonatomic, strong) NSString *finishedHuntCount;
@property (nonatomic, strong) NSString *inProgressCount;

@property (nonatomic, strong) NSMutableArray *finishedHuntNames;
@property (nonatomic, strong) NSMutableArray *inProgressHuntNames;

@property (nonatomic, strong) NSMutableDictionary *huntDict1;
@property (nonatomic, strong) NSMutableDictionary *huntDict2;
@property (nonatomic, strong) NSMutableDictionary *huntDict3;
@property (nonatomic, strong) NSMutableDictionary *huntDict4;
@property (nonatomic, strong) NSMutableDictionary *huntDict5;
@property (nonatomic, strong) NSMutableDictionary *huntDict6;
@property (nonatomic, strong) NSMutableDictionary *huntDict7;

@property (nonatomic, strong) NSMutableDictionary *finishedHuntVenues;

@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPicUrl;

@property (nonatomic, strong) IBOutlet UIButton *userFollowingBtn;
@property (nonatomic, strong) IBOutlet UIButton *userFollowersBtn;

@property (nonatomic, strong) IBOutlet UIButton *userFollowingBtn3;
@property (nonatomic, strong) IBOutlet UIButton *userFollowersBtn3;

@property (nonatomic, strong) NSMutableArray *inProgressHuntCounts;
@property (nonatomic, strong) NSMutableArray *finishedHuntCounts;
@property (nonatomic, strong) IBOutlet YookaButton *button;

@property (nonatomic, strong) NSString *likes;
@property (nonatomic, strong) NSMutableArray *postLikers;
@property (nonatomic, strong) NSMutableArray *likesData;
@property (nonatomic, strong) NSMutableArray *likersData;

@property (nonatomic, strong) IBOutlet UIImageView *detailsModalView;
@property (nonatomic, strong) IBOutlet UIImageView *captionModalView;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *postLikes;
@property (nonatomic, strong) NSString *likeStatus;

@property (strong, nonatomic) IBOutlet YookaButton *hunts_options_button;
@property (strong, nonatomic) IBOutlet YookaButton *hunts_options_button_2;

@property (strong, nonatomic) IBOutlet YookaButton *pics_options_button;

@property (nonatomic, strong) IBOutlet UIImageView *modal_view;
@property (nonatomic, strong) IBOutlet YookaButton *private_btn;
@property (nonatomic, strong) IBOutlet YookaButton *public_btn;
@property (nonatomic, strong) IBOutlet YookaButton *delete_btn;
@property (nonatomic, strong) IBOutlet UIButton *cancel_btn;
@property (nonatomic, strong) IBOutlet UIButton *cancel_btn_2;

@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, retain) id<KCSStore> updateStore;

@property (nonatomic, retain) UIImage* profileImage;

@end
