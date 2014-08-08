//
//  MainViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 5/28/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "MainViewController.h"
#import "PanelDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "YookaHunts2ViewController.h"
#import "YookaNewsFeedViewController.h"
#import "YookaNewNewsfeedViewController.h"
#import "YookaPostViewController.h"
#import "YookaSearchLandingViewController.h"
#import "YookaProfileViewController.h"
#import "NavigationViewController.h"
#import "YookaHuntsLandingViewController.h"
#import "YookaProfileNewViewController.h"
#import "YookaRestaurantViewController.h"
#import "YookaSearchViewController.h"
#import "YookaMapViewController.h"

#define CORNER_RADIUS 0
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60

@interface MainViewController () <PanelDelegate, UIGestureRecognizerDelegate> {
    // This view controller doesn't have a UI.
    // activeViewController.view is what the user sees
    UIViewController *activeViewController;
}

@property (nonatomic, strong) YookaHuntsLandingViewController *landingViewController;
@property (nonatomic, strong) YookaPostViewController *postViewController;
@property (nonatomic, strong) YookaNewsFeedViewController *newsfeedViewController;
@property (nonatomic, strong) YookaNewNewsfeedViewController *newsfeed2ViewController;
@property (nonatomic, strong) YookaSearchLandingViewController *searchViewController;
@property (nonatomic, strong) YookaProfileNewViewController *profileViewController;
@property (nonatomic, strong) YookaRestaurantViewController *restaurantViewController;
@property (nonatomic, strong) YookaSearchViewController *search2ViewController;
@property (nonatomic, strong) YookaMapViewController *mapViewController;

@property (nonatomic, strong) NavigationViewController *navigationViewController;
@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) BOOL panelMovedRight;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark -
#pragma mark Custom view methods

- (void)setupView {
    // When the app is launched we'll start by showing the red view
    self.landingViewController = [[YookaHuntsLandingViewController alloc] init];
    self.landingViewController.delegate = self;
    [self.view addSubview:self.landingViewController.view];
    [self addChildViewController:self.landingViewController];
    [self.landingViewController didMoveToParentViewController:self];
    activeViewController = self.landingViewController;
    
    // Get ready for swipes
    [self setupGestures];
}

- (void)resetMainView {
    if (_navigationViewController != nil) {
        [_navigationViewController.view removeFromSuperview];
        _navigationViewController = nil;
    }
    
    [self showActiveViewWithShadow:NO withOffset:0];
}

// This is where the NavigationViewController eventually ends up via its delegate
- (void)showActiveViewWithName:(NSString *)viewName {
    if ([viewName isEqualToString:@"YookaHuntsLandingViewController"]) {
            self.landingViewController = [[YookaHuntsLandingViewController alloc] init];
            self.landingViewController.delegate = self;
        activeViewController = self.landingViewController;
    }
    else if ([viewName isEqualToString:@"YookaPostViewController"]) {
        if (self.postViewController == nil) {
            self.postViewController = [[YookaPostViewController alloc] init];
            self.postViewController.delegate = self;
        }
        activeViewController = self.postViewController;
    }
    else if ([viewName isEqualToString:@"YookaNewsFeedViewController"]) {
            self.newsfeedViewController = [[YookaNewsFeedViewController alloc]init];
            self.newsfeedViewController.delegate = self;
         activeViewController = self.newsfeedViewController;
    }
    else if ([viewName isEqualToString:@"YookaSearchLandingViewController"]) {
        if (self.searchViewController == nil) {
            self.searchViewController = [[YookaSearchLandingViewController alloc]init];
            self.searchViewController.delegate = self;
        }
        activeViewController = self.searchViewController;
    }
    else if ([viewName isEqualToString:@"YookaProfileNewViewController"]) {
            self.profileViewController = [[YookaProfileNewViewController alloc]init];
            self.profileViewController.delegate = self;
        activeViewController = self.profileViewController;
    }
    else if ([viewName isEqualToString:@"YookaRestaurantViewController"]) {
        if (self.restaurantViewController == nil) {
            self.restaurantViewController = [[YookaRestaurantViewController alloc]init];
            self.restaurantViewController.delegate = self;
        }
            activeViewController = self.restaurantViewController;
    }
    else if ([viewName isEqualToString:@"YookaSearchViewController"]) {
            self.search2ViewController = [[YookaSearchViewController alloc]init];
            self.search2ViewController.delegate = self;
            activeViewController = self.search2ViewController;
    }
    else if ([viewName isEqualToString:@"YookaMapViewController"]) {
        if (self.mapViewController == nil) {
            self.mapViewController = [[YookaMapViewController alloc]init];
            self.mapViewController.delegate = self;
        }
        activeViewController = self.mapViewController;
    }
    
    activeViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:activeViewController.view];
    [self addChildViewController:activeViewController];
    
    [activeViewController didMoveToParentViewController:self];
    
    [self showActiveViewWithShadow:YES withOffset:-2];
}

