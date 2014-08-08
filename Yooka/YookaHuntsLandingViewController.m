//
//  YookaHuntsLandingViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 6/2/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaHuntsLandingViewController.h"
#import "RVCollectionViewCell.h"
#import "RVCollectionViewLayout.h"
#import "iCarousel.h"
#import "YookaCategoryViewController.h"
#import "YookaProfileNewViewController.h"
#import "YookaBackend.h"
#import "YookaHuntVenuesViewController.h"
#import <AsyncImageDownloader.h>
#import "YookaBackend.h"
#import "BDViewController2.h"
#import "YookaButton.h"
#import <Reachability.h>
#import "UIImageView+WebCache.h"
#import "YookaAppDelegate.h"
#import "YookaNewsFeedViewController.h"
#import "MainViewController.h"
#import "YookaFeaturedHuntViewController.h"
#import "LRGlowingButton.h"

@interface YookaHuntsLandingViewController ()<iCarouselDataSource, iCarouselDelegate>



@end

@implementation YookaHuntsLandingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //set up data
        self.items = [NSMutableArray array];
        for (int carousel = 1; carousel < 5; carousel++)
        {
            [_items addObject:@(carousel)];
        }
    }
    return self;
}

- (void)dealloc
{
	//it's a good idea to set these to nil here to avoid
	//sending messages to a deallocated viewcontroller
	_carousel.delegate = nil;
	_carousel.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if(self.presentingViewController.presentedViewController == self) {
//        NSLog(@"presented view");
//    }else{
//        NSLog(@"not presented view");
//    }
    
    k=0;
    l=0;
    m=0;
    
    self.following_users_huntname = [NSMutableArray new];
    self.following_users_email = [NSMutableArray new];
    self.following_users_logopicurl = [NSMutableArray new];
    self.following_users_userpicurl = [NSMutableArray new];
    self.following_users_userpicurl2 = [NSMutableArray new];
    self.following_users2 = [NSMutableArray new];
    self.following_users_fullname = [NSMutableArray new];
    self.following_users_fullname2 = [NSMutableArray new];
    self.category_hunts =[NSMutableArray new];
    self.category_hunt_names = [NSMutableArray new];
    self.sponsored_hunts = [NSMutableArray new];
    self.sponsored_hunt_names = [NSMutableArray new];
    self.cache_sponsored_hunt_names = [NSMutableArray new];
    self.subscribedHuntNames = [NSMutableArray new];
    self.unSubscribedHuntNames = [NSMutableArray new];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit fromDate:[NSDate date]];
    NSInteger currentHour = [components hour];
    
    if (currentHour>6 && currentHour<18){
        // Do Something
        NSLog(@"morning");
    }else{
        NSLog(@"evening");
    }
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (INTERFACE_IS_PHONE) {
        if (screenSize.height > 480.0f) {
            
            self.myEmail = [KCSUser activeUser].email;
            
            self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
            [self.bgImageView setImage:[UIImage imageNamed:@"yooka_front.png"]];
            [self.view addSubview:self.bgImageView];
            
            self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.navButton  setFrame:CGRectMake(10, 27, 25, 18)];
            [self.navButton setBackgroundColor:[UIColor clearColor]];
            [self.navButton setBackgroundImage:[[UIImage imageNamed:@"grey_menu.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
            [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            self.navButton.tag = 1;
            self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.navButton];
            
            self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.navButton3  setFrame:CGRectMake(0, 0, 60, 80)];
            [self.navButton3 setBackgroundColor:[UIColor clearColor]];
            [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            self.navButton3.tag = 1;
            self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.navButton3];

            //create carousel
            self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 240, 320, 300)];
            self.carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.carousel.type = iCarouselTypeWheel;
            self.carousel.delegate = self;
            self.carousel.dataSource = self;
            self.carousel.backgroundColor = [UIColor clearColor];
            //add carousel to view
            [self.view addSubview:self.carousel];
            
            self.categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 525, 190, 50)];
            self.categoryLabel.textColor = [UIColor whiteColor];
            self.categoryLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:19.0];
            [self.categoryLabel setTextAlignment:NSTextAlignmentCenter];
            [self.categoryLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:self.categoryLabel];
            
            self.hunts_pages = [[UIPageControl alloc] init];
            self.hunts_pages.frame = CGRectMake(141,77,29,27);
            self.hunts_pages.enabled = TRUE;
            [self.hunts_pages setHighlighted:YES];
            [self.view addSubview:self.hunts_pages];
            
            self.hunts_pages.backgroundColor = [UIColor clearColor];
            
            UIImageView *arrowview = [[UIImageView alloc]initWithFrame:CGRectMake(140, 507, 40, 40)];
            arrowview.image = [UIImage imageNamed:@"arrow_landing.png"];
            [self.view addSubview:arrowview];
            
            // Get ready for swipes
            [self setupGestures];
            
        }else{
            
            self.myEmail = [KCSUser activeUser].email;
            
            self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
            [self.bgImageView setImage:[UIImage imageNamed:@"yooka_front.png"]];
            [self.view addSubview:self.bgImageView];
            
            self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.navButton  setFrame:CGRectMake(10, 27, 25, 18)];
            [self.navButton setBackgroundColor:[UIColor clearColor]];
            [self.navButton setBackgroundImage:[[UIImage imageNamed:@"grey_menu.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
            [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            self.navButton.tag = 1;
            self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.navButton];
            
            self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.navButton3  setFrame:CGRectMake(0, 0, 60, 80)];
            [self.navButton3 setBackgroundColor:[UIColor clearColor]];
            [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            self.navButton3.tag = 1;
            self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.view addSubview:self.navButton3];
            
            //create carousel
            self.carousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 240, 320, 300)];
            self.carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            self.carousel.type = iCarouselTypeWheel;
            self.carousel.delegate = self;
            self.carousel.dataSource = self;
            self.carousel.backgroundColor = [UIColor clearColor];
            //add carousel to view
            [self.view addSubview:self.carousel];
            
            self.categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 525, 190, 50)];
            self.categoryLabel.textColor = [UIColor whiteColor];
            self.categoryLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:19.0];
            [self.categoryLabel setTextAlignment:NSTextAlignmentCenter];
            [self.categoryLabel setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:self.categoryLabel];
            
            self.hunts_pages = [[UIPageControl alloc] init];
            self.hunts_pages.frame = CGRectMake(141,77,29,27);
            self.hunts_pages.enabled = TRUE;
            [self.hunts_pages setHighlighted:YES];
            [self.view addSubview:self.hunts_pages];
            
            self.hunts_pages.backgroundColor = [UIColor clearColor];
            
            UIImageView *arrowview = [[UIImageView alloc]initWithFrame:CGRectMake(140, 507, 40, 40)];
            arrowview.image = [UIImage imageNamed:@"arrow_landing.png"];
            [self.view addSubview:arrowview];
            
            // Get ready for swipes
            [self setupGestures];
            
        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    //    [self.view setBackgroundColor:color];
    
    [self.carousel setHidden:NO];

    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (INTERFACE_IS_PHONE) {
        if (screenSize.height > 480.0f) {
            
            self.topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, 320, 150)];
            [self.topScrollView setBackgroundColor:[UIColor clearColor]];
            self.topScrollView.delegate = self;
            [self.view addSubview:self.topScrollView];
            
            [self.topScrollView setPagingEnabled:YES];
            self.topScrollView.showsHorizontalScrollIndicator = NO;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            self.cache_sponsored_hunt_names = [defaults objectForKey:@"sponsoredHunts"];
            self.cachesubscribedHuntNames = [defaults objectForKey:@"subscribedHuntNames"];
            self.cacheUnSubscribedHuntNames = [defaults objectForKey:@"unsubscribedHuntNames"];
