//
//  YookaViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 09/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit.h>
#import <FacebookSDK.h>

@interface YookaViewController : UIViewController<UIApplicationDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) IBOutlet UIImageView *logoImage;
@property (nonatomic,strong) IBOutlet FUIButton *fbBtn;
@property (nonatomic,strong) IBOutlet FUIButton *signInBtn;
@property (nonatomic,strong) IBOutlet FUIButton *signUpBtn;
@property (strong, nonatomic) IBOutlet FUIButton *termsBtn;

- (IBAction)fbBtnTouched:(id)sender;
- (IBAction)signInBtnTouched:(id)sender;
- (IBAction)signUpBtnTouched:(id)sender;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

@property (strong,nonatomic) IBOutlet UIImageView* imageView12;
@property (strong,nonatomic) IBOutlet UIImageView* imageView13;
@property (strong,nonatomic) IBOutlet UIImageView* imageView14;

@end
