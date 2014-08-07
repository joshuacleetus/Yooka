//
//  YookaLocationViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 16/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol senddataProtocol <NSObject>

-(void)sendLocationDataToA:(NSArray *)locationSelected; //I am thinking my data is NSArray , you can use another object for store your information.

@end

@class FSVenue;

@interface YookaLocationViewController : UIViewController<UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) IBOutlet UITableView *locationTableView;
@property (strong, nonatomic) NSMutableArray *nearbyVenues;
@property (strong, nonatomic) NSMutableArray *locationObjects;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (strong, nonatomic) FSVenue *selected;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (retain) NSIndexPath *lastSelected;
@property (nonatomic, strong) NSString *venueSelected;
@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *venueCc;
@property (nonatomic, strong) NSString *venueCity;
@property (nonatomic, strong) NSString *venueCountry;
@property (nonatomic, strong) NSString *venuePostalCode;
@property (nonatomic, strong) NSString *venueState;
@property (strong, nonatomic) NSMutableArray *locationSelected;
@property(nonatomic,assign)id delegate;
@property (strong, nonatomic) IBOutlet UISearchBar *locationSearch;

@property (nonatomic, strong) UILabel *detailLabel;

@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;

@end
