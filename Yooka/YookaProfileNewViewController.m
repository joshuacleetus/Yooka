//
//  YookaProfileNewViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 6/3/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaProfileNewViewController.h"
#import "UIImageView+WebCache.h"
#import "YookaBackend.h"
#import "NavigationViewController.h"
#import "MainViewController.h"
#import "YookaHuntVenuesViewController.h"
#import "UserFollowersViewController.h"
#import "UserFollowingViewController.h"
#import "YookaRestaurantViewController.h"
#import "YookaButton.h"
#import "UIImage+scale.h"
#import "UIImage+Crop.h"
#import "YookaFeaturedHuntViewController.h"
#import "LLACircularProgressView.h"
#import "Flurry.h"

const NSInteger yookaThumbnailWidth2014 = 145;
const NSInteger yookaThumbnailHeight2014 = 145;
const NSInteger yookaImagesPerRow2014 = 2;
const NSInteger yookaThumbnailSpace2014 = 10;
const NSInteger yookaThumbnailWidth2000 = 320;
const NSInteger yookaThumbnailHeight2000 = 340;
const NSInteger yookaImagesPerRow2000 = 1;
const NSInteger yookaThumbnailSpace2000 = 5;



@interface YookaProfileNewViewController ()
@property (nonatomic, strong) LLACircularProgressView *circularProgressView;

@end

@implementation YookaProfileNewViewController

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
    // Do any additional setup after loading the view.
    
    if (INTERFACE_IS_PHONE) {
        if (isiPhone5) {
            
            [self.view setBackgroundColor:[UIColor whiteColor]];
            
            self.huntDict1 = [NSMutableDictionary new];
            self.huntDict2 = [NSMutableDictionary new];
            self.huntDict3 = [NSMutableDictionary new];
            self.huntDict4 = [NSMutableDictionary new];
            self.huntDict5 = [NSMutableDictionary new];
            self.huntDict6 = [NSMutableDictionary new];
            self.finishedHuntVenues = [NSMutableDictionary new];
            self.cachesubscribedHuntNames = [NSMutableArray new];
            self.cacheUnSubscribedHuntNames = [NSMutableArray new];
            self.finishedHuntNames = [NSMutableArray new];
            self.inProgressHuntNames = [NSMutableArray new];
            self.thumbnails = [NSMutableArray new];
            self.thumbnails2 = [NSMutableArray new];
            self.thumbnails3 = [NSMutableArray new];
            self.inProgressHuntCounts = [NSMutableArray new];
            self.finishedHuntCounts = [NSMutableArray new];
            self.postLikers = [NSMutableArray new];
            self.likesData = [NSMutableArray new];
            self.likersData = [NSMutableArray new];
            self.imagesArray = [NSMutableArray new];
            
            i = 0;
            j = 0;
            j2 = 0;
            l = 0;
            m = 0;
            n = 0;
            p = 0;
            q = 0;
            row = 0, col = 0;
            row2 = 0, col2 = 0;
            row3 = 0, col3 = 0;
            contentSize = 340;
            contentSize2 = 340;
            contentSize3 = 35;
            maincontentSize = 285;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            self.huntDict1 = [defaults objectForKey:@"huntDescription"];
            self.huntDict2 = [defaults objectForKey:@"huntCount"];
            self.huntDict3 = [defaults objectForKey:@"huntLogoUrl"];
            self.huntDict4 = [defaults objectForKey:@"huntPicsUrl"];
            self.huntDict5 = [defaults objectForKey:@"huntLocations"];
            self.huntDict6 = [defaults objectForKey:@"huntPicUrl"];
            self.cachesubscribedHuntNames = [defaults objectForKey:@"subscribedHuntNames"];
            self.cacheUnSubscribedHuntNames = [defaults objectForKey:@"unsubscribedHuntNames"];
            
            self.userFullName = [NSString stringWithFormat:@"%@ %@",[[KCSUser activeUser].givenName uppercaseString],[[KCSUser activeUser].surname  uppercaseString]];
            self.myEmail = [KCSUser activeUser].email;
            
            KCSCollection* collection = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
            self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyResource : collection, KCSStoreKeyCachePolicy : @(KCSCachePolicyBoth), KCSStoreKeyOfflineUpdateEnabled : @YES }];
            
            CGRect screenRect5 = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            self.gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect5];
            self.gridScrollView.contentSize= self.view.bounds.size;
            self.gridScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            [self.view addSubview:self.gridScrollView];
            
            CGRect screenRect4 = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            
            self.profileScrollView=[[UIScrollView alloc] initWithFrame:screenRect4];
            self.profileScrollView.contentSize= self.view.bounds.size;
            self.profileScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            [self.view addSubview:self.profileScrollView];
            [self.profileScrollView setBackgroundColor:[UIColor clearColor]];
            
            self.feedScrollView = [[UIScrollView alloc] initWithFrame:screenRect4];
            self.feedScrollView.contentSize= self.view.bounds.size;
            self.feedScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            [self.view addSubview:self.feedScrollView];
            [self.feedScrollView setBackgroundColor:[UIColor whiteColor]];
            
            [self.feedScrollView setHidden:YES];

            UIImageView *bg_color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 278)];
            [bg_color setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.profileScrollView addSubview:bg_color];
            
            UIImageView *bg_color_3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 278)];
            [bg_color_3 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.feedScrollView addSubview:bg_color_3];
            
            //set profile image background color here.
            self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 320, 220)];
