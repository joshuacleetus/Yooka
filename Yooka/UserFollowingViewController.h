//
//  UserFollowingViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 3/3/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KinveyKit/KinveyKit.h>


@interface UserFollowingViewController : UIViewController<UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate>{
    int j;
//    UISearchDisplayController *searchDisplayController;

}
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) NSString *followingUserEmail;
@property (nonatomic, strong) NSString *followingUserPicUrl;
@property (nonatomic, strong) NSString *followingUserFullName;

@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) NSMutableArray *userFollowing;
@property (nonatomic, strong) NSMutableArray *userFollowingEmail;
@property (nonatomic, strong) NSMutableArray *userFollowingFullName;
@property (nonatomic, strong) IBOutlet UITableView *followingTableView;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic, strong) NSMutableArray *followingUsers;
@property (nonatomic, strong) NSMutableArray *followingUsersData;
@property (nonatomic, strong) NSMutableArray *followingUsersPicUrls;
@property (nonatomic, strong) NSMutableArray *followingUsersFullNames;

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
