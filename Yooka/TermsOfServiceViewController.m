//
//  TermsOfServiceViewController.m
//  BeUrSelfie
//
//  Created by Joshua Cleetus on 11/1/13.
//  Copyright (c) 2013 JoshuaSoft. All rights reserved.
//

#import "TermsOfServiceViewController.h"
#import "Reachability.h"

@interface TermsOfServiceViewController ()

@end

@implementation TermsOfServiceViewController

@synthesize webView = _webView;
@synthesize gridScrollView = _gridScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            
            CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            _gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
            _gridScrollView.contentSize= CGSizeMake(320.f, 4250.f);
            _gridScrollView.frame = CGRectMake(0.f, 50.f, 320.f, self.view.frame.size.height);
            [self.view addSubview:_gridScrollView];
            
            terms_imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.f, 4219.f)];
            terms_imageview.image = [UIImage imageNamed:@"License.png"];
            [self.gridScrollView addSubview:terms_imageview];
//            [self.view sendSubviewToBack:backgroundImage];
            
            doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [doneBtn setFrame:CGRectMake(10, 25, 50, 20)];
            [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//            [editProfileBtn setBackgroundImage:[[UIImage imageNamed:@"logoutbtn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [doneBtn addTarget:self action:@selector(dismissTerms:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:doneBtn];
            
        } else {
            
            CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
            _gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
            _gridScrollView.contentSize= CGSizeMake(320.f, 4250.f);
            _gridScrollView.frame = CGRectMake(0.f, 40.f, 320.f, self.view.frame.size.height);
            [self.view addSubview:_gridScrollView];
            
            terms_imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320.f, 4219.f)];
            terms_imageview.image = [UIImage imageNamed:@"License.png"];
            [self.gridScrollView addSubview:terms_imageview];
            
            doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [doneBtn setFrame:CGRectMake(10, 15, 50, 20)];
            [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
            [doneBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            //            [editProfileBtn setBackgroundImage:[[UIImage imageNamed:@"logoutbtn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
            [doneBtn addTarget:self action:@selector(dismissTerms:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:doneBtn];
            
        }
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
    
    
    //self.title = @"Login View";
    
    
}

- (void)dismissTerms:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
