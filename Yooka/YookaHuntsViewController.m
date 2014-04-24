//
//  YookaHuntsViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 12/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaHuntsViewController.h"
#import "YookaBackend.h"
#import "YookaHuntVenuesViewController.h"
#import <AsyncImageDownloader.h>
#import "YookaBackend.h"
#import "BDViewController2.h"
#import "YookaButton.h"
#import <Reachability.h>
#import "UIImageView+WebCache.h"

@interface YookaHuntsViewController ()

@end

@implementation YookaHuntsViewController

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
    
    j=0;
    k=0;
    l=0;
    m=0;
    total_featured_hunts_2 = 0;
    
    _featuredHunts = [NSMutableArray new];
    _objects = [NSMutableArray new];
    _subscribedHunts = [NSMutableArray new];
    _subscribedHuntNames = [NSMutableArray new];
    _unsubscribedHunts = [NSMutableArray new];
    _unsubscribedHuntNames = [NSMutableArray new];
    _objects = [NSMutableArray new];
    _objects2 = [NSMutableArray new];
    _featuredHuntsDictionary = [[NSMutableDictionary alloc]init];
    _following_users = [NSMutableArray new];
    _following_users2 = [NSMutableArray new];
    _followingUserSubscribedHuntNames = [NSMutableArray new];
    _followingUserSubscribedHunts = [NSMutableArray new];
    _following_users_fullname = [NSMutableArray new];
    _following_users_userpicurl = [NSMutableArray new];
    _following_users_userpicurl2 = [NSMutableArray new];
    _following_users_huntname = [NSMutableArray new];
    _following_users_email = [NSMutableArray new];
    _following_users_logopicurl = [NSMutableArray new];
    _following_users_fullname2 = [NSMutableArray new];
    
    [self showActivityIndicator];
    
    _userEmail = [KCSUser activeUser].email;
    _myEmail = [KCSUser activeUser].email;
    _myFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
    
    if (_textField) {
        [_textField removeFromSuperview];
    }
    if (_total) {
        [_total removeFromSuperview];
    }
    if (_scrollView1) {
        [_scrollView1 removeFromSuperview];
    }
    if (_scrollView2) {
        [_scrollView2 removeFromSuperview];
    }
    
    //    _textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, 280, 30)];
    //    _textField.borderStyle = UITextBorderStyleRoundedRect;
    //    _textField.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    //    _textField.textColor = [UIColor lightGrayColor];
    //    UIColor *color1 = [UIColor lightGrayColor];
    //    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"             🔍 Search Hunts" attributes:@{NSForegroundColorAttributeName: color1}];
    //    _textField.backgroundColor = [UIColor whiteColor];
    //    _textField.autocorrectionType = UITextAutocorrectionTypeNo;
    //    _textField.keyboardType = UIKeyboardTypeDefault;
    //    _textField.returnKeyType = UIReturnKeySearch;
    //    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    //    [_textField addTarget:self
    //                   action:@selector(textFieldDone:)
    //         forControlEvents:UIControlEventEditingDidEndOnExit];
    //    [self.navigationController.navigationBar addSubview:_textField];
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    [self.navigationItem setTitle:@"HUNTS"];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
        } else {
            /*Do iPhone Classic stuff here.*/
        }
    } else {
            /*Do iPad stuff here.*/
        }
    
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            
            _imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 63, 320, 175)];
            _imageView1.image = [UIImage imageNamed:@"top_hunt.png"];
            [self.view addSubview:_imageView1];
            
            _scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 99, 280, 121)];
            self.scrollView1.delegate = self;
            [self.view addSubview:_scrollView1];
            
            [self.scrollView1 setPagingEnabled:YES];
            self.scrollView1.showsHorizontalScrollIndicator = NO;
            
            self.hunts_pages = [[UIPageControl alloc] init];
            self.hunts_pages.frame = CGRectMake(141,206,39,37);
            self.hunts_pages.enabled = TRUE;
            [self.hunts_pages setHighlighted:YES];
            [self.view addSubview:self.hunts_pages];
            
            //    _hunts_pages.backgroundColor = [UIColor whiteColor];
            
            _middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 238, 320, 136)];
            _middleImageView.image = [UIImage imageNamed:@"yookabackground.png"];
            [self.view addSubview:_middleImageView];
            
            _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 377, 320, 142)];
            _imageView2.image = [UIImage imageNamed:@"hunt_bottom.png"];
            [self.view addSubview:_imageView2];
            
            _scrollView2 = [[UIScrollView alloc]initWithFrame:CGRectMake(1, 240, 320, 134)];
            self.scrollView2.delegate = self;
            [self.view addSubview:_scrollView2];
            self.scrollView2.contentSize = CGSizeMake(320.5f, self.scrollView2.frame.size.height);
            self.scrollView2.showsHorizontalScrollIndicator = NO;
            [self.scrollView2 setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
            self.scrollView2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.scrollView2.contentMode = UIViewContentModeScaleToFill;
            
            _scrollView3 = [[UIScrollView alloc] initWithFrame:CGRectMake(3, 373, 314, 131)];
            self.scrollView3.delegate = self;
            [self.view addSubview:_scrollView3];
            
            [self.scrollView3 setPagingEnabled:YES];
            self.scrollView3.showsHorizontalScrollIndicator = NO;
            
            self.following_hunts_pages = [[UIPageControl alloc] init];
            self.following_hunts_pages.frame = CGRectMake(141,485,39,37);
            self.following_hunts_pages.enabled = TRUE;
            [self.following_hunts_pages setHighlighted:YES];
            [self.view addSubview:self.following_hunts_pages];
            
            _featured_title = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 62, 23)];
            _featured_title.textColor = [UIColor whiteColor];
            _featured_title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
            _featured_title.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:_featured_title];
            
            [self getFeaturedHunts];
            [self checkforUserFollowing];
            [self getUserPicture];
            
        } else {
            /*Do iPhone Classic stuff here.*/
            
            _imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 63, 320, 140)];
            _imageView1.image = [UIImage imageNamed:@"top_hunt.png"];
            [self.view addSubview:_imageView1];
            
            _scrollView1 = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 89, 280, 121)];
            self.scrollView1.delegate = self;
            [self.view addSubview:_scrollView1];
            
            [self.scrollView1 setPagingEnabled:YES];
            self.scrollView1.showsHorizontalScrollIndicator = NO;
            
            self.hunts_pages = [[UIPageControl alloc] init];
            self.hunts_pages.frame = CGRectMake(141,171,39,37);
            self.hunts_pages.enabled = TRUE;
            [self.hunts_pages setHighlighted:YES];
            [self.view addSubview:self.hunts_pages];
            
            //    _hunts_pages.backgroundColor = [UIColor whiteColor];
            
            _middleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 198, 320, 136)];
            _middleImageView.image = [UIImage imageNamed:@"yookabackground.png"];
            [self.view addSubview:_middleImageView];
            
            _imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 320, 320, 122)];
            _imageView2.image = [UIImage imageNamed:@"hunt_bottom.png"];
            [self.view addSubview:_imageView2];
            
            _scrollView2 = [[UIScrollView alloc]initWithFrame:CGRectMake(1, 200, 320, 134)];
            self.scrollView2.delegate = self;
            [self.view addSubview:_scrollView2];
            self.scrollView2.contentSize = CGSizeMake(320.5f, self.scrollView2.frame.size.height);
            self.scrollView2.showsHorizontalScrollIndicator = NO;
            [self.scrollView2 setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
            self.scrollView2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.scrollView2.contentMode = UIViewContentModeScaleToFill;
            
            _scrollView3 = [[UIScrollView alloc] initWithFrame:CGRectMake(3, 323, 314, 115)];
            self.scrollView3.delegate = self;
            [self.view addSubview:_scrollView3];
            
            [self.scrollView3 setPagingEnabled:YES];
            self.scrollView3.showsHorizontalScrollIndicator = NO;
            
            self.following_hunts_pages = [[UIPageControl alloc] init];
            self.following_hunts_pages.frame = CGRectMake(141,435,39,37);
            self.following_hunts_pages.enabled = TRUE;
            [self.following_hunts_pages setHighlighted:YES];
            [self.view addSubview:self.following_hunts_pages];
            
            _featured_title = [[UILabel alloc]initWithFrame:CGRectMake(20, 70, 62, 23)];
            _featured_title.textColor = [UIColor whiteColor];
            _featured_title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0];
            _featured_title.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:_featured_title];
            
            [self getFeaturedHunts];
            [self checkforUserFollowing];
            [self getUserPicture];
        }
    } else {
        /*Do iPad stuff here.*/
    }
    
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.closeButton2 removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showReloadButton {
    
    UIBarButtonItem * reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(viewDidLoad)];
    reloadButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = reloadButton;

}

- (void)showActivityIndicator {
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(305, 9, 27, 27)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

- (void)stopActivityIndicator {
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(305, 9, 27, 27)];
    [activityIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = nil;
    [self showReloadButton];
}

-(IBAction)textFieldDone:(id)sender
{
    [_textField resignFirstResponder];
}

- (void)getFeaturedHunts
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"FeaturedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store queryWithQuery:[KCSQuery query] withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
//            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            
        } else {
            //got all events back from server -- update table view
//            NSLog(@"featured hunts = %@",objectsOrNil);
            _featuredHunts = [NSMutableArray arrayWithArray:objectsOrNil];
            [self checkSubscribedHunts];

        }
    } withProgressBlock:nil];

}

- (void)getFeaturedHuntCounts
{
    int x=0;
    for (x=0; x<_featuredHunts.count; x++) {
        YookaBackend *yooka = _featuredHunts[x];
        [_featuredHuntsDictionary setObject:yooka.Count forKey:yooka.Name];
//        NSLog(@"featured dictionary = %@",_featuredHuntsDictionary);
    }
    if (x==_featuredHunts.count) {
        [self checkSubscribedHunts];
    }

}


//- (void)getSkylineCount
//{
//        NSString *huntName = @"SKYLINEhunt";
//        NSLog(@"hunt name = %@",huntName);
//        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaPosts" ofClass:[YookaBackend class]];
//        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
//        
//        KCSQuery* query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:_userEmail];
//        KCSQuery* query2 = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:huntName];
//        KCSQuery* query3 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2, nil];
//        [store queryWithQuery:query3 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
//            if (errorOrNil != nil) {
//                //An error happened, just log for now
//                NSLog(@"An error occurred on fetch: %@", errorOrNil);
//                
//            } else {
//                
//                //got all events back from server -- update table view
//                NSLog(@"yooksss count = %@,%@",objectsOrNil,huntName);
//                _skylineCount = [NSString stringWithFormat:@"%lu",(unsigned long)objectsOrNil.count];
// 
//            }
//
//        } withProgressBlock:nil];
//}
//