//            NSLog(@"cache sponsored hunt names = %@",self.cache_sponsored_hunt_names);
            if (self.cache_sponsored_hunt_names) {
                self.sponsored_hunt_names = self.cache_sponsored_hunt_names;
                self.subscribedHuntNames = self.cachesubscribedHuntNames;
                self.unSubscribedHuntNames = self.cacheUnSubscribedHuntNames;
                
                if (self.sponsored_hunt_names.count == 0) {
                    [self.sponsored_hunt_names addObject:@"MORE HUNTS COMING"];
                    [self fillFeauturedHunts];
                }else{
                    [self fillFeauturedHunts];
                }
                
                [self getFeaturedHunts2];
                
            }else{
                [self getFeaturedHunts];
            }
            
        }else{
            
        }
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    float scrollViewHeight = scrollView.frame.size.height;
    float scrollContentSizeHeight = scrollView.contentSize.height;
    float scrollOffset = scrollView.contentOffset.x;
    
    if (scrollView == self.topScrollView) {
        NSLog(@"scroll offset = %f",scrollOffset);
    }

    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (scrollView == self.topScrollView) {
        
        self.hunts_pages.currentPage = page;
        
        if(scrollOffset > (self.topScrollView.frame.size.width * (total_featured_hunts-1))+50){
            // You have reached last page
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                
                if (screenSize.height > 480.0f) {
                    /*Do iPhone 5 stuff here.*/
                    CGPoint bottomOffset = CGPointMake(0, 0);
                    [self.topScrollView setContentOffset:bottomOffset animated:NO];
                    
                } else {
                    
                    /*Do iPhone Classic stuff here.*/
                    CGPoint bottomOffset = CGPointMake(0, 0);
                    [self.topScrollView setContentOffset:bottomOffset animated:NO];
                    
                }
                
            } else {
                /*Do iPad stuff here.*/
            }
            
        }else if(self.topScrollView.contentOffset.x < -50)       {
            // You have reached page 1
            //            NSLog(@"we reached the end %f",self.scrollView1.frame.size.width);
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                
                if (screenSize.height > 480.0f) {
                    /*Do iPhone 5 stuff here.*/
                    CGPoint bottomOffset = CGPointMake(self.topScrollView.frame.size.width * (total_featured_hunts-1), 0);
                    [self.topScrollView setContentOffset:bottomOffset animated:NO];
                    
                } else {
                    
                    /*Do iPhone Classic stuff here.*/
                    CGPoint bottomOffset = CGPointMake(self.topScrollView.frame.size.width * (total_featured_hunts-1), 0);
                    [self.topScrollView setContentOffset:bottomOffset animated:NO];
                    
                }
                
            } else {
                /*Do iPad stuff here.*/
            }
            
        }
        
    } else if (scrollView == self.scrollView3) {
//        self.following_hunts_pages.currentPage = page;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

// navButton tag = 1 when created in Interface Builder
- (IBAction)navButtonClicked:(id)sender {
    
    [self.topScrollView setUserInteractionEnabled:YES];
    [self.modalView removeFromSuperview];
    [self.closeButton removeFromSuperview];
    [self.closeButton2 removeFromSuperview];
    
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            self.navButton.tag = 1;
            self.navButton2.tag = 1;
            self.navButton3.tag = 1;
            [_delegate movePanelToOriginalPosition];
            [self.carousel setHidden:NO];
            
            break;
        }
            
        case 1: {
            self.navButton.tag = 0;
            self.navButton2.tag = 0;
            self.navButton3.tag = 0;
            [_delegate movePanelRight];
            [self.carousel setHidden:YES];
            [self.navButton2 setHidden:NO];
            
            break;
        }
            
        default:
            break;
    }
    
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

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [_items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    //    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    //    if (view == nil)
    //    {
    //        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100.0f, 100.0f)];
    //        ((UIImageView *)view).image = [UIImage imageNamed:@"house_placeholder.png"];
    //        view.contentMode = UIViewContentModeCenter;
    //        label = [[UILabel alloc] initWithFrame:view.bounds];
    //        label.backgroundColor = [UIColor clearColor];
    //        label.textAlignment = NSTextAlignmentCenter;
    //        label.font = [label.font fontWithSize:50];
    //        label.tag = 1;
    //        [view addSubview:label];
    //    }
    //    else
    //    {
    //        //get a reference to the label in the recycled view
    //        label = (UILabel *)[view viewWithTag:1];
    //    }
    
    LRGlowingButton *button = (LRGlowingButton *)view;
	if (button == nil)
	{
		//no button available to recycle, so create new one
//		UIImage *image = [UIImage imageNamed:@"house_placeholder.png"];
		button = [LRGlowingButton buttonWithType:UIButtonTypeCustom];
		button.frame = CGRectMake(0.0f, 0.0f, 150.f, 350.f);
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
//		[button setBackgroundImage:image forState:UIControlStateNormal];
//		button.titleLabel.font = [button.titleLabel.font fontWithSize:30];
        button.glowsWhenHighlighted = NO;
        //button.highlightedGlowColor = [self colorWithHexString:@"3ac0ec"];
		[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
//        UIImageView *building = [[UIImageView alloc]initWithFrame:CGRectMake(20, 60, 120, 200)];
//        [building setImage:[UIImage imageNamed:@"building.png"]];
//        [button addSubview:building];
        

	}
    
    UILabel *category_name = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 150, 35)];
    category_name.textColor = [UIColor whiteColor];
    category_name.font = [UIFont fontWithName:@"OpenSans" size:25.0];
    category_name.textAlignment = NSTextAlignmentCenter;
    [button addSubview:category_name];
	
	//set category images
    if (index==0) {
        [self.categoryLabel setText:@"EAT"];
        
        self.eat = [[UIImageView alloc]initWithFrame:CGRectMake(-185, -165, 530, 550)];
        [self.eat setImage:[UIImage imageNamed:@"resturant.png"]];
        [button addSubview:self.eat];
        
    }else if (index==1){
        
        self.drink = [[UIImageView alloc]initWithFrame:CGRectMake(-193, -105, 530, 530)];
        [self.drink setImage:[UIImage imageNamed:@"tavern.png"]];
        [button addSubview:self.drink];

    }else if (index==2){
        
        self.play = [[UIImageView alloc]initWithFrame:CGRectMake(-169, -55, 500, 450)];
        [self.play setImage:[UIImage imageNamed:@"ferriswheel.png"]];
        [self.play setBackgroundColor:[UIColor clearColor]];
        [button addSubview:self.play];

    }else if (index==3){
        
        self.yooka = [[UIImageView alloc]initWithFrame:CGRectMake(-120, -15, 450, 430)];
        [self.yooka setImage:[UIImage imageNamed:@"Yooka_building.png"]];
        [button addSubview:self.yooka];

    }
    
	return button;
    
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    
    if(carousel.currentItemIndex == 0){
        [self.categoryLabel setText:@"EAT"];
        
//        [self.eat setHidden:NO];
//        [self.drink setHidden:YES];
//        [self.play setHidden:YES];
//        [self.yooka setHidden:YES];
        
        
    }else if(carousel.currentItemIndex == 1){
        [self.categoryLabel setText:@"DRINK"];
        
//        [self.eat setHidden:YES];
//        [self.drink setHidden:NO];
//        [self.play setHidden:YES];
//        [self.yooka setHidden:YES];
        
    }else if(carousel.currentItemIndex == 2){
        [self.categoryLabel setText:@"PLAY"];
        
//        [self.eat setHidden:YES];
//        [self.drink setHidden:YES];
//        [self.play setHidden:NO];
//        [self.yooka setHidden:YES];
        
    }else if(carousel.currentItemIndex == 3){
        [self.categoryLabel setText:@"YOOKA"];
        
//        [self.eat setHidden:YES];
//        [self.drink setHidden:YES];
//        [self.play setHidden:YES];
//        [self.yooka setHidden:NO];
    }
    
}

