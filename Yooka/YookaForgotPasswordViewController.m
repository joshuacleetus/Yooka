//
//  YookaForgotPasswordViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 4/7/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaForgotPasswordViewController.h"
#import "YookaSigninViewController.h"
#import "YookaNewsFeedViewController.h"
#import "YookaAppDelegate.h"

#define kOFFSET_FOR_KEYBOARD 135.0
#define kOFFSET_FOR_KEYBOARD_1 145.0
#define kOFFSET_FOR_KEYBOARD_2 145.0
#define kOFFSET_FOR_KEYBOARD_3 155.0

@interface YookaForgotPasswordViewController ()

@end

@implementation YookaForgotPasswordViewController

@synthesize fullName = _fullName;
@synthesize email = _email;
@synthesize password = _password;
@synthesize password2 = _password2;

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
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.view setBackgroundColor:color];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
            UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 97, 120, 120)];
            backgroundImage.image = [UIImage imageNamed:@"Yookatransparent.png"];
            [self.view addSubview:backgroundImage];
            [self.view sendSubviewToBack:backgroundImage];
        
        UIImageView *emailbgImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 275, 260, 30)];
        emailbgImage.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:emailbgImage];
        
            _email = [[UITextField alloc] initWithFrame:CGRectMake(40, 275, 260, 30)];
            _email.borderStyle = UITextBorderStyleNone;
            _email.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
            _email.placeholder = @"    Email";
            _email.backgroundColor = [UIColor whiteColor];
            _email.autocorrectionType = UITextAutocorrectionTypeNo;
            _email.keyboardType = UIKeyboardTypeEmailAddress;
            _email.returnKeyType = UIReturnKeyDone;
            _email.clearButtonMode = UITextFieldViewModeWhileEditing;
            _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [_email addTarget:self
                       action:@selector(resetPassword:)
             forControlEvents:UIControlEventEditingDidEndOnExit];
            [self.view addSubview:_email];
            
            resetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [resetPasswordBtn setFrame:CGRectMake(30, 320, 85, 30)];
            [resetPasswordBtn setTitle:@"Reset" forState:UIControlStateNormal];
            [resetPasswordBtn setBackgroundColor:[UIColor orangeColor]];
            [resetPasswordBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:resetPasswordBtn];
            
            cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [cancelBtn setFrame:CGRectMake(195, 320, 85, 30)];
            [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
            [cancelBtn setBackgroundColor:[UIColor orangeColor]];
            [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:cancelBtn];
            
//        } else {
//            
//            UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
//            backgroundImage.image = [UIImage imageNamed:@"resetiphone5ios6.png"];
//            [self.view addSubview:backgroundImage];
//            [self.view sendSubviewToBack:backgroundImage];
//            
//            _email = [[UITextField alloc] initWithFrame:CGRectMake(45, 154, 235, 40)];
//            _email.borderStyle = UITextBorderStyleNone;
//            _email.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
//            _email.placeholder = @"Email";
//            _email.backgroundColor = [UIColor clearColor];
//            _email.autocorrectionType = UITextAutocorrectionTypeNo;
//            _email.keyboardType = UIKeyboardTypeEmailAddress;
//            _email.returnKeyType = UIReturnKeyDone;
//            _email.clearButtonMode = UITextFieldViewModeWhileEditing;
//            _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            [_email addTarget:self
//                       action:@selector(resetPassword:)
//             forControlEvents:UIControlEventEditingDidEndOnExit];
//            [self.view addSubview:_email];
//            
//            resetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [resetPasswordBtn setFrame:CGRectMake(30, 230, 75, 40)];
//            [resetPasswordBtn setTitle:nil forState:UIControlStateNormal];
//            [resetPasswordBtn setBackgroundColor:[UIColor clearColor]];
//            [resetPasswordBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
//            [self.view addSubview:resetPasswordBtn];
//            
//            cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            [cancelBtn setFrame:CGRectMake(202, 230, 95, 40)];
//            [cancelBtn setTitle:nil forState:UIControlStateNormal];
//            [cancelBtn setBackgroundColor:[UIColor clearColor]];
//            [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
//            [self.view addSubview:cancelBtn];
//            
//        }
        
    } else {
        
//        if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
//            
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        
                UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 37, 120, 120)];
                backgroundImage.image = [UIImage imageNamed:@"Yookatransparent.png"];
                [self.view addSubview:backgroundImage];
                [self.view sendSubviewToBack:backgroundImage];
        
                UIImageView *emailbgImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 205, 260, 30)];
                emailbgImage.backgroundColor = [UIColor whiteColor];
                [self.view addSubview:emailbgImage];
        
                _email = [[UITextField alloc] initWithFrame:CGRectMake(40, 205, 250, 30)];
                _email.borderStyle = UITextBorderStyleNone;
                _email.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
                _email.placeholder = @"Enter your email to reset password";
                _email.backgroundColor = [UIColor whiteColor];
                _email.autocorrectionType = UITextAutocorrectionTypeNo;
                _email.keyboardType = UIKeyboardTypeEmailAddress;
                _email.returnKeyType = UIReturnKeyDone;
                _email.clearButtonMode = UITextFieldViewModeWhileEditing;
                _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [_email addTarget:self
                           action:@selector(resetPassword:)
                 forControlEvents:UIControlEventEditingDidEndOnExit];
                [self.view addSubview:_email];
                
                resetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [resetPasswordBtn setFrame:CGRectMake(30, 250, 85, 30)];
                [resetPasswordBtn setTitle:@"Reset" forState:UIControlStateNormal];
                [resetPasswordBtn setBackgroundColor:[UIColor orangeColor]];
                [resetPasswordBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:resetPasswordBtn];
        
                cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cancelBtn setFrame:CGRectMake(205, 250, 85, 30)];
                [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
                [cancelBtn setBackgroundColor:[UIColor orangeColor]];
                [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:cancelBtn];
        
//            } else {
//                
//                UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//                backgroundImage.image = [UIImage imageNamed:@"resetiphone4sios6.png"];
//                [self.view addSubview:backgroundImage];
//                [self.view sendSubviewToBack:backgroundImage];
//                
//                _email = [[UITextField alloc] initWithFrame:CGRectMake(45, 130, 235, 40)];
//                _email.borderStyle = UITextBorderStyleNone;
//                _email.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
//                _email.placeholder = @"Email";
//                _email.backgroundColor = [UIColor clearColor];
//                _email.autocorrectionType = UITextAutocorrectionTypeNo;
//                _email.keyboardType = UIKeyboardTypeEmailAddress;
//                _email.returnKeyType = UIReturnKeyDone;
//                _email.clearButtonMode = UITextFieldViewModeWhileEditing;
//                _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                [_email addTarget:self
//                           action:@selector(resetPassword:)
//                 forControlEvents:UIControlEventEditingDidEndOnExit];
//                [self.view addSubview:_email];
//                
//                resetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [resetPasswordBtn setFrame:CGRectMake(30, 210, 75, 40)];
//                [resetPasswordBtn setTitle:nil forState:UIControlStateNormal];
//                [resetPasswordBtn setBackgroundColor:[UIColor clearColor]];
//                [resetPasswordBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
//                [self.view addSubview:resetPasswordBtn];
//                
//                cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [cancelBtn setFrame:CGRectMake(198, 210, 95, 40)];
//                [cancelBtn setTitle:nil forState:UIControlStateNormal];
//                [cancelBtn setBackgroundColor:[UIColor clearColor]];
//                [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
//                [self.view addSubview:cancelBtn];
//                
//            }
        
//        } else {
//            
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//                
//                UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//                backgroundImage.image = [UIImage imageNamed:@"resetiphone4sios7.png"];
//                [self.view addSubview:backgroundImage];
//                [self.view sendSubviewToBack:backgroundImage];
//                
//                _email = [[UITextField alloc] initWithFrame:CGRectMake(45, 140, 235, 40)];
//                _email.borderStyle = UITextBorderStyleNone;
//                _email.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
//                _email.placeholder = @"Email";
//                _email.backgroundColor = [UIColor clearColor];
//                _email.autocorrectionType = UITextAutocorrectionTypeNo;
//                _email.keyboardType = UIKeyboardTypeEmailAddress;
//                _email.returnKeyType = UIReturnKeyDone;
//                _email.clearButtonMode = UITextFieldViewModeWhileEditing;
//                _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                [_email addTarget:self
//                           action:@selector(resetPassword:)
//                 forControlEvents:UIControlEventEditingDidEndOnExit];
//                [self.view addSubview:_email];
//                
//                resetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [resetPasswordBtn setFrame:CGRectMake(30, 220, 75, 40)];
//                [resetPasswordBtn setTitle:nil forState:UIControlStateNormal];
//                [resetPasswordBtn setBackgroundColor:[UIColor clearColor]];
//                [resetPasswordBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
//                [self.view addSubview:resetPasswordBtn];
//                
//                cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [cancelBtn setFrame:CGRectMake(198, 220, 95, 40)];
//                [cancelBtn setTitle:nil forState:UIControlStateNormal];
//                [cancelBtn setBackgroundColor:[UIColor clearColor]];
//                [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
//                [self.view addSubview:cancelBtn];
//                
//            } else {
//                
//                UIImageView *backgroundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
//                backgroundImage.image = [UIImage imageNamed:@"resetiphone4sios6.png"];
//                [self.view addSubview:backgroundImage];
//                [self.view sendSubviewToBack:backgroundImage];
//                
//                _email = [[UITextField alloc] initWithFrame:CGRectMake(45, 130, 235, 40)];
//                _email.borderStyle = UITextBorderStyleNone;
//                _email.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
//                _email.placeholder = @"Email";
//                _email.backgroundColor = [UIColor clearColor];
//                _email.autocorrectionType = UITextAutocorrectionTypeNo;
//                _email.keyboardType = UIKeyboardTypeEmailAddress;
//                _email.returnKeyType = UIReturnKeyDone;
//                _email.clearButtonMode = UITextFieldViewModeWhileEditing;
//                _email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//                [_email addTarget:self
//                           action:@selector(resetPassword:)
//                 forControlEvents:UIControlEventEditingDidEndOnExit];
//                [self.view addSubview:_email];
//                
//                resetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [resetPasswordBtn setFrame:CGRectMake(30, 210, 75, 40)];
//                [resetPasswordBtn setTitle:nil forState:UIControlStateNormal];
//                [resetPasswordBtn setBackgroundColor:[UIColor clearColor]];
//                [resetPasswordBtn addTarget:self action:@selector(resetPassword:) forControlEvents:UIControlEventTouchUpInside];
//                [self.view addSubview:resetPasswordBtn];
//                
//                cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [cancelBtn setFrame:CGRectMake(198, 210, 95, 40)];
//                [cancelBtn setTitle:nil forState:UIControlStateNormal];
//                [cancelBtn setBackgroundColor:[UIColor clearColor]];
//                [cancelBtn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
//                [self.view addSubview:cancelBtn];
//                
//            }
//        
//        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return (UIInterfaceOrientationMaskPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_email resignFirstResponder];
    
}
- (void)resetPassword:(id)sender {
    
    //    NSLog(@" username = %@", _email.text);
    
    NSString *useremail = _email.text;
    NSString *lowercase = [useremail lowercaseString];
    
    [KCSUser sendPasswordResetForUser:lowercase withCompletionBlock:^(BOOL emailSent, NSError *errorOrNil) {
        // handle error
        if (emailSent == 1) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Password reset link mailed to you"
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles: nil];
            [alert show];
        }else{
            NSString* message = [errorOrNil localizedDescription];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Reset password failed", @"Reset password failed")
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelBtn:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)dismissKeyboard {
    
    [_email resignFirstResponder];
    
}

@end
