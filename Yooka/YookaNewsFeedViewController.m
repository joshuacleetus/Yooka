//
//  YookaNewsFeedViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 11/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaNewsFeedViewController.h"
#import "YookaProfileViewController.h"
#import "YookaAppDelegate.h"
#import "YookaBackend.h"
#import <AsyncImageDownloader.h>
#import <QuartzCore/QuartzCore.h>
#import "BDViewController2.h"
#import "YookaHuntRestaurantViewController.h"
#import "YookaPostViewController.h"
#import <Reachability.h>
#import "UIImageView+WebCache.h"
#import "WebImageOperations.h"
#import "ImageCache.h"
#import "YookaRestaurantViewController.h"
#import "YookaButton.h"
#import "YookaProfileNewViewController.h"
#import "YookaClickProfileViewController.h"
#import "YookaHuntVenuesViewController.h"
#import "YookaFeaturedHuntViewController.h"
#import "UIImage+Crop.h"
#import "LLACircularProgressView.h"
#import "Flurry.h"

const NSInteger yookaThumbnailWidth3 = 320;
const NSInteger yookaThumbnailHeight3 = 270;
const NSInteger yookaImagesPerRow3 = 1;
const NSInteger yookaThumbnailSpace3 = 5;

@interface YookaNewsFeedViewController ()
@property (nonatomic, strong) LLACircularProgressView *circularProgressView;
@end

@implementation YookaNewsFeedViewController{
    NSTimer *_timer;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    //Do loading here
    
    i=0;
    j=0;
    n=0;
    skip = 50;
    _userEmail = [KCSUser activeUser].email;
    _following_users = [NSMutableArray new];
    _queryArray = [NSArray new];
    _newsFeed = [NSMutableArray new];
    _newsFeed2 = [NSMutableArray new];
    _newsFeed3 = [NSMutableArray new];
    _newsFeed4 = [NSMutableArray new];
    _newsFeed5 = [NSMutableArray new];
    _thumbnails = [NSMutableArray new];
    _thumbnails2 = [NSMutableArray new];
    _likesData = [NSMutableArray new];
    _likersData = [NSMutableArray new];
    _userNames = [NSMutableArray new];
    _userEmails = [NSMutableArray new];
    _userPicUrls = [NSMutableArray new];
    self.huntPicUrlDict = [NSMutableDictionary new];
    
    _timeArray = [NSMutableArray new];
    _avgArray = [NSMutableArray new];
    contentSize = 80;
    contentSize2 = 0;
    
    self.newsfeed_caption = [NSMutableArray new];
    self.newsfeed_images = [NSMutableArray new];
    self.newsfeed_userimages = [NSMutableArray new];
    self.newsfeed_dishname = [NSMutableArray new];
    self.newsfeed_huntname = [NSMutableArray new];
    self.newsfeed_kinvey_id = [NSMutableArray new];
    self.newsfeed_kinveyid = [NSMutableArray new];
    self.newsfeed_postdate = [NSMutableArray new];
    self.newsfeed_posttype = [NSMutableArray new];
    self.newsfeed_postvote = [NSMutableArray new];
    self.newsfeed_useremail = [NSMutableArray new];
    self.newsfeed_userfullname = [NSMutableArray new];
    self.newsfeed_userid = [NSMutableArray new];
    self.newsfeed_venueaddress = [NSMutableArray new];
    self.newsfeed_venuecc = [NSMutableArray new];
    self.newsfeed_venuecity = [NSMutableArray new];
    self.newsfeed_venuecountry = [NSMutableArray new];
    self.newsfeed_venueid = [NSMutableArray new];
    self.newsfeed_venuename = [NSMutableArray new];
    self.newsfeed_venuepostalcode = [NSMutableArray new];
    self.newsfeed_venuestate = [NSMutableArray new];
    self.sponsored_hunt_names = [NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // GET THE SUBSCRIBED HUNT NAMES
    self.subscribedHunts = [defaults objectForKey:@"subscribedHuntNames"];
    self.unSubscribedHunts = [defaults objectForKey:@"unsubscribedHuntNames"];
    self.huntPicUrlDict = [defaults objectForKey:@"huntPicUrl"];
    
//    [self checkSponsoredHunts];
    self.myEmail = [[KCSUser activeUser] email];
    
    self.reload_toggle = @"YES";
    
    KCSCollection* collection = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
    self.updateStore2 = [KCSLinkedAppdataStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:collection, KCSStoreKeyResource, [NSNumber numberWithInt:KCSCachePolicyBoth], KCSStoreKeyCachePolicy, nil]];
    
    KCSCollection* collection2 = [KCSCollection collectionFromString:@"userPicture2" ofClass:[YookaBackend class]];
    self.updateStore3 = [KCSLinkedAppdataStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:collection2, KCSStoreKeyResource, [NSNumber numberWithInt:KCSCachePolicyBoth], KCSStoreKeyCachePolicy, nil]];
    
    KCSCollection* collection3 = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
    self.updateStore4 = [KCSLinkedAppdataStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:collection3, KCSStoreKeyResource, [NSNumber numberWithInt:KCSCachePolicyBoth], KCSStoreKeyCachePolicy, nil]];
    
    self.tabBarController.delegate = self;
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yooka.png"]];
    
    [_gridScrollView removeFromSuperview];
    
    [self.view setBackgroundColor:[self colorWithHexString:@"f0f0f0"]];
    
    UIImageView *top_bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [top_bar setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    [self.view addSubview:top_bar];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 320, 40)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    NSString *string5 = @"NEWSFEED";
    NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:string5];
    float spacing5 = 1.5f;
    [attributedString5 addAttribute:NSKernAttributeName
                              value:@(spacing5)
                              range:NSMakeRange(0, [string5 length])];
    
    titleLabel.attributedText = attributedString5;
    titleLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
    [self.view addSubview:titleLabel];
    
    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    _gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
    _gridScrollView.contentSize= self.view.bounds.size;
    _gridScrollView.frame = CGRectMake(0.f, 60.f, 320.f, self.view.frame.size.height);
    self.gridScrollView.delegate = self;
    [self.view addSubview:_gridScrollView];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(testRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.gridScrollView addSubview:refreshControl];
    
    UILabel *subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 120, 8)];
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    subtitleLabel.textColor = [UIColor grayColor];
    NSString *string6 = @"FEATURED 5 LISTS :";
    NSMutableAttributedString *attributedString6 = [[NSMutableAttributedString alloc] initWithString:string6];
    float spacing6 = 1.5f;
    [attributedString6 addAttribute:NSKernAttributeName
                              value:@(spacing6)
                              range:NSMakeRange(0, [string6 length])];
    
    subtitleLabel.attributedText = attributedString6;
    subtitleLabel.font = [UIFont fontWithName:@"OpenSans" size:8.0];
//    [self.gridScrollView addSubview:subtitleLabel];
    
    self.topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 85)];
    [self.topScrollView setBackgroundColor:[UIColor clearColor]];
    self.topScrollView.delegate = self;
    [self.gridScrollView addSubview:self.topScrollView];
    
    [self.topScrollView setPagingEnabled:YES];
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    
    self.hunts_pages = [[UIPageControl alloc] init];
    self.hunts_pages.frame = CGRectMake(130,81,60,25);
    self.hunts_pages.enabled = TRUE;
   // [self.hunts_pages sizeToFit];
    [self.hunts_pages setHighlighted:YES];
    //[self.gridScrollView addSubview:self.hunts_pages];
    self.hunts_pages.pageIndicatorTintColor = [UIColor grayColor];
    self.hunts_pages.currentPageIndicatorTintColor = [self colorWithHexString:@"75bfea"];
    self.hunts_pages.backgroundColor = [UIColor clearColor];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.newsfeed_kinveyid = [userDefaults objectForKey:@"newsfeedKinveyid"];
    
    [self setupNewsFeed];
    
    self.newsfeed_kinvey_id = [NSMutableArray new];
    
    self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton3  setFrame:CGRectMake(0, 0, 60, 70)];
    [self.navButton3 setBackgroundColor:[UIColor clearColor]];
    [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navButton3.tag = 1;
    self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton3];
    
    self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton  setFrame:CGRectMake(10, 27, 25, 18)];
    [self.navButton setBackgroundColor:[UIColor clearColor]];
    [self.navButton setBackgroundImage:[[UIImage imageNamed:@"white_menu.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
    [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navButton.tag = 1;
    self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton];
    
    self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton2  setFrame:CGRectMake(0, 63, 60, 520)];
    [self.navButton2 setBackgroundColor:[UIColor clearColor]];
    [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navButton2.tag = 0;
    self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton2];
    
    [self.navButton2 setHidden:YES];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int launches = [[ud objectForKey:@"newsfeed_screen"]intValue];
    
    if(launches == 0){
        
    self.instruction_screen_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.instruction_screen_1 setImage:[UIImage imageNamed:@"newsfeed_instruction2.png"]];
    [self.view addSubview:self.instruction_screen_1];
    
    UIImageView *bg_color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [bg_color setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
    [self.instruction_screen_1 addSubview:bg_color];
    
    CGRect r = bg_color.bounds;
    CGRect r2 = CGRectMake( 0, 55, 320, 250); // adjust this as desired!
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextAddRect(c, r2);
    CGContextAddRect(c, r);
    CGContextEOClip(c);
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextFillRect(c, r);
    UIImage* maskim = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)maskim.CGImage;
    bg_color.layer.mask = mask;
    
    UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(120, 320, 60, 60)];
    [pointing_finger setImage:[UIImage imageNamed:@"righthand.png"]];
    [self.instruction_screen_1 addSubview:pointing_finger];
    
    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -10.0)]; // y increases downwards on iOS
    hover.autoreverses = YES; // Animate back to normal afterwards
    hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
    hover.repeatCount = INFINITY; // The number of times the animation should repeat
    [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
    
    UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 380, 300, 30)];
    instruction1.textColor = [UIColor whiteColor];
    instruction1.text = @"See what lists your friends are doing!”";
    instruction1.textAlignment = NSTextAlignmentCenter;
    [self.instruction_screen_1 addSubview:instruction1];

    UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 500, 100, 30)];
    next_label.textColor = [UIColor whiteColor];
    next_label.text = @"NEXT-->";
    [self.instruction_screen_1 addSubview:next_label];
    
    self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.next_button setFrame:CGRectMake(250, 500, 100, 30)];
    [self.next_button addTarget:self action:@selector(next_action:) forControlEvents:UIControlEventTouchUpInside];
    [self.next_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.next_button];
        
    }
    
    UIButton *top_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [top_button setFrame:CGRectMake( 60, 0, 320-60, 60)];
    [top_button addTarget:self action:@selector(topBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:top_button];
    
}

- (void)topBtnClicked:(id)sender{
    
    [UIScrollView animateWithDuration:.5f animations:^{
        [self.gridScrollView setContentOffset:CGPointMake(0, 0)];
    }];
    
    
}

- (void)testRefresh:(UIRefreshControl *)refreshControl
{
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading data..."];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [NSThread sleepForTimeInterval:3];
        
        [self reloadView];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [refreshControl endRefreshing];
            
            NSLog(@"refresh end");
        });
    });
}

- (void)next_action:(id)sender{
    
    [self.instruction_screen_1 removeFromSuperview];
    [self.next_button removeFromSuperview];
    
    self.instruction_screen_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.instruction_screen_1 setImage:[UIImage imageNamed:@"newsfeed_instruction2.png"]];
    [self.view addSubview:self.instruction_screen_1];
    
    UIImageView *bg_color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [bg_color setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
    [self.instruction_screen_1 addSubview:bg_color];

    CGRect r = bg_color.bounds;
    CGRect r2 = CGRectMake( 270, 120, 50, 45); // adjust this as desired!
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextAddRect(c, r2);
    CGContextAddRect(c, r);
    CGContextEOClip(c);
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextFillRect(c, r);
    UIImage* maskim = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)maskim.CGImage;
    bg_color.layer.mask = mask;
    
    UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(260, 180, 60, 60)];
    [pointing_finger setImage:[UIImage imageNamed:@"righthand.png"]];
    [self.instruction_screen_1 addSubview:pointing_finger];
    
    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -10.0)]; // y increases downwards on iOS
    hover.autoreverses = YES; // Animate back to normal afterwards
    hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
    hover.repeatCount = INFINITY; // The number of times the animation should repeat
    [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
    
    UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 250, 300, 30)];
    instruction1.textColor = [UIColor whiteColor];
    instruction1.text = @"Click here to learn more about this list";
    instruction1.textAlignment = NSTextAlignmentCenter;
    [self.instruction_screen_1 addSubview:instruction1];
    
    UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 500, 100, 30)];
    next_label.textColor = [UIColor whiteColor];
    next_label.text = @"NEXT-->";
    [self.instruction_screen_1 addSubview:next_label];
    
    self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.next_button setFrame:CGRectMake(250, 500, 100, 30)];
    [self.next_button addTarget:self action:@selector(next_action_2:) forControlEvents:UIControlEventTouchUpInside];
    [self.next_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.next_button];
    
}

- (void)next_action_2:(id)sender{
    
    [self.instruction_screen_1 removeFromSuperview];
    [self.next_button removeFromSuperview];
    
    self.instruction_screen_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 622)];
    [self.instruction_screen_1 setImage:[UIImage imageNamed:@"newsfeed_instruction.png"]];
    [self.view addSubview:self.instruction_screen_1];
    
    UIImageView *bg_color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [bg_color setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
    [self.instruction_screen_1 addSubview:bg_color];
    
    CGRect r = bg_color.bounds;
    CGRect r2 = CGRectMake( 0, 60, 320, 335); // adjust this as desired!
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextAddRect(c, r2);
    CGContextAddRect(c, r);
    CGContextEOClip(c);
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextFillRect(c, r);
    UIImage* maskim = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)maskim.CGImage;
    bg_color.layer.mask = mask;
    
    UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(150, 410, 60, 60)];
    [pointing_finger setImage:[UIImage imageNamed:@"righthand.png"]];
    [self.instruction_screen_1 addSubview:pointing_finger];
    
    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -10.0)]; // y increases downwards on iOS
    hover.autoreverses = YES; // Animate back to normal afterwards
    hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
    hover.repeatCount = INFINITY; // The number of times the animation should repeat
    [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
    
    UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 470, 300, 30)];
    instruction1.textColor = [UIColor whiteColor];
    instruction1.text = @"See what people are doing in the city";
    instruction1.textAlignment = NSTextAlignmentCenter;
    [self.instruction_screen_1 addSubview:instruction1];
    
    UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 510, 100, 30)];
    next_label.textColor = [UIColor whiteColor];
    next_label.text = @"NEXT-->";
    [self.instruction_screen_1 addSubview:next_label];
    
    self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.next_button setFrame:CGRectMake(250, 500, 100, 30)];
    [self.next_button addTarget:self action:@selector(next_action_3:) forControlEvents:UIControlEventTouchUpInside];
    [self.next_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.next_button];
    
}

- (void)next_action_3:(id)sender{
    
    [self.instruction_screen_1 removeFromSuperview];
    [self.next_button removeFromSuperview];
    
    self.instruction_screen_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 622)];
    [self.instruction_screen_1 setImage:[UIImage imageNamed:@"newsfeed_instruction.png"]];
    [self.view addSubview:self.instruction_screen_1];
    
    UIImageView *bg_color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [bg_color setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
    [self.instruction_screen_1 addSubview:bg_color];
    
    CGRect r = bg_color.bounds;
    CGRect r2 = CGRectMake( 273, 355, 35, 30); // adjust this as desired!
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextAddRect(c, r2);
    CGContextAddRect(c, r);
    CGContextEOClip(c);
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextFillRect(c, r);
    UIImage* maskim = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)maskim.CGImage;
    bg_color.layer.mask = mask;
    
    UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(270, 400, 60, 55)];
    [pointing_finger setImage:[UIImage imageNamed:@"righthand.png"]];
    [self.instruction_screen_1 addSubview:pointing_finger];
    
    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -10.0)]; // y increases downwards on iOS
    hover.autoreverses = YES; // Animate back to normal afterwards
    hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
    hover.repeatCount = INFINITY; // The number of times the animation should repeat
    [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
    
    UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 470, 300, 30)];
    instruction1.textColor = [UIColor whiteColor];
    instruction1.text = @"Like the picture";
    instruction1.textAlignment = NSTextAlignmentCenter;
    [self.instruction_screen_1 addSubview:instruction1];
    
    UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 510, 100, 30)];
    next_label.textColor = [UIColor whiteColor];
    next_label.text = @"NEXT-->";
    [self.instruction_screen_1 addSubview:next_label];
    
    self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.next_button setFrame:CGRectMake(250, 500, 100, 30)];
    [self.next_button addTarget:self action:@selector(next_action_4:) forControlEvents:UIControlEventTouchUpInside];
    [self.next_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.next_button];
    
}