- (CATransform3D)carousel:(iCarousel *)carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.7f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return value;
        }
    }
}

#pragma mark -
#pragma mark Button tap event

- (void)buttonTapped:(UIButton *)sender
{
	//get item index for button
	NSInteger index = [self.carousel indexOfItemViewOrSubview:sender];
	
    //    [[[UIAlertView alloc] initWithTitle:@"Button Tapped"
    //                                message:[NSString stringWithFormat:@"You tapped button number %li", (long)index]
    //                               delegate:nil
    //                      cancelButtonTitle:@"OK"
    //                      otherButtonTitles:nil] show];
    
    [self.topScrollView removeFromSuperview];

    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    YookaCategoryViewController* media = [[YookaCategoryViewController alloc]init];
    if (index == 0) {
        media.categoryName = @"EAT";
        media.categoryArray = _eatArray;
    }else if (index == 1) {
        media.categoryName = @"DRINK";
        media.categoryArray = _drinkArray;
    }else if (index == 2) {
        media.categoryName = @"PLAY";
        media.categoryArray = _playArray;
    }else if (index == 3) {
        media.categoryName = @"YOOKA";
        media.categoryArray = _yookaArray;
    }
    media.subscribedHunts = self.cachesubscribedHuntNames;
    media.unsubscribedHunts = self.cacheUnSubscribedHuntNames;
    [self presentViewController:media animated:NO completion:nil];
    
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
            _featuredHunts = [NSMutableArray arrayWithArray:objectsOrNil];
            NSLog(@"featured hunts  count = %lu",(unsigned long)_featuredHunts.count);
            [self storeFeaturedHunts];
            //            [self checkSubscribedHunts];
            
        }
    } withProgressBlock:nil];
    
}

