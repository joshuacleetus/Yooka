//
//  YookaMenu2ViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 3/12/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FSVenue;

@interface YookaMenu2ViewController : UIViewController<UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    UISearchDisplayController *searchDisplayController;

}

@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSString *venueID;
@property (nonatomic, strong) NSString *venueSelected;
@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *menuSelected;
@property (nonatomic, strong) NSArray *menu;
@property (nonatomic, strong) NSArray *menuData;
@property (nonatomic, strong) NSString *venueCc;
@property (nonatomic, strong) NSString *venueCity;
@property (nonatomic, strong) NSString *venueCountry;
@property (nonatomic, strong) NSString *venuePostalCode;
@property (nonatomic, strong) NSString *venueState;
@property (nonatomic, strong) NSString *huntName;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (retain) NSIndexPath *lastSelected;
@property (nonatomic, strong) NSMutableArray *menuObjects;
@property(nonatomic,assign)id delegate;
@property (strong, nonatomic) IBOutlet UISearchBar *menuSearch;
@property (strong,nonatomic) NSMutableArray *filteredArray;


@end