- (void)next_action_4:(id)sender{
    
    [self.instruction_screen_1 removeFromSuperview];
    [self.next_button removeFromSuperview];
    
    self.instruction_screen_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 622)];
    [self.instruction_screen_1 setImage:[UIImage imageNamed:@"newsfeed_instruction.png"]];
    [self.view addSubview:self.instruction_screen_1];
    
    UIImageView *bg_color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [bg_color setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
    [self.instruction_screen_1 addSubview:bg_color];
    
    CGRect r = bg_color.bounds;
    CGRect r2 = CGRectMake( 247, 355, 25, 25); // adjust this as desired!
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextAddRect(c, r2);
    CGContextAddRect(c, r);
    CGContextEOClip(c);
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextFillRect(c, r);
    UIImage* maskim = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)maskim.CGImage;
    bg_color.layer.mask = mask;
    
    UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake( 235, 400, 60, 60)];
    [pointing_finger setImage:[UIImage imageNamed:@"righthand.png"]];
    [self.instruction_screen_1 addSubview:pointing_finger];
    
    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -10.0)]; // y increases downwards on iOS
    hover.autoreverses = YES; // Animate back to normal afterwards
    hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
    hover.repeatCount = INFINITY; // The number of times the animation should repeat
    [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
    
    UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 470, 300, 30)];
    instruction1.textColor = [UIColor whiteColor];
    instruction1.text = @"% of people that would get it again";
    instruction1.textAlignment = NSTextAlignmentCenter;
    [self.instruction_screen_1 addSubview:instruction1];
    
    UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 510, 100, 30)];
    next_label.textColor = [UIColor whiteColor];
    next_label.text = @"DONE";
    [self.instruction_screen_1 addSubview:next_label];
    
    self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.next_button setFrame:CGRectMake(250, 500, 100, 30)];
    [self.next_button addTarget:self action:@selector(next_action_5:) forControlEvents:UIControlEventTouchUpInside];
    [self.next_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.next_button];
    
}

- (void)next_action_5:(id)sender{
    
    [self.instruction_screen_1 removeFromSuperview];
    [self.next_button removeFromSuperview];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int launches = 1;
    
    [ud setObject:[NSNumber numberWithInt:launches] forKey:@"newsfeed_screen"];

    
}

- (void)gotoFeaturedHunts:(id)sender{
    
    UIButton* button = sender;
    NSUInteger b = button.tag;
    NSLog(@"button %lu pressed",(unsigned long)b);
    NSString *hunt_name;
    if (b==901) {
        hunt_name = [_newsFeed5[0] objectForKeyedSubscript:@"HuntName"];
    }else{
        hunt_name = [_newsFeed[b] objectForKeyedSubscript:@"HuntName"];
    }
    
    [Flurry logEvent:@"Photo_Upload_Saved"];

    NSDictionary *articleParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   hunt_name, @"Hunt_Name",
                                   nil];
    
    [Flurry logEvent:@"Newsfeed_Add_Button_Clicked" withParameters:articleParams];
    
    if ([self.subscribedHunts containsObject:hunt_name]) {
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.35;
        transition.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        
        //            NSLog(@"self.view.window=%@", self.view.window);
        UIView *containerView = self.view.window;
        [containerView.layer addAnimation:transition forKey:nil];
        
        YookaHuntVenuesViewController* media = [[YookaHuntVenuesViewController alloc]init];
        media.huntTitle = hunt_name;
        media.userEmail = self.myEmail;
        media.emailId = self.myEmail;
        media.subscribedHunts = self.subscribedHunts;
        media.unsubscribedHunts = self.unSubscribedHunts;
        [self presentViewController:media animated:NO completion:nil];
        
    }else{
        
        YookaFeaturedHuntViewController *media = [[YookaFeaturedHuntViewController alloc]init];
        media.huntTitle = hunt_name;
        media.subscribedHunts = self.subscribedHunts;
        media.unsubscribedHunts = self.unSubscribedHunts;
        [self presentViewController:media animated:YES completion:nil];
        
    }
    
}

- (void)checkSponsoredHunts
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Featured" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store queryWithQuery:[KCSQuery query] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            
            // If the error requires people using an app to make an action outside of the app in order to recover
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error occured"
                                                            message:@"Pls check your connection and try again."
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
            [alert show];
            //            [self stopActivityIndicator];
            
        } else {
            
            //got all events back from server -- update table view
            
            YookaBackend *yooka = objectsOrNil[0];
            self.sponsored_hunt_names = [NSMutableArray arrayWithArray:yooka.sponsored_hunts];
            
            [self fillFeauturedHunts];
            
        }
    } withProgressBlock:nil];
}


- (void)fillFeauturedHunts
{
    self.working = YES;
    n=0;
    
    // -- show hunts
    total_featured_hunts = [self.sponsored_hunt_names count];
    self.topScrollView.contentSize = CGSizeMake(self.topScrollView.frame.size.width * total_featured_hunts, self.topScrollView.frame.size.height);
    self.hunts_pages.numberOfPages = total_featured_hunts;
    self.hunts_pages.currentPage = 0;
    
    [self fillUnSubscribedHuntImages];
    
}

- (void)fillUnSubscribedHuntImages
{
    
    if(self.working == YES)
    {
        if (n==total_featured_hunts) {
            //            [self viewDidLoad];
        }
        if (n < total_featured_hunts) {
            
            new_page_frame = CGRectMake(n * 320, 0, 320, 85);
            self.FeaturedView = [[UIView alloc]initWithFrame:new_page_frame];
            
        
            
            NSString *huntPicUrl = [self.huntPicUrlDict objectForKey:self.sponsored_hunt_names[n]];
            
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:huntPicUrl]
                                                                options:0
                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             }
                                                              completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
             {
                 if (image && finished)
                 {
                     // do something with image
                     
                     UIImageView *top_pic = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 3, 305, 85)];
                     top_pic.image = image;
                     //top_pic.layer.cornerRadius = 10;
                     //top_pic.clipsToBounds = YES;
                     [self.FeaturedView addSubview:top_pic];
                     
                     UIImageView *transparent_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 85)];
                     //transparent_view.layer.cornerRadius = 10;
                     transparent_view.backgroundColor = [[self colorWithHexString:@"4c4a4a"] colorWithAlphaComponent:0.5f];
                     //[top_pic addSubview:transparent_view];
                     
                     UILabel *subtitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 30, 200, 25)];
                     subtitleLabel.textAlignment = NSTextAlignmentCenter;
                     subtitleLabel.adjustsFontSizeToFitWidth = YES;
                     subtitleLabel.textColor = [UIColor whiteColor];
                     NSString *string6 = self.sponsored_hunt_names[n];
                     
                     //int k = total_featured_hunts+5;
                     
                     UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
                     [user_button  setFrame:CGRectMake(0, 0, 320, 100)];
                     [user_button setBackgroundColor:[UIColor clearColor]];
                     [user_button addTarget:self action:@selector(feat_button_clicked:) forControlEvents:UIControlEventTouchUpInside];
                     [self.FeaturedView addSubview:user_button];
                     
                     NSMutableAttributedString *attributedString6 = [[NSMutableAttributedString alloc] initWithString:string6];
                     float spacing6 = 1.5f;
                     [attributedString6 addAttribute:NSKernAttributeName
                                               value:@(spacing6)
                                               range:NSMakeRange(0, [string6 length])];
                     
                     subtitleLabel.attributedText = attributedString6;
                     subtitleLabel.font = [UIFont fontWithName:@"OpenSans-Regular" size:25.0];
                     [self.FeaturedView addSubview:subtitleLabel];
                     
                     [self.topScrollView addSubview:self.FeaturedView];
                     n++;
                     [self fillUnSubscribedHuntImages];

                 }
             }];
            
        }
    }
}

- (void)feat_button_clicked:(id)sender {
    
    NSString * hunt_name=self.sponsored_hunt_names[self.hunts_pages.currentPage];
    
    NSDictionary *articleParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   hunt_name, @"Hunt_Name",
                                   nil];
    
    [Flurry logEvent:@"Newsfeed_Featured_Button_Clicked" withParameters:articleParams];
    
    if ([self.subscribedHunts containsObject:hunt_name]) {
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.35;
        transition.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        
        //            NSLog(@"self.view.window=%@", self.view.window);
        UIView *containerView = self.view.window;
        [containerView.layer addAnimation:transition forKey:nil];
        
        YookaHuntVenuesViewController* media = [[YookaHuntVenuesViewController alloc]init];
        media.huntTitle = hunt_name;
        media.userEmail = self.myEmail;
        media.emailId = self.myEmail;
        media.subscribedHunts = self.subscribedHunts;
        media.unsubscribedHunts = self.unSubscribedHunts;
        [self presentViewController:media animated:NO completion:nil];
        
    }else{
        
        YookaFeaturedHuntViewController *media = [[YookaFeaturedHuntViewController alloc]init];
        media.huntTitle = hunt_name;
        media.subscribedHunts = self.subscribedHunts;
        media.unsubscribedHunts = self.unSubscribedHunts;
        [self presentViewController:media animated:YES completion:nil];
        
    }

    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float scrollOffset = scrollView.contentOffset.y;
    
    if (scrollOffset < -50)
    {
        // then we are at the top
//        NSLog(@"scroll offset = %f",scrollOffset);
//        if([self.reload_toggle isEqualToString:@"YES"]){
//            self.reload_toggle = @"NO";
////            NSLog(@"reload toggle = %@",self.reload_toggle);
//            if (self.newsFeed.count>0) {
//                [self performSelector:@selector(reloadView) withObject:nil afterDelay:3.0];
//            }
//        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.y;
    
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (scrollView == self.topScrollView) {
        self.hunts_pages.currentPage = page;

    }
    
    
    
    if (scrollOffset < -50)
    {
        // then we are at the top
//        NSLog(@"scroll offset Y = %f",scrollOffset);
//        if([self.reload_toggle isEqualToString:@"YES"]){
//            self.reload_toggle = @"NO";
////            NSLog(@"reload toggle = %@",self.reload_toggle);
//            if (self.newsfeed_kinvey_id.count>0) {
//                [self reloadView];
//            }
//        }
    }
    else if (scrollOffset > 10)
    {

        if (scrollOffset > 25) {
            if (self.thumbnails.count<3) {
                if ([self.cache_toggle isEqualToString:@"YES"]) {
                    //[self layoutCacheNewsFeed:2];
                }else{
//                    [self layoutNewsFeed:2];
                }
            }
            
            if (scrollOffset > 200) {
                if (self.thumbnails.count<4) {
                    if ([self.cache_toggle isEqualToString:@"YES"]) {
                     //   [self layoutCacheNewsFeed:3];
                    }else{
//                        [self layoutNewsFeed:3];
                    }
                }
                
                if (scrollOffset > 400) {
                    if (self.thumbnails.count<5) {
                        if ([self.cache_toggle isEqualToString:@"YES"]) {
                        //    [self layoutCacheNewsFeed:4];
                        }else{
                            [self layoutNewsFeed:4];
                        }
                    }
                    
                    if (scrollOffset > 600) {
                        if (self.thumbnails.count<6) {
                            if ([self.cache_toggle isEqualToString:@"YES"]) {
                          //      [self layoutCacheNewsFeed:5];
                            }else{
                                [self layoutNewsFeed:5];
                            }
                        }
                        
                        if (scrollOffset > 800) {
                            if (self.thumbnails.count<7) {
                                if ([self.cache_toggle isEqualToString:@"YES"]) {
                             //       [self layoutCacheNewsFeed:6];
                                }else{
                                    [self layoutNewsFeed:6];
                                }
                            }
                            
                            if (scrollOffset > 1000) {
                                if (self.thumbnails.count<8) {
                                    if ([self.cache_toggle isEqualToString:@"YES"]) {
                             //           [self layoutCacheNewsFeed:7];
                                    }else{
                                        [self layoutNewsFeed:7];
                                    }
                                }
                                
                                if (scrollOffset > 1200) {
                                    if (self.thumbnails.count<9) {
                                        if ([self.cache_toggle isEqualToString:@"YES"]) {
                             //               [self layoutCacheNewsFeed:8];
                                        }else{
                                            [self layoutNewsFeed:8];
                                        }
                                    }
                                    
                                    if (scrollOffset > 1400) {
                                        if (self.thumbnails.count<10) {
                                            if ([self.cache_toggle isEqualToString:@"YES"]) {
                              //                  [self layoutCacheNewsFeed:9];
                                            }else{
                                                [self layoutNewsFeed:9];
                                            }
                                        }
                                        
                                        if (scrollOffset > 1600) {
                                            if (self.thumbnails.count<11) {
                                                if ([self.cache_toggle isEqualToString:@"YES"]) {
                                              //      [self layoutCacheNewsFeed:10];
                                                }else{
                                                    [self layoutNewsFeed:10];
                                                }
                                            }
                                            
                                            if (scrollOffset > 1800) {
                                                if (self.thumbnails.count<12) {
                                                    if ([self.cache_toggle isEqualToString:@"YES"]) {
                                                   //     [self layoutCacheNewsFeed:11];
                                                    }else{
                                                        [self layoutNewsFeed:11];
                                                    }
                                                }
                                                
                                                if (scrollOffset > 2000) {
                                                    if (self.thumbnails.count<13) {
                                                        if ([self.cache_toggle isEqualToString:@"YES"]) {
                                                      //      [self layoutCacheNewsFeed:12];
                                                        }else{
                                                            [self layoutNewsFeed:12];
                                                        }
                                                    }
                                                    
                                                    if (scrollOffset > 2200) {
                                                        if (self.thumbnails.count<14) {
                                                            if ([self.cache_toggle isEqualToString:@"YES"]) {
                                                         //       [self layoutCacheNewsFeed:13];
                                                            }else{
                                                                [self layoutNewsFeed:13];
                                                            }
                                                        }
                                                        
                                                        if (scrollOffset > 2400) {
                                                            if (self.thumbnails.count<15) {
                                                                if ([self.cache_toggle isEqualToString:@"YES"]) {
                                                                //    [self layoutCacheNewsFeed:14];
                                                                }else{
                                                                    [self layoutNewsFeed:14];
                                                                }
                                                            }
                                                            
                                                            if (scrollOffset > 2600) {
                                                                if (self.thumbnails.count<16) {
                                                                    if ([self.cache_toggle isEqualToString:@"YES"]) {
//[self layoutCacheNewsFeed:15];
                                                                    }else{
                                                                        [self layoutNewsFeed:15];
                                                                    }
                                                                }
                                                                
                                                                if (scrollOffset > 2800) {
                                                                    if (self.thumbnails.count<17) {
                                                                        if ([self.cache_toggle isEqualToString:@"YES"]) {
                                                                        //    [self layoutCacheNewsFeed:16];
                                                                        }else{
                                                                            [self layoutNewsFeed:16];
                                                                        }
                                                                    }
                                                                    
                                                                    if (scrollOffset > 3000) {
                                                                        if (self.thumbnails.count<18) {
                                                                            if ([self.cache_toggle isEqualToString:@"YES"]) {
                                                                               // [self layoutCacheNewsFeed:17];
                                                                            }else{
                                                                                [self layoutNewsFeed:17];
                                                                            }
                                                                        }
                                                                        
                                                                        if (scrollOffset > 3200) {
                                                                            if (self.thumbnails.count<19) {
                                                                                if ([self.cache_toggle isEqualToString:@"YES"]) {
                                                                                 //   [self layoutCacheNewsFeed:18];
                                                                                }else{
                                                                                    [self layoutNewsFeed:18];
                                                                                }
                                                                            }
                                                                            
                                                                            if (scrollOffset > 3400) {
                                                                                if (self.thumbnails.count<20) {
                                                                                    if ([self.cache_toggle isEqualToString:@"YES"]) {
                                                                                     //   [self layoutCacheNewsFeed:19];
                                                                                    }else{
                                                                                        [self layoutNewsFeed:19];
                                                                                    }
                                                                                }
                                                                            }

                                                                        }

                                                                    }

                                                                }

                                                            }

                                                        }

                                                    }

                                                }
                                                
                                            }

                                        }
                                    }
                                }

                            }

                        }
                        
                    }

                }

            }
        }
    }
    else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
    {
        // then we are at the end
    }
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
    
}