- (void)getFeaturedHunts2
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
            
        } else {
            
            //got all events back from server -- update table view
            _featuredHunts = [NSMutableArray arrayWithArray:objectsOrNil];
            [self storeFeaturedHunts2];
            
        }
    } withProgressBlock:nil];
    
}

- (void)storeFeaturedHunts
{
    _featuredHuntNames = [NSMutableArray new];
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
    
//    NSLog(@"item = %@",self.featuredHunts);

    
    int q;
    for (q=0; q<_featuredHunts.count; q++) {
        
        NSLog(@"number = %d",q);
        
        YookaBackend *yooka = _featuredHunts[q];
        
        if(yooka.Name){
        [_featuredHuntNames addObject:yooka.Name];
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
    
//    NSLog(@"eat array = %@",self.eatArray);

    
    if (q==_featuredHunts.count) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_featuredHuntNames forKey:@"featuredHuntNames"];
        [defaults setObject:_huntDict1 forKey:@"huntDescription"];
        [defaults setObject:_huntDict2 forKey:@"huntCount"];
        [defaults setObject:_huntDict3 forKey:@"huntLogoUrl"];
        [defaults setObject:_huntDict6 forKey:@"huntPicUrl"];
        [defaults setObject:_eatArray forKey:@"eatArray"];
        [defaults setObject:_drinkArray forKey:@"drinkArray"];
        [defaults setObject:_playArray forKey:@"playArray"];
        [defaults setObject:_yookaArray forKey:@"yookaArray"];
        [defaults synchronize];
        
        _cacheHuntDescription = _huntDict1;
        _cacheHuntCount = _huntDict2;
        _cacheHuntLogoUrl = _huntDict3;
        _cacheFeaturedHuntNames = _featuredHuntNames;
        [self checkSubscribedHunts];
        
    }
    
}

- (void)storeFeaturedHunts2
{
    _featuredHuntNames = [NSMutableArray new];
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
    
    int q;
    for (q=0; q<_featuredHunts.count; q++) {
        
        YookaBackend *yooka = _featuredHunts[q];
        if(yooka.Name){
            [_featuredHuntNames addObject:yooka.Name];
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
    
    if (q==_featuredHunts.count) {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_featuredHuntNames forKey:@"featuredHuntNames"];
        [defaults setObject:_huntDict1 forKey:@"huntDescription"];
        [defaults setObject:_huntDict2 forKey:@"huntCount"];
        [defaults setObject:_huntDict3 forKey:@"huntLogoUrl"];
        [defaults setObject:_huntDict6 forKey:@"huntPicUrl"];
        [defaults setObject:_eatArray forKey:@"eatArray"];
        [defaults setObject:_drinkArray forKey:@"drinkArray"];
        [defaults setObject:_playArray forKey:@"playArray"];
        [defaults setObject:_yookaArray forKey:@"yookaArray"];
        [defaults synchronize];
        
        _cacheHuntDescription = _huntDict1;
        _cacheHuntCount = _huntDict2;
        _cacheHuntLogoUrl = _huntDict3;
        _cacheFeaturedHuntNames = _featuredHuntNames;
        [self checkSubscribedHunts2];
        
//        NSLog(@"eat array = %@",self.eatArray);
//        NSLog(@"drink array = %@",self.drinkArray);
//        NSLog(@"play array = %@",self.playArray);
//        NSLog(@"yooka array = %@",self.yookaArray);
        
    }
    
}

- (void)checkSubscribedHunts
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:self.myEmail];
    
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
//                NSLog(@"try 2002");
                _subscribedHuntNames = [NSMutableArray arrayWithArray:@[]];
                _unSubscribedHunts = _featuredHunts;
                //                NSLog(@"unsubscribed hunts = %@",objectsOrNil);
                if (_unSubscribedHunts.count == _featuredHunts.count) {
                    
                }
                _unSubscribedHuntNames = [NSMutableArray new];
                int x=0;
                for (x=0; x<_unSubscribedHunts.count; x++) {
                    YookaBackend *yooka = _unSubscribedHunts[x];
                    [_unSubscribedHuntNames addObject:yooka.Name];
                }
                
                NSMutableArray *public_hunts = [NSMutableArray new];
                public_hunts = self.subscribedHuntNames;
                
                if (x==_unSubscribedHuntNames.count) {
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:_subscribedHuntNames forKey:@"subscribedHuntNames"];
                    [defaults setObject:_unSubscribedHuntNames forKey:@"unsubscribedHuntNames"];
                    [defaults setObject:public_hunts forKey:@"publicHunts"];
                    [defaults synchronize];
                    
                    _cachesubscribedHuntNames = [NSMutableArray new];
                    _cacheUnSubscribedHuntNames = [NSMutableArray new];
                    _cacheUnSubscribedHuntNames = _unSubscribedHuntNames;
//                    NSLog(@"unsubscr array = %@",_cacheUnSubscribedHuntNames);
                    
                    [self checkSponsoredHunts];
                }
                
            } else {
                
                _subscribedHuntNames = [NSMutableArray new];
                _unSubscribedHuntNames = [NSMutableArray new];
                _cachesubscribedHuntNames = [NSMutableArray new];
                _cacheUnSubscribedHuntNames = [NSMutableArray new];
                
                YookaBackend *yooka = objectsOrNil[0];
                //                NSLog(@"featured hunts = %@",_featuredHuntNames);
                //                NSLog(@"subscribed hunts = %@",yooka.HuntNames);
                _subscribedHuntNames = [NSMutableArray arrayWithArray:yooka.HuntNames];
                NSMutableArray *public_hunts = [NSMutableArray new];
                if (yooka.public_hunts) {
                    public_hunts = [NSMutableArray arrayWithArray:yooka.public_hunts];
                }else{
                    public_hunts = _subscribedHuntNames;
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
                _unSubscribedHuntNames = removeArray;
//                NSLog(@"remove array = %@",_unSubscribedHuntNames);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_subscribedHuntNames forKey:@"subscribedHuntNames"];
                [defaults setObject:_unSubscribedHuntNames forKey:@"unsubscribedHuntNames"];
                [defaults setObject:public_hunts forKey:@"publicHunts"];
                [defaults synchronize];
                _cachesubscribedHuntNames = _subscribedHuntNames;
                _cacheUnSubscribedHuntNames = _unSubscribedHuntNames;

                [self checkSponsoredHunts];
                
            }
            
        }
    } withProgressBlock:nil];
}

