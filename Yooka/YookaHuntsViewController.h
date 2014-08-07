//
//  YookaHuntsViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 12/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit.h>
#import <FacebookSDK.h>
#import <KinveyKit/KinveyKit.h>
#import "YookaButton.h"
#import "YookaNewsFeedViewController.h"



@interface YookaHuntsViewController : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,UITabBarControllerDelegate,UIAlertViewDelegate,KCSOfflineUpdateDelegate, NSURLConnectionDelegate>{

    CGRect new_page_frame;
    CGRect new_page_frame_2;
    CGRect new_page_frame_3;

    int i;
    int j;
    int k;
    int l;
    int m;
    long total_featured_hunts;
    long total_featured_hunts_2;

    long total_hunts;
    long total_hunts_2;
}

@property (nonatomic, strong) NSString *userEmail;

@property (nonatomic, strong) IBOutlet UITextField *textField;

@property (nonatomic, strong) IBOutlet UIImageView *imageView1;
@property (nonatomic, strong) IBOutlet UIImageView *imageView2;
@property (nonatomic, strong) IBOutlet UIImageView *middleImageView;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView1;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView2;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView3;

@property (nonatomic, strong) NSMutableArray *featuredHunts;
@property (nonatomic, strong) NSMutableArray *featuredHunts2;

@property (nonatomic, strong) IBOutlet UIPageControl *hunts_pages;
@property (nonatomic, strong) IBOutlet UIPageControl *following_hunts_pages;

@property (nonatomic, strong) IBOutlet UILabel *total;
@property (nonatomic, strong) IBOutlet UILabel *featured_title;

@property (nonatomic, strong) IBOutlet UIView *FeaturedView;
@property (nonatomic, strong) IBOutlet UIView *HuntView;
@property (nonatomic, strong) IBOutlet UIView *FollowingView;

@property (nonatomic, strong) IBOutlet UIView *subscribedView;

@property (nonatomic, strong) IBOutlet UILabel *name;
@property (nonatomic, strong) IBOutlet UILabel *description;
@property (nonatomic, strong) IBOutlet UIImageView *image1;
@property (nonatomic, strong) IBOutlet UIImageView *image2;
@property (nonatomic, strong) IBOutlet UIImageView *image3;

@property (nonatomic, strong) IBOutlet UIButton *action;

@property (nonatomic, strong) IBOutlet UILabel *name2;
@property (nonatomic, strong) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) IBOutlet UIImageView *image1a;
@property (nonatomic, strong) IBOutlet UIImageView *image2a;
@property (nonatomic, strong) IBOutlet UIImageView *image3a;
@property (nonatomic, strong) IBOutlet UIImageView *image4a;

@property (nonatomic, strong) IBOutlet YookaButton *go_hunt;

@property (nonatomic, strong) IBOutlet UILabel *name3a;
@property (nonatomic, strong) IBOutlet UILabel *description3;
@property (nonatomic, strong) IBOutlet UILabel *name3b;
@property (nonatomic, strong) IBOutlet UILabel *name3c;
@property (nonatomic, strong) IBOutlet UIImageView *image1c;
@property (nonatomic, strong) IBOutlet UIImageView *image2c;
@property (nonatomic, strong) IBOutlet UIImageView *image3c;
@property (nonatomic, strong) IBOutlet UIImageView *image4c;

@property (nonatomic, strong) IBOutlet YookaButton *action3a;
@property (nonatomic, strong) IBOutlet YookaButton *action3b;

@property (nonatomic, strong) IBOutlet UIView *modalView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) IBOutlet UIButton *closeButton2;
@property (nonatomic, strong) IBOutlet UIScrollView* gridScrollView;
@property (nonatomic, strong) IBOutlet UILabel *description2;
@property (nonatomic, strong) IBOutlet UIImageView *badgeView;
@property (nonatomic, strong) IBOutlet UIImageView *badgeView2;
@property (nonatomic, strong) IBOutlet UIImageView *badgeView3;
@property (nonatomic, strong) IBOutlet FUIButton *startButton;

@property (nonatomic, strong) NSMutableArray *unsubscribedHunts;
@property (nonatomic, strong) NSMutableArray *unsubscribedHuntNames;
@property (nonatomic, strong) NSMutableArray *featuredHuntNames;
@property (nonatomic, strong) NSMutableArray *featuredHuntNames2;
@property (nonatomic, strong) NSMutableArray *subscribedHunts;
@property (nonatomic, strong) NSMutableArray *subscribedHuntNames;
@property (nonatomic, strong) NSMutableArray *followingUserSubscribedHuntNames;
@property (nonatomic, strong) NSMutableArray *followingUserSubscribedHunts;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, strong) NSMutableArray *objects2;

@property (nonatomic, strong) NSMutableArray *unsubscribedHunts2b;
@property (nonatomic, strong) NSMutableArray *unsubscribedHuntNames2b;
@property (nonatomic, strong) NSMutableArray *subscribedHunts2b;
@property (nonatomic, strong) NSMutableArray *subscribedHuntNames2b;
@property (nonatomic, strong) NSMutableArray *followingUserSubscribedHuntNames2b;
@property (nonatomic, strong) NSMutableArray *followingUserSubscribedHunts2b;