// navButton tag = 1 when created in Interface Builder

- (IBAction)navButtonClicked:(id)sender {
    
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            self.navButton.tag = 1;
            self.navButton2.tag = 1;
            self.navButton3.tag = 1;
            [self.navButton2 setHidden:YES];
            [_delegate movePanelToOriginalPosition];
            
            break;
        }
            
        case 1: {
            self.navButton.tag = 0;
            self.navButton3.tag = 0;
            self.navButton2.tag = 0;
            [_delegate movePanelRight];
            [self.navButton2 setHidden:NO];
            
            break;
        }
            
        default:
            break;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self stopActivityIndicator];
    
    

    
}

- (void)showReloadButton {
    UIBarButtonItem * reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadView)];
    reloadButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = reloadButton;
    
}

- (void)showActivityIndicator {
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, -50, 27, 27)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    [self.gridScrollView addSubview:activityIndicator];
}

- (void)stopActivityIndicator {
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(145, -50, 27, 27)];
    [activityIndicator stopAnimating];
    [self.gridScrollView addSubview:activityIndicator];

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"selectedItem"] && [object isKindOfClass:[UITabBar class]]){
        UITabBar *bar = (UITabBar *)object; // The object will be the bar we're observing.
        // The change dictionary will contain the previous tabBarItem for the "old" key.
        UITabBarItem *wasItem = [change objectForKey:NSKeyValueChangeOldKey];
        NSUInteger was = [bar.items indexOfObject:wasItem];
        // The same is true for the new tabBarItem but it will be under the "new" key.
        UITabBarItem *isItem = [change objectForKey:NSKeyValueChangeNewKey];
        NSUInteger is = [bar.items indexOfObject:isItem];
//        NSLog(@"was tab %lu",(unsigned long)was);
//        NSLog(@"is tab  %lu",(unsigned long)is);
        if (was==2 & is==1) {
//            NSLog(@"done");
            [self reloadView];
        }
    }
    // handle other observings.
}

- (void)findFollowingUsers
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store loadObjectWithID:_userEmail withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            YookaBackend *backendObject = objectsOrNil[0];
            _following_users = [NSMutableArray arrayWithArray:backendObject.following_users];
            [_following_users addObject:_userEmail];
            _queryArray = [NSArray arrayWithArray:_following_users];
//            NSLog(@"successful reload: %@", _following_users[0]); // event updated

        } else {
//            NSLog(@"error occurred: %@", errorOrNil);
        }
    } withProgressBlock:nil];
    
}

- (void)reloadView
{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        KCSQuery* query = [KCSQuery queryOnField:@"deleted" withExactMatchForValue:@"NO"];
        KCSQuery* query2 = [KCSQuery queryOnField:@"yooka_private" withExactMatchForValue:@"NO"];
        KCSQuery* query3 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2, nil];
        KCSQuerySortModifier* sortByDate = [[KCSQuerySortModifier alloc] initWithField:@"postDate" inDirection:kKCSDescending];
        [query3 addSortModifier:sortByDate]; //sort the return by the date field
        [query3 setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:5]]; //just get back 10 results
        [self.updateStore2 queryWithQuery:query3 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            //        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0]; //too fast transition feels weird
            //            [self.refreshControl endRefreshing];
            if (objectsOrNil && objectsOrNil.count) {
                
                _newsFeed2 = [NSMutableArray arrayWithArray:objectsOrNil];
                
                YookaBackend *yooka = _newsFeed2[0];

                if ([yooka.kinveyId isEqualToString:[self.newsFeed[0] objectForKey:@"_id"]]) {
                    NSLog(@"same");
                    k=0;
                    self.reload_toggle = @"YES";
                    
                }else{
                    
                    NSLog(@"not same");
                    
                    self.reload_toggle = @"YES";
                    [self.delegate didSelectViewWithName2:@"YookaNewsFeedViewController"];
                    
                }
                
            }else{
                self.reload_toggle = @"YES";
            }
        } withProgressBlock:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }

}

//Get the image with maximum likes
- (void)setupImageWithMaximumLikes{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        [self showActivityIndicator];
        
        KCSQuery* query = [KCSQuery query];
        KCSQuerySortModifier* sortByLikes = [[KCSQuerySortModifier alloc] initWithField:@"likes" inDirection:kKCSDescending];
        [query addSortModifier:sortByLikes]; //sort the return by the date field
        [query setLimitModifer:[[KCSQueryLimitModifier alloc] initWithLimit:1]]; //just get back 10 results
        [self.updateStore4 queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            //        [self performSelector:@selector(stopLoading) withObject:nil afterDelay:1.0]; //too fast transition feels weird
            //            [self.refreshControl endRefreshing];
            if (objectsOrNil && objectsOrNil.count) {
                
                _newsFeed4 = [NSMutableArray arrayWithArray:objectsOrNil];
                YookaBackend *yooka = _newsFeed4[0];
//                NSLog(@"news feed = %@",yooka.kinveyId);
                
                [self setupFirstImage:yooka.kinveyId];
                
            }else{
                //                NSLog(@"newfeed= %@",errorOrNil);
                
//                [self stopActivityIndicator];
            }
        } withProgressBlock:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    
}

- (void)setupFirstImage:(NSString*)kinveyId{
//    NSLog(@"kinvey id = %@",kinveyId);
    
//    NSString* kinvey2 = @"8B943E16-A492-49AD-860D-CDFED6AB3791";
    
    _collectionName3 = @"yookaPosts2";
    _customEndpoint3 = @"Likes";

    //NSLog(@"selected restaurant = %@",_selectedRestaurantName);
    _dict3 = [[NSDictionary alloc]initWithObjectsAndKeys:_collectionName3,@"collectionName",kinveyId,@"kinveyId", nil];
    
    [KCSCustomEndpoints callEndpoint:_customEndpoint3 params:_dict3 completionBlock:^(id results, NSError *error){
        
//        NSLog(@"%@",results);

        if ([results isKindOfClass:[NSArray class]]) {
            _newsFeed5 = [NSMutableArray arrayWithArray:results];
            if (_newsFeed5 && _newsFeed5.count) {
                
                
                UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
                UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
                UITapGestureRecognizer *tapTrice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapThrice:)];
                
                tapOnce.numberOfTapsRequired = 1;
                //        tapTwice.numberOfTapsRequired = 2;
                tapTrice.numberOfTapsRequired = 3;
                //stops tapOnce from overriding tapTwice
                [tapOnce requireGestureRecognizerToFail:tapTrice];
                //        [tapTwice requireGestureRecognizerToFail:tapTrice];
                
                UIButton *buttton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     yookaThumbnailWidth3,
                                                                     275)];
                buttton.tag = 901;
                buttton.userInteractionEnabled = YES;
                [buttton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
                [buttton addGestureRecognizer:tapOnce]; //remove the other button action which calls method `button`
                [buttton addGestureRecognizer:tapTwice];
                [buttton addGestureRecognizer:tapTrice];
                
//                [self.gridScrollView addSubview:buttton];
                [self.thumbnails2 addObject:buttton];
                
                //[self fillTopPic];
                
                
            }else{
                //                 NSLog(@"User Search Results = \n %@",results);
            }
            
        }
    }];

}

- (void)setupNewsFeed
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    i=0;
    j=0;
    k=0;
        
    _userEmails = [NSMutableArray new];
    _userNames = [NSMutableArray new];
    _newsFeed = [NSMutableArray new];
    _thumbnails = [NSMutableArray new];
    _likesData = [NSMutableArray new];
    _likersData = [NSMutableArray new];
    _userEmails = [NSMutableArray new];
    _userPicUrls = [NSMutableArray new];
    self.newsfeed_kinvey_id = [NSMutableArray new];
        
    _collectionName1 = @"yookaPosts2";
    _customEndpoint1 = @"Posts";
    _fieldName1 = @"postDate";
        
    _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
        
    [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
        if (results) {
            
                if ([results isKindOfClass:[NSArray class]]) {
                _newsFeed = [NSMutableArray arrayWithArray:results];
                if (_newsFeed && _newsFeed.count) {
                    
//                    NSLog(@"results 1 = %@",_newsFeed[0]);
                    [self layoutNewsFeed:0];
                    [self layoutNewsFeed:1];
                    [self layoutNewsFeed:2];
                    [self layoutNewsFeed:3];
                    
                    [self checkForOldImagesAndDestroyIt];
                    
                }else{
//                    NSLog(@"User Search Results = \n %@",results);
                }
                
            }else{
//                NSLog(@"results 2 = %@",results);
            }
        }else{
//            NSLog(@"results 3 = %@",error);
        }
        
    }];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
        
    }
    
}

- (void)checkForOldImagesAndDestroyIt{
    
    NSMutableArray *new_array = [NSMutableArray new];
    
    int q = 0;
    for (q=0; q<self.newsFeed.count; q++) {
        [new_array addObject:[self.newsFeed[q] objectForKey:@"_id"]];
    }
    if (q==self.newsFeed.count) {

        NSMutableSet *intersection = [NSMutableSet setWithArray:new_array];
        [intersection intersectSet:[NSSet setWithArray:self.newsfeed_kinveyid]];
        NSArray *resultArray = [intersection allObjects];
        if (self.newsfeed_kinveyid.count>0) {
            if (resultArray.count==0) {
                NSLog(@"nothing common");
                int l2=0;
                for (l2=0; l2<self.newsfeed_kinveyid.count; l2++) {
                    [[SDImageCache sharedImageCache] removeImageForKey:self.newsfeed_kinveyid[l2]];
                    NSLog(@"deleted image with id %@",self.newsfeed_kinveyid[l2]);
                }
            }else{
                NSLog(@"something common");
            }
        }else{
            NSLog(@"no saved kinvey id");
        }

    }
}

- (void)average:(NSMutableArray*)array
{
    double value = 0;
    for (int h= 0; h<array.count; h++) {
        double value2 = [array[h] doubleValue];
        value = value+value2;
    }
//    NSLog(@"value = %f",value);
    double average = value/30;
    [self.avgArray addObject:[NSNumber numberWithDouble:average]];

    if (self.avgArray.count<5) {
        for (int q=0; q<30; q++) {
            [self setupNewsFeed];
        }
    }
    if (self.avgArray.count == 5) {
        double value = 0;
        for (int h= 0; h<self.avgArray.count; h++) {
            double value2 = [self.avgArray[h] doubleValue];
            value = value+value2;
        }
        
        double average2 = value/5;
        NSLog(@"average 2 = %f",average2);
        
    }
}

- (void)user_button_Action:(id)sender
{
    
}

- (void)restaurant_button:(id)sender
{
    
}