- (void)checkSubscribedHunts2
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"SubscribedHunts" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:self.myEmail];
    
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
                //                NSLog(@"try 2002");
                _subscribedHuntNames = [NSMutableArray arrayWithArray:@[]];
                _unSubscribedHunts = _featuredHunts;
                //                NSLog(@"unsubscribed hunts = %@",objectsOrNil);
                if (_unSubscribedHunts.count == _featuredHunts.count) {
                    
                }
                _unSubscribedHuntNames = [NSMutableArray new];
                int x=0;
                for (x=0; x<_unSubscribedHunts.count; x++) {
                    YookaBackend *yooka = _unSubscribedHunts[x];
                    [_unSubscribedHuntNames addObject:yooka.Name];
                }
                
                NSMutableArray *public_hunts = [NSMutableArray new];
                public_hunts = self.subscribedHuntNames;
                
                if (x==_unSubscribedHuntNames.count) {
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:_subscribedHuntNames forKey:@"subscribedHuntNames"];
                    [defaults setObject:_unSubscribedHuntNames forKey:@"unsubscribedHuntNames"];
                    [defaults setObject:public_hunts forKey:@"publicHunts"];
                    [defaults synchronize];
                    
                    _cachesubscribedHuntNames = [NSMutableArray new];
                    _cacheUnSubscribedHuntNames = [NSMutableArray new];
                    _cacheUnSubscribedHuntNames = _unSubscribedHuntNames;
                    //                    NSLog(@"unsubscr array = %@",_cacheUnSubscribedHuntNames);
                    
                    [self checkSponsoredHunts2];
                }
                
            } else {
                
                _subscribedHuntNames = [NSMutableArray new];
                _unSubscribedHuntNames = [NSMutableArray new];
                _cachesubscribedHuntNames = [NSMutableArray new];
                _cacheUnSubscribedHuntNames = [NSMutableArray new];
                
                YookaBackend *yooka = objectsOrNil[0];

                _subscribedHuntNames = [NSMutableArray arrayWithArray:yooka.HuntNames];
                NSMutableArray *public_hunts = [NSMutableArray new];
                if (yooka.public_hunts) {
                    public_hunts = [NSMutableArray arrayWithArray:yooka.public_hunts];
                }else{
                    public_hunts = _subscribedHuntNames;
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
                _unSubscribedHuntNames = removeArray;
//                NSLog(@"remove array = %@",_unSubscribedHuntNames);
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:_subscribedHuntNames forKey:@"subscribedHuntNames"];
                [defaults setObject:_unSubscribedHuntNames forKey:@"unsubscribedHuntNames"];
                [defaults setObject:public_hunts forKey:@"publicHunts"];
                [defaults synchronize];
                _cachesubscribedHuntNames = _subscribedHuntNames;
                _cacheUnSubscribedHuntNames = _unSubscribedHuntNames;
                
                [self checkSponsoredHunts2];
                
            }
            
        }
    } withProgressBlock:nil];
}

- (void)checkforUnsubscribedHunts
{
    if (_cacheUnSubscribedHuntNames.count == 0) {
        
//        NSLog(@"first");
    }else{
//        NSLog(@"second");
//        [self fillFeauturedHunts];
    }
    
    if (_cacheUnSubscribedHuntNames.count == _featuredHuntNames.count) {
//        NSLog(@"third");
    }else{
//        NSLog(@"fourth");
        //        [self fillSubscribedHunts];
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
            self.category_hunt_names = [NSMutableArray arrayWithArray:yooka.category_hunts];
            
            NSMutableArray *removeArray = [self.sponsored_hunt_names mutableCopy];
            [removeArray removeObjectsInArray:self.subscribedHuntNames];
            self.sponsored_hunt_names = removeArray;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.sponsored_hunt_names forKey:@"sponsoredHunts"];
            [defaults synchronize];
            
//            NSLog(@"sponsored hunts = %@",self.sponsored_hunt_names);

                if (self.sponsored_hunt_names.count == 0) {
                    [self.sponsored_hunt_names addObject:@"MORE HUNTS COMING"];
                    [self fillFeauturedHunts];
                }else{
                    [self fillFeauturedHunts];
                }

        }
    } withProgressBlock:nil];
}

- (void)checkSponsoredHunts2
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
//            self.sponsored_hunt_names = [NSMutableArray arrayWithArray:yooka.sponsored_hunts];
            self.category_hunt_names = [NSMutableArray arrayWithArray:yooka.category_hunts];
            
            NSMutableArray *removeArray = [self.sponsored_hunt_names mutableCopy];
            [removeArray removeObjectsInArray:self.subscribedHuntNames];
//            NSLog(@"remove array = %@",removeArray);
//            NSLog(@"subscribed hunts = %@",self.subscribedHuntNames);
//            NSLog(@"category hunts = %@",self.category_hunt_names);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:removeArray forKey:@"sponsoredHunts"];
            [defaults synchronize];
            
        }
    } withProgressBlock:nil];
}

