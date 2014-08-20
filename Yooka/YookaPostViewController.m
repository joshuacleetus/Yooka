//
//  YookaPostViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 12/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaPostViewController.h"
#import "YookaLocationViewController.h"
#import "YookaMenuViewController.h"
#import <DYRateView.h>
#import <AsyncImageDownloader.h>
#import "YookaAppDelegate.h"
#import "YookaBackend.h"
#import "YookaHuntVenuesViewController.h"
#import "YookaHuntRestaurantViewController.h"
#import "YookaNewsFeedViewController.h"
#import <Reachability.h>
#import "UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "YookaNewsFeedViewController.h"
#import "LDProgressView.h"
#import "Foursquare2.h"
#import "FSConverter.h"
#import "FSVenue.h"
#import "Flurry.h"
#import "MainViewController.h"

#define kOFFSET_FOR_KEYBOARD 155.0
#define kOFFSET_FOR_KEYBOARD_1 255.0
#define kOFFSET_FOR_KEYBOARD_2 355.0
#define kOFFSET_FOR_KEYBOARD_3 515.0

@interface YookaPostViewController ()

@end

@implementation YookaPostViewController

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
    
    self.tabBarController.delegate = self;
    _userEmail = [[KCSUser activeUser] email];
    self.firstName = [[KCSUser activeUser] givenName];
    self.userFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
//    NSLog(@"user name = %@",self.firstName);
    
    _yay_list = [NSMutableArray new];
    _nay_list = [NSMutableArray new];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            
            [self.view setBackgroundColor:[UIColor whiteColor]];
            
            UIImageView *setPostBgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 275)];
            //setPostBgImage.image = [UIImage imageNamed:@"camera_image_size.png"];
            setPostBgImage.backgroundColor = [self colorWithHexString:@"a3a3a3"];
            [self.view addSubview:setPostBgImage];
            
            
            UIImageView *plusLabel = [[UIImageView alloc]initWithFrame:CGRectMake(145, 105, 30, 30)];
            plusLabel.image = [UIImage imageNamed:@"photo.png"];
            plusLabel.backgroundColor=[UIColor clearColor];
            [self.view addSubview:plusLabel];
            
            NSLog(@"my hunt count = %@",_huntCount);
            NSLog(@"hunt count = %@",_totalHuntCount);
            
            self.dishImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 275)];
            [self.dishImage setContentMode:UIViewContentModeScaleAspectFill];
            [self.dishImage setClipsToBounds:YES];
            [self.view addSubview:self.dishImage];
            
            self.modal_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 275)];
            self.modal_view.opaque = NO;
            //self.modal_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45f];
           // [self.view addSubview:self.modal_view];
            
            KCSCollection* collection = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
            self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyResource : collection, KCSStoreKeyCachePolicy : @(KCSCachePolicyBoth), KCSStoreKeyOfflineUpdateEnabled : @YES }];
            
            //set notification for when keyboard shows/hides
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillHide:)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
            
            //set notification for when a key is pressed.
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector: @selector(keyPressed:)
                                                         name: UITextViewTextDidChangeNotification
                                                       object: nil];
            
            [_quickNote becomeFirstResponder];
            
//            UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];

            _voteImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 240, 320, 140)];
            [_voteImageview setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.view addSubview:_voteImageview];
            
            _voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 320, 20)];
//            _voteLabel.text = @"WOULD YOU GET THIS AGAIN?";
            NSString *string = @"WOULD YOU GET THIS AGAIN ?";
            if (string) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                float spacing = 1.2f;
                [attributedString addAttribute:NSKernAttributeName
                                         value:@(spacing)
                                         range:NSMakeRange(0, [string length])];
                self.voteLabel.attributedText = attributedString;
            }
            _voteLabel.font = [UIFont fontWithName:@"OpenSans-Italic" size:13.0];
            _voteLabel.textColor = [UIColor whiteColor];
            _voteLabel.textAlignment = NSTextAlignmentCenter;
            [_voteImageview addSubview:_voteLabel];
            
            _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yayButton  setFrame:CGRectMake(73, 330, 70, 35)];
            [_yayButton setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [_yayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_yayButton setTitle:@" YES" forState:UIControlStateNormal];

            [self.view addSubview:_yayButton];
            
            UIImageView *yesView = [[UIImageView alloc]initWithFrame:CGRectMake(-18, -10, 100, 50)];
            yesView.image = [UIImage imageNamed:@"yes_no_button2.png"];
            yesView.backgroundColor=[UIColor clearColor];
            [_yayButton addSubview:yesView];

            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(175, 330, 70, 35)];
            [_nayButton setBackgroundColor:[UIColor clearColor]];
            [_nayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_nayButton setTitle:@" NO" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
            
            UIImageView *noView = [[UIImageView alloc]initWithFrame:CGRectMake(-18, -10, 100, 50)];
            noView.image = [UIImage imageNamed:@"yes_no_button2.png"];
            noView.backgroundColor=[UIColor clearColor];
            [_nayButton addSubview:noView];
            
            [self getUserImage];
            
            self.changePic = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.changePic  setFrame:CGRectMake(0, 0, 320, 230)];
            [self.changePic setBackgroundColor:[UIColor clearColor]];
            [self.changePic addTarget:self action:@selector(changePicture) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.changePic];
            
            
            //            UIImageView *comment_icon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 230, 40, 35)];
            //            comment_icon.image = [UIImage imageNamed:@"comments_white.png"];
            //            [self.view addSubview:comment_icon];