- (void)layoutNewsFeed:(int)num
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    self.subscribedHunts=[defaults objectForKey:@"subscribedHuntNames"];
    
    NSString *dishPicUrl = [[_newsFeed[num] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
    NSString *userId = [_newsFeed[num] objectForKey:@"userEmail"];
    [_userEmails addObject:userId];
    //        NSLog(@"newsfeed = %@",_newsFeed[i]);
    NSString *dishName = [_newsFeed[num] objectForKey:@"dishName"];
    //        NSString *venueName = [_newsFeed[i] objectForKey:@"venueName"];
    //        NSString *venueAddress = [_newsFeed[i] objectForKey:@"venueAddress"];
    NSString *caption = [_newsFeed[num] objectForKey:@"caption"];
    NSString *post_vote = [_newsFeed[num] objectForKey:@"postVote"];
    NSString *kinveyId = [NSString stringWithFormat:@"%@",[_newsFeed[num] objectForKey:@"_id"]];
    NSString *hunt_name = [_newsFeed[num] objectForKey:@"HuntName"];
    NSDate *created_date = [_newsFeed[num] objectForKey:@"postDate"];
    NSString *post_type = [_newsFeed[num] objectForKey:@"postType"];
    
    if (caption) {
        [self.newsfeed_caption addObject:caption];
    }else{
        [self.newsfeed_caption addObject:@""];
    }
    self.newsfeed_userid[num] = userId;
    if (post_vote) {
        [self.newsfeed_postvote addObject:post_vote];
    }else{
        [self.newsfeed_postvote addObject:@""];
    }
    if ([_newsFeed[num] objectForKey:@"HuntName"]) {
        [self.newsfeed_huntname addObject:hunt_name];
    }else{
        [self.newsfeed_huntname addObject:@""];
    }
    if (dishName) {
        [self.newsfeed_dishname addObject:dishName];

    }else{
        [self.newsfeed_dishname addObject:@""];
    }
    if ([_newsFeed[num] objectForKey:@"postType"]) {
        [self.newsfeed_posttype addObject:post_type];
    }else{
        [self.newsfeed_posttype addObject:@""];
    }
    [self.newsfeed_kinvey_id addObject:kinveyId];
    [self.newsfeed_postdate addObject:created_date];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (num==19) {
        [ud setObject:self.newsfeed_caption forKey:@"newsfeedCaption"];
        [ud setObject:self.newsfeed_userid forKey:@"newsfeedUserid"];
        [ud setObject:self.newsfeed_kinvey_id forKey:@"newsfeedKinveyid"];
        [ud setObject:self.newsfeed_huntname forKey:@"newsfeedHuntname"];
        [ud setObject:self.newsfeed_dishname forKey:@"newsfeedDishname"];
        [ud setObject:self.newsfeed_posttype forKey:@"newsfeedPosttype"];
        [ud setObject:self.newsfeed_postvote forKey:@"newsfeedPostvote"];
        [ud setObject:self.newsfeed_postdate forKey:@"newsfeedPostdate"];
        [ud synchronize];
    }

    UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
    UITapGestureRecognizer *tapTrice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapThrice:)];
    
    tapOnce.numberOfTapsRequired = 1;
    //        tapTwice.numberOfTapsRequired = 2;
    tapTrice.numberOfTapsRequired = 3;
    //stops tapOnce from overriding tapTwice
    [tapOnce requireGestureRecognizerToFail:tapTrice];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if ([[_newsFeed[num] objectForKey:@"postType"] isEqualToString:@"started hunt"]) {
    
        button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  contentSize2+10,
                                                                  yookaThumbnailWidth3,
                                                                  305)];
        contentSize2 = contentSize2 + 305;
    }else{
        button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                contentSize2+10,
                                                                yookaThumbnailWidth3,
                                                                325)];
        contentSize2 = contentSize2 + 325;

    }
    button.tag = 0;
    button.userInteractionEnabled = YES;
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button addGestureRecognizer:tapOnce]; //remove the other button action which calls method `button`
    [button addGestureRecognizer:tapTwice];
    [button addGestureRecognizer:tapTrice];
    
    [button setBackgroundColor:[self colorWithHexString:@"f0f0f0"]]; //a7a7a7
    
    [self.gridScrollView addSubview:button];
    [self.thumbnails addObject:button];
    
    [_gridScrollView setContentSize:CGSizeMake(320, contentSize+contentSize2)];
    
    //check if its started hunt picture
    
    if ([[_newsFeed[num] objectForKey:@"postType"] isEqualToString:@"started hunt"]) {
        
        NSString *hunt_pic_url = [_newsFeed[num] objectForKey:@"huntPicUrl"];
        
        UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 55, 305, 225)];
        [buttonImage setBackgroundColor:[UIColor clearColor]];
        buttonImage.contentMode = UIViewContentModeScaleAspectFill;
        //buttonImage.layer.cornerRadius = 5.0;
        buttonImage.clipsToBounds = YES;
        buttonImage.opaque = YES;
        buttonImage.image = nil;
        
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:kinveyId done:^(UIImage *image, SDImageCacheType cacheType)
         {
             if (image) {
                 
                 [UIView animateWithDuration:1.0f
                                  animations:^{
                                      buttonImage.alpha = 0.f;
                                  } completion:^(BOOL finished) {
                                      
                                      UIImageView *whitebox = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 10, 305, 45)];
                                      [whitebox setBackgroundColor:[UIColor whiteColor]];
                                      whitebox.layer.shadowRadius = 0;
                                      whitebox.layer.shadowOpacity = 1;
                                      whitebox.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                                      whitebox.layer.masksToBounds = NO;
                                      whitebox.layer.shadowColor = [[[self colorWithHexString:@"bdbdbd"]colorWithAlphaComponent:0.6f]CGColor];
                                      [button addSubview:whitebox];
                                      
                                      buttonImage.image = image;
                                      [button addSubview:buttonImage];
                                      
                                      UIImageView *whitebox2 = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 280, 305, 10)];
                                      [whitebox2 setBackgroundColor:[UIColor whiteColor]];
                                      whitebox2.layer.shadowRadius = 0;
                                      whitebox2.layer.shadowOpacity = 1;
                                      whitebox2.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                                      whitebox2.layer.masksToBounds = NO;
                                      whitebox2.layer.shadowColor = [[[self colorWithHexString:@"bdbdbd"]colorWithAlphaComponent:0.6f]CGColor];
                                      [button addSubview:whitebox2];
                                      
                                      [self getUserImage:num];
                                      
                                      NSString *string = [NSString stringWithFormat:@"image%d",num];
                                      NSData *imgData = UIImagePNGRepresentation(image);
                                      [ud setObject:imgData forKey:string];
                                      [ud synchronize];
                                      
                                      
                                      [UIView animateWithDuration:1.0f
                                                       animations:^{
                                                           buttonImage.alpha = 1;
                                                           
                                                       } completion:^(BOOL finished) {
                                                           
                                                           
                                                           if ([self.subscribedHunts containsObject:hunt_name]) {
                                                               
                                                           }else{
                                                               
                                                               UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                                               [joinButton setFrame:CGRectMake(271, 65,50,40)];
                                                               [joinButton setBackgroundColor:[UIColor clearColor]];
                                                               [joinButton setTag:num];
                                                               
                                                               UIImageView *joinBtn = [[UIImageView alloc]initWithFrame:CGRectMake(275, 63,45,45)];
                                                               joinBtn.image=[UIImage imageNamed:@"ribbon.png"];
                                                               [button addSubview:joinBtn];
                                                               
                                                               UIImageView *joinBtn2 = [[UIImageView alloc]initWithFrame:CGRectMake(265, 53,67,67)];
                                                               joinBtn2.image=[UIImage imageNamed:@"add_to_button.png"];
                                                               [button addSubview:joinBtn2];
                                                               
                                                               [joinButton addTarget:self action:@selector(gotoFeaturedHunts:)
                                                                    forControlEvents:UIControlEventTouchUpInside];
                                                               [button addSubview:joinButton];
                                                               
                                                           }
                                                           
                                                           NSDate *createddate = [_newsFeed[num] objectForKey:@"postDate"];
                                                           NSDate *now = [NSDate date];
                                                           NSString *str;
                                                           NSMutableString *myString = [NSMutableString string];
                                                           
                                                           NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createddate];
                                                           
                                                           if (secondsBetween<60) {
                                                               int duration = secondsBetween;
                                                               str = [NSString stringWithFormat:@"%d sec",duration]; //%d or %i both is ok.
                                                               [myString appendString:str];
                                                           }else if (secondsBetween<3600) {
                                                               int duration = secondsBetween / 60;
                                                               str = [NSString stringWithFormat:@"%d min",duration]; //%d or %i both is ok.
                                                               [myString appendString:str];
                                                           }else if (secondsBetween<86400){
                                                               int duration = secondsBetween / 3600;
                                                               str = [NSString stringWithFormat:@"%d hrs",duration]; //%d or %i both is ok.
                                                               [myString appendString:str];
                                                           }else if (secondsBetween<604800){
                                                               int duration = secondsBetween / 86400;
                                                               str = [NSString stringWithFormat:@"%d days",duration]; //%d or %i both is ok.
                                                               [myString appendString:str];
                                                           }else {
                                                               int duration = secondsBetween / 604800;
                                                               if(duration==1) {
                                                                   str = [NSString stringWithFormat:@"%d week",duration]; //%d or %i both is ok.
                                                               }else{
                                                                   str = [NSString stringWithFormat:@"%d weeks",duration]; //%d or %i both is ok.
                                                               }
                                                               [myString appendString:str];
                                                           }
                                                           
                                                           UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(253, 13, 50, 12)];
                                                           time_label.text = [NSString stringWithFormat:@"%@ ago",myString];
                                                           time_label.textColor = [UIColor lightGrayColor];
                                                           [time_label setFont:[UIFont fontWithName:@"OpenSans" size:7]];
                                                           time_label.textAlignment = NSTextAlignmentRight;
                                                           [button addSubview:time_label];
                                                           
                                                           [_gridScrollView addSubview:button];
                                                           
                                                           //                 [self imageLikes:num];
                                                       }];
                                  }];
                 
             }else{
                 
                 [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:hunt_pic_url]
                                                                     options:0
                                                                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
                  {
                      // progression tracking code
                  }
                                                                   completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                  {
                      if (image && finished)
                      {
                          
                          [UIView animateWithDuration:1.0f
                                           animations:^{
                                               buttonImage.alpha = 0.f;
                                           } completion:^(BOOL finished) {
                                               
                                               UIImageView *whitebox = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 10, 305, 45)];
                                               [whitebox setBackgroundColor:[UIColor whiteColor]];
                                               whitebox.layer.shadowRadius = 0;
                                               whitebox.layer.shadowOpacity = 1;
                                               whitebox.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                                               whitebox.layer.masksToBounds = NO;
                                               whitebox.layer.shadowColor = [[[self colorWithHexString:@"bdbdbd"]colorWithAlphaComponent:0.6f]CGColor];
                                               [button addSubview:whitebox];
                                               
                                               buttonImage.image = image;
                                               [button addSubview:buttonImage];
                                               
                                               [[SDImageCache sharedImageCache] storeImage:image forKey:kinveyId];
                                               
                                               UIImageView *whitebox2 = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 280, 305, 10)];
                                               [whitebox2 setBackgroundColor:[UIColor whiteColor]];
                                               whitebox2.layer.shadowRadius = 0;
                                               whitebox2.layer.shadowOpacity = 1;
                                               whitebox2.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                                               whitebox2.layer.masksToBounds = NO;
                                               whitebox2.layer.shadowColor = [[[self colorWithHexString:@"bdbdbd"]colorWithAlphaComponent:0.6f]CGColor];
                                               [button addSubview:whitebox2];
                                               
                                               [self getUserImage:num];
                                               
                                               NSString *string = [NSString stringWithFormat:@"image%d",num];
                                               NSData *imgData = UIImagePNGRepresentation(image);
                                               [ud setObject:imgData forKey:string];
                                               [ud synchronize];
                                               
                                               
                                               [UIView animateWithDuration:1.0f
                                                                animations:^{
                                                                    buttonImage.alpha = 1;
                                                                    
                                                                } completion:^(BOOL finished) {
                                                                    
                                                                    
                                                                    if ([self.subscribedHunts containsObject:hunt_name]) {
                                                                        
                                                                    }else{
                                                                        
                                                                        UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                                                        [joinButton setFrame:CGRectMake(271, 65,50,40)];
                                                                        [joinButton setBackgroundColor:[UIColor clearColor]];
                                                                        [joinButton setTag:num];
                                                                        
                                                                        UIImageView *joinBtn = [[UIImageView alloc]initWithFrame:CGRectMake(275, 63,45,45)];
                                                                        joinBtn.image=[UIImage imageNamed:@"ribbon.png"];
                                                                        [button addSubview:joinBtn];
                                                                        
                                                                        UIImageView *joinBtn2 = [[UIImageView alloc]initWithFrame:CGRectMake(265, 53,67,67)];
                                                                        joinBtn2.image=[UIImage imageNamed:@"add_to_button.png"];
                                                                        [button addSubview:joinBtn2];
                                                                        
                                                                        [joinButton addTarget:self action:@selector(gotoFeaturedHunts:)
                                                                             forControlEvents:UIControlEventTouchUpInside];
                                                                        [button addSubview:joinButton];
                                                                        
                                                                    }
                                                                    
                                                                    NSDate *createddate = [_newsFeed[num] objectForKey:@"postDate"];
                                                                    NSDate *now = [NSDate date];
                                                                    NSString *str;
                                                                    NSMutableString *myString = [NSMutableString string];
                                                                    
                                                                    NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createddate];
                                                                    
                                                                    if (secondsBetween<60) {
                                                                        int duration = secondsBetween;
                                                                        str = [NSString stringWithFormat:@"%d sec",duration]; //%d or %i both is ok.
                                                                        [myString appendString:str];
                                                                    }else if (secondsBetween<3600) {
                                                                        int duration = secondsBetween / 60;
                                                                        str = [NSString stringWithFormat:@"%d min",duration]; //%d or %i both is ok.
                                                                        [myString appendString:str];
                                                                    }else if (secondsBetween<86400){
                                                                        int duration = secondsBetween / 3600;
                                                                        str = [NSString stringWithFormat:@"%d hrs",duration]; //%d or %i both is ok.
                                                                        [myString appendString:str];
                                                                    }else if (secondsBetween<604800){
                                                                        int duration = secondsBetween / 86400;
                                                                        str = [NSString stringWithFormat:@"%d days",duration]; //%d or %i both is ok.
                                                                        [myString appendString:str];
                                                                    }else {
                                                                        int duration = secondsBetween / 604800;
                                                                        if(duration==1) {
                                                                            str = [NSString stringWithFormat:@"%d week",duration]; //%d or %i both is ok.
                                                                        }else{
                                                                            str = [NSString stringWithFormat:@"%d weeks",duration]; //%d or %i both is ok.
                                                                        }
                                                                        [myString appendString:str];
                                                                    }
                                                                    
                                                                    UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(253, 13, 50, 12)];
                                                                    time_label.text = [NSString stringWithFormat:@"%@ ago",myString];
                                                                    time_label.textColor = [UIColor lightGrayColor];
                                                                    [time_label setFont:[UIFont fontWithName:@"OpenSans" size:7]];
                                                                    time_label.textAlignment = NSTextAlignmentRight;
                                                                    [button addSubview:time_label];
                                                                    
                                                                    [_gridScrollView addSubview:button];
                                                                    
                                                                    //                 [self imageLikes:num];
                                                                }];
                                           }];
                          
                      }else{
                          
                      }
                  }];

             }
         }];
        
    }else{
        
        // its an uploaded picture
        
        UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 55, 305, 210)];
        [buttonImage setBackgroundColor:[UIColor clearColor]];
        buttonImage.contentMode = UIViewContentModeScaleAspectFill;
        //buttonImage.layer.cornerRadius = 5.0;
        buttonImage.clipsToBounds = YES;
        buttonImage.opaque = YES;
        buttonImage.image = nil;
        
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:kinveyId done:^(UIImage *image, SDImageCacheType cacheType)
         {
             if (image) {
                 
                 [UIView animateWithDuration:1.0f
                                  animations:^{
                                      buttonImage.alpha = 0.f;
                                  } completion:^(BOOL finished) {
                                      
                                      UIImageView *whitebox = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 10, 305, 45)];
                                      [whitebox setBackgroundColor:[UIColor whiteColor]];
                                      whitebox.layer.shadowRadius = 0;
                                      whitebox.layer.shadowOpacity = 1;
                                      whitebox.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                                      whitebox.layer.masksToBounds = NO;
                                      whitebox.layer.shadowColor = [[[self colorWithHexString:@"bdbdbd"]colorWithAlphaComponent:0.6f]CGColor];
                                      [button addSubview:whitebox];
                                      
                                      UIImageView *whitebox2 = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 260, 305, 50)];
                                      [whitebox2 setBackgroundColor:[UIColor whiteColor]];
                                      whitebox2.layer.shadowRadius = 0;
                                      whitebox2.layer.shadowOpacity = 1;
                                      whitebox2.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                                      whitebox2.layer.masksToBounds = NO;
                                      whitebox2.layer.shadowColor = [[[self colorWithHexString:@"bdbdbd"]colorWithAlphaComponent:0.6f]CGColor];
                                      [button addSubview:whitebox2];
                                      
                                      buttonImage.image = image;
                                      [button addSubview:buttonImage];
                                      
                                      UIImageView *transparent_view = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 175+45, 305, 45)];
                                      transparent_view.backgroundColor = [[self colorWithHexString:@"4c4a4a"] colorWithAlphaComponent:0.5f];
                                      [button addSubview:transparent_view];
                                      
                                      [self getUserImage:num];
                                      [self imageLikes:num];
                                      
                                      [UIView animateWithDuration:1.0f
                                                       animations:^{
                                                           buttonImage.alpha = 1;
                                                           
                                                       } completion:^(BOOL finished) {
                                                           
                                                           
                                                           if ([[_newsFeed[num] objectForKey:@"postType"] isEqualToString:@"hunt"]) {
                                                               
                                                               UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 225, 300, 25)];
                                                               dishLabel.textColor = [UIColor whiteColor];
                                                               [dishLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:15]];
                                                               dishLabel.text = [dishName uppercaseString];
                                                               dishLabel.textAlignment = NSTextAlignmentLeft;
                                                               dishLabel.adjustsFontSizeToFitWidth = YES;
                                                               dishLabel.layer.masksToBounds = NO;
                                                               dishLabel.backgroundColor = [UIColor clearColor];
                                                               [button addSubview:dishLabel];
                                                               
                                                           }else{
                                                               
                                                               UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 231, 300, 25)];
                                                               dishLabel.textColor = [UIColor whiteColor];
                                                               [dishLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:15]];
                                                               dishLabel.text = [dishName uppercaseString];
                                                               dishLabel.textAlignment = NSTextAlignmentLeft;
                                                               dishLabel.adjustsFontSizeToFitWidth = YES;
                                                               dishLabel.layer.masksToBounds = NO;
                                                               dishLabel.backgroundColor = [UIColor clearColor];
                                                               [button addSubview:dishLabel];
                                                               
                                                           }
                                                           
                                                           UILabel *captionLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 215+50, 190, 25)];
                                                           captionLabel2.textColor = [UIColor lightGrayColor];
                                                           [captionLabel2 setFont:[UIFont fontWithName:@"OpenSans" size:10.f]];
                                                           captionLabel2.text = [NSString stringWithFormat:@"Comments:"];
                                                           [button addSubview:captionLabel2];
                                                           
                                                           UILabel *captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 230+50, 190, 25)];
                                                           captionLabel.textColor = [UIColor lightGrayColor];
                                                           [captionLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:10.f]];
                                                           captionLabel.text = [NSString stringWithFormat:@"\"%@\"",caption];
                                                           captionLabel.textAlignment = NSTextAlignmentLeft;
                                                           captionLabel.adjustsFontSizeToFitWidth = YES;
                                                           //captionLabel.numberOfLines = 0;
                                                           //[captionLabel sizeToFit];
                                                           //captionLabel.layer.masksToBounds = NO;
                                                           
                                                           
                                                           if ([[_newsFeed[num] objectForKey:@"postType"] isEqualToString:@"hunt"]) {
                                                               
                                                               // same placement
                                                           }else{
                                                               captionLabel.frame=CGRectMake(20, 230+50, 190, 25);
                                                           }
                                                           
                                                           
                                                           //                                                           captionLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
                                                           //                                                           captionLabel.layer.shadowRadius = 1;
                                                           //                                                           captionLabel.layer.shadowOpacity = 1;
                                                           //                                                           captionLabel.layer.shadowOffset = CGSizeMake(2.0, 2.0);
                                                           captionLabel.backgroundColor = [UIColor clearColor];
                                                           [button addSubview:captionLabel];
                                                           
                                                           NSDate *createddate = [_newsFeed[num] objectForKey:@"postDate"];
                                                           NSDate *now = [NSDate date];
                                                           NSString *str;
                                                           NSMutableString *myString = [NSMutableString string];
                                                           
                                                           NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createddate];
                                                           if (secondsBetween<60) {
                                                               int duration = secondsBetween;
                                                               str = [NSString stringWithFormat:@"%d sec",duration]; //%d or %i both is ok.
                                                               [myString appendString:str];
                                                           }else if (secondsBetween<3600) {
                                                               int duration = secondsBetween / 60;
                                                               str = [NSString stringWithFormat:@"%d min",duration]; //%d or %i both is ok.
                                                               [myString appendString:str];
                                                           }else if (secondsBetween<86400){
                                                               int duration = secondsBetween / 3600;
                                                               str = [NSString stringWithFormat:@"%d hrs",duration]; //%d or %i both is ok.
                                                               [myString appendString:str];
                                                           }else if (secondsBetween<604800){
                                                               int duration = secondsBetween / 86400;
                                                               str = [NSString stringWithFormat:@"%d days",duration]; //%d or %i both is ok.
                                                               [myString appendString:str];
                                                           }else {
                                                               int duration = secondsBetween / 604800;
                                                               if(duration==1) {
                                                                   str = [NSString stringWithFormat:@"%d week",duration]; //%d or %i both is ok.
                                                               }else{
                                                                   str = [NSString stringWithFormat:@"%d weeks",duration]; //%d or %i both is ok.
                                                               }
                                                               [myString appendString:str];
                                                           }
                                                           
                                                           UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(253, 13, 50, 12)];
                                                           time_label.text = [NSString stringWithFormat:@"%@ ago",myString];
                                                           time_label.textColor = [UIColor lightGrayColor];
                                                           [time_label setFont:[UIFont fontWithName:@"OpenSans" size:7]];
                                                           time_label.textAlignment = NSTextAlignmentRight;
                                                           [button addSubview:time_label];
                                                           
                                                           self.circularProgressView = [[LLACircularProgressView alloc] init];
                                                           self.circularProgressView.frame = CGRectMake(220, 280, 30, 30);
                                                           self.circularProgressView.center = CGPointMake(240, 288);
                                                           [self.circularProgressView setBackgroundColor:[UIColor clearColor]];
                                                           [button addSubview:self.circularProgressView];
                                                           
                                                           if ([post_vote isEqualToString:@"YAY"]) {
                                                               float percent = 1.f;
                                                               [self tick:percent];
                                                               
                                                               UILabel *rate_label = [[UILabel alloc]initWithFrame:CGRectMake(215, 283, 50, 10)];
                                                               [rate_label setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:7.0]];
                                                               [rate_label setTextColor:[self colorWithHexString:@"a7a7a7"]];
                                                               rate_label.textAlignment = NSTextAlignmentCenter;
                                                               [rate_label setText:@"100%"];
                                                               [button addSubview:rate_label];
                                                               
                                                           }else{
                                                               float percent = 0.f;
                                                               [self tick:percent];
                                                               UILabel *rate_label = [[UILabel alloc]initWithFrame:CGRectMake(215, 283, 50, 10)];
                                                               [rate_label setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:7.0]];
                                                               [rate_label setTextColor:[self colorWithHexString:@"a7a7a7"]];
                                                               rate_label.textAlignment = NSTextAlignmentCenter;
                                                               [rate_label setText:@"0%"];
                                                               [button addSubview:rate_label];
                                                           }
                                                           
                                                           [_gridScrollView addSubview:button];
                                                           
                                                       }];
                                  }];
                 
             }else{
                 
                 [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:dishPicUrl]
                                                                     options:0
                                                                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
                  {
                      // progression tracking code
                  }
                                                                   completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                  {
                      if (image && finished)
                      {
                          //                                                      NSLog(@"found image");
                          
                          [UIView animateWithDuration:1.0f
                                           animations:^{
                                               buttonImage.alpha = 0.f;
                                           } completion:^(BOOL finished) {
                                               
                                               UIImageView *whitebox = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 10, 305, 45)];
                                               [whitebox setBackgroundColor:[UIColor whiteColor]];
                                               whitebox.layer.shadowRadius = 0;
                                               whitebox.layer.shadowOpacity = 1;
                                               whitebox.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                                               whitebox.layer.masksToBounds = NO;
                                               whitebox.layer.shadowColor = [[[self colorWithHexString:@"bdbdbd"]colorWithAlphaComponent:0.6f]CGColor];
                                               [button addSubview:whitebox];
                                               
                                               UIImageView *whitebox2 = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 260, 305, 50)];
                                               [whitebox2 setBackgroundColor:[UIColor whiteColor]];
                                               whitebox2.layer.shadowRadius = 0;
                                               whitebox2.layer.shadowOpacity = 1;
                                               whitebox2.layer.shadowOffset = CGSizeMake(0.0, 1.0);
                                               whitebox2.layer.masksToBounds = NO;
                                               whitebox2.layer.shadowColor = [[[self colorWithHexString:@"bdbdbd"]colorWithAlphaComponent:0.6f]CGColor];
                                               [button addSubview:whitebox2];
                                               
                                               buttonImage.image = image;
                                               [button addSubview:buttonImage];
                                               
                                               [[SDImageCache sharedImageCache] storeImage:image forKey:kinveyId];
                                               
                                               UIImageView *transparent_view = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 175+45, 305, 45)];
                                               transparent_view.backgroundColor = [[self colorWithHexString:@"4c4a4a"] colorWithAlphaComponent:0.5f];
                                               [button addSubview:transparent_view];
                                               
                                               [self getUserImage:num];
                                               [self imageLikes:num];
                                               
                                               [UIView animateWithDuration:1.0f
                                                                animations:^{
                                                                    buttonImage.alpha = 1;
                                                                    
                                                                } completion:^(BOOL finished) {
                                                                    
                                                                    
                                                                    if ([[_newsFeed[num] objectForKey:@"postType"] isEqualToString:@"hunt"]) {
                                                                        
                                                                        UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 225, 300, 25)];
                                                                        dishLabel.textColor = [UIColor whiteColor];
                                                                        [dishLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:15]];
                                                                        dishLabel.text = [dishName uppercaseString];
                                                                        dishLabel.textAlignment = NSTextAlignmentLeft;
                                                                        dishLabel.adjustsFontSizeToFitWidth = YES;
                                                                        dishLabel.layer.masksToBounds = NO;
                                                                        dishLabel.backgroundColor = [UIColor clearColor];
                                                                        [button addSubview:dishLabel];
                                                                        
                                                                    }else{
                                                                        
                                                                        UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 231, 300, 25)];
                                                                        dishLabel.textColor = [UIColor whiteColor];
                                                                        [dishLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:15]];
                                                                        dishLabel.text = [dishName uppercaseString];
                                                                        dishLabel.textAlignment = NSTextAlignmentLeft;
                                                                        dishLabel.adjustsFontSizeToFitWidth = YES;
                                                                        dishLabel.layer.masksToBounds = NO;
                                                                        dishLabel.backgroundColor = [UIColor clearColor];
                                                                        [button addSubview:dishLabel];
                                                                        
                                                                    }
                                                                    
                                                                    UILabel *captionLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 215+50, 190, 25)];
                                                                    captionLabel2.textColor = [UIColor lightGrayColor];
                                                                    [captionLabel2 setFont:[UIFont fontWithName:@"OpenSans" size:10.f]];
                                                                    captionLabel2.text = [NSString stringWithFormat:@"Comments:"];
                                                                    [button addSubview:captionLabel2];
                                                                    
                                                                    UILabel *captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 230+50, 190, 25)];
                                                                    captionLabel.textColor = [UIColor lightGrayColor];
                                                                    [captionLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:10.f]];
                                                                    captionLabel.text = [NSString stringWithFormat:@"\"%@\"",caption];
                                                                    captionLabel.textAlignment = NSTextAlignmentLeft;
                                                                    captionLabel.adjustsFontSizeToFitWidth = YES;
                                                                    //captionLabel.numberOfLines = 0;
                                                                    //[captionLabel sizeToFit];
                                                                    //captionLabel.layer.masksToBounds = NO;
                                                                    
                                                                    
                                                                    if ([[_newsFeed[num] objectForKey:@"postType"] isEqualToString:@"hunt"]) {
                                                                        
                                                                        // same placement
                                                                    }else{
                                                                        captionLabel.frame=CGRectMake(20, 230+50, 190, 25);
                                                                    }
                                                                    
                                                                    
                                                                    //                                                           captionLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
                                                                    //                                                           captionLabel.layer.shadowRadius = 1;
                                                                    //                                                           captionLabel.layer.shadowOpacity = 1;
                                                                    //                                                           captionLabel.layer.shadowOffset = CGSizeMake(2.0, 2.0);
                                                                    captionLabel.backgroundColor = [UIColor clearColor];
                                                                    [button addSubview:captionLabel];
                                                                    
                                                                    NSDate *createddate = [_newsFeed[num] objectForKey:@"postDate"];
                                                                    NSDate *now = [NSDate date];
                                                                    NSString *str;
                                                                    NSMutableString *myString = [NSMutableString string];
                                                                    
                                                                    NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createddate];
                                                                    if (secondsBetween<60) {
                                                                        int duration = secondsBetween;
                                                                        str = [NSString stringWithFormat:@"%d sec",duration]; //%d or %i both is ok.
                                                                        [myString appendString:str];
                                                                    }else if (secondsBetween<3600) {
                                                                        int duration = secondsBetween / 60;
                                                                        str = [NSString stringWithFormat:@"%d min",duration]; //%d or %i both is ok.
                                                                        [myString appendString:str];
                                                                    }else if (secondsBetween<86400){
                                                                        int duration = secondsBetween / 3600;
                                                                        str = [NSString stringWithFormat:@"%d hrs",duration]; //%d or %i both is ok.
                                                                        [myString appendString:str];
                                                                    }else if (secondsBetween<604800){
                                                                        int duration = secondsBetween / 86400;
                                                                        str = [NSString stringWithFormat:@"%d days",duration]; //%d or %i both is ok.
                                                                        [myString appendString:str];
                                                                    }else {
                                                                        int duration = secondsBetween / 604800;
                                                                        if(duration==1) {
                                                                            str = [NSString stringWithFormat:@"%d week",duration]; //%d or %i both is ok.
                                                                        }else{
                                                                            str = [NSString stringWithFormat:@"%d weeks",duration]; //%d or %i both is ok.
                                                                        }
                                                                        [myString appendString:str];
                                                                    }
                                                                    
                                                                    UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(253, 13, 50, 12)];
                                                                    time_label.text = [NSString stringWithFormat:@"%@ ago",myString];
                                                                    time_label.textColor = [UIColor lightGrayColor];
                                                                    [time_label setFont:[UIFont fontWithName:@"OpenSans" size:7]];
                                                                    time_label.textAlignment = NSTextAlignmentRight;
                                                                    [button addSubview:time_label];
                                                                    
                                                                    self.circularProgressView = [[LLACircularProgressView alloc] init];
                                                                    self.circularProgressView.frame = CGRectMake(220, 280, 30, 30);
                                                                    self.circularProgressView.center = CGPointMake(240, 288);
                                                                    [self.circularProgressView setBackgroundColor:[UIColor clearColor]];
                                                                    [button addSubview:self.circularProgressView];
                                                                    
                                                                    if ([post_vote isEqualToString:@"YAY"]) {
                                                                        float percent = 1.f;
                                                                        [self tick:percent];
                                                                        
                                                                        UILabel *rate_label = [[UILabel alloc]initWithFrame:CGRectMake(215, 283, 50, 10)];
                                                                        [rate_label setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:7.0]];
                                                                        [rate_label setTextColor:[self colorWithHexString:@"a7a7a7"]];
                                                                        rate_label.textAlignment = NSTextAlignmentCenter;
                                                                        [rate_label setText:@"100%"];
                                                                        [button addSubview:rate_label];
                                                                        
                                                                    }else{
                                                                        float percent = 0.f;
                                                                        [self tick:percent];
                                                                        UILabel *rate_label = [[UILabel alloc]initWithFrame:CGRectMake(215, 283, 50, 10)];
                                                                        [rate_label setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:7.0]];
                                                                        [rate_label setTextColor:[self colorWithHexString:@"a7a7a7"]];
                                                                        rate_label.textAlignment = NSTextAlignmentCenter;
                                                                        [rate_label setText:@"0%"];
                                                                        [button addSubview:rate_label];
                                                                    }
                                                                    
                                                                    [_gridScrollView addSubview:button];
                                                                    
                                                                }];
                                           }];
                          
                          
                      }else{
                          
                      }
                  }];
                 
             }
         }];
        
    }
    
}