- (void)fillFeauturedHunts
{
    self.working = YES;
    i=0;
    
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
        if (i==total_featured_hunts) {
            //            [self viewDidLoad];
        }
        if (i < total_featured_hunts) {
            
            if (i==0) {
                new_page_frame = CGRectMake(320, 00, 320, 350);
                self.FeaturedView = [[UIView alloc]initWithFrame:new_page_frame];
            }else{
                new_page_frame = CGRectMake(i * 320, 00, 320, 350);
                self.FeaturedView = [[UIView alloc]initWithFrame:new_page_frame];
            }
            
            self.image3 = [[UIImageView alloc]initWithFrame:CGRectMake(-91, -170, 550, 550)];
            self.image3.image = [UIImage imageNamed:@"blimp2.png"];
            self.image3.opaque = YES;
            self.image3.contentMode = UIViewContentModeScaleAspectFit;
            [self.FeaturedView addSubview:self.image3];
            
            self.name = [[UILabel alloc]initWithFrame:CGRectMake(103, 61, 120, 30)];
            self.name.textColor = [UIColor whiteColor];
            self.name.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0];
            self.name.adjustsFontSizeToFitWidth = YES;
            self.name.textAlignment = NSTextAlignmentCenter;
            [self.name setText:[self.sponsored_hunt_names[i] uppercaseString]];
            [self.name setBackgroundColor:[UIColor clearColor]];
            [self.FeaturedView addSubview:self.name];
            
            self.action = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.action  setFrame:CGRectMake(0, 12, 280, 98)];
            [self.action setBackgroundColor:[UIColor clearColor]];
            self.action.tag = i;
            [self.action addTarget:self action:@selector(featuredButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.FeaturedView addSubview:self.action];
            
            [self.topScrollView addSubview:self.FeaturedView];
            
            if (i==0) {
                
                [UIView animateWithDuration:1.0f
                                      delay:0.0f
                                    options:UIViewAnimationOptionAllowUserInteraction
                                 animations:^{
                                     [self.FeaturedView setFrame:CGRectMake(0.0f, 0.0f, 320.0f, 350.0f)];
                                 }
                                 completion:^(BOOL finished){
                                     if(finished)
                                         [self scrollblimpautomatically];
                                     // do any stuff here if you want
                                 }];
                
//                [UIScrollView animateWithDuration:3.0f delay:1.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
//                    
//                    [self.topScrollView setContentOffset:CGPointMake(0, 0)];
//                    
//                }
//                                       completion:^(BOOL finished){
//                                           if(finished)
//                                               [self scrollblimpautomatically];
//                                           // do any stuff here if you want
//                                           
//                                       }];
                
                self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton3  setFrame:CGRectMake(0, 0, 60, 80)];
                [self.navButton3 setBackgroundColor:[UIColor clearColor]];
                [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                self.navButton3.tag = 1;
                self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.view addSubview:self.navButton3];
                
                self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton2  setFrame:CGRectMake(0, 63, 60, 520)];
                [self.navButton2 setBackgroundColor:[UIColor clearColor]];
                [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                self.navButton2.tag = 0;
                self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.view addSubview:self.navButton2];
                
                [self.navButton2 setHidden:YES];
            }
            
            i++;
            [self fillUnSubscribedHuntImages];
            
        }
    }
}

- (void) scrollblimpautomatically
{

    CGPoint scrollOffset = self.topScrollView.contentOffset;
    scrollOffset.x = scrollOffset.x+320;

    if (scrollOffset.x < (320 * (total_featured_hunts))) {
        
        
        [UIScrollView animateWithDuration:1.0f delay:3.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{

            [self.topScrollView setContentOffset:scrollOffset];

        }
                               completion:^(BOOL finished){
                                   if(finished)
                                       [self scrollblimpautomatically];
                                   // do any stuff here if you want

                               }];
    }else{
        
        [UIScrollView animateWithDuration:0.0f delay:3.0f options:UIViewAnimationOptionAllowUserInteraction animations:^{
            
            [self.topScrollView setContentOffset:CGPointMake(0, 0)];
            
        }
                               completion:^(BOOL finished){

                                   // do any stuff here if you want
                                   
                               }];

        
    }

    

}

- (void)featuredButtonTouched:(id)sender
{
    
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
//    NSLog(@"sponsored hunt names = %@",self.sponsored_hunt_names);
    
    if ([self.sponsored_hunt_names[b] isEqualToString:@"MORE HUNTS COMING"]) {

    }else{
        [self.topScrollView removeFromSuperview];

        YookaFeaturedHuntViewController *media = [[YookaFeaturedHuntViewController alloc]init];
        media.huntTitle = self.sponsored_hunt_names[b];
        media.sponsored_hunt_name = self.sponsored_hunt_names[b];
        media.subscribedHunts = _cachesubscribedHuntNames;
        media.unsubscribedHunts = _cacheUnSubscribedHuntNames;
        [self presentViewController:media animated:YES completion:nil];
    }
    
}