- (void)showActiveViewWithShadow:(BOOL)value withOffset:(double)offset {
    if (value) {
        [activeViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [activeViewController.view.layer setShadowColor:[UIColor clearColor].CGColor];
        [activeViewController.view.layer setShadowOpacity:0.8];
        [activeViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    } else {
        [activeViewController.view.layer setCornerRadius:0.0f];
        [activeViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

- (UIView *)getNavigationView {
    if (_navigationViewController == nil) {
        _navigationViewController = [[NavigationViewController alloc] init];
        _navigationViewController.delegate = self;
        [self.view addSubview:_navigationViewController.view];
        [self addChildViewController:_navigationViewController];
        [_navigationViewController didMoveToParentViewController:self];
        _navigationViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    [self showActiveViewWithShadow:YES withOffset:-2];
    
    return _navigationViewController.view;
}

-(void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:panRecognizer];
}

// navButton tag = 1 when created in Interface Builder
- (IBAction)navButtonClicked:(id)sender {
    
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            self.navButton2.tag = 1;
            [self movePanelToOriginalPosition];
            
            
            break;
        }
            
        case 1: {
            self.navButton2.tag = 0;
            [self movePanelRight];
            [self.navButton2 setHidden:NO];
            
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark PanelDelegate methods

// Called by a view when its navButton is clicked and the panel is occupying the entire screen
- (void)movePanelRight {
    
    UIView *childView = [self getNavigationView];
    
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         activeViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
                             
//                             self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
//                             [self.navButton2  setFrame:CGRectMake(260, 63, 60, 520)];
//                             [self.navButton2 setBackgroundColor:[UIColor redColor]];
//                             [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//                             [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//                             [self.navButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
//                             self.navButton2.tag = 0;
//                             self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//                             [self.view addSubview:self.navButton2];
                             
                         }
                     }];
}

// Called by a view when its navButton is clicked and the panel has already been moved to the right
- (void)movePanelToOriginalPosition {
    
    [self.navButton2 removeFromSuperview];
    
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         activeViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         if (finished) {
 
                         }
                     }];
}

// Called by NavigationViewController when one of the coloured buttons is tapped
- (void)didSelectViewWithName:(NSString *)viewName {
    if (activeViewController != nil) {
        [activeViewController.view removeFromSuperview];
        activeViewController = nil;
    }
    [self showActiveViewWithName:viewName];
    [self movePanelToOriginalPosition];
}

#pragma mark - 
#pragma mark UIGestureRecognizerDelegate methods

// This is where we can slide the active panel from left to right and back again,
// endlessly, for great fun!
-(void)movePanel:(id)sender {
    [[[(UITapGestureRecognizer*)sender view] layer] removeAllAnimations];
    
    [self.navButton removeFromSuperview];
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:[sender view]];
    
    // Stop the main panel from being dragged to the left if it's not already dragged to the right
    if ((velocity.x < 0) && (activeViewController.view.frame.origin.x == 0)) {
        return;
    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        if(velocity.x > 0) {
            _showPanel = YES;
        }
        else {
            _showPanel = NO;
        }
        
        UIView *childView = [self getNavigationView];
        [self.view sendSubviewToBack:childView];
    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        // If we stopped dragging the panel somewhere between the left and right
        // edges of the screen, these will animate it to its final position.
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
            _panelMovedRight = NO;
        } else {
            [self movePanelRight];
            _panelMovedRight = YES;
        }
    }
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            _showPanel = YES;
        }
        else {
            _showPanel = NO;
        }
        
        // Set the new x coord of the active panel...
        activeViewController.view.center = CGPointMake(activeViewController.view.center.x + translatedPoint.x, activeViewController.view.center.y);
        
        // ...and move it there
        [(UIPanGestureRecognizer*)sender setTranslation:CGPointMake(0, 0) inView:self.view];
    }
}

@end