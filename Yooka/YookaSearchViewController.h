//
//  YookaSearchViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 12/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>
#import <FacebookSDK.h>
#import <FUIButton.h>
#import "PanelDelegate.h"
#import <CoreLocation/CoreLocation.h>
@class FSVenue;

@interface YookaSearchViewController : UIViewController<UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate,CLLocationManagerDelegate,UIGestureRecognizerDelegate>{
    int j,k;
    int skip;
}

@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *userEmailSelected;
@property (nonatomic, strong) NSString *userFullNameSelected;
@property (nonatomic, strong) NSString *userPicUrlSelected;
@property (nonatomic, strong) NSString *tryl;

@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSMutableArray *userFollowing;
@property (nonatomic, strong) NSMutableArray *userFollowingEmail;
@property (nonatomic, strong) NSMutableArray *userFollowingFullName;
@property (nonatomic, strong) NSMutableArray *userFollowingPicture;
@property (nonatomic, strong) NSMutableArray *userFollowingPictureUrl;

@property (nonatomic, strong) NSMutableArray *peopleArray;
@property (nonatomic, strong) NSMutableArray *searchArray;

@property (nonatomic, strong) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UITextField *location_textField;

@property (strong, nonatomic) IBOutlet UILabel *inviteFriendsLabel;
@property (strong, nonatomic) IBOutlet FUIButton *inviteButton;

@property (nonatomic, strong) UIImage* userImage;
@property (nonatomic, strong) UIImageView* horz_line3;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (retain) NSIndexPath *lastSelected;

@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;
@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) NSString *collectionName2;
@property (nonatomic, strong) NSString *customEndpoint2;
@property (nonatomic, strong) NSString *fieldName2;
@property (nonatomic, strong) NSDictionary *dict2;

@property (nonatomic, strong) NSArray* objects;
@property (nonatomic, strong) NSString *myEmail;

@property (nonatomic, assign) id<PanelDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *navButton;
@property (strong, nonatomic) IBOutlet UIButton *navButton2;
@property (strong, nonatomic) IBOutlet UIButton *navButton3;

@property (strong, nonatomic) IBOutlet UIButton* tap_button;

- (IBAction)navButtonClicked:(id)sender;

@property (nonatomic, strong) IBOutlet UIImageView *peopleSearch;
@property (nonatomic, strong) IBOutlet UIImageView *placesSearch;

@property (nonatomic, strong) IBOutlet UITableView *locationTableView;
@property (strong, nonatomic) NSArray *nearbyVenues;
@property (strong, nonatomic) NSMutableArray *locationObjects;

@property (strong, nonatomic) IBOutlet UIView* locationView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (strong, nonatomic) FSVenue *selected;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *titleLabel2;

@property (nonatomic, strong) NSString *venueSelected;
@property (nonatomic, strong) NSString *venueId;
@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *venueCc;
@property (nonatomic, strong) NSString *venueCity;
@property (nonatomic, strong) NSString *venueCountry;
@property (nonatomic, strong) NSString *venuePostalCode;
@property (nonatomic, strong) NSString *venueState;

@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) BOOL panelMovedRight;

@end
