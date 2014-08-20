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
    
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (isiPhone5) {
                
                /*Do iPhone 5 stuff here.*/
                
                CGRect screenRect = CGRectMake(0.f, 0.f, self.view.frame.size.width, 568.f);
                self.scrollView=[[UIScrollView alloc] initWithFrame:screenRect];
                self.scrollView.frame = CGRectMake(0.f, 0.f, self.view.frame.size.width, 568.f);
                self.scrollView.delegate = self;
                CGSize contentSize = CGSizeMake(960, self.view.frame.size.height);
                self.scrollView.contentSize = contentSize;
                self.scrollView.pagingEnabled = YES;
                self.scrollView.showsVerticalScrollIndicator=NO;
                [self.view addSubview:self.scrollView];
                
                self.imageView12 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
                self.imageView12.image = [UIImage imageNamed:@"Sign_up_welcome.jpg"];
                [self.scrollView addSubview:self.imageView12];
                
                self.imageView13 = [[UIImageView alloc]initWithFrame:CGRectMake(320, 0, 320, 568)];
                self.imageView13.image = [UIImage imageNamed:@"Sign_up_bestoflist.png"];
                [self.scrollView addSubview:self.imageView13];
                
                self.imageView14 = [[UIImageView alloc]initWithFrame:CGRectMake(640, 0, 320, 588)];
                self.imageView14.image = [UIImage imageNamed:@"Sign_up_share.jpg"];
                [self.scrollView addSubview:self.imageView14];
                
                self.hunts_pages = [[UIPageControl alloc] init];
                self.hunts_pages.frame = CGRectMake(141,568-110,30,30);
                self.hunts_pages.enabled = TRUE;
                [self.hunts_pages setHighlighted:YES];
                [self.view addSubview:self.hunts_pages];
                
                self.hunts_pages.currentPage = 0;
                self.hunts_pages.numberOfPages = 3;
            
                
                self.fb_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 568-80, 320, 40)];
                [self.fb_image_view setImage:[UIImage imageNamed:@"facebookbutton.png"]];
                [self.view addSubview:self.fb_image_view];
                
                self.signup_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 568-40, 160, 40)];
                [self.signup_image_view setImage:[UIImage imageNamed:@"signupbutton.png"]];
                [self.view addSubview:self.signup_image_view];
                
                self.signin_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(160, 568-40, 160, 40)];
                [self.signin_image_view setImage:[UIImage imageNamed:@"signinbutton.png"]];
                [self.view addSubview:self.signin_image_view];
                
                
                UIButton *fb_button = [[UIButton alloc]initWithFrame:CGRectMake(0, 568-80, 320, 45)];
                UIColor * color2 = [UIColor clearColor];
                [fb_button setBackgroundColor:color2];
                [fb_button setImage:[UIImage imageNamed:@"facebookbutton.png"] forState:UIControlStateNormal];
                [fb_button addTarget:self action:@selector(fbBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:fb_button];

                UIButton *sign_up_btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 568-40, 160, 40)];
                [sign_up_btn setImage:[UIImage imageNamed:@"signupbutton.png"] forState:UIControlStateNormal];
                [sign_up_btn addTarget:self action:@selector(signUpBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:sign_up_btn];
                
                UIButton *sign_in_btn = [[UIButton alloc]initWithFrame:CGRectMake(160, 568-40, 160, 40)];
                [sign_in_btn setImage:[UIImage imageNamed:@"signinbutton.png"] forState:UIControlStateNormal];
                [sign_in_btn addTarget:self action:@selector(signInBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:sign_in_btn];
                
                UIImageView *gray_line = [[UIImageView alloc]initWithFrame:CGRectMake(160, 568-40, 1, 40)];
                [gray_line setBackgroundColor:[self colorWithHexString:@"cccccc"]];
                [self.view addSubview:gray_line];
                
                
//
                
            } else {
                
                /*Do iPhone Classic stuff here.*/
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Coming for iphone 4 soon!"
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Yes", nil];
                
                [alert show];
                
            }
        } else {
            /*Do iPad stuff here.*/
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.fbBtn setEnabled:YES];
    [self.signInBtn setEnabled:YES];
    [self.signUpBtn setEnabled:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.fbBtn setEnabled:YES];
    [self.signInBtn setEnabled:YES];
    [self.signUpBtn setEnabled:YES];
//    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    
//    activityView.center=self.view.center;
//    
//    [activityView stopAnimating];
//    
//    [self.view addSubview:activityView];
}

-(void)scrollViewDidScroll: (UIScrollView*)scrollView
{

    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    
        self.hunts_pages.currentPage = page;
        
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
