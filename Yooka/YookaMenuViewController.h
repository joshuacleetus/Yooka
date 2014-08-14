//
//  YookaMenuViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 19/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol sendmenudataProtocol <NSObject>

-(void)sendMenuDataToA:(NSArray *)menuData; //I am thinking my data is NSArray , you can use another object for store your information.

@end

@class FSVenue;

@interface YookaMenuViewController : UIViewController<UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>{
    UISearchDisplayController *searchDisplayController;

}

@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSString *venueID;
@property (nonatomic, strong) NSString *venueSelected;
@property (nonatomic, strong) NSString *venueAddress;
@property (nonatomic, strong) NSString *menuSelected;
@property (strong, nonatomic) NSArray *menu;
@property (strong, nonatomic) NSMutableArray *menuData;
@property (nonatomic, strong) NSString *venueCc;
@property (nonatomic, strong) NSString *venueCity;
@property (nonatomic, strong) NSString *venueCountry;
@property (nonatomic, strong) NSString *venuePostalCode;
@property (nonatomic, strong) NSString *venueState;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (retain) NSIndexPath *lastSelected;
@property (nonatomic, strong) NSMutableArray *menuObjects;
@property (nonatomic, strong) NSMutableArray *searchData;

@property(nonatomic,assign)id delegate;
@property (strong, nonatomic) IBOutlet UISearchBar *menuSearch;

@property(nonatomic, strong) NSMutableArray *tableViewData;
@property(nonatomic, strong) NSMutableArray *originalTableViewData;
@property(nonatomic, strong) NSMutableArray *searchArray;
@property(nonatomic, strong) NSMutableDictionary *units;

@property (strong,nonatomic) NSMutableArray *filteredArray;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *addBtn;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end