- (void)checkSubscribedHunts
{
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:_userEmail];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
//            NSLog(@"An error occurred on fetch: %@", errorOrNil);
//            _unsubscribedHunts = _featuredHunts;
//            [self modifyFeaturedHunts];
            
//            NSLog(@"try 1");
            
        } else {
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
//                NSLog(@"try 2");

                
                _unsubscribedHunts = _featuredHunts;
                NSLog(@"unsubscribed hunts = %lu",(unsigned long)_unsubscribedHunts.count);
                if (_unsubscribedHunts.count == _featuredHunts.count) {
                    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                        if (screenSize.height > 480.0f) {
                            /*Do iPhone 5 stuff here.*/
                            UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 40)];
                            headingLabel.textColor = [UIColor blackColor];
                            headingLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:20.0];
                            headingLabel.textAlignment = NSTextAlignmentCenter;
                            headingLabel.numberOfLines = 0;
                            [headingLabel setText:@"Start Conquering!"];
                            [self.middleImageView addSubview:headingLabel];
                            
                            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 40, 200, 60)];
                            contentLabel.textColor = [UIColor blackColor];
                            contentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                            contentLabel.textAlignment = NSTextAlignmentCenter;
                            contentLabel.numberOfLines = 0;
                            [contentLabel setText:@"Start some of the featured hunts above!"];
                            [self.middleImageView addSubview:contentLabel];
                        } else {
                            /*Do iPhone Classic stuff here.*/
                            UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 40)];
                            headingLabel.textColor = [UIColor blackColor];
                            headingLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:20.0];
                            headingLabel.textAlignment = NSTextAlignmentCenter;
                            headingLabel.numberOfLines = 0;
                            [headingLabel setText:@"Start Conquering!"];
                            [self.middleImageView addSubview:headingLabel];
                            
                            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 200, 60)];
                            contentLabel.textColor = [UIColor blackColor];
                            contentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                            contentLabel.textAlignment = NSTextAlignmentCenter;
                            contentLabel.numberOfLines = 0;
                            [contentLabel setText:@"Start some of the featured hunts above!"];
                            [self.middleImageView addSubview:contentLabel];
                        }
                    } else {
                        /*Do iPad stuff here.*/
                    }
                    

                }
                
                int x=0;
                for (x=0; x<_unsubscribedHunts.count; x++) {
                    YookaBackend *yooka = _unsubscribedHunts[x];
                    [_unsubscribedHuntNames addObject:yooka.Name];
                }
                if (x==_unsubscribedHuntNames.count) {
                    [self fillFeauturedHunts];
                }
                
            } else {
//                NSLog(@"try 3");

                YookaBackend *yooka = objectsOrNil[0];
//                NSLog(@"hunts = %@",yooka.HuntNames);
                _subscribedHuntNames = [NSMutableArray arrayWithArray:yooka.HuntNames];
                [self checkforUnsubscribedHunts];
                
            }

        }
    } withProgressBlock:nil];
    
}

- (void)checkforUnsubscribedHunts
{

        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"FeaturedHunts" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        KCSQuery *query = [KCSQuery queryOnField:@"Name" usingConditionalsForValues:kKCSNotIn,_subscribedHuntNames, nil];
        
        [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
                //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
//                NSLog(@"try 4");
            } else {
                //got all events back from server -- update table view
                //            NSLog(@"modify featured hunts = %@",objectsOrNil);
                _unsubscribedHunts = [NSMutableArray arrayWithArray:objectsOrNil];
                [self getUnsubscribedHunts];
//                NSLog(@"try 5");

            }
        } withProgressBlock:nil];
}

- (void)getUnsubscribedHunts
{
//    NSLog(@"unsubscribed hunts = %lu",(unsigned long)_unsubscribedHunts.count);
//    NSLog(@"featured hunts = %lu",(unsigned long)_featuredHunts.count);
    
    if (_unsubscribedHunts.count == 0) {
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f) {
                /*Do iPhone 5 stuff here.*/
                UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 300, 40)];
                headingLabel.textColor = [UIColor whiteColor];
                headingLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:18.0];
                headingLabel.textAlignment = NSTextAlignmentCenter;
                headingLabel.numberOfLines = 0;
                [headingLabel setText:@"More Hunts Dropping Soon!"];
                [self.imageView1 addSubview:headingLabel];
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, 260, 60)];
                contentLabel.textColor = [UIColor whiteColor];
                contentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                contentLabel.textAlignment = NSTextAlignmentCenter;
                contentLabel.numberOfLines = 0;
                [contentLabel setText:@"You’re currently doing all our featured hunts. Be on the lookout for the next. Happy Hunting!"];
                [self.imageView1 addSubview:contentLabel];
            } else {
                /*Do iPhone Classic stuff here.*/
                UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 300, 40)];
                headingLabel.textColor = [UIColor whiteColor];
                headingLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:18.0];
                headingLabel.textAlignment = NSTextAlignmentCenter;
                headingLabel.numberOfLines = 0;
                [headingLabel setText:@"More Hunts Dropping Soon!"];
                [self.imageView1 addSubview:headingLabel];
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, 260, 60)];
                contentLabel.textColor = [UIColor whiteColor];
                contentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                contentLabel.textAlignment = NSTextAlignmentCenter;
                contentLabel.numberOfLines = 0;
                [contentLabel setText:@"You’re currently doing all our featured hunts. Be on the lookout for the next. Happy Hunting!"];
                [self.imageView1 addSubview:contentLabel];
            }
        } else {
            /*Do iPad stuff here.*/
        }
        
    }
    
    if (_unsubscribedHunts.count == _featuredHunts.count) {
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f) {
                /*Do iPhone 5 stuff here.*/
                UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 200, 40)];
                headingLabel.textColor = [UIColor blackColor];
                headingLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:20.0];
                headingLabel.textAlignment = NSTextAlignmentCenter;
                headingLabel.numberOfLines = 0;
                [headingLabel setText:@"Start Conquering!"];
                [self.middleImageView addSubview:headingLabel];
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 40, 200, 60)];
                contentLabel.textColor = [UIColor blackColor];
                contentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                contentLabel.textAlignment = NSTextAlignmentCenter;
                contentLabel.numberOfLines = 0;
                [contentLabel setText:@"Start some of the featured hunts above!"];
                [self.middleImageView addSubview:contentLabel];
            } else {
                /*Do iPhone Classic stuff here.*/
                UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 200, 40)];
                headingLabel.textColor = [UIColor blackColor];
                headingLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:20.0];
                headingLabel.textAlignment = NSTextAlignmentCenter;
                headingLabel.numberOfLines = 0;
                [headingLabel setText:@"Start Conquering!"];
                [self.middleImageView addSubview:headingLabel];
                
                UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 25, 200, 60)];
                contentLabel.textColor = [UIColor blackColor];
                contentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                contentLabel.textAlignment = NSTextAlignmentCenter;
                contentLabel.numberOfLines = 0;
                [contentLabel setText:@"Start some of the featured hunts above!"];
                [self.middleImageView addSubview:contentLabel];
            }
        } else {
            /*Do iPad stuff here.*/
        }
        

    }

    int x=0;
    for (x=0; x<_unsubscribedHunts.count; x++) {
        YookaBackend *yooka = _unsubscribedHunts[x];
        [_unsubscribedHuntNames addObject:yooka.Name];
    }
    if (x==_unsubscribedHuntNames.count) {
        [self fillFeauturedHunts];
        [self getSubscribedHunts];
    }
}


- (void)checkforUserFollowing
{
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store loadObjectWithID:_userEmail withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            
            if (!objectsOrNil || !objectsOrNil.count) {
                
//                NSLog(@"try1");
                
            }else{
                
//                NSLog(@"try2");

                YookaBackend *backendObject = objectsOrNil[0];
                _following_users = [NSMutableArray arrayWithArray:backendObject.following_users];
//                NSLog(@"following user count = %lu",(unsigned long)_following_users.count);
                
                if (_following_users.count == 0) {
                    
                    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                    
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                        if (screenSize.height > 480.0f) {
                            /*Do iPhone 5 stuff here.*/
                            UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 300, 40)];
                            headingLabel.textColor = [UIColor whiteColor];
                            headingLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:18.0];
                            headingLabel.textAlignment = NSTextAlignmentCenter;
                            headingLabel.numberOfLines = 0;
                            [headingLabel setText:@"Find Your Friends!"];
                            [self.imageView2 addSubview:headingLabel];
                            
                            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, 260, 60)];
                            contentLabel.textColor = [UIColor whiteColor];
                            contentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                            contentLabel.textAlignment = NSTextAlignmentCenter;
                            contentLabel.numberOfLines = 0;
                            [contentLabel setText:@"Follow your friends to see what hunts your friends are on!"];
                            [self.imageView2 addSubview:contentLabel];
                        } else {
                            /*Do iPhone Classic stuff here.*/
                            UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 40)];
                            headingLabel.textColor = [UIColor whiteColor];
                            headingLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:18.0];
                            headingLabel.textAlignment = NSTextAlignmentCenter;
                            headingLabel.numberOfLines = 0;
                            [headingLabel setText:@"Find Your Friends!"];
                            [self.imageView2 addSubview:headingLabel];
                            
                            UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 40, 260, 60)];
                            contentLabel.textColor = [UIColor whiteColor];
                            contentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                            contentLabel.textAlignment = NSTextAlignmentCenter;
                            contentLabel.numberOfLines = 0;
                            [contentLabel setText:@"Follow your friends to see what hunts your friends are on!"];
                            [self.imageView2 addSubview:contentLabel];
                        }
                    } else {
                        /*Do iPad stuff here.*/
                    }
                    

                }

