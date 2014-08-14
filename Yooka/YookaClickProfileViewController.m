//
//  YookaClickProfileViewController.m
//  Yooka
//
//  Created by Paulina Michon on 6/18/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaClickProfileViewController.h"
#import "UIImageView+WebCache.h"
#import "YookaBackend.h"
#import "NavigationViewController.h"
#import "MainViewController.h"
#import "UserFollowersViewController.h"
#import "UserFollowingViewController.h"
#import "YookaHuntVenuesViewController.h"
#import "LLACircularProgressView.h"


const NSInteger yookaThumbnailWidth2015 = 145;
const NSInteger yookaThumbnailHeight2015 = 145;
const NSInteger yookaImagesPerRow2015 = 2;
const NSInteger yookaThumbnailSpace2015 = 10;
const NSInteger yookaThumbnailWidth2015_2 = 320;
const NSInteger yookaThumbnailHeight2015_2 = 340;
const NSInteger yookaImagesPerRow2015_2 = 1;
const NSInteger yookaThumbnailSpace2015_2 = 5;

@interface YookaClickProfileViewController ()
@property (nonatomic, strong) LLACircularProgressView *circularProgressView;

@end

@implementation YookaClickProfileViewController

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
            
            _huntDict1 = [NSMutableDictionary new];
            _huntDict2 = [NSMutableDictionary new];
            _huntDict3 = [NSMutableDictionary new];
            _huntDict4 = [NSMutableDictionary new];
            _huntDict5 = [NSMutableDictionary new];
            _huntDict6 = [NSMutableDictionary new];
            _cachesubscribedHuntNames = [NSMutableArray new];
            _cacheUnSubscribedHuntNames = [NSMutableArray new];
            _finishedHuntNames = [NSMutableArray new];
            _inProgressHuntNames = [NSMutableArray new];
            _thumbnails = [NSMutableArray new];
            _thumbnails2 = [NSMutableArray new];
            _thumbnails3 = [NSMutableArray new];
            _featuredHuntNames = [NSMutableArray new];
            self.inProgressHuntCounts = [NSMutableArray new];
            self.finishedHuntCounts = [NSMutableArray new];
            self.followerUsers2 = [NSMutableArray new];
            self.followingUsers2 = [NSMutableArray new];
            self.followerUsers3 = [NSMutableArray new];
            self.followingUsers3 = [NSMutableArray new];
            
            i = 0;
            j = 0;
            j2 = 0;
            l = 0;
            m = 0;
            n = 0;
            p = 0;
            row = 0, col = 0;
            row2 = 0, col2 = 0;
            row3 = 0, col3 = 0;
            contentSize = 340;
            contentSize2 = 340;
            contentSize3 = 35;

            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            _huntDict1 = [defaults objectForKey:@"huntDescription"];
            _huntDict2 = [defaults objectForKey:@"huntCount"];
            _huntDict3 = [defaults objectForKey:@"huntLogoUrl"];
            _huntDict4 = [defaults objectForKey:@"huntPicsUrl"];
            _huntDict5 = [defaults objectForKey:@"huntLocations"];
            _huntDict6 = [defaults objectForKey:@"huntPicUrl"];
            _featuredHuntNames = [defaults objectForKey:@"featuredHuntNames"];

            NSLog(@"featured hunt names = %@",self.myEmail);
            
            if (self.myEmail){
                // do nothing
                
            }else{
//                self.userFullName = [NSString stringWithFormat:@"%@ %@",[[KCSUser activeUser].givenName uppercaseString],[[KCSUser activeUser].surname  uppercaseString]];
//                self.myEmail = [[KCSUser activeUser]email];
            }
            
            CGRect screenRect4 = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            
            self.profileScrollView=[[UIScrollView alloc] initWithFrame:screenRect4];
            self.profileScrollView.contentSize= self.view.bounds.size;
            self.profileScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            [self.view addSubview:self.profileScrollView];
            [self.profileScrollView setBackgroundColor:[UIColor clearColor]];
            
            UIImageView *bg_color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 278)];
            [bg_color setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.profileScrollView addSubview:bg_color];
            
            self.backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
            self.backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
            [self.profileScrollView addSubview:self.backBtnImage];
            
            self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.backBtn setFrame:CGRectMake(10, 20, 40, 40)];
            [self.backBtn setTitle:@"" forState:UIControlStateNormal];
            [self.backBtn setBackgroundColor:[UIColor clearColor]];
            //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            [self.profileScrollView addSubview:self.backBtn];
            
            //set profile image background color here.
            self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 320, 220)];
            //            [self.bgImageView setBackgroundColor:[self colorWithHexString:(@"fb604e")]];
            [self.profileScrollView addSubview:self.bgImageView];
            
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.textColor = [UIColor whiteColor];
            NSString *string5 = @"PROFILE";
            NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:string5];
            float spacing5 = 1.5f;
            [attributedString5 addAttribute:NSKernAttributeName
                                      value:@(spacing5)
                                      range:NSMakeRange(0, [string5 length])];
            
            self.titleLabel.attributedText = attributedString5;
            self.titleLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
            [self.profileScrollView addSubview:self.titleLabel];
            
            self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(111, 65, 100, 100)];
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
            [self.profileImageView.layer setBorderWidth:4.0];
            [self.profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
            [self.profileImageView setClipsToBounds:YES];
            [self.profileScrollView addSubview:self.profileImageView];
            
                if (_myURL) {
                    
                     NSLog(@"image 1 test");
                    
                    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:_myURL]
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
                             [self.profileImageView setImage:image];

                         }else{
                             UIImage *image = [UIImage imageNamed:@"minion.jpg"];
                             [self.profileImageView setImage:image];
                         }
                     }];
                    
                }else{
                    
                    
                    
                }
            
            self.profileLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10, 170, 300, 20)];
            self.profileLabel.textAlignment = NSTextAlignmentCenter;
            self.profileLabel.textColor = [UIColor whiteColor];
            self.profileLabel.text = [_userFullName uppercaseString];
            self.profileLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:16.0];
            [self.profileLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileLabel setAdjustsFontSizeToFitWidth:YES];
            [self.profileScrollView addSubview:self.profileLabel];
            
            self.listCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, 107, 25)];
            self.listCountLabel.textAlignment = NSTextAlignmentCenter;
            self.listCountLabel.textColor = [UIColor whiteColor];
            self.listCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.listCountLabel setBackgroundColor:[UIColor clearColor]];
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
            
            self.progressView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 320, self.view.frame.size.height)];
            [self.progressView setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.progressView];
            
            self.completedView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 320, self.view.frame.size.height)];
            [self.completedView setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.completedView];
            
            self.feedView = [[UIView alloc]initWithFrame:CGRectMake(0, 300, 300, self.view.frame.size.height)];
            [self.feedView setBackgroundColor:[UIColor clearColor]];
            [self.profileScrollView addSubview:self.feedView];
            
            [self.feedView setHidden:YES];
            [self.completedView setHidden:YES];
            
            UIImageView *blue_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21.70, 320, 56)];
            [blue_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.progressView addSubview:blue_bg];
            
            UIImageView *blue_bg_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21.70, 320, 56)];
            [blue_bg_2 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.completedView addSubview:blue_bg_2];
            
            UIImageView *blue_bg_3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21.70, 320, 56)];
            [blue_bg_3 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.feedView addSubview:blue_bg_3];
            
            UIImageView *highlighted_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21.70, 107, 56)];
            highlighted_bg.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.10f];
            [self.progressView addSubview:highlighted_bg];
            
            UIImageView *highlighted_bg_2 = [[UIImageView alloc]initWithFrame:CGRectMake(108, -21.70, 106, 56)];
            highlighted_bg_2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.10f];
            [self.completedView addSubview:highlighted_bg_2];
            
            UIImageView *highlighted_bg_3 = [[UIImageView alloc]initWithFrame:CGRectMake(215, -21.70, 107, 56)];
            highlighted_bg_3.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.10f];
            [self.feedView addSubview:highlighted_bg_3];
            
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
            progressLabel2.textColor = [UIColor whiteColor];
            progressLabel2.textAlignment = NSTextAlignmentCenter;
            progressLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            progressLabel2.attributedText = attributedString;
            [progressLabel2 setBackgroundColor:[UIColor clearColor]];
            [self.completedView addSubview:progressLabel2];
            
            UILabel *progressLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, -5, 107, 20)];
            progressLabel3.textColor = [UIColor whiteColor];
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
            
            UILabel *completedLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(107, -5, 107, 20)];
            completedLabel2.textColor = [UIColor whiteColor];
            completedLabel2.textAlignment = NSTextAlignmentCenter;
            completedLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            completedLabel2.attributedText = attributedString2;
            [completedLabel2 setBackgroundColor:[UIColor clearColor]];
            [self.completedView addSubview:completedLabel2];
            
            UILabel *completedLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(107, -5, 107, 20)];
            completedLabel3.textColor = [UIColor whiteColor];
            completedLabel3.textAlignment = NSTextAlignmentCenter;
            completedLabel3.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
            completedLabel3.attributedText = attributedString2;
            [completedLabel3 setBackgroundColor:[UIColor clearColor]];
            [self.feedView addSubview:completedLabel3];
            
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
            
            [self checkSubscribedHunts];
            [self getMyNewsFeed];
            
            // Get ready for swipes
            [self setupGestures];
            
        }
        else{
            
            [self.view setBackgroundColor:[UIColor whiteColor]];
            
            _huntDict1 = [NSMutableDictionary new];
            _huntDict2 = [NSMutableDictionary new];
            _huntDict3 = [NSMutableDictionary new];
            _huntDict4 = [NSMutableDictionary new];
            _huntDict5 = [NSMutableDictionary new];
            _huntDict6 = [NSMutableDictionary new];
            _cachesubscribedHuntNames = [NSMutableArray new];
            _cacheUnSubscribedHuntNames = [NSMutableArray new];
            _finishedHuntNames = [NSMutableArray new];
            _inProgressHuntNames = [NSMutableArray new];
            _thumbnails = [NSMutableArray new];
            _thumbnails2 = [NSMutableArray new];
            _thumbnails3 = [NSMutableArray new];
            _featuredHuntNames = [NSMutableArray new];
            self.inProgressHuntCounts = [NSMutableArray new];
            self.finishedHuntCounts = [NSMutableArray new];
            self.followerUsers2 = [NSMutableArray new];
            self.followingUsers2 = [NSMutableArray new];
            self.followerUsers3 = [NSMutableArray new];
            self.followingUsers3 = [NSMutableArray new];
            
            i = 0;
            j = 0;
            j2 = 0;
            l = 0;
            m = 0;
            n = 0;
            p = 0;
            row = 0, col = 0;
            row2 = 0, col2 = 0;
            row3 = 0, col3 = 0;
            contentSize = 340;
            contentSize2 = 340;
            contentSize3 = 30;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            _huntDict1 = [defaults objectForKey:@"huntDescription"];
            _huntDict2 = [defaults objectForKey:@"huntCount"];
            _huntDict3 = [defaults objectForKey:@"huntLogoUrl"];
            _huntDict4 = [defaults objectForKey:@"huntPicsUrl"];
            _huntDict5 = [defaults objectForKey:@"huntLocations"];
            _huntDict6 = [defaults objectForKey:@"huntPicUrl"];
            _featuredHuntNames = [defaults objectForKey:@"featuredHuntNames"];
            
            NSLog(@"featured hunt names = %@",self.myEmail);
            
            if (self.myEmail){
                // do nothing
                
            }else{
                //                self.userFullName = [NSString stringWithFormat:@"%@ %@",[[KCSUser activeUser].givenName uppercaseString],[[KCSUser activeUser].surname  uppercaseString]];
                //                self.myEmail = [[KCSUser activeUser]email];
            }
            
            CGRect screenRect4 = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            
            self.profileScrollView=[[UIScrollView alloc] initWithFrame:screenRect4];
            self.profileScrollView.contentSize= self.view.bounds.size;
            self.profileScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            [self.view addSubview:self.profileScrollView];
            [self.profileScrollView setBackgroundColor:[UIColor clearColor]];
            
            UIImageView *bg_color = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 278)];
            [bg_color setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.profileScrollView addSubview:bg_color];
            
            self.backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
            self.backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
            [self.profileScrollView addSubview:self.backBtnImage];
            
            self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.backBtn setFrame:CGRectMake(10, 20, 40, 40)];
            [self.backBtn setTitle:@"" forState:UIControlStateNormal];
            [self.backBtn setBackgroundColor:[UIColor clearColor]];
            //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            [self.profileScrollView addSubview:self.backBtn];
            
            //set profile image background color here.
            self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 320, 220)];
            //            [self.bgImageView setBackgroundColor:[self colorWithHexString:(@"fb604e")]];
            [self.profileScrollView addSubview:self.bgImageView];
            
            self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.textColor = [UIColor whiteColor];
            NSString *string5 = @"PROFILE";
            NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:string5];
            float spacing5 = 1.5f;
            [attributedString5 addAttribute:NSKernAttributeName
                                      value:@(spacing5)
                                      range:NSMakeRange(0, [string5 length])];
            
            self.titleLabel.attributedText = attributedString5;
            self.titleLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
            [self.profileScrollView addSubview:self.titleLabel];
            
            self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(111, 65, 100, 100)];
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
            [self.profileImageView.layer setBorderWidth:4.0];
            [self.profileImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
            [self.profileImageView setClipsToBounds:YES];
            [self.profileScrollView addSubview:self.profileImageView];
            
            NSLog(@"userpicurl = %@",_myURL);
            
            if (_myURL) {
                
                NSLog(@"image 1 test");
                
                [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:_myURL]
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
                         [self.profileImageView setImage:image];
                         
                     }
                 }];
                
            }else{
                
                
                
            }
            
            self.profileLabel = [[UILabel alloc]initWithFrame:CGRectMake( 10, 170, 300, 20)];
            self.profileLabel.textAlignment = NSTextAlignmentCenter;
            self.profileLabel.textColor = [UIColor whiteColor];
            self.profileLabel.text = [_userFullName uppercaseString];
            self.profileLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:16.0];
            [self.profileLabel setBackgroundColor:[UIColor clearColor]];
            [self.profileLabel setAdjustsFontSizeToFitWidth:YES];
            [self.profileScrollView addSubview:self.profileLabel];
            
            self.listCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 230, 107, 25)];
            self.listCountLabel.textAlignment = NSTextAlignmentCenter;
            self.listCountLabel.textColor = [UIColor whiteColor];
            self.listCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
            [self.listCountLabel setBackgroundColor:[UIColor clearColor]];
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
            [self.profileScrollView addSubview:self.feedView];
            
            [self.feedView setHidden:YES];
            [self.completedView setHidden:YES];
            
            UIImageView *blue_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, -21, 107, 56)];
            [blue_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.progressView addSubview:blue_bg];
            
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
            self.completedLabel.textColor = [UIColor lightGrayColor];
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
            
            [self checkSubscribedHunts];
            [self getMyNewsFeed];
            
            // Get ready for swipes
            [self setupGestures];
            
        }
    }
    
}