//            [self.bgImageView setBackgroundColor:[self colorWithHexString:(@"fb604e")]];
            [self.profileScrollView addSubview:self.bgImageView];
            
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.textColor = [UIColor whiteColor];
            NSString *string5 = @"ME";
            NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:string5];
            float spacing5 = 1.5f;
            [attributedString5 addAttribute:NSKernAttributeName
                                      value:@(spacing5)
                                      range:NSMakeRange(0, [string5 length])];
            self.titleLabel.attributedText = attributedString5;
            self.titleLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
            [self.profileScrollView addSubview:self.titleLabel];
            
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
            label3.textAlignment = NSTextAlignmentCenter;
            label3.textColor = [UIColor whiteColor];
            label3.attributedText = attributedString5;
            label3.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
            [self.feedScrollView addSubview:label3];
            
            self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(111, 75, 100, 100)];
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
            [self.profileImageView.layer setBorderWidth:4.0];
            [self.profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
            [self.profileImageView setClipsToBounds:YES];
            [self.profileScrollView addSubview:self.profileImageView];
            
            self.profileImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(111, 75, 100, 100)];
            self.profileImageView3.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
            [self.profileImageView3.layer setBorderWidth:4.0];
            [self.profileImageView3.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [self.profileImageView3 setContentMode:UIViewContentModeScaleAspectFill];
            [self.profileImageView3 setClipsToBounds:YES];
            [self.feedScrollView addSubview:self.profileImageView3];
            
            // check if image is already cached in userdefaults.
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSData* imageData = [ud objectForKey:@"MyProfilePic"];
            UIImage *image = [UIImage imageWithData:imageData];
            
//            UIImage *image2 = [image scaleToSize:CGSizeMake(100, 100)];
            
            if (image) {
                
                [self.profileImageView setImage:image];
                [self.profileImageView3 setImage:image];
                
            }else{
                
                [self getUserPicUrl];
                
            }
            
            self.pickImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.pickImageBtn setFrame:CGRectMake(111, 65, 100, 100)];
            [self.pickImageBtn setTitle:nil forState:UIControlStateNormal];
            [self.pickImageBtn setBackgroundColor:[UIColor clearColor]];
            [self.pickImageBtn addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
//            [self.profileScrollView addSubview:self.pickImageBtn];
            
            self.profileLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10, 190, 300, 20)];
            self.profileLabel.textAlignment = NSTextAlignmentCenter;
            self.profileLabel.textColor = [UIColor whiteColor];
            self.profileLabel.text = [_userFullName uppercaseString];
            self.profileLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:16.0];
            [self.profileLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileLabel setAdjustsFontSizeToFitWidth:YES];
            [self.profileScrollView addSubview:self.profileLabel];
            
            self.profileLabel3 = [[UILabel alloc]initWithFrame:CGRectMake( 10, 190, 300, 20)];
            self.profileLabel3.textAlignment = NSTextAlignmentCenter;
            self.profileLabel3.textColor = [UIColor whiteColor];
            self.profileLabel3.text = [_userFullName uppercaseString];
            self.profileLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:16.0];
            [self.profileLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.profileLabel3 setAdjustsFontSizeToFitWidth:YES];
            [self.feedScrollView addSubview:self.profileLabel3];
            
            self.settingsImage = [[UIImageView alloc]initWithFrame:CGRectMake(105, 200, 25, 25)];
            [self.settingsImage setImage:[UIImage imageNamed:@"edit_profile.png"]];
            //[self.profileScrollView addSubview:self.settingsImage];
            
            self.editLabel = [[UILabel alloc]initWithFrame:CGRectMake(123, 200, 100, 25)];
            self.editLabel.textAlignment = NSTextAlignmentCenter;
            self.editLabel.textColor = [UIColor whiteColor];
            self.editLabel.text = @"EDIT PROFILE";
            self.editLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0];
            [self.editLabel setBackgroundColor:[UIColor clearColor]];
           // [self.profileScrollView addSubview:self.editLabel];
            
            self.listCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, 107, 25)];
            self.listCountLabel.textAlignment = NSTextAlignmentCenter;
            self.listCountLabel.textColor = [UIColor whiteColor];
            self.listCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.listCountLabel setBackgroundColor:[UIColor clearColor]];
            NSString *count_string = [NSString stringWithFormat:@"%lu",(unsigned long)self.cachesubscribedHuntNames.count];
            [self.listCountLabel setText:count_string];
            [self.profileScrollView addSubview:self.listCountLabel];
            
            self.listLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, 107, 25)];
            self.listLabel.textAlignment = NSTextAlignmentCenter;
            self.listLabel.textColor = [UIColor whiteColor];
            self.listLabel.text = @"LISTS";
            self.listLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:9.5];
            [self.listLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.listLabel];
            
            self.followersCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, 230, 107, 25)];
            self.followersCountLabel.textAlignment = NSTextAlignmentCenter;
            self.followersCountLabel.textColor = [UIColor whiteColor];
            self.followersCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.followersCountLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.followersCountLabel];
            
            self.followersLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, 250, 107, 25)];
            self.followersLabel.textAlignment = NSTextAlignmentCenter;
            self.followersLabel.textColor = [UIColor whiteColor];
            self.followersLabel.text = @"FOLLOWERS";
            self.followersLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:9.5];
            [self.followersLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.followersLabel];
            
            [self getFollowerUsers];
            
            self.followingCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 230, 107, 25)];
            self.followingCountLabel.textAlignment = NSTextAlignmentCenter;
            self.followingCountLabel.textColor = [UIColor whiteColor];
            self.followingCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.followingCountLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.followingCountLabel];
            
            self.followingLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 250, 107, 25)];
            self.followingLabel.textAlignment = NSTextAlignmentCenter;
            self.followingLabel.textColor = [UIColor whiteColor];
            self.followingLabel.text = @"FOLLOWING";
            self.followingLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:9.5];
            [self.followingLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.followingLabel];
            
            [self getFollowingUsers];
            
            self.listCountLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, 107, 25)];
            self.listCountLabel3.textAlignment = NSTextAlignmentCenter;
            self.listCountLabel3.textColor = [UIColor whiteColor];
            self.listCountLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.listCountLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.listCountLabel3 setText:count_string];
            [self.feedScrollView addSubview:self.listCountLabel3];
            
            self.listLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, 107, 25)];
            self.listLabel3.textAlignment = NSTextAlignmentCenter;
            self.listLabel3.textColor = [UIColor whiteColor];
            self.listLabel3.text = @"LISTS";
            self.listLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:9.5];
            [self.listLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedScrollView addSubview:self.listLabel3];
            
            self.followersCountLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(107, 230, 107, 25)];
            self.followersCountLabel3.textAlignment = NSTextAlignmentCenter;
            self.followersCountLabel3.textColor = [UIColor whiteColor];
            self.followersCountLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.followersCountLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedScrollView addSubview:self.followersCountLabel3];
            
            self.followersLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(107, 250, 107, 25)];
            self.followersLabel3.textAlignment = NSTextAlignmentCenter;
            self.followersLabel3.textColor = [UIColor whiteColor];
            self.followersLabel3.text = @"FOLLOWERS";
            self.followersLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:9.5];
            [self.followersLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedScrollView addSubview:self.followersLabel3];
            
            self.followingCountLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(215, 230, 107, 25)];
            self.followingCountLabel3.textAlignment = NSTextAlignmentCenter;
            self.followingCountLabel3.textColor = [UIColor whiteColor];
            self.followingCountLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.followingCountLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedScrollView addSubview:self.followingCountLabel3];
            
            self.followingLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(215, 250, 107, 25)];
            self.followingLabel3.textAlignment = NSTextAlignmentCenter;
            self.followingLabel3.textColor = [UIColor whiteColor];
            self.followingLabel3.text = @"FOLLOWING";
            self.followingLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:9.5];
            [self.followingLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedScrollView addSubview:self.followingLabel3];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 278, 320, 1)];
            lineView.backgroundColor = [UIColor whiteColor];
            [self.profileScrollView addSubview:lineView];
            
            self.progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 320, self.view.frame.size.height)];
            [self.progressView setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.progressView];
            
            self.completedView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 320, self.view.frame.size.height)];
            [self.completedView setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.completedView];
            
            //new changes here
            
            self.feedView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 300, self.view.frame.size.height)];
            [self.feedView setBackgroundColor:[UIColor clearColor]];
            [self.feedView setUserInteractionEnabled:YES];
            [self.feedScrollView addSubview:self.feedView];
            
            [self.feedScrollView setHidden:YES];
            [self.feedView setHidden:YES];
            [self.completedView setHidden:YES];
            
            UIImageView *blue_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21.70, 320, 56)];
            [blue_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.progressView addSubview:blue_bg];
            
            UIImageView *highlighted_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21.70, 107, 56)];
            highlighted_bg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.10f];
            [self.progressView addSubview:highlighted_bg];
            
            self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, 107, 20)];
            self.progressLabel.textColor = [UIColor whiteColor];
            self.progressLabel.textAlignment = NSTextAlignmentCenter;
            self.progressLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            NSString *string = @"PROGRESS";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            float spacing = 1.25f;
            [attributedString addAttribute:NSKernAttributeName
                                     value:@(spacing)
                                     range:NSMakeRange(0, [string length])];
            
            self.progressLabel.attributedText = attributedString;
            [self.progressLabel setBackgroundColor:[UIColor clearColor]];
            [self.progressView addSubview:self.progressLabel];
            
            self.completedLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, -5, 107, 20)];
            self.completedLabel.textColor = [UIColor whiteColor];
            self.completedLabel.textAlignment = NSTextAlignmentCenter;
            self.completedLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            NSString *string2 = @"COMPLETED";
            NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:string2];
            float spacing2 = 1.25f;
            [attributedString2 addAttribute:NSKernAttributeName
                                      value:@(spacing2)
                                      range:NSMakeRange(0, [string2 length])];
            
            self.completedLabel.attributedText = attributedString2;
            [self.completedLabel setBackgroundColor:[UIColor clearColor]];
            [self.progressView addSubview:self.completedLabel];
            
            UIImageView *blue_bg_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21.70, 320, 56)];
            [blue_bg_2 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.completedView addSubview:blue_bg_2];
            
            UILabel *progressLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, 107, 20)];
            progressLabel2.textColor = [UIColor whiteColor];
            progressLabel2.textAlignment = NSTextAlignmentCenter;
            progressLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            progressLabel2.attributedText = attributedString;
            [progressLabel2 setBackgroundColor:[UIColor clearColor]];
            [self.completedView addSubview:progressLabel2];
            
            UIImageView *highlighted_bg_2 = [[UIImageView alloc]initWithFrame:CGRectMake(108, -21.70, 106, 56)];
            highlighted_bg_2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.10f];
            [self.completedView addSubview:highlighted_bg_2];
            
            UILabel *completedLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(107, -5, 107, 20)];
            completedLabel2.textColor = [UIColor whiteColor];
            completedLabel2.textAlignment = NSTextAlignmentCenter;
            completedLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            completedLabel2.attributedText = attributedString2;
            [completedLabel2 setBackgroundColor:[UIColor clearColor]];
            [self.completedView addSubview:completedLabel2];
            
            self.feedLabel = [[UILabel alloc]initWithFrame:CGRectMake(214, -5, 107, 20)];
            self.feedLabel.textColor = [UIColor whiteColor];
            self.feedLabel.textAlignment = NSTextAlignmentCenter;
            self.feedLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            NSString *string3 = @"NEWSFEED";
            NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:string3];
            float spacing3 = 1.25f;
            [attributedString3 addAttribute:NSKernAttributeName
                                      value:@(spacing3)
                                      range:NSMakeRange(0, [string3 length])];
            
            self.feedLabel.attributedText = attributedString3;
            [self.feedLabel setBackgroundColor:[UIColor clearColor]];
            [self.progressView addSubview:self.feedLabel];
            
            UILabel *feedLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(214, -5, 107, 20)];
            feedLabel2.textColor = [UIColor whiteColor];
            feedLabel2.textAlignment = NSTextAlignmentCenter;
            feedLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            feedLabel2.attributedText = attributedString3;
            [feedLabel2 setBackgroundColor:[UIColor clearColor]];
            [self.completedView addSubview:feedLabel2];
            
            UIImageView *blue_bg_3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21.70, 320, 56)];
            [blue_bg_3 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.feedView addSubview:blue_bg_3];
            
            UIImageView *highlighted_bg_3 = [[UIImageView alloc]initWithFrame:CGRectMake(215, -21.70, 107, 56)];
            highlighted_bg_3.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.10f];
            [self.feedView addSubview:highlighted_bg_3];
            
            UILabel *progressLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, 107, 20)];
            progressLabel3.textColor = [UIColor whiteColor];
            progressLabel3.textAlignment = NSTextAlignmentCenter;
            progressLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            progressLabel3.attributedText = attributedString;
            [progressLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedView addSubview:progressLabel3];
            
            UILabel *feedLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(214, -5, 107, 20)];
            feedLabel3.textColor = [UIColor whiteColor];
            feedLabel3.textAlignment = NSTextAlignmentCenter;
            feedLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            feedLabel3.attributedText = attributedString3;
            [feedLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedView addSubview:feedLabel3];
            
            UILabel *completedLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(107, -5, 107, 20)];
            completedLabel3.textColor = [UIColor whiteColor];
            completedLabel3.textAlignment = NSTextAlignmentCenter;
            completedLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            completedLabel3.attributedText = attributedString2;
            [completedLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedView addSubview:completedLabel3];
            
            self.progressButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.progressButton  setFrame:CGRectMake(5, 280, 100, 55)];
            [self.progressButton setBackgroundColor:[UIColor clearColor]];
            [self.progressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.progressButton addTarget:self action:@selector(progressButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.progressButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
            self.progressButton.tag = 1;
            self.progressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.profileScrollView addSubview:self.progressButton];
            
            self.completedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.completedButton  setFrame:CGRectMake(110, 280, 100, 55)];
            [self.completedButton setBackgroundColor:[UIColor clearColor]];
            [self.completedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.completedButton addTarget:self action:@selector(completedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.completedButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
            self.completedButton.tag = 1;
            self.completedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.profileScrollView addSubview:self.completedButton];
            
            self.feedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.feedButton  setFrame:CGRectMake(216, 280, 100, 55)];
            [self.feedButton setBackgroundColor:[UIColor clearColor]];
            [self.feedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.feedButton addTarget:self action:@selector(feedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
            self.feedButton.tag = 1;
            self.feedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.profileScrollView addSubview:self.feedButton];
            
            UIButton *progressButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [progressButton3  setFrame:CGRectMake(5, 280, 100, 55)];
            [progressButton3 setBackgroundColor:[UIColor clearColor]];
            [progressButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [progressButton3 addTarget:self action:@selector(progressButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [progressButton3.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
            progressButton3.tag = 1;
            progressButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.feedScrollView addSubview:progressButton3];
            
            UIButton *completedButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [completedButton3  setFrame:CGRectMake(110, 280, 100, 55)];
            [completedButton3 setBackgroundColor:[UIColor clearColor]];
            [completedButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [completedButton3 addTarget:self action:@selector(completedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [completedButton3.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
            completedButton3.tag = 1;
            completedButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.feedScrollView addSubview:completedButton3];
            
            UIButton *feedButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [feedButton3  setFrame:CGRectMake(216, 280, 100, 55)];
            [feedButton3 setBackgroundColor:[UIColor clearColor]];
            [feedButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [feedButton3 addTarget:self action:@selector(feedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [feedButton3.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
            feedButton3.tag = 1;
            feedButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.feedScrollView addSubview:feedButton3];
            
            self.finishedHuntVenues = [defaults objectForKey:@"finishedHuntVenues"];
            self.inProgressHuntNames = [defaults objectForKey:@"inProgressHuntNames"];
            self.finishedHuntNames = [defaults objectForKey:@"finishedHuntNames"];
            self.inProgressHuntCounts = [defaults objectForKey:@"inProgressHuntCounts"];
            self.finishedHuntCounts = [defaults objectForKey:@"finishedHuntCounts"];
            
            self.finishedHuntVenues = [NSMutableDictionary new];
            self.inProgressHuntNames = [NSMutableArray new];
            self.finishedHuntNames = [NSMutableArray new];
            self.inProgressHuntCounts = [NSMutableArray new];
            self.finishedHuntCounts = [NSMutableArray new];
            
            if (self.cachesubscribedHuntNames.count) {
                [self getMyHuntCounts];
            }else{
                
                UIImageView *pin = [[UIImageView alloc]initWithFrame:CGRectMake(138, 60, 50, 60)];
                pin.backgroundColor=[UIColor clearColor];
                pin.image = [UIImage imageNamed:@"pin_blue_hole.png"];
                [self.progressView addSubview:pin];
                
                UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, 320, 20)];
                label1.textColor = [self colorWithHexString:@"c7c7c7"];
                label1.textAlignment = NSTextAlignmentCenter;
                label1.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:24.0];
                NSString *string = @"READY TO EXPLORE?";
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                float spacing = 1.25f;
                [attributedString addAttribute:NSKernAttributeName
                                         value:@(spacing)
                                         range:NSMakeRange(0, [string length])];
                
                label1.attributedText = attributedString;
                [label1 setBackgroundColor:[UIColor clearColor]];
                [self.progressView addSubview:label1];
                
                UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 150, 320, 20)];
                label2.textColor = [self colorWithHexString:@"c7c7c7"];
                label2.textAlignment = NSTextAlignmentCenter;
                label2.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
                NSString *string2 = @"START YOUR JOURNEY NOW";
                NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:string2];
                float spacing2 = 1.25f;
                [attributedString2 addAttribute:NSKernAttributeName
                                         value:@(spacing2)
                                         range:NSMakeRange(0, [string2 length])];
                
                label2.attributedText = attributedString2;
                [label2 setBackgroundColor:[UIColor clearColor]];
                [self.progressView addSubview:label2];
                
                UIImageView *blue_bottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, 208, 320, 60)];
                [blue_bottom setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
                [self.progressView addSubview:blue_bottom];
                
                UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 218, 320, 40)];
                label3.textColor = [UIColor whiteColor];
                label3.textAlignment = NSTextAlignmentCenter;
                label3.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
                NSString *string3 = @"GET STARTED";
                NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:string3];
                float spacing3 = 1.25f;
                [attributedString3 addAttribute:NSKernAttributeName
                                          value:@(spacing3)
                                          range:NSMakeRange(0, [string3 length])];
                label3.attributedText = attributedString3;
                [label3 setBackgroundColor:[UIColor clearColor]];
                [self.progressView addSubview:label3];
                
                UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(200, 214, 35, 40)];
                arrow.backgroundColor=[UIColor clearColor];
                arrow.image = [UIImage imageNamed:@"arrow_white.png"];
                [self.progressView addSubview:arrow];
                
                UIButton *get_started_button = [UIButton buttonWithType:UIButtonTypeCustom];
                [get_started_button setFrame:CGRectMake(0, 208, 320, 60)];
                [get_started_button setBackgroundColor:[UIColor clearColor]];
                [get_started_button addTarget:self action:@selector(gotoHome:) forControlEvents:UIControlEventTouchUpInside];
                [self.progressView addSubview:get_started_button];
                
                UIImageView *check = [[UIImageView alloc]initWithFrame:CGRectMake(43, -20, 230, 230)];
                check.backgroundColor=[UIColor clearColor];
                check.image = [UIImage imageNamed:@"medal-.png"];
                [self.completedView addSubview:check];
                
                UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, 320, 20)];
                label11.textColor = [self colorWithHexString:@"c7c7c7"];
                label11.textAlignment = NSTextAlignmentCenter;
                label11.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:24.0];
                NSString *string11 = @"FINISHED YET?";
                NSMutableAttributedString *attributedString11 = [[NSMutableAttributedString alloc] initWithString:string11];
                float spacing11 = 2.f;
                [attributedString11 addAttribute:NSKernAttributeName
                                         value:@(spacing11)
                                         range:NSMakeRange(0, [string11 length])];
                label11.attributedText = attributedString11;
                [label11 setBackgroundColor:[UIColor clearColor]];
                [self.completedView addSubview:label11];
                
                UILabel *label12 = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, 320, 20)];
                label12.textColor = [self colorWithHexString:@"c7c7c7"];
                label12.textAlignment = NSTextAlignmentCenter;
                label12.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
                NSString *string12 = @"ALL COMPLETED LIST GO HERE";
                NSMutableAttributedString *attributedString12 = [[NSMutableAttributedString alloc] initWithString:string12];
                float spacing12 = 1.25f;
                [attributedString12 addAttribute:NSKernAttributeName
                                          value:@(spacing12)
                                          range:NSMakeRange(0, [string12 length])];
                label12.attributedText = attributedString12;
                [label12 setBackgroundColor:[UIColor clearColor]];
                [self.completedView addSubview:label12];
                
                UIImageView *blue_bottom_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 208, 320, 60)];
                [blue_bottom_2 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
                [self.completedView addSubview:blue_bottom_2];
                
                UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 218, 320, 40)];
                label4.textColor = [UIColor whiteColor];
                label4.textAlignment = NSTextAlignmentCenter;
                label4.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
                NSString *string4 = @"GET STARTED";
                NSMutableAttributedString *attributedString4 = [[NSMutableAttributedString alloc] initWithString:string4];
                float spacing4 = 1.25f;
                [attributedString4 addAttribute:NSKernAttributeName
                                          value:@(spacing4)
                                          range:NSMakeRange(0, [string4 length])];
                label4.attributedText = attributedString4;
                [label4 setBackgroundColor:[UIColor clearColor]];
                [self.completedView addSubview:label4];
                
                UIImageView *arrow2 = [[UIImageView alloc]initWithFrame:CGRectMake(200, 214, 35, 40)];
                arrow2.backgroundColor=[UIColor clearColor];
                arrow2.image = [UIImage imageNamed:@"arrow_white.png"];
                [self.completedView addSubview:arrow2];
                
                UIButton *get_started_button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [get_started_button_2 setFrame:CGRectMake(0, 208, 320, 60)];
                [get_started_button_2 setBackgroundColor:[UIColor clearColor]];
                [get_started_button_2 addTarget:self action:@selector(gotoHome:) forControlEvents:UIControlEventTouchUpInside];
                [self.completedView addSubview:get_started_button_2];
            }
            
            UIImageView *camera = [[UIImageView alloc]initWithFrame:CGRectMake(143, 70, 40, 40)];
            camera.backgroundColor=[UIColor clearColor];
            camera.image = [UIImage imageNamed:@"map_camera.png"];
            [self.feedView addSubview:camera];
            
            UILabel *label21 = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, 320, 20)];
            label21.textColor = [self colorWithHexString:@"c7c7c7"];
            label21.textAlignment = NSTextAlignmentCenter;
            label21.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:16.0];
            NSString *string21 = @"SHARE YOUR EXPERIENCE";
            NSMutableAttributedString *attributedString21 = [[NSMutableAttributedString alloc] initWithString:string21];
            float spacing21 = 1.75f;
            [attributedString21 addAttribute:NSKernAttributeName
                                       value:@(spacing21)
                                       range:NSMakeRange(0, [string21 length])];
            label21.attributedText = attributedString21;
            [label21 setBackgroundColor:[UIColor clearColor]];
            [self.feedView addSubview:label21];
            
            UILabel *label22 = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, 320, 20)];
            label22.textColor = [self colorWithHexString:@"c7c7c7"];
            label22.textAlignment = NSTextAlignmentCenter;
            label22.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
            NSString *string22 = @"TAKE A PICTURE.TELL US WHAT YOU THINK !";
            NSMutableAttributedString *attributedString22 = [[NSMutableAttributedString alloc] initWithString:string22];
            float spacing22 = 1.f;
            [attributedString22 addAttribute:NSKernAttributeName
                                       value:@(spacing22)
                                       range:NSMakeRange(0, [string22 length])];
            label22.attributedText = attributedString22;
            [label22 setBackgroundColor:[UIColor clearColor]];
            [self.feedView addSubview:label22];
            
            UIImageView *blue_bottom_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 208, 320, 60)];
            [blue_bottom_2 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.feedView addSubview:blue_bottom_2];
            
            UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 218, 320, 40)];
            label5.textColor = [UIColor whiteColor];
            label5.textAlignment = NSTextAlignmentCenter;
            label5.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
            NSString *string14 = @"GET STARTED";
            NSMutableAttributedString *attributedString14 = [[NSMutableAttributedString alloc] initWithString:string14];
            float spacing14 = 1.25f;
            [attributedString14 addAttribute:NSKernAttributeName
                                      value:@(spacing14)
                                      range:NSMakeRange(0, [string14 length])];
            label5.attributedText = attributedString14;
            [label5 setBackgroundColor:[UIColor clearColor]];
            [self.feedView addSubview:label5];
            
            UIImageView *arrow2 = [[UIImageView alloc]initWithFrame:CGRectMake(200, 214, 35, 40)];
            arrow2.backgroundColor=[UIColor clearColor];
            arrow2.image = [UIImage imageNamed:@"arrow_white.png"];
            [self.feedView addSubview:arrow2];
            
            UIButton *get_started_button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [get_started_button_2 setFrame:CGRectMake(0, 208, 320, 60)];
            [get_started_button_2 setBackgroundColor:[UIColor clearColor]];
            [get_started_button_2 addTarget:self action:@selector(gotoHome:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedView addSubview:get_started_button_2];
            
//            [self getMyNewsFeed];
            
            if(self.presentingViewController.presentedViewController == self) {

                self.backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, 30, 30)];
                self.backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
                [self.profileScrollView addSubview:self.backBtnImage];
                
                self.backBtnImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, 30, 30)];
                self.backBtnImage3.image = [UIImage imageNamed:@"back_artisse_2.png"];
                [self.feedScrollView addSubview:self.backBtnImage3];

                self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.backBtn setFrame:CGRectMake(10, 20, 40, 40)];
                [self.backBtn setTitle:@"" forState:UIControlStateNormal];
                [self.backBtn setBackgroundColor:[UIColor clearColor]];
                //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
                [self.profileScrollView addSubview:self.backBtn];
                
                self.backBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.backBtn3 setFrame:CGRectMake(10, 20, 40, 40)];
                [self.backBtn3 setTitle:@"" forState:UIControlStateNormal];
                [self.backBtn3 setBackgroundColor:[UIColor clearColor]];
                //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [self.backBtn3 addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
                [self.feedScrollView addSubview:self.backBtn3];

            }else{

                self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton3  setFrame:CGRectMake(0, 0, 60, 70)];
                [self.navButton3 setBackgroundColor:[UIColor clearColor]];
                [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton3.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
                self.navButton3.tag = 1;
                self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.profileScrollView addSubview:self.navButton3];
                
                self.navButton3c = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton3c  setFrame:CGRectMake(0, 0, 60, 70)];
                [self.navButton3c setBackgroundColor:[UIColor clearColor]];
                [self.navButton3c setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton3c addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton3c.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
                self.navButton3c.tag = 1;
                self.navButton3c.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.feedScrollView addSubview:self.navButton3c];
                
                self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton  setFrame:CGRectMake(10, 27, 25, 18)];
                [self.navButton setBackgroundColor:[UIColor clearColor]];
                [self.navButton setBackgroundImage:[[UIImage imageNamed:@"white_menu.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
                [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
                self.navButton.tag = 1;
                self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.profileScrollView addSubview:self.navButton];
                
                self.navButtonc = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButtonc  setFrame:CGRectMake(10, 27, 25, 18)];
                [self.navButtonc setBackgroundColor:[UIColor clearColor]];
                [self.navButtonc setBackgroundImage:[[UIImage imageNamed:@"white_menu.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
                [self.navButtonc setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButtonc addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButtonc.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
                self.navButtonc.tag = 1;
                self.navButtonc.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.feedScrollView addSubview:self.navButtonc];
                
                self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton2  setFrame:CGRectMake(0, 63, 60, 520)];
                [self.navButton2 setBackgroundColor:[UIColor clearColor]];
                [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton2.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
                self.navButton2.tag = 0;
                self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.profileScrollView addSubview:self.navButton2];
                
                self.navButton2c = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton2c  setFrame:CGRectMake(0, 63, 60, 520)];
                [self.navButton2c setBackgroundColor:[UIColor clearColor]];
                [self.navButton2c setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton2c addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton2c.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
                self.navButton2c.tag = 0;
                self.navButton2c.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.feedScrollView addSubview:self.navButton2c];
                
                [self.navButton2 setHidden:YES];
                [self.navButton2c setHidden:YES];

            }
            
            // Get ready for swipes
            [self setupGestures];
            
        }else{
            
            [self.view setBackgroundColor:[UIColor whiteColor]];
            
            self.huntDict1 = [NSMutableDictionary new];
            self.huntDict2 = [NSMutableDictionary new];
            self.huntDict3 = [NSMutableDictionary new];
            self.huntDict4 = [NSMutableDictionary new];
            self.huntDict5 = [NSMutableDictionary new];
            self.huntDict6 = [NSMutableDictionary new];
            self.finishedHuntVenues = [NSMutableDictionary new];
            self.cachesubscribedHuntNames = [NSMutableArray new];
            self.cacheUnSubscribedHuntNames = [NSMutableArray new];
            self.finishedHuntNames = [NSMutableArray new];
            self.inProgressHuntNames = [NSMutableArray new];
            self.thumbnails = [NSMutableArray new];
            self.thumbnails2 = [NSMutableArray new];
            self.thumbnails3 = [NSMutableArray new];
            self.inProgressHuntCounts = [NSMutableArray new];
            self.finishedHuntCounts = [NSMutableArray new];
            self.postLikers = [NSMutableArray new];
            self.likesData = [NSMutableArray new];
            self.likersData = [NSMutableArray new];
            self.imagesArray = [NSMutableArray new];
            
            i = 0;
            j = 0;
            j2 = 0;
            l = 0;
            m = 0;
            n = 0;
            p = 0;
            q = 0;
            row = 0, col = 0;
            row2 = 0, col2 = 0;
            row3 = 0, col3 = 0;
            contentSize = 340;
            contentSize2 = 340;
            contentSize3 = 30;
            maincontentSize = 285;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            self.huntDict1 = [defaults objectForKey:@"huntDescription"];
            self.huntDict2 = [defaults objectForKey:@"huntCount"];
            self.huntDict3 = [defaults objectForKey:@"huntLogoUrl"];
            self.huntDict4 = [defaults objectForKey:@"huntPicsUrl"];
            self.huntDict5 = [defaults objectForKey:@"huntLocations"];
            self.huntDict6 = [defaults objectForKey:@"huntPicUrl"];
            self.cachesubscribedHuntNames = [defaults objectForKey:@"subscribedHuntNames"];
            self.cacheUnSubscribedHuntNames = [defaults objectForKey:@"unsubscribedHuntNames"];
            
            self.userFullName = [NSString stringWithFormat:@"%@ %@",[[KCSUser activeUser].givenName uppercaseString],[[KCSUser activeUser].surname  uppercaseString]];
            self.myEmail = [KCSUser activeUser].email;
            
            KCSCollection* collection = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
            self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyResource : collection, KCSStoreKeyCachePolicy : @(KCSCachePolicyBoth), KCSStoreKeyOfflineUpdateEnabled : @YES }];
            
            CGRect screenRect5 = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            self.gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect5];
            self.gridScrollView.contentSize= self.view.bounds.size;
            self.gridScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            [self.view addSubview:self.gridScrollView];
            
            CGRect screenRect4 = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            
            self.profileScrollView=[[UIScrollView alloc] initWithFrame:screenRect4];
            self.profileScrollView.contentSize= self.view.bounds.size;
            self.profileScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            [self.view addSubview:self.profileScrollView];
            [self.profileScrollView setBackgroundColor:[UIColor clearColor]];
            
            UIImageView *bg_color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 278)];
            [bg_color setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.profileScrollView addSubview:bg_color];
            
            //set profile image background color here.
            self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 320, 220)];
            //            [self.bgImageView setBackgroundColor:[self colorWithHexString:(@"fb604e")]];
            [self.profileScrollView addSubview:self.bgImageView];
            
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.textColor = [UIColor whiteColor];
            NSString *string5 = @"ME";
            NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:string5];
            float spacing5 = 1.5f;
            [attributedString5 addAttribute:NSKernAttributeName
                                      value:@(spacing5)
                                      range:NSMakeRange(0, [string5 length])];
            
            self.titleLabel.attributedText = attributedString5;
            self.titleLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
            [self.profileScrollView addSubview:self.titleLabel];
            
            self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(111, 75, 100, 100)];
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
            [self.profileImageView.layer setBorderWidth:4.0];
            [self.profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [self.profileImageView setContentMode:UIViewContentModeScaleAspectFit];
            [self.profileImageView setClipsToBounds:YES];
            [self.profileScrollView addSubview:self.profileImageView];
            
            // check if image is already cached in userdefaults.
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSData* imageData = [ud objectForKey:@"MyProfilePic"];
            UIImage *image = [UIImage imageWithData:imageData];
            
            UIImage *image2 = [image scaleToSize:CGSizeMake(100, 100)];
            
            if (image) {
                
                [self.profileImageView setImage:image2];
                
            }else{
                
                [self getUserPicUrl];
                
            }
            //            self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 100, 100, 100)];
            //            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
            //            [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
            //            [self.profileImageView setClipsToBounds:YES];
            //            [self.profileImageView setImage:image];
            //            [self.profileScrollView addSubview:self.profileImageView];
            
            _pickImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_pickImageBtn setFrame:CGRectMake(111, 65, 100, 100)];
            [_pickImageBtn setTitle:nil forState:UIControlStateNormal];
            [_pickImageBtn setBackgroundColor:[UIColor clearColor]];
            [_pickImageBtn addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
//            [self.profileScrollView addSubview:_pickImageBtn];
            
            self.profileLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10, 190, 300, 20)];
            self.profileLabel.textAlignment = NSTextAlignmentCenter;
            self.profileLabel.textColor = [UIColor whiteColor];
            self.profileLabel.text = [_userFullName uppercaseString];
            self.profileLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:16.0];
            [self.profileLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileLabel setAdjustsFontSizeToFitWidth:YES];
            [self.profileScrollView addSubview:self.profileLabel];
            
            self.settingsImage = [[UIImageView alloc]initWithFrame:CGRectMake(105, 200, 25, 25)];
            [self.settingsImage setImage:[UIImage imageNamed:@"edit_profile.png"]];
            //[self.profileScrollView addSubview:self.settingsImage];
            
            self.editLabel = [[UILabel alloc]initWithFrame:CGRectMake(123, 200, 100, 25)];
            self.editLabel.textAlignment = NSTextAlignmentCenter;
            self.editLabel.textColor = [UIColor whiteColor];
            self.editLabel.text = @"EDIT PROFILE";
            self.editLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0];
            [self.editLabel setBackgroundColor:[UIColor clearColor]];
            // [self.profileScrollView addSubview:self.editLabel];
            
            self.listCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, 107, 25)];
            self.listCountLabel.textAlignment = NSTextAlignmentCenter;
            self.listCountLabel.textColor = [UIColor whiteColor];
            self.listCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.listCountLabel setBackgroundColor:[UIColor clearColor]];
            NSString *count_string = [NSString stringWithFormat:@"%lu",(unsigned long)self.cachesubscribedHuntNames.count];
            [self.listCountLabel setText:count_string];
            [self.profileScrollView addSubview:self.listCountLabel];
            
            self.listLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 250, 107, 25)];
            self.listLabel.textAlignment = NSTextAlignmentCenter;
            self.listLabel.textColor = [UIColor whiteColor];
            self.listLabel.text = @"LIST";
            self.listLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:9.0];
            [self.listLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.listLabel];
            
            self.followersCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, 230, 107, 25)];
            self.followersCountLabel.textAlignment = NSTextAlignmentCenter;
            self.followersCountLabel.textColor = [UIColor whiteColor];
            self.followersCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.followersCountLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.followersCountLabel];
            
            self.followersLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, 250, 107, 25)];
            self.followersLabel.textAlignment = NSTextAlignmentCenter;
            self.followersLabel.textColor = [UIColor whiteColor];
            self.followersLabel.text = @"FOLLOWERS";
            self.followersLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:9.0];
            [self.followersLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.followersLabel];
            
            [self getFollowerUsers];
            
            self.followingCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 230, 107, 25)];
            self.followingCountLabel.textAlignment = NSTextAlignmentCenter;
            self.followingCountLabel.textColor = [UIColor whiteColor];
            self.followingCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.followingCountLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.followingCountLabel];
            
            self.followingLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 250, 107, 25)];
            self.followingLabel.textAlignment = NSTextAlignmentCenter;
            self.followingLabel.textColor = [UIColor whiteColor];
            self.followingLabel.text = @"FOLLOWING";
            self.followingLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:9.0];
            [self.followingLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.followingLabel];
            [self getFollowingUsers];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 278, 320, 1)];
            lineView.backgroundColor = [UIColor whiteColor];
            [self.profileScrollView addSubview:lineView];
            
            UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 335, 320, 1)];
            lineView4.backgroundColor = [self colorWithHexString:@"e5e4e4"];
            [self.profileScrollView addSubview:lineView4];
            
            self.progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 320, self.view.frame.size.height)];
            [self.progressView setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.progressView];
            
            self.completedView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 320, self.view.frame.size.height)];
            [self.completedView setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.completedView];
            
            self.feedView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 300, self.view.frame.size.height)];
            [self.feedView setBackgroundColor:[UIColor clearColor]];
            [self.feedView setUserInteractionEnabled:YES];
            [self.profileScrollView addSubview:self.feedView];
            
            [self.feedView setHidden:YES];
            [self.completedView setHidden:YES];
            
            UIImageView *blue_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21, 320, 56)];
            [blue_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.progressView addSubview:blue_bg];
            
            UIImageView *highlighted_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21, 107, 56)];
            highlighted_bg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.85f];
            [self.progressView addSubview:highlighted_bg];
            
            self.progressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, 107, 20)];
            self.progressLabel.textColor = [UIColor whiteColor];
            self.progressLabel.textAlignment = NSTextAlignmentCenter;
            self.progressLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            NSString *string = @"PROGRESS";
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            float spacing = 1.25f;
            [attributedString addAttribute:NSKernAttributeName
                                     value:@(spacing)
                                     range:NSMakeRange(0, [string length])];
            
            self.progressLabel.attributedText = attributedString;
            [self.progressLabel setBackgroundColor:[UIColor clearColor]];
            [self.progressView addSubview:self.progressLabel];
            
            UILabel *progressLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, 107, 20)];
            progressLabel2.textColor = [UIColor lightGrayColor];
            progressLabel2.textAlignment = NSTextAlignmentCenter;
            progressLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            progressLabel2.attributedText = attributedString;
            [progressLabel2 setBackgroundColor:[UIColor clearColor]];
            [self.completedView addSubview:progressLabel2];
            
            UILabel *progressLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, 107, 20)];
            progressLabel3.textColor = [UIColor lightGrayColor];
            progressLabel3.textAlignment = NSTextAlignmentCenter;
            progressLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            progressLabel3.attributedText = attributedString;
            [progressLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedView addSubview:progressLabel3];
            
            self.completedLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, -5, 107, 20)];
            self.completedLabel.textColor = [UIColor whiteColor];
            self.completedLabel.textAlignment = NSTextAlignmentCenter;
            self.completedLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            NSString *string2 = @"COMPLETED";
            NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:string2];
            float spacing2 = 1.25f;
            [attributedString2 addAttribute:NSKernAttributeName
                                      value:@(spacing2)
                                      range:NSMakeRange(0, [string2 length])];
            self.completedLabel.attributedText = attributedString2;
            [self.completedLabel setBackgroundColor:[UIColor clearColor]];
            [self.progressView addSubview:self.completedLabel];
            
            UIImageView *blue_bg_2 = [[UIImageView alloc]initWithFrame:CGRectMake(108, -21, 106, 56)];
            [blue_bg_2 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.completedView addSubview:blue_bg_2];
            
            UILabel *completedLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(107, -5, 107, 20)];
            completedLabel2.textColor = [UIColor whiteColor];
            completedLabel2.textAlignment = NSTextAlignmentCenter;
            completedLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            completedLabel2.attributedText = attributedString2;
            [completedLabel2 setBackgroundColor:[UIColor clearColor]];
            [self.completedView addSubview:completedLabel2];
            
            UILabel *completedLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(107, -5, 107, 20)];
            completedLabel3.textColor = [UIColor lightGrayColor];
            completedLabel3.textAlignment = NSTextAlignmentCenter;
            completedLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            completedLabel3.attributedText = attributedString2;
            [completedLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedView addSubview:completedLabel3];
            
            self.feedLabel = [[UILabel alloc]initWithFrame:CGRectMake(214, -5, 107, 20)];
            self.feedLabel.textColor = [UIColor lightGrayColor];
            self.feedLabel.textAlignment = NSTextAlignmentCenter;
            self.feedLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            NSString *string3 = @"NEWSFEED";
            NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:string3];
            float spacing3 = 1.25f;
            [attributedString3 addAttribute:NSKernAttributeName
                                      value:@(spacing3)
                                      range:NSMakeRange(0, [string3 length])];
            self.feedLabel.attributedText = attributedString3;
            [self.feedLabel setBackgroundColor:[UIColor clearColor]];
            [self.progressView addSubview:self.feedLabel];
            
            UILabel *feedLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(214, -5, 107, 20)];
            feedLabel2.textColor = [UIColor lightGrayColor];
            feedLabel2.textAlignment = NSTextAlignmentCenter;
            feedLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            feedLabel2.attributedText = attributedString3;
            [feedLabel2 setBackgroundColor:[UIColor clearColor]];
            [self.completedView addSubview:feedLabel2];
            
            UIImageView *blue_bg_3 = [[UIImageView alloc]initWithFrame:CGRectMake(215, -21, 107, 56)];
            [blue_bg_3 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.feedView addSubview:blue_bg_3];
            
            UILabel *feedLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(214, -5, 107, 20)];
            feedLabel3.textColor = [UIColor whiteColor];
            feedLabel3.textAlignment = NSTextAlignmentCenter;
            feedLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            feedLabel3.attributedText = attributedString3;
            [feedLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedView addSubview:feedLabel3];
            
            self.progressButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.progressButton  setFrame:CGRectMake(5, 280, 100, 55)];
            [self.progressButton setBackgroundColor:[UIColor clearColor]];
            [self.progressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.progressButton addTarget:self action:@selector(progressButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.progressButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
            self.progressButton.tag = 1;
            self.progressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.profileScrollView addSubview:self.progressButton];
            
            self.completedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.completedButton  setFrame:CGRectMake(110, 280, 100, 55)];
            [self.completedButton setBackgroundColor:[UIColor clearColor]];
            [self.completedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.completedButton addTarget:self action:@selector(completedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.completedButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
            self.completedButton.tag = 1;
            self.completedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.profileScrollView addSubview:self.completedButton];
            
            self.feedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.feedButton  setFrame:CGRectMake(216, 280, 100, 55)];
            [self.feedButton setBackgroundColor:[UIColor clearColor]];
            [self.feedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.feedButton addTarget:self action:@selector(feedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
            self.feedButton.tag = 1;
            self.feedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.profileScrollView addSubview:self.feedButton];
            
            self.finishedHuntVenues = [defaults objectForKey:@"finishedHuntVenues"];
            self.inProgressHuntNames = [defaults objectForKey:@"inProgressHuntNames"];
            self.finishedHuntNames = [defaults objectForKey:@"finishedHuntNames"];
            self.inProgressHuntCounts = [defaults objectForKey:@"inProgressHuntCounts"];
            self.finishedHuntCounts = [defaults objectForKey:@"finishedHuntCounts"];
            
            self.finishedHuntVenues = [NSMutableDictionary new];
            self.inProgressHuntNames = [NSMutableArray new];
            self.finishedHuntNames = [NSMutableArray new];
            self.inProgressHuntCounts = [NSMutableArray new];
            self.finishedHuntCounts = [NSMutableArray new];
            
            [self getMyHuntCounts];
            [self getMyNewsFeed];
            
            if(self.presentingViewController.presentedViewController == self) {
                
                self.backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 30, 30, 30)];
                self.backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
                [self.profileScrollView addSubview:self.backBtnImage];
                
                self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.backBtn setFrame:CGRectMake(10, 20, 40, 40)];
                [self.backBtn setTitle:@"" forState:UIControlStateNormal];
                [self.backBtn setBackgroundColor:[UIColor clearColor]];
                //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
                [self.profileScrollView addSubview:self.backBtn];
                
            }else{
                
                self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton3  setFrame:CGRectMake(0, 0, 60, 70)];
                [self.navButton3 setBackgroundColor:[UIColor clearColor]];
                [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton3.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
                self.navButton3.tag = 1;
                self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.view addSubview:self.navButton3];
                
                self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton  setFrame:CGRectMake(10, 27, 25, 18)];
                [self.navButton setBackgroundColor:[UIColor clearColor]];
                [self.navButton setBackgroundImage:[[UIImage imageNamed:@"white_menu.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
                [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
                self.navButton.tag = 1;
                self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.view addSubview:self.navButton];
                
                self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton2  setFrame:CGRectMake(0, 63, 60, 520)];
                [self.navButton2 setBackgroundColor:[UIColor clearColor]];
                [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton2.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
                self.navButton2.tag = 0;
                self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.profileScrollView addSubview:self.navButton2];
                
                [self.navButton2 setHidden:YES];
            }
            
            // Get ready for swipes
            [self setupGestures];

        }
    }
    
}