//                NSLog(@"successful reload: %@", backendObject.following_users); // event updated
                if (_following_users.count>5) {
                    NSMutableIndexSet *picks = [NSMutableIndexSet indexSet];
                    do {
                        [picks addIndex:arc4random() % _following_users.count];
                    } while (picks.count != 5);
                    [picks enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
//                        NSLog(@"Element at index %ud: %@", idx, [_following_users objectAtIndex:idx]);
                        [_following_users2 addObject:[_following_users objectAtIndex:idx]];
                    }];
                    [self checkforfollowingusersHunts];
                }else{
                    _following_users2 = [NSMutableArray arrayWithArray:_following_users];
                    [self checkforfollowingusersHunts];
                }
                
            }

        } else {

            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                if (screenSize.height > 480.0f) {
                    /*Do iPhone 5 stuff here.*/
                    UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 300, 40)];
                    headingLabel.textColor = [UIColor whiteColor];
                    headingLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:18.0];
                    headingLabel.textAlignment = NSTextAlignmentCenter;
                    headingLabel.numberOfLines = 0;
                    [headingLabel setText:@"Find Your Friends!"];
                    [self.imageView2 addSubview:headingLabel];
                    
                    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 50, 260, 60)];
                    contentLabel.textColor = [UIColor whiteColor];
                    contentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                    contentLabel.textAlignment = NSTextAlignmentCenter;
                    contentLabel.numberOfLines = 0;
                    [contentLabel setText:@"Follow your friends to see what hunts your friends are on!"];
                    [self.imageView2 addSubview:contentLabel];
                } else {
                    /*Do iPhone Classic stuff here.*/
                    UILabel *headingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 40)];
                    headingLabel.textColor = [UIColor whiteColor];
                    headingLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:18.0];
                    headingLabel.textAlignment = NSTextAlignmentCenter;
                    headingLabel.numberOfLines = 0;
                    [headingLabel setText:@"Find Your Friends!"];
                    [self.imageView2 addSubview:headingLabel];
                    
                    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 40, 260, 60)];
                    contentLabel.textColor = [UIColor whiteColor];
                    contentLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
                    contentLabel.textAlignment = NSTextAlignmentCenter;
                    contentLabel.numberOfLines = 0;
                    [contentLabel setText:@"Follow your friends to see what hunts your friends are on!"];
                    [self.imageView2 addSubview:contentLabel];
                }
            } else {
                /*Do iPad stuff here.*/
            }
            
            NSLog(@"error occurred: %@", errorOrNil);

            
            [self stopActivityIndicator];
            
        }
    } withProgressBlock:nil];
    
}

- (void)checkforfollowingusersHunts
{
    if (k<_following_users2.count) {
//        NSLog(@"k=%@",_following_users2);
        NSString *followingUserName = _following_users2[k];
//        NSLog(@"username = %@",followingUserName);
        _followingUserSubscribedHuntNames = [NSMutableArray new];
        _followingUserSubscribedHunts = [NSMutableArray new];
        [self checkFollowingUserSubscribedHunts:followingUserName];

    }
    if (k==_following_users2.count) {
            [self stopActivityIndicator];
    }
}

- (void)checkFollowingUserSubscribedHunts:(NSString*)username
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:username];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
//            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            //            _unsubscribedHunts = _featuredHunts;
            //            [self modifyFeaturedHunts];
        } else {
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
//                NSLog(@"k=%d",k);
                k++;
                [self checkforfollowingusersHunts];

            }else{

                YookaBackend *yooka = objectsOrNil[0];
//                NSLog(@"hunts = %@",yooka.HuntNames);
                _followingUserSubscribedHuntNames = [NSMutableArray arrayWithArray:yooka.HuntNames];
//                NSLog(@"subscribed hunt names = %@",_followingUserSubscribedHuntNames);
                [self getFollowingUserSubscribedHunts:username];
            }
            
        }
    } withProgressBlock:nil];
}

- (void)getFollowingUserSubscribedHunts:(NSString*)user_name
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"FeaturedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"Name" usingConditionalsForValues:kKCSIn,_followingUserSubscribedHuntNames, nil];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
//            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
//            NSLog(@"modify featured hunts = %@",objectsOrNil);
            _followingUserSubscribedHunts = [NSMutableArray arrayWithArray:objectsOrNil];
            [self getUserImageUrl:user_name];
        }
    } withProgressBlock:nil];
}

- (void)getUserImageUrl:(NSString*)user_name
{
    _collectionName1 = @"userPicture";
    _customEndpoint1 = @"NewsFeed";
    _fieldName1 = @"_id";
    _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:user_name,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
    
    [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
        if ([results isKindOfClass:[NSArray class]]) {
            NSMutableArray *results_array = [NSMutableArray arrayWithArray:results];
            if (results_array && results_array.count) {
//                NSLog(@"User Search Results = \n %@",results);
//                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                _userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                _userFullName = [results[0] objectForKey:@"userFullName"];
                [_following_users_fullname addObject:_userFullName];
                [_following_users_userpicurl addObject:_userPicUrl];
            }else{
//                NSLog(@"No image found");
            }
            [self fillFollowingUserSubscribedHunts:user_name :_userPicUrl :_userFullName];

        }
    }];

}


- (void)modifyFeaturedHunts
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"FeaturedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"Name" usingConditionalsForValues:kKCSIn,_unsubscribedHuntNames, nil];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
//            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
//            NSLog(@"modify featured hunts = %@",objectsOrNil);
            if (!objectsOrNil || !objectsOrNil.count) {

                
            }else{
                _unsubscribedHunts = [NSMutableArray arrayWithArray:objectsOrNil];
                [self fillFeauturedHunts];
            }

        }
    } withProgressBlock:nil];
}

- (void)getSubscribedHunts
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"FeaturedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"Name" usingConditionalsForValues:kKCSIn,_subscribedHuntNames, nil];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
//            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
//            NSLog(@"modify featured hunts = %@",objectsOrNil);
            _subscribedHunts = [NSMutableArray arrayWithArray:objectsOrNil];
            [self fillSubscribedHunts];
        }
    } withProgressBlock:nil];
}

- (void)getSubscribedHuntCount
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"HuntName" usingConditionalsForValues:kKCSIn,_subscribedHuntNames, nil];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
//            NSLog(@"An error occurred on fetch: %@", errorOrNil);
        } else {
            //got all events back from server -- update table view
//            NSLog(@"modify featured hunts = %@",objectsOrNil);

        }
    } withProgressBlock:nil];
}

- (void)fillFeauturedHunts
{
    i=0;

    // -- show hunts
    total_featured_hunts = [_unsubscribedHunts count];
    self.scrollView1.contentSize = CGSizeMake(self.scrollView1.frame.size.width * total_featured_hunts, self.scrollView1.frame.size.height);
    self.hunts_pages.numberOfPages = total_featured_hunts;
    self.hunts_pages.currentPage = 0;
    if (total_featured_hunts == 0) {
        [self.total setHidden:YES];
        [self.featured_title setHidden:YES];
    } else {
        [self.total setHidden:NO];
        [self.featured_title setHidden:NO];
        _featured_title.text = @"Featured";
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f) {
                /*Do iPhone 5 stuff here.*/
                _total = [[UILabel alloc]initWithFrame:CGRectMake(271, 10, 29, 29)];
                _total.textColor = [UIColor whiteColor];
                _total.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
                _total.textAlignment = NSTextAlignmentCenter;
                self.total.layer.cornerRadius = self.total.frame.size.height / 2;
                [self.total.layer setBorderWidth:2.0];
                [self.total.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                [self.imageView1 addSubview:_total];
            } else {
                /*Do iPhone Classic stuff here.*/
                _total = [[UILabel alloc]initWithFrame:CGRectMake(271, 5, 29, 29)];
                _total.textColor = [UIColor whiteColor];
                _total.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
                _total.textAlignment = NSTextAlignmentCenter;
                self.total.layer.cornerRadius = self.total.frame.size.height / 2;
                [self.total.layer setBorderWidth:2.0];
                [self.total.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                [self.imageView1 addSubview:_total];
            }
        } else {
            /*Do iPad stuff here.*/
        }
        

    }
    
    [self fillUnSubscribedHuntImages];
    
    if (total_featured_hunts > 0) {
        YookaBackend *yooka =_unsubscribedHunts[0];
        [self.total setText:[NSString stringWithFormat:@"%@",yooka.Count]];
    }
    
}

- (void)fillUnSubscribedHuntImages
{
    if (i < total_featured_hunts) {
        
        YookaBackend *yooka = _unsubscribedHunts[i];
        
        new_page_frame = CGRectMake(i * 280, 0, 280, 121);
        self.FeaturedView = [[UIView alloc]initWithFrame:new_page_frame];
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(117, 15, 150, 25)];
        self.name.textColor = [UIColor whiteColor];
        self.name.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.name setText:yooka.Name];
        [self.FeaturedView addSubview:self.name];
        
        self.image1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 115, 114)];
        self.image1.clipsToBounds = NO;
        self.image1.backgroundColor = [UIColor clearColor];
        self.image1.opaque = NO;
        self.image1.image = [UIImage imageNamed:@"badge@2x.png"];
        [self.image1 setContentMode:UIViewContentModeScaleAspectFit];
        [self.FeaturedView addSubview:self.image1];
        
        self.image2 = [[UIImageView alloc]initWithFrame:CGRectMake(37, 41, 40, 40)];
        self.image2.clipsToBounds = YES;
        self.image2.backgroundColor = [UIColor clearColor];
        self.image2.opaque = NO;
        self.image2.contentMode = UIViewContentModeScaleAspectFit;
        NSString *logoUrl = yooka.HuntLogoUrl;
//        NSLog(@"logo ul = %@",logoUrl);
        
        self.description = [[UILabel alloc]initWithFrame:CGRectMake(117, 48, 150, 48)];
        self.description.textColor = [UIColor whiteColor];
        self.description.font = [UIFont fontWithName:@"Helvetica-Light" size:12.0];
        self.description.textAlignment = NSTextAlignmentLeft;
        self.description.numberOfLines = 0;
        [self.description setText:yooka.Description];
        [self.FeaturedView addSubview:self.description];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:logoUrl]
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
                 self.image2.image = image;
                 [self.image2.layer setCornerRadius:self.image2.frame.size.width/2];
                 [self.image2 setClipsToBounds:YES];
                 [self.FeaturedView addSubview:self.image2];
                 //            NSLog(@"profile image");
                 
                 self.image3 = [[UIImageView alloc]initWithFrame:CGRectMake(35, 69, 45, 19)];
                 self.image3.image = [UIImage imageNamed:@"yooka.png"];
                 self.image3.opaque = NO;
                 self.image3.contentMode = UIViewContentModeScaleAspectFit;
                 UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                 self.image3.backgroundColor = color;
                 [self.FeaturedView addSubview:self.image3];
                 
                 self.action = [UIButton buttonWithType:UIButtonTypeCustom];
                 [self.action  setFrame:CGRectMake(0, 12, 280, 98)];
                 [self.action setBackgroundColor:[UIColor clearColor]];
                 self.action.tag = i;
                 [self.action addTarget:self action:@selector(huntBtn:) forControlEvents:UIControlEventTouchUpInside];
                 [self.FeaturedView addSubview:self.action];
                 
                 [self.scrollView1 addSubview:self.FeaturedView];
                 
                 i++;
                 
                 [self fillUnSubscribedHuntImages];
             }
         }];
        