@property (nonatomic, strong) NSString *startedHunt;

@property (nonatomic, strong) NSDictionary *dict1;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;

@property (nonatomic, strong) NSDictionary *dict2;
@property (nonatomic, strong) NSString *collectionName2;
@property (nonatomic, strong) NSString *customEndpoint2;
@property (nonatomic, strong) NSString *fieldName2;

@property (nonatomic, strong) NSDictionary *dict3;
@property (nonatomic, strong) NSString *collectionName3;
@property (nonatomic, strong) NSString *customEndpoint3;
@property (nonatomic, strong) NSString *fieldName3;

@property (nonatomic, strong) NSMutableDictionary *huntDict1;
@property (nonatomic, strong) NSMutableDictionary *huntDict2;
@property (nonatomic, strong) NSMutableDictionary *huntDict3;

@property (nonatomic, strong) NSMutableDictionary *huntDict4;
@property (nonatomic, strong) NSMutableDictionary *huntDict5;
@property (nonatomic, strong) NSMutableDictionary *huntDict6;

@property (nonatomic, strong) NSMutableArray *following_users;
@property (nonatomic, strong) NSMutableArray *following_users2;
@property (nonatomic, strong) NSMutableArray *following_users3;

@property (nonatomic, strong) NSMutableArray *following_users2b;
@property (nonatomic, strong) NSMutableArray *following_users2b2;

@property (nonatomic, strong) NSMutableArray *following_users_fullname;
@property (nonatomic, strong) NSMutableArray *following_users_userpicurl;
@property (nonatomic, strong) NSMutableArray *following_users_huntname;
@property (nonatomic, strong) NSMutableArray *following_users_email;
@property (nonatomic, strong) NSMutableArray *following_users_logopicurl;
@property (nonatomic, strong) NSMutableArray *following_users_userpicurl2;
@property (nonatomic, strong) NSMutableArray *following_users_fullname2;

@property (nonatomic, strong) NSMutableArray *following_users_fullname2b;
@property (nonatomic, strong) NSMutableArray *following_users_userpicurl2b;
@property (nonatomic, strong) NSMutableArray *following_users_huntname2b;
@property (nonatomic, strong) NSMutableArray *following_users_email2b;
@property (nonatomic, strong) NSMutableArray *following_users_logopicurl2b;
@property (nonatomic, strong) NSMutableArray *following_users_userpicurl2b2;
@property (nonatomic, strong) NSMutableArray *following_users_fullname2b2;

@property (nonatomic, strong) NSString *cupcakeCount;
@property (nonatomic, strong) NSString *skylineCount;
@property (nonatomic, strong) NSString *bbqCount;
@property (nonatomic, strong) NSString *brunchCount;
@property (nonatomic, strong) NSString *huntCount;
@property (nonatomic, strong) NSString *huntCount2;

@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *myPicUrl;
@property (nonatomic, strong) NSString *myEmail;
@property (nonatomic, strong) NSString *myFullName;

@property (nonatomic, strong) NSMutableDictionary *featuredHuntsDictionary;
@property (nonatomic, strong) NSMutableDictionary *featuredHuntsDictionary2b;


@property (nonatomic, strong) IBOutlet UIView *UserPicBorder1;
@property (nonatomic, strong) IBOutlet UIView *UserPicBorder2;

@property (nonatomic, strong) NSString *userEmailSelected;
@property (nonatomic, strong) NSString *userFullNameSelected;
@property (nonatomic, strong) NSString *userPicUrlSelected;

@property (nonatomic, strong) NSString *huntDone;
@property (nonatomic, strong) NSString *huntDone2;

@property (nonatomic, strong) UIImage* userImage;

@property (nonatomic, retain) id<KCSStore> updateStore;

@property (nonatomic, strong) NSMutableArray *newsFeed;

@property(strong, nonatomic) YookaNewsFeedViewController *controllerB;

@property (nonatomic, strong) NSString *accessToken;

@property (nonatomic, strong) NSMutableArray *cacheFeaturedHuntNames;
@property (nonatomic, strong) NSMutableDictionary *cacheHuntDescription;
@property (nonatomic, strong) NSMutableDictionary *cacheHuntCount;
@property (nonatomic, strong) NSMutableDictionary *cacheHuntLogoUrl;
@property (nonatomic, strong) NSMutableArray *cachesubscribedHuntNames;
@property (nonatomic, strong) NSMutableArray *cacheUnSubscribedHuntNames;
@property (nonatomic, strong) NSMutableArray *cacheFollowingUsers;

@property (nonatomic, strong) NSMutableArray *cacheFeaturedHuntNames2;
@property (nonatomic, strong) NSMutableDictionary *cacheHuntDescription2;
@property (nonatomic, strong) NSMutableDictionary *cacheHuntCount2;
@property (nonatomic, strong) NSMutableDictionary *cacheHuntLogoUrl2;
@property (nonatomic, strong) NSMutableArray *cachesubscribedHuntNames2;
@property (nonatomic, strong) NSMutableArray *cacheUnSubscribedHuntNames2;
@property (nonatomic, strong) NSMutableArray *cacheFollowingUsers2;

@end