- (void)huntBtn:(id)sender
{
    
    UIButton* button = sender;
    NSUInteger b = button.tag;
    //    NSLog(@"Button pressed %lu",(unsigned long)b);
    
    [self.topScrollView setUserInteractionEnabled:NO];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            
            /*Do iPhone 5 stuff here.*/
            self.modalView = [[UIView alloc] initWithFrame:CGRectMake(41, 80, 254, 406)];
            _modalView.opaque = YES;
            _modalView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
            [self.view addSubview:_modalView];
            
            _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 215, 74)];
            self.titleLabel.textColor = [UIColor grayColor];
            self.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:32.0];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.titleLabel setText:_cacheUnSubscribedHuntNames[b]];
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.modalView addSubview:self.titleLabel];
            
            _description2 = [[UILabel alloc]init];
            self.description2.textColor = [UIColor grayColor];
            self.description2.font = [UIFont fontWithName:@"OpenSans" size:14.0];
            self.description2.textAlignment = NSTextAlignmentLeft;
            self.description2.numberOfLines = 0;
            
            CGSize labelSize = CGSizeMake(210, 300);
            CGSize theStringSize = [[_cacheHuntDescription objectForKey:_cacheUnSubscribedHuntNames[b]] sizeWithFont:_description2.font constrainedToSize:labelSize lineBreakMode:_description2.lineBreakMode];
            //    NSLog(@"string size = %f %f",theStringSize.width,theStringSize.height);
            
            if (theStringSize.height>128.0) {
                
                _gridScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 100, 214, 134)];
                _gridScrollView.contentSize= self.view.bounds.size;
                [self.modalView addSubview:_gridScrollView];
                [self.gridScrollView setContentSize:CGSizeMake(213, theStringSize.height+20)];
                _description2.frame = CGRectMake(_description2.frame.origin.x, _description2.frame.origin.y, theStringSize.width, theStringSize.height);
                [self.description2 setText:[_cacheHuntDescription objectForKey:_cacheUnSubscribedHuntNames[b]]];
                [self.description2 sizeToFit];
                self.description2.textAlignment = NSTextAlignmentLeft;
                [self.gridScrollView addSubview:self.description2];
                
            }else{
                
                self.description2.frame = CGRectMake(20, 100, 214, 134);
                [self.description2 setText:[_cacheHuntDescription objectForKey:_cacheUnSubscribedHuntNames[b]]];
                [self.description2 sizeToFit];
                self.description2.textAlignment = NSTextAlignmentLeft;
                [self.modalView addSubview:self.description2];
                
            }
            
            _badgeView = [[UIImageView alloc]initWithFrame:CGRectMake(70, 227, 115, 114)];
            _badgeView.image = [UIImage imageNamed:@"badge.png"];
            self.badgeView.contentMode = UIViewContentModeScaleAspectFit;
            [self.modalView addSubview:_badgeView];
            
            NSString *logoUrl = [_cacheHuntLogoUrl objectForKey:_cacheUnSubscribedHuntNames[b]];
            
            [[SDImageCache sharedImageCache] queryDiskCacheForKey:logoUrl done:^(UIImage *image, SDImageCacheType cacheType)
             {
                 // image is not nil if image was found
                 if (image) {
                     
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
                     
                 }else{
                     
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
                              
                              [[SDImageCache sharedImageCache] storeImage:image forKey:logoUrl];
                              
                              self.badgeView3 = [[UIImageView alloc]initWithFrame:CGRectMake(105, 293, 45, 19)];
                              self.badgeView3.contentMode = UIViewContentModeScaleAspectFit;
                              _badgeView3.image = [UIImage imageNamed:@"yooka.png"];
                              UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                              _badgeView3.backgroundColor = color;
                              [self.modalView addSubview:self.badgeView3];
                          }
                      }];
                     
                 }
             }];
            
            self.closeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.closeButton2  setFrame:CGRectMake(255, 94, 40, 35)];
            [self.closeButton2 setBackgroundColor:[UIColor clearColor]];
            [self.closeButton2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.closeButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20.0]];
            [self.closeButton2 setTitle:@"X" forState:UIControlStateNormal];
            [self.closeButton2 addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.closeButton2];
            
            self.startButton = [[FUIButton alloc]initWithFrame:CGRectMake(64, 343, 127, 43)];
            UIColor * color6 = [UIColor colorFromHexCode:@"#71D2C1"];
            self.startButton.buttonColor = color6;
            UIColor * color7 = [UIColor colorFromHexCode:@"#539A8E"];
            self.startButton.shadowColor = color7;
            self.startButton.shadowHeight = 3.0f;
            self.startButton.cornerRadius = 6.0f;
            self.startButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
            self.startButton.tag = b;
            [self.startButton setTitle:@"Start" forState:UIControlStateNormal];
            [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.startButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.startButton addTarget:self action:@selector(startButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView addSubview:self.startButton];
            
        } else {
            
            /*Do iPhone Classic stuff here.*/
            self.modalView = [[UIView alloc] initWithFrame:CGRectMake(41, 20, 254, 406)];
            _modalView.opaque = YES;
            _modalView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
            [self.view addSubview:_modalView];
            
            _titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(20, 18, 215, 74)];
            self.titleLabel.textColor = [UIColor grayColor];
            self.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:32.0];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            [self.titleLabel setText:_cacheUnSubscribedHuntNames[b]];
            self.titleLabel.adjustsFontSizeToFitWidth = YES;
            [self.modalView addSubview:self.titleLabel];
            
            _description2 = [[UILabel alloc]init];
            self.description2.textColor = [UIColor grayColor];
            self.description2.font = [UIFont fontWithName:@"OpenSans" size:14.0];
            self.description2.textAlignment = NSTextAlignmentLeft;
            self.description2.numberOfLines = 0;
            
            CGSize labelSize = CGSizeMake(210, 300);
            CGSize theStringSize = [[_cacheHuntDescription objectForKey:_cacheUnSubscribedHuntNames[b]] sizeWithFont:_description2.font constrainedToSize:labelSize lineBreakMode:_description2.lineBreakMode];
            
            if (theStringSize.height>128.0) {
                
                _gridScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20, 100, 214, 134)];
                _gridScrollView.contentSize= self.view.bounds.size;
                [self.modalView addSubview:_gridScrollView];
                [self.gridScrollView setContentSize:CGSizeMake(213, 300)];
                _description2.frame = CGRectMake(_description2.frame.origin.x, _description2.frame.origin.y, theStringSize.width, theStringSize.height);
                [self.description2 setText:[_cacheHuntDescription objectForKey:_cacheUnSubscribedHuntNames[b]]];
                [self.description2 sizeToFit];
                self.description2.textAlignment = NSTextAlignmentLeft;
                [self.gridScrollView addSubview:self.description2];
                
            }else{
                
                self.description2.frame = CGRectMake(20, 100, 214, 134);
                [self.description2 setText:[_cacheHuntDescription objectForKey:_cacheUnSubscribedHuntNames[b]]];
                [self.description2 sizeToFit];
                self.description2.textAlignment = NSTextAlignmentLeft;
                [self.modalView addSubview:self.description2];
                
            }
            
            _badgeView = [[UIImageView alloc]initWithFrame:CGRectMake(70, 227, 115, 114)];
            _badgeView.image = [UIImage imageNamed:@"badge.png"];
            self.badgeView.contentMode = UIViewContentModeScaleAspectFit;
            [self.modalView addSubview:_badgeView];
            
            NSString *logoUrl = [_cacheHuntLogoUrl objectForKey:_cacheUnSubscribedHuntNames[b]];
            
            [[SDImageCache sharedImageCache] queryDiskCacheForKey:logoUrl done:^(UIImage *image, SDImageCacheType cacheType)
             {
                 // image is not nil if image was found
                 if (image) {
                     
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
                     
                 }else{
                     
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
                              
                              [[SDImageCache sharedImageCache] storeImage:image forKey:logoUrl];
                              
                              self.badgeView3 = [[UIImageView alloc]initWithFrame:CGRectMake(105, 293, 45, 19)];
                              self.badgeView3.contentMode = UIViewContentModeScaleAspectFit;
                              _badgeView3.image = [UIImage imageNamed:@"yooka.png"];
                              UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                              _badgeView3.backgroundColor = color;
                              [self.modalView addSubview:self.badgeView3];
                          }
                      }];
                     
                 }
             }];
            
            self.closeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.closeButton2  setFrame:CGRectMake(255, 34, 40, 35)];
            [self.closeButton2 setBackgroundColor:[UIColor clearColor]];
            [self.closeButton2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.closeButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20.0]];
            [self.closeButton2 setTitle:@"X" forState:UIControlStateNormal];
            [self.closeButton2 addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.closeButton2];
            
            self.startButton = [[FUIButton alloc]initWithFrame:CGRectMake(64, 343, 127, 43)];
            UIColor * color6 = [UIColor colorFromHexCode:@"#71D2C1"];
            self.startButton.buttonColor = color6;
            UIColor * color7 = [UIColor colorFromHexCode:@"#539A8E"];
            self.startButton.shadowColor = color7;
            self.startButton.shadowHeight = 3.0f;
            self.startButton.cornerRadius = 6.0f;
            self.startButton.titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16.0];
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

