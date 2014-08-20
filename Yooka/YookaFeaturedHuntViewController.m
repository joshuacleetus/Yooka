//
//  YookaFeaturedHuntViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 6/4/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaFeaturedHuntViewController.h"
#import "UIImageView+WebCache.h"
#import "YookaBackend.h"
#import "MPFlipTransition.h"
#import "FlipView.h"
#import "AnimationDelegate.h"
#import "YookaHuntVenuesViewController.h"
#import "PulsingHaloLayer.h"
#import "MultiplePulsingHaloLayer.h"
#import "Flurry.h"
#import <QuartzCore/QuartzCore.h>

@interface YookaFeaturedHuntViewController ()
@property (nonatomic, strong) MultiplePulsingHaloLayer *mutiHalo;
@property (nonatomic, weak) PulsingHaloLayer *halo;
@end

@implementation YookaFeaturedHuntViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
   // NSLog(@"Liverpool2");
    // Do any additional setup after loading the view.
//    [self.view setBackgroundColor:[self colorWithHexString:@"43444f"]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.huntDescriptionDict = [NSMutableDictionary new];
    self.huntCountDict = [NSMutableDictionary new];
    self.huntLogoUrlDict = [NSMutableDictionary new];
    self.huntPicUrlDict = [NSMutableDictionary new];
    self.huntDict5 = [NSMutableDictionary new];
    self.huntDict6 = [NSMutableDictionary new];
    self.sponsored_hunt_names = [NSMutableArray new];
    self.featured_hunt_names = [NSMutableArray new];
    self.featured_hunt = [NSMutableArray new];
    self.featured_hunts = [NSMutableArray new];
    self.subscribedHunts = [NSMutableArray new];
    self.unsubscribedHunts = [NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.huntDescriptionDict = [defaults objectForKey:@"huntDescription"];
    self.huntCountDict = [defaults objectForKey:@"huntCount"];
    self.huntLogoUrlDict = [defaults objectForKey:@"huntLogoUrl"];
    self.huntPicUrlDict = [defaults objectForKey:@"huntPicUrl"];
    self.sponsored_hunt_names = [[defaults objectForKey:@"sponsoredHunts"]mutableCopy];
    self.subscribedHunts = [[defaults objectForKey:@"subscribedHuntNames"]mutableCopy];
    self.unsubscribedHunts = [[defaults objectForKey:@"unsubscribedHuntNames"]mutableCopy];
    self.featured_hunt_names = [[defaults objectForKey:@"featuredHuntNames"]mutableCopy];
    self.huntPicUrl = [self.huntPicUrlDict objectForKey:_huntTitle];
    
    [self getHuntDescription];
    
    self.myEmail = [KCSUser activeUser].email;
    self.userEmail = [[KCSUser activeUser] email];
    self.firstName = [[KCSUser activeUser] givenName];
    self.userFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
    
    KCSCollection* collection = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
    self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyResource : collection, KCSStoreKeyCachePolicy : @(KCSCachePolicyBoth), KCSStoreKeyOfflineUpdateEnabled : @YES }];
    
    self.bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    //[self.bgImage setImage:[UIImage imageNamed:@"profile_bg.png"]];
    [self.view addSubview:self.bgImage];
    
    self.scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 250)];
    self.scrollView1.delegate = self;
    [self.view addSubview:self.scrollView1];
    [self.scrollView1 setBackgroundColor:[UIColor clearColor]];
    [self.scrollView1 setPagingEnabled:YES];
    self.scrollView1.showsHorizontalScrollIndicator = NO;
    
    self.hunts_pages = [[UIPageControl alloc] init];
    self.hunts_pages.frame = CGRectMake(241,210,39,37);
    self.hunts_pages.enabled = TRUE;
    [self.hunts_pages setHighlighted:YES];
    [self.view addSubview:self.hunts_pages];
    
    [self getFeaturedRestaurants];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.doneButton setFrame:CGRectMake(260, 15, 50, 50)];
