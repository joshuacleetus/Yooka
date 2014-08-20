//
//  YookaSigninViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 11/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaSigninViewController.h"
#import "YookaNewsFeedViewController.h"
#import "YookaAppDelegate.h"
#import "YookaForgotPasswordViewController.h"
#import "Flurry.h"

#define kOFFSET_FOR_KEYBOARD 0.0
#define kOFFSET_FOR_KEYBOARD_1 0.0
#define kOFFSET_FOR_KEYBOARD_2 145.0
#define kOFFSET_FOR_KEYBOARD_3 155.0

@interface YookaSigninViewController ()

@end

@implementation YookaSigninViewController

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (isiPhone5) {
            /*Do iPhone 5 stuff here.*/
            
            [self.view setBackgroundColor:[self colorWithHexString:@"eeeeee"]];
            
            UIImageView *text_field_holder = [[UIImageView alloc]initWithFrame:CGRectMake(0, 30, 320, 90)];
            [text_field_holder setImage:[UIImage imageNamed:@"text_field_holder.png"]];
            [self.view addSubview:text_field_holder];
            
            _username = [[UITextField alloc] initWithFrame:CGRectMake(15, 32, 305, 42)];
            _username.borderStyle = UITextBorderStyleNone;
            _username.font = [UIFont fontWithName:@"OpenSans" size:17.5f];
            _username.textColor = [UIColor lightGrayColor];
            _username.backgroundColor = [UIColor whiteColor];
            
            if ([_username respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                UIColor *color = [UIColor lightGrayColor];
                _username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
            } else {
                // TODO: Add fall-back code to set placeholder color.
                _username.backgroundColor = [UIColor clearColor];
            }
            //            _username.placeholder = @"Enter Username";
            //            _username.backgroundColor = [UIColor clearColor];
            _username.autocorrectionType = UITextAutocorrectionTypeNo;
            _username.keyboardType = UIKeyboardTypeEmailAddress;
            _username.returnKeyType = UIReturnKeyNext;
            _username.clearButtonMode = UITextFieldViewModeWhileEditing;
            _username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_username addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [_username addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [self.view addSubview:_username];
            
            _password = [[UITextField alloc] initWithFrame:CGRectMake(15, 77, 305, 42)];
            _password.borderStyle = UITextBorderStyleNone;
            _password.font = [UIFont fontWithName:@"OpenSans" size:17.5f];
            _password.textColor = [UIColor lightGrayColor];
            _password.backgroundColor = [UIColor whiteColor];
            
            if ([_password respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                UIColor *color = [UIColor lightGrayColor];
                _password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
            } else {
                // TODO: Add fall-back code to set placeholder color.
                _password.backgroundColor = [UIColor clearColor];
            }
            
            //            _username.placeholder = @"Enter Username";
            //            _username.backgroundColor = [UIColor clearColor];
            _password.autocorrectionType = UITextAutocorrectionTypeNo;
            _password.keyboardType = UIKeyboardTypeDefault;
            _password.returnKeyType = UIReturnKeyDone;
            _password.clearButtonMode = UITextFieldViewModeWhileEditing;
            _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _password.secureTextEntry = YES;
            //            [_password addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [_password addTarget:self action:@selector(signInBtnTouched:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [_password addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [self.view addSubview:_password];
            
            UILabel *forgotPassword = [[UILabel alloc]initWithFrame:CGRectMake(15, 140, 300, 18)];
            forgotPassword.textColor = [self colorWithHexString:@"3ac0ec"];
            [forgotPassword setFont:[UIFont fontWithName:@"OpenSans" size:13]];
            forgotPassword.text = @"Forgot Password?";
            forgotPassword.textAlignment = NSTextAlignmentCenter;
            forgotPassword.adjustsFontSizeToFitWidth = NO;
            [self.view addSubview:forgotPassword];
            
            resetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [resetPasswordBtn setFrame:CGRectMake(80, 130, 150, 25)];
            [resetPasswordBtn setTitle:nil forState:UIControlStateNormal];
            [resetPasswordBtn setBackgroundColor:[UIColor clearColor]];
            [resetPasswordBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:resetPasswordBtn];
            
        } else {
            /*Do iPhone Classic stuff here.*/
            
            self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 57, 120, 120)];
            self.logoImage.image = [UIImage imageNamed:@"Yookatransparent.png"];
            [self.view addSubview:self.logoImage];
            
            self.loginPanel = [[UIImageView alloc]initWithFrame:CGRectMake(15, 201, 290, 91)];
            self.loginPanel.image = [UIImage imageNamed:@"login_panel.png"];
            [self.view addSubview:self.loginPanel];
            
            _username = [[UITextField alloc] initWithFrame:CGRectMake(31, 201, 248, 43)];
            _username.borderStyle = UITextBorderStyleNone;
            _username.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
            _username.textColor = [UIColor blackColor];
            _username.backgroundColor = [UIColor clearColor];
            
            if ([_username respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                UIColor *color = [UIColor lightGrayColor];
                _username.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName: color}];
            } else {
                // TODO: Add fall-back code to set placeholder color.
                _username.backgroundColor = [UIColor clearColor];
            }
            //            _username.placeholder = @"Enter Username";
            //            _username.backgroundColor = [UIColor clearColor];
            _username.autocorrectionType = UITextAutocorrectionTypeNo;
            _username.keyboardType = UIKeyboardTypeEmailAddress;
            _username.returnKeyType = UIReturnKeyNext;
            _username.clearButtonMode = UITextFieldViewModeWhileEditing;
            _username.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_username addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [_username addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [self.view addSubview:_username];
            
            _password = [[UITextField alloc] initWithFrame:CGRectMake(31, 246, 248, 46)];
            _password.borderStyle = UITextBorderStyleNone;
            _password.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0];
            _password.textColor = [UIColor blackColor];
            _password.backgroundColor = [UIColor clearColor];
            
            if ([_password respondsToSelector:@selector(setAttributedPlaceholder:)]) {
                UIColor *color = [UIColor lightGrayColor];
                _password.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: color}];
            } else {
                // TODO: Add fall-back code to set placeholder color.
                _password.backgroundColor = [UIColor clearColor];
            }
            
            //            _username.placeholder = @"Enter Username";
            //            _username.backgroundColor = [UIColor clearColor];
            _password.autocorrectionType = UITextAutocorrectionTypeNo;
            _password.keyboardType = UIKeyboardTypeDefault;
            _password.returnKeyType = UIReturnKeyDone;
            _password.clearButtonMode = UITextFieldViewModeWhileEditing;
            _password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            _password.secureTextEntry = YES;
            //            [_password addTarget:self action:@selector(textFieldShouldReturn:)forControlEvents:UIControlEventEditingDidEndOnExit];
            [_password addTarget:self action:@selector(signInBtnTouched:) forControlEvents:UIControlEventEditingDidEndOnExit];
            [_password addTarget:self action:@selector(textFieldDidBeginEditing:)forControlEvents:UIControlEventEditingDidBegin];
            [self.view addSubview:_password];
            
            UILabel *forgotPassword = [[UILabel alloc]initWithFrame:CGRectMake(15, 300, 300, 15)];
            forgotPassword.textColor = [UIColor whiteColor];
            [forgotPassword setFont:[UIFont fontWithName:@"Helvetica" size:12]];
            forgotPassword.text = @"Forgot Password?";
            forgotPassword.textAlignment = NSTextAlignmentCenter;
            forgotPassword.adjustsFontSizeToFitWidth = NO;
            [self.view addSubview:forgotPassword];
            
            resetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [resetPasswordBtn setFrame:CGRectMake(80, 300, 150, 25)];
            [resetPasswordBtn setTitle:nil forState:UIControlStateNormal];
            [resetPasswordBtn setBackgroundColor:[UIColor clearColor]];
            [resetPasswordBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:resetPasswordBtn];
            
            self.signInBtn = [[FUIButton alloc]initWithFrame:CGRectMake(15, 340, 290, 43)];
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
            
        }
    } else {
        /*Do iPad stuff here.*/
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0){
        //cancel clicked ...do your action
    }else{
        
        YookaForgotPasswordViewController* media = [[YookaForgotPasswordViewController alloc] init];
        [self.navigationController pushViewController:media animated:NO];
        
    }
    
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