//            _commentView = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 375, 320, 100)];
//            _commentView.image = [UIImage imageNamed:@"search_bar_new.png"];
//            [_commentView setBackgroundColor:[UIColor clearColor]];
//            [self.view addSubview:_commentView];
            
            self.bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 380, 320, 188)];
            //bottomView.image = [UIImage imageNamed:@"search_bar_new.png"];
            //bottomView.backgroundColor=[UIColor whiteColor];
            [self.bottomView setUserInteractionEnabled:YES];
            [self.view addSubview:self.bottomView];
            
            _postBtn= [UIButton buttonWithType:UIButtonTypeCustom];
            [_postBtn  setFrame:CGRectMake(0, 141, 320, 47)];
            [_postBtn setBackgroundColor:[UIColor clearColor]];
            //[_postBtn setBackgroundImage:[[UIImage imageNamed:@"share_button_new.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            //[_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.postBtn addTarget:self action:@selector(postBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.postBtn.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:20]];
            self.postBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            //            [_postBtn setTitle:@"SHARE" forState:UIControlStateNormal];
            [self.postBtn setEnabled:YES];
            [self.bottomView addSubview:_postBtn];
            
            if (self.venueSelected) {
                
                UIImageView *gps_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50-9, 35, 37)];
                gps_icon.backgroundColor=[UIColor clearColor];
                gps_icon.image = [UIImage imageNamed:@"gps3.png"];
                [self.bottomView addSubview:gps_icon];

            }else{
                UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [locationButton setFrame:CGRectMake(0, 48, 320, 47)];
                [locationButton setBackgroundColor:[UIColor clearColor]];
                [locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
                [locationButton setEnabled:YES];
                [self.bottomView addSubview:locationButton];
                
                UIImageView *gps_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50, 35, 37)];
                gps_icon.backgroundColor=[UIColor clearColor];
                gps_icon.image = [UIImage imageNamed:@"greygps2.png"];
                [self.bottomView addSubview:gps_icon];
            }
            
            UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [menuButton setFrame:CGRectMake(0, 89, 320, 45)];
            [menuButton setBackgroundColor:[UIColor clearColor]];
            [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomView addSubview:menuButton];
        
            self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(63, 58, 260, 20)];
            NSString *string2;
            if (self.venueSelected) {
                string2 = self.venueSelected;
            }else{
                string2 = @"LOCATION";
            }
            self.locName=string2;
            if (self.locName) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.locName];
                float spacing = 1.4f;
                [attributedString addAttribute:NSKernAttributeName
                                         value:@(spacing)
                                         range:NSMakeRange(0, [self.locName length])];
                self.locationLabel.attributedText = attributedString;
            }
            self.locationLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
            self.locationLabel.textColor = [UIColor lightGrayColor];
            [self.bottomView addSubview:self.locationLabel];
            
            self.menuLabel = [[UILabel alloc]initWithFrame:CGRectMake(63, 103, 260, 20)];
            NSString *string3 = @"DISH NAME";
            self.dishName=string3;
            if (self.dishName) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.dishName];
                float spacing = 1.4f;
                [attributedString addAttribute:NSKernAttributeName
                                         value:@(spacing)
                                         range:NSMakeRange(0, [self.dishName length])];
                self.menuLabel.attributedText = attributedString;
            }
            self.menuLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
            self.menuLabel.textColor = [UIColor lightGrayColor];
            [self.bottomView addSubview:self.menuLabel];
            
            UIImageView *pencil_icon = [[UIImageView alloc]initWithFrame:CGRectMake(4, 9, 37, 37)];
            pencil_icon.backgroundColor=[UIColor clearColor];
            pencil_icon.image = [UIImage imageNamed:@"pencil2.png"];
            [self.bottomView addSubview:pencil_icon];
            
            UIImageView *tags_icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 85, 40, 50)];
            tags_icon.backgroundColor=[UIColor clearColor];
            tags_icon.image = [UIImage imageNamed:@"tags2.png"];
            [self.bottomView addSubview:tags_icon];
            
            UIImageView *vertical = [[UIImageView alloc]initWithFrame:CGRectMake(27, 0, 15, 180)];
            vertical.backgroundColor=[UIColor clearColor];
            vertical.image = [UIImage imageNamed:@"upload_vertical_line.png"];
            [self.bottomView addSubview:vertical];
            
            UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(173, 156, 30, 10)];
            arrow.backgroundColor=[UIColor clearColor];
            arrow.image = [UIImage imageNamed:@"upload_share_arrow.png"];
            [self.bottomView addSubview:arrow];
            
            UIImageView *ver_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 320, 11)];
            ver_line.image = [UIImage imageNamed:@"lines.png"];
            ver_line.backgroundColor = [UIColor clearColor];
            [self.bottomView addSubview:ver_line];
            
            UIImageView *ver_line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 83, 320, 11)];
            ver_line2.image = [UIImage imageNamed:@"lines.png"];
            ver_line2.backgroundColor = [UIColor clearColor];
            [self.bottomView addSubview:ver_line2];
            
            UIImageView *ver_line3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 129, 320, 11)];
            ver_line3.image = [UIImage imageNamed:@"lines.png"];
            ver_line3.backgroundColor = [UIColor clearColor];
            [self.bottomView addSubview:ver_line3];
            
            //white line to correct the gps image
            UIView *white_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 81, 40, 5)];
            white_line.backgroundColor=[UIColor whiteColor];
            [self.bottomView addSubview:white_line];

            UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(123, 151, 100, 20)];
            NSString *string4 = @"SHARE";
            if (string4) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string4];
                float spacing = 1.4f;
                [attributedString addAttribute:NSKernAttributeName
                                         value:@(spacing)
                                         range:NSMakeRange(0, [string4 length])];
                shareLabel.attributedText = attributedString;
            }
            shareLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
            shareLabel.textColor = [self colorWithHexString:@"3ac0ec"];
            [self.bottomView addSubview:shareLabel];
            
            _commentView = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 380, 320, 47)];
            [_commentView setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:_commentView];
            
            _quickNote = [[UITextView alloc]initWithFrame:CGRectMake( 58, 387, 260, 42)];
            _quickNote.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
            _quickNote.textColor = [UIColor lightGrayColor];
            _quickNote.backgroundColor = [UIColor clearColor];
            _quickNote.autocorrectionType = UITextAutocorrectionTypeDefault;
            _quickNote.keyboardType = UIKeyboardTypeDefault;
            _quickNote.returnKeyType = UIReturnKeyDone;
            _quickNote.delegate = self;
            _quickNote.text = @"WRITE A CAPTION...";
            [ _quickNote setUserInteractionEnabled:YES];
            [self.view addSubview:_quickNote];
            

            
            if(self.presentingViewController.presentedViewController == self) {
                
                NSLog(@"presented view");
                self.backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
                self.backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
                [self.view addSubview:self.backBtnImage];
                
                self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.backBtn setFrame:CGRectMake(10, 20, 40, 40)];
                [self.backBtn setTitle:@"" forState:UIControlStateNormal];
                [self.backBtn setBackgroundColor:[UIColor clearColor]];
                //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.backBtn];
                
            }else{
                
                NSLog(@"not presented view");
                self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton3  setFrame:CGRectMake(0, 0, 60, 70)];
                [self.navButton3 setBackgroundColor:[UIColor clearColor]];
                [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton3.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                self.navButton3.tag = 1;
                self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.view addSubview:self.navButton3];
                
                self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton  setFrame:CGRectMake(10, 27, 25, 18)];
                [self.navButton setBackgroundColor:[UIColor clearColor]];
                [self.navButton setBackgroundImage:[[UIImage imageNamed:@"white_menu.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
                [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                self.navButton.tag = 1;
                self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.view addSubview:self.navButton];
                
                self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton2  setFrame:CGRectMake(0, 63, 60, 520)];
                [self.navButton2 setBackgroundColor:[UIColor clearColor]];
                [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                self.navButton2.tag = 0;
                self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.view addSubview:self.navButton2];
                
                [self.navButton2 setHidden:YES];
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(dismissKeyboard)];
            [self.view addGestureRecognizer:tap];
            
        }
        
        else {

            [self.view setBackgroundColor:[UIColor whiteColor]];
         
            UIImageView *setPostBgImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 275)];
            //setPostBgImage.image = [UIImage imageNamed:@"camera_image_size.png"];
            setPostBgImage.backgroundColor = [self colorWithHexString:@"a3a3a3"];
            [self.view addSubview:setPostBgImage];
            
            UIImageView *plusLabel = [[UIImageView alloc]initWithFrame:CGRectMake(145, 105-30, 30, 30)];
            plusLabel.image = [UIImage imageNamed:@"photo.png"];
            plusLabel.backgroundColor=[UIColor clearColor];
            [self.view addSubview:plusLabel];
            
            self.dishImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 275)];
            [self.dishImage setContentMode:UIViewContentModeScaleAspectFill];
            [self.dishImage setClipsToBounds:YES];
            [self.view addSubview:self.dishImage];
            
            self.modal_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 275)];
            self.modal_view.opaque = NO;
            //[self.view addSubview:self.modal_view];
            
            KCSCollection* collection = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
            self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{ KCSStoreKeyResource : collection, KCSStoreKeyCachePolicy : @(KCSCachePolicyBoth), KCSStoreKeyOfflineUpdateEnabled : @YES }];
            
            //set notification for when keyboard shows/hides
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillHide:)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
            
            //set notification for when a key is pressed.
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector: @selector(keyPressed:)
                                                         name: UITextViewTextDidChangeNotification
                                                       object: nil];
            
            [_quickNote becomeFirstResponder];
            
            _voteImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 180, 320, 136)];
            [_voteImageview setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [self.view addSubview:_voteImageview];
            
            _voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 320, 20)];
            NSString *string = @"WOULD YOU GET THIS AGAIN ?";
            if (string) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                float spacing = 1.2f;
                [attributedString addAttribute:NSKernAttributeName
                                         value:@(spacing)
                                         range:NSMakeRange(0, [string length])];
                self.voteLabel.attributedText = attributedString;
            }
            _voteLabel.font = [UIFont fontWithName:@"OpenSans-Italic" size:13.0];
            _voteLabel.textColor = [UIColor whiteColor];
            _voteLabel.textAlignment = NSTextAlignmentCenter;
            [_voteImageview addSubview:_voteLabel];
            
            _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yayButton  setFrame:CGRectMake(73, 330-64, 70, 35)];
            [_yayButton setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [_yayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_yayButton setTitle:@" YES" forState:UIControlStateNormal];
            
            [self.view addSubview:_yayButton];
            
            UIImageView *yesView = [[UIImageView alloc]initWithFrame:CGRectMake(-18, -10, 100, 50)];
            yesView.image = [UIImage imageNamed:@"yes_no_button2.png"];
            yesView.backgroundColor=[UIColor clearColor];
            [_yayButton addSubview:yesView];
            
            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(175, 330-64, 70, 35)];
            [_nayButton setBackgroundColor:[UIColor clearColor]];
            [_nayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_nayButton setTitle:@" NO" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
            
            UIImageView *noView = [[UIImageView alloc]initWithFrame:CGRectMake(-18, -10, 100, 50)];
            noView.image = [UIImage imageNamed:@"yes_no_button2.png"];
            noView.backgroundColor=[UIColor clearColor];
            [_nayButton addSubview:noView];
            
            [self getUserImage];
            
            self.changePic = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.changePic  setFrame:CGRectMake(0, 0, 320, 170)];
            [self.changePic setBackgroundColor:[UIColor clearColor]];
            [self.changePic addTarget:self action:@selector(changePicture) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.changePic];
            
            self.bottomView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 316, 320, 164)];
            [self.bottomView setUserInteractionEnabled:YES];
            [self.view addSubview:self.bottomView];
            
            _postBtn= [UIButton buttonWithType:UIButtonTypeCustom];
            [_postBtn  setFrame:CGRectMake(0, 141, 320, 47)];
            [_postBtn setBackgroundColor:[UIColor clearColor]];
            [self.postBtn addTarget:self action:@selector(postBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.postBtn.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:20]];
            self.postBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [self.postBtn setEnabled:YES];
            [self.bottomView addSubview:_postBtn];
            
            if (self.venueSelected) {
                
                UIImageView *gps_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50-9, 35, 37)];
                gps_icon.backgroundColor=[UIColor clearColor];
                gps_icon.image = [UIImage imageNamed:@"gps3.png"];
                [self.bottomView addSubview:gps_icon];
                
            }else{
                UIButton *locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [locationButton setFrame:CGRectMake(0, 48-9, 320, 41)];
                [locationButton setBackgroundColor:[UIColor clearColor]];
                [locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
                [locationButton setEnabled:YES];
                [self.bottomView addSubview:locationButton];
                
                UIImageView *gps_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50-9, 35, 37)];
                gps_icon.backgroundColor=[UIColor clearColor];
                gps_icon.image = [UIImage imageNamed:@"greygps2.png"];
                [self.bottomView addSubview:gps_icon];
            }
            
            UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [menuButton setFrame:CGRectMake(0, 89-15, 320, 45-6)];
            [menuButton setBackgroundColor:[UIColor clearColor]];
            [menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            [self.bottomView addSubview:menuButton];
            
            self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(63, 58-9, 260, 20)];
            NSString *string2;
            if (self.venueSelected) {
                string2 = self.venueSelected;
            }else{
                string2 = @"LOCATION";
            }
            self.locName=string2;
            if (self.locName) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.locName];
                float spacing = 1.4f;
                [attributedString addAttribute:NSKernAttributeName
                                         value:@(spacing)
                                         range:NSMakeRange(0, [self.locName length])];
                self.locationLabel.attributedText = attributedString;
            }
            self.locationLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
            self.locationLabel.textColor = [UIColor lightGrayColor];
            [self.bottomView addSubview:self.locationLabel];
            
            self.menuLabel = [[UILabel alloc]initWithFrame:CGRectMake(63, 103-15, 260, 20)];
            NSString *string3 = @"DISH NAME";
            self.dishName=string3;
            if (self.dishName) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.dishName];
                float spacing = 1.4f;
                [attributedString addAttribute:NSKernAttributeName
                                         value:@(spacing)
                                         range:NSMakeRange(0, [self.dishName length])];
                self.menuLabel.attributedText = attributedString;
            }
            self.menuLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
            self.menuLabel.textColor = [UIColor lightGrayColor];
            [self.bottomView addSubview:self.menuLabel];
            
            UIImageView *pencil_icon = [[UIImageView alloc]initWithFrame:CGRectMake(4, 9-3, 37, 37)];
            pencil_icon.backgroundColor=[UIColor clearColor];
            pencil_icon.image = [UIImage imageNamed:@"pencil2.png"];
            [self.bottomView addSubview:pencil_icon];
            
            UIImageView *tags_icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 85-15, 40, 50)];
            tags_icon.backgroundColor=[UIColor clearColor];
            tags_icon.image = [UIImage imageNamed:@"tags2.png"];
            [self.bottomView addSubview:tags_icon];
            
            UIImageView *vertical = [[UIImageView alloc]initWithFrame:CGRectMake(27, 0, 15, 158)];
            vertical.backgroundColor=[UIColor clearColor];
            vertical.image = [UIImage imageNamed:@"upload_vertical_line.png"];
            [self.bottomView addSubview:vertical];
            
            UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(173, 156-21, 30, 10)];
            arrow.backgroundColor=[UIColor clearColor];
            arrow.image = [UIImage imageNamed:@"upload_share_arrow.png"];
            [self.bottomView addSubview:arrow];
            
            UIImageView *ver_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 39-6, 320, 11)];
            ver_line.image = [UIImage imageNamed:@"lines.png"];
            ver_line.backgroundColor = [UIColor clearColor];
            [self.bottomView addSubview:ver_line];
            
            UIImageView *ver_line2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 83-12, 320, 11)];
            ver_line2.image = [UIImage imageNamed:@"lines.png"];
            ver_line2.backgroundColor = [UIColor clearColor];
            [self.bottomView addSubview:ver_line2];
            
            UIImageView *ver_line3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 129-17, 320, 11)];
            ver_line3.image = [UIImage imageNamed:@"lines.png"];
            ver_line3.backgroundColor = [UIColor clearColor];
            [self.bottomView addSubview:ver_line3];
            
            //white line to correct the gps image
            UIView *white_line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 81-11, 39, 5)];
            white_line.backgroundColor=[UIColor whiteColor];
            [self.bottomView addSubview:white_line];
            
            UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(123, 151-21, 100, 20)];
            NSString *string4 = @"SHARE";
            if (string4) {
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string4];
                float spacing = 1.4f;
                [attributedString addAttribute:NSKernAttributeName
                                         value:@(spacing)
                                         range:NSMakeRange(0, [string4 length])];
                shareLabel.attributedText = attributedString;
            }
            shareLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
            shareLabel.textColor = [self colorWithHexString:@"3ac0ec"];
            [self.bottomView addSubview:shareLabel];
            
            _commentView = [[UIImageView alloc]initWithFrame:CGRectMake( 0, 380, 320, 47)];
            [_commentView setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:_commentView];
            
            _quickNote = [[UITextView alloc]initWithFrame:CGRectMake( 58, 387-67, 260, 42)];
            _quickNote.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
            _quickNote.textColor = [UIColor lightGrayColor];
            _quickNote.backgroundColor = [UIColor clearColor];
            _quickNote.autocorrectionType = UITextAutocorrectionTypeDefault;
            _quickNote.keyboardType = UIKeyboardTypeDefault;
            _quickNote.returnKeyType = UIReturnKeyDone;
            _quickNote.delegate = self;
            _quickNote.text = @"WRITE A CAPTION...";
            [ _quickNote setUserInteractionEnabled:YES];
            [self.view addSubview:_quickNote];
            
            if(self.presentingViewController.presentedViewController == self) {
                
                self.backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
                self.backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
                [self.view addSubview:self.backBtnImage];
                
                self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.backBtn setFrame:CGRectMake(10, 20, 40, 40)];
                [self.backBtn setTitle:@"" forState:UIControlStateNormal];
                [self.backBtn setBackgroundColor:[UIColor clearColor]];
                //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.backBtn];
                
            }else{
                
                self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton3  setFrame:CGRectMake(0, 0, 60, 70)];
                [self.navButton3 setBackgroundColor:[UIColor clearColor]];
                [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton3.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                self.navButton3.tag = 1;
                self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.view addSubview:self.navButton3];
                
                self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton  setFrame:CGRectMake(10, 27, 25, 18)];
                [self.navButton setBackgroundColor:[UIColor clearColor]];
                [self.navButton setBackgroundImage:[[UIImage imageNamed:@"white_menu.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
                [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                self.navButton.tag = 1;
                self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.view addSubview:self.navButton];
                
                self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.navButton2  setFrame:CGRectMake(0, 63, 60, 520)];
                [self.navButton2 setBackgroundColor:[UIColor clearColor]];
                [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                [self.navButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                self.navButton2.tag = 0;
                self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [self.view addSubview:self.navButton2];
                
                [self.navButton2 setHidden:YES];
            }
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(dismissKeyboard)];
            [self.view addGestureRecognizer:tap];
            
            
        }
    } else {
        /*Do iPad stuff here.*/
        // NO!
    }

}