//    [self.doneButton setTitle:@"X" forState:UIControlStateNormal];
    [self.doneButton setBackgroundImage:[UIImage imageNamed:@"whitex.png"] forState:UIControlStateNormal];
    [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.doneButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:25]];
//    [self.doneButton setBackgroundImage:[[UIImage imageNamed:@"logoutbtn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.doneButton];
    
    UIImageView *location_icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 212, 25, 30)];
    [location_icon setImage:[UIImage imageNamed:@"location_icon.png"]];
    [self.view addSubview:location_icon];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(23, 220, 200, 15)];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.numberOfLines = 0;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.nameLabel];
    
//    self.descriptionImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 260, 320, 200)];
//    [self.descriptionImage setImage:[UIImage imageNamed:@"discription-background_normal.png"]];
//    [self.view addSubview:self.descriptionImage];
    
    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, 320, 20)];
    self.descriptionLabel.textColor = [self colorWithHexString:@"6e6e6e"];
    self.descriptionLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.0];
    NSString *string = @"INFORMATION";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    float spacing = 1.5f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
    self.descriptionLabel.attributedText = attributedString;
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.descriptionLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 335, 320, 1)];
    lineView.backgroundColor = [self colorWithHexString:@"f5f5f5"];
    [self.view addSubview:lineView];
    
    UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(55, 285, 2, 50)];
    lineView4.backgroundColor = [self colorWithHexString:@"f5f5f5"];
    [self.view addSubview:lineView4];
    
    UIImageView *info_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 290, 37, 37)];
    [info_icon setImage:[UIImage imageNamed:@"info.png"]];
    [self.view addSubview:info_icon];
    
//    self.countLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 195, 83, 60)];
//    self.countLabel.text = [_huntDict2 objectForKey:_huntTitle];
//    self.countLabel.textColor = [UIColor whiteColor];
//    self.countLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:30.0];
//    [self.view addSubview:self.countLabel];
    
    UIImageView *restaurant_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 240, 320, 45)];
    [restaurant_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    [self.view addSubview:restaurant_bg];
    
    self.restaurantLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 240, 320, 45)];
    self.restaurantLabel.textColor = [UIColor whiteColor];
    self.restaurantLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.0];
    NSString *string4 = [self.huntTitle uppercaseString];
    NSMutableAttributedString *attributedString4 = [[NSMutableAttributedString alloc] initWithString:string4];
    float spacing4 = 1.5f;
    [attributedString4 addAttribute:NSKernAttributeName
                              value:@(spacing4)
                              range:NSMakeRange(0, [string4 length])];
    self.restaurantLabel.attributedText = attributedString4;
    self.restaurantLabel.adjustsFontSizeToFitWidth = YES;
//    self.restaurantLabel.numberOfLines = 0;
    [self.restaurantLabel setBackgroundColor:[UIColor clearColor]];
    self.restaurantLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.restaurantLabel];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 475, 320, 1)];
    lineView2.backgroundColor = [self colorWithHexString:@"f5f5f5"];
    //[self.view addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 490, 320, 1)];
    lineView3.backgroundColor = [self colorWithHexString:@"f5f5f5"];
    [self.view addSubview:lineView3];
    
    UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(215, 525, 30, 10)];
    arrow.backgroundColor=[UIColor clearColor];
    arrow.image = [UIImage imageNamed:@"upload_share_arrow.png"];
    [self.view addSubview:arrow];
    
    self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(70, 510, 40, 40)];
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
//    [self.profileImageView.layer setBorderWidth:4.0];
    [self.profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.profileImageView setClipsToBounds:YES];
    [self.view addSubview:self.profileImageView];
    
    // check if image is already cached in userdefaults.
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData* imageData = [ud objectForKey:@"MyProfilePic"];
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (image) {
        
        [self.profileImageView setImage:image];
        
    }else{
        
        [self getUserPicUrl];
        
    }
    
    //you can specify the number of halos by initial method or by instance property "haloLayerNumber"
    PulsingHaloLayer *layer = [PulsingHaloLayer layer];
    self.halo = layer;
    self.halo.position = self.profileImageView.center;
    layer.radius = 40.0;
    UIColor *color = [UIColor colorWithRed:0
                                     green:0.5
                                      blue:1.0
                                     alpha:1.0];
    layer.backgroundColor = color.CGColor;
    [self.view.layer insertSublayer:self.halo below:self.profileImageView.layer];
    
    if (self.subscribedHunts.count) {
        NSLog(@"subscribed hunts");
        UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(123, 520, 100, 20)];
        NSString *string5 = @"GET STARTED";
        if (string5) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string5];
            float spacing = 1.4f;
            [attributedString addAttribute:NSKernAttributeName
                                     value:@(spacing)
                                     range:NSMakeRange(0, [string5 length])];
            shareLabel.attributedText = attributedString;
        }
        shareLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
        shareLabel.textColor = [self colorWithHexString:@"3ac0ec"];
        [self.view addSubview:shareLabel];
        
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.startButton  setFrame:CGRectMake(110, 505, 130, 50)];
        [self.startButton setBackgroundColor:[UIColor clearColor]];
        [self.startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.startButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15]];
        self.startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.view addSubview:self.startButton];
    }else{
        NSLog(@"no subscribed hunts");
        [self checkSubscribedHunts];
    }
    
}

