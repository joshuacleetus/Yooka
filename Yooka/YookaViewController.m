//
//  YookaViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 09/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "YookaAppDelegate.h"
#import "YookaSignupViewController.h"
#import "YookaSigninViewController.h"
#import "TermsOfServiceViewController.h"
#import <Reachability.h>

@interface YookaViewController ()

@end

@implementation YookaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
//        NSLog(@"app already launched");
        UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
        [self.view setBackgroundColor:color];
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f) {
                
                /*Do iPhone 5 stuff here.*/
                
                self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 102, 120, 120)];
                self.logoImage.image = [UIImage imageNamed:@"Yookatransparent.png"];
                [self.view addSubview:self.logoImage];
                
                self.fbBtn = [[FUIButton alloc]initWithFrame:CGRectMake(16, 268, 288, 43)];
                UIColor * color2 = [UIColor colorWithRed:67/255.0f green:125/255.0f blue:162/255.0f alpha:1.0f];
                self.fbBtn.buttonColor = color2;
                UIColor * color3 = [UIColor colorWithRed:45/255.0f green:93/255.0f blue:124/255.0f alpha:1.0f];
                self.fbBtn.shadowColor = color3;
                self.fbBtn.shadowHeight = 3.0f;
                self.fbBtn.cornerRadius = 6.0f;
                self.fbBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
                [self.fbBtn setTitle:@"Facebook" forState:UIControlStateNormal];
                [self.fbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.fbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.fbBtn addTarget:self action:@selector(fbBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.fbBtn];
                
                self.signInBtn = [[FUIButton alloc]initWithFrame:CGRectMake(16, 321, 288, 43)];
                UIColor * color4 = [UIColor colorWithRed:245/255.0f green:135/255.0f blue:77/255.0f alpha:1.0f];
                self.signInBtn.buttonColor = color4;
                UIColor * color5 = [UIColor colorWithRed:221/255.0f green:117/255.0f blue:62/255.0f alpha:1.0f];
                self.signInBtn.shadowColor = color5;
                self.signInBtn.shadowHeight = 3.0f;
                self.signInBtn.cornerRadius = 6.0f;
                self.signInBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
                [self.signInBtn setTitle:@"Signin" forState:UIControlStateNormal];
                [self.signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.signInBtn addTarget:self action:@selector(signInBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.signInBtn];
                
                self.signUpBtn = [[FUIButton alloc]initWithFrame:CGRectMake(16, 374, 288, 43)];
                UIColor * color6 = [UIColor colorWithRed:216/255.0f green:115/255.0f blue:82/255.0f alpha:1.0f];
                self.signUpBtn.buttonColor = color6;
                UIColor * color7 = [UIColor colorWithRed:185/255.0f green:74/255.0f blue:47/255.0f alpha:1.0f];
                self.signUpBtn.shadowColor = color7;
                self.signUpBtn.shadowHeight = 3.0f;
                self.signUpBtn.cornerRadius = 6.0f;
                self.signUpBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
                [self.signUpBtn setTitle:@"Signup" forState:UIControlStateNormal];
                [self.signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.signUpBtn addTarget:self action:@selector(signUpBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.signUpBtn];
                
                
                UILabel *termsLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 500, 295, 30)];
                termsLbl.textColor = [UIColor whiteColor];
                [termsLbl setFont:[UIFont fontWithName:@"Helvetica" size:9]];
                termsLbl.text = @"Terms of Service";
                termsLbl.textAlignment = NSTextAlignmentCenter;
                termsLbl.adjustsFontSizeToFitWidth = NO;
                [self.view addSubview:termsLbl];
                
                self.termsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_termsBtn setFrame:CGRectMake(100, 500, 120, 30)];
                [_termsBtn setTitle:nil forState:UIControlStateNormal];
                [_termsBtn setBackgroundColor:[UIColor clearColor]];
                [_termsBtn addTarget:self action:@selector(termsofservice:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:_termsBtn];
                
            } else {
                
                /*Do iPhone Classic stuff here.*/
                
                self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 62, 120, 120)];
                self.logoImage.image = [UIImage imageNamed:@"Yookatransparent.png"];
                [self.view addSubview:self.logoImage];
                
                self.fbBtn = [[FUIButton alloc]initWithFrame:CGRectMake(16, 248, 288, 43)];
                UIColor * color2 = [UIColor colorWithRed:67/255.0f green:125/255.0f blue:162/255.0f alpha:1.0f];
                self.fbBtn.buttonColor = color2;
                UIColor * color3 = [UIColor colorWithRed:45/255.0f green:93/255.0f blue:124/255.0f alpha:1.0f];
                self.fbBtn.shadowColor = color3;
                self.fbBtn.shadowHeight = 3.0f;
                self.fbBtn.cornerRadius = 6.0f;
                self.fbBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
                [self.fbBtn setTitle:@"Facebook" forState:UIControlStateNormal];
                [self.fbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.fbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.fbBtn addTarget:self action:@selector(fbBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.fbBtn];
                
                self.signInBtn = [[FUIButton alloc]initWithFrame:CGRectMake(16, 301, 288, 43)];
                UIColor * color4 = [UIColor colorWithRed:245/255.0f green:135/255.0f blue:77/255.0f alpha:1.0f];
                self.signInBtn.buttonColor = color4;
                UIColor * color5 = [UIColor colorWithRed:221/255.0f green:117/255.0f blue:62/255.0f alpha:1.0f];
                self.signInBtn.shadowColor = color5;
                self.signInBtn.shadowHeight = 3.0f;
                self.signInBtn.cornerRadius = 6.0f;
                self.signInBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
                [self.signInBtn setTitle:@"Signin" forState:UIControlStateNormal];
                [self.signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.signInBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.signInBtn addTarget:self action:@selector(signInBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.signInBtn];
                
                self.signUpBtn = [[FUIButton alloc]initWithFrame:CGRectMake(16, 354, 288, 43)];
                UIColor * color6 = [UIColor colorWithRed:216/255.0f green:115/255.0f blue:82/255.0f alpha:1.0f];
                self.signUpBtn.buttonColor = color6;
                UIColor * color7 = [UIColor colorWithRed:185/255.0f green:74/255.0f blue:47/255.0f alpha:1.0f];
                self.signUpBtn.shadowColor = color7;
                self.signUpBtn.shadowHeight = 3.0f;
                self.signUpBtn.cornerRadius = 6.0f;
                self.signUpBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
                [self.signUpBtn setTitle:@"Signup" forState:UIControlStateNormal];
                [self.signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.signUpBtn addTarget:self action:@selector(signUpBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.signUpBtn];
                
                UILabel *termsLbl = [[UILabel alloc]initWithFrame:CGRectMake(120, 415, 100, 30)];
                [termsLbl setFont:[UIFont fontWithName:@"Helvetica" size:10]];
                NSString *string1 = @"Terms of Service";
//                NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:string1];
//                [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica" size:10] range:NSMakeRange(0, string.length)];
//            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];//TextColor
//                UIColor * color = [UIColor whiteColor];
//                NSNumber* underlineNumber = [NSNumber numberWithInteger:NSUnderlineStyleThick];
//                [string1 addAttribute:NSUnderlineStyleAttributeName value:underlineNumber range:NSMakeRange(0, string.length)];
                //Underline color
                NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSBackgroundColorAttributeName: [UIColor clearColor], NSUnderlineStyleAttributeName: @1 };
                termsLbl.textColor = [UIColor whiteColor];
                NSAttributedString *myString = [[NSAttributedString alloc] initWithString:string1 attributes:attributes];
                termsLbl.attributedText = myString;
                [termsLbl setBackgroundColor:[UIColor clearColor]];
//                [string addAttribute:NSUnderlineColorAttributeName value:color range:NSMakeRange(0, string.length)];
//                termsLbl. attributedText = string;
//                termsLbl.textAlignment = NSTextAlignmentCenter;
//                termsLbl.adjustsFontSizeToFitWidth = NO;
                [self.view addSubview:termsLbl];
                
                self.termsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_termsBtn setFrame:CGRectMake(100, 415, 120, 30)];
                [_termsBtn setTitle:nil forState:UIControlStateNormal];
                [_termsBtn setBackgroundColor:[UIColor clearColor]];
                [_termsBtn addTarget:self action:@selector(termsofservice:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:_termsBtn];
                
            }
        } else {
            /*Do iPad stuff here.*/
        }

    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // This is the first launch ever