- (void)gotoHome:(id)sender{
    [self.delegate didSelectViewWithName:@"YookaHuntsLandingViewController"];
}

- (void)tick:(float)percent {
    NSLog(@" percent : %f",percent);
    CGFloat progress = percent;
    [self.circularProgressView setProgress:(progress <= 1.00f ? progress : 0.0f) animated:YES];
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
                    
                    UIImage *image = [UIImage imageNamed:@"minion.jpg"];
                    [self.profileImageView setImage:image];
                    [self.profileImageView3 setImage:image];

                }
                
            }else{
                
                UIImage *image = [UIImage imageNamed:@"minion.jpg"];
                [self.profileImageView setImage:image];
                [self.profileImageView3 setImage:image];

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
             [self.profileImageView3 setImage:image];
             //                            NSLog(@"profile image");
             
         }
     }];
}

- (void)progressButtonClicked:(id)sender{
    
    [Flurry logEvent:@"My_Profile_Progress_Button_Clicked"];
    
    [self.feedScrollView setHidden:YES];
    [self.progressScrollView setHidden:NO];
    [self.progressView setHidden:NO];
    [self.completedView setHidden:YES];
    [self.feedView setHidden:YES];
    [self.profileScrollView setContentOffset:CGPointMake(0, 0)];
    [self.profileScrollView setContentSize:CGSizeMake(320, contentSize)];

}

- (void)completedButtonClicked:(id)sender{
    
    [Flurry logEvent:@"My_Profile_Completed_Button_Clicked"];
    
    [self.feedScrollView setHidden:YES];
    [self.progressScrollView setHidden:NO];
    [self.completedView setHidden:NO];
    [self.progressView setHidden:YES];
    [self.feedView setHidden:YES];
    [self.profileScrollView setContentOffset:CGPointMake(0, 0)];
    [self.profileScrollView setContentSize:CGSizeMake(320, contentSize2)];
    
}

- (void)feedButtonClicked:(id)sender{
    
    [Flurry logEvent:@"My_Profile_Newsfeed_Button_Clicked"];
    [self.feedScrollView setHidden:NO];
    [self.progressScrollView setHidden:YES];
    [self.feedView setHidden:NO];
    [self.progressView setHidden:YES];
    [self.completedView setHidden:YES];
    
    [self.feedScrollView setContentOffset:CGPointMake(0, 0)];
    
    if (self.myPosts.count) {
        [self.feedScrollView setContentSize:CGSizeMake(320, contentSize3+340)];
    }else{
        [self getMyNewsFeed];
    }
    
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
            
            self.navButtonc.tag = 1;
            self.navButton2c.tag = 1;
            self.navButton3c.tag = 1;
            [self.navButton2c setHidden:YES];
            
            [_delegate movePanelToOriginalPosition];
            
            break;
        }
            
        case 1: {
            self.navButton.tag = 0;
            self.navButton3.tag = 0;
            self.navButton2.tag = 0;
            [self.navButton2 setHidden:NO];
            
            self.navButtonc.tag = 0;
            self.navButton3c.tag = 0;
            self.navButton2c.tag = 0;
            [self.navButton2c setHidden:NO];
            
            [_delegate movePanelRight];

            
            break;
        }
            
        default:
            break;
    }
}


- (void)back
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    // NSLog(@"%s: controller.view.window=%@", _func_, controller.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
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

- (void)getMyHuntCounts
{
    
    if (j<_cachesubscribedHuntNames.count) {
        
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        KCSQuery* query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:[KCSUser activeUser].email];
        KCSQuery* query2 = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:_cachesubscribedHuntNames[(self.cachesubscribedHuntNames.count-j)-1]];
        KCSQuery* query3 = [KCSQuery queryOnField:@"postType" usingConditional:kKCSNotEqual forValue:@"started hunt"];
        KCSQuery* query4 = [KCSQuery queryOnField:@"deleted" withExactMatchForValue:@"NO"];
        KCSQuery* query5 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2,query3,query4, nil];
        
        [store queryWithQuery:query5 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
//                NSLog(@"An error occurred on fetch: %@", errorOrNil);
            } else {
                
                //got all events back from server -- update table view
                NSMutableArray *array1 = [NSMutableArray new];
                
                if (array1.count==0) {
//                    NSLog(@"no lists");
                }

                if (objectsOrNil.count>0) {
                    
                    for (int a = 0; a<objectsOrNil.count; a++) {
                        YookaBackend *yooka = objectsOrNil[a];
                        if (yooka.venueName) {
                            [array1 addObject:yooka.venueName];
                        }
                    }
                    
                    NSArray *copy = [array1 copy];
                    NSInteger index = [copy count] - 1;
                    
                    for (id object in [copy reverseObjectEnumerator]) {
                        if ([array1 indexOfObject:object inRange:NSMakeRange(0, index)] != NSNotFound) {
                            [array1 removeObjectAtIndex:index];
                        }
                        index--;
                    }
                    
                    [_finishedHuntVenues setObject:array1 forKey:_cachesubscribedHuntNames[(self.cachesubscribedHuntNames.count-j)-1]];
                    
                }else{
                    
                    [_finishedHuntVenues setObject:objectsOrNil forKey:_cachesubscribedHuntNames[(self.cachesubscribedHuntNames.count-j)-1]];
                    
                }
                
                if (array1.count >=[[_huntDict2 objectForKey:_cachesubscribedHuntNames[(self.cachesubscribedHuntNames.count-j)-1]]integerValue]) {
                    
                    [self.finishedHuntNames addObject:_cachesubscribedHuntNames[(self.cachesubscribedHuntNames.count-j)-1]];
                    [self.finishedHuntCounts addObject:[NSString stringWithFormat:@"%@/%@",[_huntDict2 objectForKey:_cachesubscribedHuntNames[(self.cachesubscribedHuntNames.count-j)-1]],[_huntDict2 objectForKey:_cachesubscribedHuntNames[(self.cachesubscribedHuntNames.count-j)-1]]]];
                    
                }else{
                    
                    [self.inProgressHuntNames addObject:_cachesubscribedHuntNames[(self.cachesubscribedHuntNames.count-j)-1]];
                    [self.inProgressHuntCounts addObject:[NSString stringWithFormat:@"%lu/%@",(unsigned long)array1.count,[_huntDict2 objectForKey:_cachesubscribedHuntNames[(self.cachesubscribedHuntNames.count-j)-1]]]];
                    [self fillProgressHunts:j2];
                    j2++;

                }
                
                j++;
                [self getMyHuntCounts];
                
            }
        } withProgressBlock:nil];
        
    }else{
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.finishedHuntVenues forKey:@"finishedHuntVenues"];
        [defaults setObject:self.inProgressHuntNames forKey:@"inProgressHuntNames"];
        [defaults setObject:self.finishedHuntNames forKey:@"finishedHuntNames"];
        [defaults setObject:self.inProgressHuntCounts forKey:@"inProgressHuntCounts"];
        [defaults setObject:self.finishedHuntCounts forKey:@"finishedHuntCounts"];
        [defaults synchronize];
        
        NSString *list_count = [NSString stringWithFormat:@"%d",(int)(self.inProgressHuntNames.count+self.finishedHuntNames.count)];
        self.listCountLabel.text = list_count;
        
        if (self.finishedHuntNames.count==0) {
            
            UIImageView *check = [[UIImageView alloc]initWithFrame:CGRectMake(43, -20, 230, 230)];
            check.backgroundColor=[UIColor clearColor];
            check.image = [UIImage imageNamed:@"medal-.png"];
            [self.completedView addSubview:check];
            
            UILabel *label11 = [[UILabel alloc]initWithFrame:CGRectMake(0, 130, 320, 20)];
            label11.textColor = [self colorWithHexString:@"c7c7c7"];
            label11.textAlignment = NSTextAlignmentCenter;
            label11.font = [UIFont fontWithName:@"OpenSans-Extrabold" size:24.0];
            NSString *string11 = @"FINISHED YET?";
            NSMutableAttributedString *attributedString11 = [[NSMutableAttributedString alloc] initWithString:string11];
            float spacing11 = 2.f;
            [attributedString11 addAttribute:NSKernAttributeName
                                       value:@(spacing11)
                                       range:NSMakeRange(0, [string11 length])];
            label11.attributedText = attributedString11;
            [label11 setBackgroundColor:[UIColor clearColor]];
            [self.completedView addSubview:label11];
            
            UILabel *label12 = [[UILabel alloc]initWithFrame:CGRectMake(0, 155, 320, 20)];
            label12.textColor = [self colorWithHexString:@"c7c7c7"];
            label12.textAlignment = NSTextAlignmentCenter;
            label12.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
            NSString *string12 = @"ALL COMPLETED LIST GO HERE";
            NSMutableAttributedString *attributedString12 = [[NSMutableAttributedString alloc] initWithString:string12];
            float spacing12 = 1.25f;
            [attributedString12 addAttribute:NSKernAttributeName
                                       value:@(spacing12)
                                       range:NSMakeRange(0, [string12 length])];
            label12.attributedText = attributedString12;
            [label12 setBackgroundColor:[UIColor clearColor]];
            [self.completedView addSubview:label12];
            
            UIImageView *blue_bottom_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 208, 320, 60)];
            [blue_bottom_2 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.completedView addSubview:blue_bottom_2];
            
            UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 218, 320, 40)];
            label4.textColor = [UIColor whiteColor];
            label4.textAlignment = NSTextAlignmentCenter;
            label4.font = [UIFont fontWithName:@"OpenSans-Semibold" size:14.0];
            NSString *string4 = @"GET STARTED";
            NSMutableAttributedString *attributedString4 = [[NSMutableAttributedString alloc] initWithString:string4];
            float spacing4 = 1.25f;
            [attributedString4 addAttribute:NSKernAttributeName
                                      value:@(spacing4)
                                      range:NSMakeRange(0, [string4 length])];
            label4.attributedText = attributedString4;
            [label4 setBackgroundColor:[UIColor clearColor]];
            [self.completedView addSubview:label4];
            
            UIImageView *arrow2 = [[UIImageView alloc]initWithFrame:CGRectMake(200, 214, 35, 40)];
            arrow2.backgroundColor=[UIColor clearColor];
            arrow2.image = [UIImage imageNamed:@"arrow_white.png"];
            [self.completedView addSubview:arrow2];
            
            UIButton *get_started_button_2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [get_started_button_2 setFrame:CGRectMake(0, 208, 320, 60)];
            [get_started_button_2 setBackgroundColor:[UIColor clearColor]];
            [get_started_button_2 addTarget:self action:@selector(gotoHome:) forControlEvents:UIControlEventTouchUpInside];
            [self.completedView addSubview:get_started_button_2];
            
        }

        l=0;
        [self fillFinishedHunts];
    }
    
}

- (void)fillProgressHunts:(int)num{
    
    YookaButton *button = [[YookaButton alloc] initWithFrame:CGRectMake(col2*160,
                                                                  (row2*169)+35,
                                                                  160,
                                                                  140)];
    button.userInteractionEnabled = YES;
    button.tag = num;
//    NSLog(@"num = %d",num);
    [button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
    ++col2;
    if (col2 >= yookaImagesPerRow2014) {
        row2++;
        col2 = 0;
    }else{
        contentSize += 170;
    }
    [self.profileScrollView setContentSize:CGSizeMake(320, contentSize)];
    [self.progressView addSubview:button];
    [self.thumbnails2 addObject:button];
    self.progressView.frame = CGRectMake(0, 300, 320, contentSize);

    
    NSString *picUrl = [_huntDict6 objectForKey:_inProgressHuntNames[num]];
    
    [[SDImageCache sharedImageCache] queryDiskCacheForKey:picUrl done:^(UIImage *image, SDImageCacheType cacheType){
        
        if (image) {
            
            UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 160, 157)];
            //                 UIImage *scaledImage = [image scaleToSize:CGSizeMake(150, 150)];
            buttonImage.image = image;
            buttonImage.contentMode = UIViewContentModeScaleToFill;
            [buttonImage setBackgroundColor:[UIColor clearColor]];
            [button addSubview:buttonImage];
            
            UIView *huntLabel_bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, 160, 30)];
            // huntLabel_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
            huntLabel_bg2.backgroundColor = [UIColor whiteColor];
            [button addSubview:huntLabel_bg2];
            
            UILabel *huntLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 139, 150, 33)];
            
            huntLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:11.f];
            huntLabel.textAlignment = NSTextAlignmentLeft;
            huntLabel.userInteractionEnabled = YES;
            NSString *string = [self.inProgressHuntNames[num] uppercaseString];
            huntLabel.textColor = [self colorWithHexString:@"9a8e92"];
            
            if (string) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                float spacing = 1.f;
                [attributedString addAttribute:NSKernAttributeName
                                         value:@(spacing)
                                         range:NSMakeRange(0, [string length])];
                huntLabel.attributedText = attributedString;
            }
            [button addSubview:huntLabel];
            
            UIView *ver_bg2 = [[UIView alloc]initWithFrame:CGRectMake(159, 0, 1, 140)];
            //ver_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
            ver_bg2.backgroundColor = [UIColor whiteColor];
            ver_bg2.userInteractionEnabled = YES;
            [button addSubview:ver_bg2];
            
            UIView *ver_bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 140)];
            //ver_bg3.backgroundColor = [self colorWithHexString:@"f8f8f8"];
            ver_bg3.backgroundColor = [UIColor whiteColor];
            ver_bg3.userInteractionEnabled = YES;
            [button addSubview:ver_bg3];
            
            UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 43, 20)];
            //UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(133, 3, 25, 25)];
            huntCountLabel.text =self.inProgressHuntCounts[(self.inProgressHuntNames.count-k)-1];
            //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
            huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.f];
            huntCountLabel.textAlignment = NSTextAlignmentCenter;
            huntCountLabel.textColor = [self colorWithHexString:@"f8f8f8"];
            huntCountLabel.backgroundColor = [[self colorWithHexString:@"9a8e92"] colorWithAlphaComponent:0.7];
            huntCountLabel.adjustsFontSizeToFitWidth = YES;
            huntCountLabel.layer.cornerRadius = 10;
            huntCountLabel.clipsToBounds = YES;
            //[huntCountLabel sizeToFit];
            
            [button addSubview:huntCountLabel];
            
            self.hunts_options_button = [[YookaButton alloc]initWithFrame:CGRectMake(133, 127, 26, 13)];
            self.hunts_options_button.tag = num;
            self.hunts_options_button.secondTag = [NSString stringWithFormat:@"%d",num];;
            self.hunts_options_button.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:25.0];
            [self.hunts_options_button setTitle:@"" forState:UIControlStateNormal];
            [self.hunts_options_button setBackgroundColor:[self colorWithHexString:@"9a8e92"]];
            [self.hunts_options_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.hunts_options_button addTarget:self action:@selector(hunts_options:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.hunts_options_button];
            
            UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake(135, 109, 33, 29)];
            dot.text= @".";
            dot.font = [UIFont fontWithName:@"OpenSans" size:29.f];
            dot.textColor=[UIColor whiteColor];
            [button addSubview:dot];
            
            UILabel *dot2 = [[UILabel alloc]initWithFrame:CGRectMake(142, 109, 33, 29)];
            dot2.text= @".";
            dot2.font = [UIFont fontWithName:@"OpenSans" size:29.f];
            dot2.textColor=[UIColor whiteColor];
            [button addSubview:dot2];
            
            UILabel *dot3 = [[UILabel alloc]initWithFrame:CGRectMake(149, 109, 33, 29)];
            dot3.text= @".";
            dot3.font = [UIFont fontWithName:@"OpenSans" size:29.f];
            dot3.textColor=[UIColor whiteColor];
            [button addSubview:dot3];
            
            UIButton *cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
            cover_button.frame = CGRectMake(130, 120, 30, 25);
            [cover_button setBackgroundColor:[UIColor clearColor]];
            cover_button.tag = num;
            [cover_button addTarget:self action:@selector(hunts_options:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:cover_button];
            
            [self.hunts_options_button addTarget:self action:@selector(hunts_options:) forControlEvents:UIControlEventTouchUpInside];
            [self.hunts_options_button setEnabled:YES];
            
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
                     
                     UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 160, 157)];
                     //                 UIImage *scaledImage = [image scaleToSize:CGSizeMake(150, 150)];
                     buttonImage.image = image;
                     buttonImage.contentMode = UIViewContentModeScaleToFill;
                     [buttonImage setBackgroundColor:[UIColor clearColor]];
                     [button addSubview:buttonImage];
                     
                     UIView *huntLabel_bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, 160, 30)];
                     // huntLabel_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                     huntLabel_bg2.backgroundColor = [UIColor whiteColor];
                     [button addSubview:huntLabel_bg2];
                     
                     UILabel *huntLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 139, 150, 33)];
                     
                     huntLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:11.f];
                     huntLabel.textAlignment = NSTextAlignmentLeft;
                     huntLabel.userInteractionEnabled = YES;
                     NSString *string = [self.inProgressHuntNames[num] uppercaseString];
                     huntLabel.textColor = [self colorWithHexString:@"9a8e92"];
                     
                     if (string) {
                         NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                         float spacing = 1.f;
                         [attributedString addAttribute:NSKernAttributeName
                                                  value:@(spacing)
                                                  range:NSMakeRange(0, [string length])];
                         huntLabel.attributedText = attributedString;
                     }
                     [button addSubview:huntLabel];
                     
                     UIView *ver_bg2 = [[UIView alloc]initWithFrame:CGRectMake(159, 0, 1, 140)];
                     //ver_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                     ver_bg2.backgroundColor = [UIColor whiteColor];
                     ver_bg2.userInteractionEnabled = YES;
                     [button addSubview:ver_bg2];
                     
                     UIView *ver_bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 140)];
                     //ver_bg3.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                     ver_bg3.backgroundColor = [UIColor whiteColor];
                     ver_bg3.userInteractionEnabled = YES;
                     [button addSubview:ver_bg3];
                     
                     UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 43, 20)];
                     //UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(133, 3, 25, 25)];
                     huntCountLabel.text =self.inProgressHuntCounts[(self.inProgressHuntNames.count-k)-1];
                     //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
                     huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.f];
                     huntCountLabel.textAlignment = NSTextAlignmentCenter;
                     huntCountLabel.textColor = [self colorWithHexString:@"f8f8f8"];
                     huntCountLabel.backgroundColor = [[self colorWithHexString:@"9a8e92"] colorWithAlphaComponent:0.7];
                     huntCountLabel.adjustsFontSizeToFitWidth = YES;
                     huntCountLabel.layer.cornerRadius = 10;
                     huntCountLabel.clipsToBounds = YES;
                     //[huntCountLabel sizeToFit];
                     
                     [button addSubview:huntCountLabel];
                     
                     self.hunts_options_button = [[YookaButton alloc]initWithFrame:CGRectMake(133, 127, 26, 13)];
                     self.hunts_options_button.tag = num;
                     self.hunts_options_button.secondTag = [NSString stringWithFormat:@"%d",num];;
                     self.hunts_options_button.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:25.0];
                     [self.hunts_options_button setTitle:@"" forState:UIControlStateNormal];
                     [self.hunts_options_button setBackgroundColor:[self colorWithHexString:@"9a8e92"]];
                     [self.hunts_options_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [self.hunts_options_button addTarget:self action:@selector(hunts_options:) forControlEvents:UIControlEventTouchUpInside];
                     [button addSubview:self.hunts_options_button];
                     
                     UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake(135, 109, 33, 29)];
                     dot.text= @".";
                     dot.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot.textColor=[UIColor whiteColor];
                     [button addSubview:dot];
                     
                     UILabel *dot2 = [[UILabel alloc]initWithFrame:CGRectMake(142, 109, 33, 29)];
                     dot2.text= @".";
                     dot2.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot2.textColor=[UIColor whiteColor];
                     [button addSubview:dot2];
                     
                     UILabel *dot3 = [[UILabel alloc]initWithFrame:CGRectMake(149, 109, 33, 29)];
                     dot3.text= @".";
                     dot3.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot3.textColor=[UIColor whiteColor];
                     [button addSubview:dot3];
                     
                     UIButton *cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
                     cover_button.frame = CGRectMake(130, 120, 30, 25);
                     [cover_button setBackgroundColor:[UIColor clearColor]];
                     cover_button.tag = num;
                     [cover_button addTarget:self action:@selector(hunts_options:) forControlEvents:UIControlEventTouchUpInside];
                     [button addSubview:cover_button];
                     
                     [self.hunts_options_button addTarget:self action:@selector(hunts_options:) forControlEvents:UIControlEventTouchUpInside];
                     [self.hunts_options_button setEnabled:YES];
                     
                 }
             }];
            
        }
     
     }];

}