- (void)tick:(float)percent {
    NSLog(@" percent : %f",percent);
    
    CGFloat progress = percent;
    [self.circularProgressView setProgress:(progress <= 1.00f ? progress : 0.0f) animated:YES];
}

- (void)checkSubscribedHunts
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:self.myEmail];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        if (errorOrNil != nil) {
            //An error happened, just log for now
            _subscribedHuntNames = [NSMutableArray new];
            _unsubscribedHuntNames = [NSMutableArray new];
            
            _unsubscribedHuntNames = _featuredHuntNames;
            _subscribedHuntNames = nil;
            
        } else {
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
                //                NSLog(@"try 2002");
                
                _subscribedHuntNames = [NSMutableArray new];
                _unsubscribedHuntNames = [NSMutableArray new];
                
                _unsubscribedHuntNames = _featuredHuntNames;
                _subscribedHuntNames = nil;
                
            } else {
                //                NSLog(@"try 3003");
                
                _subscribedHuntNames = [NSMutableArray new];
                _unsubscribedHuntNames = [NSMutableArray new];
                
                YookaBackend *yooka = objectsOrNil[0];
                //                NSLog(@"featured hunts = %@",_featuredHuntNames);
                NSLog(@"subscribed hunts = %@",yooka.public_hunts);
                
                if (yooka.public_hunts) {
                    NSLog(@"yes");
                    _subscribedHuntNames = [NSMutableArray arrayWithArray:yooka.public_hunts];
                    NSLog(@"subscribed hunt names = %lu",(unsigned long)_subscribedHuntNames.count);

                }else{
                    NSLog(@"no");
                    _subscribedHuntNames = [NSMutableArray arrayWithArray:yooka.HuntNames];
                }

                for (int q = 0; q<_subscribedHuntNames.count; q++) {
                    if ([_featuredHuntNames containsObject:_subscribedHuntNames[q]]) {
                        //                        NSLog(@"do nothing");
                    }else{
                        [_subscribedHuntNames removeObject:_subscribedHuntNames[q]];
                        //                        NSLog(@"removed object");
                    }
                }
                
                NSMutableArray *removeArray = [_featuredHuntNames mutableCopy];
                [removeArray removeObjectsInArray:_subscribedHuntNames];
                _unsubscribedHuntNames = removeArray;
                
                [self getMyHuntCounts];
                
            }
            
        }
    } withProgressBlock:nil];
}