- (void)tick:(float)percent {

    CGFloat progress = percent;
    [self.circularProgressView setProgress:(progress <= 1.00f ? progress : 0.0f) animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    NSLog(@"yooka check = %@",self.yooka_check);
    
//    if (self.navigationController.viewControllers.count>1 && [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] isKindOfClass:[YookaPostViewController class]]) {
//
//        [self reloadView];
//    }
    
}

- (void)didReceiveMemoryWarning
{

    // Dispose of any resources that can be recreated.
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    [self reloadView];
    [super didReceiveMemoryWarning];

}

- (void)checkForLikers
{
    
}

- (void)fillPictures
{
//    NSLog(@"FILL PICTURES");
    item = 0;
    row = 0;
    col = 0;
    for (item=0;item<self.newsFeed.count;item++) {
        
        UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
        UITapGestureRecognizer *tapTrice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapThrice:)];
        
        tapOnce.numberOfTapsRequired = 1;
//        tapTwice.numberOfTapsRequired = 2;
        tapTrice.numberOfTapsRequired = 3;
        //stops tapOnce from overriding tapTwice
        [tapOnce requireGestureRecognizerToFail:tapTrice];
        
            _button = [[UIButton alloc] initWithFrame:CGRectMake(col*yookaThumbnailWidth3,
                                                                 (row*yookaThumbnailHeight3)+307,
                                                                 yookaThumbnailWidth3,
                                                                 yookaThumbnailHeight3)];
            contentSize += (yookaThumbnailHeight3);
        
        _button.tag = item;
        _button.userInteractionEnabled = YES;
        [_button addGestureRecognizer:tapOnce]; //remove the other button action which calls method `button`
        [_button addGestureRecognizer:tapTwice];
        [_button addGestureRecognizer:tapTrice];

        ++col;
        
        if (col >= yookaImagesPerRow3) {
            row++;
            col = 0;
        }
        
        [self.gridScrollView addSubview:_button];
        [self.thumbnails addObject:_button];
        
    }
    
    [_gridScrollView setContentSize:CGSizeMake(320, contentSize)];
    
}

- (void)tapOnce:(id)sender
{
//    NSLog(@"Tap once");
}

- (void)tapTwice:(UIGestureRecognizer *)sender
{
    
}