- (void)fillProgressHunts{
    
    if (self.inProgressHuntNames.count>0 && k<self.inProgressHuntNames.count) {

//        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(col2*160, (row2*177.5)+45, 160, 180)];
//        if (_myPosts.count>2) {
        
        YookaButton *button = [[YookaButton alloc] initWithFrame:CGRectMake(col2*160,
                                                                      (row2*169)+35,
                                                                      160,
                                                                      140)];
        button.tag = k;
        button.userInteractionEnabled = YES;
        [button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
        ++col2;
        
        if (col2 >= yookaImagesPerRow2014) {
            row2++;
            col2 = 0;
            contentSize += 170;
        }
        [self.profileScrollView setContentSize:CGSizeMake(320, contentSize)];
        [self.progressView addSubview:button];
        [self.thumbnails2 addObject:button];
        
        NSString *picUrl = [_huntDict6 objectForKey:_inProgressHuntNames[(self.inProgressHuntNames.count-k)-1]];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData* imageData = [ud objectForKey:_inProgressHuntNames[(self.inProgressHuntNames.count-k)-1]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (image) {
            
            UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 160, 157)];
            //                 UIImage *scaledImage = [image scaleToSize:CGSizeMake(150, 150)];
            buttonImage.image = image;
            buttonImage.contentMode = UIViewContentModeScaleToFill;
            [buttonImage setBackgroundColor:[UIColor clearColor]];
            [button addSubview:buttonImage];
            
            UIView *huntLabel_bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, 160, 30)];
           // huntLabel_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
            huntLabel_bg2.backgroundColor = [UIColor whiteColor];
            [button addSubview:huntLabel_bg2];
            
            UILabel *huntLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 139, 150, 33)];
            
            huntLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.f];
            huntLabel.textAlignment = NSTextAlignmentLeft;
            
            NSString *string = [self.inProgressHuntNames[(self.inProgressHuntNames.count-k)-1] uppercaseString];
            huntLabel.textColor = [self colorWithHexString:@"9a8e92"];
            
            if (string) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                float spacing = 1.2f;
                [attributedString addAttribute:NSKernAttributeName
                                         value:@(spacing)
                                         range:NSMakeRange(0, [string length])];
                huntLabel.attributedText = attributedString;
            }
            [button addSubview:huntLabel];
            
            UIView *ver_bg2 = [[UIView alloc]initWithFrame:CGRectMake(159, 0, 1, 140)];
            //ver_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
            ver_bg2.backgroundColor = [UIColor whiteColor];
            [button addSubview:ver_bg2];
            
            UIView *ver_bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 140)];
            //ver_bg3.backgroundColor = [self colorWithHexString:@"f8f8f8"];
            ver_bg3.backgroundColor = [UIColor whiteColor];

            [button addSubview:ver_bg3];
            
            UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 43, 20)];
            //UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(133, 3, 25, 25)];
            huntCountLabel.text =self.inProgressHuntCounts[(self.inProgressHuntNames.count-k)-1];
            //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
            huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.f];
            huntCountLabel.textAlignment = NSTextAlignmentCenter;
            huntCountLabel.textColor = [self colorWithHexString:@"f8f8f8"];
            huntCountLabel.backgroundColor = [[self colorWithHexString:@"9a8e92"] colorWithAlphaComponent:0.7];
            huntCountLabel.adjustsFontSizeToFitWidth = YES;
            huntCountLabel.layer.cornerRadius = 10;
            huntCountLabel.clipsToBounds = YES;
            //[huntCountLabel sizeToFit];
            
            [button addSubview:huntCountLabel];
            
            self.hunts_options_button = [[YookaButton alloc]initWithFrame:CGRectMake(132, 149, 26, 13)];
            //self.hunts_options_button = [[FUIButton alloc]initWithFrame:CGRectMake(133, 107, 25, 33)];
            self.hunts_options_button.tag = k;
            self.hunts_options_button.secondTag = [NSString stringWithFormat:@"%d",k];
            self.hunts_options_button.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:25.0];
            [self.hunts_options_button setTitle:@"" forState:UIControlStateNormal];
            [self.hunts_options_button setBackgroundColor:[self colorWithHexString:@"9a8e92"]];
            [self.hunts_options_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.hunts_options_button addTarget:self action:@selector(hunts_options:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.hunts_options_button];
            
            UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake(135, 131, 33, 29)];
            dot.text= @".";
            dot.font = [UIFont fontWithName:@"OpenSans" size:29.f];
            dot.textColor=[UIColor whiteColor];
            [button addSubview:dot];
            
            UILabel *dot2 = [[UILabel alloc]initWithFrame:CGRectMake(142, 131, 33, 29)];
            dot2.text= @".";
            dot2.font = [UIFont fontWithName:@"OpenSans" size:29.f];
            dot2.textColor=[UIColor whiteColor];
            [button addSubview:dot2];
            
            UILabel *dot3 = [[UILabel alloc]initWithFrame:CGRectMake(149, 131, 33, 29)];
            dot3.text= @".";
            dot3.font = [UIFont fontWithName:@"OpenSans" size:29.f];
            dot3.textColor=[UIColor whiteColor];
            [button addSubview:dot3];
            
            [self.hunts_options_button addTarget:self action:@selector(hunts_options:) forControlEvents:UIControlEventTouchUpInside];
            [self.hunts_options_button setEnabled:YES];

            k++;
            [self fillProgressHunts];
            
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
                     
                     UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 160, 157)];
                     //                 UIImage *scaledImage = [image scaleToSize:CGSizeMake(150, 150)];
                     buttonImage.image = image;
                     buttonImage.contentMode = UIViewContentModeScaleToFill;
                     [buttonImage setBackgroundColor:[UIColor clearColor]];
                     [button addSubview:buttonImage];
                     
                     UIView *huntLabel_bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, 160, 30)];
                     // huntLabel_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                     huntLabel_bg2.backgroundColor = [UIColor whiteColor];
                     [button addSubview:huntLabel_bg2];
                     
                     UILabel *huntLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 139, 150, 33)];
                     
                     huntLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.f];
                     huntLabel.textAlignment = NSTextAlignmentLeft;
                     
                     NSString *string = [self.inProgressHuntNames[(self.inProgressHuntNames.count-k)-1] uppercaseString];
                     huntLabel.textColor = [self colorWithHexString:@"9a8e92"];
                     
                     if (string) {
                         NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                         float spacing = 1.2f;
                         [attributedString addAttribute:NSKernAttributeName
                                                  value:@(spacing)
                                                  range:NSMakeRange(0, [string length])];
                         huntLabel.attributedText = attributedString;
                     }
                     [button addSubview:huntLabel];
                     
                     UIView *ver_bg2 = [[UIView alloc]initWithFrame:CGRectMake(159, 0, 1, 140)];
                     //ver_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                     ver_bg2.backgroundColor = [UIColor whiteColor];
                     [button addSubview:ver_bg2];
                     
                     UIView *ver_bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 140)];
                     //ver_bg3.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                     ver_bg3.backgroundColor = [UIColor whiteColor];
                     
                     [button addSubview:ver_bg3];
                     
                     
                     UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 43, 20)];
                     //UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(133, 3, 25, 25)];
                     huntCountLabel.text =self.inProgressHuntCounts[(self.inProgressHuntNames.count-k)-1];
                     //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
                     huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.f];
                     huntCountLabel.textAlignment = NSTextAlignmentCenter;
                     huntCountLabel.textColor = [self colorWithHexString:@"f8f8f8"];
                     huntCountLabel.backgroundColor = [[self colorWithHexString:@"9a8e92"] colorWithAlphaComponent:0.7];
                     huntCountLabel.adjustsFontSizeToFitWidth = YES;
                     huntCountLabel.layer.cornerRadius = 10;
                     huntCountLabel.clipsToBounds = YES;
                     //[huntCountLabel sizeToFit];
                     
                     [button addSubview:huntCountLabel];
                     
                     self.hunts_options_button = [[YookaButton alloc]initWithFrame:CGRectMake(132, 149, 26, 13)];
                     //self.hunts_options_button = [[FUIButton alloc]initWithFrame:CGRectMake(133, 107, 25, 33)];
                     self.hunts_options_button.tag = k;
                     self.hunts_options_button.secondTag = [NSString stringWithFormat:@"%d",k];
                     self.hunts_options_button.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:25.0];
                     [self.hunts_options_button setTitle:@"" forState:UIControlStateNormal];
                     [self.hunts_options_button setBackgroundColor:[self colorWithHexString:@"9a8e92"]];
                     [self.hunts_options_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [self.hunts_options_button addTarget:self action:@selector(hunts_options:) forControlEvents:UIControlEventTouchUpInside];
                     [button addSubview:self.hunts_options_button];
                     
                     UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake(135, 131, 33, 29)];
                     dot.text= @".";
                     dot.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot.textColor=[UIColor whiteColor];
                     [button addSubview:dot];
                     
                     UILabel *dot2 = [[UILabel alloc]initWithFrame:CGRectMake(142, 131, 33, 29)];
                     dot2.text= @".";
                     dot2.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot2.textColor=[UIColor whiteColor];
                     [button addSubview:dot2];
                     
                     UILabel *dot3 = [[UILabel alloc]initWithFrame:CGRectMake(149, 131, 33, 29)];
                     dot3.text= @".";
                     dot3.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot3.textColor=[UIColor whiteColor];
                     [button addSubview:dot3];
                     
                     [self.hunts_options_button addTarget:self action:@selector(hunts_options:) forControlEvents:UIControlEventTouchUpInside];
                     [self.hunts_options_button setEnabled:YES];

                     k++;
                     [self fillProgressHunts];
                 }
             }];
            
        }
        
    }
    
    if (k==self.inProgressHuntNames.count) {
        self.progressView.frame = CGRectMake(0, 300, 320, contentSize);
    }
    
}

- (void)fillFinishedHunts{
    
    if (self.finishedHuntNames.count>0 && l<self.finishedHuntNames.count) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(col3*160,
                                                                      (row3*169)+35,
                                                                      160,
                                                                      140)];
        button.tag = l;
        [button addTarget:self action:@selector(buttonAction3:) forControlEvents:UIControlEventTouchUpInside];
        ++col3;
        
        if (col3 >= yookaImagesPerRow2014) {
            row3++;
            col3 = 0;
            contentSize2 += 170;
        }
//        [self.profileScrollView setContentSize:CGSizeMake(320, contentSize2)];
        [self.completedView addSubview:button];
// self.completedView.backgroundColor = [self colorWithHexString:@"f8f8f8"];
        [self.thumbnails3 addObject:button];
        
        NSString *picUrl = [_huntDict6 objectForKey:_finishedHuntNames[l]];
        
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:picUrl done:^(UIImage *image, SDImageCacheType cacheType)
         {
             
             if (image) {
                 
                 UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 160, 157)];
                 buttonImage.image = image;
                 buttonImage.contentMode = UIViewContentModeScaleToFill;
                 [buttonImage setBackgroundColor:[UIColor clearColor]];
                 [button addSubview:buttonImage];
                 
                 UIView *huntLabel_bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, 160, 30)];
                 //huntLabel_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                 huntLabel_bg2.backgroundColor = [UIColor whiteColor];
                 [button addSubview:huntLabel_bg2];
                 
                 UILabel *huntLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 139, 150, 33)];
                 huntLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.f];
                 huntLabel.textAlignment = NSTextAlignmentLeft;
                 NSString *string = [self.finishedHuntNames[l] uppercaseString];
                 //            NSLog(@"try = %@",self.finishedHuntNames[l]);
                 huntLabel.textColor = [self colorWithHexString:@"9a8e92"];
                 if (string) {
                     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                     float spacing = 1.2f;
                     [attributedString addAttribute:NSKernAttributeName
                                              value:@(spacing)
                                              range:NSMakeRange(0, [string length])];
                     huntLabel.attributedText = attributedString;
                 }
                 [button addSubview:huntLabel];
                 
                 UIView *ver_bg2 = [[UIView alloc]initWithFrame:CGRectMake(159, 0, 1, 140)];
                 //ver_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                 ver_bg2.backgroundColor = [UIColor whiteColor];
                 [button addSubview:ver_bg2];
                 
                 UIView *ver_bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 140)];
                 //ver_bg3.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                 ver_bg3.backgroundColor = [UIColor whiteColor];
                 [button addSubview:ver_bg3];
                 
                 UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 43, 20)];
                 //UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(133, 3, 25, 25)];
                 huntCountLabel.text =self.inProgressHuntCounts[(self.inProgressHuntNames.count-k)-1];
                 //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
                 huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.f];
                 huntCountLabel.textAlignment = NSTextAlignmentCenter;
                 huntCountLabel.textColor = [self colorWithHexString:@"f8f8f8"];
                 huntCountLabel.backgroundColor = [[self colorWithHexString:@"9a8e92"] colorWithAlphaComponent:0.7];
                 huntCountLabel.adjustsFontSizeToFitWidth = YES;
                 huntCountLabel.layer.cornerRadius = 10;
                 huntCountLabel.clipsToBounds = YES;
                 //[huntCountLabel sizeToFit];
                 
                 [button addSubview:huntCountLabel];
                 
                 self.hunts_options_button_2 = [[YookaButton alloc]initWithFrame:CGRectMake(133, 127, 26, 13)];
                 self.hunts_options_button_2.tag = l;
                 self.hunts_options_button_2.secondTag = [NSString stringWithFormat:@"%d",l];
                 self.hunts_options_button_2.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:25.0];
                 [self.hunts_options_button_2 setTitle:@"" forState:UIControlStateNormal];
                 [self.hunts_options_button_2 setBackgroundColor:[self colorWithHexString:@"9a8e92"]];
                 [self.hunts_options_button_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 [self.hunts_options_button_2 addTarget:self action:@selector(hunts_options_2:) forControlEvents:UIControlEventTouchUpInside];
                 [button addSubview:self.hunts_options_button_2];
                 
                 UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake(135, 109, 33, 29)];
                 dot.text= @".";
                 dot.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                 dot.textColor=[UIColor whiteColor];
                 [button addSubview:dot];
                 
                 UILabel *dot2 = [[UILabel alloc]initWithFrame:CGRectMake(142, 109, 33, 29)];
                 dot2.text= @".";
                 dot2.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                 dot2.textColor=[UIColor whiteColor];
                 [button addSubview:dot2];
                 
                 UILabel *dot3 = [[UILabel alloc]initWithFrame:CGRectMake(149, 109, 33, 29)];
                 dot3.text= @".";
                 dot3.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                 dot3.textColor=[UIColor whiteColor];
                 [button addSubview:dot3];
                 
                 UIButton *cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
                 cover_button.frame = CGRectMake(130, 120, 30, 25);
                 [cover_button setBackgroundColor:[UIColor clearColor]];
                 cover_button.tag = l;
                 [cover_button addTarget:self action:@selector(hunts_options_2:) forControlEvents:UIControlEventTouchUpInside];
                 [button addSubview:cover_button];
                 
                 l++;
                 [self fillFinishedHunts];
                 
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
                          
                          [[SDImageCache sharedImageCache] storeImage:image forKey:picUrl];
                          
                          UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 160, 157)];
                          buttonImage.image = image;
                          buttonImage.contentMode = UIViewContentModeScaleToFill;
                          [buttonImage setBackgroundColor:[UIColor clearColor]];
                          [button addSubview:buttonImage];
                          
                          UIView *huntLabel_bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, 160, 30)];
                          //huntLabel_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                          huntLabel_bg2.backgroundColor = [UIColor whiteColor];
                          [button addSubview:huntLabel_bg2];
                          
                          UILabel *huntLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 139, 150, 33)];
                          huntLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.f];
                          huntLabel.textAlignment = NSTextAlignmentLeft;
                          NSString *string = [self.finishedHuntNames[l] uppercaseString];
                          //            NSLog(@"try = %@",self.finishedHuntNames[l]);
                          huntLabel.textColor = [self colorWithHexString:@"9a8e92"];
                          if (string) {
                              NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                              float spacing = 1.2f;
                              [attributedString addAttribute:NSKernAttributeName
                                                       value:@(spacing)
                                                       range:NSMakeRange(0, [string length])];
                              huntLabel.attributedText = attributedString;
                          }
                          [button addSubview:huntLabel];
                          
                          UIView *ver_bg2 = [[UIView alloc]initWithFrame:CGRectMake(159, 0, 1, 140)];
                          //ver_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                          ver_bg2.backgroundColor = [UIColor whiteColor];
                          [button addSubview:ver_bg2];
                          
                          UIView *ver_bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 140)];
                          //ver_bg3.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                          ver_bg3.backgroundColor = [UIColor whiteColor];
                          [button addSubview:ver_bg3];
                          
                          UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 43, 20)];
                          //UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(133, 3, 25, 25)];
                          huntCountLabel.text =self.inProgressHuntCounts[(self.inProgressHuntNames.count-k)-1];
                          //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
                          huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:14.f];
                          huntCountLabel.textAlignment = NSTextAlignmentCenter;
                          huntCountLabel.textColor = [self colorWithHexString:@"f8f8f8"];
                          huntCountLabel.backgroundColor = [[self colorWithHexString:@"9a8e92"] colorWithAlphaComponent:0.7];
                          huntCountLabel.adjustsFontSizeToFitWidth = YES;
                          huntCountLabel.layer.cornerRadius = 10;
                          huntCountLabel.clipsToBounds = YES;
                          //[huntCountLabel sizeToFit];
                          
                          [button addSubview:huntCountLabel];
                          
                          self.hunts_options_button_2 = [[YookaButton alloc]initWithFrame:CGRectMake(133, 127, 26, 13)];
                          self.hunts_options_button_2.tag = l;
                          self.hunts_options_button_2.secondTag = [NSString stringWithFormat:@"%d",l];
                          self.hunts_options_button_2.titleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:25.0];
                          [self.hunts_options_button_2 setTitle:@"" forState:UIControlStateNormal];
                          [self.hunts_options_button_2 setBackgroundColor:[self colorWithHexString:@"9a8e92"]];
                          [self.hunts_options_button_2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                          [self.hunts_options_button_2 addTarget:self action:@selector(hunts_options_2:) forControlEvents:UIControlEventTouchUpInside];
                          [button addSubview:self.hunts_options_button_2];
                          
                          UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake(135, 109, 33, 29)];
                          dot.text= @".";
                          dot.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                          dot.textColor=[UIColor whiteColor];
                          [button addSubview:dot];
                          
                          UILabel *dot2 = [[UILabel alloc]initWithFrame:CGRectMake(142, 109, 33, 29)];
                          dot2.text= @".";
                          dot2.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                          dot2.textColor=[UIColor whiteColor];
                          [button addSubview:dot2];
                          
                          UILabel *dot3 = [[UILabel alloc]initWithFrame:CGRectMake(149, 109, 33, 29)];
                          dot3.text= @".";
                          dot3.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                          dot3.textColor=[UIColor whiteColor];
                          [button addSubview:dot3];
                          
                          UIButton *cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
                          cover_button.frame = CGRectMake(130, 120, 30, 25);
                          [cover_button setBackgroundColor:[UIColor clearColor]];
                          cover_button.tag = l;
                          [cover_button addTarget:self action:@selector(hunts_options_2:) forControlEvents:UIControlEventTouchUpInside];
                          [button addSubview:cover_button];
                          
                          l++;
                          [self fillFinishedHunts];
                      }
                  }];

             }

         }];
        
    }
    
    if (l==self.finishedHuntNames.count) {
        self.completedView.frame = CGRectMake(0, 300, 320, contentSize2);
    }
    
}