- (void)getHuntDescription
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"ListPopup" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"Name" withExactMatchForValue:self.huntTitle];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
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
            
            self.featured_hunt = [NSMutableArray arrayWithArray:objectsOrNil];
            YookaBackend *yooka = self.featured_hunt[0];
            self.huntDescription = yooka.Description;
            
            self.huntDescriptionLabel = [[UILabel alloc]init];
            self.huntDescriptionLabel.textColor = [self colorWithHexString:@"6e6e6e"];
            self.huntDescriptionLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:12.0];
            self.huntDescriptionLabel.textAlignment = NSTextAlignmentJustified;
            self.huntDescriptionLabel.numberOfLines = 0;
            
            // NSString *string3 = [yooka.Hood uppercaseString]
            CGSize labelSize = CGSizeMake(300, 305);
            CGSize theStringSize = [self.huntDescription sizeWithFont:self.huntDescriptionLabel.font constrainedToSize:labelSize lineBreakMode:self.huntDescriptionLabel.lineBreakMode];
            //    NSLog(@"string size = %f %f",theStringSize.width,theStringSize.height);
            
            if (theStringSize.height>128.0) {
                
                self.gridScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 345, 300, 135)];
                self.gridScrollView.contentSize= self.view.bounds.size;
                [self.view addSubview:self.gridScrollView];
                [self.gridScrollView setContentSize:CGSizeMake(280, theStringSize.height+20)];
                self.huntDescriptionLabel.frame = CGRectMake(self.huntDescriptionLabel.frame.origin.x, self.huntDescriptionLabel.frame.origin.y, theStringSize.width, theStringSize.height);
                [self.huntDescriptionLabel setText:self.huntDescription];
                [self.huntDescriptionLabel sizeToFit];
                self.huntDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                [self.huntDescriptionLabel setBackgroundColor:[UIColor clearColor]];
                [self.gridScrollView addSubview:self.huntDescriptionLabel];
                
            }else{
                
                self.huntDescriptionLabel.frame = CGRectMake(10, 345, 300, 135);
                [self.huntDescriptionLabel setText:self.huntDescription];
                [self.huntDescriptionLabel sizeToFit];
                self.huntDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                [self.huntDescriptionLabel setBackgroundColor:[UIColor clearColor]];
                [self.view addSubview:self.huntDescriptionLabel];
                
            }
            
            if(isiPhone5){
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                int launches = [[ud objectForKey:@"huntstarting_screen"]intValue];
                
                if(launches == 0){
                    
                    self.instruction_screen_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 240, 320, 338)];
                    [self.instruction_screen_1 setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
                    [self.view addSubview:self.instruction_screen_1];
                    
                    UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(150, -30, 60, 60)];
                    [pointing_finger setImage:[UIImage imageNamed:@"swipe_left.png"]];
                    [self.instruction_screen_1 addSubview:pointing_finger];
                    
                    UILabel *copy = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 320, 30)];
                    copy.text = @"Preview our 7 best locations!";
                    copy.textColor = [UIColor whiteColor];
                    copy.textAlignment = NSTextAlignmentCenter;
                    [self.instruction_screen_1 addSubview:copy];
                    
                    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
                    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
                    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
                    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(-20.0, 0.0)]; // y increases downwards on iOS
                    hover.autoreverses = YES; // Animate back to normal afterwards
                    hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
                    hover.repeatCount = INFINITY; // The number of times the animation should repeat
                    [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
                    
                    UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 200, 100, 30)];
                    next_label.textColor = [UIColor whiteColor];
                    next_label.text = @"NEXT-->";
                    [self.instruction_screen_1 addSubview:next_label];
                    
                    self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.next_button setFrame:CGRectMake(250, 440, 100, 30)];
                    [self.next_button addTarget:self action:@selector(next_action:) forControlEvents:UIControlEventTouchUpInside];
                    [self.next_button setBackgroundColor:[UIColor clearColor]];
                    [self.view addSubview:self.next_button];
                    
                    [self.startButton setUserInteractionEnabled:NO];
                    
                }

            }
            
        }
    } withProgressBlock:nil];

}