- (void)progressButtonClicked:(id)sender{
    
    [self.profileScrollView setContentSize:CGSizeMake(320, contentSize)];
    [self.progressView setHidden:NO];
    [self.completedView setHidden:YES];
    [self.feedView setHidden:YES];
    
}

- (void)completedButtonClicked:(id)sender{
    
    [self.profileScrollView setContentSize:CGSizeMake(320, contentSize2)];
    [self.completedView setHidden:NO];
    [self.progressView setHidden:YES];
    [self.feedView setHidden:YES];
    
}

- (void)feedButtonClicked:(id)sender{
    
    [self.profileScrollView setContentSize:CGSizeMake(320, contentSize3+300)];
    [self.feedView setHidden:NO];
    [self.progressView setHidden:YES];
    [self.completedView setHidden:YES];
    
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
            [self.delegate movePanelToOriginalPosition];
            
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
    
    if (j<self.subscribedHuntNames.count) {
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        KCSQuery* query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:_myEmail];
        KCSQuery* query2 = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:self.subscribedHuntNames[(self.subscribedHuntNames.count - j)-1]];
        KCSQuery* query3 = [KCSQuery queryOnField:@"postType" usingConditional:kKCSNotEqual forValue:@"started hunt"];
        KCSQuery* query4 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2,query3, nil];
        
        [store queryWithQuery:query4 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
                //                         NSLog(@"An error occurred on fetch: %@", errorOrNil);
            } else {
                //got all events back from server -- update table view
                NSLog(@"featured hunt count = %lu",(unsigned long)objectsOrNil.count);
                
                if (objectsOrNil.count >=[[_huntDict2 objectForKey:_subscribedHuntNames[(self.subscribedHuntNames.count - j)-1]]integerValue]) {
                    
                    [self.finishedHuntNames addObject:_subscribedHuntNames[(self.subscribedHuntNames.count - j)-1]];
                    [self.finishedHuntCounts addObject:[NSString stringWithFormat:@"%@/%@",[_huntDict2 objectForKey:_subscribedHuntNames[(self.subscribedHuntNames.count - j)-1]],[_huntDict2 objectForKey:_subscribedHuntNames[(self.subscribedHuntNames.count - j)-1]]]];
                    
                    
                }else{
                    [self.inProgressHuntNames addObject:_subscribedHuntNames[(self.subscribedHuntNames.count - j)-1]];
                    [self.inProgressHuntCounts addObject:[NSString stringWithFormat:@"%lu/%@",(unsigned long)objectsOrNil.count,[_huntDict2 objectForKey:_subscribedHuntNames[(self.subscribedHuntNames.count - j)-1]]]];
                    [self fillProgressHunts:j2];
                    j2++;
                }
                
                j++;
                [self getMyHuntCounts];
                
                
            }
        } withProgressBlock:nil];
        
    }else{
        
        NSLog(@"finished = %@",_finishedHuntCounts);
        NSLog(@"in progress = %@",_inProgressHuntCounts);
        
        NSString *list_count = [NSString stringWithFormat:@"%d",(int)(self.inProgressHuntNames.count+self.finishedHuntNames.count)];
        self.listCountLabel.text = list_count;
        
//        k=0;
//        [self fillProgressHunts];
        l=0;
        [self fillFinishedHunts];
    }
    
}

- (void)fillProgressHunts:(int)num{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(col2*160,
                                                                  (row2*169)+35,
                                                                  160,
                                                                  140)];
    button.userInteractionEnabled = YES;
    [button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
    ++col2;
    if (col2 >= yookaImagesPerRow2015) {
        row2++;
        col2 = 0;
    }else{
        contentSize += 170;
    }
    [self.profileScrollView setContentSize:CGSizeMake(320, contentSize)];
    [self.progressView addSubview:button];
    [self.thumbnails2 addObject:button];
    
    NSString *picUrl = [_huntDict6 objectForKey:_inProgressHuntNames[num]];

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
             
             huntLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:11.f];
             huntLabel.textAlignment = NSTextAlignmentLeft;
             huntLabel.userInteractionEnabled = YES;
             NSString *string = [self.inProgressHuntNames[num] uppercaseString];
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
             ver_bg2.userInteractionEnabled = YES;
             [button addSubview:ver_bg2];
             
             UIView *ver_bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 140)];
             //ver_bg3.backgroundColor = [self colorWithHexString:@"f8f8f8"];
             ver_bg3.backgroundColor = [UIColor whiteColor];
             ver_bg3.userInteractionEnabled = YES;
             [button addSubview:ver_bg3];
             
             UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 33, 33)];
             //UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(133, 3, 25, 25)];
             huntCountLabel.text =self.inProgressHuntCounts[num];
             //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
             huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.f];
             huntCountLabel.textAlignment = NSTextAlignmentCenter;
             huntCountLabel.textColor = [self colorWithHexString:@"f8f8f8"];
             huntCountLabel.backgroundColor = [[self colorWithHexString:@"9a8e92"] colorWithAlphaComponent:0.7];
             huntCountLabel.adjustsFontSizeToFitWidth = YES;
             huntCountLabel.layer.masksToBounds = NO;
             huntCountLabel.numberOfLines = 0;
             //[huntCountLabel sizeToFit];
             
             [button addSubview:huntCountLabel];
             
         }
     }];
}

- (void)fillProgressHunts{
    
    if (self.inProgressHuntNames.count>0 && k<self.inProgressHuntNames.count) {
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(col2*160,
                                                                      (row2*169)+35,
                                                                      160,
                                                                      140)];
        //        if (_myPosts.count>2) {
        //        }
        button.tag = k;
        [button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
        ++col2;
        
        if (col2 >= yookaImagesPerRow2015) {
            row2++;
            col2 = 0;
            contentSize += 170;
        }
        [self.profileScrollView setContentSize:CGSizeMake(320, contentSize)];
        // self.progressView.backgroundColor = [self colorWithHexString:@"f8f8f8"];
        [self.progressView addSubview:button];
        [self.thumbnails2 addObject:button];
        
        NSString *picUrl = [_huntDict6 objectForKey:_inProgressHuntNames[k]];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData* imageData = [ud objectForKey:_inProgressHuntNames[k]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (image) {
            
            UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 160, 157)];
            //                 UIImage *scaledImage = [image scaleToSize:CGSizeMake(150, 150)];
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
            NSString *string = [self.inProgressHuntNames[k] uppercaseString];
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
            
            
            UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 33, 33)];
            //UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(133, 3, 25, 25)];
            huntCountLabel.text  =self.inProgressHuntCounts[k];
            //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
            huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.f];
            huntCountLabel.textAlignment = NSTextAlignmentCenter;
            huntCountLabel.textColor = [self colorWithHexString:@"f8f8f8"];
            
            huntCountLabel.backgroundColor = [[self colorWithHexString:@"9a8e92"] colorWithAlphaComponent:0.7];
            huntCountLabel.adjustsFontSizeToFitWidth = YES;
            huntCountLabel.layer.masksToBounds = NO;
            huntCountLabel.numberOfLines = 0;
            //[huntCountLabel sizeToFit];
            
            [button addSubview:huntCountLabel];
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
                     UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 160, 157)];
                     //                 UIImage *scaledImage = [image scaleToSize:CGSizeMake(150, 150)];
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
                     NSString *string = [self.inProgressHuntNames[k] uppercaseString];
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
                     
                     
                     UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 33, 33)];
                     //UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(133, 3, 25, 25)];
                     huntCountLabel.text  =self.inProgressHuntCounts[k];
                     //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
                     huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.f];
                     huntCountLabel.textAlignment = NSTextAlignmentCenter;
                     huntCountLabel.textColor = [self colorWithHexString:@"f8f8f8"];
                     
                     huntCountLabel.backgroundColor = [[self colorWithHexString:@"9a8e92"] colorWithAlphaComponent:0.7];
                     huntCountLabel.adjustsFontSizeToFitWidth = YES;
                     huntCountLabel.layer.masksToBounds = NO;
                     huntCountLabel.numberOfLines = 0;
                     //[huntCountLabel sizeToFit];
                     
                     [button addSubview:huntCountLabel];
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
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(col3*161,
                                                                      (row3*139)+35,
                                                                      160,
                                                                      140)];
        //        if (_myPosts.count>2) {
        //        }
        button.tag = l;
        [button addTarget:self action:@selector(buttonAction3:) forControlEvents:UIControlEventTouchUpInside];
        ++col3;
        
        if (col3 >= yookaImagesPerRow2015) {
            row3++;
            col3 = 0;
            contentSize2 += 170;
        }
