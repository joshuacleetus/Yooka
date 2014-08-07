//
//  YookaProfileViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 12/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>
#import <FacebookSDK.h>
#import "PanelDelegate.h"

@interface YookaProfileViewController : UIViewController<UINavigationBarDelegate,UINavigationControllerDelegate,UIScrollViewAccessibilityDelegate,UIScrollViewDelegate>{
    int i;
    int j;
    CGRect new_post_frame;
    int skip;
    int item;
    int row;
    int col;
    int contentSize;
}

@property (nonatomic, strong) IBOutlet UIButton *logoutBtn;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) UIImage* userImage;
@property (nonatomic, strong) IBOutlet UIView *circle_one;
@property (nonatomic, strong) IBOutlet UIView *circle_two;
@property (nonatomic, strong) IBOutlet UIImageView *userView;
@property (nonatomic, strong) IBOutlet UIImageView *user_image;
@property (nonatomic, strong) IBOutlet UIImageView *profile_bg;
@property (nonatomic, strong) IBOutlet UIImageView *profile_bg1;
@property (nonatomic, strong) IBOutlet UILabel *usernameLbl;
@property (nonatomic, strong) IBOutlet UILabel *profileLbl1;
@property (nonatomic, strong) IBOutlet UILabel *userFollowingLbl;
@property (nonatomic, strong) IBOutlet UIButton *userFollowingBtn;
@property (nonatomic, strong) IBOutlet UILabel *userpicturesLbl;
@property (nonatomic, strong) IBOutlet UILabel *userFollowersLbl;
@property (nonatomic, strong) IBOutlet UIButton *userFollowersBtn;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;
@property (nonatomic, strong) NSDictionary *dict1;
@property (nonatomic, strong) IBOutlet UIView *modalView;
@property (nonatomic, strong) UIScrollView* gridScrollView;
@property (nonatomic, strong) NSMutableArray *myPosts;
@property (nonatomic, strong) IBOutlet UIView *PostsView;
@property (nonatomic, strong) IBOutlet UIImageView *post_imageview;
@property (nonatomic, strong) NSMutableArray* thumbnails;

@property (nonatomic, strong) NSMutableArray* followingUsers;
@property (nonatomic, strong) NSMutableArray* followerUsers;

@property (nonatomic, retain) id<KCSStore> updateStore;

@property (nonatomic, assign) id<PanelDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *navButton;

- (IBAction)navButtonClicked:(id)sender;

@end
