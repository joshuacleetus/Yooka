//
//  YookaSignupViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 11/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaSignupViewController.h"
#import "YookaBackend.h"
#import "YookaNewsFeedViewController.h"
#import "YookaAppDelegate.h"
#import "Flurry.h"
#import "TermsOfServiceViewController.h"

#define kOFFSET_FOR_KEYBOARD 0.0
#define kOFFSET_FOR_KEYBOARD_1 0.0
#define kOFFSET_FOR_KEYBOARD_2 0.0
#define kOFFSET_FOR_KEYBOARD_3 0.0

#define kOFFSET_FOR_KEYBOARD_4 65.0
#define kOFFSET_FOR_KEYBOARD_5 135.0
#define kOFFSET_FOR_KEYBOARD_6 255.0
#define kOFFSET_FOR_KEYBOARD_7 415.0

#define kMinPasswordLength 4

@interface YookaSignupViewController ()

@end

@implementation YookaSignupViewController

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
    
    self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{
                                                                 KCSStoreKeyCollectionName : @"userPicture",
                                                                 KCSStoreKeyCollectionTemplateClass : [YookaBackend class]}];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
	// Do any additional setup after loading the view.
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (isiPhone5) {
            
            /*Do iPhone 5 stuff here.*/
            
            NSArray *fontFamilies = [UIFont familyNames];
            
            for (int i = 0; i < [fontFamilies count]; i++)
            {
                NSString *fontFamily = [fontFamilies objectAtIndex:i];
                NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
                NSLog (@"%@: %@", fontFamily, fontNames);
            }
            
            UIImageView *text_field_holder = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 568-60)];
            [text_field_holder setImage:[UIImage imageNamed:@"text_field_holder2.png"]];
            [self.view addSubview:text_field_holder];
            
            UIImageView *fb_image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, 320, 50)];
            [fb_image setImage:[UIImage imageNamed:@"facebookbutton2.png"]];
            [self.view addSubview:fb_image];
            
            self.fbBtn = [[FUIButton alloc]initWithFrame:CGRectMake(0, 8, 320, 50)];
            self.fbBtn.buttonColor = [UIColor clearColor];
            [self.fbBtn addTarget:self action:@selector(fbBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.fbBtn];
            
            _pickImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_pickImageBtn setFrame:CGRectMake(15, 75, 80, 80)];
            [_pickImageBtn setTitle:nil forState:UIControlStateNormal];
            [_pickImageBtn setBackgroundColor:[UIColor clearColor]];
            [_pickImageBtn addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_pickImageBtn];
            
            _firstName = [[UITextField alloc] initWithFrame:CGRectMake(106, 73, 99, 32)];
            _firstName.borderStyle = UITextBorderStyleNone;
            _firstName.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.5f];
            _firstName.textColor = [UIColor lightGrayColor];
            _firstName.backgroundColor = [UIColor whiteColor];
            
            if ([_firstName respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                UIColor *color2 = [UIColor lightGrayColor];
                _firstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: color2}];
            } else {
                // TODO: Add fall-back code to set placeholder color.
                _firstName.backgroundColor = [UIColor clearColor];
            }
            //            _username.placeholder = @"Enter Username";
            //            _username.backgroundColor = [UIColor clearColor];
            _firstName.autocorrectionType = UITextAutocorrectionTypeNo;
            _firstName.keyboardType = UIKeyboardTypeDefault;
            _firstName.returnKeyType = UIReturnKeyNext;
            _firstName.clearButtonMode = UITextFieldViewModeWhileEditing;
            _firstName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_firstName addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [_firstName addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [self.view addSubview:_firstName];
            
            _lastName = [[UITextField alloc] initWithFrame:CGRectMake( 222, 74, 99, 32)];
            _lastName.borderStyle = UITextBorderStyleNone;
            _lastName.font = [UIFont fontWithName:@"OpenSans" size:17.5f];
            _lastName.textColor = [UIColor lightGrayColor];
            _lastName.backgroundColor = [UIColor whiteColor];
            UIColor *color2 = [UIColor lightGrayColor];
            if ([_lastName respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                _lastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color2}];
            } else {
                // TODO: Add fall-back code to set placeholder color.
                _lastName.backgroundColor = [UIColor clearColor];
            }
            //            _username.placeholder = @"Enter Username";
            //            _username.backgroundColor = [UIColor clearColor];
            _lastName.autocorrectionType = UITextAutocorrectionTypeNo;
            _lastName.keyboardType = UIKeyboardTypeDefault;
            _lastName.returnKeyType = UIReturnKeyNext;
            _lastName.clearButtonMode = UITextFieldViewModeWhileEditing;
            _lastName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_lastName addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [_lastName addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [self.view addSubview:_lastName];
            
            _email = [[UITextField alloc] initWithFrame:CGRectMake(106, 122, 210, 30)];
            _email.borderStyle = UITextBorderStyleNone;
            _email.font = [UIFont fontWithName:@"OpenSans" size:17.5f];
            _email.textColor = [UIColor lightGrayColor];
            _email.textAlignment = NSTextAlignmentLeft;
            _email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color2}];
            _email.backgroundColor = [UIColor whiteColor];
            _email.autocorrectionType = UITextAutocorrectionTypeNo;
            _email.keyboardType = UIKeyboardTypeEmailAddress;
            _email.returnKeyType = UIReturnKeyNext;
            _email.clearButtonMode = UITextFieldViewModeWhileEditing;
            _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_email addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [_email addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [self.view addSubview:_email];
            
            _password = [[UITextField alloc] initWithFrame:CGRectMake(15, 170, 300, 30)];
            _password.borderStyle = UITextBorderStyleNone;
            _password.font = [UIFont fontWithName:@"OpenSans" size:17.5f];
            _password.textColor = [UIColor lightGrayColor];
            _password.textAlignment = NSTextAlignmentLeft;
            _password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color2}];
            _password.backgroundColor = [UIColor whiteColor];
            _password.autocorrectionType = UITextAutocorrectionTypeNo;
            _password.keyboardType = UIKeyboardTypeDefault;
            _password.returnKeyType = UIReturnKeyNext;
            _password.clearButtonMode = UITextFieldViewModeWhileEditing;
            _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _password.tag = 1;
            _password.secureTextEntry = YES;
            [_password addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [_password addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [self.view addSubview:_password];
            
            _password2 = [[UITextField alloc] initWithFrame:CGRectMake(15, 215, 300, 30)];
            _password2.borderStyle = UITextBorderStyleNone;
            _password2.font = [UIFont fontWithName:@"OpenSans" size:17.5f];
            _password2.textColor = [UIColor lightGrayColor];
            _password2.textAlignment = NSTextAlignmentLeft;
            _password2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color2}];
            _password2.backgroundColor = [UIColor whiteColor];
            _password2.autocorrectionType = UITextAutocorrectionTypeNo;
            _password2.keyboardType = UIKeyboardTypeDefault;
            _password2.returnKeyType = UIReturnKeyDone;
            _password2.clearButtonMode = UITextFieldViewModeWhileEditing;
            _password2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _password2.tag = 1;
            _password2.secureTextEntry = YES;
            [_password2 addTarget:self
                           action:@selector(signUpBtnTouched:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
            [_password2 addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [self.view addSubview:_password2];
            
            UIImageView *bottom_white_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 290, 320, 568-290)];
            [bottom_white_bg setBackgroundColor:[UIColor whiteColor]];
            [self.view addSubview:bottom_white_bg];
            
            UILabel *termsLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 260, 200, 30)];
            termsLbl.textColor = [self colorWithHexString:@"6e6e6e"];
            [termsLbl setFont:[UIFont fontWithName:@"OpenSans-Italic" size:12]];
            NSString *string1 = @"Our Privacy Policy &";
            NSMutableAttributedString *yourString = [[NSMutableAttributedString alloc] initWithString:string1];
            [yourString addAttribute:NSUnderlineStyleAttributeName
                               value:[NSNumber numberWithInt:1]
                               range:(NSRange){4,[yourString length]-6}];
            termsLbl.attributedText = [yourString copy];
            termsLbl.textAlignment = NSTextAlignmentCenter;
            termsLbl.adjustsFontSizeToFitWidth = NO;
            [termsLbl setBackgroundColor:[UIColor whiteColor]];
            [self.view addSubview:termsLbl];
            
            UILabel *termsLbl2 = [[UILabel alloc]initWithFrame:CGRectMake(93, 260, 250, 30)];
            termsLbl2.textColor = [self colorWithHexString:@"6e6e6e"];
            [termsLbl2 setFont:[UIFont fontWithName:@"OpenSans-Italic" size:12]];
            NSMutableAttributedString *yourString2 = [[NSMutableAttributedString alloc] initWithString:@"Terms of service"];
            [yourString2 addAttribute:NSUnderlineStyleAttributeName
                               value:[NSNumber numberWithInt:1]
                               range:(NSRange){0,[yourString2 length]}];
            termsLbl2.attributedText = [yourString2 copy];
            termsLbl2.textAlignment = NSTextAlignmentCenter;
            termsLbl2.adjustsFontSizeToFitWidth = NO;
            [termsLbl2 setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:termsLbl2];
            
            self.termsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_termsBtn setFrame:CGRectMake( 50, 260, 250, 30)];
            [_termsBtn setTitle:nil forState:UIControlStateNormal];
            [_termsBtn setBackgroundColor:[UIColor clearColor]];
            [_termsBtn addTarget:self action:@selector(termsofservice:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_termsBtn];

            
        } else {
            
            /*Do iPhone Classic stuff here.*/
            
            self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 5, 120, 120)];
            self.logoImage.image = [UIImage imageNamed:@"Yookatransparent.png"];
            [self.view addSubview:self.logoImage];
            
            self.signupPanelTop = [[UIImageView alloc]initWithFrame:CGRectMake(15, 134, 290, 69)];
            self.signupPanelTop.image = [UIImage imageNamed:@"signup_panel_top.png"];
            [self.view addSubview:self.signupPanelTop];
            
            self.signupPanelBottom = [[UIImageView alloc]initWithFrame:CGRectMake(15, 221, 290, 115)];
            self.signupPanelBottom.image = [UIImage imageNamed:@"signup_panel_bottom.png"];
            [self.view addSubview:self.signupPanelBottom];
            
            self.camera = [[UIImageView alloc]initWithFrame:CGRectMake(25, 137, 63, 63)];
            self.camera.image = [UIImage imageNamed:@"take_picture.png"];
            [self.view addSubview:self.camera];
            
            _pickImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_pickImageBtn setFrame:CGRectMake(25, 137, 63, 63)];
            [_pickImageBtn setTitle:nil forState:UIControlStateNormal];
            [_pickImageBtn setBackgroundColor:[UIColor clearColor]];
            [_pickImageBtn addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_pickImageBtn];
            
            _firstName = [[UITextField alloc] initWithFrame:CGRectMake(114, 139, 177, 27)];
            _firstName.borderStyle = UITextBorderStyleNone;
            _firstName.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
            _firstName.textColor = [UIColor blackColor];
            _firstName.backgroundColor = [UIColor clearColor];
            
            if ([_firstName respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                UIColor *color2 = [UIColor lightGrayColor];
                _firstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: color2}];
            } else {
                // TODO: Add fall-back code to set placeholder color.
                _firstName.backgroundColor = [UIColor clearColor];
            }
            //            _username.placeholder = @"Enter Username";
            //            _username.backgroundColor = [UIColor clearColor];
            _firstName.autocorrectionType = UITextAutocorrectionTypeNo;
            _firstName.keyboardType = UIKeyboardTypeDefault;
            _firstName.returnKeyType = UIReturnKeyNext;
            _firstName.clearButtonMode = UITextFieldViewModeWhileEditing;
            _firstName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_firstName addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [_firstName addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [self.view addSubview:_firstName];
            
            _lastName = [[UITextField alloc] initWithFrame:CGRectMake(114, 171, 177, 27)];
            _lastName.borderStyle = UITextBorderStyleNone;
            _lastName.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
            _lastName.textColor = [UIColor blackColor];
            _lastName.backgroundColor = [UIColor clearColor];
            UIColor *color2 = [UIColor lightGrayColor];
            if ([_lastName respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                _lastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color2}];
            } else {
                // TODO: Add fall-back code to set placeholder color.
                _lastName.backgroundColor = [UIColor clearColor];
            }
            //            _username.placeholder = @"Enter Username";
            //            _username.backgroundColor = [UIColor clearColor];
            _lastName.autocorrectionType = UITextAutocorrectionTypeNo;
            _lastName.keyboardType = UIKeyboardTypeDefault;
            _lastName.returnKeyType = UIReturnKeyNext;
            _lastName.clearButtonMode = UITextFieldViewModeWhileEditing;
            _lastName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_lastName addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [_lastName addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [self.view addSubview:_lastName];
            
            _email = [[UITextField alloc] initWithFrame:CGRectMake(29, 226, 262, 32)];
            _email.borderStyle = UITextBorderStyleNone;
            _email.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
            _email.textColor = [UIColor blackColor];
            _email.textAlignment = NSTextAlignmentLeft;
            _email.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color2}];
            _email.backgroundColor = [UIColor clearColor];
            _email.autocorrectionType = UITextAutocorrectionTypeNo;
            _email.keyboardType = UIKeyboardTypeEmailAddress;
            _email.returnKeyType = UIReturnKeyNext;
            _email.clearButtonMode = UITextFieldViewModeWhileEditing;
            _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_email addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [_email addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [self.view addSubview:_email];
            
            _password = [[UITextField alloc] initWithFrame:CGRectMake(29, 262, 262, 32)];
            _password.borderStyle = UITextBorderStyleNone;
            _password.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
            _password.textColor = [UIColor blackColor];
            _password.textAlignment = NSTextAlignmentLeft;
            _password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color2}];
            _password.backgroundColor = [UIColor clearColor];
            _password.autocorrectionType = UITextAutocorrectionTypeNo;
            _password.keyboardType = UIKeyboardTypeDefault;
            _password.returnKeyType = UIReturnKeyNext;
            _password.clearButtonMode = UITextFieldViewModeWhileEditing;
            _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _password.tag = 1;
            _password.secureTextEntry = YES;
            [_password addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [_password addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [self.view addSubview:_password];
            
            _password2 = [[UITextField alloc] initWithFrame:CGRectMake(29, 300, 262, 32)];
            _password2.borderStyle = UITextBorderStyleNone;
            _password2.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
            _password2.textColor = [UIColor blackColor];
            _password2.textAlignment = NSTextAlignmentLeft;
            _password2.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Confirm Password" attributes:@{NSForegroundColorAttributeName: color2}];
            _password2.backgroundColor = [UIColor clearColor];
            _password2.autocorrectionType = UITextAutocorrectionTypeNo;
            _password2.keyboardType = UIKeyboardTypeDefault;
            _password2.returnKeyType = UIReturnKeyDone;
            _password2.clearButtonMode = UITextFieldViewModeWhileEditing;
            _password2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _password2.tag = 1;
            _password2.secureTextEntry = YES;
            [_password2 addTarget:self
                           action:@selector(signUpBtnTouched:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
            [_password2 addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [self.view addSubview:_password2];
            
            self.termsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_termsBtn setFrame:CGRectMake(100, 500, 120, 30)];
            [_termsBtn setTitle:nil forState:UIControlStateNormal];
            [_termsBtn setBackgroundColor:[UIColor clearColor]];
            [_termsBtn addTarget:self action:@selector(termsofservice:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_termsBtn];

        }
    } else {
        /*Do iPad stuff here.*/
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

- (void)resetPassword:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to reset password?"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    
    [alert show];
    
}

- (void)termsofservice:(id)sender {
    TermsOfServiceViewController *media = [[TermsOfServiceViewController alloc]init];
    [self presentViewController:media animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [self colorWithHexString:@"3ac0ec"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"Sign Up";
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [self colorWithHexString:@"6e6e6e"],
                                                                        NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:18.0f]
                                                                        };
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
         setTitleTextAttributes:
         @{NSForegroundColorAttributeName:[self colorWithHexString:@"3ac0ec"],
           NSFontAttributeName:[UIFont fontWithName:@"OpenSans" size:18.0f]
           }
         forState:UIControlStateNormal];
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if (IS_OS_5_OR_LATER) {
        self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: [self colorWithHexString:@"6e6e6e"],
                                                                        UITextAttributeFont: [UIFont fontWithName:@"OpenSans" size:18.0f]
                                                                        };
        
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
         @{UITextAttributeTextColor:[self colorWithHexString:@"3ac0ec"],
           UITextAttributeFont:[UIFont fontWithName:@"OpenSans" size:18.0f]
           }
                                                                                                forState:UIControlStateNormal];
    }
    
    UIBarButtonItem *signinButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Up" style:UIBarButtonItemStylePlain target:self action:@selector(signUpBtnTouched:)];
    self.navigationItem.rightBarButtonItem = signinButton;
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO
                                            withAnimation:UIStatusBarAnimationFade];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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