- (void)getMyNewsFeed{
    
    self.myPosts = [NSMutableArray new];
    self.thumbnails = [NSMutableArray new];

    self.postLikers = [NSMutableArray new];
    self.likesData = [NSMutableArray new];
    self.likersData = [NSMutableArray new];
    self.imagesArray = [NSMutableArray new];
    
    i=0;
    self.collectionName1 = @"yookaPosts2";
    self.customEndpoint1 = @"NewsFeed";
    self.fieldName1 = @"postDate";

    self.dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:self.myEmail,@"userEmail",self.collectionName1,@"collectionName",self.fieldName1,@"fieldName", nil];
    
    [KCSCustomEndpoints callEndpoint:self.customEndpoint1 params:self.dict1 completionBlock:^(id results, NSError *error){
        if ([results isKindOfClass:[NSArray class]]) {
            self.myPosts = [NSMutableArray arrayWithArray:results];
            if (self.myPosts && self.myPosts.count) {

                [self fillPictures];
                
            }else{
                
                
            }
            
        }else{
            
        }
    }];
    
}

- (void)reloadNewsfeed:(int)index
{
    [self.myPosts removeObjectAtIndex:index];
    
    [self.feedView removeFromSuperview];
    
    self.feedView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 300, self.view.frame.size.height)];
    [self.feedView setBackgroundColor:[UIColor clearColor]];
    [self.feedView setUserInteractionEnabled:YES];
    [self.profileScrollView addSubview:self.feedView];
    
    self.thumbnails = [NSMutableArray new];
    
    self.postLikers = [NSMutableArray new];
    self.likesData = [NSMutableArray new];
    self.likersData = [NSMutableArray new];
    self.imagesArray = [NSMutableArray new];
    
    i=0;
    m=0;
    n=0;
    p=0;
    contentSize3 = 30;

    [self fillPictures];
    
    NSString *string = @"PROGRESS";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    float spacing = 1.25f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
    UILabel *progressLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, 107, 20)];
    progressLabel3.textColor = [UIColor lightGrayColor];
    progressLabel3.textAlignment = NSTextAlignmentCenter;
    progressLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
    progressLabel3.attributedText = attributedString;
    [progressLabel3 setBackgroundColor:[UIColor clearColor]];
    [self.feedView addSubview:progressLabel3];
    
    NSString *string2 = @"COMPLETED";
    NSMutableAttributedString *attributedString2 = [[NSMutableAttributedString alloc] initWithString:string2];
    float spacing2 = 1.25f;
    [attributedString2 addAttribute:NSKernAttributeName
                              value:@(spacing2)
                              range:NSMakeRange(0, [string2 length])];
    
    UILabel *completedLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(107, -5, 107, 20)];
    completedLabel3.textColor = [UIColor lightGrayColor];
    completedLabel3.textAlignment = NSTextAlignmentCenter;
    completedLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
    completedLabel3.attributedText = attributedString2;
    [completedLabel3 setBackgroundColor:[UIColor clearColor]];
    [self.feedView addSubview:completedLabel3];
    
    NSString *string3 = @"NEWSFEED";
    NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:string3];
    float spacing3 = 1.25f;
    [attributedString3 addAttribute:NSKernAttributeName
                              value:@(spacing3)
                              range:NSMakeRange(0, [string3 length])];
    
    UIImageView *blue_bg_3 = [[UIImageView alloc]initWithFrame:CGRectMake(215, -21, 107, 56)];
    [blue_bg_3 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    [self.feedView addSubview:blue_bg_3];
    
    UILabel *feedLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(214, -5, 107, 20)];
    feedLabel3.textColor = [UIColor whiteColor];
    feedLabel3.textAlignment = NSTextAlignmentCenter;
    feedLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
    feedLabel3.attributedText = attributedString3;
    [feedLabel3 setBackgroundColor:[UIColor clearColor]];
    [self.feedView addSubview:feedLabel3];
    
    self.progressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.progressButton  setFrame:CGRectMake(5, 280, 100, 55)];
    [self.progressButton setBackgroundColor:[UIColor clearColor]];
    [self.progressButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.progressButton addTarget:self action:@selector(progressButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.progressButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
    self.progressButton.tag = 1;
    self.progressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.profileScrollView addSubview:self.progressButton];
    
    self.completedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.completedButton  setFrame:CGRectMake(110, 280, 100, 55)];
    [self.completedButton setBackgroundColor:[UIColor clearColor]];
    [self.completedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.completedButton addTarget:self action:@selector(completedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.completedButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
    self.completedButton.tag = 1;
    self.completedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.profileScrollView addSubview:self.completedButton];
    
    self.feedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.feedButton  setFrame:CGRectMake(216, 280, 100, 55)];
    [self.feedButton setBackgroundColor:[UIColor clearColor]];
    [self.feedButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.feedButton addTarget:self action:@selector(feedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.feedButton.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18]];
    self.feedButton.tag = 1;
    self.feedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.profileScrollView addSubview:self.feedButton];

}

- (void)fillPictures
{
    //    NSLog(@"FILL PICTURES");
    item = 0;
    row = 0;
    col = 0;
    for (item=0;item<self.myPosts.count;item++) {
        
        UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
        UITapGestureRecognizer *tapTrice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapThrice:)];
        
        tapOnce.numberOfTapsRequired = 1;
        tapTwice.numberOfTapsRequired = 2;
        tapTrice.numberOfTapsRequired = 3;
        //stops tapOnce from overriding tapTwice
        [tapOnce requireGestureRecognizerToFail:tapTrice];
        [tapTwice requireGestureRecognizerToFail:tapTrice];
        
        if ([[self.myPosts[item] objectForKey:@"postType"] isEqualToString:@"started hunt"]) {
            
            _button = [[YookaButton alloc] initWithFrame:CGRectMake(col,
                                                                  contentSize3+300,
                                                                 yookaThumbnailWidth2000,
                                                                 305)];
            contentSize3 += 305;
            
        }else{
            _button = [[YookaButton alloc] initWithFrame:CGRectMake(col,
                                                                 contentSize3+300,
                                                                 yookaThumbnailWidth2000,
                                                                 325)];
            contentSize3 += 325;
            
        }
        
        _button.tag = item;
        [_button setBackgroundColor:[self colorWithHexString:@"f0f0f0"]];
        _button.userInteractionEnabled = YES;
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_button addGestureRecognizer:tapOnce]; //remove the other button action which calls method `button`
        [_button addGestureRecognizer:tapTwice];
        [_button addGestureRecognizer:tapTrice];
        
        row++;
        
        [self.feedScrollView addSubview:_button];
        [self.thumbnails addObject:_button];
        
        [self.feedScrollView setContentSize:CGSizeMake(320, contentSize3+340)];
        
    }
    
    self.feedView.frame = CGRectMake(0, 300, 320, 300+586);
    
    [self loadImages];
    
}

- (void)tapOnce:(id)sender
{
//    NSLog(@"Tap once");
}

- (void)tapTwice:(id)sender
{
//    NSLog(@"Tap twice2");
}

- (void)tapThrice:(id)sender
{
//    NSLog(@"Tap thrice");
}

- (void)tapTwice2:(id)sender
{
    
//    NSLog(@"Tap twice");
    UIButton* button1 = sender;
    NSUInteger b = button1.tag;
    //NSLog(@"b=%lu",(unsigned long)b);
    //    NSLog(@"post data = %@",_newsFeed[view.tag]);
    //    NSLog(@"likes data = %@",_likesData);
    //    NSLog(@"likers data = %@",_likersData);
    _postLikers = [NSMutableArray new];
        
       // NSLog(@"index = %lu",(unsigned long)b);
    UIButton* button = [self.thumbnails objectAtIndex:b];
        
    //NSLog(@"button subviews = %@",[button viewWithTag:220]);
    [[button viewWithTag:220] removeFromSuperview];
    // [[button viewWithTag:221] removeFromSuperview];
    //[[button viewWithTag:221] removeFromSuperview];
    // [[button viewWithTag:221] removeFromSuperview];
    
    UIImageView *red_heart2 = [[UIImageView alloc]initWithFrame:CGRectMake(259, 224+45, 37, 37)];
    red_heart2.image = [UIImage imageNamed:@"Before_like.png"];
   // [button addSubview:red_heart2];
    
        _postId = [self.myPosts[b] objectForKey:@"_id"];
        
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
                [self.feedScrollView setUserInteractionEnabled:YES];
                
            }
        }
    } withProgressBlock:nil];
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




- (void)loadImages
{
    
    //    NSLog(@"load images");
    if (m<self.myPosts.count) {
        
        NSString *dishPicUrl = [[self.myPosts[m] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
        //NSString *userId = [self.myPosts[i] objectForKey:@"userEmail"];
        //[_userEmails addObject:userId];
        //        NSLog(@"newsfeed = %@",self.myPosts[i]);
        NSString *dishName = [self.myPosts[m] objectForKey:@"dishName"];
        //        NSString *venueName = [self.myPosts[i] objectForKey:@"venueName"];
        //        NSString *venueAddress = [self.myPosts[i] objectForKey:@"venueAddress"];
        NSString *caption = [self.myPosts[m] objectForKey:@"caption"];
        NSString *post_vote = [self.myPosts[m] objectForKey:@"postVote"];
        NSString *kinveyId = [self.myPosts[m] objectForKey:@"_id"];
        NSString *hunt_name = [self.myPosts[m] objectForKeyedSubscript:@"HuntName"];
        
        YookaButton *button = [self.thumbnails objectAtIndex:m];
        
        [button setBackgroundColor:[self colorWithHexString:@"f0f0f0"]]; //a7a7a7
        
        [button setUserInteractionEnabled:YES];
        
        if ([[self.myPosts[m] objectForKey:@"postType"] isEqualToString:@"started hunt"]) {
            
            NSString *hunt_pic_url = [self.myPosts[m] objectForKey:@"huntPicUrl"];
            
            UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 55, 305, 225)];
            [buttonImage setBackgroundColor:[UIColor clearColor]];
            buttonImage.contentMode = UIViewContentModeScaleAspectFill;
            //buttonImage.layer.cornerRadius = 5.0;
            buttonImage.clipsToBounds = YES;
            buttonImage.opaque = YES;
            buttonImage.image = nil;
            
            UIImageView *whitebox = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 10, 305, 45)];
            [whitebox setBackgroundColor:[UIColor whiteColor]];
            whitebox.layer.shadowRadius = 0;
            whitebox.layer.shadowOpacity = 1;
            whitebox.layer.shadowOffset = CGSizeMake(0.0, 1.0);
            whitebox.layer.masksToBounds = NO;
            whitebox.layer.shadowColor = [[[self colorWithHexString:@"bdbdbd"]colorWithAlphaComponent:0.6f]CGColor];
            [button addSubview:whitebox];
            
            UIImageView *whitebox2 = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 280, 305, 10)];
            [whitebox2 setBackgroundColor:[UIColor whiteColor]];
            whitebox2.layer.shadowRadius = 0;
            whitebox2.layer.shadowOpacity = 1;
            whitebox2.layer.shadowOffset = CGSizeMake(0.0, 1.0);
            whitebox2.layer.masksToBounds = NO;
            whitebox2.layer.shadowColor = [[[self colorWithHexString:@"bdbdbd"]colorWithAlphaComponent:0.6f]CGColor];
            [button addSubview:whitebox2];
            
            NSDate *createddate = [self.myPosts[m] objectForKey:@"postDate"];
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

            
            
            [[SDImageCache sharedImageCache] queryDiskCacheForKey:kinveyId done:^(UIImage *image, SDImageCacheType cacheType)
             {
                 // image is not nil if image was found
                 if (image) {
                     
                     buttonImage.image = image;
                     [button addSubview:buttonImage];
                     
                     [self.imagesArray addObject:image];
                     
                     self.pics_options_button = [[YookaButton alloc]initWithFrame:CGRectMake(287, 267, 26, 13)];
                     UIColor * color4 = [self colorWithHexString:@"9a8e92"];
                     [self.pics_options_button setBackgroundColor:color4];
                     self.pics_options_button.tag = m;
                     self.pics_options_button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
                     [self.pics_options_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [self.pics_options_button addTarget:self action:@selector(pics_options:) forControlEvents:UIControlEventTouchUpInside];
                     [button addSubview:self.pics_options_button];
                     
                     UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake(289, 249, 33, 29)];
                     dot.text= @".";
                     dot.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot.textColor=[UIColor whiteColor];
                     [button addSubview:dot];
                     
                     UILabel *dot2 = [[UILabel alloc]initWithFrame:CGRectMake(296, 249, 33, 29)];
                     dot2.text= @".";
                     dot2.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot2.textColor=[UIColor whiteColor];
                     [button addSubview:dot2];
                     
                     UILabel *dot3 = [[UILabel alloc]initWithFrame:CGRectMake(303, 249, 33, 29)];
                     dot3.text= @".";
                     dot3.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot3.textColor=[UIColor whiteColor];
                     [button addSubview:dot3];
                     
                     UIButton *cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
                     cover_button.frame = CGRectMake(260, 260, 50, 20);
                     [cover_button setBackgroundColor:[UIColor clearColor]];
                     cover_button.tag = m;
                     [cover_button addTarget:self action:@selector(pics_options:) forControlEvents:UIControlEventTouchUpInside];
                     [button addSubview:cover_button];
                     
                     //don't need subscribe in your own profile
                     //                     UIButton *joinButton = [UIButton buttonWithType:UIButtonTypeCustom];
                     //                     [joinButton setFrame:CGRectMake(80, 45+250-2, 145, 45)];
                     //                     [joinButton setBackgroundColor:[UIColor clearColor]];
                     //                     [joinButton setTag:m];
                     //                     NSLog(@"sub hunts = %@",self.subscribedHunts);
                     //                    UIImageView *joinBtn = [[UIImageView alloc]initWithFrame:CGRectMake(80, 45+250-2,45,45)];
                     //                    joinBtn.image=[UIImage imageNamed:@"activate_icon.png"];
                     //                    [button addSubview:joinBtn];
                     //                         //[joinButton setBackgroundImage:[[UIImage imageNamed:@"activate_icon.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
                     //                     [joinButton addTarget:self action:@selector(gotoFeaturedHunts:)
                     //                          forControlEvents:UIControlEventTouchUpInside];
                     //                     [button addSubview:joinButton];
                     //                         NSString *myString1 =@"ACTIVE";
                     //
                     //                         UILabel* sub_label = [[UILabel alloc] initWithFrame:CGRectMake(130, 45+250, 200, 35)];
                     //                         sub_label.text = [NSString stringWithFormat:@"%@",myString1];
                     //                         sub_label.textColor = [UIColor lightGrayColor];
                     //                         [sub_label setFont:[UIFont fontWithName:@"Helvetica" size:19]];
                     //                         sub_label.textAlignment = NSTextAlignmentLeft;
                     //                         [button addSubview:sub_label];
                     
                     
                     [self.feedScrollView addSubview:button];
                     
                     m++;
                     if (m==self.myPosts.count) {
                         [self loadImages2];
                     }
                     [self loadImages];
                     
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
                              //                                                      NSLog(@"found image");
                              
                              [[SDImageCache sharedImageCache] storeImage:image forKey:kinveyId];
                              
                              buttonImage.image = image;
                              [button addSubview:buttonImage];
                              
                              [self.imagesArray addObject:image];
                              
                              self.pics_options_button = [[YookaButton alloc]initWithFrame:CGRectMake(287, 267, 26, 13)];
                              UIColor * color4 = [self colorWithHexString:@"9a8e92"];
                              [self.pics_options_button setBackgroundColor:color4];
                              self.pics_options_button.tag = m;
                              self.pics_options_button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
                              [self.pics_options_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                              [self.pics_options_button addTarget:self action:@selector(pics_options:) forControlEvents:UIControlEventTouchUpInside];
                              [button addSubview:self.pics_options_button];
                              
                              UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake(289, 249, 33, 29)];
                              dot.text= @".";
                              dot.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                              dot.textColor=[UIColor whiteColor];
                              [button addSubview:dot];
                              
                              UILabel *dot2 = [[UILabel alloc]initWithFrame:CGRectMake(296, 249, 33, 29)];
                              dot2.text= @".";
                              dot2.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                              dot2.textColor=[UIColor whiteColor];
                              [button addSubview:dot2];
                              
                              UILabel *dot3 = [[UILabel alloc]initWithFrame:CGRectMake(303, 249, 33, 29)];
                              dot3.text= @".";
                              dot3.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                              dot3.textColor=[UIColor whiteColor];
                              [button addSubview:dot3];
                              
                              UIButton *cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
                              cover_button.frame = CGRectMake(260, 260, 50, 20);
                              [cover_button setBackgroundColor:[UIColor clearColor]];
                              cover_button.tag = m;
                              [cover_button addTarget:self action:@selector(pics_options:) forControlEvents:UIControlEventTouchUpInside];
                              [button addSubview:cover_button];
                              
                              [self.feedScrollView addSubview:button];
                              
                              m++;
                              
                              if (m==self.myPosts.count) {
                                  [self loadImages2];
                              }
                              
                              [self loadImages];
                          }else{
                              m++;
                              
                              if (m==self.myPosts.count) {
                                  [self loadImages2];
                              }
                              
                              [self loadImages];
                          }
                      }];
                     
                 }
             }];
            
        }
        
        else{
            
            
            UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 55, 305, 210)];
            [buttonImage setBackgroundColor:[UIColor clearColor]];
            buttonImage.contentMode = UIViewContentModeScaleAspectFill;
            //buttonImage.layer.cornerRadius = 5.0;
            buttonImage.clipsToBounds = YES;
            buttonImage.opaque = YES;
            buttonImage.image = nil;
            
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

            NSDate *createddate = [self.myPosts[m] objectForKey:@"postDate"];
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
            
            [[SDImageCache sharedImageCache] queryDiskCacheForKey:kinveyId done:^(UIImage *image, SDImageCacheType cacheType)
             {
                 // image is not nil if image was found
                 if (image) {
                     
                     //                NSLog(@"found cache");
                     
                     buttonImage.image = image;
                     [button addSubview:buttonImage];
                     
                     [self.imagesArray addObject:image];
                     
                     UIImageView *transparent_view = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 175+45, 305, 45)];
                     transparent_view.backgroundColor = [[self colorWithHexString:@"4c4a4a"] colorWithAlphaComponent:0.5f];
                     [button addSubview:transparent_view];
                     
                     self.pics_options_button = [[YookaButton alloc]initWithFrame:CGRectMake(287, 252, 26, 13)];
                     UIColor * color4 = [self colorWithHexString:@"9a8e92"];
                     [self.pics_options_button setBackgroundColor:color4];
                     self.pics_options_button.tag = m;
                     self.pics_options_button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
                     //                     [self.pics_options_button setTitle:@"..." forState:UIControlStateNormal];
                     [self.pics_options_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                     [self.pics_options_button addTarget:self action:@selector(pics_options:) forControlEvents:UIControlEventTouchUpInside];
                     [button addSubview:self.pics_options_button];
                     
                     UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake(289, 234, 33, 29)];
                     dot.text= @".";
                     dot.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot.textColor=[UIColor whiteColor];
                     [button addSubview:dot];
                     
                     UILabel *dot2 = [[UILabel alloc]initWithFrame:CGRectMake(296, 234, 33, 29)];
                     dot2.text= @".";
                     dot2.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot2.textColor=[UIColor whiteColor];
                     [button addSubview:dot2];
                     
                     UILabel *dot3 = [[UILabel alloc]initWithFrame:CGRectMake(303, 234, 33, 29)];
                     dot3.text= @".";
                     dot3.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                     dot3.textColor=[UIColor whiteColor];
                     [button addSubview:dot3];
                     
                     UIButton *cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
                     cover_button.frame = CGRectMake(260, 245, 50, 20);
                     [cover_button setBackgroundColor:[UIColor clearColor]];
                     cover_button.tag = m;
                     [cover_button addTarget:self action:@selector(pics_options:) forControlEvents:UIControlEventTouchUpInside];
                     [button addSubview:cover_button];
                     
                     if ([[self.myPosts[m] objectForKey:@"postType"] isEqualToString:@"hunt"]) {
                         
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
                     
                     captionLabel.backgroundColor = [UIColor clearColor];
                     [button addSubview:captionLabel];
                     
                     [self.feedScrollView addSubview:button];
                     
                     m++;
                     if (m==self.myPosts.count) {
                         [self loadImages2];
                     }
                     [self loadImages];
                     
                 }else{
                     
                     //                NSLog(@"no cache");
                     
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
                              buttonImage.image = image;
                              [button addSubview:buttonImage];
                              
                              [[SDImageCache sharedImageCache] storeImage:image forKey:kinveyId];
                              
                              [self.imagesArray addObject:image];
                              
                              UIImageView *transparent_view = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 175+45, 305, 45)];
                              transparent_view.backgroundColor = [[self colorWithHexString:@"4c4a4a"] colorWithAlphaComponent:0.5f];
                              [button addSubview:transparent_view];
                              
                              self.pics_options_button = [[YookaButton alloc]initWithFrame:CGRectMake(287, 252, 26, 13)];
                              UIColor * color4 = [self colorWithHexString:@"9a8e92"];
                              [self.pics_options_button setBackgroundColor:color4];
                              self.pics_options_button.tag = m;
                              self.pics_options_button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0];
                              //                     [self.pics_options_button setTitle:@"..." forState:UIControlStateNormal];
                              [self.pics_options_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                              [self.pics_options_button addTarget:self action:@selector(pics_options:) forControlEvents:UIControlEventTouchUpInside];
                              [button addSubview:self.pics_options_button];
                              
                              UILabel *dot = [[UILabel alloc]initWithFrame:CGRectMake(289, 234, 33, 29)];
                              dot.text= @".";
                              dot.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                              dot.textColor=[UIColor whiteColor];
                              [button addSubview:dot];
                              
                              UILabel *dot2 = [[UILabel alloc]initWithFrame:CGRectMake(296, 234, 33, 29)];
                              dot2.text= @".";
                              dot2.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                              dot2.textColor=[UIColor whiteColor];
                              [button addSubview:dot2];
                              
                              UILabel *dot3 = [[UILabel alloc]initWithFrame:CGRectMake(303, 234, 33, 29)];
                              dot3.text= @".";
                              dot3.font = [UIFont fontWithName:@"OpenSans" size:29.f];
                              dot3.textColor=[UIColor whiteColor];
                              [button addSubview:dot3];
                              
                              UIButton *cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
                              cover_button.frame = CGRectMake(260, 245, 50, 20);
                              [cover_button setBackgroundColor:[UIColor clearColor]];
                              cover_button.tag = m;
                              [cover_button addTarget:self action:@selector(pics_options:) forControlEvents:UIControlEventTouchUpInside];
                              [button addSubview:cover_button];
                              
                              
                              if ([[self.myPosts[m] objectForKey:@"postType"] isEqualToString:@"hunt"]) {
                                  
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
                              
                              captionLabel.backgroundColor = [UIColor clearColor];
                              [button addSubview:captionLabel];
                              
                              [self.feedScrollView addSubview:button];
                              
                              m++;
                              
                              if (m==self.myPosts.count) {
                                  //                                  [self loadImages2];
                              }
                              
                              [self loadImages];
                          }else{
                              
                              [self.feedScrollView addSubview:button];
                              
                              m++;
                              
                              if (m==self.myPosts.count) {
                                  [self loadImages2];
                              }
                              
                              [self loadImages];
                          }
                      }];
                     
                 }
             }];
            
        }
        
    }
    
}