- (void)tapTwice2:(id)sender
{

    UIButton* button1 = sender;
    NSUInteger b = button1.tag;

    _postLikers = [NSMutableArray new];
    

    
    if (b==901) {
        
        UIButton* button = [self.thumbnails2 objectAtIndex:0];
//        NSLog(@"button subviews = %@",[button subviews]);
        
        [[button viewWithTag:220] removeFromSuperview];
        [[button viewWithTag:221] removeFromSuperview];
        [[button viewWithTag:220] removeFromSuperview];
        [[button viewWithTag:221] removeFromSuperview];
        
        _postId = [_newsFeed5[0] objectForKey:@"_id"];
        
        //[removeHeart setHidden:YES];
        //[removeLike setHidden:YES];
        
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        [store loadObjectWithID:_postId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                if (objectsOrNil && objectsOrNil.count) {
                    
                    YookaBackend *backendObject = objectsOrNil[0];
                    _postLikers = [NSMutableArray arrayWithArray:backendObject.likers];
                    _postLikes = backendObject.likes;
                    
                    if ([_postLikes intValue]==0) {
                        _likeStatus = @"NO";
                    }
                    //                NSLog(@"likes = %@",_postLikes);
                    
                    if (!(_postLikers == (id)[NSNull null])) {
                        if ([_postLikers containsObject:_userEmail]) {
                            _likeStatus = @"YES";
                        }else{
                            _likeStatus = @"NO";
                        }
                    }else{
                        _likeStatus = @"NO";
                        //        NSLog(@"try try try");
                    }
                    
                    //    NSLog(@"like status = %@",_likeStatus);
                    
                    if ([_likeStatus isEqualToString:@"YES"]) {
                        
                        int post_likes = [_postLikes intValue];
                        post_likes = post_likes-1;
                        _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                        
                        if (_postLikers==(id)[NSNull null]) {
                            //                        [_likersData replaceObjectAtIndex:view.tag withObject:[NSNull null]];
                        }else{
                            [_postLikers removeObject:_userEmail];
                        }
                        
                        //        NSLog(@"likes data 2 = %@",_likesData);
                        //        NSLog(@"likers data 2 = %@",_likersData);
                        
                        UIView* removeHeart = [button viewWithTag:22];
                        [removeHeart removeFromSuperview];
                        
                        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(260, 225+45, 40, 40)];
                        likesImageView.image = [UIImage imageNamed:@"Wheart.png"];
                        [likesImageView setTag:220];
                        [button addSubview:likesImageView];
                        
                        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                        likesLabel.textColor = [UIColor whiteColor];
                        [likesLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
                        likesLabel.text = [NSString stringWithFormat:@"%@",_postLikes];
                        likesLabel.textAlignment = NSTextAlignmentLeft;
                        //likesLabel.adjustsFontSizeToFitWidth = YES;
                        [likesLabel setTag:221];
                        [button addSubview:likesLabel];

                        [self saveLikes];
                        _likeStatus = @"NO";
                        
                    }else{
                        
                        if (_postLikers == (id)[NSNull null]) {
                            //            NSLog(@"post likers 2 = %@",_postLikers);
                            _postLikers = [NSMutableArray arrayWithObject:_userEmail];
                            //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                            
                        }else{
                            //            NSLog(@"post likers 3 = %@",_postLikers);
                            
                            [_postLikers addObject:_userEmail];
                            //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                            
                        }
                        
                        int post_likes = [_postLikes intValue];
                        post_likes=post_likes+1;
                        _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                        
                        UIView* removeHeart = [button viewWithTag:22];
                        
                        [removeHeart removeFromSuperview];
                        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(260, 225+45, 40, 40)];
                        likesImageView.image = [UIImage imageNamed:@"Heart_fill.png"];
                        [likesImageView setTag:220];
                        [button addSubview:likesImageView];
                        
                        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                        likesLabel.textColor = [UIColor whiteColor];
                        likesLabel.backgroundColor=[UIColor clearColor];
                        [likesLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
                        likesLabel.text = [NSString stringWithFormat:@"%@",_postLikes];
                        likesLabel.textAlignment = NSTextAlignmentLeft;
                        //likesLabel.adjustsFontSizeToFitWidth = YES;
                        [likesLabel setTag:221];
                        [button addSubview:likesLabel];
                        
                        //                [self saveSelectedPost];
                        [self saveLikes];
                        _likeStatus = @"YES";
                        
                    }
                    
                }else{
                    
                    _postLikes = @"0";
                    
                    _likeStatus = @"NO";
                    //                NSLog(@"likes = %@",_postLikes);
                    
                    _postLikers = [NSMutableArray arrayWithObject:_userEmail];
                    
                    
                    int post_likes = [_postLikes intValue];
                    post_likes=post_likes+1;
                    _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                    
                    //        NSLog(@"likes data 2 = %@",_likesData);
                    //        NSLog(@"likers data 2 = %@",_likersData);
                    
                    UIView* removeHeart = [button viewWithTag:22];
                    [removeHeart removeFromSuperview];
                    
                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(260, 225+45, 40, 40)];
                    likesImageView.image = [UIImage imageNamed:@"Heart_fill.png"];
                    [likesImageView setTag:220];
                    [button addSubview:likesImageView];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                    likesLabel.textColor = [UIColor whiteColor];
                    likesLabel.backgroundColor=[UIColor clearColor];
                    [likesLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
                    likesLabel.text = [NSString stringWithFormat:@"%@",_postLikes];
                    likesLabel.textAlignment = NSTextAlignmentLeft;
                    //likesLabel.adjustsFontSizeToFitWidth = YES;
                    [likesLabel setTag:221];
                    [button addSubview:likesLabel];
                    
                    //                [self saveSelectedPost];
                    [self saveLikes];
                    _likeStatus = @"YES";
                    
                }
                
            }else{
                
                _postLikes = @"0";
                
                _likeStatus = @"NO";
                //            NSLog(@"likes = %@",_postLikes);
                
                _postLikers = [NSMutableArray arrayWithObject:_userEmail];
                
                
                int post_likes = [_postLikes intValue];
                post_likes=post_likes+1;
                _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                
                //        NSLog(@"likes data 2 = %@",_likesData);
                //        NSLog(@"likers data 2 = %@",_likersData);
                UIView* removeHeart = [button viewWithTag:22];
                [removeHeart removeFromSuperview];
                
                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(260, 225+45, 40, 40)];
                likesImageView.image = [UIImage imageNamed:@"Heart_fill.png"];
                [likesImageView setTag:220];
                [button addSubview:likesImageView];
                
                UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                likesLabel.textColor = [UIColor whiteColor];
                likesLabel.backgroundColor=[UIColor clearColor];
                [likesLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
                likesLabel.text = [NSString stringWithFormat:@"%@",_postLikes];
                likesLabel.textAlignment = NSTextAlignmentLeft;
                //likesLabel.adjustsFontSizeToFitWidth = YES;
                [likesLabel setTag:221];
                [button addSubview:likesLabel];
                
                //                [self saveSelectedPost];
                [self saveLikes];
                _likeStatus = @"YES";
                
            }
            
        } withProgressBlock:nil];
        

    }else{
        
//        NSLog(@"index = %lu",(unsigned long)b);
        UIButton* button = [self.thumbnails objectAtIndex:b];
        
//        NSLog(@"button subviews = %@",[button viewWithTag:220]);
        [[button viewWithTag:220] removeFromSuperview];
       // [[button viewWithTag:221] removeFromSuperview];
        [[button viewWithTag:220] removeFromSuperview];
       // [[button viewWithTag:221] removeFromSuperview];
        
//        UIImageView *red_heart2 = [[UIImageView alloc]initWithFrame:CGRectMake(128, 45+235+83-2-68, 45, 45)];
//        red_heart2.image = [UIImage imageNamed:@"Before_like.png"];
//        [button addSubview:red_heart2];
        
        if ([self.cache_toggle isEqualToString:@"YES"]) {
            _postId = self.newsfeed_kinvey_id[b];
        }else{
        _postId = [_newsFeed[b] objectForKey:@"_id"];
        }
        
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        [store loadObjectWithID:_postId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                if (objectsOrNil && objectsOrNil.count) {
                    
                    YookaBackend *backendObject = objectsOrNil[0];
                    _postLikers = [NSMutableArray arrayWithArray:backendObject.likers];
                    _postLikes = backendObject.likes;
                    
                    if ([_postLikes intValue]==0) {
                        _likeStatus = @"NO";
                    }
                    //                NSLog(@"likes = %@",_postLikes);
                    
                    if (!(_postLikers == (id)[NSNull null])) {
                        if ([_postLikers containsObject:[KCSUser activeUser].email]) {
                            _likeStatus = @"YES";
                        }else{
                            _likeStatus = @"NO";
                        }
                    }else{
                        _likeStatus = @"NO";
                        //        NSLog(@"try try try");
                    }
                    
                    //    NSLog(@"like status = %@",_likeStatus);
                    
                    if ([_likeStatus isEqualToString:@"YES"]) {
                        
                        int post_likes = [_postLikes intValue];
                        post_likes = post_likes-1;
                        _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                        
                        if (_postLikers==(id)[NSNull null]) {
                            //                        [_likersData replaceObjectAtIndex:view.tag withObject:[NSNull null]];
                        }else{
                            [_postLikers removeObject:[KCSUser activeUser].email];
                        }
                        
                        //        NSLog(@"likes data 2 = %@",_likesData);
                        //        NSLog(@"likers data 2 = %@",_likersData);
                        
                        
                        
                        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(259, 224+45, 37, 37)];
                        likesImageView.backgroundColor=[UIColor clearColor];
                        [likesImageView setTag:220];
                        likesImageView.image = [UIImage imageNamed:@"Before_like.png"];
                        [button addSubview:likesImageView];
                        
                        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                        likesLabel.textColor = [self colorWithHexString:@"f38686"]; //heartcolor //green:18af80
                        likesLabel.backgroundColor=[UIColor whiteColor];
                        [likesLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
                        likesLabel.text = [NSString stringWithFormat:@"%@",_postLikes];
                        likesLabel.textAlignment = NSTextAlignmentLeft;
                        //likesLabel.adjustsFontSizeToFitWidth = YES;
                        [likesLabel setTag:221];
                        [button addSubview:likesLabel];
                        
                        
                        //                [self saveSelectedPost];
                        [self saveLikes];
                        _likeStatus = @"NO";
                        
                    }else{
                        
                        if (_postLikers == (id)[NSNull null]) {
                            //            NSLog(@"post likers 2 = %@",_postLikers);
                            _postLikers = [NSMutableArray arrayWithObject:[KCSUser activeUser].email];
                            //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                            
                        }else{
                            //            NSLog(@"post likers 3 = %@",_postLikers);
                            
                            [_postLikers addObject:[KCSUser activeUser].email];
                            //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                            
                        }
                        
                        int post_likes = [_postLikes intValue];
                        post_likes=post_likes+1;
                        _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                        //                    [_likesData replaceObjectAtIndex:view.tag withObject:_postLikes];
                        
                        //        NSLog(@"likes data 2 = %@",_likesData);
                        //        NSLog(@"likers data 2 = %@",_likersData);
                        
                        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(250, 225+45, 40, 40)];
                        likesImageView.image = [UIImage imageNamed:@"full_heart.png"];
                        [likesImageView setTag:220];
                        [button addSubview:likesImageView];
                        
                        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                        likesLabel.textColor = [self colorWithHexString:@"f38686"]; //heartcolor //green:18af80
                        likesLabel.backgroundColor=[UIColor whiteColor];
                        [likesLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
                        likesLabel.text = [NSString stringWithFormat:@"%@",_postLikes];
                        likesLabel.textAlignment = NSTextAlignmentLeft;
                        //likesLabel.adjustsFontSizeToFitWidth = YES;
                        [likesLabel setTag:221];
                        [button addSubview:likesLabel];
                        
                        
                        //                [self saveSelectedPost];
                        [self saveLikes];
                        _likeStatus = @"YES";
                        
                    }
                    
                }else{
                    
                    _postLikes = @"0";
                    
                    _likeStatus = @"NO";
                    //                NSLog(@"likes = %@",_postLikes);
                    
                    _postLikers = [NSMutableArray arrayWithObject:[KCSUser activeUser].email];
                    
                    
                    int post_likes = [_postLikes intValue];
                    post_likes=post_likes+1;
                    _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                    
                    //        NSLog(@"likes data 2 = %@",_likesData);
                    //        NSLog(@"likers data 2 = %@",_likersData);
                    
                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(250, 225+45, 40, 40)];
                    likesImageView.image = [UIImage imageNamed:@"full_heart.png"];
                    [likesImageView setTag:220];
                    [button addSubview:likesImageView];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                    likesLabel.textColor = [self colorWithHexString:@"f38686"]; //heartcolor //green:18af80
                    likesLabel.backgroundColor=[UIColor whiteColor];
                    [likesLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
                    likesLabel.text = [NSString stringWithFormat:@"%@",_postLikes];
                    likesLabel.textAlignment = NSTextAlignmentLeft;
                    //likesLabel.adjustsFontSizeToFitWidth = YES;
                    [likesLabel setTag:221];
                    [button addSubview:likesLabel];
                    
                    //                [self saveSelectedPost];
                    [self saveLikes];
                    _likeStatus = @"YES";
                    
                }
                
            }else{
                
                _postLikes = @"0";
                
                _likeStatus = @"NO";
                //            NSLog(@"likes = %@",_postLikes);
                
                _postLikers = [NSMutableArray arrayWithObject:[KCSUser activeUser].email];
                
                
                int post_likes = [_postLikes intValue];
                post_likes=post_likes+1;
                _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                
                //        NSLog(@"likes data 2 = %@",_likesData);
                //        NSLog(@"likers data 2 = %@",_likersData);
                
                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(250, 225+45, 40, 40)];
                likesImageView.image = [UIImage imageNamed:@"full_heart.png"];
                [likesImageView setTag:220];
                [button addSubview:likesImageView];
                
                UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                likesLabel.textColor = [self colorWithHexString:@"f38686"]; //heartcolor //green:18af80
                likesLabel.backgroundColor=[UIColor whiteColor];
                [likesLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
                likesLabel.text = [NSString stringWithFormat:@"%@",_postLikes];
                likesLabel.textAlignment = NSTextAlignmentLeft;
                //likesLabel.adjustsFontSizeToFitWidth = YES;
                [likesLabel setTag:221];
                [button addSubview:likesLabel];
                
                //                [self saveSelectedPost];
                [self saveLikes];
                _likeStatus = @"YES";
                
            }
            
        } withProgressBlock:nil];
        
    }
    
}

- (void)saveLikes
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _postId;
    yookaObject.likes = _postLikes;
    yookaObject.likers = _postLikers;
    [yookaObject.meta setGloballyReadable:YES];
    [yookaObject.meta setGloballyWritable:YES];
    
    KCSUser* myFriend = [KCSUser activeUser];
    [yookaObject.meta.readers addObject:myFriend.userId];
    //add 'myFriend' to the writers list as well
    [yookaObject.meta.writers addObject:myFriend.userId];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
//            NSLog(@"Not saved event (error= %@).",errorOrNil);

        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
//                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                [self.gridScrollView setUserInteractionEnabled:YES];

            }
        }
    } withProgressBlock:nil];
}

- (void)tapThrice:(id)sender
{
//    NSLog(@"Tap thrice");
}

- (UIImage*) blur:(UIImage*)theImage
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    return [UIImage imageWithCGImage:cgImage];
    
    // if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