-(void)next_action:(id)sender{
    
    [self.instruction_screen_1 removeFromSuperview];
    [self.next_button removeFromSuperview];
    [self.cover_button removeFromSuperview];
    
    self.instruction_screen_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.instruction_screen_2 setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
    [self.view addSubview:self.instruction_screen_2];
    
    self.cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cover_button setFrame:CGRectMake(0, 0, 320, 568)];
    [self.cover_button addTarget:self action:@selector(cover_action:) forControlEvents:UIControlEventTouchUpInside];
    [self.cover_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.cover_button];
    
    CGRect r = self.instruction_screen_2.bounds;
    CGRect r2 = CGRectMake(0,300,320,68); // adjust this as desired!
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextAddRect(c, r2);
    CGContextAddRect(c, r);
    CGContextEOClip(c);
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextFillRect(c, r);
    UIImage* maskim = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)maskim.CGImage;
    self.instruction_screen_2.layer.mask = mask;
    
    UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(140, 375, 60, 60)];
    [pointing_finger setImage:[UIImage imageNamed:@"righthand.png"]];
    [self.instruction_screen_2 addSubview:pointing_finger];
    
    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -10.0)]; // y increases downwards on iOS
    hover.autoreverses = YES; // Animate back to normal afterwards
    hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
    hover.repeatCount = INFINITY; // The number of times the animation should repeat
    [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
    
    UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 430, 300, 30)];
    instruction1.textColor = [UIColor whiteColor];
    instruction1.text = @"Rate what you got here";
    instruction1.textAlignment = NSTextAlignmentCenter;
    [self.instruction_screen_2 addSubview:instruction1];
    
    UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 490, 100, 30)];
    next_label.textColor = [UIColor whiteColor];
    next_label.text = @"NEXT-->";
    [self.instruction_screen_2 addSubview:next_label];
    
    self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.next_button setFrame:CGRectMake(250, 490, 100, 30)];
    [self.next_button addTarget:self action:@selector(next_action_2:) forControlEvents:UIControlEventTouchUpInside];
    [self.next_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.next_button];
    
}

- (void)next_action_2:(id)sender{
    
    [self.instruction_screen_2 removeFromSuperview];
    [self.next_button removeFromSuperview];
    [self.cover_button removeFromSuperview];
    
    self.instruction_screen_3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.instruction_screen_3 setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
    [self.view addSubview:self.instruction_screen_3];
    
    self.cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cover_button setFrame:CGRectMake(0, 0, 320, 568)];
    [self.cover_button addTarget:self action:@selector(cover_action:) forControlEvents:UIControlEventTouchUpInside];
    [self.cover_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.cover_button];

    
    CGRect r = self.instruction_screen_3.bounds;
    CGRect r2 = CGRectMake(0,380,320,135); // adjust this as desired!
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextAddRect(c, r2);
    CGContextAddRect(c, r);
    CGContextEOClip(c);
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextFillRect(c, r);
    UIImage* maskim = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)maskim.CGImage;
    self.instruction_screen_3.layer.mask = mask;
    
    UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(120, 290, 120, 100)];
    [pointing_finger setImage:[UIImage imageNamed:@"pointer2.png"]];
    [self.instruction_screen_3 addSubview:pointing_finger];
    
    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -10.0)]; // y increases downwards on iOS
    hover.autoreverses = YES; // Animate back to normal afterwards
    hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
    hover.repeatCount = INFINITY; // The number of times the animation should repeat
    [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
    
    UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 150, 320, 90)];
    instruction1.textColor = [UIColor whiteColor];
    instruction1.text = @"Write a quick comment\nTag the place\nTag the item";
    instruction1.numberOfLines = 0;
    instruction1.textAlignment = NSTextAlignmentCenter;
    [self.instruction_screen_3 addSubview:instruction1];
    
    UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 290, 100, 30)];
    next_label.textColor = [UIColor whiteColor];
    next_label.text = @"NEXT-->";
    [self.instruction_screen_3 addSubview:next_label];
    
    self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.next_button setFrame:CGRectMake(250, 290, 100, 30)];
    [self.next_button addTarget:self action:@selector(next_action_3:) forControlEvents:UIControlEventTouchUpInside];
    [self.next_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.next_button];
    
    
}

- (void)next_action_3:(id)sender{
    
    [self.instruction_screen_3 removeFromSuperview];
    [self.next_button removeFromSuperview];
    [self.cover_button removeFromSuperview];
    
    self.instruction_screen_4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.instruction_screen_4 setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
    [self.view addSubview:self.instruction_screen_4];
    
    self.cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cover_button setFrame:CGRectMake(0, 0, 320, 568)];
    [self.cover_button addTarget:self action:@selector(cover_action:) forControlEvents:UIControlEventTouchUpInside];
    [self.cover_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.cover_button];
    
    CGRect r = self.instruction_screen_4.bounds;
    CGRect r2 = CGRectMake(0,518,320,50); // adjust this as desired!
    UIGraphicsBeginImageContextWithOptions(r.size, NO, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextAddRect(c, r2);
    CGContextAddRect(c, r);
    CGContextEOClip(c);
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    CGContextFillRect(c, r);
    UIImage* maskim = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CALayer* mask = [CALayer layer];
    mask.frame = r;
    mask.contents = (id)maskim.CGImage;
    self.instruction_screen_4.layer.mask = mask;
    
    UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(120, 400, 120, 100)];
    [pointing_finger setImage:[UIImage imageNamed:@"pointer2.png"]];
    [self.instruction_screen_4 addSubview:pointing_finger];
    
    CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
    hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
    hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
    hover.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0, -10.0)]; // y increases downwards on iOS
    hover.autoreverses = YES; // Animate back to normal afterwards
    hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
    hover.repeatCount = INFINITY; // The number of times the animation should repeat
    [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
    
    UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 340, 320, 90)];
    instruction1.textColor = [UIColor whiteColor];
    instruction1.text = @"Share your pic!";
    instruction1.numberOfLines = 0;
    instruction1.textAlignment = NSTextAlignmentCenter;
    [self.instruction_screen_4 addSubview:instruction1];
    
    UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 420, 100, 30)];
    next_label.textColor = [UIColor whiteColor];
    next_label.text = @"DONE";
    [self.instruction_screen_4 addSubview:next_label];
    
    self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.next_button setFrame:CGRectMake(250, 420, 100, 30)];
    [self.next_button addTarget:self action:@selector(next_action_4:) forControlEvents:UIControlEventTouchUpInside];
    [self.next_button setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.next_button];
    
}