//        NSLog(@"This is the first launch ever");
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f) {
                /*Do iPhone 5 stuff here.*/
                
                _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320, 586)];
                _scrollView.delegate = self;
                [_scrollView setPagingEnabled:YES];
                _scrollView.showsHorizontalScrollIndicator = NO;
                _scrollView.showsVerticalScrollIndicator = NO;
                [_scrollView setScrollsToTop:NO];
                [self.view addSubview:_scrollView];
                [_scrollView setContentSize:CGSizeMake(320*3, 568)];
                self.automaticallyAdjustsScrollViewInsets = NO;
                
                _imageView12 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
                _imageView12.image = [UIImage imageNamed:@"iphone5splash.png"];
                [_scrollView addSubview:_imageView12];
                
                _imageView13 = [[UIImageView alloc]initWithFrame:CGRectMake(320, 0, 320, 568)];
                _imageView13.image = [UIImage imageNamed:@"iphone5landingscreen.png"];
                [_scrollView addSubview:_imageView13];
                
                _imageView14 = [[UIImageView alloc]initWithFrame:CGRectMake(640, 0, 320, 568)];
                _imageView14.image = [UIImage imageNamed:@"iphone5huntscreen.png"];
                [_scrollView addSubview:_imageView14];
                
                
            } else {
                /*Do iPhone Classic stuff here.*/
                
                _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,320, 480)];
                _scrollView.delegate = self;
                [_scrollView setPagingEnabled:YES];
                _scrollView.showsHorizontalScrollIndicator = NO;
                _scrollView.showsVerticalScrollIndicator = NO;
                [_scrollView setScrollsToTop:NO];
                [self.view addSubview:_scrollView];
                [_scrollView setContentSize:CGSizeMake(320*3, 480)];
                self.automaticallyAdjustsScrollViewInsets = NO;
                
                _imageView12 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
                _imageView12.image = [UIImage imageNamed:@"iphone4splash.png"];
                [_scrollView addSubview:_imageView12];
                
                _imageView13 = [[UIImageView alloc]initWithFrame:CGRectMake(320, 0, 320, 480)];
                _imageView13.image = [UIImage imageNamed:@"iphone4landingscreen.png"];
                [_scrollView addSubview:_imageView13];
                
                _imageView14 = [[UIImageView alloc]initWithFrame:CGRectMake(640, 0, 320, 480)];
                _imageView14.image = [UIImage imageNamed:@"iphone4huntscreen.png"];
                [_scrollView addSubview:_imageView14];
                
            }
        } else {
            /*Do iPad stuff here.*/
        }
        
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.fbBtn setEnabled:YES];
    [self.signInBtn setEnabled:YES];
    [self.signUpBtn setEnabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.fbBtn setEnabled:YES];
    [self.signInBtn setEnabled:YES];
    [self.signUpBtn setEnabled:YES];
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=self.view.center;
    
    [activityView stopAnimating];
    
    [self.view addSubview:activityView];
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{
    float scrollViewWidth = scrollView.frame.size.width;
    float scrollContentSizeWidth = scrollView.contentSize.width;
    float scrollOffset = scrollView.contentOffset.x;
    
    if (scrollOffset == 0)
    {
        // then we are at the top
    }
    else if (scrollOffset + scrollViewWidth > scrollContentSizeWidth)
    {
        // then we are at the end
        
        [_scrollView removeFromSuperview];
        [self viewDidLoad];
        
    }
}