//        [self.completedScrollView setContentSize:CGSizeMake(320, contentSize2)];
        [self.completedView addSubview:button];
        //self.completedView.backgroundColor = [self colorWithHexString:@"f8f8f8"];
        [self.thumbnails3 addObject:button];
        
        NSString *picUrl = [_huntDict6 objectForKey:_finishedHuntNames[l]];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData* imageData = [ud objectForKey:self.finishedHuntNames[l]];
        UIImage *image = [UIImage imageWithData:imageData];
        
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
            
            NSString *string = self.finishedHuntNames[l];
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
           // ver_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
            ver_bg2.backgroundColor = [UIColor whiteColor];
            [button addSubview:ver_bg2];
            
            UIView *ver_bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 140)];
            //ver_bg3.backgroundColor = [self colorWithHexString:@"f8f8f8"];
            ver_bg3.backgroundColor = [UIColor whiteColor];

            [button addSubview:ver_bg3];
            
            UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 33, 33)];
            //UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(133, 3, 25, 25)];
            huntCountLabel.text =self.finishedHuntCounts[l];
            //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
            huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.f];
            huntCountLabel.textAlignment = NSTextAlignmentCenter;
            huntCountLabel.textColor = [self colorWithHexString:@"f8f8f8"];
            huntCountLabel.backgroundColor = [[self colorWithHexString:@"9a8e92"] colorWithAlphaComponent:0.7];
            huntCountLabel.adjustsFontSizeToFitWidth = YES;
            huntCountLabel.layer.masksToBounds = NO;
            huntCountLabel.numberOfLines = 0;
            //[huntCountLabel sizeToFit];
            
            [button addSubview:huntCountLabel];
            
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
                     UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 160, 157)];
                     buttonImage.image = image;
                     buttonImage.contentMode = UIViewContentModeScaleToFill;
                     [buttonImage setBackgroundColor:[UIColor clearColor]];
                     [button addSubview:buttonImage];
                     
                     UIView *huntLabel_bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, 160, 30)];
                     huntLabel_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                     [button addSubview:huntLabel_bg2];
                     
                     UILabel *huntLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 139, 150, 33)];
                     
                     huntLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.f];
                     huntLabel.textAlignment = NSTextAlignmentLeft;
                     
                     NSString *string = self.finishedHuntNames[l];
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
                     ver_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                     [button addSubview:ver_bg2];
                     
                     UIView *ver_bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 140)];
                     ver_bg3.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                     [button addSubview:ver_bg3];
                     
                     
                     UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 33, 33)];
                     //UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(133, 3, 25, 25)];
                     huntCountLabel.text =self.finishedHuntCounts[l];
                     //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
                     huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.f];
                     huntCountLabel.textAlignment = NSTextAlignmentCenter;
                     huntCountLabel.textColor = [self colorWithHexString:@"f8f8f8"];
                     huntCountLabel.backgroundColor = [[self colorWithHexString:@"9a8e92"] colorWithAlphaComponent:0.7];
                     huntCountLabel.adjustsFontSizeToFitWidth = YES;
                     huntCountLabel.layer.masksToBounds = NO;
                     huntCountLabel.numberOfLines = 0;
                     //[huntCountLabel sizeToFit];
                     
                     [button addSubview:huntCountLabel];
                     l++;
                     [self fillFinishedHunts];
                     
                 }
             }];
            
        }
        
    }
    
    if (l==self.finishedHuntNames.count) {
        self.progressView.frame = CGRectMake(0, 300, 320, contentSize2);
    }
    
}

- (void)getMyNewsFeed{
    
    self.myPosts = [NSMutableArray new];
    
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

- (void)fillPictures
{
    item = 0;
    row = 0;
    col = 0;
    for (item=0;item<self.myPosts.count;item++) {
        
        UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
        UITapGestureRecognizer *tapTrice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapThrice:)];
        
        tapOnce.numberOfTapsRequired = 1;
        //        tapTwice.numberOfTapsRequired = 2;
        tapTrice.numberOfTapsRequired = 3;
        //stops tapOnce from overriding tapTwice
        [tapOnce requireGestureRecognizerToFail:tapTrice];
        //        [tapTwice requireGestureRecognizerToFail:tapTrice];
        
        if ([[self.myPosts[item] objectForKey:@"postType"] isEqualToString:@"started hunt"]) {
            
            NSLog(@"type yes");
            _button = [[UIButton alloc] initWithFrame:CGRectMake(col,
                                                                 contentSize3,
                                                                 yookaThumbnailWidth2015_2,
                                                                 305)];
            contentSize3 += 305;
            
        }else{
            _button = [[UIButton alloc] initWithFrame:CGRectMake(col,
                                                                 contentSize3,
                                                                 yookaThumbnailWidth2015_2,
                                                                 325)];
            contentSize3 += 325;
        }
        
        _button.tag = item;
        _button.userInteractionEnabled = YES;
        //        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_button addGestureRecognizer:tapOnce]; //remove the other button action which calls method `button`
        [_button addGestureRecognizer:tapTwice];
        [_button addGestureRecognizer:tapTrice];
        [_button setBackgroundColor:[UIColor grayColor]];
        
        row++;
        
        [self.feedView addSubview:_button];
        [self.thumbnails addObject:_button];
        
        
    }
    
    self.feedView.frame = CGRectMake(0, 300, 320, contentSize3+40);
    [self.profileScrollView setContentSize:CGSizeMake(320, contentSize3+300)];
    
    [self loadImages];
    
}

- (void)tapOnce:(id)sender
{
    //    NSLog(@"Tap once");
}

- (void)tapTwice:(UIGestureRecognizer *)sender
{
    
}

- (void)tapThrice:(id)sender
{
    //    NSLog(@"Tap thrice");
}

