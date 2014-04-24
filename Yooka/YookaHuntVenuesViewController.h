//
//  YookaHuntVenuesViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 3/8/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <FUIButton.h>

@interface YookaHuntVenuesViewController : UIViewController<UIAlertViewDelegate,UIScrollViewAccessibilityDelegate,UIScrollViewDelegate,CLLocationManagerDelegate, MKMapViewDelegate,UITableViewDelegate, UITableViewDataSource,UIDocumentInteractionControllerDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate> {
    int k;
    int count,size,count2,size2;
    int i, y,y2;
    CGRect new_dish_frame;
    CGRect new_dish_frame2;

}

@property UIColor *color;

@property (nonatomic, strong) IBOutlet UIScrollView *gridScrollView;


@property (nonatomic, strong) NSString *huntTitle;
@property (nonatomic, strong) IBOutlet UIImageView *huntTitleImageView;
@property (nonatomic, strong) IBOutlet UIImageView *userNameImageView;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) UIImage* userImage;
@property (nonatomic, strong) IBOutlet UIImageView *userView;
@property (nonatomic, strong) NSDictionary *dict1;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;
@property (nonatomic, strong) NSDictionary *dict2;
@property (nonatomic, strong) NSString *collectionName2;
@property (nonatomic, strong) NSString *customEndpoint2;
@property (nonatomic, strong) NSString *fieldName2;
@property (nonatomic, strong) NSString *tapTag;
@property (nonatomic, strong) NSString *restaurantName;

@property (nonatomic, strong) IBOutlet UILabel *usernameLbl;
@property (nonatomic, strong) NSArray *featuredRestaurants;
@property (nonatomic, strong) IBOutlet UIScrollView* dishScrollView;
@property (nonatomic, strong) IBOutlet UIView *DishView;

@property (nonatomic, strong) UIImage *dishImage;
@property (nonatomic, strong) UIImageView *dishImageView;
@property (nonatomic, strong) UILabel *dishName;
@property (nonatomic, strong) IBOutlet UIButton *dishButton;

@property (nonatomic, strong) IBOutlet UIScrollView* mapScrollView;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) NSTimer *locationTimer;
@property (nonatomic, retain) CLLocation* oldLocation;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSString* longitude;
@property (nonatomic, strong) NSString* latitude;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;

@property (nonatomic, strong) UIColor *yookaGreen;
@property (nonatomic, strong) UIColor *yookaGreen2;
@property (nonatomic, strong) UIColor *yookaOrange;
@property (nonatomic, strong) UIColor *yookaOrange2;

@property (nonatomic, strong) NSMutableArray *selectedRestaurant;
@property (nonatomic, strong) NSString *selectedRestaurantName;

@property (nonatomic, strong) IBOutlet UIView *modalView;
@property (nonatomic, strong) IBOutlet UIView *modalView2;

@property (nonatomic, strong) IBOutlet UILabel *huntTitleLabel;

@property (nonatomic, strong) IBOutlet UIImageView *badgeImageView;
@property (nonatomic, strong) IBOutlet UIImageView *badgeDishImageView;
@property (nonatomic, strong) IBOutlet UIImageView *yookaImageView;

@property (nonatomic, strong) IBOutlet UILabel *restaurantTitleLabel;
@property (nonatomic, strong) IBOutlet UIButton *restaurantTitleButton2;

@property (nonatomic, strong) IBOutlet FUIButton *restaurantTitleButton;
@property (nonatomic, strong) IBOutlet UILabel *restaurantDescriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *youMight;
@property (nonatomic, strong) IBOutlet UIButton *closeButton;
@property (nonatomic, strong) IBOutlet UIButton *closeButton2;

@property (nonatomic, strong) IBOutlet UITableView *dishtableView;

@property (nonatomic, strong) UILabel *descriptionLabel;

@property (retain) NSIndexPath *lastSelected;

@property (nonatomic, strong) NSMutableArray *selectedDishes;

@property (nonatomic, strong) IBOutlet FUIButton *uploadButton;

- (void)buttonAction1:(id)sender;

@property (nonatomic, strong) NSMutableArray *objects;

@property (nonatomic, strong) UIImage* fettesau;
@property (nonatomic, strong) UIImage* dinosaurbbq;
@property (nonatomic, strong) UIImage* hillcountrybbqbk;
@property (nonatomic, strong) UIImage* fattycue2;
@property (nonatomic, strong) UIImage* mablesbk;
@property (nonatomic, strong) UIImage* gaonnuri;
@property (nonatomic, strong) UIImage* ravelnyc;
@property (nonatomic, strong) UIImage* twothirtyfifth;
@property (nonatomic, strong) UIImage* labisteccany;
@property (nonatomic, strong) UIImage* riverpark;
@property (nonatomic, strong) UIImage* landmarc;
@property (nonatomic, strong) UIImage* babycakesnyc;
@property (nonatomic, strong) UIImage* amysbread;
@property (nonatomic, strong) UIImage* magnoliabakery;
@property (nonatomic, strong) UIImage* butterlane;
@property (nonatomic, strong) UIImage* buttercupbakeny;
@property (nonatomic, strong) UIImage* buttermilkchannel;
@property (nonatomic, strong) UIImage* shopsins;
@property (nonatomic, strong) UIImage* thedutch;
@property (nonatomic, strong) UIImage* jacobspickles;
@property (nonatomic, strong) UIImage* cafeorlin;

@property (nonatomic, strong) NSString* huntImageUrl;

@property (nonatomic, strong) NSString *fettesauUrl;
@property (nonatomic, strong) NSString *dinosaurbbqUrl;
@property (nonatomic, strong) NSString *hillcountrybbqbkUrl;
@property (nonatomic, strong) NSString *fattycue2Url;
@property (nonatomic, strong) NSString *mablesbkUrl;
@property (nonatomic, strong) NSString *gaonnuriUrl;
@property (nonatomic, strong) NSString *ravelnycUrl;
@property (nonatomic, strong) NSString *twothirtyfifthUrl;
@property (nonatomic, strong) NSString *labisteccanyUrl;
@property (nonatomic, strong) NSString *riverparkUrl;
@property (nonatomic, strong) NSString *landmarcUrl;
@property (nonatomic, strong) NSString *babycakesnycUrl;
@property (nonatomic, strong) NSString *amysbreadUrl;
@property (nonatomic, strong) NSString *magnoliabakeryUrl;
@property (nonatomic, strong) NSString *butterlaneUrl;
@property (nonatomic, strong) NSString *buttercupbakenyUrl;
@property (nonatomic, strong) NSString *buttermilkchannelUrl;
@property (nonatomic, strong) NSString *shopsinsUrl;
@property (nonatomic, strong) NSString *thedutchUrl;
@property (nonatomic, strong) NSString *jacobspicklesUrl;
@property (nonatomic, strong) NSString *cafeorlinUrl;
@property (nonatomic, strong) NSString *emailId;
@property (nonatomic, strong) NSString *trickpick;

@property (nonatomic, strong) IBOutlet UILabel *dishNumber;

@property (nonatomic, strong) NSString *huntDone;

@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *shareString;
@property (readwrite) BOOL includeURL;

@property (nonatomic, strong) UIBarButtonItem *presentFromButton;
// overwritten if shareImage is non-square, because the document-interaction-controller is presented in the resize view.

@property (nonatomic, strong) UIDocumentInteractionController *documentController;

@property(nonatomic,retain) UIDocumentInteractionController *docFile;



@end
