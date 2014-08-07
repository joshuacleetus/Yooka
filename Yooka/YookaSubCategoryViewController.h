//
//  YookaSubCategoryViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 6/18/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YookaSubCategoryViewController : UIViewController{
    
    int i;
    int j;
    int item;
    int row;
    int col;
    int contentSize;
    
}

@property (nonatomic, strong) UIScrollView* gridScrollView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIImageView* backBtnImage;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *subCategoryName;
@property (strong, nonatomic) NSString *subCatPicUrl;

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *subCategoryArray;
@property (nonatomic, strong) NSMutableArray *featuredHunts;
@property (nonatomic, strong) NSMutableArray *thumbnails;

@property (nonatomic, strong) NSMutableDictionary *huntDict1;
@property (nonatomic, strong) NSMutableDictionary *huntDict2;
@property (nonatomic, strong) NSMutableDictionary *huntDict3;
@property (nonatomic, strong) NSMutableDictionary *huntDict4;
@property (nonatomic, strong) NSMutableDictionary *huntDict5;
@property (nonatomic, strong) NSMutableDictionary *huntDict6;

@property (nonatomic, strong) NSMutableArray *subscribedHunts;
@property (nonatomic, strong) NSMutableArray *unsubscribedHunts;
@property (nonatomic, strong) NSMutableArray *huntCounts;

@property (nonatomic, strong) NSString *myEmail;
@property (nonatomic, strong) NSString *active;

@end