- (void)tapTwice2:(id)sender
{

    UIButton* button1 = sender;
    NSUInteger b = button1.tag;

    _postLikers = [NSMutableArray new];
    
    UIButton* button = [self.thumbnails objectAtIndex:b];
    
    [[button viewWithTag:220] removeFromSuperview];
    [[button viewWithTag:221] removeFromSuperview];
    
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

- (void)loadImages
{
    
    //    NSLog(@"load images");
    if (m<self.myPosts.count) {
        
        NSString *dishPicUrl = [[self.myPosts[m] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
        //        NSString *userId = [self.myPosts[m] objectForKey:@"userEmail"];
        //        [_userEmails addObject:userId];
        //        NSLog(@"newsfeed = %@",_newsFeed[i]);
        NSString *dishName = [self.myPosts[m] objectForKey:@"dishName"];
        NSString *venueName = [self.myPosts[m] objectForKey:@"venueName"];
        NSString *venueAddress = [self.myPosts[m] objectForKey:@"venueAddress"];
        NSString *caption = [self.myPosts[m] objectForKey:@"caption"];
        NSString *post_vote = [self.myPosts[m] objectForKey:@"postVote"];
        NSString *kinveyId = [self.myPosts[m] objectForKey:@"_id"];
        NSString *hunt_name = [self.myPosts[m] objectForKeyedSubscript:@"HuntName"];
        NSLog(@"hunt name = %@",hunt_name);
        
        UIButton *button = [self.thumbnails objectAtIndex:m];
        
        [button setBackgroundColor:[self colorWithHexString:@"f0f0f0"]];
        
        
        if ([[self.myPosts[m] objectForKey:@"postType"] isEqualToString:@"started hunt"]) {
            
            NSString *hunt_pic_url = [self.myPosts[m] objectForKey:@"huntPicUrl"];
            
            
            UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 55, 305, 225)];
            [buttonImage setBackgroundColor:[UIColor clearColor]];
            buttonImage.contentMode = UIViewContentModeTopLeft;
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
                     
                     //                NSLog(@"found cache");
                     
                     buttonImage.image = image;
                     [button addSubview:buttonImage];
                     
                    
                     
                     
                     m++;
                     if (m==self.myPosts.count) {
                         [self loadImages2];
                     }
                     [self loadImages];
                     
                 }else{
                     
                     //                NSLog(@"no cache");
                     
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
                              
                             
                              
                              [self.feedView addSubview:button];
                              
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
                     
                     UIImageView *transparent_view = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 175+45, 305, 45)];
                     transparent_view.backgroundColor = [[self colorWithHexString:@"4c4a4a"] colorWithAlphaComponent:0.5f];
                     [button addSubview:transparent_view];
                     
                     
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
                     

                     
                     [self.feedView addSubview:button];
                     
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
                              //                                                      NSLog(@"found image");
                              
                              buttonImage.image = image;
                              [button addSubview:buttonImage];
                              
                              [[SDImageCache sharedImageCache] storeImage:image forKey:kinveyId];
                              buttonImage.image = image;
                              [button addSubview:buttonImage];
                              
                              UIImageView *transparent_view = [[UIImageView alloc]initWithFrame:CGRectMake(7.5, 175+45, 305, 45)];
                              transparent_view.backgroundColor = [[self colorWithHexString:@"4c4a4a"] colorWithAlphaComponent:0.5f];
                              [button addSubview:transparent_view];
                              
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

                              
                              [self.feedView addSubview:button];
                              
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
            
            //             }
            //         }];
            
            //        UIButton *button = [self.thumbnails objectAtIndex:i];
            //
            //        UIImageView *buttonImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 310, 310)];
            //        //                [buttonImage2 setBackgroundColor:[UIColor redColor]];
            //        buttonImage2.image = [UIImage imageNamed:@"YookaPostsBg.png"];
            //        [button addSubview:buttonImage2];
            //
            //        UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 304, 304)];
            //        [buttonImage setBackgroundColor:[UIColor clearColor]];
            //        buttonImage.contentMode = UIViewContentModeScaleAspectFill;
            //        buttonImage.clipsToBounds = YES;
            //        [button addSubview:buttonImage];
            //
            //        [buttonImage setImageWithURL:[NSURL URLWithString:dishPicUrl]
            //                       placeholderImage:nil
            //                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            //
            //                                  UIImageView *buttonImage3 = [[UIImageView alloc]initWithFrame:CGRectMake( 20, 260, 76, 78)];
            //                                  buttonImage3.image = [UIImage imageNamed:@"YookaProfilePicbg.png"];
            //                                  [button addSubview:buttonImage3];
            //
            //
            //                                  UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 290, 45)];
            //                                  dishLabel.textColor = [UIColor whiteColor];
            //                                  [dishLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:30]];
            //                                  dishLabel.text = [dishName uppercaseString];
            //                                  dishLabel.textAlignment = NSTextAlignmentLeft;
            //                                  dishLabel.adjustsFontSizeToFitWidth = YES;
            //                                  dishLabel.numberOfLines = 0;
            //                                  [dishLabel sizeToFit];
            //                                  dishLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
            //                                  dishLabel.layer.shadowRadius = 1;
            //                                  dishLabel.layer.shadowOpacity = 1;
            //                                  dishLabel.layer.shadowOffset = CGSizeMake(2.0, 5.0);
            //                                  dishLabel.layer.masksToBounds = NO;
            //                                  [button addSubview:dishLabel];
            //
            //                                  UILabel *venueLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 315, 155, 30)];
            //                                  venueLabel.textColor = [UIColor orangeColor];
            //                                  [venueLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20]];
            //                                  venueLabel.text = venueName;
            //                                  venueLabel.textAlignment = NSTextAlignmentCenter;
            //                                  venueLabel.adjustsFontSizeToFitWidth = YES;
            //                                  [button addSubview:venueLabel];
            //
            //                                  UIButton *restaurant_button = [UIButton buttonWithType:UIButtonTypeCustom];
            //                                  [restaurant_button  setFrame:CGRectMake(100, 315, 155, 30)];
            //                                  [restaurant_button setBackgroundColor:[UIColor clearColor]];
            //                                  restaurant_button.tag = i;
            //                                  [restaurant_button addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
            //                                  [button addSubview:restaurant_button];
            //
            //                                  UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, 345, 90, 12)];
            //                                  addressLabel.textColor = [UIColor lightGrayColor];
            //                                  [addressLabel setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            //                                  addressLabel.text = venueAddress;
            //                                  addressLabel.textAlignment = NSTextAlignmentRight;
            //                                  addressLabel.adjustsFontSizeToFitWidth = NO;
            //                                  [button addSubview:addressLabel];
            //
            //                                  NSDate *createddate = [_newsFeed[i] objectForKey:@"postDate"];
            //                                  NSDate *now = [NSDate date];
            //                                  NSString *str;
            //                                  NSMutableString *myString = [NSMutableString string];
            //
            //                                  NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createddate];
            //                                  if (secondsBetween<60) {
            //                                      int duration = secondsBetween;
            //                                      str = [NSString stringWithFormat:@"%ds",duration]; //%d or %i both is ok.
            //                                      [myString appendString:str];
            //                                  }else if (secondsBetween<3600) {
            //                                      int duration = secondsBetween / 60;
            //                                      str = [NSString stringWithFormat:@"%dm",duration]; //%d or %i both is ok.
            //                                      [myString appendString:str];
            //                                  }else if (secondsBetween<86400){
            //                                      int duration = secondsBetween / 3600;
            //                                      str = [NSString stringWithFormat:@"%dh",duration]; //%d or %i both is ok.
            //                                      [myString appendString:str];
            //                                  }else if (secondsBetween<604800){
            //                                      int duration = secondsBetween / 86400;
            //                                      str = [NSString stringWithFormat:@"%dd",duration]; //%d or %i both is ok.
            //                                      [myString appendString:str];
            //                                  }else {
            //                                      int duration = secondsBetween / 604800;
            //                                      str = [NSString stringWithFormat:@"%dw",duration]; //%d or %i both is ok.
            //                                      [myString appendString:str];
            //                                  }
            //
            //                                  UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(240, 330, 70, 12)];
            //                                  time_label.text = [NSString stringWithFormat:@"%@",myString];
            //                                  time_label.textColor = [UIColor grayColor];
            //                                  [time_label setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            //                                  time_label.textAlignment = NSTextAlignmentRight;
            //                                  [button addSubview:time_label];
            //
            //                                  UILabel *captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 370, 310, 18)];
            //                                  captionLabel.textColor = [UIColor darkGrayColor];
            //                                  [captionLabel setFont:[UIFont fontWithName:@"Helvetica-LightOblique" size:15]];
            //                                  captionLabel.text = [NSString stringWithFormat:@"\"%@\"",caption];
            //                                  captionLabel.textAlignment = NSTextAlignmentCenter;
            //                                  captionLabel.adjustsFontSizeToFitWidth = YES;
            //                                  [button addSubview:captionLabel];
            //
            //                                  //                                    KCSCollection *yookaObjects2 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
            //                                  //                                    KCSAppdataStore *store2 = [KCSAppdataStore storeWithCollection:yookaObjects2 options:nil];
            //                                  //
            //                                  //                                    KCSQuery* query4 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
            //                                  //                                    KCSQuery* query5 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YAY"];
            //                                  ////                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
            //                                  //                                    KCSQuery* query7 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query4,query5, nil];
            //                                  //
            //                                  //                                    [store2 queryWithQuery:query7 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            //                                  //                                        if (errorOrNil == nil) {
            //                                  //
            //                                  //                                            _yayVote = [NSNumber numberWithInteger:objectsOrNil.count];
            //                                  ////                                            NSLog(@"TRY 1 postVote = %@",_yayVote);
            //                                  //
            //                                  //                                            KCSCollection *yookaObjects3 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
            //                                  //                                            KCSAppdataStore *store3 = [KCSAppdataStore storeWithCollection:yookaObjects3 options:nil];
            //                                  //
            //                                  //                                            KCSQuery* query8 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
            //                                  //                                            KCSQuery* query9 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"NAY"];
            //                                  //                                            //                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
            //                                  //                                            KCSQuery* query10 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query8,query9, nil];
            //                                  //
            //                                  //                                            [store3 queryWithQuery:query10 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            //                                  //                                                if (errorOrNil == nil) {
            //                                  //                                                    _nayVote = [NSNumber numberWithInteger:objectsOrNil.count];
            //                                  ////                                                    NSLog(@"venue name = %@",dishName);
            //                                  ////                                                    NSLog(@"TRY 3 postVote = %@",_nayVote);
            //                                  ////                                                    NSLog(@"yay = %@",_yayVote);
            //                                  ////                                                    NSLog(@"nay = %@",_nayVote);
            //                                  //
            //                                  //                                                    CGFloat percent = [_yayVote floatValue]/([_yayVote doubleValue]+[_nayVote doubleValue]);
            //                                  ////                                                    NSLog(@"percentage = %f",percent);
            //                                  //
            //                                  //                                                    // Calculate this somehow
            //                                  //                                                    UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
            //                                  //                                                    barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
            //                                  //                                                    [button addSubview:barImage];
            //                                  //
            //                                  //                                                    UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
            //                                  //                                                    barPercentage.image = [UIImage imageNamed:@"100.png"];
            //                                  //                                                    [button addSubview:barPercentage];
            //                                  //
            //                                  //                                                    UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
            //                                  //                                                    voteLabel.textColor = [UIColor whiteColor];
            //                                  //                                                    [voteLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
            //                                  //                                                    voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
            //                                  //                                                    voteLabel.textAlignment = NSTextAlignmentCenter;
            //                                  //                                                    voteLabel.adjustsFontSizeToFitWidth = NO;
            //                                  //                                                    [button addSubview:voteLabel];
            //                                  //
            //                                  //                                                    [_gridScrollView addSubview:button];
            //                                  //
            //                                  //                                                    i++;
            //                                  //                                                    [self loadImages];
            //                                  //
            //                                  //                                                }else{
            //                                  ////                                                    NSLog(@"TRY 4 ");
            //                                  //                                                    [_gridScrollView addSubview:button];
            //                                  //
            //                                  //                                                    i++;
            //                                  //                                                    [self loadImages];
            //                                  //                                                }
            //                                  //
            //                                  //                                            } withProgressBlock:nil];
            //                                  //
            //                                  //                                        }else{
            //                                  //
            //                                  ////                                            NSLog(@"TRY 2 ");
            //                                  //                                            KCSCollection *yookaObjects3 = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
            //                                  //                                            KCSAppdataStore *store3 = [KCSAppdataStore storeWithCollection:yookaObjects3 options:nil];
            //                                  //
            //                                  //                                            KCSQuery* query8 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:dishName];
            //                                  //                                            KCSQuery* query9 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"NAY"];
            //                                  //                                            //                                    KCSQuery* query6 = [KCSQuery queryOnField:@"postVote" withExactMatchForValue:@"YES"];
            //                                  //                                            KCSQuery* query10 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query8,query9, nil];
            //                                  //
            //                                  //                                            [store3 queryWithQuery:query10 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            //                                  //                                                if (errorOrNil == nil) {
            //                                  //
            //                                                    _nayVote = [NSNumber numberWithInteger:objectsOrNil.count];
            ////                                                    NSLog(@"venue name = %@",dishName);
            ////                                                    NSLog(@"TRY 3 postVote = %@",_nayVote);
            ////                                                    NSLog(@"yay = %@",_yayVote);
            ////                                                    NSLog(@"nay = %@",_nayVote);
            //
            //                                                    CGFloat percent = [_yayVote floatValue]/([_yayVote doubleValue]+[_nayVote doubleValue]);
            ////                                                    NSLog(@"percentage = %f",percent);
            //
            // Calculate this somehow
            //                                UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
            //                                barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
            //                                [button addSubview:barImage];
            //
            //                                UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
            //                                barPercentage.image = [UIImage imageNamed:@"100.png"];
            //                                [button addSubview:barPercentage];
            
            //                                UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
            //                                voteLabel.textColor = [UIColor whiteColor];
            //                                [voteLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
            //                                voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
            //                                voteLabel.textAlignment = NSTextAlignmentCenter;
            //                                voteLabel.adjustsFontSizeToFitWidth = NO;
            //                                [button addSubview:voteLabel];
            //
            //                                [_gridScrollView addSubview:button];
            //
            //                                                    i++;
            //                                                    [self loadImages];
            //                                  //
            //                                  //                                                }else{
            //                                  ////                                                    NSLog(@"TRY 4 ");
            //                                  //                                                    [_gridScrollView addSubview:button];
            //                                  //
            //                                  //                                                    i++;
            //                                  //                                                    [self loadImages];
            //                                  //                                                }
            //                                  //
            //                                  //                                            } withProgressBlock:nil];
            //                                  //                                        }
            //                                  //
            //                                  //                                    } withProgressBlock:nil];
            //
            //                                  if ([post_vote isEqualToString:@"YAY"]) {
            //                                      CGFloat percent = 1.0;
            //                                      // Calculate this somehow
            //                                      UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
            //                                      barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
            //                                      [button addSubview:barImage];
            //
            //                                      UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
            //                                      barPercentage.image = [UIImage imageNamed:@"100.png"];
            //                                      [button addSubview:barPercentage];
            //
            //                                      UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
            //                                      voteLabel.textColor = [UIColor whiteColor];
            //                                      [voteLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
            //                                      voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
            //                                      voteLabel.textAlignment = NSTextAlignmentCenter;
            //                                      voteLabel.adjustsFontSizeToFitWidth = NO;
            //                                      [button addSubview:voteLabel];
            //                                  }else{
            //                                      CGFloat percent = 0.0;
            //                                      // Calculate this somehow
            //                                      UIImageView *barImage = [[UIImageView alloc]initWithFrame:CGRectMake(35, 390, 250, 20)];
            //                                      barImage.image = [UIImage imageNamed:@"ratingscalebehind.png"];
            //                                      [button addSubview:barImage];
            //
            //                                      UIImageView *barPercentage = [[UIImageView alloc] initWithFrame:CGRectMake(42, 384, 238*percent, 35)];
            //                                      barPercentage.image = [UIImage imageNamed:@"100.png"];
            //                                      [button addSubview:barPercentage];
            //
            //                                      UILabel *voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 383, 40, 35)];
            //                                      voteLabel.textColor = [UIColor whiteColor];
            //                                      [voteLabel setFont:[UIFont fontWithName:@"OpenSans" size:10]];
            //                                      voteLabel.text = [NSString stringWithFormat:@"%d%%",(int)(percent*100)];
            //                                      voteLabel.textAlignment = NSTextAlignmentCenter;
            //                                      voteLabel.adjustsFontSizeToFitWidth = NO;
            //                                      [button addSubview:voteLabel];
            //                                  }
            //                                  //                                                    NSLog(@"percentage = %f",percent);
            //
            //                                  [_gridScrollView addSubview:button];
            //
            //
            //                                  if (i==1) {
            //                                      [self loadImages2];
            //                                  }
            //
            //                                  i++;
            //                                  [self loadImages];
            //
            //                              }];
            
        }
        
        
        
    }
    
    
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
        
        
        UIButton* button = [self.thumbnails objectAtIndex:n];
        

        
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
                     NSLog(@"user id = %@",userId);
                  
                     NSLog(@"user full name = %@",userFullName);
                     
                     
                     UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 25, 240, 30)];
                     userLabel.textColor = [UIColor lightGrayColor];
                     userLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:12.0];
                     
                     
                     
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

                         
                         [self.feedView addSubview:button];
                         
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
                                     
                                     [self.feedView addSubview:button];
                                     
                                     n++;
                                     if (n == self.myPosts.count) {
                                         
                                         [self loadlikes];
                                     }
                                     [self loadImages2];
                                     
                                 }else{
                                     
                                     [self.feedView addSubview:button];
                                     
                                     n++;
                                     if (n == self.myPosts.count) {
                                         
                                         [self loadlikes];
                                     }
                                     [self loadImages2];
                                     
                                 }
                                 
                             }else{
                                 
                                 [self.feedView addSubview:button];
                                 
                                 n++;
                                 if (n == self.myPosts.count) {
                                     
                                     [self loadlikes];
                                 }
                                 [self loadImages2];
                                 
                             }
                             
                         }];
                         
                     }
                     
                     //                [_gridScrollView addSubview:button];
                     //
                     //                 j++;
                     //                 if (j == _newsFeed.count) {
                     //
                     //                     [self loadlikes];
                     //                 }
                     //
                     //                 [self loadImages2];
                     
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
                                              
                                              buttonImage4.image = image;
                                              [button addSubview:buttonImage4];
                                              
                                              buttonImage4.image = image;
                                              [button addSubview:buttonImage4];
                                              
                                              UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                              [user_button  setFrame:CGRectMake(12, 5, 55, 55)];
                                              [user_button setBackgroundColor:[UIColor clearColor]];
                                              user_button.tag = n;
                                              [user_button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
                                              [button addSubview:user_button];
                                              
                                              UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 25, 240, 30)];
                                              userLabel.textColor = [UIColor lightGrayColor];
                                              userLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:12.0];
                                              
                                              if ([self.myPosts[n] objectForKey:@"postType"]) {
                                                  userLabel.text = [[self.myPosts[n] objectForKey:@"postCaption"] uppercaseString];
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
                                              
                                              [self.feedView addSubview:button];
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
                //[rest_arrow addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
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
                     NSLog(@"user id = %@",userId);
                     NSLog(@"user full name = %@",userFullName);
                     
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
                         
                         
                         [self.feedView addSubview:button];
                         
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

                                     
                                    
                                     
                                     [self.feedView addSubview:button];
                                     
                                     n++;
                                     if (n == self.myPosts.count) {
                                         
                                         [self loadlikes];
                                     }
                                     
                                     [self loadImages2];
                                     
                                 }else{
                                     
                                     [self.feedView addSubview:button];
                                     
                                     n++;
                                     if (n == self.myPosts.count) {
                                         
                                         [self loadlikes];
                                     }
                                     
                                     [self loadImages2];
                                     
                                 }
                                 
                             }else{
                                 
                                 [self.feedView addSubview:button];
                                 
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
                                              
                                              
                                              [self.feedView addSubview:button];
                                              
                                              [self.feedView addSubview:button];
                                              
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
    
    self.myEmail2 = [KCSUser activeUser].email;
    
    if(p<self.myPosts.count){
        
        //        YookaBackend *yooka4 = _newsFeed[k];
        
        if ([[self.myPosts[p] objectForKey:@"postType"] isEqualToString:@"started hunt"]) {
            NSLog(@"type yes");
            p++;
            
            [self loadlikes];
            
        }else{
            
            NSString *kinveyId = [self.myPosts[p] objectForKey:@"_id"];
            //        NSLog(@"kinveyId = %@",kinveyId);
            
            NSLog(@"index = %d",p);
            UIButton* button = [self.thumbnails objectAtIndex:p];
            
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
                            
                            if([myArray containsObject:_myEmail2]){
                                
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
    NSLog(@"button %lu pressed 2",(unsigned long)b);
    
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
    media.huntTitle = self.inProgressHuntNames[b];
    media.userEmail = self.myEmail;
    media.emailId = self.myEmail;
    media.userPicUrl = self.myURL;
    media.subscribedHunts = self.cachesubscribedHuntNames;
    media.unsubscribedHunts = self.cacheUnSubscribedHuntNames;
    [self presentViewController:media animated:NO completion:nil];
}

- (void)buttonAction3:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    NSLog(@"button %lu pressed",(unsigned long)b);
    
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
    media.huntTitle = self.finishedHuntNames[b];
    media.userEmail = self.myEmail;
    media.emailId = self.myEmail;
    media.subscribedHunts = self.cachesubscribedHuntNames;
    media.unsubscribedHunts = self.cacheUnSubscribedHuntNames;
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
            
            self.userFollowersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.userFollowersBtn  setFrame:CGRectMake(130, 225, 80, 50)];
            [self.userFollowersBtn setBackgroundColor:[UIColor clearColor]];
            [self.userFollowersBtn addTarget:self action:@selector(userFollowers:) forControlEvents:UIControlEventTouchUpInside];
            [self.profileScrollView addSubview:self.userFollowersBtn];
            
            [self showFollowBtn];

            
        } else {
            
            //got all events back from server -- update table view

            if (!objectsOrNil || !objectsOrNil.count) {
                
                NSString *followersCount = [NSString stringWithFormat:@"0"];
                _followersCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                _followersCountLabel.text = followersCount;
                
                self.userFollowersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.userFollowersBtn  setFrame:CGRectMake(130, 225, 80, 50)];
                [self.userFollowersBtn setBackgroundColor:[UIColor clearColor]];
                [self.userFollowersBtn addTarget:self action:@selector(userFollowers:) forControlEvents:UIControlEventTouchUpInside];
                [self.profileScrollView addSubview:self.userFollowersBtn];
                
                [self showFollowBtn];
                
            } else {
                YookaBackend *yooka = objectsOrNil[0];
                
                _followerUsers = [NSMutableArray arrayWithArray:yooka.followers];
//                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//                [defaults setObject:_followerUsers forKey:@"followers"];
//                [defaults synchronize];
                // _cacheFollowers = _followerUsers;
                //[_followersLabel removeFromSuperview];
                
                NSString *followersCount = [NSString stringWithFormat:@"%lu",(unsigned long)_followerUsers.count];
                NSLog(@"%lu Followers",(unsigned long)_followerUsers.count);
                
                if(followersCount==nil){
                    followersCount=@"0";
                }
                _followersCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                _followersCountLabel.text = followersCount;
                
                self.userFollowersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.userFollowersBtn  setFrame:CGRectMake(130, 225, 80, 50)];
                [self.userFollowersBtn setBackgroundColor:[UIColor clearColor]];
                [self.userFollowersBtn addTarget:self action:@selector(userFollowers:) forControlEvents:UIControlEventTouchUpInside];
                [self.profileScrollView addSubview:self.userFollowersBtn];
                
                if ([_followerUsers containsObject:[KCSUser activeUser].email]) {
                    [self showUnfollowBtn];
                }else{
                    [self showFollowBtn];
                }
            }
            
        }
    } withProgressBlock:nil];

}

