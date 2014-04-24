//
//  YookaSigninViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 11/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FUIButton.h>
#import <KinveyKit/KinveyKit.h>

@interface YookaSigninViewController : UIViewController{
    
    IBOutlet UIButton *resetPasswordBtn;

}

@property (nonatomic, strong) IBOutlet UIImageView *logoImage;
@property (nonatomic, strong) IBOutlet UIImageView *loginPanel;
@property (nonatomic, strong) IBOutlet UITextField *username;
@property (nonatomic, strong) IBOutlet UITextField *password;

@property (nonatomic,strong) IBOutlet FUIButton *signInBtn;

@end
