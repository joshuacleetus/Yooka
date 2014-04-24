//
//  YookaForgotPasswordViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 4/7/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FUIButton.h>
#import <KinveyKit/KinveyKit.h>

@interface YookaForgotPasswordViewController : UIViewController {
    
    IBOutlet UIButton *cancelBtn;
    IBOutlet UIButton *signupBtn;
    IBOutlet UIButton *resetPasswordBtn;
    
}

@property (strong, nonatomic) IBOutlet UITextField *fullName;
@property (strong, nonatomic) IBOutlet UITextField *email;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *password2;

@end
