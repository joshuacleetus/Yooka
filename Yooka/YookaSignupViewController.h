//
//  YookaSignupViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 11/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FlatUIKit.h>
#import <KinveyKit/KinveyKit.h>

@interface YookaSignupViewController : UIViewController<UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    IBOutlet UIButton *resetPasswordBtn;
}

@property (nonatomic, strong) IBOutlet UIImageView *logoImage;
@property (nonatomic, strong) IBOutlet UIImageView *signupPanelTop;
@property (nonatomic, strong) IBOutlet UIImageView *signupPanelBottom;
@property (nonatomic, strong) IBOutlet UIImageView *camera;
@property (nonatomic, strong) IBOutlet UITextField *firstName;
@property (nonatomic, strong) IBOutlet UITextField *lastName;
@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *password;
@property (nonatomic, strong) IBOutlet UITextField *password2;
@property (nonatomic, strong) IBOutlet FUIButton *signUpBtn;
@property (nonatomic, strong) IBOutlet UIButton *pickImageBtn;
@property (nonatomic, retain) UIImage* profileImage;
@property (nonatomic, retain) id<KCSStore> updateStore;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *userEmail;
- (IBAction)signUpBtnTouched:(id)sender;
- (IBAction)takePicture:(id)sender;
@property (nonatomic,strong) IBOutlet FUIButton *fbBtn;

@property (strong, nonatomic) IBOutlet FUIButton *termsBtn;

@end
