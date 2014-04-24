//
//  UserFollowersViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 3/3/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>

@interface UserFollowersViewController : UIViewController<UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate>{
    int j;
}

@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) NSString *followerEmail;
@property (nonatomic, strong) NSString *followerPicUrl;
@property (nonatomic, strong) NSString *followerFullName;

@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSMutableArray *userFollowing;
@property (nonatomic, strong) NSMutableArray *userFollowingEmail;
@property (nonatomic, strong) NSMutableArray *userFollowingFullName;
@property (nonatomic, strong) IBOutlet UITableView *followerTableView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableArray *followers;
@property (nonatomic, strong) NSMutableArray *followersData;
@property (nonatomic, strong) NSMutableArray *followersPicUrls;
@property (nonatomic, strong) NSMutableArray *followersFullNames;

@property(nonatomic,assign)id delegate;
@property (strong, nonatomic) IBOutlet UISearchBar *followingSearch;
@property (strong,nonatomic) NSMutableArray *filteredArray;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;
@property (nonatomic, strong) NSDictionary *dict;

@property (nonatomic, strong) UIImage* userImage;
@property (nonatomic, strong) UILabel *descriptionLabel;

@property (retain) NSIndexPath *lastSelected;

@property (nonatomic, strong) NSString *userEmailSelected;
@property (nonatomic, strong) NSString *userFullNameSelected;
@property (nonatomic, strong) NSString *userPicUrlSelected;

@end
