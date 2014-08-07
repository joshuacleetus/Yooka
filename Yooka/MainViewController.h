//
//  MainViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 5/28/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelDelegate.h"
#import "iCarousel.h"

@interface MainViewController : UIViewController<UIScrollViewDelegate,UINavigationControllerDelegate,UINavigationBarDelegate,UITabBarControllerDelegate,UIAlertViewDelegate,KCSOfflineUpdateDelegate, NSURLConnectionDelegate>

@property (nonatomic, assign) id<PanelDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *navButton;
@property (weak, nonatomic) IBOutlet UIButton *navButton2;

@property (nonatomic, strong) iCarousel *carousel;

@end