- (void)viewWillDisappear:(BOOL)animated
{
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

-(void)keyboardWillShow {
    
    // Animate the current view out of the way
    //        if (self.view.frame.origin.y >= 0)
    //        {
    //            [self setViewMovedUp:YES];
    //        }
    //        else if (self.view.frame.origin.y < 0)
    //        {
    //            [self setViewMovedUp:NO];
    //        }
    
    
}

-(void)keyboardWillHide {
    
    if (self.view.frame.origin.y >= 0)
    {
        //            [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
    [_firstName resignFirstResponder];
    [_lastName resignFirstResponder];
    [_email resignFirstResponder];
    [_password resignFirstResponder];
    [_password2 resignFirstResponder];
    
}

-(BOOL)textFieldDidBeginEditing:(UITextField *)sender
{
    
    if (sender == _firstName) {
        
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            //            [self setViewMovedUp:NO];
        }
    }
    if (sender == _lastName) {
        
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            //            [self setViewMovedUp:NO];
        }
    }
    if (sender == _email) {
        
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            //            [self setViewMovedUp:NO];
        }
    }
    if (sender == _password) {
        
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            //            [self setViewMovedUp:NO];
        }
    }
    if (sender == _password2)
    {
        //move the main view, so that the keyboard does not hide it.
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            //            [self setViewMovedUp:NO];
        }
    }
    return YES;
    
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
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                rect.origin.y -= kOFFSET_FOR_KEYBOARD;
                rect.size.height += kOFFSET_FOR_KEYBOARD;
            } else {
                rect.origin.y -= kOFFSET_FOR_KEYBOARD_1;
                rect.size.height += kOFFSET_FOR_KEYBOARD_1;
            }
        } else {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                rect.origin.y -= kOFFSET_FOR_KEYBOARD_5;
                rect.size.height += kOFFSET_FOR_KEYBOARD_5;
            } else {
                rect.origin.y -= kOFFSET_FOR_KEYBOARD_3;
                rect.size.height += kOFFSET_FOR_KEYBOARD_3;
            }
        }
        
    }
    else
    {
        // revert back to the normal state.
        if ([[UIScreen mainScreen] bounds].size.height == 568) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                rect.origin.y += kOFFSET_FOR_KEYBOARD;
                rect.size.height -= kOFFSET_FOR_KEYBOARD;
            } else {
                rect.origin.y += kOFFSET_FOR_KEYBOARD_1;
                rect.size.height -= kOFFSET_FOR_KEYBOARD_1;
            }
        } else {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                rect.origin.y += kOFFSET_FOR_KEYBOARD_5;
                rect.size.height -= kOFFSET_FOR_KEYBOARD_5;
            } else {
                rect.origin.y += kOFFSET_FOR_KEYBOARD_3;
                rect.size.height -= kOFFSET_FOR_KEYBOARD_3;
            }
        }
        
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _firstName) {
        
        [_lastName becomeFirstResponder];
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            //            [self setViewMovedUp:NO];
        }
        
    } else if (textField == _lastName) {
        
        [_email becomeFirstResponder];
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            //            [self setViewMovedUp:NO];
        }
        
    }else if (textField == _email) {
        
        [_password becomeFirstResponder];
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            //            [self setViewMovedUp:NO];
        }
        
        
    } else if (textField == _password) {
        
        [_password2 becomeFirstResponder];
        if (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
        }
        else if (self.view.frame.origin.y < 0)
        {
            //            [self setViewMovedUp:NO];
        }
    }
    
    return YES;
}