- (void)next_action:(id)sender{
    
    [self.instruction_screen_1 removeFromSuperview];
    [self.next_button removeFromSuperview];
    
    self.instruction_screen_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 500)];
    [self.instruction_screen_2 setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
    [self.view addSubview:self.instruction_screen_2];
    
    UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(150, 530, 60, 60)];
    [pointing_finger setImage:[UIImage imageNamed:@"tap_down.png"]];
    [self.instruction_screen_2 addSubview:pointing_finger];
    
    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -5.0)]; // y increases downwards on iOS
    hover.autoreverses = YES; // Animate back to normal afterwards
    hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
    hover.repeatCount = INFINITY; // The number of times the animation should repeat
    [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
    
    UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 460, 300, 30)];
    instruction1.textColor = [UIColor whiteColor];
    instruction1.text = @"Press here to see these places!";
    instruction1.textAlignment = NSTextAlignmentCenter;
    [self.instruction_screen_2 addSubview:instruction1];
    
    UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 350, 100, 30)];
    next_label.textColor = [UIColor whiteColor];
    next_label.text = @"DONE";
    [self.instruction_screen_2 addSubview:next_label];
    
    self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.next_button setFrame:CGRectMake(250, 350, 100, 30)];
    [self.next_button addTarget:self action:@selector(next_action_2:) forControlEvents:UIControlEventTouchUpInside];
    [self.next_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.next_button];
    
}

- (void)next_action_2:(id)sender{
    
    [self.instruction_screen_2 removeFromSuperview];
    [self.next_button removeFromSuperview];
    
    [self.startButton setUserInteractionEnabled:YES];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int launches = 1;
    
    [ud setObject:[NSNumber numberWithInt:launches] forKey:@"huntstarting_screen"];
    
}