- (void)next_action_4:(id)sender{
    
    [self.instruction_screen_4 removeFromSuperview];
    [self.next_button removeFromSuperview];
    [self.cover_button removeFromSuperview];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int launches = 1;
    [ud setObject:[NSNumber numberWithInt:launches] forKey:@"upload_screen"];
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

-(void)dismissKeyboard {
    [_quickNote resignFirstResponder];
}

- (void)getMenuForVenue {
    
    [Foursquare2 venueGetMenu:self.venueId
                     callback:^(BOOL success, id result){
                         if (success) {
                             NSDictionary *dic = result;
                             //                             NSLog(@"menu data 1 = %@",dic);
                             NSString *menus = [dic valueForKeyPath:@"response.menu.menus.count"];
                             //                             NSLog(@"menu data 2 = %@",menus);
                             
                             if (!([menus isEqual:0])) {
                                 
                                 NSString *menu1 = [result valueForKeyPath:@"response.menu.menus.items.entries.items.entries.items.name"];
                                 NSData *jsonData = [NSJSONSerialization dataWithJSONObject:menu1 options:NSJSONWritingPrettyPrinted error:nil];
                                 NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                 //NSLog(@"menu 1 = %@",jsonString);
                                 
                                 _menuObjects = [NSMutableArray array];
                                 NSScanner *scanner = [NSScanner scannerWithString:jsonString];
                                 NSString *tmp;
                                 
                                 while ([scanner isAtEnd] == NO)
                                 {
                                     [scanner scanUpToString:@"\"" intoString:NULL];
                                     [scanner scanString:@"\"" intoString:NULL];
                                     [scanner scanString:@"\\" intoString:NULL];
                                     [scanner scanUpToString:@"\"" intoString:&tmp];
                                     if ([scanner isAtEnd] == NO)
                                         [_menuObjects addObject:tmp];
                                     [scanner scanString:@"\"" intoString:NULL];
                                 }
                                 
                                 if (_menuObjects.count==0) {
                                     NSString *string = @"No menu found.";
                                     [_menuObjects insertObject:string atIndex:0];
                                 }
                                 
                                 [_menuTableView reloadData];
                                 
                             }
                             
                         }
                     }];
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

- (void)clearImage:(id)sender
{
    NSLog(@"clear image");
    self.uploadImage = nil;
    [self.dishImage removeFromSuperview];
    [self.modalView removeFromSuperview];
    self.dishImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)];
    [self.dishImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.dishImage setClipsToBounds:YES];
    [self.view addSubview:self.dishImage];
    [self.closeBtn removeFromSuperview];
    
}

- (void)yayButtonTouched:(id)sender
{
    _postVote = @"YAY";
//    NSLog(@"post vote = %@",_postVote);
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yayButton  setFrame:CGRectMake(73, 330, 70, 35)];
            [_yayButton setBackgroundColor:[UIColor clearColor]];

            [_yayButton setTitle:@" YES" forState:UIControlStateNormal];
            
            [self.view addSubview:_yayButton];
            
            
            UIImageView *yesView = [[UIImageView alloc]initWithFrame:CGRectMake(-8, -7, 85, 48)];
            yesView.image = [UIImage imageNamed:@"yes_no_button_after2.png"];
            yesView.backgroundColor=[UIColor clearColor];
            [_yayButton addSubview:yesView];
            
            [_yayButton setTitleColor:[self colorWithHexString:@"3ac0ec"]forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            

            
            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(175, 330, 70, 35)];
            [_nayButton setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [_nayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_nayButton setTitle:@" NO" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
            
            UIImageView *noView = [[UIImageView alloc]initWithFrame:CGRectMake(-18, -10, 100, 50)];
            noView.image = [UIImage imageNamed:@"yes_no_button2.png"];
            noView.backgroundColor=[UIColor clearColor];
            [_nayButton addSubview:noView];
            
        } else {
            /*Do iPhone Classic stuff here.*/
            _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yayButton  setFrame:CGRectMake(73, 330-64, 70, 35)];
            [_yayButton setBackgroundColor:[UIColor clearColor]];
            
            [_yayButton setTitle:@" YES" forState:UIControlStateNormal];
            
            [self.view addSubview:_yayButton];
            
            
            UIImageView *yesView = [[UIImageView alloc]initWithFrame:CGRectMake(-8, -7, 85, 48)];
            yesView.image = [UIImage imageNamed:@"yes_no_button_after2.png"];
            yesView.backgroundColor=[UIColor clearColor];
            [_yayButton addSubview:yesView];
            
            [_yayButton setTitleColor:[self colorWithHexString:@"3ac0ec"]forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            
            
            
            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(175, 330-64, 70, 35)];
            [_nayButton setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [_nayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_nayButton setTitle:@" NO" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
            
            UIImageView *noView = [[UIImageView alloc]initWithFrame:CGRectMake(-18, -10, 100, 50)];
            noView.image = [UIImage imageNamed:@"yes_no_button2.png"];
            noView.backgroundColor=[UIColor clearColor];
            [_nayButton addSubview:noView];
        }
    } else {
        /*Do iPad stuff here.*/
    }

}

- (IBAction)navButtonClicked:(id)sender {
    
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            self.navButton.tag = 1;
            self.navButton2.tag = 1;
            self.navButton3.tag = 1;
            [self.navButton2 setHidden:YES];
            [_delegate movePanelToOriginalPosition];
            
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

- (void)nayButtonTouched:(id)sender
{
    _postVote = @"NAY";
//    NSLog(@"post vote = %@",_postVote);
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            
            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(175, 330, 70, 35)];
            [_nayButton setBackgroundColor:[UIColor clearColor]];
            [_nayButton setTitle:@" NO" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
            
            UIImageView *noView = [[UIImageView alloc]initWithFrame:CGRectMake(-8, -8, 85, 48)];
            noView.image = [UIImage imageNamed:@"yes_no_button_after2.png"];
            noView.backgroundColor=[UIColor clearColor];
            [_nayButton addSubview:noView];
            
            [_nayButton setTitleColor:[self colorWithHexString:@"3ac0ec"]forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            
            _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yayButton  setFrame:CGRectMake(73, 330, 70, 35)];
            [_yayButton setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [_yayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_yayButton setTitle:@" YES" forState:UIControlStateNormal];
            [self.view addSubview:_yayButton];
            
            UIImageView *yesView = [[UIImageView alloc]initWithFrame:CGRectMake(-18, -10, 100, 50)];
            yesView.image = [UIImage imageNamed:@"yes_no_button2.png"];
            yesView.backgroundColor=[UIColor clearColor];
            [_yayButton addSubview:yesView];
        
        
        } else {
            /*Do iPhone Classic stuff here.*/
            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(175, 330-64, 70, 35)];
            [_nayButton setBackgroundColor:[UIColor clearColor]];
            [_nayButton setTitle:@" NO" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
            
            UIImageView *noView = [[UIImageView alloc]initWithFrame:CGRectMake(-8, -8, 85, 48)];
            noView.image = [UIImage imageNamed:@"yes_no_button_after2.png"];
            noView.backgroundColor=[UIColor clearColor];
            [_nayButton addSubview:noView];
            
            [_nayButton setTitleColor:[self colorWithHexString:@"3ac0ec"]forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            
            _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yayButton  setFrame:CGRectMake(73, 330-64, 70, 35)];
            [_yayButton setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
            [_yayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_yayButton setTitle:@" YES" forState:UIControlStateNormal];
            [self.view addSubview:_yayButton];
            
            UIImageView *yesView = [[UIImageView alloc]initWithFrame:CGRectMake(-18, -10, 100, 50)];
            yesView.image = [UIImage imageNamed:@"yes_no_button2.png"];
            yesView.backgroundColor=[UIColor clearColor];
            [_yayButton addSubview:yesView];
        }
    } else {
        /*Do iPad stuff here.*/
    }
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view.
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationItem setTitle:@"Upload Picture"];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    if (_uploadImage) {

    }else{
//        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upload photo", @"title")
//                                                        message:nil
//                                                       delegate:self
//                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
//                                              otherButtonTitles:@"Take a picture",@"Select from gallery",nil];
//        alert.tag=0;
//        [alert show];
    }
    
    if (_venueSelected) {
        NSString *venueName = _venueSelected;
        if ([venueName length] >= 16){
            venueName = [venueName substringToIndex:16];
            NSString *venueName2 = [NSString stringWithFormat:@"   %@...",venueName];
            [_locationButton setTitle:venueName2 forState:UIControlStateNormal];
        }else{
            NSString *venueName2 = [NSString stringWithFormat:@"   %@",venueName];
        [_locationButton setTitle:venueName2 forState:UIControlStateNormal];
        }
    }else{
        [_locationButton setTitle:@"   Where am I?" forState:UIControlStateNormal];
    }
    
    if (_menuSelected) {
        NSString *menuName = _menuSelected;
        if ([menuName length] >= 16){
            menuName = [menuName substringToIndex:16];
            NSString *menuName2 = [NSString stringWithFormat:@"   %@...",menuName];
            [_menuButton setTitle:menuName2 forState:UIControlStateNormal];
        }else{
            NSString *menuName2 = [NSString stringWithFormat:@"   %@",menuName];

            [_menuButton setTitle:menuName2 forState:UIControlStateNormal];
        }
    }else{
        [_menuButton setTitle:@"   Tag" forState:UIControlStateNormal];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.dishImage setImage:[UIImage imageNamed:@""]];
}