- (void)gotoFeaturedHunts:(id)sender{
    
    UIButton* button = sender;
    NSUInteger b = button.tag;
    NSLog(@"button %lu pressed",(unsigned long)b);
    NSString *hunt_name;
    
    hunt_name = [self.myPosts[b] objectForKeyedSubscript:@"HuntName"];
    
    NSLog(@"hunt name = %@",hunt_name);
    
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
    
}



- (void)loadImages2
{
    //    NSLog(@"load images");
    if (n<self.myPosts.count) {
        //        NSLog(@"hahahah");
        //        NSString *dishPicUrl = [[_newsFeed[i] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
        //        NSString *caption = [_newsFeed[j] objectForKey:@"caption"];
        NSString *venueName = [self.myPosts[n] objectForKey:@"venueName"];
        NSString *venueAddress = [self.myPosts[n] objectForKey:@"venueAddress"];
        NSString *venueState = [self.myPosts[n] objectForKey:@"venueState"];
        NSString *hunt_name = [self.myPosts[n] objectForKeyedSubscript:@"HuntName"];
        
        
        YookaButton* button = [self.thumbnails objectAtIndex:n];
        [button setUserInteractionEnabled:YES];
        
        [button setBackgroundColor:[self colorWithHexString:@"f0f0f0"]];
        
        
        
        
        NSString *userId = [self.myPosts[n] objectForKey:@"userEmail"];
        
        if ([[self.myPosts[n] objectForKey:@"postType"] isEqualToString:@"started hunt"]) {
            
            
            [[SDImageCache sharedImageCache] queryDiskCacheForKey:userId done:^(UIImage *image, SDImageCacheType cacheType)
             {
                 if(image){
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
                     user_button.tag = n;
                     [user_button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
                     [button addSubview:user_button];
                     
                     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                     NSString *userFullName = [ud objectForKey:userId];
                     
                     UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 25, 240, 30)];
                     userLabel.textColor = [UIColor lightGrayColor];
                     userLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
                     
                     if (userFullName) {
                         
                         if ([self.myPosts[n] objectForKey:@"postType"]) {
                             userLabel.text = [[self.myPosts[n] objectForKey:@"postCaption"] capitalizedString];
                             userLabel.text=[userLabel.text uppercaseString];
                             
                         }else{
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
                         
                         [self.feedScrollView addSubview:button];
                         
                         n++;
                         
                         if (n == self.myPosts.count) {
                             
                             [self loadlikes];
                         }
                         [self loadImages2];
                         
                     }else{
                         
                         _collectionName2 = @"userPicture";
                         _customEndpoint2 = @"NewsFeed";
                         _fieldName2 = @"_id";
                         _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"userEmail",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
                         
                         //        [[button subviews]
                         //         makeObjectsPerformSelector:@selector(removeFromSuperview)];
                         
                         [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
                             if ([results isKindOfClass:[NSArray class]]) {
                                 NSArray *results_array = [NSArray arrayWithArray:results];
                                 if (results_array && results_array.count) {
                                     
                                     //                                     NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                                     NSString *userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                                     //                                     [_userPicUrls addObject:userPicUrl];
                                     NSString *userFullName = [results[0] objectForKey:@"userFullName"];
                                     //                                     [_userNames addObject:userFullName];
                                     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                     [ud setObject:userFullName forKey:userId];
                                     NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
                                     [ud setObject:userPicUrl forKey:userId2];
                                     [ud synchronize];
                                     
                                     if ([self.myPosts[n] objectForKey:@"postType"]) {
                                         userLabel.text = [[self.myPosts[n] objectForKey:@"postCaption"] capitalizedString];
                                         userLabel.text=[userLabel.text uppercaseString];
                                         
                                     }else{
                                         //                             userLabel.text = [NSString stringWithFormat:@"%@ is at %@",userFullName,venueName];
                                     }
                                     [userLabel setBackgroundColor:[UIColor clearColor]];
                                     userLabel.textAlignment = NSTextAlignmentLeft;
                                     userLabel.adjustsFontSizeToFitWidth = YES;
                                     userLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
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
                                     
                                     [self.feedScrollView addSubview:button];
                                     
                                     n++;
                                     if (n == self.myPosts.count) {
                                         
                                         [self loadlikes];
                                     }
                                     [self loadImages2];
                                     
                                 }else{
                                     
                                     [self.feedScrollView addSubview:button];
                                     
                                     n++;
                                     if (n == self.myPosts.count) {
                                         
                                         [self loadlikes];
                                     }
                                     [self loadImages2];
                                     
                                 }
                                 
                             }else{
                                 
                                 [self.feedScrollView addSubview:button];
                                 
                                 n++;
                                 if (n == self.myPosts.count) {
                                     
                                     [self loadlikes];
                                 }
                                 [self loadImages2];
                                 
                             }
                             
                         }];
                         
                     }
                     
                 }else{
                     
                     //                 NSLog(@"no cache");
                     _collectionName2 = @"userPicture";
                     _customEndpoint2 = @"NewsFeed";
                     _fieldName2 = @"_id";
                     _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"userEmail",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
                     
                     //        [[button subviews]
                     //         makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     
                     [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
                         if ([results isKindOfClass:[NSArray class]]) {
                             NSArray *results_array = [NSArray arrayWithArray:results];
                             if (results_array && results_array.count) {
                                 //                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                                 NSString *userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                                 //                                 [_userPicUrls addObject:userPicUrl];
                                 NSString *userFullName = [results[0] objectForKey:@"userFullName"];
                                 //                                 [_userNames addObject:userFullName];
                                 NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                 [ud setObject:userFullName forKey:userId];
                                 NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
                                 [ud setObject:userPicUrl forKey:userId2];
                                 [ud synchronize];
                                 
                                 if (userPicUrl) {
                                     
                                     //                                     UIImageView *buttonImage3 = [[UIImageView alloc]initWithFrame:CGRectMake( 4.5, 5, 34, 39)];
                                     //                                     buttonImage3.image = [UIImage imageNamed:@"regular_timeline_imagesize.png"];
                                     //                                     [button addSubview:buttonImage3];
                                     
                                     UIImageView *buttonImage4 = [[UIImageView alloc]initWithFrame:CGRectMake( 4.5, 10-7.5, 38, 38)];
                                     buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                                     [buttonImage4.layer setBorderWidth:2.0];
                                     buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                                     [buttonImage4.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                                     [buttonImage4 setContentMode:UIViewContentModeScaleAspectFit];
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
                                              
                                              //                                              UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                              //                                              [user_button  setFrame:CGRectMake(5, 5-7.5, 38, 38)];
                                              //                                              [user_button setBackgroundColor:[UIColor redColor]];
                                              //                                              user_button.tag = n;
                                              //                                              [user_button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
                                              //                                              [button addSubview:user_button];
                                              
                                              UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(53, 7, 260, 30)];
                                              userLabel.textColor = [UIColor whiteColor];
                                              userLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
                                              if ([self.myPosts[n] objectForKey:@"postType"]) {
                                                  userLabel.text = [[self.myPosts[n] objectForKey:@"postCaption"] uppercaseString];
                                                  
                                              }else{
                                                  //                             userLabel.text = [NSString stringWithFormat:@"%@ is at %@",userFullName,venueName];
                                              }
                                              [userLabel setBackgroundColor:[UIColor clearColor]];
                                              userLabel.textAlignment = NSTextAlignmentLeft;
                                              userLabel.adjustsFontSizeToFitWidth = YES;
                                              //                     userLabel.numberOfLines = 0;
                                              [button addSubview:userLabel];
                                              
                                              [self.feedScrollView addSubview:button];
                                              n++;
                                              if (n == self.myPosts.count) {
                                                  
                                                  [self loadlikes];
                                              }
                                              
                                              [self loadImages2];
                                          }else{
                                              j++;
                                              
                                              if (n == self.myPosts.count) {
                                                  
                                                  [self loadlikes];
                                              }
                                              [self loadImages2];
                                          }
                                          
                                      }];
                                     
                                     //                                     }
                                     //                                 }];
                                     
                                 }else{
                                     
                                     //                        NSLog(@"fail 3");
                                     n++;
                                     
                                     if (n == self.myPosts.count) {
                                         
                                         [self loadlikes];
                                     }
                                     [self loadImages2];
                                     
                                 }
                                 
                                 
                             }else{
                                 //                    NSLog(@"fail 1");
                                 n++;
                                 if (n == self.myPosts.count) {
                                     
                                     [self loadlikes];
                                 }
                                 
                                 [self loadImages2];
                             }
                             
                         }else{
                             
                             //                NSLog(@"fail 2");
                             n++;
                             if (n == self.myPosts.count) {
                                 
                                 [self loadlikes];
                             }
                             
                             [self loadImages2];
                             
                         }
                     }];
                     
                 }
             }];
            
        }
        
        
        else{
            
            if (venueName){
                
                UIButton *rest_arrow = [UIButton buttonWithType:UIButtonTypeCustom];
                [rest_arrow  setFrame:CGRectMake(80, 10, 220, 45)];
                [rest_arrow setBackgroundColor:[UIColor clearColor]];
                rest_arrow.tag = n;
                [rest_arrow addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
                [button addSubview:rest_arrow];
                
            }
            
            [[SDImageCache sharedImageCache] queryDiskCacheForKey:userId done:^(UIImage *image, SDImageCacheType cacheType)
             {
                 if(image){
                     UIImageView *buttonImage4 = [[UIImageView alloc]initWithFrame:CGRectMake( 12, 10, 55, 55)];
                     buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                     [buttonImage4.layer setBorderWidth:2.0];
                     [buttonImage4.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                     [buttonImage4 setContentMode:UIViewContentModeScaleAspectFill];
                     buttonImage4.clipsToBounds = YES;
                     buttonImage4.image = image;
                     buttonImage4.opaque = YES;
                     
                     buttonImage4.image = image;
                     [button addSubview:buttonImage4];
                     
                     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                     NSString *userFullName = [ud objectForKey:userId];
                     
                     if (userFullName) {
                         
                         UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
                         [user_button  setFrame:CGRectMake(12, 5, 55, 55)];
                         [user_button setBackgroundColor:[UIColor clearColor]];
                         user_button.tag = n;
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
                         
                         if ([self.myPosts[n] objectForKey:@"postType"]) {
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
                         
                         
                         [self.feedScrollView addSubview:button];
                         
                         n++;
                         if (n == self.myPosts.count) {
                             
                             [self loadlikes];
                         }
                         
                         [self loadImages2];
                         
                     }
                     
                     
                     else{
                         
                         _collectionName2 = @"userPicture";
                         _customEndpoint2 = @"NewsFeed";
                         _fieldName2 = @"_id";
                         _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"userEmail",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
                         
                         //        [[button subviews]
                         //         makeObjectsPerformSelector:@selector(removeFromSuperview)];
                         
                         [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
                             if ([results isKindOfClass:[NSArray class]]) {
                                 NSArray *results_array = [NSArray arrayWithArray:results];
                                 if (results_array && results_array.count) {
                                     
                                     //                    NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                                     NSString *userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                                     //                                     [_userPicUrls addObject:userPicUrl];
                                     NSString *userFullName = [results[0] objectForKey:@"userFullName"];
                                     //                                     [_userNames addObject:userFullName];
                                     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                     [ud setObject:userFullName forKey:userId];
                                     NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
                                     [ud setObject:userPicUrl forKey:userId2];
                                     [ud synchronize];
                                     
                                     UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                     [user_button  setFrame:CGRectMake(12, 5, 55, 55)];
                                     [user_button setBackgroundColor:[UIColor clearColor]];
                                     user_button.tag = n;
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
                                     
                                     if ([self.myPosts[n] objectForKey:@"postType"]) {
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
                                     
                                     
                                     [self.feedScrollView addSubview:button];
                                     
                                     n++;
                                     if (n == self.myPosts.count) {
                                         
                                         [self loadlikes];
                                     }
                                     
                                     [self loadImages2];
                                     
                                 }else{
                                     
                                     [self.feedScrollView addSubview:button];
                                     
                                     n++;
                                     if (n == self.myPosts.count) {
                                         
                                         [self loadlikes];
                                     }
                                     
                                     [self loadImages2];
                                     
                                 }
                                 
                             }else{
                                 
                                 [self.feedScrollView addSubview:button];
                                 
                                 n++;
                                 if (n == self.myPosts.count) {
                                     
                                     [self loadlikes];
                                 }
                                 
                                 [self loadImages2];
                                 
                             }
                             
                         }];
                         
                     }
                     
                 }
                 
                 
                 else{
                     
                     //                 NSLog(@"no cache");
                     _collectionName2 = @"userPicture";
                     _customEndpoint2 = @"NewsFeed";
                     _fieldName2 = @"_id";
                     _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"userEmail",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
                     
                     //        [[button subviews]
                     //         makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     
                     [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
                         if ([results isKindOfClass:[NSArray class]]) {
                             NSArray *results_array = [NSArray arrayWithArray:results];
                             if (results_array && results_array.count) {
                                 //                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                                 NSString *userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                                 //                                 [_userPicUrls addObject:userPicUrl];
                                 NSString *userFullName = [results[0] objectForKey:@"userFullName"];
                                 //                                 [_userNames addObject:userFullName];
                                 NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                 [ud setObject:userFullName forKey:userId];
                                 NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
                                 [ud setObject:userPicUrl forKey:userId2];
                                 [ud synchronize];
                                 
                                 if (userPicUrl) {
                                     
                                     
                                     
                                     UIImageView *buttonImage4 = [[UIImageView alloc]initWithFrame:CGRectMake( 12, 10, 55, 55)];
                                     buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                                     [buttonImage4.layer setBorderWidth:2.0];
                                     buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                                     [buttonImage4.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                                     [buttonImage4 setContentMode:UIViewContentModeScaleAspectFill];
                                     buttonImage4.clipsToBounds = YES;
                                     buttonImage4.image = image;
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
                                              user_button.tag = n;
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
                                              
                                              
                                              if ([self.myPosts[n] objectForKey:@"postType"]) {
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
                                              
                                              
                                              [self.feedScrollView addSubview:button];
                                              
                                              n++;
                                              if (n == self.myPosts.count) {
                                                  
                                                  [self loadlikes];
                                              }
                                              
                                              [self loadImages2];
                                          }else{
                                              n++;
                                              if (n == self.myPosts.count) {
                                                  
                                                  [self loadlikes];
                                              }
                                              
                                              [self loadImages2];
                                          }
                                          
                                      }];
                                     
                                     //                                     }
                                     //                                 }];
                                     
                                 }else{
                                     
                                     //                        NSLog(@"fail 3");
                                     n++;
                                     if (n == self.myPosts.count) {
                                         
                                         [self loadlikes];
                                         
                                         //                                    [self stopActivityIndicator];
                                         //        NSLog(@"user pic url = %@",_userPicUrls);
                                         
                                     }
                                     
                                     [self loadImages2];
                                     
                                 }
                                 
                                 
                             }else{
                                 //                    NSLog(@"fail 1");
                                 n++;
                                 if (n == self.myPosts.count) {
                                     
                                     [self loadlikes];
                                     
                                     //                                [self stopActivityIndicator];
                                     //        NSLog(@"user pic url = %@",_userPicUrls);
                                     
                                 }
                                 
                                 [self loadImages2];
                             }
                             
                         }else{
                             
                             //                NSLog(@"fail 2");
                             n++;
                             if (n == self.myPosts.count) {
                                 
                                 [self loadlikes];
                                 
                                 
                             }
                             
                             [self loadImages2];
                             
                         }
                     }];
                     
                 }
             }];
            
        }
        
    }
    
}

- (void)loadlikes{
    
    if(p<self.myPosts.count){
        
        //        YookaBackend *yooka4 = _newsFeed[k];
        
        if ([[self.myPosts[p] objectForKey:@"postType"] isEqualToString:@"started hunt"]) {
            p++;
            
            [self loadlikes];
            
        }else{
            
            NSString *kinveyId = [self.myPosts[p] objectForKey:@"_id"];
            //        NSLog(@"kinveyId = %@",kinveyId);
            
            YookaButton* button = [self.thumbnails objectAtIndex:p];
            
            [button setUserInteractionEnabled:YES];
            
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
                            
                            if([myArray containsObject:_myEmail]){
                                
                                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(250, 225+45, 40, 40)];
                                likesImageView.backgroundColor=[UIColor clearColor];
                                [likesImageView setTag:220];
                                likesImageView.image = [UIImage imageNamed:@"full_heart.png"];
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
                                like_button.tag = p;
                                [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                                [button addSubview:like_button];
                                p++;
                                
                                [self loadlikes];
                                
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
                                like_button.tag = p;
                                [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                                [button addSubview:like_button];
                                p++;
                                
                                [self loadlikes];
                                
                            }
                            
                        }else{
                            
                            _likes = @"0";
                            
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
                            likesLabel.font=[UIFont fontWithName:@"OpenSans" size:5];
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
                            like_button.tag = p;
                            [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                            [button addSubview:like_button];
                            p++;
                            
                            [self loadlikes];
                            
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
                        like_button.tag = p;
                        [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                        [button addSubview:like_button];
                        p++;
                        
                        [self loadlikes];
                        
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
                    like_button.tag = p;
                    [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                    [button addSubview:like_button];
                    p++;
                    
                    [self loadlikes];
                    
                }
            } withProgressBlock:nil];
            
        }
        
    }
  
    
}

- (void)hunts_options:(id)sender
{

    UIButton* button = sender;
    NSUInteger b = button.tag;
    
    self.profileScrollView.scrollEnabled = NO;
    
    self.modal_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.modal_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35f];
    [self.modal_view setUserInteractionEnabled:YES];
    [self.view addSubview:self.modal_view];
    
    UIImageView *offwhite_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 400, 320, 168)];
    [offwhite_bg setBackgroundColor:[self colorWithHexString:@"faebd7"]];
    [self.modal_view addSubview:offwhite_bg];
    
    self.private_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.private_btn  setFrame:CGRectMake(10, 480, 300, 30)];
    [self.private_btn setBackgroundColor:[UIColor whiteColor]];
    [self.private_btn setTitle:@"Make this hunt private" forState:UIControlStateNormal];
    [self.private_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.private_btn addTarget:self action:@selector(private_btn:) forControlEvents:UIControlEventTouchUpInside];
    self.private_btn.tag = b;
    [self.view addSubview:self.private_btn];
    
    self.public_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.public_btn  setFrame:CGRectMake(10, 440, 300, 30)];
    [self.public_btn setBackgroundColor:[UIColor whiteColor]];
    [self.public_btn setTitle:@"Make this hunt public" forState:UIControlStateNormal];
    [self.public_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.public_btn addTarget:self action:@selector(public_btn:) forControlEvents:UIControlEventTouchUpInside];
    self.public_btn.tag = b;
    [self.view addSubview:self.public_btn];
    
    self.cancel_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel_btn  setFrame:CGRectMake(10, 520, 300, 30)];
    [_cancel_btn setBackgroundColor:[UIColor whiteColor]];
    [_cancel_btn setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancel_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_cancel_btn addTarget:self action:@selector(cancel_btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel_btn];
    
    self.cancel_btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel_btn_2  setFrame:CGRectMake(0, 0, 320, 400)];
    [_cancel_btn_2 setBackgroundColor:[UIColor clearColor]];
    [_cancel_btn_2 addTarget:self action:@selector(cancel_btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel_btn_2];

}

- (void)hunts_options_2:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;

    self.profileScrollView.scrollEnabled = NO;
    
    self.modal_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.modal_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35f];
    [self.modal_view setUserInteractionEnabled:YES];
    [self.view addSubview:self.modal_view];
    
    UIImageView *offwhite_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 400, 320, 168)];
    [offwhite_bg setBackgroundColor:[self colorWithHexString:@"faebd7"]];
    [self.modal_view addSubview:offwhite_bg];
    
    self.public_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.public_btn  setFrame:CGRectMake(10, 440, 300, 30)];
    [self.public_btn setBackgroundColor:[UIColor whiteColor]];
    [self.public_btn setTitle:@"Make this hunt public" forState:UIControlStateNormal];
    [self.public_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.public_btn addTarget:self action:@selector(public_btn_2:) forControlEvents:UIControlEventTouchUpInside];
    self.public_btn.tag = b;
    [self.view addSubview:self.public_btn];
    
    self.private_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.private_btn  setFrame:CGRectMake(10, 480, 300, 30)];
    [self.private_btn setBackgroundColor:[UIColor whiteColor]];
    [self.private_btn setTitle:@"Make this hunt private" forState:UIControlStateNormal];
    [self.private_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.private_btn addTarget:self action:@selector(private_btn_2:) forControlEvents:UIControlEventTouchUpInside];
    self.private_btn.tag = b;
    [self.view addSubview:self.private_btn];
    
    self.cancel_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel_btn  setFrame:CGRectMake(10, 520, 300, 30)];
    [_cancel_btn setBackgroundColor:[UIColor whiteColor]];
    [_cancel_btn setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancel_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_cancel_btn addTarget:self action:@selector(cancel_btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel_btn];
    
    self.cancel_btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel_btn_2  setFrame:CGRectMake(0, 0, 320, 400)];
    [_cancel_btn_2 setBackgroundColor:[UIColor clearColor]];
    [_cancel_btn_2 addTarget:self action:@selector(cancel_btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel_btn_2];
    
}

