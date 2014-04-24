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

@interface YookaNewsFeedViewController : UIViewController<UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate>{
    int i;
    int j;
    int k;
    int l;
    int skip;
    int item;
    int row;
    int col;
    int contentSize;
}
@property (nonatomic, strong) IBOutlet UIImageView *titleView;
@property (nonatomic, strong) IBOutlet UIImageView *subTitleView;
@property (nonatomic, strong) IBOutlet UIButton *button;
@property (nonatomic, strong) NSDictionary *dict1;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;
@property (nonatomic, strong) NSDictionary *dict2;
@property (nonatomic, strong) NSString *collectionName2;
@property (nonatomic, strong) NSString *customEndpoint2;
@property (nonatomic, strong) NSString *fieldName2;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSArray *queryArray;
@property (nonatomic, strong) NSMutableArray *following_users;
@property (nonatomic, strong) NSMutableArray *postsData;
@property (nonatomic, strong) IBOutlet UITableView *postsTableView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (retain) NSIndexPath *lastSelected;
@property (nonatomic, strong) NSMutableArray *newsFeed;
@property (nonatomic, strong) UIScrollView* gridScrollView;
@property (nonatomic, strong) NSMutableArray* thumbnails;
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

@property (nonatomic, strong) NSDate *postDate;
@property (nonatomic, strong) NSString *postVote;
@property (nonatomic, strong) NSString *postEmailId;
@property (nonatomic, strong) NSString *postVenueId;
@property (nonatomic, strong) NSString *postVenueName;
@property (nonatomic, strong) NSString *postVenueAddress1;
@property (nonatomic, strong) NSString *likeStatus;

@property (nonatomic, retain) id<KCSStore> updateStore;

@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *venueCc;
@property (nonatomic, strong) NSString *venueCity;
@property (nonatomic, strong) NSString *venueCountry;
@property (nonatomic, strong) NSString *venuePostalCode;
@property (nonatomic, strong) NSString *venueState;

@property (nonatomic, strong) NSNumber *yayVote;
@property (nonatomic, strong) NSNumber *nayVote;

@end