- (void)getUserImage
{
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f){
            
            // Whenever a person opens the app, check for a cached session
            if (FBSession.activeSession.isOpen) {
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                
                _userPicUrl = [ud objectForKey:@"user_pic_url"];
                
                //        NSLog(@"Found a cached session");
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
                         UIImageView *profile_icon = [[UIImageView alloc]initWithFrame:CGRectMake(108, 190, 100, 92)];
                         profile_icon.backgroundColor=[UIColor clearColor];
                         profile_icon.image = [UIImage imageNamed:@"profile_circle2.png"];
                         [self.view addSubview:profile_icon];
                         
                         self.cameraView.image = image;
                         [self.cameraView.layer setCornerRadius:self.cameraView.frame.size.width/2];
                         [self.cameraView setClipsToBounds:YES];
                         [self.view addSubview:_cameraView];
                         NSLog(@"profile image2");
                         
                         self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(125, 200, 72, 72)];
                         self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
                         [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
                         [self.profileImageView setClipsToBounds:YES];
                         [self.profileImageView setImage:image];
                         [self.view addSubview:self.profileImageView];
                         
                         self.userFullName = [NSString stringWithFormat:@"%@ %@",[[KCSUser activeUser].givenName uppercaseString],[[KCSUser activeUser].surname  uppercaseString]];
                         
                         UILabel *profileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 280, 320, 20)];
                         NSString *string4 = self.userFullName;
                         if (string4) {
                             NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string4];
                             float spacing = 1.4f;
                             [attributedString addAttribute:NSKernAttributeName
                                                      value:@(spacing)
                                                      range:NSMakeRange(0, [string4 length])];
                             profileLabel.attributedText = attributedString;
                         }
                         profileLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
                         profileLabel.textColor = [UIColor whiteColor];
                         profileLabel.textAlignment = NSTextAlignmentCenter;
                         [self.view addSubview:profileLabel];
                         
                         //     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                         
                         NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                         int launches = [[ud objectForKey:@"upload_screen"]intValue];
                         
                         if(launches == 0){
                         
                             self.instruction_screen_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 190, 320, 568-190)];
                             [self.instruction_screen_1 setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
                             [self.view addSubview:self.instruction_screen_1];
                             
                             self.cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
                             [self.cover_button setFrame:CGRectMake(0, 0, 320, 568)];
                             [self.cover_button addTarget:self action:@selector(cover_action:) forControlEvents:UIControlEventTouchUpInside];
                             [self.cover_button setBackgroundColor:[UIColor clearColor]];
                             [self.view addSubview:self.cover_button];
                             
                             UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(190, -110, 60, 60)];
                             [pointing_finger setImage:[UIImage imageNamed:@"leftpointer.png"]];
                             [self.instruction_screen_1 addSubview:pointing_finger];
                             
                             CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
                             hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
                             hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
                             hover.toValue = [NSValue valueWithCGPoint:CGPointMake(-10.0, 0.0)]; // y increases downwards on iOS
                             hover.autoreverses = YES; // Animate back to normal afterwards
                             hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
                             hover.repeatCount = INFINITY; // The number of times the animation should repeat
                             [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
                             
                             UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(10, -40, 300, 30)];
                             instruction1.textColor = [UIColor whiteColor];
                             instruction1.text = @"Take a pic or pick from your gallery";
                             instruction1.textAlignment = NSTextAlignmentCenter;
                             [self.instruction_screen_1 addSubview:instruction1];
                             
                             UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 300, 100, 30)];
                             next_label.textColor = [UIColor whiteColor];
                             next_label.text = @"NEXT-->";
                             [self.instruction_screen_1 addSubview:next_label];
                             
                             self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
                             [self.next_button setFrame:CGRectMake(250, 490, 100, 30)];
                             [self.next_button addTarget:self action:@selector(next_action:) forControlEvents:UIControlEventTouchUpInside];
                             [self.next_button setBackgroundColor:[UIColor clearColor]];
                             [self.view addSubview:self.next_button];
                             
                         }

                         
                         
                     }
                 }];
                
                // If there's no cached session, we will show a login button
            } else {
                
                _collectionName1 = @"userPicture";
                _customEndpoint1 = @"NewsFeed";
                _fieldName1 = @"_id";
                _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
                
                [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
                    if ([results isKindOfClass:[NSArray class]]) {
                        
                        _objects = [NSMutableArray arrayWithArray:results];
                        
                        if (_objects && _objects.count) {
                            //                    NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
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
                                     
                                     UIImageView *profile_icon = [[UIImageView alloc]initWithFrame:CGRectMake(108, 190, 100, 92)];
                                     profile_icon.backgroundColor=[UIColor clearColor];
                                     profile_icon.image = [UIImage imageNamed:@"profile_circle2.png"];
                                     [self.view addSubview:profile_icon];
                                     
                                     self.cameraView.image = image;
                                     [self.cameraView.layer setCornerRadius:self.cameraView.frame.size.width/2];
                                     [self.cameraView setClipsToBounds:YES];
                                     [self.view addSubview:_cameraView];
                                     NSLog(@"profile image2");
                                     
                                     self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(125, 200, 72, 72)];
                                     self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
                                     [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
                                     [self.profileImageView setClipsToBounds:YES];
                                     [self.profileImageView setImage:image];
                                     [self.view addSubview:self.profileImageView];
                                     
                                     self.userFullName = [NSString stringWithFormat:@"%@ %@",[[KCSUser activeUser].givenName uppercaseString],[[KCSUser activeUser].surname  uppercaseString]];
                                     
                                     UILabel *profileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 280, 320, 20)];
                                     NSString *string4 = self.userFullName;
                                     if (string4) {
                                         NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string4];
                                         float spacing = 1.4f;
                                         [attributedString addAttribute:NSKernAttributeName
                                                                  value:@(spacing)
                                                                  range:NSMakeRange(0, [string4 length])];
                                         profileLabel.attributedText = attributedString;
                                     }
                                     profileLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
                                     profileLabel.textColor = [UIColor whiteColor];
                                     profileLabel.textAlignment = NSTextAlignmentCenter;
                                     [self.view addSubview:profileLabel];
                                     
                                     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                     int launches = [[ud objectForKey:@"upload_screen"]intValue];
                                     
                                     if(launches == 0){
                                         
                                         self.instruction_screen_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 190, 320, 568-190)];
                                         [self.instruction_screen_1 setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8f]];
                                         [self.view addSubview:self.instruction_screen_1];
                                         
                                         self.cover_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                         [self.cover_button setFrame:CGRectMake(0, 0, 320, 568)];
                                         [self.cover_button addTarget:self action:@selector(cover_action:) forControlEvents:UIControlEventTouchUpInside];
                                         [self.cover_button setBackgroundColor:[UIColor clearColor]];
                                         [self.view addSubview:self.cover_button];
                                         
                                         UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(190, -110, 60, 60)];
                                         [pointing_finger setImage:[UIImage imageNamed:@"leftpointer.png"]];
                                         [self.instruction_screen_1 addSubview:pointing_finger];
                                         
                                         CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
                                         hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
                                         hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
                                         hover.toValue = [NSValue valueWithCGPoint:CGPointMake(-10.0, 0.0)]; // y increases downwards on iOS
                                         hover.autoreverses = YES; // Animate back to normal afterwards
                                         hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
                                         hover.repeatCount = INFINITY; // The number of times the animation should repeat
                                         [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
                                         
                                         UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(10, -40, 300, 30)];
                                         instruction1.textColor = [UIColor whiteColor];
                                         instruction1.text = @"Take a pic or pick from your gallery";
                                         instruction1.textAlignment = NSTextAlignmentCenter;
                                         [self.instruction_screen_1 addSubview:instruction1];
                                         
                                         UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 300, 100, 30)];
                                         next_label.textColor = [UIColor whiteColor];
                                         next_label.text = @"NEXT-->";
                                         [self.instruction_screen_1 addSubview:next_label];
                                         
                                         self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                         [self.next_button setFrame:CGRectMake(250, 490, 100, 30)];
                                         [self.next_button addTarget:self action:@selector(next_action:) forControlEvents:UIControlEventTouchUpInside];
                                         [self.next_button setBackgroundColor:[UIColor clearColor]];
                                         [self.view addSubview:self.next_button];
                                         
                                     }
                                     
                                     
                                 }
                             }];
                        }
                        
                    }
                }];
                
            }
            
        }
        else{
            if (FBSession.activeSession.isOpen) {
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                
                _userPicUrl = [ud objectForKey:@"user_pic_url"];
                
                //        NSLog(@"Found a cached session");
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
                         UIImageView *profile_icon = [[UIImageView alloc]initWithFrame:CGRectMake(108, 190-65, 100, 92)];
                         profile_icon.backgroundColor=[UIColor clearColor];
                         profile_icon.image = [UIImage imageNamed:@"profile_circle2.png"];
                         [self.view addSubview:profile_icon];
                         
                         self.cameraView.image = image;
                         [self.cameraView.layer setCornerRadius:self.cameraView.frame.size.width/2];
                         [self.cameraView setClipsToBounds:YES];
                         [self.view addSubview:_cameraView];
                         NSLog(@"profile image2");
                         
                         self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(125, 200-65, 72, 72)];
                         self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
                         [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
                         [self.profileImageView setClipsToBounds:YES];
                         [self.profileImageView setImage:image];
                         [self.view addSubview:self.profileImageView];
                         
                         self.userFullName = [NSString stringWithFormat:@"%@ %@",[[KCSUser activeUser].givenName uppercaseString],[[KCSUser activeUser].surname  uppercaseString]];
                         
                         UILabel *profileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 280-65, 320, 20)];
                         NSString *string4 = self.userFullName;
                         if (string4) {
                             NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string4];
                             float spacing = 1.4f;
                             [attributedString addAttribute:NSKernAttributeName
                                                      value:@(spacing)
                                                      range:NSMakeRange(0, [string4 length])];
                             profileLabel.attributedText = attributedString;
                         }
                         profileLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
                         profileLabel.textColor = [UIColor whiteColor];
                         profileLabel.textAlignment = NSTextAlignmentCenter;
                         [self.view addSubview:profileLabel];
                         
                         //     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                         
                         self.instruction_screen_1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 190, 320, 568-190)];
                         [self.instruction_screen_1 setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.5f]];
                         [self.view addSubview:self.instruction_screen_1];
                         
                         UIImageView *pointing_finger = [[UIImageView alloc]initWithFrame:CGRectMake(190, -110, 60, 60)];
                         [pointing_finger setImage:[UIImage imageNamed:@"leftpointer.png"]];
                         [self.instruction_screen_1 addSubview:pointing_finger];
                         
                         CABasicAnimation *hover = [CABasicAnimation animationWithKeyPath:@"position"];
                         hover.additive = YES; // fromValue and toValue will be relative instead of absolute values
                         hover.fromValue = [NSValue valueWithCGPoint:CGPointZero];
                         hover.toValue = [NSValue valueWithCGPoint:CGPointMake(-10.0, 0.0)]; // y increases downwards on iOS
                         hover.autoreverses = YES; // Animate back to normal afterwards
                         hover.duration = 0.3; // The duration for one part of the animation (0.2 up and 0.2 down)
                         hover.repeatCount = INFINITY; // The number of times the animation should repeat
                         [pointing_finger.layer addAnimation:hover forKey:@"myHoverAnimation"];
                         
                         UILabel *instruction1 = [[UILabel alloc]initWithFrame:CGRectMake(50, -40, 300, 30)];
                         instruction1.textColor = [UIColor whiteColor];
                         instruction1.text = @"Click here to upload a picture";
                         [self.instruction_screen_1 addSubview:instruction1];
                         
                         UILabel *next_label = [[UILabel alloc]initWithFrame:CGRectMake(250, 300, 100, 30)];
                         next_label.textColor = [UIColor whiteColor];
                         next_label.text = @"NEXT-->";
                         [self.instruction_screen_1 addSubview:next_label];
                         
                         self.next_button = [UIButton buttonWithType:UIButtonTypeCustom];
                         [self.next_button setFrame:CGRectMake(250, 490, 100, 30)];
                         [self.next_button addTarget:self action:@selector(next_action:) forControlEvents:UIControlEventTouchUpInside];
                         [self.next_button setBackgroundColor:[UIColor clearColor]];
                         [self.view addSubview:self.next_button];
                         
                     }
                 }];
                
                // If there's no cached session, we will show a login button
            } else {
                
                _collectionName1 = @"userPicture";
                _customEndpoint1 = @"NewsFeed";
                _fieldName1 = @"_id";
                _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
                
                [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
                    if ([results isKindOfClass:[NSArray class]]) {
                        
                        _objects = [NSMutableArray arrayWithArray:results];
                        
                        if (_objects && _objects.count) {
                            //                    NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
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
                                     
                                     UIImageView *profile_icon = [[UIImageView alloc]initWithFrame:CGRectMake(108, 190-65, 100, 92)];
                                     profile_icon.backgroundColor=[UIColor clearColor];
                                     profile_icon.image = [UIImage imageNamed:@"profile_circle2.png"];
                                     [self.view addSubview:profile_icon];
                                     
                                     self.cameraView.image = image;
                                     [self.cameraView.layer setCornerRadius:self.cameraView.frame.size.width/2];
                                     [self.cameraView setClipsToBounds:YES];
                                     [self.view addSubview:_cameraView];
                                     NSLog(@"profile image2");
                                     
                                     self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(125, 200-65, 72, 72)];
                                     self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
                                     [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
                                     [self.profileImageView setClipsToBounds:YES];
                                     [self.profileImageView setImage:image];
                                     [self.view addSubview:self.profileImageView];
                                     
                                     self.userFullName = [NSString stringWithFormat:@"%@ %@",[[KCSUser activeUser].givenName uppercaseString],[[KCSUser activeUser].surname  uppercaseString]];
                                     
                                     UILabel *profileLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 280-65, 320, 20)];
                                     NSString *string4 = self.userFullName;
                                     if (string4) {
                                         NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string4];
                                         float spacing = 1.4f;
                                         [attributedString addAttribute:NSKernAttributeName
                                                                  value:@(spacing)
                                                                  range:NSMakeRange(0, [string4 length])];
                                         profileLabel.attributedText = attributedString;
                                     }
                                     profileLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15.0];
                                     profileLabel.textColor = [UIColor whiteColor];
                                     profileLabel.textAlignment = NSTextAlignmentCenter;
                                     [self.view addSubview:profileLabel];
                                     
                                     
                                 }
                             }];
                        }
                        
                    }
                }];
                
            }

        }
    }
    
    
}
- (void)cover_action:(id)sender{
    
}

