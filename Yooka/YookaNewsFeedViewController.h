//
//  YookaNewsFeedViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 11/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>
#import <FacebookSDK.h>
#import "PanelDelegate.h"

@interface YookaNewsFeedViewController : UIViewController<UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate,UITabBarControllerDelegate,UIScrollViewDelegate>{
    int i;
    int j;
    int k;
    int l;
    int n;
    int skip;
    int item;
    int row;
    int col;
    int contentSize;
    int contentSize2;
    
    CGRect new_page_frame;

    int z;
    
    int  toggle_toppic;
    // this array keeps track of which picture's comments are displayed
    NSInteger toggle[25];
    
    long total_featured_hunts;
    long total_hunts;

}

@property (nonatomic, strong) IBOutlet UIImageView *titleView;
@property (nonatomic, strong) IBOutlet UIImageView *subTitleView;

@property (nonatomic, strong) IBOutlet UIImageView *detailsModalView;
@property (nonatomic, strong) IBOutlet UIImageView *captionModalView;

@property (nonatomic, strong) IBOutlet UIButton *button;
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
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSArray *queryArray;
@property (nonatomic, strong) NSMutableArray *following_users;
@property (nonatomic, strong) NSMutableArray *postsData;
@property (nonatomic, strong) IBOutlet UITableView *postsTableView;
@property (nonatomic, strong) IBOutlet UIRefreshControl *customRefreshControl;

@property (nonatomic, strong) UILabel *descriptionLabel;
@property (retain) NSIndexPath *lastSelected;
@property (nonatomic, strong) NSMutableArray *newsFeed;
@property (nonatomic, strong) NSMutableArray *newsFeed2;
@property (nonatomic, strong) NSMutableArray *newsFeed3;
@property (nonatomic, strong) NSMutableArray *newsFeed4;
@property (nonatomic, strong) NSMutableArray *newsFeed5;

@property (nonatomic, strong) NSMutableArray *newsfeed_images;
@property (nonatomic, strong) NSMutableArray *newsfeed_userid;
@property (nonatomic, strong) NSMutableArray *newsfeed_userimages;
@property (nonatomic, strong) NSMutableArray *newsfeed_dishname;
@property (nonatomic, strong) NSMutableArray *newsfeed_caption;
@property (nonatomic, strong) NSMutableArray *newsfeed_postvote;
@property (nonatomic, strong) NSMutableArray *newsfeed_posttype;
@property (nonatomic, strong) NSMutableArray *newsfeed_kinvey_id;
@property (nonatomic, strong) NSMutableArray *newsfeed_kinveyid;
@property (nonatomic, strong) NSMutableArray *newsfeed_huntname;
@property (nonatomic, strong) NSMutableArray *newsfeed_postdate;
@property (nonatomic, strong) NSMutableArray *newsfeed_useremail;
@property (nonatomic, strong) NSMutableArray *newsfeed_userfullname;
@property (nonatomic, strong) NSMutableArray *newsfeed_venueaddress;
@property (nonatomic, strong) NSMutableArray *newsfeed_venuecc;
@property (nonatomic, strong) NSMutableArray *newsfeed_venuecity;
@property (nonatomic, strong) NSMutableArray *newsfeed_venuecountry;
@property (nonatomic, strong) NSMutableArray *newsfeed_venueid;
@property (nonatomic, strong) NSMutableArray *newsfeed_venuename;
@property (nonatomic, strong) NSMutableArray *newsfeed_venuepostalcode;
@property (nonatomic, strong) NSMutableArray *newsfeed_venuestate;

@property (nonatomic, strong) UIScrollView* gridScrollView;
@property (nonatomic, strong) NSMutableArray* thumbnails;
@property (nonatomic, strong) NSMutableArray* thumbnails2;