- (void)resetPassword:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Do you want to reset password?"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Yes", nil];
    
    [alert show];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [self colorWithHexString:@"3ac0ec"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"Sign In";
    
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
    
    UIBarButtonItem *signinButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign In" style:UIBarButtonItemStylePlain target:self action:@selector(signInBtnTouched:)];
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

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
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


- (void)signInBtnTouched:(id)sender
{
    NSString *username = _username.text;
    //    NSLog(@"username = %@",username);
    NSString *yookaUsername = [username lowercaseString];
    
    
    [Flurry setUserID: yookaUsername];
    
    NSString *yookaPassword = _password.text;
    
    if ([_username.text  isEqual: @""] || _username.text ==nil) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Sign account failed")
                                                        message:@"Please enter your username"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles: nil];
        [alert show];
        
    } else if([_password.text isEqualToString:@""] || _password.text == nil) {
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Sign account failed")
                                                        message:@"Please enter your password"
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                              otherButtonTitles: nil];
        [alert show];
        
    } else {
        
        [KCSUser loginWithUsername:yookaUsername password:yookaPassword withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
            if (errorOrNil ==  nil) {
                //the log-in was successful and the user is now the active user and credentials saved
                //hide log-in view and show main app content
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:yookaUsername forKey:@"user_email"];
                //                [ud setObject:[NSNumber numberWithInt:0] forKey:@"results_screen"];
                [ud synchronize];
                
                //the log-in was successful and the user is now the active user and credentials saved
                //hide log-in view and show main app content
                
                YookaAppDelegate* appDelegate = (id)[UIApplication sharedApplication].delegate;
                [appDelegate userLoggedIn];

            } else {
                
                //there was an error with the update save
                NSString* message = [errorOrNil localizedDescription];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Sign account failed", @"Sign account failed")
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                      otherButtonTitles: nil];
                [alert show];
            }
        }];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _username) {
        
        [_password becomeFirstResponder];
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
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    
}

-(BOOL)textFieldDidBeginEditing:(UITextField *)sender
{
    if (sender == _username) {
        
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
                rect.origin.y -= kOFFSET_FOR_KEYBOARD_2;
                rect.size.height += kOFFSET_FOR_KEYBOARD_2;
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
                rect.origin.y += kOFFSET_FOR_KEYBOARD_2;
                rect.size.height -= kOFFSET_FOR_KEYBOARD_2;
            } else {
                rect.origin.y += kOFFSET_FOR_KEYBOARD_3;
                rect.size.height -= kOFFSET_FOR_KEYBOARD_3;
            }
        }
        
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

-(void)dismissKeyboard {
    [_username resignFirstResponder];
    [_password resignFirstResponder];
}

@end