- (void)startButtonTouched:(id)sender
{
    
    [self.topScrollView setUserInteractionEnabled:YES];
    
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
    self.startedHunt = _cacheUnSubscribedHuntNames[b];
    //    NSLog(@"self started = %@",self.startedHunt);
    [_cachesubscribedHuntNames addObject:self.startedHunt];
    if ([_cacheUnSubscribedHuntNames containsObject:self.startedHunt]) {
        [_cacheUnSubscribedHuntNames removeObject:self.startedHunt];
    }
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:_cachesubscribedHuntNames forKey:@"subscribedHuntNames"];
    [ud setObject:_cacheUnSubscribedHuntNames forKey:@"unsubscribedHuntNames"];
    [ud setObject:@"YES" forKey:@"wentToVenues"];
    [ud synchronize];
    
    self.working = NO;
    
    [self saveStartedHunt];
    [self.modalView removeFromSuperview];
    [self.closeButton2 removeFromSuperview];
    [self.topScrollView removeFromSuperview];
    
    
    YookaHuntVenuesViewController *media = [[YookaHuntVenuesViewController alloc]init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationItem setBackBarButtonItem: backBtn];
    media.huntTitle = _startedHunt;
    media.userEmail = _myEmail;
    media.emailId = _myEmail;
    
    //    NSLog(@"%@",_cacheHuntLogoUrl);
    
    media.huntImageUrl = [_cacheHuntLogoUrl objectForKey:self.startedHunt];
    //    NSLog(@"%@",[_cacheHuntLogoUrl objectForKey:self.startedHunt]);
    if (_myPicUrl) {
        media.userPicUrl = _myPicUrl;
    }
    media.userFullName = _myFullName;
    media.delegate = self;
    media.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:media animated:YES];
    
}

- (void)closeBtn
{
    //    NSLog(@"close modal view");
    [self.modalView removeFromSuperview];
    [self.closeButton2 removeFromSuperview];
    [self.topScrollView setUserInteractionEnabled:YES];
    
}

- (void)saveStartedHunt
{
    YookaBackend *yooka = [[YookaBackend alloc]init];
    yooka.kinveyId = _myEmail;
    yooka.userEmail = _myEmail;
    yooka.HuntNames = _cachesubscribedHuntNames;
    yooka.NotTriedHuntNames = _cacheUnSubscribedHuntNames;
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
        }
    } withProgressBlock:nil];
}

- (void)backAction
{
    //    NSLog(@"back button pressed");
    
}

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
            [self.carousel setHidden:YES];
            
        }
        else {
            _showPanel = NO;
            //[self.carousel setHidden:NO];
            
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
            [self.carousel setHidden:NO];
            [self.navButton2 setHidden:YES];
            self.navButton3.tag = 1;
            self.navButton.tag = 1;
            self.navButton2.tag = 1;
        } else {
            [self.navButton2 setHidden:NO];
            self.navButton2.tag = 0;
            self.navButton3.tag = 0;
            self.navButton.tag = 0;
            [_delegate movePanelRight];
            _panelMovedRight = YES;
        }
    }
    //pm
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