//        [[[AsyncImageDownloader alloc] initWithMediaURL:logoUrl successBlock:^(UIImage *image)  {
//
//            
//        } failBlock:^(NSError *error) {
////            NSLog(@"Failed to download image due to %@!", error);
//        }] startDownload];
        
    }
}

- (void)fillSubscribedHunts
{
    //show my hunts
    j=0;
    total_hunts = [_subscribedHunts count];
    [self fillSubscribedHuntImages];
    
    if (total_hunts>3) {
        self.scrollView2.contentSize = CGSizeMake(320.0f+(106.0f*(total_hunts-3)), self.scrollView2.frame.size.height);
    }
}

- (void)fillSubscribedHuntImages
{
    if (j < total_hunts) {
//        NSLog(@"j=%d",j);
        
        YookaBackend *yooka = _subscribedHunts[j];
        NSLog(@"j=%@",yooka.Name);
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f) {
                /*Do iPhone 5 stuff here.*/
                new_page_frame_2 = CGRectMake(j * 105.0f+1.5, 1.25, 105.0f, 133);
                
                self.subscribedView = [[UIView alloc]initWithFrame:new_page_frame_2];
                
                self.image1a = [[UIImageView alloc]initWithFrame:CGRectMake(1.5, 0, 101, 133)];
                self.image1a.clipsToBounds = NO;
                self.image1a.backgroundColor = [UIColor clearColor];
                self.image1a.opaque = NO;
                self.image1a.image = [UIImage imageNamed:@"g@2x.png"];
                [self.image1a setContentMode:UIViewContentModeScaleAspectFit];
                [self.subscribedView addSubview:self.image1a];
                
                KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
                KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
                
                KCSQuery* query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:_userEmail];
                KCSQuery* query2 = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:yooka.Name];
                KCSQuery* query3 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2, nil];
                
                [store queryWithQuery:query3 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    if (errorOrNil != nil) {
                        //An error happened, just log for now
//                         NSLog(@"An error occurred on fetch: %@", errorOrNil);
                    } else {
                        //got all events back from server -- update table view
//                        NSLog(@"featured hunt count = %@",objectsOrNil);
                        if (!objectsOrNil || !objectsOrNil.count) {
                            _huntCount = @"0";
                            _huntDone = @"NO";
                        }else{
                            _huntCount = [NSString stringWithFormat:@"%lu",(unsigned long)objectsOrNil.count];
                            
                            if ([_huntCount integerValue] >= [yooka.Count integerValue]) {
                                _huntDone = @"YES";
                                self.image1a = [[UIImageView alloc]initWithFrame:CGRectMake(1.5, 0, 101, 133)];
                                self.image1a.clipsToBounds = NO;
                                self.image1a.backgroundColor = [UIColor clearColor];
                                self.image1a.opaque = NO;
                                self.image1a.image = [UIImage imageNamed:@"b@2x.png"];
                                [self.image1a setContentMode:UIViewContentModeScaleAspectFit];
                                [self.subscribedView addSubview:self.image1a];
                            }else{
                                _huntDone = @"NO";
                            }
                        }
                        if ([_huntCount integerValue] >= [yooka.Count integerValue]) {
                            
                            self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 102, 56, 22)];
                            self.statusLabel.textColor = [UIColor whiteColor];
                            self.statusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
                            self.statusLabel.textAlignment = NSTextAlignmentCenter;
                            [self.statusLabel setText:[NSString stringWithFormat:@"%@/%@",yooka.Count,yooka.Count]];
                            [self.subscribedView addSubview:self.statusLabel];
                            
                        }else{
                            
                            self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 102, 56, 22)];
                            self.statusLabel.textColor = [UIColor whiteColor];
                            self.statusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
                            self.statusLabel.textAlignment = NSTextAlignmentCenter;
                            [self.statusLabel setText:[NSString stringWithFormat:@"%@/%@",_huntCount,yooka.Count]];
                            [self.subscribedView addSubview:self.statusLabel];
                        }
                        
                        self.name2 = [[UILabel alloc]initWithFrame:CGRectMake(3, 7, 99, 20)];
                        self.name2.textColor = [UIColor whiteColor];
                        self.name2.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
                        self.name2.textAlignment = NSTextAlignmentCenter;
                        [self.name2 setText:yooka.Name];
                        [self.subscribedView addSubview:self.name2];
                        
                        self.image2a = [[UIImageView alloc]initWithFrame:CGRectMake(6, 17, 93, 98)];
                        self.image2a.clipsToBounds = NO;
                        self.image2a.backgroundColor = [UIColor clearColor];
                        self.image2a.opaque = NO;
                        self.image2a.image = [UIImage imageNamed:@"badge@2x.png"];
                        [self.image2a setContentMode:UIViewContentModeScaleAspectFit];
                        [self.subscribedView addSubview:self.image2a];
                        
                        NSString *logoUrl = yooka.HuntLogoUrl;
                        //                NSLog(@"logo ul = %@",logoUrl);
                        
                        [self getLogoUrl:logoUrl];
                        
                    }
                } withProgressBlock:nil];
            } else {
                /*Do iPhone Classic stuff here.*/
                new_page_frame_2 = CGRectMake(j * 105.0f+1.5, 1.25, 105.0f, 115);
                
                self.subscribedView = [[UIView alloc]initWithFrame:new_page_frame_2];
                
                self.image1a = [[UIImageView alloc]initWithFrame:CGRectMake(1.5, 0, 101, 115)];
                self.image1a.clipsToBounds = NO;
                self.image1a.backgroundColor = [UIColor clearColor];
                self.image1a.opaque = NO;
                self.image1a.image = [UIImage imageNamed:@"g@2x.png"];
//                [self.image1a setContentMode:UIViewContentModeScaleAspectFit];
                [self.subscribedView addSubview:self.image1a];
                
                KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
                KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
                
                KCSQuery* query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:_userEmail];
                KCSQuery* query2 = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:yooka.Name];
                KCSQuery* query3 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2, nil];
                
                [store queryWithQuery:query3 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    if (errorOrNil != nil) {
                        //An error happened, just log for now
                        //                NSLog(@"An error occurred on fetch: %@", errorOrNil);
                    } else {
                        //got all events back from server -- update table view
                        //                NSLog(@"featured hunt count = %@",objectsOrNil);
                        if (!objectsOrNil || !objectsOrNil.count) {
                            _huntCount = @"0";
                            _huntDone = @"NO";
                        }else{
                            _huntCount = [NSString stringWithFormat:@"%lu",(unsigned long)objectsOrNil.count];
                            
                            if ([_huntCount integerValue] >= [yooka.Count integerValue]) {
                                _huntDone = @"YES";
                                self.image1a = [[UIImageView alloc]initWithFrame:CGRectMake(1.5, 0, 101, 115)];
                                self.image1a.clipsToBounds = NO;
                                self.image1a.backgroundColor = [UIColor clearColor];
                                self.image1a.opaque = NO;
                                self.image1a.image = [UIImage imageNamed:@"b@2x.png"];
//                                [self.image1a setContentMode:UIViewContentModeScaleAspectFill];
                                [self.subscribedView addSubview:self.image1a];
                            }else{
                                _huntDone = @"NO";
                            }
                        }
                        if ([_huntCount integerValue] >= [yooka.Count integerValue]) {
                            
                            self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 92, 56, 22)];
                            self.statusLabel.textColor = [UIColor whiteColor];
                            self.statusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
                            self.statusLabel.textAlignment = NSTextAlignmentCenter;
                            [self.statusLabel setText:[NSString stringWithFormat:@"%@/%@",yooka.Count,yooka.Count]];
                            [self.subscribedView addSubview:self.statusLabel];
                            
                        }else{
                            
                            self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(24, 92, 56, 22)];
                            self.statusLabel.textColor = [UIColor whiteColor];
                            self.statusLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18.0];
                            self.statusLabel.textAlignment = NSTextAlignmentCenter;
                            [self.statusLabel setText:[NSString stringWithFormat:@"%@/%@",_huntCount,yooka.Count]];
                            [self.subscribedView addSubview:self.statusLabel];
                        }
                        
                        self.name2 = [[UILabel alloc]initWithFrame:CGRectMake(3, 3, 99, 20)];
                        self.name2.textColor = [UIColor whiteColor];
                        self.name2.font = [UIFont fontWithName:@"HelveticaNeue" size:12.0];
                        self.name2.textAlignment = NSTextAlignmentCenter;
                        [self.name2 setText:yooka.Name];
                        [self.subscribedView addSubview:self.name2];
                        
                        self.image2a = [[UIImageView alloc]initWithFrame:CGRectMake(6, 7, 93, 98)];
                        self.image2a.clipsToBounds = NO;
                        self.image2a.backgroundColor = [UIColor clearColor];
                        self.image2a.opaque = NO;
                        self.image2a.image = [UIImage imageNamed:@"badge@2x.png"];
                        [self.image2a setContentMode:UIViewContentModeScaleAspectFit];
                        [self.subscribedView addSubview:self.image2a];
                        
                        NSString *logoUrl = yooka.HuntLogoUrl;
                        //                NSLog(@"logo ul = %@",logoUrl);
                        
                        
                        [self getLogoUrl:logoUrl];
                        
                    }
                } withProgressBlock:nil];
            }
        } else {
            /*Do iPad stuff here.*/
        }
        
    }
}