- (void)pics_options:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;

    self.profileScrollView.scrollEnabled = NO;
    
    self.modal_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    self.modal_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35f];
    [self.modal_view setUserInteractionEnabled:YES];
    [self.view addSubview:self.modal_view];
    
    UIImageView *offwhite_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 400, 320, 168)];
    [offwhite_bg setBackgroundColor:[self colorWithHexString:@"faebd7"]];
    [offwhite_bg setUserInteractionEnabled:YES];
    [self.modal_view addSubview:offwhite_bg];
    
//    self.private_btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.private_btn  setFrame:CGRectMake(10, 440, 300, 30)];
//    [self.private_btn setBackgroundColor:[UIColor whiteColor]];
//    [self.private_btn setTitle:@"Make this picture private" forState:UIControlStateNormal];
//    [self.private_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [self.private_btn addTarget:self action:@selector(private_btn:) forControlEvents:UIControlEventTouchUpInside];
//    self.private_btn.tag = b;
//    [self.view addSubview:self.private_btn];
    
    self.delete_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.delete_btn  setFrame:CGRectMake(10, 480, 300, 30)];
    [self.delete_btn setBackgroundColor:[UIColor whiteColor]];
    [self.delete_btn setTitle:@"Delete" forState:UIControlStateNormal];
    [self.delete_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.delete_btn addTarget:self action:@selector(delete_btn:) forControlEvents:UIControlEventTouchUpInside];
    self.delete_btn.tag = b;
    [self.view addSubview:self.delete_btn];
    
    self.cancel_btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel_btn  setFrame:CGRectMake(10, 520, 300, 30)];
    [_cancel_btn setBackgroundColor:[UIColor whiteColor]];
    [_cancel_btn setTitle:@"Cancel" forState:UIControlStateNormal];
    [_cancel_btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_cancel_btn addTarget:self action:@selector(cancel_btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel_btn];
    
    self.cancel_btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancel_btn_2  setFrame:CGRectMake(0, 0, 320, 400)];
    [_cancel_btn_2 setBackgroundColor:[UIColor clearColor]];
    [_cancel_btn_2 addTarget:self action:@selector(cancel_btn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cancel_btn_2];
}

- (void)public_btn:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
    NSMutableArray *updatedArray = [NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    updatedArray = [[defaults objectForKey:@"publicHunts"] mutableCopy];

    if (updatedArray) {
        if ([updatedArray containsObject:self.inProgressHuntNames[b]]) {
            
        }else{
            [updatedArray addObject:self.inProgressHuntNames[b]];
        }
    }else{
        updatedArray = [self.cachesubscribedHuntNames mutableCopy];
    }
    
    [defaults setObject:updatedArray forKey:@"publicHunts"];
    [defaults synchronize];
    
    YookaBackend *yooka = [[YookaBackend alloc]init];
    yooka.kinveyId = _myEmail;
    yooka.userEmail = _myEmail;
    yooka.HuntNames = self.cachesubscribedHuntNames;
    yooka.NotTriedHuntNames = self.cacheUnSubscribedHuntNames;
    yooka.public_hunts = updatedArray;
    [yooka.meta setGloballyReadable:YES];
    [yooka.meta setGloballyWritable:YES];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store saveObject:yooka withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
        } else {
            //save was successful
            NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            [self.modal_view removeFromSuperview];
            [self.private_btn removeFromSuperview];
            [self.public_btn removeFromSuperview];
            [self.delete_btn removeFromSuperview];
            [self.cancel_btn removeFromSuperview];
            [self.cancel_btn_2 removeFromSuperview];
            self.profileScrollView.scrollEnabled = YES;
        }
    } withProgressBlock:nil];
}

- (void)public_btn_2:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
    NSMutableArray *updatedArray = [NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    updatedArray = [[defaults objectForKey:@"publicHunts"] mutableCopy];
    
    if (updatedArray) {
        if ([updatedArray containsObject:self.finishedHuntNames[b]]) {
        }else{
            NSLog(@"need to add the public");
            [updatedArray addObject:self.finishedHuntNames[b]];
        }
    }else{
        updatedArray = [self.cachesubscribedHuntNames mutableCopy];
        NSLog(@"updated array 2 = %@",updatedArray);
    }
    
    [defaults setObject:updatedArray forKey:@"publicHunts"];
    [defaults synchronize];
    
    YookaBackend *yooka = [[YookaBackend alloc]init];
    yooka.kinveyId = _myEmail;
    yooka.userEmail = _myEmail;
    yooka.HuntNames = self.cachesubscribedHuntNames;
    yooka.NotTriedHuntNames = self.cacheUnSubscribedHuntNames;
    yooka.public_hunts = updatedArray;
    [yooka.meta setGloballyReadable:YES];
    [yooka.meta setGloballyWritable:YES];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store saveObject:yooka withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
        } else {
            //save was successful
            NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            [self.modal_view removeFromSuperview];
            [self.public_btn removeFromSuperview];
            [self.private_btn removeFromSuperview];
            [self.delete_btn removeFromSuperview];
            [self.cancel_btn removeFromSuperview];
            [self.cancel_btn_2 removeFromSuperview];
            self.profileScrollView.scrollEnabled = YES;
        }
    } withProgressBlock:nil];
}

- (void)private_btn:(id)sender
{
    NSLog(@"private hunt");
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
    NSMutableArray *updatedArray = [NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    updatedArray = [[defaults objectForKey:@"publicHunts"] mutableCopy];

    if (updatedArray) {
        if ([updatedArray containsObject:self.inProgressHuntNames[b]]) {
            [updatedArray removeObject:self.inProgressHuntNames[b]];
        }
    }else{
        updatedArray = [self.cachesubscribedHuntNames mutableCopy];
        [updatedArray removeObject:self.inProgressHuntNames[b]];
    }

    [defaults setObject:updatedArray forKey:@"publicHunts"];
    [defaults synchronize];
    
    YookaBackend *yooka = [[YookaBackend alloc]init];
    yooka.kinveyId = _myEmail;
    yooka.userEmail = _myEmail;
    yooka.HuntNames = self.cachesubscribedHuntNames;
    yooka.NotTriedHuntNames = self.cacheUnSubscribedHuntNames;
    yooka.public_hunts = updatedArray;
    [yooka.meta setGloballyReadable:YES];
    [yooka.meta setGloballyWritable:YES];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store saveObject:yooka withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
        } else {
            //save was successful
            NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            [self.modal_view removeFromSuperview];
            [self.public_btn removeFromSuperview];
            [self.private_btn removeFromSuperview];
            [self.delete_btn removeFromSuperview];
            [self.cancel_btn removeFromSuperview];
            [self.cancel_btn_2 removeFromSuperview];
            self.profileScrollView.scrollEnabled = YES;

        }
    } withProgressBlock:nil];
    
}

- (void)private_btn_2:(id)sender
{
//    NSLog(@"private pic 2");
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
//    NSLog(@"hunt name = %@",self.finishedHuntNames[b]);
//    NSLog(@"hunt no = %lu",(unsigned long)b);
    
    NSMutableArray *updatedArray = [NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    updatedArray = [[defaults objectForKey:@"publicHunts"] mutableCopy];
    
    if (updatedArray) {
        if ([updatedArray containsObject:self.finishedHuntNames[b]]) {
            [updatedArray removeObject:self.finishedHuntNames[b]];
        }
    }else{
        updatedArray = [self.cachesubscribedHuntNames mutableCopy];
        [updatedArray removeObject:self.finishedHuntNames[b]];
    }
    
    [defaults setObject:updatedArray forKey:@"publicHunts"];
    [defaults synchronize];
    
    YookaBackend *yooka = [[YookaBackend alloc]init];
    yooka.kinveyId = _myEmail;
    yooka.userEmail = _myEmail;
    yooka.HuntNames = self.cachesubscribedHuntNames;
    yooka.NotTriedHuntNames = self.cacheUnSubscribedHuntNames;
    yooka.public_hunts = updatedArray;
    [yooka.meta setGloballyReadable:YES];
    [yooka.meta setGloballyWritable:YES];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store saveObject:yooka withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
//            NSLog(@"Not saved event (error= %@).",errorOrNil);
        } else {
            //save was successful
//            NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            [self.modal_view removeFromSuperview];
            [self.public_btn removeFromSuperview];
            [self.private_btn removeFromSuperview];
            [self.delete_btn removeFromSuperview];
            [self.cancel_btn removeFromSuperview];
            [self.cancel_btn_2 removeFromSuperview];
            self.profileScrollView.scrollEnabled = YES;

        }
    } withProgressBlock:nil];
    
}

- (void)delete_btn:(id)sender
{
//    NSLog(@"delete pic");
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
    UIImage *btn_image = self.imagesArray[b];
    if (btn_image) {
//        NSLog(@"yes image");
    }
    
//    NSLog(@"hunt name = %@",self.myPosts[b]);
//    NSLog(@"hunt no = %lu",(unsigned long)b);

    NSString *kinvey_id = [self.myPosts[b] objectForKey:@"_id"];
    
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    KCSQuery* query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:kinvey_id];
    [self.updateStore queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
//            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
            YookaBackend *yooka = objectsOrNil[0];
            
            if ([[self.myPosts[b] objectForKey:@"postType"] isEqualToString:@"started hunt"]) {
                yookaObject.kinveyId = yooka.kinveyId;
                yookaObject.postDate = yooka.postDate;
                yookaObject.userEmail = yooka.userEmail;
                yookaObject.HuntName = yooka.HuntName;
                yookaObject.postType = yooka.postType;
                yookaObject.userFullName = yooka.userFullName;
                yookaObject.postCaption = yooka.postCaption;
                yookaObject.huntPicUrl = yooka.huntPicUrl;
                yookaObject.yooka_private = yooka.yooka_private;
                yookaObject.deleted = @"YES";
                //        [yookaObject.meta setGloballyReadable:YES];
                //        [yookaObject.meta setGloballyWritable:YES];
                
                //Kinvey use code: add a new update to the updates collection
                [self.updateStore saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    
                    if (errorOrNil == nil) {
                        
//                        NSLog(@"saved successfully");
                        [self.modal_view removeFromSuperview];
                        [self.public_btn removeFromSuperview];
                        [self.private_btn removeFromSuperview];
                        [self.delete_btn removeFromSuperview];
                        [self.cancel_btn removeFromSuperview];
                        [self.cancel_btn_2 removeFromSuperview];
                        self.profileScrollView.scrollEnabled = YES;
                        [self reloadNewsfeed:(int)b];

                    } else {
                        
                        BOOL wasNetworkError = [[errorOrNil domain] isEqual:KCSNetworkErrorDomain];
                        NSString* title = wasNetworkError ? NSLocalizedString(@"There was a network error.", @"network error title"): NSLocalizedString(@"An error occurred.", @"Generic error message");
                        NSString* message = wasNetworkError ? NSLocalizedString(@"Please wait a few minutes and try again.", @"try again error message") : [errorOrNil localizedDescription];
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                        message:message                                                           delegate:nil
                                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                              otherButtonTitles:nil];
                        [alert show];
                        [self.modal_view removeFromSuperview];
                        [self.public_btn removeFromSuperview];
                        [self.private_btn removeFromSuperview];
                        [self.delete_btn removeFromSuperview];
                        [self.cancel_btn removeFromSuperview];
                        [self.cancel_btn_2 removeFromSuperview];
                        self.profileScrollView.scrollEnabled = YES;
                        
                        [self reloadNewsfeed:(int)b];
                        
                    }
                } withProgressBlock:nil];
            }else{
                YookaBackend *yookaObject = [[YookaBackend alloc]init];
                yookaObject.kinveyId = yooka.kinveyId;
                yookaObject.caption = yooka.caption;
                yookaObject.venueName = yooka.venueName;
                yookaObject.venueId = yooka.venueId;
                if (btn_image) {
                    yookaObject.dishImage = btn_image;
                }
                yookaObject.postDate = yooka.postDate;
                yookaObject.userEmail = yooka.userEmail;
                yookaObject.HuntName = yooka.HuntName;
                yookaObject.myHuntCount = yooka.myHuntCount;
                yookaObject.totalHuntCount = yooka.totalHuntCount;
                yookaObject.postType = yooka.postType;
                yookaObject.postCaption = yooka.postCaption;
                yookaObject.HuntName = yooka.HuntName;
                yookaObject.dishName = yooka.dishName;
                yookaObject.postVote = yooka.postVote;
                yookaObject.venueAddress = yooka.venueAddress;
                yookaObject.venueCc = yooka.venueCc;
                yookaObject.venueCity = yooka.venueCity;
                yookaObject.venueCountry = yooka.venueCountry;
                yookaObject.venueState = yooka.venueState;
                yookaObject.venuePostalCode = yooka.venuePostalCode;
                yookaObject.userFullName = _userFullName;
                yookaObject.yooka_private = yooka.yooka_private;
                yookaObject.deleted = @"YES";
//        [yookaObject.meta setGloballyReadable:YES];
//        [yookaObject.meta setGloballyWritable:YES];
                
                //Kinvey use code: add a new update to the updates collection
                [self.updateStore saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    
                    if (errorOrNil == nil) {
//                        NSLog(@"saved successfully");
                        [self.modal_view removeFromSuperview];
                        [self.public_btn removeFromSuperview];
                        [self.private_btn removeFromSuperview];
                        [self.delete_btn removeFromSuperview];
                        [self.cancel_btn removeFromSuperview];
                        [self.cancel_btn_2 removeFromSuperview];
                        self.profileScrollView.scrollEnabled = YES;
                        [self reloadNewsfeed:(int)b];
                        
                    } else {
                        
                        BOOL wasNetworkError = [[errorOrNil domain] isEqual:KCSNetworkErrorDomain];
                        NSString* title = wasNetworkError ? NSLocalizedString(@"There was a network error.", @"network error title"): NSLocalizedString(@"An error occurred.", @"Generic error message");
                        NSString* message = wasNetworkError ? NSLocalizedString(@"Please wait a few minutes and try again.", @"try again error message") : [errorOrNil localizedDescription];
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                        message:message                                                           delegate:nil
                                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                              otherButtonTitles:nil];
                        [alert show];
                        [self.modal_view removeFromSuperview];
                        [self.public_btn removeFromSuperview];
                        [self.private_btn removeFromSuperview];
                        [self.delete_btn removeFromSuperview];
                        [self.cancel_btn removeFromSuperview];
                        [self.cancel_btn_2 removeFromSuperview];
                        self.profileScrollView.scrollEnabled = YES;
                        [self reloadNewsfeed:(int)b];

                    }
                } withProgressBlock:^(NSArray *objects, double percentComplete) {
                    
                }];
                
            }
            
        }
    } withProgressBlock:nil];
    
}

- (void)cancel_btn:(id)sender
{
//    NSLog(@"cancel button pressed");
    [self.modal_view removeFromSuperview];
    [self.private_btn removeFromSuperview];
    [self.public_btn removeFromSuperview];
    [self.delete_btn removeFromSuperview];
    [self.cancel_btn removeFromSuperview];
    [self.cancel_btn_2 removeFromSuperview];
    self.profileScrollView.scrollEnabled = YES;
    [self.profileScrollView setUserInteractionEnabled:YES];
}


- (void)gotoRestaurant:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
    //NSLog(@"button %lu pressed",(unsigned long)b);
    //    YookaBackend *yooka = _newsFeed[b];
    NSString *venueId = [self.myPosts[b] objectForKey:@"venueId"];
    //    NSLog(@"venue id = %@",venueId);
    NSString *venueName = [self.myPosts[b] objectForKey:@"venueName"];
    
    YookaRestaurantViewController* media = [[YookaRestaurantViewController alloc]init];
    media.venueId = venueId;
    media.selectedRestaurantName = venueName;
    [self presentViewController:media animated:NO completion:nil];
    
}