- (void)checkSubscribedHunts
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:[KCSUser activeUser].email];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        if (errorOrNil != nil) {
            //An error happened, just log for now
//            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
            if (objectsOrNil.count) {
                NSLog(@"got unsubscribed hunts");
                
                YookaBackend *yooka = objectsOrNil[0];
                self.subscribedHunts = [NSMutableArray arrayWithArray:yooka.HuntNames];
                self.unsubscribedHunts = [NSMutableArray arrayWithArray:yooka.NotTriedHuntNames];
                
                UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(123, 520, 100, 20)];
                NSString *string5 = @"GET STARTED";
                if (string5) {
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string5];
                    float spacing = 1.4f;
                    [attributedString addAttribute:NSKernAttributeName
                                             value:@(spacing)
                                             range:NSMakeRange(0, [string5 length])];
                    shareLabel.attributedText = attributedString;
                }
                shareLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
                shareLabel.textColor = [self colorWithHexString:@"3ac0ec"];
                [self.view addSubview:shareLabel];
                
                self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.startButton  setFrame:CGRectMake(110, 505, 130, 50)];
                [self.startButton setBackgroundColor:[UIColor clearColor]];
                [self.startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.startButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15]];
                self.startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.view addSubview:self.startButton];
            } else {
                NSLog(@"got no subscribed hunts");
                
                if (self.featured_hunt_names.count) {
                    
                    NSLog(@"got featured hunts");

                    self.unsubscribedHunts = [NSMutableArray arrayWithArray:self.featured_hunt_names];
                    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(123, 520, 100, 20)];
                    NSString *string5 = @"GET STARTED";
                    if (string5) {
                        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string5];
                        float spacing = 1.4f;
                        [attributedString addAttribute:NSKernAttributeName
                                                 value:@(spacing)
                                                 range:NSMakeRange(0, [string5 length])];
                        shareLabel.attributedText = attributedString;
                    }
                    shareLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
                    shareLabel.textColor = [self colorWithHexString:@"3ac0ec"];
                    [self.view addSubview:shareLabel];
                    
                    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.startButton  setFrame:CGRectMake(110, 505, 130, 50)];
                    [self.startButton setBackgroundColor:[UIColor clearColor]];
                    [self.startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.startButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15]];
                    self.startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [self.view addSubview:self.startButton];
                    
                }else{
                    
                    NSLog(@"got no featured hunts");
                    [self getFeaturedHunts];
                    
                }
                
            }
            
        }
    } withProgressBlock:nil];
}

- (void)getFeaturedHunts
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"ListPopup" ofClass:[YookaBackend class]];
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
            //            NSLog(@"featured hunts = %@",objectsOrNil);
            self.featured_hunts = [NSMutableArray arrayWithArray:objectsOrNil];
            [self storeFeaturedHunts];
            //            [self checkSubscribedHunts];
            
        }
    } withProgressBlock:nil];
    
}

- (void)storeFeaturedHunts
{
    self.featured_hunt_names = [NSMutableArray new];
    _huntDict1 = [NSMutableDictionary new];
    _huntDict2 = [NSMutableDictionary new];
    _huntDict3 = [NSMutableDictionary new];
    _huntDict4 = [NSMutableDictionary new];
    _huntDict5 = [NSMutableDictionary new];
    _huntDict6 = [NSMutableDictionary new];
    _huntDict7 = [NSMutableDictionary new];
    _huntDict8 = [NSMutableDictionary new];
    _huntDict9 = [NSMutableDictionary new];
    _huntDict10 = [NSMutableDictionary new];
    _eatArray = [NSMutableArray new];
    _drinkArray = [NSMutableArray new];
    _playArray = [NSMutableArray new];
    _yookaArray = [NSMutableArray new];
    _eatDict = [NSMutableDictionary new];
    _drinkDict = [NSMutableDictionary new];
    _playDict = [NSMutableDictionary new];
    _yookaDict = [NSMutableDictionary new];
    
    NSLog(@"item = %@",self.featured_hunts);
    
    
    int q;
    for (q=0; q<self.featured_hunts.count; q++) {
        
        NSLog(@"number = %d",q);
        
        YookaBackend *yooka = self.featured_hunts[q];
        
        if(yooka.Name){
            [self.featured_hunt_names addObject:yooka.Name];
        }
        //        [_huntDict1 setObject:yooka.Description forKey:yooka.Name];
        if(yooka.Count){
            [_huntDict2 setObject:yooka.Count forKey:yooka.Name];
        }
        if(yooka.HuntLogoUrl){
            [_huntDict3 setObject:yooka.HuntLogoUrl forKey:yooka.Name];
        }
        //        [_huntDict4 setObject:yooka.huntPicsUrl forKey:yooka.Name];
        //        [_huntDict5 setObject:yooka.huntLocations forKey:yooka.Name];
        if(yooka.Name){
            [_huntDict6 setObject:yooka.huntPicUrl forKey:yooka.Name];
        }
        
        if ([yooka.Category isEqualToString:@"EAT"]) {
            
            [_eatArray addObject:yooka.Name];
            
        }else if ([yooka.Category isEqualToString:@"DRINK"]){
            
            [_drinkArray addObject:yooka.Name];
            
        }else if ([yooka.Category isEqualToString:@"PLAY"]){
            
            [_playArray addObject:yooka.Name];
            
        }else if ([yooka.Category isEqualToString:@"YOOKA"]){
            
            [_yookaArray addObject:yooka.Name];
            
        }else{
            
        }
        
    }
    
    NSLog(@"eat array = %@",self.eatArray);
    
    
    if (q==self.featured_hunts.count) {
        
        self.unsubscribedHunts = [NSMutableArray arrayWithArray:self.featured_hunt_names];
        
        UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(123, 520, 100, 20)];
        NSString *string5 = @"GET STARTED";
        if (string5) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string5];
            float spacing = 1.4f;
            [attributedString addAttribute:NSKernAttributeName
                                     value:@(spacing)
                                     range:NSMakeRange(0, [string5 length])];
            shareLabel.attributedText = attributedString;
        }
        shareLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
        shareLabel.textColor = [self colorWithHexString:@"3ac0ec"];
        [self.view addSubview:shareLabel];
        
        self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.startButton  setFrame:CGRectMake(110, 505, 130, 50)];
        [self.startButton setBackgroundColor:[UIColor clearColor]];
        [self.startButton addTarget:self action:@selector(startButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.startButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15]];
        self.startButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [self.view addSubview:self.startButton];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.featured_hunt_names forKey:@"featuredHuntNames"];
        [defaults setObject:_huntDict1 forKey:@"huntDescription"];
        [defaults setObject:_huntDict2 forKey:@"huntCount"];
        [defaults setObject:_huntDict3 forKey:@"huntLogoUrl"];
        [defaults setObject:_huntDict6 forKey:@"huntPicUrl"];
        [defaults setObject:_eatArray forKey:@"eatArray"];
        [defaults setObject:_drinkArray forKey:@"drinkArray"];
        [defaults setObject:_playArray forKey:@"playArray"];
        [defaults setObject:_yookaArray forKey:@"yookaArray"];
        [defaults synchronize];
        
    }
    
}

