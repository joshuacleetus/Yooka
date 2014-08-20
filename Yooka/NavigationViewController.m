//
//  NavigationViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 5/28/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "NavigationViewController.h"
#import <AsyncImageDownloader.h>
#import "UIImageView+WebCache.h"
#import "YookaBackend.h"
#import "YookaProfileNewViewController.h"
#import "YookaNewsFeedViewController.h"
#import "YookaNewNewsfeedViewController.h"
#import "YookaSearchViewController.h"
#import "UIImage+ImageEffects.h"
#import "YookaAppDelegate.h"
#import "YookaMapViewController.h"
#import "Flurry.h"

@interface NavigationViewController ()

@end

@implementation NavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.bgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, 320, 568)];
//    self.bgImage.image = [UIImage imageNamed:@"profile_background.png"];
//    [self.view addSubview:self.bgImage];
    
    self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{
                                                                 KCSStoreKeyCollectionName : @"userPicture",
                                                                 KCSStoreKeyCollectionTemplateClass : [YookaBackend class]}];
    
    _userEmail = [[KCSUser activeUser] email];
    _userFullName = [NSString stringWithFormat:@"%@ %@",[[KCSUser activeUser].givenName uppercaseString],[[KCSUser activeUser].surname  uppercaseString]];
    
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (INTERFACE_IS_PHONE) {
        if (screenSize.height > 480.0f) {
    
    
            //set background color.
            [self.view setBackgroundColor:[self colorWithHexString:@"212529"]];
            
            UIView *top_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 218)];
            top_bg.backgroundColor = [self colorWithHexString:@"272c30"];
            [self.view addSubview:top_bg];
            
            //set userview here.
            self.userView = [[UIImageView alloc]initWithFrame:CGRectMake(79, 50, 100, 100)];
            self.userView.layer.cornerRadius = self.userView.frame.size.height / 2;
            [self.userView setContentMode:UIViewContentModeScaleAspectFill];
            [self.userView.layer setBorderWidth:4.0];
            [self.userView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [self.userView setClipsToBounds:YES];
            
            //    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 187, 250, 0.25)];
            //    lineView.backgroundColor = [UIColor whiteColor];
            //    [self.view addSubview:lineView];
            
            self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.profileButton  setFrame:CGRectMake(0, 0, 180, 218)];
            [self.profileButton setBackgroundColor:[UIColor clearColor]];
            [self.profileButton addTarget:self action:@selector(profileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.homeButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.profileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.profileButton];
            
            //    UIView *lineViewx = [[UIView alloc] initWithFrame:CGRectMake(12, 100, 1, 500)];
            //    lineViewx.backgroundColor = [UIColor whiteColor];
            //    [self.view addSubview:lineViewx];
            //
            //    UIView *lineViewxy = [[UIView alloc] initWithFrame:CGRectMake(41, 100, 1, 500)];
            //    lineViewxy.backgroundColor = [UIColor whiteColor];
            //    [self.view addSubview:lineViewxy];
            
            // check if image is already cached in userdefaults.
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSData* imageData = [ud objectForKey:@"MyProfilePic"];
            UIImage *image = [UIImage imageWithData:imageData];
            if (image) {
                
                //if image is already there set it to userview.
                [self.userView setImage:image];
                
            }else{
                
                //get the user image from facebook or kinvey if its not cached.
                [self get_user_image];
            }
            [self.view addSubview:self.userView];
            
            //set user name label here
            _usernameLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 240, 24)];
            _usernameLbl.textColor = [UIColor whiteColor];
            _usernameLbl.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.0];
            _usernameLbl.text = [_userFullName uppercaseString];
            _usernameLbl.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:_usernameLbl];
            
            //set home button here
            
            UIImageView *home_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 253-30, 32, 32)];
            [home_image_view setImage:[UIImage imageNamed:@"home_artisse.png"]];
            [self.view addSubview:home_image_view];
            
            UILabel *homeLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 255-30, 205, 30)];
            homeLabel.textColor = [UIColor whiteColor];
            homeLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            homeLabel.textAlignment = NSTextAlignmentLeft;
            [homeLabel setText:@"Home"];
            [self.view addSubview:homeLabel];
            
            self.homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.homeButton  setFrame:CGRectMake(10, 255-30, 210, 35)];
            [self.homeButton setBackgroundColor:[UIColor clearColor]];
            //    [self.homeButton setBackgroundImage:[[UIImage imageNamed:@"home_new.png"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:2.0] forState:UIControlStateNormal];
            //    [self.homeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.homeButton addTarget:self action:@selector(homeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.homeButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.homeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.homeButton];
            
            UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 240-22, 320, 0.25)];
            lineView2.backgroundColor = [self colorWithHexString:@"515558"];
            [self.view addSubview:lineView2];
            
            //set profile button here
            //    UIImageView *profile_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 253, 35, 35)];
            //    [profile_image_view setImage:[UIImage imageNamed:@"profile_artisse.png"]];
            //    [self.view addSubview:profile_image_view];
            
            UIView *lineView3 = [[UIView alloc] initWithFrame:CGRectMake(50, 300-30, 250, 0.25)];
            lineView3.backgroundColor = [self colorWithHexString:@"515558"];
            //[self.view addSubview:lineView3];
            
            //    UILabel *profileLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 255, 205, 30)];
            //    profileLabel.textColor = [UIColor whiteColor];
            //    profileLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            //    profileLabel.textAlignment = NSTextAlignmentLeft;
            //    [profileLabel setText:@"Profile"];
            //    [self.view addSubview:profileLabel];
            
            //set profile navigation button here
            
            
            
            //set newsfeed button here
            UIImageView *newsfeed_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 315-30, 33, 31)];
            [newsfeed_image_view setImage:[UIImage imageNamed:@"newsfeed_artisse.png"]];
            [self.view addSubview:newsfeed_image_view];
            
            UILabel *newsfeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 315-30, 205, 30)];
            newsfeedLabel.textColor = [UIColor whiteColor];
            newsfeedLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            newsfeedLabel.textAlignment = NSTextAlignmentLeft;
            [newsfeedLabel setText:@"Newsfeed"];
            [self.view addSubview:newsfeedLabel];
            
            self.newsFeedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.newsFeedButton  setFrame:CGRectMake(10, 320-30, 210, 35)];
            [self.newsFeedButton setBackgroundColor:[UIColor clearColor]];
            //    [self.newsFeedButton setBackgroundImage:[[UIImage imageNamed:@"newsfeed_new.png"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:2.0] forState:UIControlStateNormal];
            //    [self.homeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.newsFeedButton addTarget:self action:@selector(newsFeedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.newsFeedButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.newsFeedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.newsFeedButton];
            
            UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(50, 360-30, 250, 0.25)];
            lineView4.backgroundColor = [self colorWithHexString:@"515558"];
            //[self.view addSubview:lineView4];
            
            //set upload photo button here
            UIImageView *upload_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 375-30, 33, 31)];
            [upload_image_view setImage:[UIImage imageNamed:@"upload_artisse.png"]];
            [self.view addSubview:upload_image_view];
            
            UILabel *uploadLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 375-30, 205, 30)];
            uploadLabel.textColor = [UIColor whiteColor];
            uploadLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            uploadLabel.textAlignment = NSTextAlignmentLeft;
            [uploadLabel setText:@"Upload Photo"];
            [self.view addSubview:uploadLabel];
            
            self.uploadPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.uploadPhotoButton  setFrame:CGRectMake(10, 370-30, 210, 40)];
            [self.uploadPhotoButton setBackgroundColor:[UIColor clearColor]];
            //    [self.uploadPhotoButton setBackgroundImage:[[UIImage imageNamed:@"camera_new.png"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:2.0] forState:UIControlStateNormal];
            //    [self.homeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.uploadPhotoButton addTarget:self action:@selector(uploadPhotoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.uploadPhotoButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.uploadPhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.uploadPhotoButton];
            
            UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(50, 420-30, 250, 0.25)];
            lineView5.backgroundColor = [self colorWithHexString:@"515558"];
            //[self.view addSubview:lineView5];
            
            //set search button
            
            UIImageView *search_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 432-30, 33, 32)];
            [search_image_view setImage:[UIImage imageNamed:@"search_artisse.png"]];
            [self.view addSubview:search_image_view];
            
            UILabel *searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 435-30, 205, 30)];
            searchLabel.textColor = [UIColor whiteColor];
            searchLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            searchLabel.textAlignment = NSTextAlignmentLeft;
            [searchLabel setText:@"Search"];
            [self.view addSubview:searchLabel];
            
            self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.searchButton  setFrame:CGRectMake(10, 430-30, 210, 40)];
            [self.searchButton setBackgroundColor:[UIColor clearColor]];
            //    [self.searchButton setBackgroundImage:[[UIImage imageNamed:@"camera_new.png"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:2.0] forState:UIControlStateNormal];
            //    [self.homeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.uploadPhotoButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.searchButton];
            
            UIView *lineView6 = [[UIView alloc] initWithFrame:CGRectMake(50, 480-30, 250, 0.25)];
            lineView6.backgroundColor = [self colorWithHexString:@"515558"];
            //[self.view addSubview:lineView6];
            
            UIView *lineView7 = [[UIView alloc] initWithFrame:CGRectMake(50, 540-30, 250, 0.25)];
            lineView7.backgroundColor = [self colorWithHexString:@"515558"];
            //[self.view addSubview:lineView7];
            
            UIView *vertical_line = [[UIView alloc] initWithFrame:CGRectMake(259, 0, 0.5, 586)];
            vertical_line.backgroundColor = [self colorWithHexString:@"515558"];
            [self.view addSubview:vertical_line];
            
            UIImageView *logout_view = [[UIImageView alloc]initWithFrame:CGRectMake(9, 494-30, 34, 32)];
            [logout_view setImage:[UIImage imageNamed:@"logoout_artisse.png"]];
            [self.view addSubview:logout_view];
            
            UILabel *logoutLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 495-30, 205, 30)];
            logoutLabel.textColor = [UIColor whiteColor];
            logoutLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            logoutLabel.textAlignment = NSTextAlignmentLeft;
            [logoutLabel setText:@"Logout"];
            [self.view addSubview:logoutLabel];
            
            self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.logoutButton  setFrame:CGRectMake(10, 495-30, 210, 40)];
            [self.logoutButton setBackgroundColor:[UIColor clearColor]];
            [self.logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            self.logoutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.logoutButton];
            
        }
        
        
        
        else{
            //iPhone 4
            
            [self.view setBackgroundColor:[self colorWithHexString:@"212529"]];
            
            UIView *top_bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 218-30)];
            top_bg.backgroundColor = [self colorWithHexString:@"272c30"];
            [self.view addSubview:top_bg];
            
            self.userView = [[UIImageView alloc]initWithFrame:CGRectMake(79, 40, 100, 100)];
            self.userView.layer.cornerRadius = self.userView.frame.size.height / 2;
            [self.userView setContentMode:UIViewContentModeScaleAspectFill];
            [self.userView.layer setBorderWidth:4.0];
            [self.userView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [self.userView setClipsToBounds:YES];
            
            self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.profileButton  setFrame:CGRectMake(0, 0, 180, 190)];
            [self.profileButton setBackgroundColor:[UIColor clearColor]];
            [self.profileButton addTarget:self action:@selector(profileButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.homeButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.profileButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.profileButton];
            

            // check if image is already cached in userdefaults.
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSData* imageData = [ud objectForKey:@"MyProfilePic"];
            UIImage *image = [UIImage imageWithData:imageData];
            if (image) {
                
                //if image is already there set it to userview.
                [self.userView setImage:image];
                
            }else{
                
                //get the user image from facebook or kinvey if its not cached.
                [self get_user_image];
            }
            [self.view addSubview:self.userView];
            
            //set user name label here
            _usernameLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 160-10, 240, 24)];
            _usernameLbl.textColor = [UIColor whiteColor];
            _usernameLbl.font = [UIFont fontWithName:@"OpenSans-Bold" size:15.0];
            _usernameLbl.text = [_userFullName uppercaseString];
            _usernameLbl.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:_usernameLbl];
            
            //set home button here
            
            UIImageView *home_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 200, 32, 32)];
            [home_image_view setImage:[UIImage imageNamed:@"home_artisse.png"]];
            [self.view addSubview:home_image_view];
            
            UILabel *homeLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 200, 205, 30)];
            homeLabel.textColor = [UIColor whiteColor];
            homeLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            homeLabel.textAlignment = NSTextAlignmentLeft;
            [homeLabel setText:@"Home"];
            [self.view addSubview:homeLabel];
            
            self.homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.homeButton  setFrame:CGRectMake(10, 200, 210, 35)];
            [self.homeButton setBackgroundColor:[UIColor clearColor]];
            //    [self.homeButton setBackgroundImage:[[UIImage imageNamed:@"home_new.png"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:2.0] forState:UIControlStateNormal];
            //    [self.homeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.homeButton addTarget:self action:@selector(homeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.homeButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.homeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.homeButton];
            
            UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 240-22-30, 320, 0.25)];
            lineView2.backgroundColor = [self colorWithHexString:@"515558"];
            [self.view addSubview:lineView2];
            
            
            //set newsfeed button here
            UIImageView *newsfeed_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 255, 33, 31)];
            [newsfeed_image_view setImage:[UIImage imageNamed:@"newsfeed_artisse.png"]];
            [self.view addSubview:newsfeed_image_view];
            
            UILabel *newsfeedLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 255, 205, 30)];
            newsfeedLabel.textColor = [UIColor whiteColor];
            newsfeedLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            newsfeedLabel.textAlignment = NSTextAlignmentLeft;
            [newsfeedLabel setText:@"Newsfeed"];
            [self.view addSubview:newsfeedLabel];
            
            self.newsFeedButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.newsFeedButton  setFrame:CGRectMake(10, 255, 210, 35)];
            [self.newsFeedButton setBackgroundColor:[UIColor clearColor]];
            //    [self.newsFeedButton setBackgroundImage:[[UIImage imageNamed:@"newsfeed_new.png"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:2.0] forState:UIControlStateNormal];
            //    [self.homeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.newsFeedButton addTarget:self action:@selector(newsFeedButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.newsFeedButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.newsFeedButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.newsFeedButton];
            
            UIView *lineView4 = [[UIView alloc] initWithFrame:CGRectMake(50, 360-30-30, 250, 0.25)];
            lineView4.backgroundColor = [self colorWithHexString:@"515558"];
            //[self.view addSubview:lineView4];
            
            //set upload photo button here
            UIImageView *upload_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 310, 33, 31)];
            [upload_image_view setImage:[UIImage imageNamed:@"upload_artisse.png"]];
            [self.view addSubview:upload_image_view];
            
            UILabel *uploadLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 310, 205, 30)];
            uploadLabel.textColor = [UIColor whiteColor];
            uploadLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            uploadLabel.textAlignment = NSTextAlignmentLeft;
            [uploadLabel setText:@"Upload Photo"];
            [self.view addSubview:uploadLabel];
            
            self.uploadPhotoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.uploadPhotoButton  setFrame:CGRectMake(10, 310, 210, 35)];
            [self.uploadPhotoButton setBackgroundColor:[UIColor clearColor]];
            //    [self.uploadPhotoButton setBackgroundImage:[[UIImage imageNamed:@"camera_new.png"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:2.0] forState:UIControlStateNormal];
            //    [self.homeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.uploadPhotoButton addTarget:self action:@selector(uploadPhotoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.uploadPhotoButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.uploadPhotoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.uploadPhotoButton];
            
            UIView *lineView5 = [[UIView alloc] initWithFrame:CGRectMake(50, 360, 250, 0.25)];
            lineView5.backgroundColor = [self colorWithHexString:@"515558"];
            //[self.view addSubview:lineView5];
            
            //set search button
            
            UIImageView *search_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(10, 365, 33, 32)];
            [search_image_view setImage:[UIImage imageNamed:@"search_artisse.png"]];
            [self.view addSubview:search_image_view];
            
            UILabel *searchLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 365, 205, 30)];
            searchLabel.textColor = [UIColor whiteColor];
            searchLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            searchLabel.textAlignment = NSTextAlignmentLeft;
            [searchLabel setText:@"Search"];
            [self.view addSubview:searchLabel];
            
            self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.searchButton  setFrame:CGRectMake(10, 365, 210, 35)];
            [self.searchButton setBackgroundColor:[UIColor clearColor]];
            //    [self.searchButton setBackgroundImage:[[UIImage imageNamed:@"camera_new.png"]stretchableImageWithLeftCapWidth:5.0 topCapHeight:2.0] forState:UIControlStateNormal];
            //    [self.homeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.searchButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.uploadPhotoButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.searchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.searchButton];
            
            UIView *lineView6 = [[UIView alloc] initWithFrame:CGRectMake(50, 480-30-5-30, 250, 0.25)];
            lineView6.backgroundColor = [self colorWithHexString:@"515558"];
            //[self.view addSubview:lineView6];
            
            UIView *lineView7 = [[UIView alloc] initWithFrame:CGRectMake(50, 540-30-5-30, 250, 0.25)];
            lineView7.backgroundColor = [self colorWithHexString:@"515558"];
            //[self.view addSubview:lineView7];
            
            UIView *vertical_line = [[UIView alloc] initWithFrame:CGRectMake(259, 0, 0.5, 586)];
            vertical_line.backgroundColor = [self colorWithHexString:@"515558"];
            [self.view addSubview:vertical_line];
            
            UIImageView *logout_view = [[UIImageView alloc]initWithFrame:CGRectMake(9, 420, 34, 32)];
            [logout_view setImage:[UIImage imageNamed:@"logoout_artisse.png"]];
            [self.view addSubview:logout_view];
            
            UILabel *logoutLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 420, 205, 30)];
            logoutLabel.textColor = [UIColor whiteColor];
            logoutLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            logoutLabel.textAlignment = NSTextAlignmentLeft;
            [logoutLabel setText:@"Logout"];
            [self.view addSubview:logoutLabel];
            
            self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.logoutButton  setFrame:CGRectMake(10, 420, 210, 30)];
            [self.logoutButton setBackgroundColor:[UIColor clearColor]];
            [self.logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            self.logoutButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.logoutButton];
            
    
            
            
            
            
        }
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

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