- (void)userFollowers:(id)sender
{
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
    media.userFullName = self.userFullName;
    media.userEmail = self.myEmail;
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
            
            _userFollowingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_userFollowingBtn  setFrame:CGRectMake(220, 210, 90, 50)];
            [_userFollowingBtn setBackgroundColor:[UIColor clearColor]];
            [_userFollowingBtn addTarget:self action:@selector(userFollowing:) forControlEvents:UIControlEventTouchUpInside];
            [self.profileScrollView addSubview:_userFollowingBtn];
            
        } else {
            
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
                
                NSString *followingCount = @"0";
                
                _followingCountLabel.text = followingCount;
                _followingCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                [self.profileScrollView addSubview:_followingCountLabel];
                
                _userFollowingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_userFollowingBtn  setFrame:CGRectMake(220, 210, 90, 50)];
                [_userFollowingBtn setBackgroundColor:[UIColor clearColor]];
                [_userFollowingBtn addTarget:self action:@selector(userFollowing:) forControlEvents:UIControlEventTouchUpInside];
                [self.profileScrollView addSubview:_userFollowingBtn];
                
            } else {
                
                YookaBackend *yooka = objectsOrNil[0];
                
                _followingUsers = [NSMutableArray arrayWithArray:yooka.following_users];
                
                NSString *followingCount = [NSString stringWithFormat:@"%lu",(unsigned long)_followingUsers.count];
                
                NSLog(@"%@",followingCount);
                
                if(followingCount==nil){
                    followingCount=@"0";
                }
                _followingCountLabel.text = followingCount;
                _followingCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                [self.profileScrollView addSubview:_followingCountLabel];
                
                _userFollowingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_userFollowingBtn  setFrame:CGRectMake(220, 210, 90, 50)];
                [_userFollowingBtn setBackgroundColor:[UIColor clearColor]];
                [_userFollowingBtn addTarget:self action:@selector(userFollowing:) forControlEvents:UIControlEventTouchUpInside];
                [self.profileScrollView addSubview:_userFollowingBtn];
            }
        }
    } withProgressBlock:nil];
}

