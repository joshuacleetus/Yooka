//
//  YookaCategoryViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 6/2/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YookaCategoryViewController : UIViewController {
    int i;
    int item;
    int row;
    int col;
    int contentSize;
}

@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) IBOutlet UIImageView* backBtnImage;
@property (strong, nonatomic) NSString *categoryName;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) NSMutableArray *categoryArray;

@property (nonatomic, strong) NSMutableArray *featuredHunts;
@property (nonatomic, strong) NSMutableArray *thumbnails;
@property (nonatomic, strong) NSMutableArray *image_array;

@property (nonatomic, strong) UIScrollView* gridScrollView;

@property (nonatomic, strong) NSMutableArray *subscribedHunts;
@property (nonatomic, strong) NSMutableArray *unsubscribedHunts;

@property (nonatomic, strong) UIImage* category_image;

@end
