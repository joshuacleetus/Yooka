//
//  YookaPostViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 12/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DYRateView.h>
#import <FlatUIKit.h>
#import <KinveyKit/KinveyKit.h>
#import <FacebookSDK.h>

@interface YookaPostViewController : UIViewController<UINavigationControllerDelegate,UINavigationBarDelegate,UITextViewDelegate,DYRateViewDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView *titleView;
@property (nonatomic, strong) IBOutlet UIImageView *pictureView;
@property (nonatomic, strong) IBOutlet UILabel *bglineLabel;
@property (nonatomic, strong) IBOutlet UIImageView *cameraView;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *rateLabel;
@property (nonatomic, strong) IBOutlet UIImageView *voteImageview;
@property (nonatomic, strong) IBOutlet UILabel *voteLabel;
@property (nonatomic, strong) IBOutlet UILabel *yayLabel;
@property (nonatomic, strong) IBOutlet UILabel *nayLabel;
@property (nonatomic, strong) IBOutlet UILabel *orLabel;
@property (nonatomic, strong) IBOutlet UIImageView *yayImageview;
@property (nonatomic, strong) IBOutlet UIImageView *nayImageview;
@property (nonatomic, strong) IBOutlet UIButton *yayButton;
@property (nonatomic, strong) IBOutlet UIButton *nayButton;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, strong) NSString *venueID;
@property (nonatomic, strong) NSString *venueSelected;
@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *venueCc;
@property (nonatomic, strong) NSString *venueCity;
@property (nonatomic, strong) NSString *venueCountry;
@property (nonatomic, strong) NSString *venuePostalCode;
@property (nonatomic, strong) NSString *venueState;
@property (nonatomic, strong) NSString *menuSelected;
@property (nonatomic, strong) NSString *rateValue;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) NSString *huntName;
@property (nonatomic, strong) NSString *postVote;
@property (nonatomic, strong) IBOutlet UIImageView *commentView;
@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) IBOutlet UILabel *menuLabel;

@property (nonatomic, strong) IBOutlet UIButton *changePic;
@property (nonatomic, strong) IBOutlet UIButton *downArrow1;
@property (nonatomic, strong) IBOutlet UIButton *downArrow2;
@property (nonatomic, strong) IBOutlet UIButton *locationButton;
@property (nonatomic, strong) IBOutlet UIButton *menuButton;
@property (nonatomic, strong) IBOutlet FUIButton *postBtn;
@property (nonatomic, strong) IBOutlet UITextView *quickNote;
@property (nonatomic, strong) IBOutlet UILabel *rateLabel2;
@property (nonatomic, strong) UIImage* uploadImage;
@property (nonatomic, strong) UIImage* userImage;
@property (nonatomic, strong) IBOutlet UIImageView *dishImage;
@property (nonatomic, retain) id<KCSStore> updateStore;
@property (nonatomic, strong) NSMutableArray* followingList;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;
@property (nonatomic, strong) NSDictionary *dict1;
@property (nonatomic, strong) NSMutableArray *objects;
@property (nonatomic, retain) UITabBarController *yookaTabBar;

@end
