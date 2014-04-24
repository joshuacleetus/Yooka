//
//  YookaSearchLandingViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 4/5/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YookaSearchLandingViewController : UIViewController<UITableViewDataSource,UIAlertViewDelegate,UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *searchTableView;
@property (nonatomic, strong) NSMutableArray *searchContent;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (retain) NSIndexPath *lastSelected;


@end