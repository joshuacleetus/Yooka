//
//  YookaLocation2ViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 4/5/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@class FSVenue;

@interface YookaLocation2ViewController : UIViewController<UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate,CLLocationManagerDelegate>

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
@property (nonatomic, strong) NSString *venueId;
@property (strong, nonatomic) NSArray *locationSelected;
@property(nonatomic,assign)id delegate;
@property (strong, nonatomic) IBOutlet UISearchBar *locationSearch;



@end