- (void)getLogoUrl:(NSString*)logo_url
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:logo_url]
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
                     self.image3a = [[UIImageView alloc]initWithFrame:CGRectMake(34, 49, 36, 33)];
                     self.image3a.clipsToBounds = YES;
                     self.image3a.backgroundColor = [UIColor clearColor];
                     self.image3a.opaque = NO;
                     self.image3a.contentMode = UIViewContentModeScaleAspectFit;
                     self.image3a.image = image;
                     [self.subscribedView addSubview:self.image3a];
                     
                     self.image4a = [[UIImageView alloc]initWithFrame:CGRectMake(30, 74, 45, 16)];
                     self.image4a.image = [UIImage imageNamed:@"yooka.png"];
                     self.image4a.opaque = NO;
                     self.image4a.contentMode = UIViewContentModeScaleAspectFit;
                     UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                     self.image4a.backgroundColor = color;
                     [self.subscribedView addSubview:self.image4a];
                     
                     self.go_hunt = [YookaButton buttonWithType:UIButtonTypeCustom];
                     [self.go_hunt  setFrame:CGRectMake(0, 0, 105, 133)];
                     [self.go_hunt setBackgroundColor:[UIColor clearColor]];
                     self.go_hunt.tag = j;
                     self.go_hunt.secondTag = _huntDone;
                     [self.go_hunt addTarget:self action:@selector(huntBtn2:) forControlEvents:UIControlEventTouchUpInside];
                     [self.subscribedView addSubview:self.go_hunt];
                     
                     [self.scrollView2 addSubview:self.subscribedView];
                     
                     j++;
                     [self fillSubscribedHuntImages];
                 }
             }];
            
//            [[[AsyncImageDownloader alloc] initWithMediaURL:logo_url successBlock:^(UIImage *image)  {
//                
//
//                
//                
//            } failBlock:^(NSError *error) {
//                //        NSLog(@"Failed to download image due to %@!", error);
//            }] startDownload];
            
        } else {
            /*Do iPhone Classic stuff here.*/
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:logo_url]
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
                     self.image3a = [[UIImageView alloc]initWithFrame:CGRectMake(34, 39, 36, 33)];
                     self.image3a.clipsToBounds = YES;
                     self.image3a.backgroundColor = [UIColor clearColor];
                     self.image3a.opaque = NO;
                     self.image3a.contentMode = UIViewContentModeScaleAspectFit;
                     self.image3a.image = image;
                     [self.subscribedView addSubview:self.image3a];
                     
                     self.image4a = [[UIImageView alloc]initWithFrame:CGRectMake(30, 64, 45, 16)];
                     self.image4a.image = [UIImage imageNamed:@"yooka.png"];
                     self.image4a.opaque = NO;
                     self.image4a.contentMode = UIViewContentModeScaleAspectFit;
                     UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                     self.image4a.backgroundColor = color;
                     [self.subscribedView addSubview:self.image4a];
                     
                     self.go_hunt = [YookaButton buttonWithType:UIButtonTypeCustom];
                     [self.go_hunt  setFrame:CGRectMake(0, 0, 105, 115)];
                     [self.go_hunt setBackgroundColor:[UIColor clearColor]];
                     self.go_hunt.tag = j;
                     self.go_hunt.secondTag = _huntDone;
                     [self.go_hunt addTarget:self action:@selector(huntBtn2:) forControlEvents:UIControlEventTouchUpInside];
                     [self.subscribedView addSubview:self.go_hunt];
                     
                     [self.scrollView2 addSubview:self.subscribedView];
                     
                     j++;
                     [self fillSubscribedHuntImages];
                 }
             }];
            
//            [[[AsyncImageDownloader alloc] initWithMediaURL:logo_url successBlock:^(UIImage *image)  {
//                
//
//                
//                
//            } failBlock:^(NSError *error) {
//                //        NSLog(@"Failed to download image due to %@!", error);
//            }] startDownload];
        }
    } else {
        /*Do iPad stuff here.*/
    }
    

}

- (void)fillFollowingUserSubscribedHunts:(NSString*)user_name :(NSString*)user_pic_url :(NSString*)user_full_name
{
    m=0;
//    NSLog(@"testing 1234");
    // -- show hunts
    total_featured_hunts_2 = l + 1;
    self.scrollView3.contentSize = CGSizeMake(self.scrollView3.frame.size.width * total_featured_hunts_2, self.scrollView3.frame.size.height);
    self.following_hunts_pages.numberOfPages = total_featured_hunts_2;
    self.following_hunts_pages.currentPage = 0;
    
    [self fillFollowingUserSubscribedHuntImages:user_name :user_pic_url :user_full_name];
    
}