- (void)commentsBtnTouched:(id)sender{
    
//    NSLog(@"comment pressed");
    
    UIButton* button1 = sender;
    NSUInteger b = button1.tag;
    
//    NSLog(@"button %lu pressed",(unsigned long)b);
    
    UIButton* button = [self.thumbnails objectAtIndex:b];
    
    //button = [self.thumbnails objectAtIndex:b];
    
    if ( toggle[b]==1){
        //do nothing
    }
    else{
        self.captionModalView = [[UIImageView alloc] initWithFrame:CGRectMake(0+49, 0+42, button.frame.size.width -53, button.frame.size.height -82)];
        self.captionModalView.opaque = NO;
        self.captionModalView.backgroundColor = [[self colorWithHexString:(@"88888D")] colorWithAlphaComponent:0.7f];
        //[self.captionModalView setTag:b];
        [self.captionModalView setTag:117];
        [button addSubview:self.captionModalView];
        
        NSString *caption = [self.myPosts[b] objectForKey:@"caption"];
//        NSLog(@"caption = %@",caption);
        
        UILabel *captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 75, self.captionModalView.frame.size.width-10, self.captionModalView.frame.size.height-75)];
        captionLabel.textColor = [UIColor whiteColor];
        [captionLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:13]];
        captionLabel.text = [NSString stringWithFormat:@"%@",caption];
        captionLabel.textAlignment = NSTextAlignmentCenter;
        captionLabel.adjustsFontSizeToFitWidth = YES;
        captionLabel.numberOfLines = 0;
        [captionLabel sizeToFit];
        CGRect myFrame = captionLabel.frame;
        // Resize the frame's width to 280 (320 - margins)
        // width could also be myOriginalLabelFrame.size.width
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, self.captionModalView.frame.size.width-10, myFrame.size.height);
        captionLabel.frame = myFrame;
        [captionLabel setBackgroundColor:[UIColor clearColor]];
        
        [captionLabel setTag:110];
        [self.captionModalView addSubview:captionLabel];
        
        YookaButton* closeButton = [YookaButton buttonWithType:UIButtonTypeCustom];
        [closeButton  setFrame:CGRectMake((button.frame.size.width)-55, +43,45,25)];
        [closeButton setBackgroundColor:[UIColor clearColor]];
        [closeButton setBackgroundImage:[[UIImage imageNamed:@"close_button.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
        
        [closeButton setTag:119];
        [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:closeButton];
        
        closeButton.fourthTag=b;
        
//        NSLog(@"button subviews = %@",[button subviews]);
        
        toggle[b]=1;
        
    }
    
//    NSLog(@"button %lu pressed",(unsigned long)b);
//    NSLog(@"toggle b %lu pressed",(unsigned long)toggle[b]);
//    NSLog(@"toggle 0 %lu pressed",(unsigned long)toggle[0]);
    
}

- (void)closeBtnTouched:(id)sender{
    
    
    YookaButton *b3 = (YookaButton*)sender;
    
    UIButton* button1 = sender;
//    NSUInteger b = button1.tag;
//    NSLog(@"close button %lu pressed",(unsigned long)b);
    
    
    UIButton* button = [self.thumbnails objectAtIndex:b3.fourthTag];
    
    toggle[b3.fourthTag]=0;
    
    UIView* removeCaption = [button viewWithTag:110];
    
    UIView* removeCloseButton = [button viewWithTag:119];
    UIView* removeCaptionModal = [button viewWithTag:117];
    
    [removeCaptionModal removeFromSuperview];
    [removeCloseButton removeFromSuperview];
    [removeCaption removeFromSuperview];
    [button1 removeFromSuperview];
    
//    NSLog(@"button %lu pressed",(unsigned long)b3.fourthTag);
//    NSLog(@"toggle b %lu pressed",(unsigned long)toggle[b3.fourthTag]);
//    NSLog(@"toggle 0 %lu pressed",(unsigned long)toggle[0]);
    
}


- (void)fillFeedPictures
{
//    if (i<self.myPosts.count) {
//        
//        NSString *venueName = [self.myPosts[i] objectForKey:@"venueName"];
//        NSString *venueAddress = [self.myPosts[i] objectForKey:@"venueAddress"];
//        
//        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0,
//                                                                      (row*350),
//                                                                      320,
//                                                                      350)];
//        //        if (_myPosts.count>2) {
//        contentSize3 += 353;
//        //        }
//        button.tag = i;
//        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
////        ++col;
////
////        if (col >= yookaImagesPerRow2014) {
////            row++;
////            col = 0;
////        }
//        row++;
//        [self.feedScrollView setContentSize:CGSizeMake(320, contentSize3)];
//        [self.feedScrollView addSubview:button];
//        [self.thumbnails addObject:button];
//        
//        NSString *picUrl = [[_myPosts[i] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
//        NSString *kinveyId = [self.myPosts[i] objectForKey:@"_id"];
//        
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        NSData* imageData = [ud objectForKey:kinveyId];
//        UIImage *image = [UIImage imageWithData:imageData];
//        
//        if (image) {
//            
//            // do something with image
//            UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(7+33+9, 7+35, 304-33-5, 304-33)];
//            buttonImage.image = image;
//            [button addSubview:buttonImage];
//            
//            UIImageView *sidebarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 350)];
//            sidebarImageView.image = [UIImage imageNamed:@"sideborder_with_dropshadow.png"];
//            [button addSubview:sidebarImageView];
//            
//            UIImageView *timelineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 0, 40, 350)];
//            timelineImageView.image = [UIImage imageNamed:@"timeline.png"];
//            [button addSubview:timelineImageView];
//            
//            UIImageView *bulletImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-1, 150, 50, 50)];
//            bulletImageView.image = [UIImage imageNamed:@"timeline_bullet.png"];
//            [button addSubview:bulletImageView];
//            
//            UIImageView *captionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(49, 310, 304-38, 40)];
//            [captionImageView setBackgroundColor:[UIColor whiteColor]];
//            [button addSubview:captionImageView];
//            
//            UIImageView *commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 315, 30, 30)];
//            commentImageView.image = [UIImage imageNamed:@"comments_grey.png"];
//            [button addSubview:commentImageView];
//            
//            UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [commentButton setFrame:CGRectMake(200, 315, 30, 30)];
//            [commentButton setBackgroundColor:[UIColor clearColor]];
//            [commentButton setTag:i];
////            [commentButton addTarget:self action:@selector(commentsBtnTouched:)
////                    forControlEvents:UIControlEventTouchUpInside];
//            [button addSubview:commentButton];
//            
//            
//            UILabel *venueLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 310, 145, 30)];
//            venueLabel.textColor = [UIColor lightGrayColor];
//            [venueLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15]];
//            venueLabel.text = venueName;
//            venueLabel.textAlignment = NSTextAlignmentLeft;
//            venueLabel.adjustsFontSizeToFitWidth = YES;
//            [venueLabel setBackgroundColor:[UIColor clearColor]];
//            [button addSubview:venueLabel];
//            
//            UIButton *restaurant_button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [restaurant_button  setFrame:CGRectMake(49, 310, 145, 40)];
//            [restaurant_button setBackgroundColor:[UIColor clearColor]];
//            restaurant_button.tag = i;
////            [restaurant_button addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
//            [button addSubview:restaurant_button];
//            
//            UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 335, 145, 12)];
//            addressLabel.textColor = [UIColor lightGrayColor];
//            [addressLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//            addressLabel.text = venueAddress;
//            addressLabel.textAlignment = NSTextAlignmentLeft;
//            addressLabel.adjustsFontSizeToFitWidth = NO;
//            [addressLabel setBackgroundColor:[UIColor clearColor]];
//            [button addSubview:addressLabel];
//            
//            NSDate *createddate = [_myPosts[i] objectForKey:@"postDate"];
//            NSDate *now = [NSDate date];
//            NSString *str;
//            NSMutableString *myString = [NSMutableString string];
//            
//            NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createddate];
//            if (secondsBetween<60) {
//                int duration = secondsBetween;
//                str = [NSString stringWithFormat:@"%ds",duration]; //%d or %i both is ok.
//                [myString appendString:str];
//            }else if (secondsBetween<3600) {
//                int duration = secondsBetween / 60;
//                str = [NSString stringWithFormat:@"%dm",duration]; //%d or %i both is ok.
//                [myString appendString:str];
//            }else if (secondsBetween<86400){
//                int duration = secondsBetween / 3600;
//                str = [NSString stringWithFormat:@"%dh",duration]; //%d or %i both is ok.
//                [myString appendString:str];
//            }else if (secondsBetween<604800){
//                int duration = secondsBetween / 86400;
//                str = [NSString stringWithFormat:@"%dd",duration]; //%d or %i both is ok.
//                [myString appendString:str];
//            }else {
//                int duration = secondsBetween / 604800;
//                str = [NSString stringWithFormat:@"%dw",duration]; //%d or %i both is ok.
//                [myString appendString:str];
//            }
//            
//            UIImageView *clockView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 40, 30, 38)];
//            clockView.image = [UIImage imageNamed:@"timestamp_clock.png"];
//            [button addSubview:clockView];
//            
//            UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(29, 52, 70, 12)];
//            time_label.text = [[NSString stringWithFormat:@"%@",myString]uppercaseString];
//            time_label.textColor = [UIColor whiteColor];
//            [time_label setFont:[UIFont fontWithName:@"Helvetica" size:7]];
//            time_label.textAlignment = NSTextAlignmentLeft;
//            [button addSubview:time_label];
//            
//            
//            i++;
//            [self fillFeedPictures];
//            
//        }else{
//            
//            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:picUrl]
//                                                                options:0
//                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize)
//             {
//                 // progression tracking code
//             }
//                                                              completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
//             {
//                 if (image && finished)
//                 {
//                     
//                     // do something with image
//                     UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(7+33+9, 7+35, 304-33-5, 304-33)];
//                     buttonImage.image = image;
//                     [button addSubview:buttonImage];
//                     
//                     UIImageView *sidebarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 350)];
//                     sidebarImageView.image = [UIImage imageNamed:@"sideborder_with_dropshadow.png"];
//                     [button addSubview:sidebarImageView];
//                     
//                     UIImageView *timelineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(3, 0, 40, 350)];
//                     timelineImageView.image = [UIImage imageNamed:@"timeline.png"];
//                     [button addSubview:timelineImageView];
//                     
//                     UIImageView *bulletImageView = [[UIImageView alloc]initWithFrame:CGRectMake(-1, 150, 50, 50)];
//                     bulletImageView.image = [UIImage imageNamed:@"timeline_bullet.png"];
//                     [button addSubview:bulletImageView];
//                     
//                     UIImageView *captionImageView = [[UIImageView alloc]initWithFrame:CGRectMake(49, 310, 304-38, 40)];
//                     [captionImageView setBackgroundColor:[UIColor whiteColor]];
//                     [button addSubview:captionImageView];
//                     
//                     UIImageView *commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(200, 315, 30, 30)];
//                     commentImageView.image = [UIImage imageNamed:@"comments_grey.png"];
//                     [button addSubview:commentImageView];
//                     
//                     UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                     [commentButton setFrame:CGRectMake(200, 315, 30, 30)];
//                     [commentButton setBackgroundColor:[UIColor clearColor]];
//                     [commentButton setTag:i];
//                     //            [commentButton addTarget:self action:@selector(commentsBtnTouched:)
//                     //                    forControlEvents:UIControlEventTouchUpInside];
//                     [button addSubview:commentButton];
//                     
//                     
//                     UILabel *venueLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 310, 145, 30)];
//                     venueLabel.textColor = [UIColor lightGrayColor];
//                     [venueLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:15]];
//                     venueLabel.text = venueName;
//                     venueLabel.textAlignment = NSTextAlignmentLeft;
//                     venueLabel.adjustsFontSizeToFitWidth = YES;
//                     [venueLabel setBackgroundColor:[UIColor clearColor]];
//                     [button addSubview:venueLabel];
//                     
//                     UIButton *restaurant_button = [UIButton buttonWithType:UIButtonTypeCustom];
//                     [restaurant_button  setFrame:CGRectMake(49, 310, 145, 40)];
//                     [restaurant_button setBackgroundColor:[UIColor clearColor]];
//                     restaurant_button.tag = i;
//                     //            [restaurant_button addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
//                     [button addSubview:restaurant_button];
//                     
//                     UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 335, 145, 12)];
//                     addressLabel.textColor = [UIColor lightGrayColor];
//                     [addressLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
//                     addressLabel.text = venueAddress;
//                     addressLabel.textAlignment = NSTextAlignmentLeft;
//                     addressLabel.adjustsFontSizeToFitWidth = NO;
//                     [addressLabel setBackgroundColor:[UIColor clearColor]];
//                     [button addSubview:addressLabel];
//                     
//                     NSDate *createddate = [_myPosts[i] objectForKey:@"postDate"];
//                     NSDate *now = [NSDate date];
//                     NSString *str;
//                     NSMutableString *myString = [NSMutableString string];
//                     
//                     NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createddate];
//                     if (secondsBetween<60) {
//                         int duration = secondsBetween;
//                         str = [NSString stringWithFormat:@"%ds",duration]; //%d or %i both is ok.
//                         [myString appendString:str];
//                     }else if (secondsBetween<3600) {
//                         int duration = secondsBetween / 60;
//                         str = [NSString stringWithFormat:@"%dm",duration]; //%d or %i both is ok.
//                         [myString appendString:str];
//                     }else if (secondsBetween<86400){
//                         int duration = secondsBetween / 3600;
//                         str = [NSString stringWithFormat:@"%dh",duration]; //%d or %i both is ok.
//                         [myString appendString:str];
//                     }else if (secondsBetween<604800){
//                         int duration = secondsBetween / 86400;
//                         str = [NSString stringWithFormat:@"%dd",duration]; //%d or %i both is ok.
//                         [myString appendString:str];
//                     }else {
//                         int duration = secondsBetween / 604800;
//                         str = [NSString stringWithFormat:@"%dw",duration]; //%d or %i both is ok.
//                         [myString appendString:str];
//                     }
//                     
//                     UIImageView *clockView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 40, 30, 38)];
//                     clockView.image = [UIImage imageNamed:@"timestamp_clock.png"];
//                     [button addSubview:clockView];
//                     
//                     UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(29, 52, 70, 12)];
//                     time_label.text = [[NSString stringWithFormat:@"%@",myString]uppercaseString];
//                     time_label.textColor = [UIColor whiteColor];
//                     [time_label setFont:[UIFont fontWithName:@"Helvetica" size:7]];
//                     time_label.textAlignment = NSTextAlignmentLeft;
//                     [button addSubview:time_label];
//                     
//                     i++;
//                     [self fillFeedPictures];
//                     
//                 }
//             }];
//            
//        }
//        
//    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}


- (void)buttonAction:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    NSLog(@"button %lu pressed",(unsigned long)b);
}

- (void)buttonAction2:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    NSDictionary *articleParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self.inProgressHuntNames[b], @"Hunt_Name",
                                   nil];
    
    [Flurry logEvent:@"My_Profile_Progress_Hunt_Button_Clicked" withParameters:articleParams];
    
    YookaHuntVenuesViewController* media = [[YookaHuntVenuesViewController alloc]init];
    media.huntTitle = self.inProgressHuntNames[b];
    media.my_hunt_count = self.inProgressHuntCounts[b];
    media.userEmail = self.myEmail;
    media.emailId = self.myEmail;
    media.subscribedHunts = self.cachesubscribedHuntNames;
    media.unsubscribedHunts = self.cacheUnSubscribedHuntNames;
    media.finishedHuntVenues = [_finishedHuntVenues objectForKey:self.inProgressHuntNames[b]];
    [self presentViewController:media animated:NO completion:nil];
    
}

- (void)buttonAction3:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;

    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    NSDictionary *articleParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self.finishedHuntNames[b], @"Hunt_Name",
                                   nil];
    
    [Flurry logEvent:@"My_Profile_Progress_Hunt_Button_Clicked" withParameters:articleParams];
    
    YookaHuntVenuesViewController* media = [[YookaHuntVenuesViewController alloc]init];
    media.huntTitle = self.finishedHuntNames[b];
    media.my_hunt_count = self.finishedHuntCounts[b];
    media.userEmail = self.myEmail;
    media.emailId = self.myEmail;
    media.subscribedHunts = self.cachesubscribedHuntNames;
    media.unsubscribedHunts = self.cacheUnSubscribedHuntNames;
    media.finishedHuntVenues = [_finishedHuntVenues objectForKey:self.finishedHuntNames[b]];
    [self presentViewController:media animated:NO completion:nil];
    
}

- (void)getFollowerUsers
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:_myEmail];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            NSString *followersCount = [NSString stringWithFormat:@"0"];
            _followersCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            _followersCountLabel.text = followersCount;
            
            _followersCountLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            _followersCountLabel3.text = followersCount;
            
            self.userFollowersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.userFollowersBtn  setFrame:CGRectMake(130, 225, 80, 50)];
            [self.userFollowersBtn setBackgroundColor:[UIColor clearColor]];
            [self.userFollowersBtn addTarget:self action:@selector(userFollowers:) forControlEvents:UIControlEventTouchUpInside];
            [self.profileScrollView addSubview:self.userFollowersBtn];
            
            self.userFollowersBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.userFollowersBtn3  setFrame:CGRectMake(130, 225, 80, 50)];
            [self.userFollowersBtn3 setBackgroundColor:[UIColor clearColor]];
            [self.userFollowersBtn3 addTarget:self action:@selector(userFollowers:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedScrollView addSubview:self.userFollowersBtn3];
            
        } else {
            
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
                
                NSString *followersCount = [NSString stringWithFormat:@"0"];
                _followersCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                _followersCountLabel.text = followersCount;
                
                _followersCountLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                _followersCountLabel3.text = followersCount;

                self.userFollowersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.userFollowersBtn  setFrame:CGRectMake(130, 225, 80, 50)];
                [self.userFollowersBtn setBackgroundColor:[UIColor clearColor]];
                [self.userFollowersBtn addTarget:self action:@selector(userFollowers:) forControlEvents:UIControlEventTouchUpInside];
                [self.profileScrollView addSubview:self.userFollowersBtn];
                
                self.userFollowersBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.userFollowersBtn3  setFrame:CGRectMake(130, 225, 80, 50)];
                [self.userFollowersBtn3 setBackgroundColor:[UIColor clearColor]];
                [self.userFollowersBtn3 addTarget:self action:@selector(userFollowers:) forControlEvents:UIControlEventTouchUpInside];
                [self.feedScrollView addSubview:self.userFollowersBtn3];
                
            } else {
                YookaBackend *yooka = objectsOrNil[0];
                
                _followerUsers = [NSMutableArray arrayWithArray:yooka.followers];
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_followerUsers forKey:@"followers"];
                [defaults synchronize];
                // _cacheFollowers = _followerUsers;
                //[_followersLabel removeFromSuperview];
                
                NSString *followersCount = [NSString stringWithFormat:@"%lu",(unsigned long)_followerUsers.count];
                
                if(followersCount==nil){
                    followersCount=@"0";
                }
                _followersCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                _followersCountLabel.text = followersCount;
                
                _followersCountLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                _followersCountLabel3.text = followersCount;
                
                self.userFollowersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.userFollowersBtn  setFrame:CGRectMake(130, 225, 80, 50)];
                [self.userFollowersBtn setBackgroundColor:[UIColor clearColor]];
                [self.userFollowersBtn addTarget:self action:@selector(userFollowers:) forControlEvents:UIControlEventTouchUpInside];
                [self.profileScrollView addSubview:self.userFollowersBtn];
                
                self.userFollowersBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.userFollowersBtn3  setFrame:CGRectMake(130, 225, 80, 50)];
                [self.userFollowersBtn3 setBackgroundColor:[UIColor clearColor]];
                [self.userFollowersBtn3 addTarget:self action:@selector(userFollowers:) forControlEvents:UIControlEventTouchUpInside];
                [self.feedScrollView addSubview:self.userFollowersBtn3];
            }
            
        }
    } withProgressBlock:nil];
}

- (void)userFollowers:(id)sender
{
    [Flurry logEvent:@"My_Profile_Followers_Button_Clicked"];

    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    UserFollowersViewController *media = [[UserFollowersViewController alloc]init];
    //    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //    self.navigationItem.backBarButtonItem = backBtn;
    //    [self.navigationItem setBackBarButtonItem: backBtn];
    media.userFullName = self.userFullName;
    media.followers = self.followerUsers;
    [self presentViewController:media animated:NO completion:nil];
}

- (void)getFollowingUsers
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:_myEmail];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            NSString *followingCount = @"0";
            
            _followingCountLabel.text = followingCount;
            _followingCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.profileScrollView addSubview:_followingCountLabel];
            
            self.followingCountLabel3.text = followingCount;
            self.followingCountLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.feedScrollView addSubview:self.followersCountLabel3];
            
            self.userFollowingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.userFollowingBtn  setFrame:CGRectMake(220, 210, 90, 50)];
            [self.userFollowingBtn setBackgroundColor:[UIColor clearColor]];
            [self.userFollowingBtn addTarget:self action:@selector(userFollowing:) forControlEvents:UIControlEventTouchUpInside];
            [self.profileScrollView addSubview:_userFollowingBtn];
            
            self.userFollowingBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.userFollowingBtn3  setFrame:CGRectMake(220, 210, 90, 50)];
            [self.userFollowingBtn3 setBackgroundColor:[UIColor clearColor]];
            [self.userFollowingBtn3 addTarget:self action:@selector(userFollowing:) forControlEvents:UIControlEventTouchUpInside];
            [self.feedScrollView addSubview:self.userFollowingBtn3];
            
        } else {
            
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
                
                NSString *followingCount = @"0";
                
                self.followingCountLabel.text = followingCount;
                self.followingCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                [self.profileScrollView addSubview:self.followingCountLabel];
                
                self.followingCountLabel3.text = followingCount;
                self.followingCountLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                [self.feedScrollView addSubview:self.followingCountLabel3];
                
                self.userFollowingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.userFollowingBtn  setFrame:CGRectMake(220, 210, 90, 50)];
                [self.userFollowingBtn setBackgroundColor:[UIColor clearColor]];
                [self.userFollowingBtn addTarget:self action:@selector(userFollowing:) forControlEvents:UIControlEventTouchUpInside];
                [self.profileScrollView addSubview:self.userFollowingBtn];
                
                self.userFollowingBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.userFollowingBtn3  setFrame:CGRectMake(220, 210, 90, 50)];
                [self.userFollowingBtn3 setBackgroundColor:[UIColor clearColor]];
                [self.userFollowingBtn3 addTarget:self action:@selector(userFollowing:) forControlEvents:UIControlEventTouchUpInside];
                [self.feedScrollView addSubview:self.userFollowingBtn3];
                
            } else {
                
                YookaBackend *yooka = objectsOrNil[0];
                
                _followingUsers = [NSMutableArray arrayWithArray:yooka.following_users];
                
                NSString *followingCount = [NSString stringWithFormat:@"%lu",(unsigned long)_followingUsers.count];
                                
                if(followingCount==nil){
                    followingCount=@"0";
                }
                self.followingCountLabel.text = followingCount;
                self.followingCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                [self.profileScrollView addSubview:self.followingCountLabel];
                
                self.followingCountLabel3.text = followingCount;
                self.followingCountLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                [self.feedScrollView addSubview:self.followingCountLabel3];
                
                _userFollowingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_userFollowingBtn  setFrame:CGRectMake(220, 210, 80, 50)];
                [_userFollowingBtn setBackgroundColor:[UIColor clearColor]];
                [_userFollowingBtn addTarget:self action:@selector(userFollowing:) forControlEvents:UIControlEventTouchUpInside];
                [self.profileScrollView addSubview:_userFollowingBtn];
                
                _userFollowingBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [_userFollowingBtn3  setFrame:CGRectMake(220, 210, 80, 50)];
                [_userFollowingBtn3 setBackgroundColor:[UIColor clearColor]];
                [_userFollowingBtn3 addTarget:self action:@selector(userFollowing:) forControlEvents:UIControlEventTouchUpInside];
                [self.feedScrollView addSubview:_userFollowingBtn3];
            }
        }
    } withProgressBlock:nil];
    
}

- (void)userFollowing:(id)sender
{
    [Flurry logEvent:@"My_Profile_Following_Button_Clicked"];

    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    //NSLog(@"Following Button pressed");
    UserFollowingViewController *media = [[UserFollowingViewController alloc]init];
    //    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    //    self.navigationItem.backBarButtonItem = backBtn;
    //    [self.navigationItem setBackBarButtonItem: backBtn];
    media.userFullName = _userFullName;
    media.followingUsers = _followingUsers;
    [self presentViewController:media animated:NO completion:nil];
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

-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:panRecognizer];
}
#pragma mark -
#pragma mark UIGestureRecognizerDelegate methods

// This is where we can slide the active panel from left to right and back again,
// endlessly, for great fun!
-(void)movePanel:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    
    //    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    // Stop the main panel from being dragged to the left if it's not already dragged to the right
    //    if ((velocity.x < 0) && (activeViewController.view.frame.origin.x == 0)) {
    //        return;
    //    }
    
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        if(velocity.x > 0) {
            _showPanel = YES;
            
            
        } else {
            
            _showPanel = NO;
            
        }
        
        //        UIView *childView = [self getNavigationView];
        //        [self.view sendSubviewToBack:childView];
    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        // If we stopped dragging the panel somewhere between the left and right
        // edges of the screen, these will animate it to its final position.
        if (!_showPanel) {
            [_delegate movePanelToOriginalPosition];
            _panelMovedRight = NO;
            [self.navButton2 setHidden:YES];
            self.navButton3.tag = 1;
            self.navButton.tag = 1;
            self.navButton2.tag = 1;
        } else {
            [self.navButton2 setHidden:NO];
            self.navButton3.tag = 0;
            self.navButton2.tag = 0;
            self.navButton.tag = 0;
            [_delegate movePanelRight];
            _panelMovedRight = YES;
        }
    }
    
    //added reappeared button2, reset tags
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            _showPanel = YES;
        }
        else {
            
            _showPanel = NO;
        }
        
        // Set the new x coord of the active panel...
        //        activeViewController.view.center = CGPointMake(activeViewController.view.center.x + translatedPoint.x, activeViewController.view.center.y);
        
        // ...and move it there
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

- (IBAction)takePicture:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profile photo", @"title")
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                          otherButtonTitles:@"Take a picture",@"Select from gallery",nil];
    alert.tag=1;
    [alert show];
    
}


#pragma mark - pictures

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.profileImage = nil;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.profileImage = image;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        double ratio;
        double delta;
        CGPoint offset;
        
        //make a new square size, that is the resized imaged width
        CGSize sz = CGSizeMake(310.0, 310.0);
        
        //figure out if the picture is landscape or portrait, then
        //calculate scale factor and offset
        if (image.size.width > image.size.height) {
            ratio = 310.0 / image.size.width;
            delta = (ratio*image.size.width - ratio*image.size.height);
            offset = CGPointMake(delta/2, 0);
        } else {
            ratio = 310.0 / image.size.height;
            delta = (ratio*image.size.height - ratio*image.size.width);
            offset = CGPointMake(0, delta/2);
        }
        
        //make the final clipping rect based on the calculated values
        CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                     (ratio * image.size.width) + delta,
                                     (ratio * image.size.height) + delta);
        
        
        //start a new context, with scale factor 0.0 so retina displays get
        //high quality image
        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
        } else {
            UIGraphicsBeginImageContext(sz);
        }
        UIRectClip(clipRect);
        [image drawInRect:clipRect];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        
        self.profileImage = newImage;
        
        [self.profileImageView setContentMode:UIViewContentModeScaleAspectFit];
        
        self.profileImageView.image = self.profileImage;
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:UIImagePNGRepresentation(self.profileImage) forKey:@"MyProfilePic"];
        [defaults synchronize];
        
        [self saveUserImage];
        
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==0) {
        
        if (buttonIndex == 0){
            //cancel clicked ...do your action
            
            
        }
        
    } else {
        
        if (buttonIndex == 0) {
            
        } else if (buttonIndex == 1) {
            
            UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
            
        }else if (buttonIndex == 2) {
            
            UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
            
        }else{
            
        }
        
    }
    
}

- (void)saveUserImage
{
    
    //        NSLog(@"profile image");
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = [KCSUser activeUser].email;
    if (_profileImage) {
        yookaObject.userImage = _profileImage;
    }else{
        yookaObject.userImage = [UIImage imageNamed:@"minion.jpg"];
    }
    yookaObject.userFullName = _userFullName;
    yookaObject.userEmail = _userEmail;
    
    //Kinvey use code: add a new update to the updates collection
    [self.updateStore saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
//            NSLog(@"saved successfully");

        } else {
            //                NSLog(@"save failed %@",errorOrNil);
        }
    } withProgressBlock:nil];
    
    
}


@end
