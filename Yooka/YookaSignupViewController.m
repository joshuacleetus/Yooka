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

#define kOFFSET_FOR_KEYBOARD 165.0
#define kOFFSET_FOR_KEYBOARD_1 255.0
#define kOFFSET_FOR_KEYBOARD_2 355.0
#define kOFFSET_FOR_KEYBOARD_3 515.0

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
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.view setBackgroundColor:color];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            
            /*Do iPhone 5 stuff here.*/
            
            self.logoImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 20, 120, 120)];
            self.logoImage.image = [UIImage imageNamed:@"Yookatransparent.png"];
            [self.view addSubview:self.logoImage];
            
            self.signupPanelTop = [[UIImageView alloc]initWithFrame:CGRectMake(15, 164, 290, 89)];
            self.signupPanelTop.image = [UIImage imageNamed:@"signup_panel_top.png"];
            [self.view addSubview:self.signupPanelTop];
            
            self.signupPanelBottom = [[UIImageView alloc]initWithFrame:CGRectMake(15, 261, 290, 135)];
            self.signupPanelBottom.image = [UIImage imageNamed:@"signup_panel_bottom.png"];
            [self.view addSubview:self.signupPanelBottom];
            
            self.camera = [[UIImageView alloc]initWithFrame:CGRectMake(25, 177, 63, 63)];
            self.camera.image = [UIImage imageNamed:@"take_picture.png"];
            [self.view addSubview:self.camera];
            
            _pickImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [_pickImageBtn setFrame:CGRectMake(25, 177, 63, 63)];
            [_pickImageBtn setTitle:nil forState:UIControlStateNormal];
            [_pickImageBtn setBackgroundColor:[UIColor clearColor]];
            [_pickImageBtn addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_pickImageBtn];
            
            _firstName = [[UITextField alloc] initWithFrame:CGRectMake(114, 164, 177, 47)];
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
            
            _lastName = [[UITextField alloc] initWithFrame:CGRectMake(114, 206, 177, 47)];
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
            
            _email = [[UITextField alloc] initWithFrame:CGRectMake(29, 261, 262, 42)];
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
            
            _password = [[UITextField alloc] initWithFrame:CGRectMake(29, 307, 262, 42)];
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
            
            _password2 = [[UITextField alloc] initWithFrame:CGRectMake(29, 351, 262, 42)];
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
            
            self.signUpBtn = [[FUIButton alloc]initWithFrame:CGRectMake(16, 404, 288, 43)];
            UIColor * color6 = [UIColor colorWithRed:245/255.0f green:135/255.0f blue:77/255.0f alpha:1.0f];
            self.signUpBtn.buttonColor = color6;
            UIColor * color7 = [UIColor colorWithRed:221/255.0f green:117/255.0f blue:62/255.0f alpha:1.0f];
            self.signUpBtn.shadowColor = color7;
            self.signUpBtn.shadowHeight = 3.0f;
            self.signUpBtn.cornerRadius = 6.0f;
            self.signUpBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
            [self.signUpBtn setTitle:@"Signup" forState:UIControlStateNormal];
            [self.signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.signUpBtn addTarget:self action:@selector(signUpBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.signUpBtn];
            
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
            
            self.signUpBtn = [[FUIButton alloc]initWithFrame:CGRectMake(16, 354, 288, 43)];
            UIColor * color6 = [UIColor colorWithRed:245/255.0f green:135/255.0f blue:77/255.0f alpha:1.0f];
            self.signUpBtn.buttonColor = color6;
            UIColor * color7 = [UIColor colorWithRed:221/255.0f green:117/255.0f blue:62/255.0f alpha:1.0f];
            self.signUpBtn.shadowColor = color7;
            self.signUpBtn.shadowHeight = 3.0f;
            self.signUpBtn.cornerRadius = 6.0f;
            self.signUpBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
            [self.signUpBtn setTitle:@"Signup" forState:UIControlStateNormal];
            [self.signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.signUpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            [self.signUpBtn addTarget:self action:@selector(signUpBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.signUpBtn];
        }
    } else {
        /*Do iPad stuff here.*/
    }
    


}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"Signup";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
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
    
    [sender resignFirstResponder];
    
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
        
        self.camera = [[UIImageView alloc] initWithFrame:CGRectMake(25, 177, 63, 63)];
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
