//
//  YookaRestaurantViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 6/9/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <KinveyKit/KinveyKit.h>
#import <FacebookSDK.h>
#import <MapKit/MapKit.h>

@class FSVenue;

@protocol sendrestaurantdataProtocol2 <NSObject>

-(void)sendrestaurantDataToA:(NSString *)selectedHuntName;

@end

@interface YookaRestaurantViewController : UIViewController<MKMapViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    int i;
    int j;
    int k;
    int l;
    int m;
    int n;
    int row, col, contentSize;
    int row2, col2, contentSize2;
    int row3, col3, contentSize3;
    int reviewRowHeight;
    
    int p;
    int q;
    UISearchDisplayController *searchDisplayController;
    CGRect new_page_frame;

}

@property (nonatomic, strong) NSMutableArray *selectedRestaurant;
@property (nonatomic, strong) NSString *selectedRestaurantName;
@property (nonatomic, strong) NSString *huntTitle;
@property (nonatomic, strong) NSString *locationId;
@property (nonatomic, strong) NSString *venueId;
@property (nonatomic, strong) NSString *subscribed;
@property (nonatomic,assign) id delegate2;
@property (nonatomic, strong) NSString *selectedHunt;
@property (nonatomic, strong) NSString *openHours;
@property (nonatomic, strong) IBOutlet UIImageView *panelImageView;
@property (nonatomic, strong) IBOutlet UIImageView *whiteBg;

@property (nonatomic, strong) IBOutlet UILabel *restaurantNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *addressLabel;
@property (nonatomic, strong) IBOutlet UILabel *cityLabel;
@property (nonatomic, strong) IBOutlet UIButton *button;
@property (nonatomic, strong) UIScrollView* gridScrollView;
@property (nonatomic, strong) NSMutableArray* thumbnails;

@property (nonatomic, strong) IBOutlet NSString *phoneLabel;
@property (nonatomic, strong) IBOutlet UILabel *phoneLabel2;

@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *hoursLabel;
@property (nonatomic, strong) IBOutlet UIButton *phoneCallButton;
@property (nonatomic, strong) IBOutlet UIButton *hoursButton;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSString* longitude;
@property (nonatomic, strong) NSString* latitude;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) NSTimer *locationTimer;
@property (nonatomic, retain) CLLocation* oldLocation;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
@property (nonatomic, strong) NSMutableArray *yookaObjects;
//@property (nonatomic, strong) IBOutlet FUIButton *menuButton;

@property (nonatomic, strong) UIColor *yookaGreen;
@property (nonatomic, strong) UIColor *yookaGreen2;
@property (nonatomic, strong) UIColor *yookaOrange;
@property (nonatomic, strong) UIColor *yookaOrange2;

@property (nonatomic, strong) NSDictionary *dict1;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;
@property (nonatomic, strong) NSMutableArray *newsFeed;

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
@property (nonatomic, strong) NSMutableArray *postLikers;
@property (nonatomic, strong) NSMutableArray *likesData;
@property (nonatomic, strong) NSMutableArray *likersData;
@property (nonatomic, strong) NSDate *postDate;
@property (nonatomic, strong) NSString *postVote;
@property (nonatomic, strong) NSString *postEmailId;
@property (nonatomic, strong) NSString *postVenueId;
@property (nonatomic, strong) NSString *postVenueName;
@property (nonatomic, strong) NSString *postVenueAddress1;
@property (nonatomic, strong) NSString *likeStatus;
@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *venueCc;
@property (nonatomic, strong) NSString *venueCity;
@property (nonatomic, strong) NSString *venueCountry;
@property (nonatomic, strong) NSString *venuePostalCode;
@property (nonatomic, strong) NSString *venueState;
@property (nonatomic, strong) NSString *teampic_url;

@property (nonatomic, strong) NSString *userEmail;