- (void)userFollowing:(id)sender
{
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
    media.userEmail = self.myEmail;
    media.userFullName = _userFullName;
    media.followingUsers = _followingUsers;
    [self presentViewController:media animated:NO completion:nil];
}

- (void)showFollowBtn
{
    
//    UIImageView *followBtn = [[UIImageView alloc]initWithFrame:CGRectMake(115, 200, 100, 35)];
//    followBtn.image= [UIImage imageNamed:@"unfollow_new.png"];
//    [self.profileScrollView addSubview:followBtn];
    
    self.followBtn = [[FUIButton alloc]initWithFrame:CGRectMake(110, 201, 101, 24)];
    UIColor * color4 = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    self.followBtn.buttonColor = color4;
    //UIColor * color5 = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    //self.followBtn.shadowColor = color5;
    //self.followBtn.shadowHeight = 3.0f;
    self.followBtn.cornerRadius = 10.0f;
    self.followBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
    [self.followBtn setTitle:@"FOLLOW" forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[self colorWithHexString:@"3ac0ec"] forState:UIControlStateNormal];
    [self.followBtn addTarget:self action:@selector(followBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.profileScrollView addSubview:self.followBtn];
    
    
}

- (void)showUnfollowBtn
{
    

    
    self.followBtn2 = [[FUIButton alloc]initWithFrame:CGRectMake(110, 201, 101, 24)];
    UIColor * color4 = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    self.followBtn2.buttonColor = color4;

    self.followBtn2.cornerRadius = 10.0f;
    self.followBtn2.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:13.0];
    [self.followBtn2 setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
    [self.followBtn2 setTitleColor:[self colorWithHexString:@"3ac0ec"] forState:UIControlStateNormal];
    [self.followBtn2 addTarget:self action:@selector(unFollowBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.profileScrollView addSubview:self.followBtn2];
    

}

- (void)followBtnTouched:(id)sender
{
    //NSLog(@"Follow button pressed");
    
    [self.followBtn setHidden:YES];
    [self showUnfollowBtn];
    [self.followBtn2 setEnabled:YES];
    
    [_followersCountLabel removeFromSuperview];
    
    self.followersCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, 230, 107, 25)];
    self.followersCountLabel.textAlignment = NSTextAlignmentCenter;
    _followersCountLabel.textColor = [UIColor whiteColor];
    if (_followerUsers.count) {
        NSString *followerCount = [NSString stringWithFormat:@"%lu",((unsigned long)_followerUsers.count+1)];
        _followersCountLabel.text = followerCount;
    }else{
        NSString *followerCount = [NSString stringWithFormat:@"1"];
        _followersCountLabel.text = followerCount;
    }
    self.followersCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
    [self.profileScrollView addSubview:_followersCountLabel];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:_myEmail];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            [_followerUsers2 addObject:[KCSUser activeUser].email];
            _followerUsers = _followerUsers2;

            [self saveFollowers];
            [self modifyFollowing];
        } else {
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
                
                [_followerUsers2 addObject:[KCSUser activeUser].email];
                _followerUsers = _followerUsers2;
                                
                [self saveFollowers];
                
                [self modifyFollowing];
                
            } else {
                
                if (objectsOrNil.count>0) {
                    YookaBackend *yooka = objectsOrNil[0];
                    _followerUsers2 = [NSMutableArray arrayWithArray:yooka.followers];
                    if ([_followerUsers2 containsObject:[KCSUser activeUser].email]) {
                        
                    }else{
                        [_followerUsers2 addObject:[KCSUser activeUser].email];
                    }
                }
                

                
                _followerUsers = _followerUsers2;
                [self saveFollowers];
                [self modifyFollowing];
            }
            
        }
    } withProgressBlock:nil];
    
}