#pragma mark - pictures

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.uploadImage = nil;
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{

    
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
        
        self.uploadImage = newImage;
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f) {
                /*Do iPhone 5 stuff here.*/
//                self.dishImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
                self.dishImage.image = newImage;
                
                self.changePic = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.changePic  setFrame:CGRectMake(0, 0, 320, 180)];
                [self.changePic setBackgroundColor:[UIColor clearColor]];
                [self.changePic addTarget:self action:@selector(changePicture) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.changePic];
                
                self.closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(270, 10, 50, 50)];
                [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"whitex.png" ] forState:UIControlStateNormal];
                self.closeBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45f];
                [self.closeBtn addTarget:self action:@selector(clearImage:) forControlEvents:UIControlEventTouchUpInside];
                self.closeBtn.backgroundColor=[UIColor clearColor];
                [self.view addSubview:self.closeBtn];
                
                if(self.presentingViewController.presentedViewController == self) {
                    
                    NSLog(@"presented view");
                    self.backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
                    self.backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
                    [self.view addSubview:self.backBtnImage];
                    
                    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.backBtn setFrame:CGRectMake(10, 20, 40, 40)];
                    [self.backBtn setTitle:@"" forState:UIControlStateNormal];
                    [self.backBtn setBackgroundColor:[UIColor clearColor]];
                    //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:self.backBtn];
                    
                }else{
                    
                    NSLog(@"not presented view");
                    self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.navButton3  setFrame:CGRectMake(0, 0, 60, 70)];
                    [self.navButton3 setBackgroundColor:[UIColor clearColor]];
                    [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.navButton3.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                    self.navButton3.tag = 1;
                    self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [self.view addSubview:self.navButton3];
                    
                    self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.navButton  setFrame:CGRectMake(10, 27, 25, 18)];
                    [self.navButton setBackgroundColor:[UIColor clearColor]];
                    [self.navButton setBackgroundImage:[[UIImage imageNamed:@"white_menu.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
                    [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.navButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                    self.navButton.tag = 1;
                    self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [self.view addSubview:self.navButton];
                    
                    self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.navButton2  setFrame:CGRectMake(0, 63, 60, 520)];
                    [self.navButton2 setBackgroundColor:[UIColor clearColor]];
                    [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.navButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                    self.navButton2.tag = 0;
                    self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [self.view addSubview:self.navButton2];
                    
                    [self.navButton2 setHidden:YES];
                }


            }else{
                
                /*Do iPhone 4 stuff here.*/

//                self.dishImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)];
                self.dishImage.image = newImage;
//                //        [self.dishImage.layer setCornerRadius:self.dishImage.frame.size.width/2];
//                [self.dishImage setContentMode:UIViewContentModeCenter];
//                [self.dishImage setClipsToBounds:YES];
//                [self.view addSubview:self.dishImage];
                
                self.changePic = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.changePic  setFrame:CGRectMake(0, 0, 320, 120)];
                [self.changePic setBackgroundColor:[UIColor clearColor]];
                [self.changePic addTarget:self action:@selector(changePicture) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:self.changePic];
                
                if(self.presentingViewController.presentedViewController == self) {
                    
                    NSLog(@"presented view");
                    self.backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
                    self.backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
                    [self.view addSubview:self.backBtnImage];
                    
                    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.backBtn setFrame:CGRectMake(10, 20, 40, 40)];
                    [self.backBtn setTitle:@"" forState:UIControlStateNormal];
                    [self.backBtn setBackgroundColor:[UIColor clearColor]];
                    //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
                    [self.view addSubview:self.backBtn];
                    
                }else{
                    
                    NSLog(@"not presented view");
                    self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.navButton3  setFrame:CGRectMake(0, 0, 60, 70)];
                    [self.navButton3 setBackgroundColor:[UIColor clearColor]];
                    [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.navButton3.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                    self.navButton3.tag = 1;
                    self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [self.view addSubview:self.navButton3];
                    
                    self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.navButton  setFrame:CGRectMake(10, 27, 25, 18)];
                    [self.navButton setBackgroundColor:[UIColor clearColor]];
                    [self.navButton setBackgroundImage:[[UIImage imageNamed:@"white_menu.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
                    [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.navButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                    self.navButton.tag = 1;
                    self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [self.view addSubview:self.navButton];
                    
                    self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                    [self.navButton2  setFrame:CGRectMake(0, 63, 60, 520)];
                    [self.navButton2 setBackgroundColor:[UIColor clearColor]];
                    [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    [self.navButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                    self.navButton2.tag = 0;
                    self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [self.view addSubview:self.navButton2];
                    
                    [self.navButton2 setHidden:YES];
                }

            }
        }

        
        [self dismissModalViewControllerAnimated:NO];
        
        [self getUserImage];
                
    });

}

- (UIImage *)scaleAndRotateImage:(UIImage *)image { // here we rotate the image in its orignel
    int kMaxResolution = 640; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = roundf(bounds.size.width / ratio);
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = roundf(bounds.size.height * ratio);
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}

- (void)changePicture
{
//    NSLog(@"change pic pressed");
    UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upload photo", @"title")
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                          otherButtonTitles:@"Take a picture",@"Select from gallery",nil];
    alert2.tag=0;
    [alert2 show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==0) {
        
        if (buttonIndex == 0){
            //cancel clicked ...do your action
                
//                YookaAppDelegate* appDelegate = (id)[UIApplication sharedApplication].delegate;
//                [appDelegate userLoggedIn];
            
            } else if (buttonIndex == 1) {
                
                UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:imagePicker animated:NO completion:^{
                    
                }];
                
            }else if (buttonIndex == 2) {
                
                UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:imagePicker animated:NO completion:^{
                    
                }];
                
            }
            
        }
    
}

- (void)postBtnTouched:(id)sender
{

    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
//        self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, 300, 280, 60)];
//        self.progressView.progressViewStyle = UIProgressViewStyleBar;
//        self.progressView.backgroundColor = [UIColor grayColor];
//        UIImage *track = [[UIImage imageNamed:@"100.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 1)];
//        [self.progressView setTrackImage:track];
//        self.progressView.center = self.view.center;
//        [self.view addSubview:self.progressView];
        
        [self dismissKeyboard];
        
        NSLog(@"venue address = %@",self.venueAddress);
        NSLog(@"venue city = %@",self.venueCity);
    
        [self.postBtn setEnabled:NO];
        [self.locationButton setEnabled:NO];
        [self.menuButton setEnabled:NO];
    if(_uploadImage){
    if (_venueSelected) {
            if (_menuSelected) {
                if (_quickNote) {
                    if (_postVote) {
//                        NSLog(@"comment = %@ \n venue selected = %@ \n venue id = %@ \n venue address = %@ \n venue cc = %@ \n venue city = %@ \n venue country = %@ \n venue postal code = %@ \n venue state = %@ \n rating = %@ \n user profile pic = %@",_quickNote.text,_venueSelected,_venueID,_venueAddress,_venueCc,_venueCity,_venueCountry,_venuePostalCode,_venueState,_postVote,_userPicUrl);
                        [self savePostData];
                        [self getYookaMenuForVenue];
                    }else{
                        
                        [self.postBtn setEnabled:YES];

                        UIAlertView* alert4 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Vote", @"account success note title")
                                                                         message:NSLocalizedString(@"Please vote the picture!", @"account success message body")
                                                                        delegate:nil
                                                               cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                               otherButtonTitles:nil];
                        [alert4 show];
                    }
                    
                } else {
                    
                    [self.postBtn setEnabled:YES];

                    UIAlertView* alert1 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Comments", @"account success note title")
                                                                    message:NSLocalizedString(@"Please comment the picture!", @"account success message body")
                                                                   delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                          otherButtonTitles:nil];
                    [alert1 show];
                }
                
            } else {
                
                [self.postBtn setEnabled:YES];

                UIAlertView* alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Dish", @"account success note title")
                                                                message:NSLocalizedString(@"Please tag the dish!", @"account success message body")
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                      otherButtonTitles:nil];
                [alert2 show];
            }
            
        }else{
            
            [self.postBtn setEnabled:YES];
            
            UIAlertView* alert3 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Restaurant Selected", @"account success note title")
                                                            message:NSLocalizedString(@"Please select a restaurant!", @"account success message body")
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
            [alert3 show];
        }
        
    }else{
        
        [self.postBtn setEnabled:YES];

        UIAlertView* alert4 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Image Selected", @"title")
                                                         message:NSLocalizedString(@"Please select an image!", @"message body")
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                               otherButtonTitles:nil];
        [alert4 show];
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