- (void)getUserImage:(int)num
{
    NSString *venueName = [_newsFeed[num] objectForKey:@"venueName"];
    NSString *venueAddress = [_newsFeed[num] objectForKey:@"venueAddress"];
    NSString *venueState = [_newsFeed[num] objectForKey:@"venueState"];
    NSString *hunt_name = [_newsFeed[num] objectForKey:@"HuntName"];
    NSString *post_type = [_newsFeed[num] objectForKey:@"postType"];
    
    if (venueName) {
        [self.newsfeed_venuename addObject:venueName];
    }else{
        [self.newsfeed_venuename addObject:@""];
    }
    
    if (venueAddress) {
        [self.newsfeed_venueaddress addObject:venueAddress];
    }else{
        [self.newsfeed_venueaddress addObject:@"New York"];
    }
    
    if (venueState) {
        [self.newsfeed_venuestate addObject:venueState];
    }else{
        [self.newsfeed_venuestate addObject:@""];
    }
    
    NSUserDefaults *ud = [ NSUserDefaults standardUserDefaults];
    
    if (num==19) {
        [ud setObject:self.newsfeed_venuename forKey:@"newsfeedVenuename"];
        [ud setObject:self.newsfeed_venueaddress forKey:@"newsfeedVenueaddress"];
        [ud setObject:self.newsfeed_venuestate forKey:@"newsfeedVenuestate"];
    }

//    NSLog(@"index num = %d",num);
    
    UIButton* button = [self.thumbnails objectAtIndex:num];
    
    [button setBackgroundColor:[self colorWithHexString:@"f0f0f0"]]; //a7a7a7
    
    //        if (j==0) {
//    UIImageView *blueBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 45)];
//    [blueBg setBackgroundColor:[self colorWithHexString:@"75bfea"]];
//    [button addSubview:blueBg];
    
//    NSLog(@"venue address = %@",venueAddress);
    
    NSString *userId = [_newsFeed[num] objectForKey:@"userEmail"];
    
    if ([[_newsFeed[num] objectForKey:@"postType"] isEqualToString:@"started hunt"]) {
        
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:userId done:^(UIImage *image, SDImageCacheType cacheType)
         {
             if (image) {
                 
                 
                 UIImageView *buttonImage4 = [[UIImageView alloc]initWithFrame:CGRectMake( 12, 10, 55, 55)];
                 buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                 [buttonImage4.layer setBorderWidth:2.0];
                 buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                 [buttonImage4.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                 [buttonImage4 setContentMode:UIViewContentModeScaleAspectFill];
                 buttonImage4.clipsToBounds = YES;
                 buttonImage4.image = image;
                 buttonImage4.opaque = YES;
                 [button addSubview:buttonImage4];
                 
                 UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
                 [user_button  setFrame:CGRectMake(12, 5, 55, 55)];
                 [user_button setBackgroundColor:[UIColor clearColor]];
                 user_button.tag = num;
                 [user_button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
                 [button addSubview:user_button];
                 
                 NSString *userFullName = [_newsFeed[num] objectForKey:@"userFullName"];
                 UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 25, 240, 30)];
                 userLabel.textColor = [UIColor lightGrayColor];
                 userLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
                 if ([_newsFeed[num] objectForKey:@"postType"]) {
                     //                                              NSLog(@"type yes");
                     userLabel.text = [[_newsFeed[num] objectForKey:@"postCaption"] capitalizedString];
                     userLabel.text=[userLabel.text uppercaseString];
                     
                 }else{
                     //                                              NSLog(@"type no");
                     //                             userLabel.text = [NSString stringWithFormat:@"%@ is at %@",userFullName,venueName];
                 }
                 [userLabel setBackgroundColor:[UIColor clearColor]];
                 userLabel.textAlignment = NSTextAlignmentLeft;
                 userLabel.adjustsFontSizeToFitWidth = YES;
                 //                     userLabel.numberOfLines = 0;
                 [button addSubview:userLabel];
                 
                 NSArray *items = [userFullName componentsSeparatedByString:@" "];
                 NSString *first_name = items[0];
                 
                 UILabel *wentto = [[UILabel alloc]initWithFrame:CGRectMake(75, 15, 200, 20)];
                 wentto.textColor = [UIColor lightGrayColor];
                 [wentto setFont:[UIFont fontWithName:@"OpenSans" size:8]];
                 wentto.text = [NSString stringWithFormat:@"%@ started the:",first_name];
                 wentto.textAlignment = NSTextAlignmentLeft;
                 wentto.adjustsFontSizeToFitWidth = YES;
                 [wentto setBackgroundColor:[UIColor clearColor]];
                 [button addSubview:wentto];
                 
                 [_gridScrollView addSubview:button];

             }else{
                 
                 _collectionName2 = @"userPicture";
                 _customEndpoint2 = @"NewsFeed";
                 _fieldName2 = @"_id";
                 _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"userEmail",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
                 
                 [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
                     if ([results isKindOfClass:[NSArray class]]) {
                         NSArray *results_array = [NSArray arrayWithArray:results];
                         if (results_array && results_array.count) {
                             //                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                             NSString *userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                             [_userPicUrls addObject:userPicUrl];
                             NSString *userFullName = [results[0] objectForKey:@"userFullName"];
                             [self.newsfeed_userfullname addObject:userFullName];
                             [_userNames addObject:userFullName];
                             if (num==19) {
                                 [ud setObject:self.newsfeed_userfullname forKey:@"newsfeedUserfullname"];
                             }
                             [ud synchronize];
                             
                             if (userPicUrl) {
                                 
                                 //                                     UIImageView *buttonImage3 = [[UIImageView alloc]initWithFrame:CGRectMake( 4.5, 5, 34, 39)];
                                 //                                     buttonImage3.image = [UIImage imageNamed:@"regular_timeline_imagesize.png"];
                                 //                                     [button addSubview:buttonImage3];
                                 
                                 UIImageView *buttonImage4 = [[UIImageView alloc]initWithFrame:CGRectMake( 12, 10, 55, 55)];
                                 buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                                 [buttonImage4.layer setBorderWidth:2.0];
                                 buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                                 [buttonImage4.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                                 [buttonImage4 setContentMode:UIViewContentModeScaleAspectFill];
                                 buttonImage4.clipsToBounds = YES;
                                 buttonImage4.image = nil;
                                 buttonImage4.opaque = YES;
                                 
                                 [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:userPicUrl]
                                                                                     options:0
                                                                                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                  {
                                      // progression tracking code
                                  }
                                                                                   completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                                  {
                                      if (image && finished)
                                      {
                                          //                                         NSLog(@"found image");
                                          [[SDImageCache sharedImageCache] storeImage:image forKey:userId];
                                          
                                          buttonImage4.image = image;
                                          [button addSubview:buttonImage4];
                                          
                                          UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                          [user_button  setFrame:CGRectMake(12, 5, 55, 55)];
                                          [user_button setBackgroundColor:[UIColor clearColor]];
                                          user_button.tag = num;
                                          [user_button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
                                          [button addSubview:user_button];
                                          
                                          UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 25, 240, 30)];
                                          userLabel.textColor = [UIColor lightGrayColor];
                                          userLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
                                          if ([_newsFeed[num] objectForKey:@"postType"]) {
                                              //                                              NSLog(@"type yes");
                                              userLabel.text = [[_newsFeed[num] objectForKey:@"postCaption"] capitalizedString];
                                              userLabel.text=[userLabel.text uppercaseString];
                                              
                                          }else{
                                              //                                              NSLog(@"type no");
                                              //                             userLabel.text = [NSString stringWithFormat:@"%@ is at %@",userFullName,venueName];
                                          }
                                          [userLabel setBackgroundColor:[UIColor clearColor]];
                                          userLabel.textAlignment = NSTextAlignmentLeft;
                                          userLabel.adjustsFontSizeToFitWidth = YES;
                                          //                     userLabel.numberOfLines = 0;
                                          [button addSubview:userLabel];
                                          
                                          NSArray *items = [userFullName componentsSeparatedByString:@" "];
                                          NSString *first_name = items[0];
                                          
                                          UILabel *wentto = [[UILabel alloc]initWithFrame:CGRectMake(75, 15, 200, 20)];
                                          wentto.textColor = [UIColor lightGrayColor];
                                          [wentto setFont:[UIFont fontWithName:@"OpenSans" size:8]];
                                          wentto.text = [NSString stringWithFormat:@"%@ started the:",first_name];
                                          wentto.textAlignment = NSTextAlignmentLeft;
                                          wentto.adjustsFontSizeToFitWidth = YES;
                                          [wentto setBackgroundColor:[UIColor clearColor]];
                                          [button addSubview:wentto];
                                          
                                          [_gridScrollView addSubview:button];
                                          
                                      }else{
                                          
                                      }
                                      
                                  }];
                                 
                                 
                             }else{
                                 
                             }
                             
                         }else{
                             
                         }
                         
                     }else{
                         
                         
                     }
                 }];

             }
         }];
        
        //NOT STARTED A HUNT
        
    }else{

        if (venueName){
            
            UIButton *rest_arrow = [UIButton buttonWithType:UIButtonTypeCustom];
            [rest_arrow  setFrame:CGRectMake(80, 10, 220, 45)];
            [rest_arrow setBackgroundColor:[UIColor clearColor]];
            rest_arrow.tag = num;
            [rest_arrow addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:rest_arrow];
            
    }
        
            _collectionName2 = @"userPicture";
            _customEndpoint2 = @"NewsFeed";
            _fieldName2 = @"_id";
            _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"userEmail",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
                 
            [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
                    if ([results isKindOfClass:[NSArray class]]) {
                         NSArray *results_array = [NSArray arrayWithArray:results];
                        if (results_array && results_array.count) {
                             //                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                             NSString *userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                             [_userPicUrls addObject:userPicUrl];

                             NSString *userFullName = [results[0] objectForKey:@"userFullName"];
                             
                             [_userNames addObject:userFullName];
                             [self.newsfeed_userfullname addObject:userFullName];
                             
                             if (num==19) {
                                 [ud setObject:self.newsfeed_userfullname forKey:@"newsfeedUserfullname"];
                             }

                             [ud synchronize];
                             
                             if (userPicUrl) {
                                 
                                 UIImageView *buttonImage4 = [[UIImageView alloc]initWithFrame:CGRectMake( 12, 10, 55, 55)];
                                 buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                                 [buttonImage4.layer setBorderWidth:2.0];
                                 [buttonImage4.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                                 [buttonImage4 setContentMode:UIViewContentModeScaleAspectFill];
                                 buttonImage4.clipsToBounds = YES;
                                 buttonImage4.image = nil;
                                 buttonImage4.opaque = YES;
                                 
                                 [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:userPicUrl]
                                                                                     options:0
                                                                                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                  {
                                      // progression tracking code
                                  }
                                                                                   completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                                  {
                                      if (image && finished)
                                      {

//                                         NSLog(@"found image");
                                          [[SDImageCache sharedImageCache] storeImage:image forKey:userId];
                                          
                                          buttonImage4.image = image;
                                          [button addSubview:buttonImage4];
                                          
                                          UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                          [user_button  setFrame:CGRectMake(12, 5, 55, 55)];
                                          [user_button setBackgroundColor:[UIColor clearColor]];
                                          user_button.tag = num;
                                          [user_button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
                                          [button addSubview:user_button];
                                          
                                          UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 180, 220, 30)];
                                          userLabel.textColor = [UIColor whiteColor];
                                          userLabel.adjustsFontSizeToFitWidth = YES;
                                          userLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0];
                                          
                                          UILabel *userLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(25, 241, 300, 25)];
                                          userLabel2.textColor = [UIColor whiteColor];
                                          userLabel2.adjustsFontSizeToFitWidth = YES;

                                          userLabel2.font = [UIFont fontWithName:@"OpenSans-Semibold" size:7.0];
                                          
                                          NSArray *items = [userFullName componentsSeparatedByString:@" "];
                                          NSString *first_name = items[0];

                                          
                                          if ([[_newsFeed[num] objectForKey:@"postType"] isEqualToString:@"hunt"]) {
                                              
                                              UILabel *wentto = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 200, 20)];
                                              wentto.textColor = [UIColor lightGrayColor];
                                              [wentto setFont:[UIFont fontWithName:@"OpenSans" size:8]];
                                              wentto.text = [NSString stringWithFormat:@"%@ went to:",first_name];
                                              wentto.textAlignment = NSTextAlignmentLeft;
                                              wentto.adjustsFontSizeToFitWidth = YES;
                                              [wentto setBackgroundColor:[UIColor clearColor]];
                                              [button addSubview:wentto];
                                              
                                              UILabel *venueName2 = [[UILabel alloc]initWithFrame:CGRectMake(80, 23, 200, 20)];
                                              venueName2.textColor = [UIColor lightGrayColor];
                                              [venueName2 setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:11]];
                                              venueName2.text = [NSString stringWithFormat:@"%@",venueName];
                                              venueName2.text=[venueName2.text uppercaseString];
                                              venueName2.textAlignment = NSTextAlignmentLeft;
                                              venueName2.adjustsFontSizeToFitWidth = YES;
                                              [venueName2 setBackgroundColor:[UIColor clearColor]];
                                              [button addSubview:venueName2];
                                              
//                                              NSLog(@"type yes");
                                              NSString *string5 = [NSString stringWithFormat:@"FEATURED IN %@",[hunt_name uppercaseString]];
                                              NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:string5];
                                              float spacing5 = .5f;
                                              [attributedString5 addAttribute:NSKernAttributeName
                                                                        value:@(spacing5)
                                                                        range:NSMakeRange(0, [string5 length])];
                                              
                                              userLabel2.attributedText = attributedString5;
                                              
                                          }else{
                                          
                                              UILabel *wentto = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 200, 20)];
                                              wentto.textColor = [UIColor lightGrayColor];
                                              [wentto setFont:[UIFont fontWithName:@"OpenSans" size:8]];
                                              wentto.text = [NSString stringWithFormat:@"%@ went to:",first_name];
                                              wentto.textAlignment = NSTextAlignmentLeft;
                                              wentto.adjustsFontSizeToFitWidth = YES;
                                              [wentto setBackgroundColor:[UIColor clearColor]];
                                              [button addSubview:wentto];
                                              
                                              UILabel *venueName2 = [[UILabel alloc]initWithFrame:CGRectMake(80, 23, 200, 20)];
                                              venueName2.textColor = [UIColor lightGrayColor];
                                              [venueName2 setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:11]];
                                              venueName2.text = [NSString stringWithFormat:@"%@",venueName];
                                              venueName2.text=[venueName2.text uppercaseString];
                                              venueName2.textAlignment = NSTextAlignmentLeft;
                                              venueName2.adjustsFontSizeToFitWidth = YES;
                                              [venueName2 setBackgroundColor:[UIColor clearColor]];
                                              [button addSubview:venueName2];
                                          
                                          }
                                          userLabel.textAlignment = NSTextAlignmentLeft;
                                          userLabel.adjustsFontSizeToFitWidth = YES;
                                          [button addSubview:userLabel];
                                          
                                          userLabel2.textAlignment = NSTextAlignmentLeft;
                                          //userLabel2.adjustsFontSizeToFitWidth = YES;
                                          [button addSubview:userLabel2];
                                          
                                          if(venueAddress){
                                              UILabel *venueLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 37, 200, 20)];
                                              venueLabel.textColor = [UIColor lightGrayColor];
                                              [venueLabel setFont:[UIFont fontWithName:@"OpenSans" size:7]];
                                              venueLabel.text = [NSString stringWithFormat:@"%@, %@",venueAddress,venueState];
                                              venueLabel.textAlignment = NSTextAlignmentLeft;
                                              venueLabel.adjustsFontSizeToFitWidth = YES;
                                              [venueLabel setBackgroundColor:[UIColor clearColor]];
                                              [button addSubview:venueLabel];
                                          }
                                          else{

                                          }
                                          
                                          [_gridScrollView addSubview:button];

                                      }else{

                                      }
                                      
                                  }];

                                 
                             }else{
                                 
                                 
                             }
                             
                             
                         }else{
                             //                    NSLog(@"fail 1");

                         }
                         
                     }else{
                         
                         //                NSLog(@"fail 2");
                         
                     }
                 }];
        
    }
}