-(void)dismissKeyboard {
    [_firstName resignFirstResponder];
    [_lastName resignFirstResponder];
    [_email resignFirstResponder];
    [_password resignFirstResponder];
    [_password2 resignFirstResponder];
}

- (void)signUpBtnTouched:(id)sender
{
    if ([self.firstName.text length]) {
        [self  dismissKeyboard];
    }
    
    if ([_firstName.text  isEqual: @""] || [_lastName.text isEqualToString:@""] || [_email.text  isEqual: @""] || [_password.text  isEqual: @""]) {
        
        //there was an error with the create
        
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Create account failed")
                                                        message:@"Please don't keep the fields empty"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles: nil];
        [alert show];
        
    } else if (_password.text.length < kMinPasswordLength) {
        
        //there was an error with the create
        
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Create account failed")
                                                        message:@"Please don't keep the fields empty"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles: nil];
        [alert show];
        
    } else if ([_password.text isEqualToString:_password2.text]) {
            
            _userName = _email.text;
            NSString *lowercase = [_userName lowercaseString];
            _userEmail = lowercase;
            _userFullName = [NSString stringWithFormat:@"%@ %@",_firstName.text,_lastName.text];
//
//            NSLog(@"email = %@",lowercase);
        
        // Create a new user with the username 'kinvey' and the password '12345'
        [KCSUser userWithUsername:_userEmail password:_password.text fieldsAndValues:@{KCSUserAttributeEmail : _userEmail, KCSUserAttributeGivenname : _firstName.text, KCSUserAttributeSurname : _lastName.text} withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
                if (errorOrNil == nil) {
                    
                    if (self.profileImage) {
                        [self saveUserImage];
                    }else{
                        self.profileImage = [UIImage imageNamed:@"minion.jpg"];
                        [self saveUserImage];
                    }
                    
                    [Flurry setUserID: lowercase];

                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:lowercase forKey:@"user_email"];
                    [ud synchronize];
                    
                    //user is created
                    //was successful!
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Account Creation Successful", @"account success note title")
                                                                    message:NSLocalizedString(@"Yooka account created successfully. Woo....!", @"account success message body")
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                          otherButtonTitles:nil];
                    alert.tag=0;
                    [alert show];
                    
                } else {
                    
                    //there was an error with the update save
                    BOOL wasUserError = [[errorOrNil domain] isEqual: KCSUserErrorDomain];
                    NSString* title = wasUserError ? [NSString stringWithFormat:NSLocalizedString(@"Could not create new user with username %@", @"create username error title"), _userName]: NSLocalizedString(@"An error occurred.", @"Generic error message");
                    NSString* message = wasUserError ? NSLocalizedString(@"Please choose a different username.", @"create username error message") : [errorOrNil localizedDescription];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                                    message:message                                                           delegate:nil
                                                          cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }];
            
            
        }else{
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Create account failed", @"Create account failed")
                                                            message:@"The passwords are not matching"
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles: nil];
            [alert show];
        }

}