- (void)updateUI:(NSTimer *)timer
{
    static int count =0; count++;
    
    if (count <=10)
    {
        self.progressView.progress = (float)count/10.0f;
    } else
    {
        [self.myTimer invalidate];
        self.myTimer = nil;
    } 
}

- (void)savePostData
{
    
    self.modalView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.modalView.opaque = NO;
    self.modalView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f];
    
    self.progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 120, self.view.frame.size.width-40, 2)];
    self.progressView.showText = @NO;
    self.progressView.progress = 0.10;
    [self.modalView addSubview:self.progressView];
    [self.view addSubview:self.modalView];
    
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
    
    if (_uploadImage) {
        YookaBackend *yookaObject = [[YookaBackend alloc]init];
        NSString *textstring = _quickNote.text;
        if ([textstring isEqualToString:@"WRITE A CAPTION..."]) {
            textstring = @"";
        }
        if ([textstring length] >= 100) textstring = [textstring substringToIndex:100];
        yookaObject.caption = textstring;
        if ([_venueSelected isKindOfClass:[NSNull class]]) {
            yookaObject.venueName = @"";
        }else{
        yookaObject.venueName = _venueSelected;
        }
        if ([_venueID isKindOfClass:[NSNull class]]) {
            yookaObject.venueId = @"";
        }else{
        yookaObject.venueId = _venueID;
        }
        if (_uploadImage) {
            yookaObject.dishImage = _uploadImage;
        }
        
        yookaObject.postDate = [NSDate date];
        yookaObject.userEmail = _userEmail;
        if (_huntName) {
            yookaObject.HuntName = _huntName;
            yookaObject.myHuntCount = self.huntCount;
            yookaObject.totalHuntCount = self.totalHuntCount;
            yookaObject.postType = @"hunt";
            if ([self.huntCount integerValue]>=[self.totalHuntCount integerValue]) {
                yookaObject.postCaption = [NSString stringWithFormat:@"completed %@", self.huntName];
            }else{
                yookaObject.postCaption = [NSString stringWithFormat:@"completed %@ of %@ %@", self.huntCount, self.totalHuntCount, self.huntName];
            }
        }else{
            yookaObject.HuntName = @"";
        }
        if (_menuSelected) {
            yookaObject.dishName = _menuSelected;
        }
        yookaObject.postVote = _postVote;
        if ([_venueAddress isKindOfClass:[NSNull class]]) {
            yookaObject.venueAddress = @"";
        }else{
            yookaObject.venueAddress = _venueAddress;
        }
        if ([_venueCc isKindOfClass:[NSNull class]]) {
            yookaObject.venueCc = @"";
        }else{
            yookaObject.venueCc = _venueCc;
        }
        if ([_venueCity isKindOfClass:[NSNull class]]) {
            yookaObject.venueCity = @"";
        }else{
            yookaObject.venueCity = _venueCity;
        }
        if ([_venueCountry isKindOfClass:[NSNull class]]) {
            yookaObject.venueCountry = @"";
        }else{
            yookaObject.venueCountry = _venueCountry;
        }
        if ([_venueState isKindOfClass:[NSNull class]]) {
            yookaObject.venueState = @"";
        }else{
            yookaObject.venueState = _venueState;
        }
        if ([_venuePostalCode isEqual:[NSNull null]]) {
            yookaObject.venuePostalCode = @"";
            NSLog(@"postal code 2 = %@",_venuePostalCode);
        }else{
            NSLog(@"postal code = %@",_venuePostalCode);
            yookaObject.venuePostalCode = _venuePostalCode;
        }
        yookaObject.userFullName = _userFullName;
        yookaObject.yooka_private = @"NO";
        yookaObject.deleted = @"NO";
        
//        [yookaObject.meta setGloballyReadable:YES];
//        [yookaObject.meta setGloballyWritable:YES];
        
        //Kinvey use code: add a new update to the updates collection
        [self.updateStore saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            
            if (errorOrNil == nil) {
                NSLog(@"saved successfully");
                
                [Flurry logEvent:@"Photo_Upload_Saved"];
                
                [self.modalView removeFromSuperview];
                
                if(self.presentingViewController.presentedViewController == self) {
                    
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
                    
                }else{
                    
                    [self.delegate didSelectViewWithName2:@"YookaNewsFeedViewController"];
                    
                }
                
                _venueSelected = nil;
                _menuSelected = nil;
                _uploadImage = nil;
                _quickNote.text = nil;
                _venueID = nil;
                _venueAddress = nil;
                _venueCc = nil;
                _venueCity = nil;
                _venueCountry = nil;
                _venuePostalCode = nil;
                _venueState = nil;
                self.dishImage.image = nil;
                _postVote = nil;
                
                [_quickNote resignFirstResponder];
                
                [self.postBtn setEnabled:YES];
                [self.locationButton setEnabled:YES];
                [self.menuButton setEnabled:YES];
                
            } else {
                
                [self.modalView removeFromSuperview];
                [Flurry logEvent:@"Photo_Upload_Failed"];
                
                [self.postBtn setEnabled:YES];
                [self.locationButton setEnabled:YES];
                [self.menuButton setEnabled:YES];
                BOOL wasNetworkError = [[errorOrNil domain] isEqual:KCSNetworkErrorDomain];
                NSString* title = wasNetworkError ? NSLocalizedString(@"There was a network error.", @"network error title"): NSLocalizedString(@"An error occurred.", @"Generic error message");
                NSString* message = wasNetworkError ? NSLocalizedString(@"Please wait a few minutes and try again.", @"try again error message") : [errorOrNil localizedDescription];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                message:message                                                           delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                      otherButtonTitles:nil];
                [alert show];

            }
        } withProgressBlock:^(NSArray *objects, double percentComplete
                              
                              ) {
            
//            percent = -(percentComplete)/1000000;
//            NSLog(@"percent complete = %f",percent);
//                if(0.00<percent<0.10){
//                _progressView.progress = 0.10;
//                }else if (0.10<percent<0.20){
//                    _progressView.progress = 0.20;
//                }

        }];
    }else{
        UIAlertView* alert3 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Image Selected", @"title")
                                                         message:NSLocalizedString(@"Please upload a dish image!", @"message body")
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                               otherButtonTitles:nil];
        [alert3 show];
    }
}

- (void)getYookaMenuForVenue{
    //    NSString *string = @"Add a Menu";
    //    [_menuObjects insertObject:string atIndex:0];
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaMenuRatinga" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery* query = [KCSQuery queryOnField:@"venueId" withExactMatchForValue:self.venueID];
    KCSQuery* query2 = [KCSQuery queryOnField:@"dishName" withExactMatchForValue:self.dishName];
    //    KCSQuery* query3 = [KCSQuery queryOnField:@"postType" usingConditional:kKCSNotEqual forValue:@"started hunt"];
    KCSQuery* query4 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2, nil];
    
    [store queryWithQuery:query4 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //                         NSLog(@"An error occurred on fetch: %@", errorOrNil);
            if ([self.postVote isEqualToString:@"YAY"]) {
                [self.yay_list addObject:[KCSUser activeUser].email];
            }else{
                [self.nay_list addObject:[KCSUser activeUser].email];
            }
            [self saveMenuData];
        
        } else {
            
            //got all events back from server -- update table view
            NSLog(@"featured hunt count = %lu",(unsigned long)objectsOrNil.count);
            NSMutableArray *array1 = [NSMutableArray new];
            NSMutableArray *array2 = [NSMutableArray new];

            if (objectsOrNil.count>0) {
                YookaBackend *yooka = objectsOrNil[0];
                array1 = [NSMutableArray arrayWithArray:yooka.yay_list];
                array2 = [NSMutableArray arrayWithArray:yooka.nay_list];
                if ([self.postVote isEqualToString:@"YAY"]) {
                    [array1 addObject:[KCSUser activeUser].email];
                    self.yay_list = array1;
                }else{
                    [array2 addObject:[KCSUser activeUser].email];
                    self.nay_list = array2;
                }
                [self saveMenuData];

            }else{
                if ([self.postVote isEqualToString:@"YAY"]) {
                    [self.yay_list addObject:[KCSUser activeUser].email];
                }else{
                    [self.nay_list addObject:[KCSUser activeUser].email];
                }
                [self saveMenuData];

            }
            
        }
    } withProgressBlock:nil];
    
}

- (void)saveMenuData
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.venueId = self.venueID;
    yookaObject.dishName = self.dishName;
    if (self.yay_list.count>0) {
        yookaObject.yay_list = self.yay_list;
    }
    if (self.nay_list.count>0) {
        yookaObject.nay_list = self.nay_list;
    }
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaMenuRatinga" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event 2014 (error= %@).",errorOrNil);
        } else {
            //save was successful
            NSLog(@"Successfully saved event 2014 (id='%@').", [objectsOrNil[0] kinveyObjectId]);
        }
    } withProgressBlock:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

- (void)updateLocation
{
    /*
    NSLog(@" postview %@",self.dishName);

    if (self.dishName) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.dishName];
        float spacing = 1.4f;
        [attributedString addAttribute:NSKernAttributeName
                                 value:@(spacing)
                                 range:NSMakeRange(0, [self.dishName length])];
        self.locationLabel.attributedText = attributedString;
    }
    
    [self.locationLabel setText:@"ADFA"];
    
    self.locationLabel.text=self.dishName;
    self.locationLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
       // [self.bottomView addSubview:self.locationLabel];
*/
}

- (void)showLocation:(id)sender
{
    
    YookaLocationViewController *media = [[YookaLocationViewController alloc]init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationItem setBackBarButtonItem: backBtn];
    
    media.delegate=self;
    
    [self presentViewController:media animated:YES completion:nil];
    
}

- (void)backAction
{
//    NSLog(@"BACK BUTTON");
}

