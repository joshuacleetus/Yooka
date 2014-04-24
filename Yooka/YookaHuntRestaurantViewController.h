//
//  YookaHuntRestaurantViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 3/8/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <KinveyKit/KinveyKit.h>
#import <FacebookSDK.h>
#import <MapKit/MapKit.h>
#import <FUIButton.h>

@protocol sendrestaurantdataProtocol <NSObject>

-(void)sendrestaurantDataToA:(NSString *)selectedHuntName; //I am thinking my data is NSArray , you can use another object for store your information.

@end

@interface YookaHuntRestaurantViewController : UIViewController<MKMapViewDelegate>{
    int i;
    int j;
    int k;
    int skip;
    int item;
    int row;
    int col;
    int contentSize;
}

@property (nonatomic, strong) NSMutableArray *selectedRestaurant;
@property (nonatomic, strong) NSString *selectedRestaurantName;
@property (nonatomic, strong) NSString *huntTitle;
@property (nonatomic, strong) NSString *locationId;
@property (nonatomic, strong) NSString *venueId;
@property (nonatomic, strong) NSString *subscribed;
@property (nonatomic,assign) id delegate;
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
@property (nonatomic, strong) IBOutlet FUIButton *menuButton;

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

@property (nonatomic, strong) NSString *userEmail;

@property (nonatomic, strong) NSDictionary *dict2;
@property (nonatomic, strong) NSString *collectionName2;
@property (nonatomic, strong) NSString *customEndpoint2;
@property (nonatomic, strong) NSString *fieldName2;

@property (nonatomic, strong) NSMutableArray *userNames;
@property (nonatomic, strong) NSMutableArray *userEmails;
@property (nonatomic, strong) NSMutableArray *userPicUrls;

@end
