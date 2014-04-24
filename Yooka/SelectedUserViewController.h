//
//  SelectedUserViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 3/4/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>
#import <FacebookSDK.h>
#import <FlatUIKit.h>

@interface SelectedUserViewController : UIViewController<UINavigationBarDelegate,UINavigationControllerDelegate,UIScrollViewAccessibilityDelegate,UIScrollViewDelegate>{
    int i;
    int j;
    CGRect new_post_frame;
    int skip;
    int item;
    int row;
    int col;
    int contentSize;
}

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *myEmail;
@property (nonatomic, strong) NSString *myFullName;
@property (nonatomic, strong) UIImage* userImage;
@property (nonatomic, strong) IBOutlet UILabel *usernameLbl;
@property (nonatomic, strong) IBOutlet UIView *circle_one;
@property (nonatomic, strong) IBOutlet UIView *circle_two;
@property (nonatomic, strong) IBOutlet UIImageView *userView;
@property (nonatomic, strong) IBOutlet UIImageView *user_image;
@property (nonatomic, strong) IBOutlet UIImageView *profile_bg;
@property (nonatomic, strong) IBOutlet UIImageView *profile_bg1;
@property (nonatomic, strong) IBOutlet UILabel *profileLbl1;
@property (nonatomic, strong) IBOutlet UILabel *userFollowingLbl;
@property (nonatomic, strong) IBOutlet UIButton *userFollowingBtn;
@property (nonatomic, strong) IBOutlet UILabel *userpicturesLbl;
@property (nonatomic, strong) IBOutlet UILabel *userFollowersLbl;
@property (nonatomic, strong) IBOutlet UIButton *userFollowersBtn;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) NSDictionary *dict2;
@property (nonatomic, strong) NSString *collectionName2;
@property (nonatomic, strong) NSString *customEndpoint2;
@property (nonatomic, strong) NSString *fieldName2;

@property (nonatomic, strong) IBOutlet FUIButton *followBtn;
@property (nonatomic, strong) IBOutlet FUIButton *unFollowBtn;
@property (nonatomic, strong) NSMutableArray *following_users;
@property (nonatomic, strong) NSMutableArray *following_users2;
@property (nonatomic, strong) NSMutableArray *followers;
@property (nonatomic, strong) NSMutableArray *followers2;
@property (nonatomic, strong) NSArray* objects;
@property (nonatomic, strong) NSMutableArray* thumbnails;
@property (nonatomic, strong) NSMutableArray *myPosts;

@property (nonatomic, strong) UIScrollView* gridScrollView;

@property (nonatomic, strong) NSMutableArray* followingUsers;
@property (nonatomic, strong) NSMutableArray* followerUsers;

@end