- (void)getUserPicUrl{
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.isOpen) {
        //        NSLog(@"Found a cached session");
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 //                      NSLog(@"username = %@",user.name);
                 //                      NSLog(@"user email = %@",[user objectForKey:@"email"]);
                 _userName = user.username;
                 _userFullName = user.name;
                 [self.navigationItem setTitle:[_userFullName uppercaseString]];
                 _userPicUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", _userName];
                 _userEmail = [user objectForKey:@"email"];
                 //                      NSLog(@"user pic url = %@",_userPicUrl);
                 [self getUserImage];
                 
                 
             }
         }];
        
        // If there's no cached session, we will show a login button
    } else {
        //        NSLog(@"Cannot found a cached session");
        _userEmail = [[KCSUser activeUser] email];
        _userFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
        [self.navigationItem setTitle:[_userFullName uppercaseString]];
        _collectionName1 = @"userPicture";
        _customEndpoint1 = @"NewsFeed";
        _fieldName1 = @"_id";
        _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
                
                NSArray *results_array = [NSArray arrayWithArray:results];
                
                if (results_array && results_array.count) {
                    
                    _userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                    [self getUserImage];
                    
                    
                }else{
                    
                    _userPicUrl = @"http://s25.postimg.org/4qq1lj6nj/minion.jpg";
                    [self getUserImage];
                    
                }
                
            }else{
                
                _userPicUrl = @"http://s25.postimg.org/4qq1lj6nj/minion.jpg";
                [self getUserImage];
                
            }
        }];
        
    }
    
}

- (void)getUserImage
{
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:_userPicUrl]
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
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:UIImagePNGRepresentation(image) forKey:@"MyProfilePic"];
             [defaults synchronize];
             
             [self.profileImageView setImage:image];
             //                            NSLog(@"profile image");
             
         }
     }];
}