- (void)modifyFollowing
{
    NSString *my_email = [KCSUser activeUser].email;
    
    NSLog(@"meee %@",my_email);
    
    NSLog(@"meee2 %@",_myEmail);
    
    KCSCollection *yookaObjects2 = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store2 = [KCSAppdataStore storeWithCollection:yookaObjects2 options:nil];
    
    [store2 loadObjectWithID:my_email withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            if (objectsOrNil && objectsOrNil.count) {
                YookaBackend *backendObject = objectsOrNil[0];
                _followingUsers2 = [NSMutableArray arrayWithArray:backendObject.following_users];
                if ([_followingUsers2 containsObject:_myEmail]) {
                    
                }else{

                    //[_followingUsers2 addObject:my_email];
                    [_followingUsers2 addObject:_myEmail];
                }
                self.followingUsers = self.followingUsers2;
                [self savefollowingUsers];
                
                //NSLog(@"successful reload: %@", backendObject.followers); // event updated
            }else{
                [_followingUsers2 addObject:_myEmail];
                self.followingUsers = self.followingUsers2;
                [self savefollowingUsers];
            }
            
        } else {
            //NSLog(@"error occurred: %@", errorOrNil);
            [_followingUsers2 addObject:my_email];
            self.followingUsers = self.followingUsers2;
            [self savefollowingUsers];
            
        }
    } withProgressBlock:nil];
}

- (void)savefollowingUsers
{
    NSString *my_email = [KCSUser activeUser].email;
    NSString *my_full_name = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = my_email;
    yookaObject.userFullName = my_full_name;
    yookaObject.following_users = _followingUsers2;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event 4 (error= %@).",errorOrNil);
            [self.unFollowBtn2 setEnabled:YES];
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                NSLog(@"Successfully saved event 4 (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                [self.unFollowBtn2 setEnabled:YES];
                
            }
            [self.unFollowBtn2 setEnabled:YES];
        }
    } withProgressBlock:nil];
}

- (void)savefollowingUsers2
{
    NSString *my_email = [KCSUser activeUser].email;
    NSString *my_full_name = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = my_email;
    yookaObject.userFullName = my_full_name;
    yookaObject.following_users = _followingUsers3;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event 3 (error= %@).",errorOrNil);
            
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                 NSLog(@"Successfully saved event 3 (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            }
        }
    } withProgressBlock:nil];
}

- (void)saveFollowers
{
    
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _myEmail;
    yookaObject.userFullName = _userFullName;
    yookaObject.followers = _followerUsers2;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event 1(error= %@).",errorOrNil);
            [self.unFollowBtn2 setEnabled:YES];
            [self.followBtn setEnabled:YES];
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                NSLog(@"Successfully saved event 1(id='%@').", [objectsOrNil[0] kinveyObjectId]);
                [self.unFollowBtn2 setEnabled:YES];

            }
            [self.unFollowBtn2 setEnabled:YES];

        }
    } withProgressBlock:nil];
    [_followersCountLabel removeFromSuperview];
    
    self.followersCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, 230, 107, 25)];
    self.followersCountLabel.textColor = [UIColor whiteColor];
    if (_followerUsers2.count) {
        NSString *followerCount = [NSString stringWithFormat:@"%lu",(unsigned long)_followerUsers2.count];
        _followersCountLabel.text = followerCount;
    }else{
        NSString *followerCount = [NSString stringWithFormat:@"0"];
        _followersCountLabel.text = followerCount;
    }

    self.followersCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
    _followersCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.profileScrollView addSubview:_followersCountLabel];
}

- (void)saveFollowers2
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _myEmail;
    yookaObject.userFullName = _userFullName;
    yookaObject.followers = _followerUsers3;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event 2 (error= %@).",errorOrNil);
            [self.followBtn setEnabled:YES];
            
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                NSLog(@"Successfully saved event 2(id='%@').", [objectsOrNil[0] kinveyObjectId]);
            }
            [self.followBtn setEnabled:YES];
            
        }
    } withProgressBlock:nil];
    
    [_followersCountLabel removeFromSuperview];
    
    self.followersCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, 230, 107, 25)];
    self.followersCountLabel.textColor = [UIColor whiteColor];
    if (_followerUsers3.count) {
        NSString *followerCount = [NSString stringWithFormat:@"%lu",(unsigned long)_followerUsers3.count];
        _followersCountLabel.text = followerCount;
    }else{
        NSString *followerCount = [NSString stringWithFormat:@"0"];
        _followersCountLabel.text = followerCount;
    }

    self.followersCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
    _followersCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.profileScrollView addSubview:_followersCountLabel];
}

- (void)unFollowBtnTouched:(id)sender
{
    // NSLog(@"UnFollow button pressed");
    [self.followBtn2 setHidden:YES];
    [self showFollowBtn];
    [self.followBtn setEnabled:YES];
    [self unFollowUser];
}

- (void)unFollowUser
{
    [_followersCountLabel removeFromSuperview];

    self.followersCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, 230, 107, 25)];
    _followersCountLabel.textColor = [UIColor whiteColor];
    if (_followerUsers.count) {
        NSString *followerCount = [NSString stringWithFormat:@"%lu",((unsigned long)_followerUsers.count-1)];
        _followersCountLabel.text = followerCount;
    }else{
        NSString *followerCount = [NSString stringWithFormat:@"0"];
        _followersCountLabel.text = followerCount;
    }

    self.followersCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
    _followersCountLabel.textAlignment = NSTextAlignmentCenter;
    [self.profileScrollView addSubview:_followersCountLabel];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:_myEmail];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            
            //An error happened, just log for now
            
            _followerUsers = _followerUsers3;
            [self saveFollowers2];
            [self removeFollowing2];

            
        } else {
            
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
                


                _followerUsers = _followerUsers3;
                [self saveFollowers2];
                [self removeFollowing2];

                
            } else {
                
                if (objectsOrNil.count>0) {
                    YookaBackend *yooka = objectsOrNil[0];
                    
                    _followerUsers3 = [NSMutableArray arrayWithArray:yooka.followers];
                    if ([_followerUsers3 containsObject:[KCSUser activeUser].email]) {
                        [_followerUsers3 removeObject:[KCSUser activeUser].email];
                        _followerUsers = _followerUsers3;
                        [self saveFollowers2];
                        [self removeFollowing2];

                    }else{
                        _followerUsers = _followerUsers3;
                        [self saveFollowers2];
                        [self removeFollowing2];
                    }

                }
                
            }
            
        }
    } withProgressBlock:nil];
    
    
}

- (void)removeFollowing2
{
    NSString *my_email = [KCSUser activeUser].email;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store loadObjectWithID:my_email withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            if (objectsOrNil && objectsOrNil.count) {

                YookaBackend *backendObject = objectsOrNil[0];
                _followingUsers3 = [NSMutableArray arrayWithArray:backendObject.following_users];
                if ([_followingUsers3 containsObject:my_email]) {
                    [_followingUsers3 removeObject:my_email];
                    _followingUsers = _followingUsers3;
                    [self savefollowingUsers2];
                }else{
                    
                }
                
                //NSLog(@"successful reload: %@", backendObject.followers); // event updated
            }else{
                _followingUsers = _followingUsers3;
                [self savefollowingUsers2];
            }
            
        } else {
            //NSLog(@"error occurred: %@", errorOrNil);
            _followingUsers = _followingUsers3;
            [self savefollowingUsers2];        }
    } withProgressBlock:nil];
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
            
            
        }
        else {
            
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
@end