- (void)get_user_image {
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.isOpen) {
        NSLog(@"Found a cached session");
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 //                      NSLog(@"username = %@",user.name);
                 //                      NSLog(@"user email = %@",[user objectForKey:@"email"]);
                 _userName = user.username;
                 _userFullName = [user.name uppercaseString];
                 [self.navigationItem setTitle:[_userFullName uppercaseString]];
                 _userPicUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", _userName];
                 _userEmail = [user objectForKey:@"email"];
                 //                      NSLog(@"user pic url = %@",_userPicUrl);
                 [self getUserImage];
                 
                 //                 [_usernameLbl setText:[_userFullName uppercaseString]];
                 
             }
         }];
        
        // If there's no cached session, we will show a login button
    } else {
        
        NSLog(@"Cannot found a cached session");
        _userEmail = [[KCSUser activeUser] email];
        _userFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
        _usernameLbl.text = [_userFullName uppercaseString];
        [self.navigationItem setTitle:[_userFullName uppercaseString]];
        _collectionName1 = @"userPicture";
        _customEndpoint1 = @"NewsFeed";
        _fieldName1 = @"_id";
        _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
                
                NSArray *results_array = [NSArray arrayWithArray:results];
                
                if (results_array && results_array.count) {
                    //                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                    _userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                    
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
                             _userImage = image;
                             _userView.image = image;
                             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                             [defaults setObject:UIImagePNGRepresentation(image) forKey:@"MyProfilePic"];
                             [defaults synchronize];
                             [self.view addSubview:_userView];
                             //                            NSLog(@"profile image");
                             
                         }
                     }];
                    
                }else{
                    
                    _userPicUrl = @"http://s25.postimg.org/4qq1lj6nj/minion.jpg";
                    
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
                             _userImage = image;
                             _userView.image = image;
                             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                             [defaults setObject:UIImagePNGRepresentation(image) forKey:@"MyProfilePic"];
                             [defaults synchronize];
                             [self.view addSubview:_userView];
                             //                            NSLog(@"profile image");
                             
                         }
                     }];
                    
                }
                
            }else{
                
                _userPicUrl = @"http://s25.postimg.org/4qq1lj6nj/minion.jpg";
                
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
                         _userImage = image;
                         _userView.image = image;
                         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                         [defaults setObject:UIImagePNGRepresentation(image) forKey:@"MyProfilePic"];
                         [defaults synchronize];
                         [self.view addSubview:_userView];
                         //                            NSLog(@"profile image");
                         
                     }
                 }];
            }
        }];
        
    }
    
}

