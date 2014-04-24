//
//  TermsOfServiceViewController.h
//  BeUrSelfie
//
//  Created by Joshua Cleetus on 11/1/13.
//  Copyright (c) 2013 JoshuaSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TermsOfServiceViewController : UIViewController<UIWebViewDelegate,UIScrollViewAccessibilityDelegate,UIScrollViewDelegate>{
    IBOutlet UIImageView *terms_imageview;
    IBOutlet UIButton *doneBtn;
}

@property (nonatomic, strong) UIWebView* webView;
@property (nonatomic, strong) UIScrollView* gridScrollView;

@end