- (void)fillFollowingUserSubscribedHuntImages:(NSString*)user_name :(NSString*)user_pic_url :(NSString*)user_full_name
{
//    NSLog(@"testing 12345");

    if (m < 1) {
        
//        NSLog(@"testing 123456" );
//        NSLog(@"l=%d,m=%d,k=%d,total featured hunts 2 = %ld",l,m,k,total_featured_hunts_2 );
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        YookaBackend *yooka = _followingUserSubscribedHunts[m];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f) {
                /*Do iPhone 5 stuff here.*/
                new_page_frame_3 = CGRectMake(l * 314, 0, 314, 131);
                self.FollowingView = [[UIView alloc]initWithFrame:new_page_frame_3];
                
                KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
                KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
                
                [_following_users_email addObject:user_name];
                
                KCSQuery* query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:user_name];
                KCSQuery* query2 = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:yooka.Name];
                KCSQuery* query3 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2, nil];
                
                [store queryWithQuery:query3 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    if (errorOrNil != nil) {
                        //An error happened, just log for now
                        //                NSLog(@"An error occurred on fetch: %@", errorOrNil);
                    } else {
                        //got all events back from server -- update table view
                        //                NSLog(@"featured hunt count = %@",objectsOrNil);
                        if (!objectsOrNil || !objectsOrNil.count) {
                            _huntCount2 = @"0";
                            _huntDone2 = @"NO";
                        }else{
                            _huntCount2 = [NSString stringWithFormat:@"%lu",(unsigned long)objectsOrNil.count];
                            //                    NSLog(@"featured hunt count = %@",_huntCount2);
                            if ([_huntCount2 integerValue] >= [yooka.Count integerValue]) {
                                _huntDone2 = @"YES";
                            }else{
                                _huntDone2 = @"NO";
                            }
                            
                        }
                        
                        _UserPicBorder1 = [[UIView alloc]initWithFrame:CGRectMake(-8, 1, 130, 130)];
                        self.UserPicBorder1.layer.cornerRadius = self.UserPicBorder1.frame.size.height / 2;
                        [self.UserPicBorder1.layer setBorderWidth:4.0];
                        [self.UserPicBorder1.layer setBorderColor:[[[UIColor whiteColor]colorWithAlphaComponent:0.05] CGColor]];
                        [self.FollowingView addSubview:self.UserPicBorder1];
                        
                        _UserPicBorder2 = [[UIView alloc]initWithFrame:CGRectMake(2, 11, 110, 110)];
                        self.UserPicBorder2.layer.cornerRadius = self.UserPicBorder2.frame.size.height / 2;
                        [self.UserPicBorder2.layer setBorderWidth:4.0];
                        [self.UserPicBorder2.layer setBorderColor:[[[UIColor whiteColor]colorWithAlphaComponent:0.05] CGColor]];
                        [self.FollowingView addSubview:self.UserPicBorder2];
                        
                        if ([_huntCount2 integerValue]>=[yooka.Count integerValue]) {
                            
                            self.name3c = [[UILabel alloc]initWithFrame:CGRectMake(182, 57, 112, 25)];
                            self.name3c.textColor = [UIColor whiteColor];
                            self.name3c.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:27.0];
                            self.name3c.textAlignment = NSTextAlignmentCenter;
                            [self.name3c setText:[NSString stringWithFormat:@"%@/%@",yooka.Count,yooka.Count]];
                            [self.FollowingView addSubview:self.name3c];
                            
                        } else {
                            
                            self.name3c = [[UILabel alloc]initWithFrame:CGRectMake(182, 57, 112, 25)];
                            self.name3c.textColor = [UIColor whiteColor];
                            self.name3c.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:27.0];
                            self.name3c.textAlignment = NSTextAlignmentCenter;
                            [self.name3c setText:[NSString stringWithFormat:@"%@/%@",_huntCount2,yooka.Count]];
                            [self.FollowingView addSubview:self.name3c];
                        }
                        
                        self.name3a = [[UILabel alloc]initWithFrame:CGRectMake(167, 7, 142, 26)];
                        self.name3a.textColor = [UIColor whiteColor];
                        self.name3a.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                        self.name3a.textAlignment = NSTextAlignmentCenter;
                        self.name3a.layer.masksToBounds = NO;
                        self.name3a.adjustsFontSizeToFitWidth = YES;
                        [self.name3a setText:user_full_name];
                        [self.FollowingView addSubview:self.name3a];
                        [_following_users_fullname2 addObject:user_full_name];
                        
                        self.name3b = [[UILabel alloc]initWithFrame:CGRectMake(182, 29, 112, 25)];
                        self.name3b.textColor = [UIColor whiteColor];
                        self.name3b.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
                        self.name3b.textAlignment = NSTextAlignmentCenter;
                        self.name3b.layer.masksToBounds = NO;
                        self.name3b.adjustsFontSizeToFitWidth = YES;
                        [self.name3b setText:yooka.Name];
                        [self.following_users_huntname addObject:yooka.Name];
                        [self.FollowingView addSubview:self.name3b];
                        
                        self.description3 = [[UILabel alloc]initWithFrame:CGRectMake(167, 83, 142, 38)];
                        self.description3.textColor = [UIColor whiteColor];
                        self.description3.font = [UIFont fontWithName:@"Helvetica" size:12.0];
                        self.description3.textAlignment = NSTextAlignmentCenter;
                        [self.description3 setText:yooka.Description];
                        self.description3.numberOfLines = 0;
                        [self.FollowingView addSubview:self.description3];
                        
                        self.image1c = [[UIImageView alloc]initWithFrame:CGRectMake(74, 0, 100, 106)];
                        self.image1c.clipsToBounds = NO;
                        self.image1c.backgroundColor = [UIColor clearColor];
                        self.image1c.opaque = NO;
                        self.image1c.image = [UIImage imageNamed:@"badge@2x.png"];
                        [self.image1c setContentMode:UIViewContentModeScaleAspectFit];
                        [self.FollowingView addSubview:self.image1c];
                        
                        NSString *logoUrl = yooka.HuntLogoUrl;
                        [_following_users_logopicurl addObject:logoUrl];
                        
                        //                NSLog(@"logo ul = %@",logoUrl);
                        [self.scrollView3 addSubview:self.FollowingView];
                        
                        [self getLogoUrl2:logoUrl :user_pic_url :user_name :user_full_name];
                        
                    }
                } withProgressBlock:nil];
            } else {
                /*Do iPhone Classic stuff here.*/
                new_page_frame_3 = CGRectMake(l * 314, 0, 314, 131);
                self.FollowingView = [[UIView alloc]initWithFrame:new_page_frame_3];
                
                KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
                KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
                
                [_following_users_email addObject:user_name];
                
                KCSQuery* query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:user_name];
                KCSQuery* query2 = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:yooka.Name];
                KCSQuery* query3 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2, nil];
                
                [store queryWithQuery:query3 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                    if (errorOrNil != nil) {
                        //An error happened, just log for now
                        //                NSLog(@"An error occurred on fetch: %@", errorOrNil);
                    } else {
                        //got all events back from server -- update table view
                        //                NSLog(@"featured hunt count = %@",objectsOrNil);
                        if (!objectsOrNil || !objectsOrNil.count) {
                            _huntCount2 = @"0";
                            _huntDone2 = @"NO";
                        }else{
                            _huntCount2 = [NSString stringWithFormat:@"%lu",(unsigned long)objectsOrNil.count];
                            //                    NSLog(@"featured hunt count = %@",_huntCount2);
                            if ([_huntCount2 integerValue] >= [yooka.Count integerValue]) {
                                _huntDone2 = @"YES";
                            }else{
                                _huntDone2 = @"NO";
                            }
                            
                        }
                        
                        _UserPicBorder1 = [[UIView alloc]initWithFrame:CGRectMake(-8, 0, 120, 120)];
                        self.UserPicBorder1.layer.cornerRadius = self.UserPicBorder1.frame.size.height / 2;
                        [self.UserPicBorder1.layer setBorderWidth:4.0];
                        [self.UserPicBorder1.layer setBorderColor:[[[UIColor whiteColor]colorWithAlphaComponent:0.05] CGColor]];
                        [self.FollowingView addSubview:self.UserPicBorder1];
                        
                        _UserPicBorder2 = [[UIView alloc]initWithFrame:CGRectMake(2, 10, 100, 100)];
                        self.UserPicBorder2.layer.cornerRadius = self.UserPicBorder2.frame.size.height / 2;
                        [self.UserPicBorder2.layer setBorderWidth:4.0];
                        [self.UserPicBorder2.layer setBorderColor:[[[UIColor whiteColor]colorWithAlphaComponent:0.05] CGColor]];
                        [self.FollowingView addSubview:self.UserPicBorder2];
                        
                        if ([_huntCount2 integerValue]>=[yooka.Count integerValue]) {
                            
                            self.name3c = [[UILabel alloc]initWithFrame:CGRectMake(182, 40, 112, 25)];
                            self.name3c.textColor = [UIColor whiteColor];
                            self.name3c.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
                            self.name3c.textAlignment = NSTextAlignmentCenter;
                            [self.name3c setText:[NSString stringWithFormat:@"%@/%@",yooka.Count,yooka.Count]];
                            [self.FollowingView addSubview:self.name3c];
                            
                        } else {
                            
                            self.name3c = [[UILabel alloc]initWithFrame:CGRectMake(182, 40, 112, 25)];
                            self.name3c.textColor = [UIColor whiteColor];
                            self.name3c.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0];
                            self.name3c.textAlignment = NSTextAlignmentCenter;
                            [self.name3c setText:[NSString stringWithFormat:@"%@/%@",_huntCount2,yooka.Count]];
                            [self.FollowingView addSubview:self.name3c];
                        }
                        
                        self.name3a = [[UILabel alloc]initWithFrame:CGRectMake(167, 0, 142, 26)];
                        self.name3a.textColor = [UIColor whiteColor];
                        self.name3a.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                        self.name3a.textAlignment = NSTextAlignmentCenter;
                        self.name3a.layer.masksToBounds = NO;
                        self.name3a.adjustsFontSizeToFitWidth = YES;
                        [self.name3a setText:user_full_name];
                        [self.FollowingView addSubview:self.name3a];
                        [_following_users_fullname2 addObject:user_full_name];
                        
                        self.name3b = [[UILabel alloc]initWithFrame:CGRectMake(182, 20, 112, 25)];
                        self.name3b.textColor = [UIColor whiteColor];
                        self.name3b.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
                        self.name3b.textAlignment = NSTextAlignmentCenter;
                        self.name3b.layer.masksToBounds = NO;
                        self.name3b.adjustsFontSizeToFitWidth = YES;
                        [self.name3b setText:yooka.Name];
                        [self.following_users_huntname addObject:yooka.Name];
                        [self.FollowingView addSubview:self.name3b];
                        
                        self.description3 = [[UILabel alloc]initWithFrame:CGRectMake(167, 63, 142, 38)];
                        self.description3.textColor = [UIColor whiteColor];
                        self.description3.font = [UIFont fontWithName:@"Helvetica" size:12.0];
                        self.description3.textAlignment = NSTextAlignmentCenter;
                        [self.description3 setText:yooka.Description];
                        self.description3.numberOfLines = 0;
                        [self.FollowingView addSubview:self.description3];
                        
                        self.image1c = [[UIImageView alloc]initWithFrame:CGRectMake(74, 0, 100, 96)];
                        self.image1c.clipsToBounds = NO;
                        self.image1c.backgroundColor = [UIColor clearColor];
                        self.image1c.opaque = NO;
                        self.image1c.image = [UIImage imageNamed:@"badge@2x.png"];
                        [self.image1c setContentMode:UIViewContentModeScaleAspectFit];
                        [self.FollowingView addSubview:self.image1c];
                        
                        NSString *logoUrl = yooka.HuntLogoUrl;
                        [_following_users_logopicurl addObject:logoUrl];
                        
                        //                NSLog(@"logo ul = %@",logoUrl);
                        [self.scrollView3 addSubview:self.FollowingView];
                        
                        [self getLogoUrl2:logoUrl :user_pic_url :user_name :user_full_name];
                        
                    }
                } withProgressBlock:nil];
            }
        } else {
            /*Do iPad stuff here.*/
        }
        
    }
    
}

- (void)getLogoUrl2:(NSString*)logoUrl :(NSString*)user_pic_url :(NSString*)user_name :(NSString*)user_full_name
{
//    NSLog(@"%@ %@ %@",logoUrl,user_pic_url,user_name);
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:logoUrl]
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
                     self.image2c = [[UIImageView alloc]initWithFrame:CGRectMake(105, 34, 38, 38)];
                     self.image2c.clipsToBounds = YES;
                     self.image2c.backgroundColor = [UIColor clearColor];
                     self.image2c.opaque = NO;
                     self.image2c.contentMode = UIViewContentModeScaleAspectFit;
                     self.image2c.image = image;
                     [self.image2c.layer setCornerRadius:self.image2.frame.size.width/2];
                     [self.image2c setClipsToBounds:YES];
                     [self.FollowingView addSubview:self.image2c];
                     //        NSLog(@"profile image");
                     
                     self.image3c = [[UIImageView alloc]initWithFrame:CGRectMake(102, 61, 45, 19)];
                     self.image3c.image = [UIImage imageNamed:@"yooka.png"];
                     self.image3c.opaque = NO;
                     self.image3c.contentMode = UIViewContentModeScaleAspectFit;
                     UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                     self.image3c.backgroundColor = color;
                     [self.FollowingView addSubview:self.image3c];
                 }
             }];
            
//            [[[AsyncImageDownloader alloc] initWithMediaURL:logoUrl successBlock:^(UIImage *image)  {
//                
//
//                
//                //        NSLog(@"tryyyyyy");
//                
//            } failBlock:^(NSError *error) {
//                //        NSLog(@"Failed to download image due to %@!", error);
//            }] startDownload];
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:user_pic_url]
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
                     [_following_users_userpicurl2 addObject:user_pic_url];
                     
                     self.image4c = [[UIImageView alloc]initWithFrame:CGRectMake(12, 21, 90, 90)];
                     self.image4c.backgroundColor = [UIColor clearColor];
                     self.image4c.opaque = NO;
                     //        self.image4c.contentMode = UIViewContentModeScaleAspectFit;
                     self.image4c.image = image;
                     self.image4c.layer.cornerRadius = self.image4c.frame.size.height / 2;
                     [self.image4c.layer setBorderWidth:4.0];
                     [self.image4c.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                     [self.image4c setContentMode:UIViewContentModeScaleAspectFill];
                     [self.image4c setClipsToBounds:YES];
                     [self.FollowingView addSubview:self.image4c];
                     //        NSLog(@"profile image");
                     
                     self.action3a = [YookaButton buttonWithType:UIButtonTypeCustom];
                     [self.action3a  setFrame:CGRectMake(167, 7, 142, 114)];
                     [self.action3a setBackgroundColor:[UIColor clearColor]];
                     self.action3a.tag = l;
                     self.action3a.secondTag = _huntDone2;
                     [self.action3a addTarget:self action:@selector(action3a:) forControlEvents:UIControlEventTouchUpInside];
                     [self.FollowingView addSubview:self.action3a];
                     
                     self.action3b = [YookaButton buttonWithType:UIButtonTypeCustom];
                     [self.action3b  setFrame:CGRectMake(12, 8, 139, 116)];
                     [self.action3b setBackgroundColor:[UIColor clearColor]];
                     self.action3b.tag = k;
                     self.action3b.secondTag = [NSString stringWithFormat:@"%d",l];
                     [self.action3b addTarget:self action:@selector(action3b:) forControlEvents:UIControlEventTouchUpInside];
                     [self.FollowingView addSubview:self.action3b];
                     
                     [self.scrollView3 addSubview:self.FollowingView];
                     //        NSLog(@"cry.....");
                     
                     m++;
                     l++;
                     
                     if (m==1) {
                         k++;
                         [self checkforfollowingusersHunts];
                     }
                     
                     [self fillFollowingUserSubscribedHuntImages:user_name :user_pic_url :user_full_name];

                 }
             }];
            