- (void)getUserImage
{
    [[[AsyncImageDownloader alloc] initWithMediaURL:_userPicUrl successBlock:^(UIImage *image)  {
        
        _userImage = image;
        _userView.image = image;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:UIImagePNGRepresentation(image) forKey:@"MyProfilePic"];
        [defaults synchronize];
        
        //        [self.userView.layer setCornerRadius:self.userView.frame.size.width/2];
        //        [self.userView setClipsToBounds:YES];
        [self.view addSubview:_userView];
        //        NSLog(@"profile image");
//        [self saveUserImage];
    } failBlock:^(NSError *error) {
        //        NSLog(@"Failed to download image due to %@!", error);
    }] startDownload];
}

- (void)saveUserImage
{
    
    //NSLog(@"profile image");
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _userEmail;
    if (_userImage) {
        yookaObject.userImage = _userImage;
    }else{
        yookaObject.userImage = [UIImage imageNamed:@"minion.jpg"];
    }
    yookaObject.userFullName = _userFullName;
    yookaObject.userEmail = _userEmail;
    
    //Kinvey use code: add a new update to the updates collection
    [self.updateStore saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            //NSLog(@"saved successfully");
        } else {
            //NSLog(@"save failed %@",errorOrNil);
        }
    } withProgressBlock:nil];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)homeButtonClicked:(id)sender {
    
    [Flurry logEvent:@"Main_Menu_Home_Button_Clicked"];
    [self.delegate didSelectViewWithName:@"YookaHuntsLandingViewController"];
}

