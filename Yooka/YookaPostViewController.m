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
#import "YookaMenu2ViewController.h"
#import "YookaNewsFeedViewController.h"
#import <Reachability.h>
#import "UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"


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
    
    if (self.navigationController.viewControllers.count >1) {
        NSLog(@"previous view controller = %@",[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2]);
        UIViewController *previousViewController = [[[self navigationController]viewControllers] objectAtIndex:([self.navigationController.viewControllers indexOfObject:self]-1)];
        NSLog(@"Previous view controller = %@",previousViewController);
    }
    
    NSLog(@"venue add = %@",_venueAddress);
    NSLog(@"venue city = %@",_venueCity);
    
    _userEmail = [[KCSUser activeUser] email];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            _cameraView = [[UIImageView alloc]initWithFrame:CGRectMake(130, 128, 60, 60)];
            _cameraView.image = [UIImage imageNamed:@"image_profile_bg@2x.png"];
            self.cameraView.layer.cornerRadius = self.cameraView.frame.size.height / 2;
            [self.cameraView.layer setBorderWidth:2.0];
            [self.cameraView.layer setBorderColor:[[UIColor orangeColor] CGColor]];
            [self.view addSubview:_cameraView];
            
            [self getUserImage];
            
            self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{
                                                                         KCSStoreKeyCollectionName : @"yookaPosts2",
                                                                         KCSStoreKeyCollectionTemplateClass : [YookaBackend class]}];
            
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
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(dismissKeyboard)];
            [self.view addGestureRecognizer:tap];
            
            //    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
            //    [self.navigationController.navigationBar setBarTintColor:color];
            //    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
            
            //    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, 25, 140, 20)];
            //    _titleLabel.text = @"Upload Picture";
            //    _titleLabel.textColor = [UIColor whiteColor];
            //    _titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
            //    [self.view addSubview:_titleLabel];
            
            //    self.dishImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
            //    //        [self.dishImage.layer setCornerRadius:self.dishImage.frame.size.width/2];
            //    self.dishImage.contentMode = UIViewContentModeCenter;
            //    [self.dishImage setClipsToBounds:YES];
            //    [self.view addSubview:self.dishImage];
            
            _bglineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 160, 320, 1)];
            _bglineLabel.backgroundColor = [UIColor orangeColor];
            [self.view addSubview:_bglineLabel];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM dd, yyyy"];
            _dateString = [formatter stringFromDate:[NSDate date]];
            
            _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 165, 80, 21)];
            //    UIColor * color2 = [UIColor colorWithRed:84/255.0f green:84/255.0f blue:84/255.0f alpha:1.0f];
            _dateLabel.textColor = [UIColor orangeColor];
            _dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
            _dateLabel.text = _dateString;
            _dateLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:_dateLabel];
            
            _commentView = [[UIImageView alloc]initWithFrame:CGRectMake(58, 280, 210, 70)];
            _commentView.image = [UIImage imageNamed:@"commentbox.png"];
            [self.view addSubview:_commentView];
            
            //    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(73, 239, 196, 21)];
            //    _locationLabel.textColor = [UIColor lightGrayColor];
            //    _locationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
            //    if (_venueSelected) {
            //        _locationLabel.text = _venueSelected;
            //    }else{
            //    _locationLabel.text = @"Where am I?";
            //    }
            //    _locationLabel.textAlignment = NSTextAlignmentLeft;
            //    [self.view addSubview:_locationLabel];
            
            UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
            
            _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_locationButton  setFrame:CGRectMake(57, 189, 212, 36)];
            [_locationButton setBackgroundColor:[UIColor clearColor]];
            [_locationButton setBackgroundImage:[[UIImage imageNamed:@"dropbox.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_locationButton setTitleColor:color forState:UIControlStateNormal];
            [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
            [self.locationButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
            self.locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
            //    [self.locationButton.layer setShadowOffset:CGSizeMake(0, 2)];
            //    [self.locationButton.layer setShadowColor:[[UIColor grayColor] CGColor]];
            //    [self.locationButton.layer setShadowOpacity:0.5];
            [self.view addSubview:_locationButton];
            
            //    self.locationButton = [[FUIButton alloc]initWithFrame:CGRectMake(57, 199, 212, 32)];
            //    UIColor * color4 = [UIColor colorWithRed:245/255.0f green:135/255.0f blue:77/255.0f alpha:1.0f];
            //    self.locationButton.buttonColor = [UIColor whiteColor];
            //    UIColor * color5 = [UIColor colorWithRed:221/255.0f green:117/255.0f blue:62/255.0f alpha:1.0f];
            //    self.locationButton.shadowColor = [UIColor lightGrayColor];
            //    self.locationButton.shadowHeight = 3.0f;
            //    self.locationButton.cornerRadius = 6.0f;
            //    [self.locationButton.layer setBorderWidth:1.0f];
            //    [self.locationButton.layer setBorderColor:[[UIColor grayColor]CGColor]];
            //    self.locationButton.layer.cornerRadius = 6.0f;
            //    self.locationButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:13.0];
            //    [self.locationButton setTitle:@"Where am I?" forState:UIControlStateNormal];
            //    [self.locationButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            //    [self.locationButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
            //    [_locationButton setImage:[UIImage imageNamed:@"dropbox.png"] forState:UIControlStateNormal];
            //    [_locationButton setImage:[UIImage imageNamed:@"dropbox.png"] forState:UIControlStateHighlighted];
            //    [_locationButton setImage:[UIImage imageNamed:@"dropbox.png"] forState:UIControlStateSelected];
            //    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.view addSubview:self.locationButton];
            
            if (self.navigationController.viewControllers.count>1 && [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] isKindOfClass:[YookaHuntVenuesViewController class]]) {
                [_locationButton setEnabled:NO];
            }else  if (self.navigationController.viewControllers.count>1 && [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2]isKindOfClass:[YookaMenu2ViewController class]]) {
                [_locationButton setEnabled:NO];
            }else{
                [_locationButton setEnabled:YES];
            }
            
            //    _menuLabel = [[UILabel alloc]initWithFrame:CGRectMake(73, 278, 196, 21)];
            //    _menuLabel.textColor = [UIColor lightGrayColor];
            //    _menuLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
            //    if (_menuSelected) {
            //        _menuLabel.text = _menuSelected;
            //    }else{
            //    _menuLabel.text = @"Tag the dish";
            //    }
            //    _menuLabel.textAlignment = NSTextAlignmentLeft;
            //    [self.view addSubview:_menuLabel];
            
            _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_menuButton  setFrame:CGRectMake(57, 234, 212, 36)];
            [_menuButton setTitleColor:color forState:UIControlStateNormal];
            [self.menuButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
            [self.menuButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [_menuButton setBackgroundColor:[UIColor clearColor]];
            self.menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
            //    [[_menuButton imageView] setContentMode:UIViewContentModeScaleAspectFill];
            [_menuButton setBackgroundImage:[UIImage imageNamed:@"dropbox.png"] forState:UIControlStateNormal];
            [_menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_menuButton];
            
            //    _downArrow1 = [UIButton buttonWithType:UIButtonTypeCustom];
            //    [_downArrow1  setFrame:CGRectMake(277, 239, 23, 22)];
            //    [_downArrow1 setImage:[UIImage imageNamed:@"down_side_arrrow_button.png"] forState:UIControlStateNormal];
            //    [self.view addSubview:_downArrow1];
            
            //    _downArrow1 = [UIButton buttonWithType:UIButtonTypeCustom];
            //    [_downArrow1  setFrame:CGRectMake(277, 278, 23, 22)];
            //    [_downArrow1 setImage:[UIImage imageNamed:@"down_side_arrrow_button.png"] forState:UIControlStateNormal];
            //    [self.view addSubview:_downArrow1];
            
            _quickNote = [[UITextView alloc]initWithFrame:CGRectMake(63, 280, 200, 60)];
            _quickNote.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
            _quickNote.textColor = color;
            _quickNote.backgroundColor = [UIColor clearColor];
            _quickNote.autocorrectionType = UITextAutocorrectionTypeNo;
            _quickNote.keyboardType = UIKeyboardTypeDefault;
            _quickNote.returnKeyType = UIReturnKeyNext;
            _quickNote.delegate = self;
            _quickNote.text = @"Comments";
            _quickNote.textColor = color;
            [self.view addSubview:_quickNote];
            
            _rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(84, 400, 152, 21)];
            UIColor * color3 = [UIColor colorWithRed:84/255.0f green:84/255.0f blue:84/255.0f alpha:1.0f];
            _rateLabel.textColor = color3;
            _rateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0];
            _rateLabel.text = @"Rate the dish";
            _rateLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:_rateLabel];
            
            //    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 430, self.view.bounds.size.width, 20) fullStar:[UIImage imageNamed:@"StarFull.png"] emptyStar:[UIImage imageNamed:@"StarEmpty.png"]];
            //    rateView.padding = 20;
            //    rateView.alignment = RateViewAlignmentCenter;
            //    rateView.editable = YES;
            //    rateView.delegate = self;
            //    [self.view addSubview:rateView];
            
            _voteImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 365, 320, 100)];
            [_voteImageview setBackgroundColor:color];
            [self.view addSubview:_voteImageview];
            
            _voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 120, 20)];
            _voteLabel.text = @"GET IT AGAIN?";
            _voteLabel.font = [UIFont fontWithName:@"Montserrat-regular" size:12.0];
            _voteLabel.textAlignment = NSTextAlignmentCenter;
            [_voteImageview addSubview:_voteLabel];
            
            //    _yayImageview = [[UIImageView alloc]initWithFrame:CGRectMake(70, 25, 75, 70)];
            //    _yayImageview.image = [UIImage imageNamed:@"orangecircle.png"];
            //    [_voteImageview addSubview:_yayImageview];
            //
            //    _yayLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, 40, 20)];
            //    _yayLabel.text = @"YAY";
            //    _yayLabel.textAlignment = NSTextAlignmentCenter;
            //    _yayLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:20];
            //    [_yayImageview addSubview:_yayLabel];
            
            UIImageView *icon1 = [[UIImageView alloc]initWithFrame:CGRectMake(32, 197, 20, 27)];
            icon1.image = [UIImage imageNamed:@"icon1.png"];
            [self.view addSubview:icon1];
            
            UIImageView *icon2 = [[UIImageView alloc]initWithFrame:CGRectMake(27, 243, 25, 27)];
            icon2.image = [UIImage imageNamed:@"icon2.png"];
            [self.view addSubview:icon2];
            
            UIImageView *icon3 = [[UIImageView alloc]initWithFrame:CGRectMake(27, 288, 25, 27)];
            icon3.image = [UIImage imageNamed:@"icon3.png"];
            [self.view addSubview:icon3];
            
            _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yayButton  setFrame:CGRectMake(70, 390, 75, 70)];
            [_yayButton setBackgroundColor:[UIColor clearColor]];
            [_yayButton setBackgroundImage:[[UIImage imageNamed:@"orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_yayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_yayButton setTitle:@"  YAY" forState:UIControlStateNormal];
            [self.view addSubview:_yayButton];
            
            //    _nayImageview = [[UIImageView alloc]initWithFrame:CGRectMake(180, 25, 75, 70)];
            //    _nayImageview.image = [UIImage imageNamed:@"orangecircle.png"];
            //    [_voteImageview addSubview:_nayImageview];
            
            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(174, 390, 75, 70)];
            [_nayButton setBackgroundColor:[UIColor clearColor]];
            [_nayButton setBackgroundImage:[[UIImage imageNamed:@"orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_nayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_nayButton setTitle:@"  NAY" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
            
            _postBtn= [UIButton buttonWithType:UIButtonTypeCustom];
            [_postBtn  setFrame:CGRectMake(72, 475, 175, 35)];
            [_postBtn setBackgroundColor:[UIColor clearColor]];
            [_postBtn setBackgroundImage:[[UIImage imageNamed:@"sharebutton-2.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.postBtn addTarget:self action:@selector(postBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.postBtn.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:20]];
            self.postBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_postBtn setTitle:@"SHARE" forState:UIControlStateNormal];
            [self.view addSubview:_postBtn];
            
            [self getUserImage];
            
            self.changePic = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.changePic  setFrame:CGRectMake(0, 0, 320, 180)];
            [self.changePic setBackgroundColor:[UIColor clearColor]];
            [self.changePic addTarget:self action:@selector(changePicture) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.changePic];
        } else {
            /*Do iPhone Classic stuff here.*/
            _cameraView = [[UIImageView alloc]initWithFrame:CGRectMake(140, 98, 40, 40)];
            _cameraView.image = [UIImage imageNamed:@"image_profile_bg@2x.png"];
            self.cameraView.layer.cornerRadius = self.cameraView.frame.size.height / 2;
            [self.cameraView.layer setBorderWidth:2.0];
            [self.cameraView.layer setBorderColor:[[UIColor orangeColor] CGColor]];
            [self.view addSubview:_cameraView];
            
            [self getUserImage];
            
            self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{
                                                                         KCSStoreKeyCollectionName : @"yookaPosts2",
                                                                         KCSStoreKeyCollectionTemplateClass : [YookaBackend class]}];
            
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
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(dismissKeyboard)];
            [self.view addGestureRecognizer:tap];
            
            //    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
            //    [self.navigationController.navigationBar setBarTintColor:color];
            //    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
            
            //    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(107, 25, 140, 20)];
            //    _titleLabel.text = @"Upload Picture";
            //    _titleLabel.textColor = [UIColor whiteColor];
            //    _titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
            //    [self.view addSubview:_titleLabel];
            
            //    self.dishImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
            //    //        [self.dishImage.layer setCornerRadius:self.dishImage.frame.size.width/2];
            //    self.dishImage.contentMode = UIViewContentModeCenter;
            //    [self.dishImage setClipsToBounds:YES];
            //    [self.view addSubview:self.dishImage];
            
            _bglineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 120, 320, 1)];
            _bglineLabel.backgroundColor = [UIColor orangeColor];
            [self.view addSubview:_bglineLabel];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM dd, yyyy"];
            _dateString = [formatter stringFromDate:[NSDate date]];
            
            _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 125, 80, 21)];
            //    UIColor * color2 = [UIColor colorWithRed:84/255.0f green:84/255.0f blue:84/255.0f alpha:1.0f];
            _dateLabel.textColor = [UIColor orangeColor];
            _dateLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10.0];
            _dateLabel.text = _dateString;
            _dateLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:_dateLabel];
            
            _commentView = [[UIImageView alloc]initWithFrame:CGRectMake(58, 230, 210, 70)];
            _commentView.image = [UIImage imageNamed:@"commentbox.png"];
            [self.view addSubview:_commentView];
            
            //    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(73, 239, 196, 21)];
            //    _locationLabel.textColor = [UIColor lightGrayColor];
            //    _locationLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
            //    if (_venueSelected) {
            //        _locationLabel.text = _venueSelected;
            //    }else{
            //    _locationLabel.text = @"Where am I?";
            //    }
            //    _locationLabel.textAlignment = NSTextAlignmentLeft;
            //    [self.view addSubview:_locationLabel];
            
            UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
            
            _locationButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_locationButton  setFrame:CGRectMake(57, 149, 212, 36)];
            [_locationButton setBackgroundColor:[UIColor clearColor]];
            [_locationButton setBackgroundImage:[[UIImage imageNamed:@"dropbox.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_locationButton setTitleColor:color forState:UIControlStateNormal];
            [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
            [self.locationButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
            self.locationButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
            //    [self.locationButton.layer setShadowOffset:CGSizeMake(0, 2)];
            //    [self.locationButton.layer setShadowColor:[[UIColor grayColor] CGColor]];
            //    [self.locationButton.layer setShadowOpacity:0.5];
            [self.view addSubview:_locationButton];
            
            //    self.locationButton = [[FUIButton alloc]initWithFrame:CGRectMake(57, 199, 212, 32)];
            //    UIColor * color4 = [UIColor colorWithRed:245/255.0f green:135/255.0f blue:77/255.0f alpha:1.0f];
            //    self.locationButton.buttonColor = [UIColor whiteColor];
            //    UIColor * color5 = [UIColor colorWithRed:221/255.0f green:117/255.0f blue:62/255.0f alpha:1.0f];
            //    self.locationButton.shadowColor = [UIColor lightGrayColor];
            //    self.locationButton.shadowHeight = 3.0f;
            //    self.locationButton.cornerRadius = 6.0f;
            //    [self.locationButton.layer setBorderWidth:1.0f];
            //    [self.locationButton.layer setBorderColor:[[UIColor grayColor]CGColor]];
            //    self.locationButton.layer.cornerRadius = 6.0f;
            //    self.locationButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:13.0];
            //    [self.locationButton setTitle:@"Where am I?" forState:UIControlStateNormal];
            //    [self.locationButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            //    [self.locationButton setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
            //    [_locationButton setImage:[UIImage imageNamed:@"dropbox.png"] forState:UIControlStateNormal];
            //    [_locationButton setImage:[UIImage imageNamed:@"dropbox.png"] forState:UIControlStateHighlighted];
            //    [_locationButton setImage:[UIImage imageNamed:@"dropbox.png"] forState:UIControlStateSelected];
            //    [self.locationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.view addSubview:self.locationButton];
            
            if (self.navigationController.viewControllers.count>1 && [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] isKindOfClass:[YookaHuntVenuesViewController class]]) {
                [_locationButton setEnabled:NO];
            }else  if (self.navigationController.viewControllers.count>1 && [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2]isKindOfClass:[YookaMenu2ViewController class]]) {
                [_locationButton setEnabled:NO];
            }else{
                [_locationButton setEnabled:YES];
            }
            
            //    _menuLabel = [[UILabel alloc]initWithFrame:CGRectMake(73, 278, 196, 21)];
            //    _menuLabel.textColor = [UIColor lightGrayColor];
            //    _menuLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14.0];
            //    if (_menuSelected) {
            //        _menuLabel.text = _menuSelected;
            //    }else{
            //    _menuLabel.text = @"Tag the dish";
            //    }
            //    _menuLabel.textAlignment = NSTextAlignmentLeft;
            //    [self.view addSubview:_menuLabel];
            
            _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_menuButton  setFrame:CGRectMake(57, 189, 212, 36)];
            [_menuButton setTitleColor:color forState:UIControlStateNormal];
            [self.menuButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
            [self.menuButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [_menuButton setBackgroundColor:[UIColor clearColor]];
            self.menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
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
            //    [[_menuButton imageView] setContentMode:UIViewContentModeScaleAspectFill];
            [_menuButton setBackgroundImage:[UIImage imageNamed:@"dropbox.png"] forState:UIControlStateNormal];
            [_menuButton addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_menuButton];
            
            //    _downArrow1 = [UIButton buttonWithType:UIButtonTypeCustom];
            //    [_downArrow1  setFrame:CGRectMake(277, 239, 23, 22)];
            //    [_downArrow1 setImage:[UIImage imageNamed:@"down_side_arrrow_button.png"] forState:UIControlStateNormal];
            //    [self.view addSubview:_downArrow1];
            
            //    _downArrow1 = [UIButton buttonWithType:UIButtonTypeCustom];
            //    [_downArrow1  setFrame:CGRectMake(277, 278, 23, 22)];
            //    [_downArrow1 setImage:[UIImage imageNamed:@"down_side_arrrow_button.png"] forState:UIControlStateNormal];
            //    [self.view addSubview:_downArrow1];
            
            _quickNote = [[UITextView alloc]initWithFrame:CGRectMake(63, 230, 200, 60)];
            _quickNote.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.0];
            _quickNote.textColor = color;
            _quickNote.backgroundColor = [UIColor clearColor];
            _quickNote.autocorrectionType = UITextAutocorrectionTypeNo;
            _quickNote.keyboardType = UIKeyboardTypeDefault;
            _quickNote.returnKeyType = UIReturnKeyNext;
            _quickNote.delegate = self;
            _quickNote.text = @"Comments";
            _quickNote.textColor = color;
            [self.view addSubview:_quickNote];
            
            _rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(84, 440, 152, 21)];
            UIColor * color3 = [UIColor colorWithRed:84/255.0f green:84/255.0f blue:84/255.0f alpha:1.0f];
            _rateLabel.textColor = color3;
            _rateLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0];
            _rateLabel.text = @"Rate the dish";
            _rateLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:_rateLabel];
            
            //    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(0, 430, self.view.bounds.size.width, 20) fullStar:[UIImage imageNamed:@"StarFull.png"] emptyStar:[UIImage imageNamed:@"StarEmpty.png"]];
            //    rateView.padding = 20;
            //    rateView.alignment = RateViewAlignmentCenter;
            //    rateView.editable = YES;
            //    rateView.delegate = self;
            //    [self.view addSubview:rateView];
            
            _voteImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 310, 320, 75)];
            [_voteImageview setBackgroundColor:color];
            [self.view addSubview:_voteImageview];
            
            _voteLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 120, 15)];
            _voteLabel.text = @"GET IT AGAIN?";
            _voteLabel.font = [UIFont fontWithName:@"Montserrat-regular" size:10.0];
            _voteLabel.textAlignment = NSTextAlignmentCenter;
            [_voteImageview addSubview:_voteLabel];
            
            //    _yayImageview = [[UIImageView alloc]initWithFrame:CGRectMake(70, 25, 75, 70)];
            //    _yayImageview.image = [UIImage imageNamed:@"orangecircle.png"];
            //    [_voteImageview addSubview:_yayImageview];
            //
            //    _yayLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, 40, 20)];
            //    _yayLabel.text = @"YAY";
            //    _yayLabel.textAlignment = NSTextAlignmentCenter;
            //    _yayLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:20];
            //    [_yayImageview addSubview:_yayLabel];
            
            UIImageView *icon1 = [[UIImageView alloc]initWithFrame:CGRectMake(32, 152, 20, 27)];
            icon1.image = [UIImage imageNamed:@"icon1.png"];
            [self.view addSubview:icon1];
            
            UIImageView *icon2 = [[UIImageView alloc]initWithFrame:CGRectMake(27, 193, 25, 27)];
            icon2.image = [UIImage imageNamed:@"icon2.png"];
            [self.view addSubview:icon2];
            
            UIImageView *icon3 = [[UIImageView alloc]initWithFrame:CGRectMake(27, 233, 25, 27)];
            icon3.image = [UIImage imageNamed:@"icon3.png"];
            [self.view addSubview:icon3];
            
            _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yayButton  setFrame:CGRectMake(70, 325, 65, 60)];
            [_yayButton setBackgroundColor:[UIColor clearColor]];
            [_yayButton setBackgroundImage:[[UIImage imageNamed:@"orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_yayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_yayButton setTitle:@"  YAY" forState:UIControlStateNormal];
            [self.view addSubview:_yayButton];
            
            //    _nayImageview = [[UIImageView alloc]initWithFrame:CGRectMake(180, 25, 75, 70)];
            //    _nayImageview.image = [UIImage imageNamed:@"orangecircle.png"];
            //    [_voteImageview addSubview:_nayImageview];
            
            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(174, 325, 65, 60)];
            [_nayButton setBackgroundColor:[UIColor clearColor]];
            [_nayButton setBackgroundImage:[[UIImage imageNamed:@"orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_nayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_nayButton setTitle:@"  NAY" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
            
            _postBtn= [UIButton buttonWithType:UIButtonTypeCustom];
            [_postBtn  setFrame:CGRectMake(72, 395, 175, 30)];
            [_postBtn setBackgroundColor:[UIColor clearColor]];
            [_postBtn setBackgroundImage:[[UIImage imageNamed:@"sharebutton-2.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_postBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.postBtn addTarget:self action:@selector(postBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.postBtn.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:20]];
            self.postBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_postBtn setTitle:@"SHARE" forState:UIControlStateNormal];
            [self.view addSubview:_postBtn];
            
            [self getUserImage];
            
            self.changePic = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.changePic  setFrame:CGRectMake(0, 0, 320, 120)];
            [self.changePic setBackgroundColor:[UIColor clearColor]];
            [self.changePic addTarget:self action:@selector(changePicture) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.changePic];
        }
    } else {
        /*Do iPad stuff here.*/
    }

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
            [_yayButton  setFrame:CGRectMake(70, 390, 75, 70)];
            [_yayButton setBackgroundColor:[UIColor clearColor]];
            [_yayButton setBackgroundImage:[[UIImage imageNamed:@"filled_orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_yayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_yayButton setTitle:@"  YAY" forState:UIControlStateNormal];
            [self.view addSubview:_yayButton];
            
            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(174, 390, 75, 70)];
            [_nayButton setBackgroundColor:[UIColor clearColor]];
            [_nayButton setBackgroundImage:[[UIImage imageNamed:@"orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_nayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_nayButton setTitle:@"  NAY" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
        } else {
            /*Do iPhone Classic stuff here.*/
            _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yayButton  setFrame:CGRectMake(70, 325, 65, 60)];
            [_yayButton setBackgroundColor:[UIColor clearColor]];
            [_yayButton setBackgroundImage:[[UIImage imageNamed:@"filled_orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_yayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_yayButton setTitle:@"  YAY" forState:UIControlStateNormal];
            [self.view addSubview:_yayButton];
            
            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(174, 325, 65, 60)];
            [_nayButton setBackgroundColor:[UIColor clearColor]];
            [_nayButton setBackgroundImage:[[UIImage imageNamed:@"orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_nayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_nayButton setTitle:@"  NAY" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
        }
    } else {
        /*Do iPad stuff here.*/
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
            _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yayButton  setFrame:CGRectMake(70, 390, 75, 70)];
            [_yayButton setBackgroundColor:[UIColor clearColor]];
            [_yayButton setBackgroundImage:[[UIImage imageNamed:@"orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_yayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_yayButton setTitle:@"  YAY" forState:UIControlStateNormal];
            [self.view addSubview:_yayButton];
            
            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(174, 390, 75, 70)];
            [_nayButton setBackgroundColor:[UIColor clearColor]];
            [_nayButton setBackgroundImage:[[UIImage imageNamed:@"filled_orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_nayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_nayButton setTitle:@"  NAY" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
        } else {
            /*Do iPhone Classic stuff here.*/
            _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_yayButton  setFrame:CGRectMake(70, 325, 65, 60)];
            [_yayButton setBackgroundColor:[UIColor clearColor]];
            [_yayButton setBackgroundImage:[[UIImage imageNamed:@"orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_yayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_yayButton setTitle:@"  YAY" forState:UIControlStateNormal];
            [self.view addSubview:_yayButton];
            
            _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_nayButton  setFrame:CGRectMake(174, 325, 65, 60)];
            [_nayButton setBackgroundColor:[UIColor clearColor]];
            [_nayButton setBackgroundImage:[[UIImage imageNamed:@"filled_orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [_nayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
            self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            [_nayButton setTitle:@"  NAY" forState:UIControlStateNormal];
            [self.view addSubview:_nayButton];
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
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    NSLog(@"hunt name = %@",_huntName);
    NSLog(@"location name = %@",_venueSelected);
    NSLog(@"location id = %@",_venueID);
    
    if (_uploadImage) {

    }else{
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Upload photo", @"title")
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                              otherButtonTitles:@"Take a picture",@"Select from gallery",nil];
        alert.tag=0;
        [alert show];
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
                self.cameraView.image = image;
                [self.cameraView.layer setCornerRadius:self.cameraView.frame.size.width/2];
                [self.cameraView setClipsToBounds:YES];
                [self.view addSubview:_cameraView];
                NSLog(@"profile image");
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
                    NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
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
                            self.cameraView.image = image;
                            [self.cameraView.layer setCornerRadius:self.cameraView.frame.size.width/2];
                            [self.cameraView setClipsToBounds:YES];
                            [self.view addSubview:_cameraView];
                            NSLog(@"profile image");
                            
                         }
                     }];
                }
                
            }
        }];
        
    }
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
//    self.dishImage.image = image;
    
//        UIView* captureView = self.view;
//        
//        /* Capture the screen shoot at native resolution */
//        UIGraphicsBeginImageContextWithOptions(captureView.bounds.size, captureView.opaque, 0.0);
//        [captureView.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage * screenshot = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
//        /* Render the screen shot at custom resolution */
//        CGRect cropRect = CGRectMake(0 ,0 ,1435 ,1435);
//        UIGraphicsBeginImageContextWithOptions(cropRect.size, captureView.opaque, 1.0f);
//        [screenshot drawInRect:cropRect];
//        UIImage * customScreenShot = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
////        CGFloat scale = [self.view.window.screen scale];
//        CGSize size = CGSizeMake(1435.0 ,1435.0);
////        UIGraphicsBeginImageContextWithOptions(size, YES, scale);
////        CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
////        [image drawInRect:CGRectMake(0., 0., size.width, size.height)];
////        UIImage* thumb = UIGraphicsGetImageFromCurrentImageContext();
////        UIGraphicsEndImageContext();
////        self.uploadImage = thumb;
//        
//        UIGraphicsBeginImageContext( size );
//        [image drawInRect:CGRectMake(0,0,size.width,size.height)];
//        UIImage* thumb = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        self.uploadImage = thumb;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        UIImage *initialImage = image;
//        NSData *data = UIImagePNGRepresentation(initialImage);
//        
//        initialImage = [UIImage imageWithCGImage:[UIImage imageWithData:data].CGImage
//                                           scale:initialImage.scale
//                                     orientation:initialImage.imageOrientation];
//        self.uploadImage = initialImage;
        
//        int kMaxResolution = 1435; // Or whatever
//        
//        CGImageRef imgRef = image.CGImage;
//        
//        CGFloat width = CGImageGetWidth(imgRef);
//        CGFloat height = CGImageGetHeight(imgRef);
//        
//        
//        CGAffineTransform transform = CGAffineTransformIdentity;
//        CGRect bounds = CGRectMake(0, 0, width, height);
//        if (width > kMaxResolution || height > kMaxResolution) {
//            CGFloat ratio = width/height;
//            if (ratio > 1) {
//                bounds.size.width = kMaxResolution;
//                bounds.size.height = roundf(bounds.size.width / ratio);
//            }
//            else {
//                bounds.size.height = kMaxResolution;
//                bounds.size.width = roundf(bounds.size.height * ratio);
//            }
//        }
//        
//        CGFloat scaleRatio = bounds.size.width / width;
//        CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
//        CGFloat boundHeight;
//        UIImageOrientation orient = image.imageOrientation;
//        switch(orient) {
//                
//            case UIImageOrientationUp: //EXIF = 1
//                transform = CGAffineTransformIdentity;
//                break;
//                
//            case UIImageOrientationUpMirrored: //EXIF = 2
//                transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
//                transform = CGAffineTransformScale(transform, -1.0, 1.0);
//                break;
//                
//            case UIImageOrientationDown: //EXIF = 3
//                transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
//                transform = CGAffineTransformRotate(transform, M_PI);
//                break;
//                
//            case UIImageOrientationDownMirrored: //EXIF = 4
//                transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
//                transform = CGAffineTransformScale(transform, 1.0, -1.0);
//                break;
//                
//            case UIImageOrientationLeftMirrored: //EXIF = 5
//                boundHeight = bounds.size.height;
//                bounds.size.height = bounds.size.width;
//                bounds.size.width = boundHeight;
//                transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
//                transform = CGAffineTransformScale(transform, -1.0, 1.0);
//                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
//                break;
//                
//            case UIImageOrientationLeft: //EXIF = 6
//                boundHeight = bounds.size.height;
//                bounds.size.height = bounds.size.width;
//                bounds.size.width = boundHeight;
//                transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
//                transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
//                break;
//                
//            case UIImageOrientationRightMirrored: //EXIF = 7
//                boundHeight = bounds.size.height;
//                bounds.size.height = bounds.size.width;
//                bounds.size.width = boundHeight;
//                transform = CGAffineTransformMakeScale(-1.0, 1.0);
//                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
//                break;
//                
//            case UIImageOrientationRight: //EXIF = 8
//                boundHeight = bounds.size.height;
//                bounds.size.height = bounds.size.width;
//                bounds.size.width = boundHeight;
//                transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
//                transform = CGAffineTransformRotate(transform, M_PI / 2.0);
//                break;
//                
//            default:
//                [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
//                
//        }
//        
//        UIGraphicsBeginImageContext(bounds.size);
//        
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        
//        if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
//            CGContextScaleCTM(context, -scaleRatio, scaleRatio);
//            CGContextTranslateCTM(context, -height, 0);
//        }
//        else {
//            CGContextScaleCTM(context, scaleRatio, -scaleRatio);
//            CGContextTranslateCTM(context, 0, -height);
//        }
//        
//        CGContextConcatCTM(context, transform);
//        
//        CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
//        UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        
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

        self.dishImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
        self.dishImage.image = newImage;
//        [self.dishImage.layer setCornerRadius:self.dishImage.frame.size.width/2];
        [self.dishImage setContentMode:UIViewContentModeCenter];
        [self.dishImage setClipsToBounds:YES];
        [self.view addSubview:self.dishImage];
        
        self.changePic = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.changePic  setFrame:CGRectMake(0, 0, 320, 180)];
        [self.changePic setBackgroundColor:[UIColor clearColor]];
        [self.changePic addTarget:self action:@selector(changePicture) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.changePic];
        
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
    NSLog(@"change pic pressed");
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
    
    [self.postBtn setEnabled:NO];
    
    if (_venueSelected) {
            if (_menuSelected) {
                if (_quickNote) {
                    if (_postVote) {
//                        NSLog(@"comment = %@ \n venue selected = %@ \n venue id = %@ \n venue address = %@ \n venue cc = %@ \n venue city = %@ \n venue country = %@ \n venue postal code = %@ \n venue state = %@ \n rating = %@ \n user profile pic = %@",_quickNote.text,_venueSelected,_venueID,_venueAddress,_venueCc,_venueCity,_venueCountry,_venuePostalCode,_venueState,_postVote,_userPicUrl);
                        [self savePostData];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (void)savePostData
{
    if (_uploadImage) {
        YookaBackend *yookaObject = [[YookaBackend alloc]init];
        NSString *textstring = _quickNote.text;
        if ([textstring length] >= 30) textstring = [textstring substringToIndex:30];
        yookaObject.caption = textstring;
        yookaObject.venueName = _venueSelected;
        yookaObject.venueId = _venueID;
        if (_uploadImage) {
            yookaObject.dishImage = _uploadImage;
        }
//        if (_userImage) {
//            yookaObject.userImage = _userImage;
//        }
        yookaObject.postDate = [NSDate date];
        yookaObject.userEmail = _userEmail;
        if (_huntName) {
            yookaObject.HuntName = _huntName;
        }else{
            yookaObject.HuntName = @"";
        }
        if (_menuSelected) {
            yookaObject.dishName = _menuSelected;
        }
        yookaObject.postVote = _postVote;
        yookaObject.venueAddress = _venueAddress;
        yookaObject.venueCc = _venueCc;
        yookaObject.venueCity = _venueCity;
        yookaObject.venueCountry = _venueCountry;
        yookaObject.venueState = _venueState;
        yookaObject.venuePostalCode = _venuePostalCode;
        [yookaObject.meta setGloballyReadable:YES];
        [yookaObject.meta setGloballyWritable:YES];
        
        //Kinvey use code: add a new update to the updates collection
        [self.updateStore saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
//                NSLog(@"saved successfully");
                
                if (self.navigationController.viewControllers.count>1 && [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2] isKindOfClass:[YookaHuntVenuesViewController class]]) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else  if (self.navigationController.viewControllers.count>1 && [[self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2]isKindOfClass:[YookaMenu2ViewController class]]) {
//                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    YookaAppDelegate* appDelegate = (id)[UIApplication sharedApplication].delegate;
                    appDelegate.yookaTabBar.selectedIndex = 1;
                }
                
                [self.postBtn setEnabled:YES];
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
                
                _yayButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_yayButton  setFrame:CGRectMake(70, 390, 75, 70)];
                [_yayButton setBackgroundColor:[UIColor clearColor]];
                [_yayButton setBackgroundImage:[[UIImage imageNamed:@"orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
                [_yayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.yayButton addTarget:self action:@selector(yayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.yayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                self.yayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [_yayButton setTitle:@"  YAY" forState:UIControlStateNormal];
                [self.view addSubview:_yayButton];
                
                //    _nayImageview = [[UIImageView alloc]initWithFrame:CGRectMake(180, 25, 75, 70)];
                //    _nayImageview.image = [UIImage imageNamed:@"orangecircle.png"];
                //    [_voteImageview addSubview:_nayImageview];
                
                _nayButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_nayButton  setFrame:CGRectMake(174, 390, 75, 70)];
                [_nayButton setBackgroundColor:[UIColor clearColor]];
                [_nayButton setBackgroundImage:[[UIImage imageNamed:@"orangecircle.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
                [_nayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [self.nayButton addTarget:self action:@selector(nayButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
                [self.nayButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
                self.nayButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [_nayButton setTitle:@"  NAY" forState:UIControlStateNormal];
                [self.view addSubview:_nayButton];
                
                
            } else {
                
                [self.postBtn setEnabled:YES];
                BOOL wasNetworkError = [[errorOrNil domain] isEqual:KCSNetworkErrorDomain];
                NSString* title = wasNetworkError ? NSLocalizedString(@"There was a network error.", @"network error title"): NSLocalizedString(@"An error occurred.", @"Generic error message");
                NSString* message = wasNetworkError ? NSLocalizedString(@"Please wait a few minutes and try again.", @"try again error message") : [errorOrNil localizedDescription];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                message:message                                                           delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                      otherButtonTitles:nil];
                [alert show];

            }
        } withProgressBlock:nil];
    }else{
        UIAlertView* alert3 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Image Selected", @"title")
                                                         message:NSLocalizedString(@"Please upload a dish image!", @"message body")
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                               otherButtonTitles:nil];
        [alert3 show];
    }
}

- (void)showLocation:(id)sender
{
    YookaLocationViewController *media = [[YookaLocationViewController alloc]init];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.backBarButtonItem = backBtn;
    [self.navigationItem setBackBarButtonItem: backBtn];
    media.delegate = self;
    [self.navigationController pushViewController:media animated:NO];
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
        [self.navigationController pushViewController:media animated:NO];
}

-(void)sendLocationDataToA:(NSArray *)locationSelected
{
    // data will come here inside of ViewControllerA
    if (locationSelected.count>0) {
        _venueSelected = [locationSelected objectAtIndex:1];
        _locationLabel.text = _venueSelected;
        _venueID = [locationSelected objectAtIndex:0];
        _venueAddress = [locationSelected objectAtIndex:2];
        _venueCc = [locationSelected objectAtIndex:3];
        _venueCity = [locationSelected objectAtIndex:4];
        _venueState = [locationSelected objectAtIndex:5];
        _venueCountry = [locationSelected objectAtIndex:6];
        _venuePostalCode = [locationSelected objectAtIndex:7];
    }
}

- (void)sendMenuDataToA:(NSArray *)menuData
{
    if (menuData.count>2) {
        _menuSelected = menuData[2];
    }
    if (menuData.count>0) {
        _venueID = menuData[0];
        _venueSelected = menuData[1];
        _locationLabel.text = _venueSelected;
        _menuLabel.text = _menuSelected;
    }

}

-(void)dismissKeyboard {
    
    [_quickNote resignFirstResponder];

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    //move the main view, so that the keyboard does not hide it.
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    textView.textColor = color;
    if ([textView.text isEqualToString:@"Comments"]) {
        textView.text = @"";
        if (_huntName) {
            textView.font = [UIFont fontWithName:@"Montserrat-Regular" size:14.0];
            textView.text = [NSString stringWithFormat:@"%@.",_huntName];
        }
        textView.textColor = color; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    textView.textColor = color;
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Comments";
        textView.font = [UIFont fontWithName:@"Montserrat-Regular" size:14.0];
        textView.textColor = color; //optional
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
    NSLog(@"rate = %@",_rateValue);
}

@end