- (void)startButtonClicked:(id)sender
{
    
    [self.startButton setEnabled:NO];
    
    // Capture author info &  user status
    NSDictionary *articleParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self.huntTitle, @"Hunt_Name",
                                   nil];
    
    [Flurry logEvent:@"Hunt_Started" withParameters:articleParams];
    
    [self.subscribedHunts addObject:_huntTitle];
    if ([self.unsubscribedHunts containsObject:self.huntTitle]) {
        [self.unsubscribedHunts removeObject:self.huntTitle];
    }
    
    if ([self.sponsored_hunt_names containsObject:self.huntTitle]) {
        [self.sponsored_hunt_names removeObject:self.huntTitle];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.sponsored_hunt_names forKey:@"sponsoredHunts"];
    }
    
    [self saveStartedHunt];
    [self savePostData];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    YookaHuntVenuesViewController* media = [[YookaHuntVenuesViewController alloc]init];
    media.huntTitle = _huntTitle;
    media.userEmail = self.myEmail;
    media.emailId = self.myEmail;
    media.userEmail = self.myEmail;
    media.subscribedHunts = self.subscribedHunts;
    media.unsubscribedHunts = self.unsubscribedHunts;
    [self presentViewController:media animated:NO completion:nil];
    
}

- (void)saveStartedHunt
{
    YookaBackend *yooka = [[YookaBackend alloc]init];
    yooka.kinveyId = _myEmail;
    yooka.userEmail = _myEmail;
    yooka.HuntNames = self.subscribedHunts;
    yooka.NotTriedHuntNames = self.unsubscribedHunts;
    yooka.public_hunts = self.subscribedHunts;
    [yooka.meta setGloballyReadable:YES];
    [yooka.meta setGloballyWritable:YES];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.subscribedHunts forKey:@"subscribedHuntNames"];
    [defaults setObject:self.unsubscribedHunts forKey:@"unsubscribedHuntNames"];
    NSMutableArray *sponsored_hunt_names = [[defaults objectForKey:@"sponsoredHunts"]mutableCopy];
    if ([sponsored_hunt_names containsObject:self.huntTitle]) {
        [sponsored_hunt_names removeObject:self.sponsored_hunt_name];
        [defaults setObject:sponsored_hunt_names forKey:@"sponsoredHunts"];
    }
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store saveObject:yooka withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
        } else {
            //save was successful
            NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
        }
    } withProgressBlock:nil];
}

- (void)savePostData
{
    
        YookaBackend *yookaObject = [[YookaBackend alloc]init];
    
        yookaObject.postDate = [NSDate date];
        yookaObject.userEmail = [KCSUser activeUser].email;
        yookaObject.userFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
        yookaObject.HuntName = _huntTitle;
        yookaObject.postType = @"started hunt";
        yookaObject.postCaption = [NSString stringWithFormat:@"%@ LIST", _huntTitle];
        yookaObject.huntPicUrl = self.huntPicUrl;
        yookaObject.yooka_private = @"NO";
        yookaObject.deleted = @"NO";

//        [yookaObject.meta setGloballyReadable:YES];
//        [yookaObject.meta setGloballyWritable:YES];
        
        //Kinvey use code: add a new update to the updates collection
        [self.updateStore saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            
            if (errorOrNil == nil) {
                
                NSLog(@"saved successfully");
                
            } else {
                
                BOOL wasNetworkError = [[errorOrNil domain] isEqual:KCSNetworkErrorDomain];
                NSString* title = wasNetworkError ? NSLocalizedString(@"There was a network error.", @"network error title"): NSLocalizedString(@"An error occurred.", @"Generic error message");
                NSString* message = wasNetworkError ? NSLocalizedString(@"Please wait a few minutes and try again.", @"try again error message") : [errorOrNil localizedDescription];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                message:message                                                           delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
        } withProgressBlock:nil];

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

- (void)dismissView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getFeaturedRestaurants
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"ListRestaurants" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:_huntTitle];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            
        } else {
            //got all events back from server -- update table view
//            NSLog(@"featured restaurant = %@",objectsOrNil);
            
            _featuredRestaurants = [NSArray arrayWithArray:objectsOrNil];
            [self makePicsScrollView];
            
        }
    } withProgressBlock:nil];
}