//            [[[AsyncImageDownloader alloc] initWithMediaURL:user_pic_url successBlock:^(UIImage *image)  {
//                
//                
//            } failBlock:^(NSError *error) {
//                //        NSLog(@"Failed to download image due to %@!", error);
//            }] startDownload];
            
        } else {
            /*Do iPhone Classic stuff here.*/
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:logoUrl]
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
                     self.image2c = [[UIImageView alloc]initWithFrame:CGRectMake(110, 30, 33, 38)];
                     self.image2c.clipsToBounds = YES;
                     self.image2c.backgroundColor = [UIColor clearColor];
                     self.image2c.opaque = NO;
                     self.image2c.contentMode = UIViewContentModeScaleAspectFit;
                     self.image2c.image = image;
                     [self.image2c.layer setCornerRadius:self.image2.frame.size.width/2];
                     [self.image2c setClipsToBounds:YES];
                     [self.FollowingView addSubview:self.image2c];
                     //        NSLog(@"profile image");
                     
                     self.image3c = [[UIImageView alloc]initWithFrame:CGRectMake(107, 56, 35, 19)];
                     self.image3c.image = [UIImage imageNamed:@"yooka.png"];
                     self.image3c.opaque = NO;
                     self.image3c.contentMode = UIViewContentModeScaleAspectFit;
                     UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                     self.image3c.backgroundColor = color;
                     [self.FollowingView addSubview:self.image3c];
                 }
             }];
            
//            [[[AsyncImageDownloader alloc] initWithMediaURL:logoUrl successBlock:^(UIImage *image)  {
//                
//
//                
//                //        NSLog(@"tryyyyyy");
//                
//            } failBlock:^(NSError *error) {
//                //        NSLog(@"Failed to download image due to %@!", error);
//            }] startDownload];
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:user_pic_url]
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
                     [_following_users_userpicurl2 addObject:user_pic_url];
                     
                     self.image4c = [[UIImageView alloc]initWithFrame:CGRectMake(12, 11, 80, 80)];
                     self.image4c.backgroundColor = [UIColor clearColor];
                     self.image4c.opaque = NO;
                     //        self.image4c.contentMode = UIViewContentModeScaleAspectFit;
                     self.image4c.image = image;
                     self.image4c.layer.cornerRadius = self.image4c.frame.size.height / 2;
                     [self.image4c.layer setBorderWidth:4.0];
                     [self.image4c.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                     [self.image4c setClipsToBounds:YES];
                     [self.FollowingView addSubview:self.image4c];
                     //        NSLog(@"profile image");
                     
                     self.action3a = [YookaButton buttonWithType:UIButtonTypeCustom];
                     [self.action3a  setFrame:CGRectMake(167, 7, 142, 114)];
                     [self.action3a setBackgroundColor:[UIColor clearColor]];
                     self.action3a.tag = l;
                     self.action3a.secondTag = _huntDone2;
                     [self.action3a addTarget:self action:@selector(action3a:) forControlEvents:UIControlEventTouchUpInside];
                     [self.FollowingView addSubview:self.action3a];
                     
                     self.action3b = [YookaButton buttonWithType:UIButtonTypeCustom];
                     [self.action3b  setFrame:CGRectMake(12, 8, 139, 116)];
                     [self.action3b setBackgroundColor:[UIColor clearColor]];
                     self.action3b.tag = k;
                     self.action3b.secondTag = [NSString stringWithFormat:@"%d",l];
                     [self.action3b addTarget:self action:@selector(action3b:) forControlEvents:UIControlEventTouchUpInside];
                     [self.FollowingView addSubview:self.action3b];
                     
                     [self.scrollView3 addSubview:self.FollowingView];
                     //        NSLog(@"cry.....");
                     
                     m++;
                     l++;
                     
                     if (m==1) {
                         k++;
                         [self checkforfollowingusersHunts];
                     }
                     
                     [self fillFollowingUserSubscribedHuntImages:user_name :user_pic_url :user_full_name];
                 }
             }];
            
//            [[[AsyncImageDownloader alloc] initWithMediaURL:user_pic_url successBlock:^(UIImage *image)  {
//                
//
//                
//            } failBlock:^(NSError *error) {
//                //        NSLog(@"Failed to download image due to %@!", error);
//            }] startDownload];
            
        }
    } else {
        /*Do iPad stuff here.*/
    }


    
}

- (void)action3a:(id)sender
{
//    NSLog(@"show hunts");
    [self.textField removeFromSuperview];
    
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
    YookaButton *buttonClicked = (YookaButton *)sender;
    NSLog(@"button clicked = %@",buttonClicked);
    
    YookaHuntVenuesViewController *media = [[YookaHuntVenuesViewController alloc]init];
    media.huntTitle = _following_users_huntname[b];
    media.userEmail = _myEmail;
    media.emailId = _following_users_email[b];
    media.huntImageUrl = _following_users_logopicurl[b];
    media.userPicUrl = _following_users_userpicurl2[b];
    media.userFullName = _following_users_fullname2[b];
    NSLog(@"button clicked = %@",buttonClicked.secondTag);
//    if ([buttonClicked.secondTag isEqualToString:@"YES"]) {
//        media.huntDone = @"YES";
        media.hidesBottomBarWhenPushed = YES;
//    }else{
//        media.huntDone = @"NO";
//    }
    [self.navigationController pushViewController:media animated:YES];
}

- (void)action3b:(id)sender
{
//    NSLog(@"show profile");
    [self.textField removeFromSuperview];
    
    UIButton* button = sender;
    NSUInteger b = button.tag;
    YookaButton *buttonClicked = (YookaButton *)sender;
//    NSLog(@"button clicked = %@",buttonClicked.secondTag);
//    NSLog(@"b=%lu",(unsigned long)b);
//    NSLog(@"full name = %@ \n email = %@ \n userpicurl = %@",_following_users_fullname,_following_users,_following_users_userpicurl);
    NSUInteger l2 = [buttonClicked.secondTag integerValue];
    BDViewController2 *media = [[BDViewController2 alloc]init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationItem setBackBarButtonItem: backBtn];
    media.userFullName = _following_users_fullname2[l2];
    media.userEmail = _following_users2[b];
    media.userPicUrl = _following_users_userpicurl2[l2];
    
    [self.navigationController pushViewController:media animated:YES];
}

- (void)huntBtn:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
//    NSLog(@"Button pressed %d",b);
    
//    [self.scrollView1 setUserInteractionEnabled:NO];
//    [self.scrollView2 setUserInteractionEnabled:NO];
//    [self.scrollView3 setUserInteractionEnabled:NO];
    
    YookaBackend *yooka = _unsubscribedHunts[b];
    
    if ([_subscribedHuntNames containsObject:yooka.Name] ) {
        //do nothing
        
    }else{
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            
            /*Do iPhone 5 stuff here.*/
            self.modalView = [[UIView alloc] initWithFrame:CGRectMake(41, 80, 254, 406)];
            _modalView.opaque = NO;
            _modalView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
            [self.tabBarController.view addSubview:_modalView];
            
            _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 215, 74)];
            self.titleLabel.textColor = [UIColor grayColor];
            self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:32.0];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.titleLabel setText:yooka.Name];
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.modalView addSubview:self.titleLabel];
            
            _description2 = [[UILabel alloc]init];
            self.description2.textColor = [UIColor grayColor];
            self.description2.font = [UIFont fontWithName:@"Montserrat-Regular" size:14.0];
            self.description2.textAlignment = NSTextAlignmentLeft;
            self.description2.numberOfLines = 0;
            
            CGSize labelSize = CGSizeMake(210, 300);
            CGSize theStringSize = [yooka.Description sizeWithFont:_description2.font constrainedToSize:labelSize lineBreakMode:_description2.lineBreakMode];
            //    NSLog(@"string size = %f %f",theStringSize.width,theStringSize.height);
            
            if (theStringSize.height>128.0) {
                
                _gridScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 100, 214, 134)];
                _gridScrollView.contentSize= self.view.bounds.size;
                [self.modalView addSubview:_gridScrollView];
                [self.gridScrollView setContentSize:CGSizeMake(213, 300)];
                _description2.frame = CGRectMake(_description2.frame.origin.x, _description2.frame.origin.y, theStringSize.width, theStringSize.height);
                [self.description2 setText:yooka.Description];
                [self.description2 sizeToFit];
                self.description2.textAlignment = NSTextAlignmentLeft;
                [self.gridScrollView addSubview:self.description2];
                
            }else{
                
                self.description2.frame = CGRectMake(20, 100, 214, 134);
                [self.description2 setText:yooka.Description];
                [self.description2 sizeToFit];
                self.description2.textAlignment = NSTextAlignmentLeft;
                [self.modalView addSubview:self.description2];
                
            }
            
            _badgeView = [[UIImageView alloc]initWithFrame:CGRectMake(70, 227, 115, 114)];
            _badgeView.image = [UIImage imageNamed:@"badge.png"];
            self.badgeView.contentMode = UIViewContentModeScaleAspectFit;
            [self.modalView addSubview:_badgeView];
            
            NSString *logoUrl = yooka.HuntLogoUrl;
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:logoUrl]
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
                     self.badgeView2 = [[UIImageView alloc]initWithFrame:CGRectMake(108, 264, 40, 40)];
                     self.badgeView2.contentMode = UIViewContentModeScaleAspectFit;
                     self.badgeView2.image = image;
                     [self.modalView addSubview:self.badgeView2];
                     
                     self.badgeView3 = [[UIImageView alloc]initWithFrame:CGRectMake(105, 293, 45, 19)];
                     self.badgeView3.contentMode = UIViewContentModeScaleAspectFit;
                     _badgeView3.image = [UIImage imageNamed:@"yooka.png"];
                     UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                     _badgeView3.backgroundColor = color;
                     [self.modalView addSubview:self.badgeView3];
                 }
             }];
            