- (IBAction)uploadPhotoButtonClicked:(id)sender {
    [Flurry logEvent:@"Main_Menu_Photo_Upload_Button_Clicked"];
    [self.delegate didSelectViewWithName:@"YookaPostViewController"];
}

- (IBAction)newsFeedButtonClicked:(id)sender {
    [Flurry logEvent:@"Main_Menu_Newsfeed_Button_Clicked"];
    [self.delegate didSelectViewWithName:@"YookaNewsFeedViewController"];
}

- (IBAction)profileButtonClicked:(id)sender {
    [Flurry logEvent:@"Main_Menu_Profile_Button_Clicked"];
    [self.delegate didSelectViewWithName:@"YookaProfileNewViewController"];
}

- (IBAction)searchButtonClicked:(id)sender {
    [Flurry logEvent:@"Main_Menu_Search_Button_Clicked"];
    [self.delegate didSelectViewWithName:@"YookaSearchViewController"];
}

- (IBAction)mapButtonClicked:(id)sender {
    [Flurry logEvent:@"Main_Menu_Map_Button_Clicked"];
    [self.delegate didSelectViewWithName:@"YookaMapViewController"];
}

- (IBAction)logoutButtonClicked:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Log out", nil];
    alert.tag = 0;
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0) {
        
        if (buttonIndex == 0){
            //cancel clicked ...do your action
        }else{
            //log out clicked
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // do work here
                [[KCSUser activeUser] logout];
                
                // Close the session and remove the access token from the cache
                // The session state handler (in the app delegate) will be called automatically
                [FBSession.activeSession closeAndClearTokenInformation];
                
                NSUserDefaults * myNSUserDefaults = [NSUserDefaults standardUserDefaults];
                NSDictionary * dict = [myNSUserDefaults dictionaryRepresentation];
                for (id key in dict) {
                    
                    //heck the keys if u need
                    [myNSUserDefaults removeObjectForKey:key];
                }
                [myNSUserDefaults synchronize];
                                
                // If there's no cached session, we will show a login button
                YookaAppDelegate* appDelegate = (id)[UIApplication sharedApplication].delegate;
                [appDelegate userLoggedOut];

            });
            
        }
        
    } else {
        
        if (buttonIndex == 0) {
            
        } else {
            
        }
        
    }
    
}


@end