- (void)imageLikes:(int)num
{
    
    if ([[_newsFeed[num] objectForKey:@"postType"] isEqualToString:@"started hunt"] ) {
        
    }else{

        NSString *kinveyId = [_newsFeed[num] objectForKey:@"_id"];
        
        UIButton* button = [self.thumbnails objectAtIndex:num];
        
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        [store loadObjectWithID:kinveyId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                if (objectsOrNil && objectsOrNil.count) {
                    
                    YookaBackend *backendObject = objectsOrNil[0];
                    NSMutableArray *myArray = [NSMutableArray arrayWithArray:backendObject.likers];
                    _likes = backendObject.likes;
                    
                    if ([_likes integerValue]>0) {
                        
                        [_likesData addObject:_likes];
                        [_likersData addObject:myArray];
                        
                        if([myArray containsObject:[KCSUser activeUser].email]){
                            
                            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(250, 225+45, 40, 40)];
                            likesImageView.image = [UIImage imageNamed:@"full_heart.png"];
                            [likesImageView setTag:220];
                            [button addSubview:likesImageView];
                            
                            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                            likesLabel.textColor = [self colorWithHexString:@"f38686"]; //heartcolor //green:18af80
                            likesLabel.backgroundColor=[UIColor clearColor];
                            //[likesLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:1]];
                            likesLabel.font=[UIFont fontWithName:@"OpenSans" size:10];
                            likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                            likesLabel.textAlignment = NSTextAlignmentLeft;
                            //likesLabel.adjustsFontSizeToFitWidth = YES;
                            [likesLabel setTag:221];
                            [button addSubview:likesLabel];
                            
                            UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                            [like_button  setFrame:CGRectMake(260, 220+45, 50, 35)];
                            [like_button setBackgroundColor:[UIColor clearColor]];
                            like_button.tag = num;
                            [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                            [button addSubview:like_button];
                            
                        }else{
                            
                            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(259, 224+45, 37, 37)];
                            likesImageView.backgroundColor=[UIColor clearColor];
                            [likesImageView setTag:220];
                            likesImageView.image = [UIImage imageNamed:@"Before_like.png"];
                            [button addSubview:likesImageView];
                            
                            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                            likesLabel.textColor = [self colorWithHexString:@"f38686"]; //heartcolor //green:18af80
                            likesLabel.backgroundColor=[UIColor clearColor];
                            //[likesLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:1]];
                            likesLabel.font=[UIFont fontWithName:@"OpenSans" size:10];
                            likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                            likesLabel.textAlignment = NSTextAlignmentLeft;
                            //likesLabel.adjustsFontSizeToFitWidth = YES;
                            [likesLabel setTag:221];
                            [button addSubview:likesLabel];
                            
                            UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                            [like_button  setFrame:CGRectMake(260, 220+45, 50, 35)];
                            [like_button setBackgroundColor:[UIColor clearColor]];
                            like_button.tag = num;
                            [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                            [button addSubview:like_button];
                            
                        }
                        
                    }else{
                        
                        _likes = @"0";
                        
                        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(259, 224+45, 37, 37)];
                        likesImageView.backgroundColor=[UIColor clearColor];
                        [likesImageView setTag:220];
                        likesImageView.image = [UIImage imageNamed:@"Before_like.png"];
                        [button addSubview:likesImageView];
                        
                        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                        likesLabel.textColor = [self colorWithHexString:@"f38686"]; //heartcolor //green:18af80
                        likesLabel.backgroundColor=[UIColor clearColor];
                        //[likesLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:1]];
                        likesLabel.font=[UIFont fontWithName:@"OpenSans" size:10];
                        likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                        likesLabel.textAlignment = NSTextAlignmentLeft;
                        //likesLabel.adjustsFontSizeToFitWidth = YES;
                        [likesLabel setTag:221];
                        [button addSubview:likesLabel];
                        
                        [_likesData addObject:@"0"];
                        [_likersData addObject:[NSNull null]];
                        
                        UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                        [like_button  setFrame:CGRectMake(260, 220+45, 50, 35)];
                        [like_button setBackgroundColor:[UIColor clearColor]];
                        like_button.tag = num;
                        [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                        [button addSubview:like_button];
                        
                    }
                    
                }else{
                    
                    _likes = @"0";
                    [_likesData addObject:_likes];
                    [_likersData addObject:[NSNull null]];
                    
                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(259, 224+45, 37, 37)];
                    likesImageView.backgroundColor=[UIColor clearColor];
                    [likesImageView setTag:220];
                    likesImageView.image = [UIImage imageNamed:@"Before_like.png"];
                    [likesImageView setTag:220];
                    [button addSubview:likesImageView];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                    likesLabel.textColor = [self colorWithHexString:@"f38686"]; //heartcolor //green:18af80
                    likesLabel.backgroundColor=[UIColor clearColor];
                    //[likesLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:1]];
                    likesLabel.font=[UIFont fontWithName:@"OpenSans" size:10];
                    likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                    likesLabel.textAlignment = NSTextAlignmentLeft;
                    //likesLabel.adjustsFontSizeToFitWidth = YES;
                    [likesLabel setTag:221];
                    [button addSubview:likesLabel];
                    
                    UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [like_button  setFrame:CGRectMake(260, 220+45, 50, 35)];
                    [like_button setBackgroundColor:[UIColor clearColor]];
                    like_button.tag = num;
                    [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                    [button addSubview:like_button];
                    
                }
                
            } else {
                
                //                                            NSLog(@"error occurred: %@", errorOrNil);
                _likes = @"0";
                [_likesData addObject:_likes];
                [_likersData addObject:[NSNull null]];
                
                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(259, 224+45, 37, 37)];
                likesImageView.backgroundColor=[UIColor clearColor];
                [likesImageView setTag:220];
                likesImageView.image = [UIImage imageNamed:@"Before_like.png"];
                [button addSubview:likesImageView];
                
                UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 235+45, 18, 15)];
                likesLabel.textColor = [self colorWithHexString:@"f38686"]; //heartcolor //green:18af80
                likesLabel.backgroundColor=[UIColor clearColor];
                //[likesLabel setFont:[UIFont fontWithName:@"OpenSans-Regular" size:1]];
                likesLabel.font=[UIFont fontWithName:@"OpenSans" size:10];
                likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                likesLabel.textAlignment = NSTextAlignmentLeft;
                //likesLabel.adjustsFontSizeToFitWidth = YES;
                [likesLabel setTag:221];
                [button addSubview:likesLabel];
                
                UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                [like_button  setFrame:CGRectMake(260, 220+45, 50, 35)];
                [like_button setBackgroundColor:[UIColor clearColor]];
                like_button.tag = num;
                [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                [button addSubview:like_button];
                
            }
        } withProgressBlock:nil];
        
    }
}


- (void)loadPics
{
    
}

- (void)buttonAction:(id)sender
{
//    UIButton* button = sender;
//    NSUInteger b = button.tag;
//    NSLog(@"button %lu pressed",(unsigned long)b);
    
}

- (void)buttonAction2:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
//    NSLog(@"button %lu pressed",(unsigned long)b);
    
    [Flurry logEvent:@"Newsfeed_User_Button_Clicked"];
    
    if (b == 901) {
        //do nothing
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.35;
        transition.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        
        UIView *containerView = self.view.window;
        [containerView.layer addAnimation:transition forKey:nil];
        
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *userId = [_newsFeed5[0] objectForKey:@"userEmail"];
        NSString *userFullName = [ud objectForKey:userId];
        NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
        NSString *userPicUrl = [ud objectForKey:userId2];
        
        if ([self.myEmail isEqual:userId]){
            YookaProfileNewViewController *media2 = [[YookaProfileNewViewController alloc]init];
            
            [self presentViewController:media2 animated:NO completion:nil];
            
        }
        else{
            
            YookaClickProfileViewController *media = [[YookaClickProfileViewController alloc]init];
            
            media.userFullName = userFullName;
            media.myEmail = userId;
            media.myURL =userPicUrl;
            
            
            [self presentViewController:media animated:NO completion:nil];
            
        }
        
    }else{
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.35;
        transition.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        
        UIView *containerView = self.view.window;
        [containerView.layer addAnimation:transition forKey:nil];
        
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *userId = [_newsFeed[b] objectForKey:@"userEmail"];
        NSString *userFullName = [ud objectForKey:userId];
        NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
        NSString *userPicUrl = [ud objectForKey:userId2];
        
        
        if ([self.myEmail isEqual:userId]){
            YookaProfileNewViewController *media2 = [[YookaProfileNewViewController alloc]init];
            
            [self presentViewController:media2 animated:NO completion:nil];
            
        }
        else{
            
            YookaClickProfileViewController *media = [[YookaClickProfileViewController alloc]init];
            media.userFullName = userFullName;
            media.myEmail = userId;
            media.myURL =userPicUrl;
            
            [self presentViewController:media animated:NO completion:nil];
        }
    }
    
    
}


- (void)gotoRestaurant:(id)sender
{
    UIButton* button = sender;
    
    NSUInteger b = button.tag;
    
    NSString *venueId = [_newsFeed[b] objectForKey:@"venueId"];
    NSString *venueName = [_newsFeed[b] objectForKey:@"venueName"];
    
    [Flurry logEvent:@"Newsfeed_Restaurant_Button_Clicked"];
    
    YookaRestaurantViewController* media = [[YookaRestaurantViewController alloc]init];
    media.venueId = venueId;
    media.selectedRestaurantName = venueName;
    [self presentViewController:media animated:NO completion:nil];

}

//
//- (void)commentsBtnTouched:(id)sender{
//    
//    
//    UIButton* button1 = sender;
//    
//    NSUInteger b = button1.tag;
//
//    
//    UIButton* button = [self.thumbnails objectAtIndex:b];
//    
//    
//    
//    
//    if ( toggle[b]==1){
//        //do nothing
//    }
//    else{
//        self.captionModalView = [[UIImageView alloc] initWithFrame:CGRectMake(0+49, 0+42, button.frame.size.width -53, button.frame.size.height -82)];
//        self.captionModalView.opaque = NO;
//        self.captionModalView.backgroundColor = [[self colorWithHexString:(@"88888D")] colorWithAlphaComponent:0.7f];
//        //[self.captionModalView setTag:b];
//        [self.captionModalView setTag:117];
//        [button addSubview:self.captionModalView];
//        
//        NSString *caption = [self.newsFeed[b] objectForKey:@"caption"];
//        
//        UILabel *captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 75, self.captionModalView.frame.size.width-10, self.captionModalView.frame.size.height-75)];
//        captionLabel.textColor = [UIColor whiteColor];
//        [captionLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:13]];
//        captionLabel.text = [NSString stringWithFormat:@"%@",caption];
//        captionLabel.textAlignment = NSTextAlignmentCenter;
//        captionLabel.adjustsFontSizeToFitWidth = YES;
//        captionLabel.numberOfLines = 0;
//        [captionLabel sizeToFit];
//        CGRect myFrame = captionLabel.frame;
//        // Resize the frame's width to 280 (320 - margins)
//        // width could also be myOriginalLabelFrame.size.width
//        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, self.captionModalView.frame.size.width-10, myFrame.size.height);
//        captionLabel.frame = myFrame;
//        [captionLabel setBackgroundColor:[UIColor clearColor]];
//        
//        [captionLabel setTag:110];
//        [self.captionModalView addSubview:captionLabel];
//        
//        
//        YookaButton* closeButton = [YookaButton buttonWithType:UIButtonTypeCustom];
//        [closeButton  setFrame:CGRectMake((button.frame.size.width)-55, +43,45,25)];
//        [closeButton setBackgroundColor:[UIColor clearColor]];
//        [closeButton setBackgroundImage:[[UIImage imageNamed:@"close_button.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
//        
//        [closeButton setTag:119];
//        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [closeButton addTarget:self action:@selector(closeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
//        [button addSubview:closeButton];
//        
//        closeButton.fourthTag=b;
//        
//        toggle[b]=1;
// 
//        }
//
//}

- (void)closeBtnTouched:(id)sender{
    
    
    YookaButton *b3 = (YookaButton*)sender;
    
    UIButton* button1 = sender;
//    NSUInteger b = button1.tag;
    
    UIButton* button = [self.thumbnails objectAtIndex:b3.fourthTag];
    
    toggle[b3.fourthTag]=0;
    
    UIView* removeCaption = [button viewWithTag:110];
    
    UIView* removeCloseButton = [button viewWithTag:119];
    UIView* removeCaptionModal = [button viewWithTag:117];
    
    [removeCaptionModal removeFromSuperview];
    [removeCloseButton removeFromSuperview];
    [removeCaption removeFromSuperview];
    [button1 removeFromSuperview];
    

}

- (void)backAction
{
    //    NSLog(@"back button pressed");
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _postsData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.postsData) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 370;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_postsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        // create a custom label:                                        x    y   width  height
//        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 320.0)];
//        [_descriptionLabel setTag:1];
//        [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
//        _descriptionLabel.textColor = [UIColor grayColor];
//        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
//        [_descriptionLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:16]];
//        // custom views should be added as subviews of the cell's contentView:
//        [cell.contentView addSubview:_descriptionLabel];
        
    }
    
    //    cell.textLabel.text = [self.nearbyVenues[indexPath.row] name];
    
    //    ((UIImageView *)cell.backgroundView).image = [UIImage imageNamed:@"check_box.jpeg"];
//    [(UILabel *)[cell.contentView viewWithTag:1] setText:[self.nearbyVenues[indexPath.row] name]];
    
    NSString *postPicUrl = [[_postsData[indexPath.row] objectForKey:@"dishImage"]objectForKey:@"_downloadURL"];
//    NSLog(@"profile image = %@",postPicUrl);
    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(q, ^{
        /* Fetch the image from the server... */
        NSURL *url = [NSURL URLWithString:postPicUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            /* This is the main thread again, where we set the tableView's image to
             be what we just fetched. */
            UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10,10, 300, 300)];
            imv.image=img;
            [cell.contentView addSubview:imv];;
            
        });
    });
    
    return cell;
}

//-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSIndexPath *oldIndex = [locationTableView indexPathForSelectedRow];
//    [locationTableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
//    [locationTableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
//    [locationTableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor purpleColor];
//    return indexPath;
//}

#pragma mark - Table view delegate

- (void)checkin {
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //    CheckinViewController *checkin = [storyboard instantiateViewControllerWithIdentifier:@"CheckinVC"];
    //    checkin.venue = self.selected;
    //    [self.navigationController pushViewController:checkin animated:YES];
}

- (void)userDidSelectVenue {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //    if (self.lastSelected==indexPath) return; // nothing to do
    //
    //    // deselect old
    //    UITableViewCell *old = [locationTableView cellForRowAtIndexPath:self.lastSelected];
    //    old.accessoryType = UITableViewCellAccessoryNone;
    //    old.backgroundColor = [UIColor blackColor];
    //    [old setSelected:FALSE animated:TRUE];
    //
    //    // select new
    //    UITableViewCell *cell = [locationTableView cellForRowAtIndexPath:indexPath];
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //    cell.backgroundColor = [UIColor purpleColor];
    //    [cell setSelected:TRUE animated:TRUE];
    
//    [_textField resignFirstResponder];
    
    // keep track of the last selected cell
    self.lastSelected = indexPath;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    self.selected = self.postsData[indexPath.row];
    //    if (self.selected.location.address) {
    //        _venueAddress = self.selected.location.address;
    //    }
    //    if (self.selected.location.cc) {
    //        _venueCc = self.selected.location.cc;
    //    }
    //    if (self.selected.location.city) {
    //        _venueCity = self.selected.location.city;
    //    }
    //    if (self.selected.location.country) {
    //        _venueCountry = self.selected.location.country;
    //    }
    //    if ([self.selected.location.postalCode stringValue]) {
    //        _venuePostalCode = [self.selected.location.postalCode stringValue];
    //    }
    //    if (self.selected.location.state) {
    //        _venueState = self.selected.location.state;
    //    }
    [self userDidSelectVenue];
    
    [_postsTableView reloadData];
    [self.postsTableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
}

@end