- (void)showMenu:(id)sender
{
    YookaMenuViewController *media = [[YookaMenuViewController alloc]init];
    media.venueID = _venueID;
    media.venueSelected = _venueSelected;
    if (_menuSelected) {
        media.menuSelected = _menuSelected;
    }
    media.delegate = self;
    [self presentViewController:media animated:YES completion:nil];
}

-(void)sendLocationDataToA:(NSArray *)locationSelected
{
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
    
    
    // data will come here inside of ViewControllerA
    if (locationSelected.count>0) {
        if ([[locationSelected objectAtIndex:1] isKindOfClass:[NSNull class]]) {

        }else{
            _venueSelected = [locationSelected objectAtIndex:1];
            
        }
        NSLog(@" sendlocation %@",_venueSelected);
        
        //[self.locationLabel setText:_venueSelected];
        
        
        if (_venueSelected){
            
            UIImageView *gps_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50, 35, 37)];
            gps_icon.backgroundColor=[UIColor clearColor];
            gps_icon.image = [UIImage imageNamed:@"gps3.png"];
            [self.bottomView addSubview:gps_icon];
            
        }
        self.locName= [_venueSelected uppercaseString];
        
        if (self.locName) {
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.locName] ;
            float spacing = 1.4f;
            [attributedString addAttribute:NSKernAttributeName
                                     value:@(spacing)
                                     range:NSMakeRange(0, [self.locName length])];
            self.locationLabel.attributedText = attributedString;
        }

        
        _venueID = [locationSelected objectAtIndex:0];
        _venueAddress = [locationSelected objectAtIndex:2];
        _venueCc = [locationSelected objectAtIndex:3];
        _venueCity = [locationSelected objectAtIndex:4];
        _venueState = [locationSelected objectAtIndex:5];
        _venueCountry = [locationSelected objectAtIndex:6];
        _venuePostalCode = [locationSelected objectAtIndex:7];
        
        NSLog(@"venue id = %@",self.venueID);
        NSLog(@"venue address = %@",self.venueAddress);
    }
            
        }
        
        else{
            
            if (locationSelected.count>0) {
                if ([[locationSelected objectAtIndex:1] isKindOfClass:[NSNull class]]) {
                    
                }else{
                    _venueSelected = [locationSelected objectAtIndex:1];
                    
                }
                NSLog(@" sendlocation %@",_venueSelected);
                
                //[self.locationLabel setText:_venueSelected];
                
                
                if (_venueSelected){
                    
                    UIImageView *gps_icon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 50-9, 35, 37)];
                    gps_icon.backgroundColor=[UIColor clearColor];
                    gps_icon.image = [UIImage imageNamed:@"gps3.png"];
                    [self.bottomView addSubview:gps_icon];
                    
                }
                self.locName= [_venueSelected uppercaseString];
                
                if (self.locName) {
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.locName] ;
                    float spacing = 1.4f;
                    [attributedString addAttribute:NSKernAttributeName
                                             value:@(spacing)
                                             range:NSMakeRange(0, [self.locName length])];
                    self.locationLabel.attributedText = attributedString;
                }
                
                
                _venueID = [locationSelected objectAtIndex:0];
                _venueAddress = [locationSelected objectAtIndex:2];
                _venueCc = [locationSelected objectAtIndex:3];
                _venueCity = [locationSelected objectAtIndex:4];
                _venueState = [locationSelected objectAtIndex:5];
                _venueCountry = [locationSelected objectAtIndex:6];
                _venuePostalCode = [locationSelected objectAtIndex:7];

            }
            
        }
    }
}

- (void)sendMenuDataToA:(NSArray *)menuData
{
    if (menuData.count>2) {
        if ([[menuData objectAtIndex:2] isKindOfClass:[NSNull class]]) {
            
        }else{
            _menuSelected = [menuData objectAtIndex:2];
            //_menuLabel.text = _menuSelected;
        }
    }
    if (menuData.count>0) {
        _venueID = menuData[0];
        if ([[menuData objectAtIndex:1] isKindOfClass:[NSNull class]]) {
            
        }else{
            _venueSelected = [menuData objectAtIndex:1];
            //_locationLabel.text = _venueSelected;

        }
    }
    
    
    if (_menuSelected){
        self.dishName= [_menuSelected uppercaseString];
    }

    
    if (self.dishName) {

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.dishName] ;
        float spacing = 1.4f;
        [attributedString addAttribute:NSKernAttributeName
                                 value:@(spacing)
                                 range:NSMakeRange(0, [self.dishName length])];
        self.menuLabel.attributedText = attributedString;
    }

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView setAutocorrectionType:UITextAutocorrectionTypeDefault];

    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    
//    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    textView.textColor = [UIColor lightGrayColor];;
    if ([textView.text isEqualToString:@"WRITE A CAPTION..."]) {
        textView.text = @"";
        if (_huntName) {
            textView.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
            textView.text = [NSString stringWithFormat:@"%@.",_huntName];
        }
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    textView.textColor = [UIColor lightGrayColor];;
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"WRITE A CAPTION...";
        textView.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13.0];
        textView.textColor = [UIColor lightGrayColor]; //optional
    }

    [textView resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loction
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // get the height since this is the main value that we need.
//    NSInteger kbSizeH = keyboardBounds.size.height;
    
//    // get a rect for the table/main frame
//    CGRect tableFrame = viewTable.frame;
//    tableFrame.size.height -= kbSizeH;
//    
//    // get a rect for the form frame
//    CGRect formFrame = viewForm.frame;
//    formFrame.origin.y -= kbSizeH;
    
    // animations settings
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:0.3f];
//    
//    // set views with new info
////    viewTable.frame = tableFrame;
////    viewForm.frame = formFrame;
//    
//    // commit animations
//    [UIView commitAnimations];
    
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(void) keyPressed: (NSNotification*) notification{
    // get the size of the text block so we can work our magic
    CGSize newSize = [_quickNote.text
                      sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]
                      constrainedToSize:CGSizeMake(222,9999)
                      lineBreakMode:NSLineBreakByWordWrapping];
    NSInteger newSizeH = newSize.height;
//    NSInteger newSizeW = newSize.width;
    
    // I output the new dimensions to the console
    // so we can see what is happening
//    NSLog(@"NEW SIZE : %d X %d", newSizeW, newSizeH);
    if (_quickNote.hasText)
    {
        // if the height of our new chatbox is
        // below 90 we can set the height
        if (newSizeH <= 65)
        {
            [_quickNote scrollRectToVisible:CGRectMake(0,0,1,1) animated:NO];
            
            // chatbox
//            CGRect chatBoxFrame = _quickNote.frame;
//            NSInteger chatBoxH = chatBoxFrame.size.height;
//            NSInteger chatBoxW = chatBoxFrame.size.width;
//            NSLog(@"CHAT BOX SIZE : %d X %d", chatBoxW, chatBoxH);
//            chatBoxFrame.size.height = newSizeH;
//            _quickNote.frame = chatBoxFrame;
            
//            // form view
//            CGRect formFrame = viewForm.frame;
//            NSInteger viewFormH = formFrame.size.height;
//            NSLog(@"FORM VIEW HEIGHT : %d", viewFormH);
//            formFrame.size.height = 30 + newSizeH;
//            formFrame.origin.y = 199 - (newSizeH - 18);
//            viewForm.frame = formFrame;
//            
//            // table view
//            CGRect tableFrame = viewTable.frame;
//            NSInteger viewTableH = tableFrame.size.height;
//            NSLog(@"TABLE VIEW HEIGHT : %d", viewTableH);
//            tableFrame.size.height = 199 - (newSizeH - 18);
//            viewTable.frame = tableFrame;
        }
        
        // if our new height is greater than 90
        // sets not set the height or move things
        // around and enable scrolling
        if (newSizeH > 65)
        {
            _quickNote.scrollEnabled = YES;
        }
    }
}

-(void) keyboardWillHide:(NSNotification *)note{
    // get keyboard size and loction
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    // get the height since this is the main value that we need.
//    NSInteger kbSizeH = keyboardBounds.size.height;
    
//    // get a rect for the table/main frame
//    CGRect tableFrame = viewTable.frame;
//    tableFrame.size.height += kbSizeH;
//    
//    // get a rect for the form frame
//    CGRect formFrame = viewForm.frame;
//    formFrame.origin.y += kbSizeH;
    
//    // animations settings
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationBeginsFromCurrentState:YES];
//    [UIView setAnimationDuration:0.3f];
//    
////    // set views with new info
////    viewTable.frame = tableFrame;
////    viewForm.frame = formFrame;
//    
//    // commit animations
//    [UIView commitAnimations];
    
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

#pragma mark - DYRateViewDelegate

- (void)rateView:(DYRateView *)rateView changedToNewRate:(NSNumber *)rate {
    _rateValue = [NSString stringWithFormat:@"%d",rate.intValue];
//    NSLog(@"rate = %@",_rateValue);
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.filteredArray count];
    } else {
        return self.menuObjects.count;
    }}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (self.filteredArray.count) {
            return 1;
        }
    } else {
        if (self.menuObjects.count) {
            return 1;
        }    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_menuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //        if(indexPath.row % 2 == 0)
        //            cell.backgroundColor = [self colorWithHexString:@"43444F"];
        //        else
        //            cell.backgroundColor = [self colorWithHexString:@"2F2F36"];
        
        // create a custom label:                                        x    y   width  height
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 0.0, 280.0, 40.0)];
        [_descriptionLabel setTag:1];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        _descriptionLabel.textColor = [UIColor whiteColor];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        [_descriptionLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:_descriptionLabel];
        
    }
    
    //    cell.textLabel.text = self.menuObjects[indexPath.row];
    //    FSVenue *venue = self.nearbyVenues[indexPath.row];
    //    if (venue.location.address) {
    //        //        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m, %@",
    //        //                                     venue.location.distance,
    //        //                                     venue.location.address];
    //    } else {
    //        //        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
    //        //                                     venue.location.distance];
    //    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [(UILabel *)[cell.contentView viewWithTag:1] setText:self.filteredArray[indexPath.row]];
    } else {
        [(UILabel *)[cell.contentView viewWithTag:1] setText:self.menuObjects[indexPath.row]];
    }
    
    //    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(20,6, 30, 31)];
    //    imv.image=[UIImage imageNamed:@"check_box.jpeg"];
    //    [cell.contentView addSubview:imv];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView willDisplayCell: (UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath *)indexPath {
    
    if(indexPath.row % 2 == 0)
        cell.backgroundColor = [self colorWithHexString:@"43444F"];
    else
        cell.backgroundColor = [self colorWithHexString:@"2F2F36"];
}

@end