@property (nonatomic, strong) NSDictionary *dict2;
@property (nonatomic, strong) NSString *collectionName2;
@property (nonatomic, strong) NSString *customEndpoint2;
@property (nonatomic, strong) NSString *fieldName2;

@property (nonatomic, strong) NSMutableArray *userNames;
@property (nonatomic, strong) NSMutableArray *userEmails;
@property (nonatomic, strong) NSMutableArray *userPicUrls;

@property (nonatomic, retain) KCSCachedStore* updateStore2;
@property (nonatomic, retain) KCSCachedStore* updateStore3;
@property (nonatomic, strong) NSMutableArray *newsFeed2;

@property (nonatomic, assign) BOOL working;
@property (nonatomic, assign) NSString *toggle;

@property (nonatomic, strong) IBOutlet UIImageView *bgImageView;
@property (nonatomic, strong) IBOutlet UIImageView *bgImageView2;

@property (strong, nonatomic) IBOutlet UIView* reviewsView;
@property (strong, nonatomic) IBOutlet UIView* detailsView;
@property (strong, nonatomic) IBOutlet UIView* menuView;

@property (strong, nonatomic) IBOutlet UILabel* reviewsLabel;
@property (strong, nonatomic) IBOutlet UILabel* detailsLabel;
@property (strong, nonatomic) IBOutlet UILabel* menuLabel;

@property (nonatomic, strong) IBOutlet UIImageView *reviewsImageView;
@property (nonatomic, strong) IBOutlet UIImageView *detailsImageView;
@property (nonatomic, strong) IBOutlet UIImageView *menuImageView;

@property (strong, nonatomic) IBOutlet UIButton *reviewsButton;
@property (strong, nonatomic) IBOutlet UIButton *detailsButton;
@property (strong, nonatomic) IBOutlet UIButton *menuButton;

@property (strong, nonatomic) IBOutlet UIButton *uploadButton;

@property (nonatomic, strong) IBOutlet UIView *modalView;
@property (nonatomic, strong) IBOutlet UIImageView *detailsModalView;
@property (nonatomic, strong) IBOutlet UIImageView *captionModalView;

@property (nonatomic, assign) id<PanelDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (weak, nonatomic) IBOutlet UIButton *navButton2;
@property (weak, nonatomic) IBOutlet UIButton *navButton3;

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIImageView* backBtnImage;

@property (nonatomic, strong) UIScrollView* reviewScrollView;
@property (nonatomic, strong) UIScrollView* detailScrollView;
@property (nonatomic, strong) UIScrollView* menuScrollView;

@property (nonatomic, strong) IBOutlet UIImageView *telephonesImageView;
@property (nonatomic, strong) IBOutlet UIImageView *clockImageView;
@property (nonatomic, strong) IBOutlet UIImageView *priceImageView;
@property (nonatomic, strong) IBOutlet UIImageView *infoIconView;

@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSString *venueID;
@property (nonatomic, strong) NSString *venueSelected;
@property (nonatomic, strong) NSString *menuSelected;
@property (nonatomic, strong) NSArray *menu;
@property (nonatomic, strong) NSArray *menuData;
@property (nonatomic, strong) NSString *huntName;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (retain) NSIndexPath *lastSelected;
@property (nonatomic, strong) NSMutableArray *menuObjects;
@property (strong, nonatomic) IBOutlet UISearchBar *menuSearch;
@property (strong,nonatomic) NSMutableArray *filteredArray;

@property (weak, nonatomic) IBOutlet UIButton *linkButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic, strong) NSMutableArray *user_full_names;
@property (nonatomic, strong) NSMutableArray *user_pic_urls;

@property (nonatomic, strong) NSString *myEmail;

@property (nonatomic, strong) NSMutableArray *venuePics;
@property (nonatomic, strong) NSMutableArray *venuePicUrls;

@property (nonatomic, strong) IBOutlet UIScrollView *topScrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *hunts_pages;

@property (nonatomic, strong) IBOutlet UIView *FeaturedView;

@end