- (IBAction)takePicture:(id)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Profile photo", @"title")
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                          otherButtonTitles:@"Take a picture",@"Select from gallery",nil];
    alert.tag=1;
    [alert show];
    
}


#pragma mark - pictures

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.profileImage = nil;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
    self.profileImage = image;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGFloat scale = [self.view.window.screen scale];
        CGSize size = CGSizeMake(200.0, 200.0);
        UIGraphicsBeginImageContextWithOptions(size, YES, scale);
        CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationHigh);
        [image drawInRect:CGRectMake(0., 0., size.width, size.height)];
        UIImage* thumb = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _profileImage = thumb;
        
        self.camera = [[UIImageView alloc] initWithFrame:CGRectMake(10, 75, 80, 80)];
        self.camera.image = thumb;
        [self.camera.layer setCornerRadius:self.camera.frame.size.width/2];
        [self.camera setClipsToBounds:YES];
        [self.view addSubview:self.camera];
        
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag==0) {
        
        if (buttonIndex == 0){
            //cancel clicked ...do your action
            
            YookaAppDelegate* appDelegate = (id)[UIApplication sharedApplication].delegate;
            [appDelegate userLoggedIn];
            
        }
        
    } else {
        
        if (buttonIndex == 0) {
            
        } else if (buttonIndex == 1) {
            
            UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
            
        }else if (buttonIndex == 2) {
            
            UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

            [self presentViewController:imagePicker animated:YES completion:^{
                
            }];
            
        }else{
            
        }
        
    }
    
}

- (void)saveUserImage
{
    
//        NSLog(@"profile image");
        YookaBackend *yookaObject = [[YookaBackend alloc]init];
        yookaObject.kinveyId = _userEmail;
        if (_profileImage) {
            yookaObject.userImage = _profileImage;
        }else{
            yookaObject.userImage = [UIImage imageNamed:@"minion.jpg"];
        }
        yookaObject.userFullName = _userFullName;
        yookaObject.userEmail = _userEmail;
        
        //Kinvey use code: add a new update to the updates collection
        [self.updateStore saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
//                NSLog(@"saved successfully");
                YookaAppDelegate* appDelegate = (id)[UIApplication sharedApplication].delegate;
                [appDelegate userLoggedIn];
            } else {
//                NSLog(@"save failed %@",errorOrNil);
            }
        } withProgressBlock:nil];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