- (IBAction)fbBtnTouched:(id)sender
{
//    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
//    [networkReachability startNotifier];
//    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
//    
//    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    [self.fbBtn setEnabled:NO];
    [self.signInBtn setEnabled:NO];
    [self.signUpBtn setEnabled:NO];
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    activityView.center=self.view.center;
    
    [activityView startAnimating];
    
    [self.view addSubview:activityView];
    
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        NSLog(@"1");
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
//        [[KCSUser activeUser]logout];
        
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email",@"read_friendlists",@"user_location",@"user_birthday"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          YookaAppDelegate* appDelegate = (id)[UIApplication sharedApplication].delegate;
                                          // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                                          [appDelegate sessionStateChanged:session state:state error:error];
                                      }];

        
        // If the session state is not any of the two "open" states when the button is clicked
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for basic_info permissions when opening a session
        
        NSLog(@"2");
        
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info",@"email",@"read_friendlists",@"user_location",@"user_birthday"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             YookaAppDelegate* appDelegate = (id)[UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             
         }];
    }
        
//    }else{
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
//                                                        message:nil
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Ok"
//                                              otherButtonTitles:nil];
//        
//        [alert show];
//        
//    }
}

- (IBAction)signUpBtnTouched:(id)sender
{
    YookaSignupViewController* media = [[YookaSignupViewController alloc]init];
    [self.navigationController pushViewController:media animated:NO];
}

- (IBAction)signInBtnTouched:(id)sender
{
    YookaSigninViewController* media = [[YookaSigninViewController alloc]init];
    [self.navigationController pushViewController:media animated:NO];
}

- (void)termsofservice:(id)sender {
    TermsOfServiceViewController *media = [[TermsOfServiceViewController alloc]init];
    [self presentViewController:media animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