@property (nonatomic, strong) NSString *likes;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *postHuntName;
@property (nonatomic, strong) NSString *postCaption;
@property (nonatomic, strong) NSString *postDishImageUrl;
@property (nonatomic, strong) UIImage *postDishImage;
@property (nonatomic, strong) UIImage *postUserImage;
@property (nonatomic, strong) UIImage *postLikeImage;
@property (nonatomic, strong) NSString *postDishName;
@property (nonatomic, strong) NSString *postLikes;
@property (nonatomic, retain) KCSMetadata *postMetadata;

@property (nonatomic, strong) NSMutableArray *postLikers;
@property (nonatomic, strong) NSMutableArray *likesData;
@property (nonatomic, strong) NSMutableArray *likersData;
@property (nonatomic, strong) NSMutableArray *userNames;
@property (nonatomic, strong) NSMutableArray *userEmails;
@property (nonatomic, strong) NSMutableArray *userPicUrls;
@property (nonatomic, strong) NSMutableArray *subscribedHunts;
@property (nonatomic, strong) NSMutableArray *unSubscribedHunts;

//@property (nonatomic, strong) NSMutableArray *followerUsers;

@property (nonatomic, strong) NSDate *postDate;
@property (nonatomic, strong) NSString *postVote;
@property (nonatomic, strong) NSString *postEmailId;
@property (nonatomic, strong) NSString *postVenueId;
@property (nonatomic, strong) NSString *postVenueName;
@property (nonatomic, strong) NSString *postVenueAddress1;
@property (nonatomic, strong) NSString *likeStatus;
@property (nonatomic, strong) NSString *myEmail;

//@property (nonatomic, assign) NSInteger toggle[25];
@property (nonatomic, assign) NSString* toggle3;

@property (nonatomic, strong) NSDate *methodStart;
@property (nonatomic, strong) NSDate *methodFinish;

@property (nonatomic, retain) id<KCSStore> updateStore;
@property (nonatomic, retain) KCSCachedStore* updateStore2;
@property (nonatomic, retain) KCSCachedStore* updateStore3;
@property (nonatomic, retain) KCSCachedStore* updateStore4;
@property (nonatomic, retain) KCSCachedStore* updateStore5;

@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *venueCc;
@property (nonatomic, strong) NSString *venueCity;
@property (nonatomic, strong) NSString *venueCountry;
@property (nonatomic, strong) NSString *venuePostalCode;
@property (nonatomic, strong) NSString *venueState;
@property (nonatomic, strong) NSString *reload_toggle;
@property (nonatomic, strong) NSString *cache_toggle;

@property (nonatomic, strong) NSNumber *yayVote;
@property (nonatomic, strong) NSNumber *nayVote;

- (void)reloadView;
-(void)setupNewsFeed;

@property (nonatomic, assign) id<PanelDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *navButton;
@property (strong, nonatomic) IBOutlet UIButton *navButton2;
@property (strong, nonatomic) IBOutlet UIButton *navButton3;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *topCommentButton;

@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) BOOL panelMovedRight;

@property (nonatomic, strong) NSMutableArray *timeArray;
@property (nonatomic, strong) NSMutableArray *avgArray;

@property (nonatomic, strong) NSMutableArray *sponsored_hunt_names;

@property (nonatomic, assign) BOOL working;

@property (nonatomic, strong) IBOutlet UIPageControl *hunts_pages;

@property (nonatomic, strong) IBOutlet UIScrollView *topScrollView;
@property (nonatomic, strong) IBOutlet UIView *FeaturedView;

@property (nonatomic, strong) NSMutableDictionary *huntPicUrlDict;

@property (nonatomic, strong) IBOutlet UIImageView *instruction_screen_1;
@property (nonatomic, strong) IBOutlet UIImageView *instruction_screen_2;
@property (nonatomic, strong) IBOutlet UIImageView *instruction_screen_3;
@property (nonatomic, strong) IBOutlet UIImageView *instruction_screen_4;

@property (strong, nonatomic) IBOutlet UIButton *next_button;

@property (nonatomic, strong) NSString *yooka_check;

@end