//            [[[AsyncImageDownloader alloc] initWithMediaURL:logoUrl successBlock:^(UIImage *image)  {
//                
//
//                
//            } failBlock:^(NSError *error) {
//                //        NSLog(@"Failed to download image due to %@!", error);
//            }] startDownload];
            
            //    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //    [self.closeButton  setFrame:CGRectMake(27, 73, 36, 36)];
            //    [self.closeButton setBackgroundColor:[UIColor clearColor]];
            //    [self.closeButton setImage:[UIImage imageNamed:@"closeoverlay@2x.png"] forState:UIControlStateNormal];
            //    [self.closeButton addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
            //    [self.view addSubview:self.closeButton];
            
            self.closeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.closeButton2  setFrame:CGRectMake(255, 94, 40, 35)];
            [self.closeButton2 setBackgroundColor:[UIColor clearColor]];
            [self.closeButton2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.closeButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20.0]];
            [self.closeButton2 setTitle:@"X" forState:UIControlStateNormal];
            [self.closeButton2 addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
            [self.tabBarController.view addSubview:self.closeButton2];
            
            self.startButton = [[FUIButton alloc]initWithFrame:CGRectMake(64, 343, 127, 43)];
            UIColor * color6 = [UIColor colorFromHexCode:@"#71D2C1"];
            self.startButton.buttonColor = color6;
            UIColor * color7 = [UIColor colorFromHexCode:@"#539A8E"];
            self.startButton.shadowColor = color7;
            self.startButton.shadowHeight = 3.0f;
            self.startButton.cornerRadius = 6.0f;
            self.startButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:16.0];
            self.startButton.tag = b;
            [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
            [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.startButton addTarget:self action:@selector(startButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView addSubview:self.startButton];
            

        } else {
            /*Do iPhone Classic stuff here.*/
            self.modalView = [[UIView alloc] initWithFrame:CGRectMake(41, 20, 254, 406)];
            _modalView.opaque = NO;
            _modalView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
            [self.tabBarController.view addSubview:_modalView];
            
            _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 215, 74)];
            self.titleLabel.textColor = [UIColor grayColor];
            self.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:32.0];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.titleLabel setText:yooka.Name];
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.modalView addSubview:self.titleLabel];
            
            _description2 = [[UILabel alloc]init];
            self.description2.textColor = [UIColor grayColor];
            self.description2.font = [UIFont fontWithName:@"Montserrat-Regular" size:14.0];
            self.description2.textAlignment = NSTextAlignmentLeft;
            self.description2.numberOfLines = 0;
            
            CGSize labelSize = CGSizeMake(210, 300);
            CGSize theStringSize = [yooka.Description sizeWithFont:_description2.font constrainedToSize:labelSize lineBreakMode:_description2.lineBreakMode];
            //    NSLog(@"string size = %f %f",theStringSize.width,theStringSize.height);
            
            if (theStringSize.height>128.0) {
                
                _gridScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 100, 214, 134)];
                _gridScrollView.contentSize= self.view.bounds.size;
                [self.modalView addSubview:_gridScrollView];
                [self.gridScrollView setContentSize:CGSizeMake(213, 300)];
                _description2.frame = CGRectMake(_description2.frame.origin.x, _description2.frame.origin.y, theStringSize.width, theStringSize.height);
                [self.description2 setText:yooka.Description];
                [self.description2 sizeToFit];
                self.description2.textAlignment = NSTextAlignmentLeft;
                [self.gridScrollView addSubview:self.description2];
                
            }else{
                
                self.description2.frame = CGRectMake(20, 100, 214, 134);
                [self.description2 setText:yooka.Description];
                [self.description2 sizeToFit];
                self.description2.textAlignment = NSTextAlignmentLeft;
                [self.modalView addSubview:self.description2];
                
            }
            
            _badgeView = [[UIImageView alloc]initWithFrame:CGRectMake(70, 227, 115, 114)];
            _badgeView.image = [UIImage imageNamed:@"badge.png"];
            self.badgeView.contentMode = UIViewContentModeScaleAspectFit;
            [self.modalView addSubview:_badgeView];
            
            NSString *logoUrl = yooka.HuntLogoUrl;
            
            [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:logoUrl]
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
                     self.badgeView2 = [[UIImageView alloc]initWithFrame:CGRectMake(108, 264, 40, 40)];
                     self.badgeView2.contentMode = UIViewContentModeScaleAspectFit;
                     self.badgeView2.image = image;
                     [self.modalView addSubview:self.badgeView2];
                     
                     self.badgeView3 = [[UIImageView alloc]initWithFrame:CGRectMake(105, 293, 45, 19)];
                     self.badgeView3.contentMode = UIViewContentModeScaleAspectFit;
                     _badgeView3.image = [UIImage imageNamed:@"yooka.png"];
                     UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                     _badgeView3.backgroundColor = color;
                     [self.modalView addSubview:self.badgeView3];
                 }
             }];
            
//            [[[AsyncImageDownloader alloc] initWithMediaURL:logoUrl successBlock:^(UIImage *image)  {
//                
//
//                
//            } failBlock:^(NSError *error) {
//                //        NSLog(@"Failed to download image due to %@!", error);
//            }] startDownload];
            
            //    self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            //    [self.closeButton  setFrame:CGRectMake(27, 73, 36, 36)];
            //    [self.closeButton setBackgroundColor:[UIColor clearColor]];
            //    [self.closeButton setImage:[UIImage imageNamed:@"closeoverlay@2x.png"] forState:UIControlStateNormal];
            //    [self.closeButton addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
            //    [self.view addSubview:self.closeButton];
            
            self.closeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.closeButton2  setFrame:CGRectMake(255, 34, 40, 35)];
            [self.closeButton2 setBackgroundColor:[UIColor clearColor]];
            [self.closeButton2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.closeButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20.0]];
            [self.closeButton2 setTitle:@"X" forState:UIControlStateNormal];
            [self.closeButton2 addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
            [self.tabBarController.view addSubview:self.closeButton2];
            
            self.startButton = [[FUIButton alloc]initWithFrame:CGRectMake(64, 343, 127, 43)];
            UIColor * color6 = [UIColor colorFromHexCode:@"#71D2C1"];
            self.startButton.buttonColor = color6;
            UIColor * color7 = [UIColor colorFromHexCode:@"#539A8E"];
            self.startButton.shadowColor = color7;
            self.startButton.shadowHeight = 3.0f;
            self.startButton.cornerRadius = 6.0f;
            self.startButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:16.0];
            self.startButton.tag = b;
            [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
            [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.startButton addTarget:self action:@selector(startButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView addSubview:self.startButton];

        }
    } else {
        /*Do iPad stuff here.*/
    }
        
    }

}

- (void)huntBtn2:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
//    NSLog(@"b=%lu",(unsigned long)b);
    [self.textField removeFromSuperview];
    YookaHuntVenuesViewController *media = [[YookaHuntVenuesViewController alloc]init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationItem setBackBarButtonItem: backBtn];
    media.userEmail = _myEmail;
    media.emailId = _userEmail;
    YookaBackend *yooka = _subscribedHunts[b];
    media.huntTitle = yooka.Name;
    media.huntImageUrl = yooka.HuntLogoUrl;
    media.userPicUrl = _myPicUrl;
    media.userFullName = _myFullName;
    YookaButton *buttonClicked = (YookaButton *)sender;
    NSLog(@"button clicked = %@",buttonClicked.secondTag);
    if ([buttonClicked.secondTag isEqualToString:@"YES"]) {
        media.huntDone = @"YES";
    }else{
        media.huntDone = @"NO";
    }
    media.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:media animated:YES];
}

- (void)startButtonTouched:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
    YookaBackend *yooka = _unsubscribedHunts[b];
    self.startedHunt = yooka.Name;
    if ([_subscribedHuntNames containsObject:self.startedHunt]) {

    }else{
        [_subscribedHuntNames addObject:self.startedHunt];
    }
    if ([_unsubscribedHuntNames containsObject:self.startedHunt]) {
        [self.unsubscribedHuntNames removeObject:self.startedHunt];
    }
    [self saveStartedHunt];
    [self.modalView removeFromSuperview];
    [self.closeButton removeFromSuperview];
    [_textField removeFromSuperview];
    
    YookaHuntVenuesViewController *media = [[YookaHuntVenuesViewController alloc]init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationItem setBackBarButtonItem: backBtn];
    media.huntTitle = _startedHunt;
    media.userEmail = _myEmail;
    media.emailId = _myEmail;
    media.huntImageUrl = yooka.HuntLogoUrl;
    media.userPicUrl = _myPicUrl;
    media.userFullName = _myFullName;
    media.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:media animated:YES];
    
}

- (void)backAction
{
//    NSLog(@"back button pressed");
    
}

-(void)sendDataToA:(NSArray *)backtoA
{

//    NSLog(@"data back");
}

- (void)saveStartedHunt
{
    YookaBackend *yooka = [[YookaBackend alloc]init];
    yooka.kinveyId = _userEmail;
    yooka.userEmail = _userEmail;
    yooka.HuntNames = _subscribedHuntNames;
    yooka.NotTriedHuntNames = _unsubscribedHuntNames;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store saveObject:yooka withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
//            NSLog(@"Not saved event (error= %@).",errorOrNil);
        } else {
            //save was successful
//            NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
        }
    } withProgressBlock:nil];
}

- (void)closeBtn
{
//    NSLog(@"close modal view");
    [self.modalView removeFromSuperview];
    [self.closeButton2 removeFromSuperview];
    [self.scrollView1 setUserInteractionEnabled:YES];
    [self.scrollView2 setUserInteractionEnabled:YES];
    [self.scrollView3 setUserInteractionEnabled:YES];
}

-(void)onFeaturedClick:(UIButton*)sender
{
//    challenge_item = [featured_objects objectAtIndex:sender.tag];
//    challenge_user_item = nil;
//    //    [self performSegueWithIdentifier:@"goToChallenge" sender:self];
//    [self actionOpenOrShow];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (scrollView == self.scrollView1) {
        self.hunts_pages.currentPage = page;
        YookaBackend *yooka = _unsubscribedHunts[page];
        [self.total setText:[NSString stringWithFormat:@"%@", yooka.Count]];
    } else if (scrollView == self.scrollView3) {
        self.following_hunts_pages.currentPage = page;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{

}

- (void)getUserPicture
{
    _collectionName2 = @"userPicture";
    _customEndpoint2 = @"NewsFeed";
    _fieldName2 = @"_id";
    _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:_myEmail,@"userEmail",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
    
    [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
        if ([results isKindOfClass:[NSArray class]]) {
            NSArray *results_array = [NSArray arrayWithArray:results];
            if (results_array && results_array.count) {
                
//                NSLog(@"User Search asdf = \n %@",results);
                _myPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                
            }
            
        }
    }];
}



@end