- (void)makePicsScrollView
{
    total_hunts = [_featuredRestaurants count];
    self.scrollView1.contentSize = CGSizeMake(self.scrollView1.frame.size.width * total_hunts, self.scrollView1.frame.size.height);
    i=0;
    [self fillPicScrollView];
    self.hunts_pages.numberOfPages = total_hunts;
    self.hunts_pages.currentPage = 0;
    
}

- (void)fillPicScrollView
{
    if (i<total_hunts) {
        
        new_page_frame = CGRectMake(i * 320, 0, 320, 250);
        self.FeaturedView = [[UIView alloc]initWithFrame:new_page_frame];
        
        YookaBackend *yooka = _featuredRestaurants[i];
        
        NSString *picUrl = yooka.popuppic;
        
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:picUrl done:^(UIImage *image, SDImageCacheType cacheType)
         {
             // image is not nil if image was found
             
             if (image) {
                 
                 self.bg_picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 250)];
                 [self.bg_picImageView setImage:image];
                 [self.FeaturedView addSubview:self.bg_picImageView];
                 if (i==0) {
                     
                     NSString *string3 = [yooka.Hood uppercaseString];
                     NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:string3];
                     float spacing3 = 1.5f;
                     [attributedString3 addAttribute:NSKernAttributeName
                                               value:@(spacing3)
                                               range:NSMakeRange(0, [string3 length])];
                     
                     self.nameLabel.attributedText = attributedString3;
                     
                 }
                 
                 [self.scrollView1 addSubview:self.FeaturedView];
                 
                 i++;
                 
                 [self fillPicScrollView];
                 
             }else{
                 
                 [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:picUrl]
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
                          [[SDImageCache sharedImageCache] storeImage:image forKey:picUrl];
                          
                          self.bg_picImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 250)];
                          [self.bg_picImageView setImage:image];
                          [self.FeaturedView addSubview:self.bg_picImageView];
                          
                          if (i==0) {
                              
                              
                              NSString *string3 = [yooka.Hood uppercaseString];
                              NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:string3];
                              float spacing3 = 1.5f;
                              [attributedString3 addAttribute:NSKernAttributeName
                                                        value:@(spacing3)
                                                        range:NSMakeRange(0, [string3 length])];
                              
                              self.nameLabel.attributedText = attributedString3;
                              
                              
                          }
                          
                          [self.scrollView1 addSubview:self.FeaturedView];
                          
                          i++;
                          
                          [self fillPicScrollView];
                      }
                  }];
                 
             }
         }];
        
    }
    
    [self resizeButton];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (scrollView == self.scrollView1) {
        
        self.hunts_pages.currentPage = page;
        
        if (page<_featuredRestaurants.count) {
            
            YookaBackend *yooka = _featuredRestaurants[page];
            
            NSString *string3 = [yooka.Hood uppercaseString];
            NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:string3];
            float spacing3 = 1.5f;
            [attributedString3 addAttribute:NSKernAttributeName
                                      value:@(spacing3)
                                      range:NSMakeRange(0, [string3 length])];
            
            self.nameLabel.attributedText = attributedString3;
            
        }
    }
    
}

- (void)resizeButton
{
    
//    _startButton.transform = CGAffineTransformMakeScale(0.9,0.9);
//    
//    [UIView animateWithDuration:1.1
//                          delay:3.0
//                        options:UIViewAnimationOptionAllowUserInteraction
//                     animations:^{ _startButton.transform = CGAffineTransformMakeScale(1.2,1.2);}
//                     completion:^(BOOL  completed){
//                         if (completed){
//                             _startButton.transform = CGAffineTransformMakeScale(1.2,1.2);
//                             
//                             [UIView animateWithDuration:1.1
//                                                   delay:0
//                                                 options:UIViewAnimationOptionAllowUserInteraction
//                                              animations:^{ _startButton.transform = CGAffineTransformMakeScale(0.9,0.9);}
//                                              completion:^(BOOL  completed){
//                                                  if (completed)
//                                                      [self resizeButton];
//                                              }];
//                         }
//                     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
