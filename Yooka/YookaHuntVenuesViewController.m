//
//  YookaHuntVenuesViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 3/8/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaHuntVenuesViewController.h"
#import "YookaBackend.h"
#import <Reachability.h>
#import "AddressAnnotation.h"
#import "BridgeAnnotation.h"
#import "SFAnnotation.h"
#import "CustomAnnotationView.h"
#import "CustomMapItem.h"
#import "BridgeAnnotation.h"
#import "YookaHuntRestaurantViewController.h"
#import "YookaPostViewController.h"
#import <AsyncImageDownloader.h>
#import "CoreTextArcView.h"
#import <DMActivityInstagram.h>
#import <Social/Social.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>
#import "GSBorderLabel.h"
#import "UIImageView+WebCache.h"


@interface YookaHuntVenuesViewController ()
{
    unsigned long total_items;
}

@end

@implementation YookaHuntVenuesViewController

+ (CGFloat)annotationPadding;
{
    return 10.0f;
}

+ (CGFloat)calloutHeight;
{
    return 40.0f;
}

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
    
    
    _yookaGreen   = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    _yookaGreen2  = [UIColor colorWithRed:83/255.0f green:154/255.0f blue:142/255.0f alpha:1.0f];
    _yookaOrange  = [UIColor colorWithRed:245/255.0f green:135/255.0f blue:77/255.0f alpha:1.0f];
    _yookaOrange2 = [UIColor colorWithRed:221/255.0f green:117/255.0f blue:62/255.0f alpha:1.0f];

//    CLLocationCoordinate2D  ctrpoint;
//    ctrpoint.latitude = [_latitude doubleValue];
//    ctrpoint.longitude =[_longitude doubleValue];
//    AddressAnnotation *addAnnotation = [[AddressAnnotation alloc]initWithCoordinate:ctrpoint];
//    [self.mapView addAnnotation:addAnnotation];
    
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = self;
//    }

}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    NSLog(@"swipe left");
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    NSLog(@"swipe right");
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)showPopUp
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height > 480.0f) {
            /*Do iPhone 5 stuff here.*/
            self.modalView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 586)];
            _modalView2.opaque = NO;
            _modalView2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
            _modalView2.tag = 101;
            [self.view addSubview:_modalView2];
            
            [self.view bringSubviewToFront:_modalView2];
            
            UIImageView *purpleBg = [[UIImageView alloc]initWithFrame:CGRectMake(40, 85, 240, 400)];
            purpleBg.image = [UIImage imageNamed:@"purplebackground.png"];
            [self.modalView2 addSubview:purpleBg];
            
            UIImageView *x_box = [[UIImageView alloc]initWithFrame:CGRectMake(240, 95, 34, 34)];
            x_box.image = [UIImage imageNamed:@"x-box.png"];
            [self.modalView2 addSubview:x_box];
            
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeBtn  setFrame:CGRectMake(240, 95, 34, 34)];
            [closeBtn setBackgroundColor:[UIColor clearColor]];
            [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [closeBtn.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:17.0]];
            [closeBtn setTitle:@"X" forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(closeBtn2) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView2 addSubview:closeBtn];
            
            UIImageView *chatbubble = [[UIImageView alloc]initWithFrame:CGRectMake(95, 102, 132, 123)];
            chatbubble.image = [UIImage imageNamed:@"chatbubble.png"];
            [self.modalView2 addSubview:chatbubble];
            
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(150, 132, 75, 12)];
            label1.text = @"GOOD JOB!";
            label1.font = [UIFont fontWithName:@"Montserrat-Regular" size:12.f];
            label1.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(105, 108, 125, 26)];
            label2.text = @"HURRAY";
            label2.font = [UIFont fontWithName:@"Montserrat-Regular" size:26.f];
            label2.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label2];
            
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(103, 155, 76, 12)];
            label3.text = @"WAY TO GO!";
            label3.font = [UIFont fontWithName:@"Montserrat-Regular" size:12.f];
            label3.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label3];
            
            UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(180, 158, 45, 7)];
            label4.text = @"YOU DID IT";
            label4.font = [UIFont fontWithName:@"Montserrat-Regular" size:7.f];
            label4.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label4];
            
            UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(138, 170, 85, 15)];
            label5.text = @"AWESOME";
            label5.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.f];
            label5.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label5];
            
            UIImageView *badgeView = [[UIImageView alloc]initWithFrame:CGRectMake(86, 225, 143, 100)];
            badgeView.image = [UIImage imageNamed:@"badge.png"];
            badgeView.contentMode = UIViewContentModeScaleAspectFit;
            [self.modalView2 addSubview:badgeView];
            
            NSString *logoUrl = _huntImageUrl;
            
            [[[AsyncImageDownloader alloc] initWithMediaURL:logoUrl successBlock:^(UIImage *image)  {
                
                UIImageView *badgeView2 = [[UIImageView alloc]initWithFrame:CGRectMake(130, 250, 55, 55)];
                badgeView2.contentMode = UIViewContentModeScaleAspectFit;
                badgeView2.image = image;
                [self.modalView2 addSubview:badgeView2];
                
                UIImageView *badgeView3 = [[UIImageView alloc]initWithFrame:CGRectMake(125, 287, 72, 27)];
                badgeView3.contentMode = UIViewContentModeCenter;
                badgeView3.image = [UIImage imageNamed:@"yooka.png"];
                UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                badgeView3.backgroundColor = color;
                [self.modalView2 addSubview:badgeView3];
                
            } failBlock:^(NSError *error) {
                //        NSLog(@"Failed to download image due to %@!", error);
            }] startDownload];
            
            UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(71, 342, 185, 16)];
            label6.text = @"YOU'VE COMPLETED";
            label6.font = [UIFont fontWithName:@"Montserrat-Regular" size:17.f];
            label6.textColor = [UIColor whiteColor];
            [self.modalView2 addSubview:label6];
            
            UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(117, 361, 93, 16)];
            label7.text = @"THE HUNT";
            label7.font = [UIFont fontWithName:@"Montserrat-Regular" size:17.f];
            label7.textColor = [UIColor whiteColor];
            [self.modalView2 addSubview:label7];
            
            UIButton *fbBtn = [[UIButton alloc]initWithFrame:CGRectMake(97, 400, 38, 38)];
            [fbBtn setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
            [fbBtn addTarget:self action:@selector(fbBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView2 addSubview:fbBtn];
            
            UIButton *twitterBtn = [[UIButton alloc]initWithFrame:CGRectMake(140, 400, 38, 38)];
            [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
            [twitterBtn addTarget:self action:@selector(twitterBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView2 addSubview:twitterBtn];
            
            UIButton *instaBtn = [[UIButton alloc]initWithFrame:CGRectMake(183, 400, 38, 38)];
            [instaBtn setBackgroundImage:[UIImage imageNamed:@"instagram123.png"] forState:UIControlStateNormal];
            [instaBtn addTarget:self action:@selector(instaBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView2 addSubview:instaBtn];
            
            //    UIButton *tumblrBtn = [[UIButton alloc]initWithFrame:CGRectMake(186, 360, 38, 38)];
            //    [tumblrBtn setBackgroundImage:[UIImage imageNamed:@"tumblr.png"] forState:UIControlStateNormal];
            //    [tumblrBtn addTarget:self action:@selector(tumblrBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.modalView addSubview:tumblrBtn];
            //    
            //    UIButton *pinterestBtn = [[UIButton alloc]initWithFrame:CGRectMake(229, 360, 38, 38)];
            //    [pinterestBtn setBackgroundImage:[UIImage imageNamed:@"pinterest.png"] forState:UIControlStateNormal];
            //    [pinterestBtn addTarget:self action:@selector(pinterestBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.modalView addSubview:pinterestBtn];
            
            UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(95, 448, 30, 20)];
            arrowView.image = [UIImage imageNamed:@"orange_arrow.png"];
            [self.modalView2 addSubview:arrowView];
            
            UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(134, 446, 160, 22)];
            label8.text = @"SHARE IT";
            label8.font = [UIFont fontWithName:@"Montserrat-Regular" size:17.f];
            label8.textColor = [UIColor whiteColor];
            [self.modalView2 addSubview:label8];
        } else {
            /*Do iPhone Classic stuff here.*/
            self.modalView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 586)];
            _modalView2.opaque = NO;
            _modalView2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
            _modalView2.tag = 101;
            [self.view addSubview:_modalView2];
            
            [self.view bringSubviewToFront:_modalView2];
            
            UIImageView *purpleBg = [[UIImageView alloc]initWithFrame:CGRectMake(40, 35, 240, 400)];
            purpleBg.image = [UIImage imageNamed:@"purplebackground.png"];
            [self.modalView2 addSubview:purpleBg];
            
            UIImageView *x_box = [[UIImageView alloc]initWithFrame:CGRectMake(240, 45, 34, 34)];
            x_box.image = [UIImage imageNamed:@"x-box.png"];
            [self.modalView2 addSubview:x_box];
            
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeBtn  setFrame:CGRectMake(240, 45, 34, 34)];
            [closeBtn setBackgroundColor:[UIColor clearColor]];
            [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [closeBtn.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:17.0]];
            [closeBtn setTitle:@"X" forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(closeBtn2) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView2 addSubview:closeBtn];
            
            UIImageView *chatbubble = [[UIImageView alloc]initWithFrame:CGRectMake(95, 52, 132, 123)];
            chatbubble.image = [UIImage imageNamed:@"chatbubble.png"];
            [self.modalView2 addSubview:chatbubble];
            
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(150, 82, 75, 12)];
            label1.text = @"GOOD JOB!";
            label1.font = [UIFont fontWithName:@"Montserrat-Regular" size:12.f];
            label1.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(105, 58, 125, 26)];
            label2.text = @"HURRAY";
            label2.font = [UIFont fontWithName:@"Montserrat-Regular" size:26.f];
            label2.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label2];
            
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(103, 105, 76, 12)];
            label3.text = @"WAY TO GO!";
            label3.font = [UIFont fontWithName:@"Montserrat-Regular" size:12.f];
            label3.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label3];
            
            UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(180, 108, 45, 7)];
            label4.text = @"YOU DID IT";
            label4.font = [UIFont fontWithName:@"Montserrat-Regular" size:7.f];
            label4.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label4];
            
            UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(138, 120, 85, 15)];
            label5.text = @"AWESOME";
            label5.font = [UIFont fontWithName:@"Montserrat-Regular" size:15.f];
            label5.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label5];
            
            UIImageView *badgeView = [[UIImageView alloc]initWithFrame:CGRectMake(86, 175, 143, 100)];
            badgeView.image = [UIImage imageNamed:@"badge.png"];
            badgeView.contentMode = UIViewContentModeScaleAspectFit;
            [self.modalView2 addSubview:badgeView];
            
            NSString *logoUrl = _huntImageUrl;
            
            [[[AsyncImageDownloader alloc] initWithMediaURL:logoUrl successBlock:^(UIImage *image)  {
                
                UIImageView *badgeView2 = [[UIImageView alloc]initWithFrame:CGRectMake(130, 200, 55, 55)];
                badgeView2.contentMode = UIViewContentModeScaleAspectFit;
                badgeView2.image = image;
                [self.modalView2 addSubview:badgeView2];
                
                UIImageView *badgeView3 = [[UIImageView alloc]initWithFrame:CGRectMake(125, 237, 72, 27)];
                badgeView3.contentMode = UIViewContentModeCenter;
                badgeView3.image = [UIImage imageNamed:@"yooka.png"];
                UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                badgeView3.backgroundColor = color;
                [self.modalView2 addSubview:badgeView3];
                
            } failBlock:^(NSError *error) {
                //        NSLog(@"Failed to download image due to %@!", error);
            }] startDownload];
            
            UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(71, 292, 185, 16)];
            label6.text = @"YOU'VE COMPLETED";
            label6.font = [UIFont fontWithName:@"Montserrat-Regular" size:17.f];
            label6.textColor = [UIColor whiteColor];
            [self.modalView2 addSubview:label6];
            
            UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(117, 321, 93, 16)];
            label7.text = @"THE HUNT";
            label7.font = [UIFont fontWithName:@"Montserrat-Regular" size:17.f];
            label7.textColor = [UIColor whiteColor];
            [self.modalView2 addSubview:label7];
            
            UIButton *fbBtn = [[UIButton alloc]initWithFrame:CGRectMake(97, 350, 38, 38)];
            [fbBtn setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
            [fbBtn addTarget:self action:@selector(fbBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView2 addSubview:fbBtn];
            
            UIButton *twitterBtn = [[UIButton alloc]initWithFrame:CGRectMake(140, 350, 38, 38)];
            [twitterBtn setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
            [twitterBtn addTarget:self action:@selector(twitterBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView2 addSubview:twitterBtn];
            
            UIButton *instaBtn = [[UIButton alloc]initWithFrame:CGRectMake(183, 350, 38, 38)];
            [instaBtn setBackgroundImage:[UIImage imageNamed:@"instagram123.png"] forState:UIControlStateNormal];
            [instaBtn addTarget:self action:@selector(instaBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView2 addSubview:instaBtn];
            
            //    UIButton *tumblrBtn = [[UIButton alloc]initWithFrame:CGRectMake(186, 360, 38, 38)];
            //    [tumblrBtn setBackgroundImage:[UIImage imageNamed:@"tumblr.png"] forState:UIControlStateNormal];
            //    [tumblrBtn addTarget:self action:@selector(tumblrBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.modalView addSubview:tumblrBtn];
            //    
            //    UIButton *pinterestBtn = [[UIButton alloc]initWithFrame:CGRectMake(229, 360, 38, 38)];
            //    [pinterestBtn setBackgroundImage:[UIImage imageNamed:@"pinterest.png"] forState:UIControlStateNormal];
            //    [pinterestBtn addTarget:self action:@selector(pinterestBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            //    [self.modalView addSubview:pinterestBtn];
            
            UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(95, 398, 30, 20)];
            arrowView.image = [UIImage imageNamed:@"orange_arrow.png"];
            [self.modalView2 addSubview:arrowView];
            
            UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(134, 396, 160, 22)];
            label8.text = @"SHARE IT";
            label8.font = [UIFont fontWithName:@"Montserrat-Regular" size:17.f];
            label8.textColor = [UIColor whiteColor];
            [self.modalView2 addSubview:label8];
        }
    } else {
        /*Do iPad stuff here.*/
    }
    

    
}

- (void)fbBtnTouched:(id)sender
{
    NSLog(@"fb btn");
    [self.modalView2 removeFromSuperview];
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        CGSize imageSize = CGSizeMake(320, 465);
        if (NULL != UIGraphicsBeginImageContextWithOptions)
            UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
        else
            UIGraphicsBeginImageContext(imageSize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Iterate over every window from back to front
        for (UIWindow *window in [[UIApplication sharedApplication] windows])
        {
            if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
            {
                // -renderInContext: renders in the coordinate space of the layer,
                // so we must first apply the layer's geometry to the graphics context
                CGContextSaveGState(context);
                // Center the context around the window's anchor point
                CGContextTranslateCTM(context, [window center].x, [window center].y);
                // Apply the window's transform about the anchor point
                CGContextConcatCTM(context, [window transform]);
                // Offset by the portion of the bounds left of and above the anchor point
                CGContextTranslateCTM(context,
                                      -[window bounds].size.width * [[window layer] anchorPoint].x,
                                      -[window bounds].size.height * [[window layer] anchorPoint].y-60);
                
                // Render the layer hierarchy to the current context
                [[window layer] renderInContext:context];
                
                // Restore the context
                CGContextRestoreGState(context);
            }
        }
        NSString *mystring = @"I have finished the hunt \n via Yooka app now available in app store";
        //    NSString *mystring = @"My most popular Instagram #selfie photo via BeUrSelfie app. Now available in app store: \nhttps://itunes.apple.com/us/app/beurselfie/id732458094?ls=1&mt=8";
        // Retrieve the screenshot image
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:mystring];
        [controller addURL:[NSURL URLWithString:@"http://www.getyooka.com"]];
        [controller addImage:image];
        
        [self presentViewController:controller animated:YES completion:Nil];
        
    }
}

- (void)twitterBtnTouched:(id)sender
{
    NSLog(@"twitter btn");
    [self.modalView2 removeFromSuperview];
        
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        CGSize imageSize = CGSizeMake(320, 465);
        if (NULL != UIGraphicsBeginImageContextWithOptions)
            UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
        else
            UIGraphicsBeginImageContext(imageSize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // Iterate over every window from back to front
        for (UIWindow *window in [[UIApplication sharedApplication] windows])
        {
            if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
            {
                // -renderInContext: renders in the coordinate space of the layer,
                // so we must first apply the layer's geometry to the graphics context
                CGContextSaveGState(context);
                // Center the context around the window's anchor point
                CGContextTranslateCTM(context, [window center].x, [window center].y);
                // Apply the window's transform about the anchor point
                CGContextConcatCTM(context, [window transform]);
                // Offset by the portion of the bounds left of and above the anchor point
                CGContextTranslateCTM(context,
                                      -[window bounds].size.width * [[window layer] anchorPoint].x,
                                      -[window bounds].size.height * [[window layer] anchorPoint].y-60);
                
                // Render the layer hierarchy to the current context
                [[window layer] renderInContext:context];
                
                // Restore the context
                CGContextRestoreGState(context);
            }
        }
        NSString *mystring = @"I have finished the hunt \n via Yooka app now available in app store";
        //    NSString *mystring = @"My most popular Instagram #selfie photo via BeUrSelfie app. Now available in app store: \nhttps://itunes.apple.com/us/app/beurselfie/id732458094?ls=1&mt=8";
        // Retrieve the screenshot image
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:mystring];
        [tweetSheet addImage:image];
        [tweetSheet addURL:[NSURL URLWithString:@"http://www.getyooka.com"]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
}

- (void)instaBtnTouched:(id)sender
{
    [self.modalView2 removeFromSuperview];
    NSLog(@"insta btn");
    CGSize imageSize = CGSizeMake(320, 320);
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y-80);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    NSString *mystring = @"I have finished the hunt \n via Yooka app now available in app store";
//    NSString *mystring = @"My most popular Instagram #selfie photo via BeUrSelfie app. Now available in app store: \nhttps://itunes.apple.com/us/app/beurselfie/id732458094?ls=1&mt=8";
    // Retrieve the screenshot image

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
    
    NSLog(@"image saved");
    
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIGraphicsEndImageContext();
    NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
    NSLog(@"jpg path %@",jpgPath);
    NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath]; //[[NSString alloc] initWithFormat:@"file://%@", jpgPath] ];
    NSLog(@"with File path %@",newJpgPath);
    NSURL *igImageHookFile = [[NSURL alloc] initFileURLWithPath:newJpgPath];
    NSLog(@"url Path %@",igImageHookFile);
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        //imageToUpload is a file path with .ig file extension
        self.docFile = [UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
        self.docFile.UTI = @"com.instagram.photo";
        self.docFile.annotation = [NSDictionary dictionaryWithObject:mystring forKey:@"InstagramCaption"];
        [self.docFile presentOpenInMenuFromRect:rect inView: self.view animated:YES];
    }
    
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

- (void)tumblrBtnTouched:(id)sender
{
    NSLog(@"tumblr btn");
}

- (void)pinterestBtnTouched:(id)sender
{
    NSLog(@"pinterest btn");
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    k=0;
    
    count = 0,size=0;
    count2 = 0,size2=0;
    i=0, y= 0;
    y2=0;
    

//    NSLog(@"funt = %lu",(unsigned long)_featuredRestaurants.count);
    
    // Do any additional setup after loading the view.
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationItem setTitle:_huntTitle];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    [self getUserPicture];
    
    _featuredRestaurants = [NSMutableArray new];

//    if ([_huntDone isEqualToString:@"YES"]) {

        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        [[self navigationController] setNavigationBarHidden:YES animated:NO];

//        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
//        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
//        [self.view addGestureRecognizer:swipeRight];
//        swipeRight.delegate = self;
//        [self.view addGestureRecognizer:swipeRight];
        
//    }else{
//        
//        UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
//        [self.navigationController.navigationBar setBarTintColor:color];
//        [self.navigationItem setTitle:_huntTitle];
//        [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        
//    }
    
    CGRect screenRect = CGRectMake(0.f, -20.f, 320.f, self.view.frame.size.height+20);
    _mapScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
    _mapScrollView.contentSize= self.view.bounds.size;
    _mapScrollView.frame = CGRectMake(0.f, -20.f, 320.f, self.view.frame.size.height+20);
    [self.view addSubview:_mapScrollView];
    
    if (([CLLocationManager locationServicesEnabled] == YES) && [CLLocationManager authorizationStatus]!= kCLAuthorizationStatusDenied) {
        _locationManager = [[CLLocationManager alloc] init];
        //... set up CLLocationManager and start updates
        _locationManager.delegate = self;
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBestForNavigation];
        [_locationManager setDistanceFilter:kCLDistanceFilterNone];
        _currentLocation = _locationManager.location;
        //            NSLog(@"current location = %f",_currentLocation.coordinate.longitude);
        [self beginUpdatingLocation];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 60.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [_locationManager stopUpdatingLocation];
        });
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Switch on location service for best results."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
    _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 20, 400, 640)];
    //Always center the dot and zoom in to an apropriate zoom level when position changes
    //        [_mapView setUserTrackingMode:MKUserTrackingModeFollow];
    _mapView.delegate = self;
    
    // set Span
    // start off by default in San Francisco
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = _currentLocation.coordinate.latitude;
    newRegion.center.longitude = _currentLocation.coordinate.longitude;

    //        NSLog(@"%f",_currentLocation.coordinate.latitude);
    //        NSLog(@"%f",_currentLocation.coordinate.longitude);
    //    newRegion.center.latitude = [_latitude doubleValue];
    //    newRegion.center.longitude = [_longitude doubleValue];
    newRegion.span.latitudeDelta = 0.122872;
    newRegion.span.longitudeDelta = 0.119863;
    
    [self.mapView setRegion:newRegion animated:YES];
    [self.mapView setShowsUserLocation:YES];
    [self.mapScrollView addSubview:_mapView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(buttonClicked:)];
    _tapTag = @"YES";
    [self.view addGestureRecognizer:tap];
    
    _featuredRestaurants = [NSArray new];
    _selectedRestaurant = [NSMutableArray new];
    
    self.userView = [[UIImageView alloc]initWithFrame:CGRectMake(222, 15, 85, 80)];
    self.userView.image = [UIImage imageNamed:@"profilebackground.png"];
    [self.view addSubview:self.userView];
    
    self.dishScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(5, 60, 200, 500)];
    self.dishScrollView.delegate = self;
    [self.dishScrollView setScrollEnabled:YES];
    [self.dishScrollView setBounces:YES];
    [self.dishScrollView setShowsVerticalScrollIndicator:NO];
    self.dishScrollView.alwaysBounceHorizontal = NO;
    self.dishScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:self.dishScrollView];
    
    [self getFeaturedRestaurants];
    
    self.huntTitleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, 320, 45)];
    self.huntTitleImageView.image = [UIImage imageNamed:@"huntnamebackground.png"];
    [self.view addSubview:self.huntTitleImageView];
    
    self.huntTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 27, 230, 35)];
    self.huntTitleLabel.text = [_huntTitle uppercaseString];
    self.huntTitleLabel.textColor = [UIColor colorFromHexCode:@"ff4e00"];
    self.huntTitleLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:28.0];
    self.huntTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.huntTitleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.huntTitleLabel];
    
    self.userNameImageView = [[UIImageView alloc]initWithFrame:CGRectMake(222, 85, 85, 30)];
    self.userNameImageView.image = [UIImage imageNamed:@"namebackground.png"];
    [self.view addSubview:self.userNameImageView];
    
    self.usernameLbl = [[UILabel alloc]initWithFrame:CGRectMake(2, 0, 81, 30)];
    self.usernameLbl.textColor = [UIColor darkGrayColor];
    self.usernameLbl.font = [UIFont fontWithName:@"Montserrat-Regular" size:16.0];
    self.usernameLbl.textAlignment = NSTextAlignmentCenter;
    NSArray* firstLastStrings = [_userFullName componentsSeparatedByString:@" "];
    NSString *firstName = [firstLastStrings objectAtIndex:0];
    self.usernameLbl.text = firstName;
    self.usernameLbl.adjustsFontSizeToFitWidth = YES;
    [self.userNameImageView addSubview:self.usernameLbl];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleBlackTranslucent;
//}

// handle the swipes here
-(void) swipeRight:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
        NSLog(@"swipe right");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getBadgeImage
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationItem.titleView removeFromSuperview];
    [self.closeButton2 removeFromSuperview];
    [self.modalView removeFromSuperview];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    
        if ([annotation isKindOfClass:[MKUserLocation class]]) {
            return nil;
        }
    //
    //    // etc...
//     return nil;
    
    // handle our three custom annotations
    //
    if ([annotation isKindOfClass:[BridgeAnnotation class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString *BridgeAnnotationIdentifier = @"bridgeAnnotationIdentifier";
        MKPinAnnotationView *pinView =
        (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
        if (pinView == nil)
        {
            // if an existing pin view was not available, create one
            MKPinAnnotationView *customPinView = [[MKPinAnnotationView alloc]
                                                  initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier];
            customPinView.pinColor = MKPinAnnotationColorGreen;
            customPinView.animatesDrop = YES;
            customPinView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: when the detail disclosure button is tapped, we respond to it via:
            //       calloutAccessoryControlTapped delegate method
            //
            // by using "calloutAccessoryControlTapped", it's a convenient way to find out which annotation was tapped
            //
            
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customPinView.rightCalloutAccessoryView = rightButton;
            
            return customPinView;
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    else if ([annotation isKindOfClass:[SFAnnotation class]])   // for City of San Francisco
    {
        static NSString *SFAnnotationIdentifier = @"SFAnnotationIdentifier";

        MKAnnotationView *flagAnnotationView =
        [self.mapView dequeueReusableAnnotationViewWithIdentifier:SFAnnotationIdentifier];
        if (flagAnnotationView == nil)
        {
            MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                            reuseIdentifier:SFAnnotationIdentifier];
            annotationView.canShowCallout = YES;
            
            SFAnnotation *myAnn = (SFAnnotation *)annotation;
            
//            NSLog(@"tag = %@",myAnn.tag);
            
            if ([myAnn.tag isEqualToString:@"1"]) {
                UIImage *flagImage = [UIImage imageNamed:@"tealpin.png"];
                // size the flag down to the appropriate size
                CGRect resizeRect;
                
                //            resizeRect.size = flagImage.size;
                //            CGSize maxSize = CGRectInset(self.view.bounds,
                //                                         [YookaHuntVenuesViewController annotationPadding],
                //                                         [YookaHuntVenuesViewController annotationPadding]).size;
                //            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [YookaHuntVenuesViewController calloutHeight];
                //            if (resizeRect.size.width > maxSize.width)
                //                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
                //            if (resizeRect.size.height > maxSize.height)
                //                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
                
                resizeRect = CGRectMake(0.f, 0.f, 30.f, 45.f);
                
                resizeRect.origin = CGPointMake(0.0, 0.0);
                UIGraphicsBeginImageContext(resizeRect.size);
                [flagImage drawInRect:resizeRect];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                annotationView.image = resizedImage;
                annotationView.opaque = NO;
                
                //            UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
                //            annotationView.leftCalloutAccessoryView = sfIconView;
                
                UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 22, 22)];
                tagLabel.textColor = [UIColor blackColor];
                tagLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:18.0];
                tagLabel.textAlignment = NSTextAlignmentCenter;
                tagLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[_mapAnnotations indexOfObject:annotation]+1];
                [annotationView addSubview:tagLabel];
            }else{
               UIImage *flagImage = [UIImage imageNamed:@"whitepin.png"];
                
                // size the flag down to the appropriate size
                CGRect resizeRect;
                
                //            resizeRect.size = flagImage.size;
                //            CGSize maxSize = CGRectInset(self.view.bounds,
                //                                         [YookaHuntVenuesViewController annotationPadding],
                //                                         [YookaHuntVenuesViewController annotationPadding]).size;
                //            maxSize.height -= self.navigationController.navigationBar.frame.size.height + [YookaHuntVenuesViewController calloutHeight];
                //            if (resizeRect.size.width > maxSize.width)
                //                resizeRect.size = CGSizeMake(maxSize.width, resizeRect.size.height / resizeRect.size.width * maxSize.width);
                //            if (resizeRect.size.height > maxSize.height)
                //                resizeRect.size = CGSizeMake(resizeRect.size.width / resizeRect.size.height * maxSize.height, maxSize.height);
                
                resizeRect = CGRectMake(0.f, 0.f, 28.f, 45.f);
                
                resizeRect.origin = CGPointMake(0.0, 0.0);
                UIGraphicsBeginImageContext(resizeRect.size);
                [flagImage drawInRect:resizeRect];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                annotationView.image = resizedImage;
                annotationView.opaque = NO;
                
                //            UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
                //            annotationView.leftCalloutAccessoryView = sfIconView;
                
                UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 22, 22)];
                tagLabel.textColor = [UIColor darkGrayColor];
                tagLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:18.0];
                tagLabel.textAlignment = NSTextAlignmentCenter;
                tagLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[_mapAnnotations indexOfObject:annotation]+1];
                [annotationView addSubview:tagLabel];
            }
            

            
            // offset the flag annotation so that the flag pole rests on the map coordinate
            annotationView.centerOffset = CGPointMake( annotationView.centerOffset.x + annotationView.image.size.width/2, annotationView.centerOffset.y - annotationView.image.size.height/2 );
            
            return annotationView;
        }
        else
        {
            flagAnnotationView.annotation = annotation;
//            SFAnnotation *myAnn = (SFAnnotation *)annotation;
            
//            NSLog(@"tag = %@",myAnn.tag);
        }
        return flagAnnotationView;
    }
    else if ([annotation isKindOfClass:[CustomMapItem class]])  // for Japanese Tea Garden
    {
        static NSString *TeaGardenAnnotationIdentifier = @"TeaGardenAnnotationIdentifier";
        
        CustomAnnotationView *annotationView =
        (CustomAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:TeaGardenAnnotationIdentifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:TeaGardenAnnotationIdentifier];
            
        }
        
        return annotationView;
    }
    
    return nil;
}

-(void)zoomToFitMapAnnotations:(MKMapView*)aMapView
{
    if([aMapView.annotations count] == 0)
        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(MKPointAnnotation *annotation in _mapView.annotations)
    {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.85; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.85; // Add a little extra space on the sides
    
    region = [aMapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
}

- (void)beginUpdatingLocation
{
    _locationManager.distanceFilter = 1000;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [_locationManager startUpdatingLocation];
    
    self.locationTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(stopUpdatingLocation) userInfo:nil repeats:NO];
}

- (void)stopUpdatingLocation
{
    [_locationManager stopUpdatingLocation];
    [self.locationTimer invalidate];
}

//listen for the new location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation* newLocation = [locations lastObject];
    
    NSTimeInterval age = -[newLocation.timestamp timeIntervalSinceNow];
    
    if (age>120) return; // ignore old (cached) updates
    
    if (newLocation.horizontalAccuracy < 0) return; // ignore invalid updates
    
    // need a valid oldLocation to be able to compute distance
    if (self.oldLocation == nil || self.oldLocation.horizontalAccuracy < 0) {
        self.oldLocation = newLocation;
        return;
    }
    
    //    CLLocationDistance distance = [newLocation distanceFromLocation:_oldLocation];
    
    self.oldLocation = newLocation; // save new location for next time
    
}

- (void)getUserPicture
{
    // Whenever a person opens the app, check for a cached session
    
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
                    _userImage = image;
                     UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 65, 61)];
                     buttonImage.layer.cornerRadius = 5.f;
                     buttonImage.clipsToBounds = YES;
                     buttonImage.image = image;
                     [self.userView addSubview:buttonImage];
                     [self.view addSubview:_userView];
                     
//                     NSLog(@"profile image");
         }
     }];
    
}

- (void)getUserPicture2
{
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.isOpen) {
//        NSLog(@"Found a cached session");
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
//                 NSLog(@"username = %@",user.name);
//                 NSLog(@"user email = %@",[user objectForKey:@"email"]);
                 _userName = user.username;
                 _userFullName = user.name;
                 //                 [self.navigationItem setTitle:_userFullName];
                 _userPicUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", _userName];
//                 NSLog(@"user pic url = %@",_userPicUrl);
                 
                 
             }
         }];
        
        // If there's no cached session, we will show a login button
    } else {
//        NSLog(@"Cannot found a cached session");
        _userEmail = [[KCSUser activeUser] email];
        _userFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
        _usernameLbl.text = _userFullName;
        //        [self.navigationItem setTitle:_userFullName];
        _collectionName1 = @"userPicture";
        _customEndpoint1 = @"NewsFeed";
        _fieldName1 = @"_id";
        _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
                
                NSArray *results_array = [NSArray arrayWithArray:results];
                
                if (results_array && results_array.count) {
                    //                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
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
                            _userImage = image;
                            _userView.image = image;
                            [self.userView.layer setCornerRadius:self.userView.frame.size.width/2];
                            [self.userView setClipsToBounds:YES];
                            [self.view addSubview:_userView];
                            [self.view addSubview:self.usernameLbl];
                            //                        NSLog(@"profile image");
                            
                         }
                     }];
                }
                
            }
        }];
        
    }

}

- (void)getFeaturedRestaurants
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"FeaturedHuntRestaurants" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:_huntTitle];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
//            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            
        } else {
            //got all events back from server -- update table view
//            NSLog(@"featured restaurant = %@",objectsOrNil);
            _featuredRestaurants = [NSArray arrayWithArray:objectsOrNil];
            [self filldishImages];
            [self getFeaturedImages];
            [self addAnnotation];
            
        }
    } withProgressBlock:nil];
}

-(UIColor *) randomColor {
    CGFloat red =  (CGFloat)arc4random() / (CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)arc4random() / (CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)arc4random() / (CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (void)filldishImages
{
    
    for (i=0; i<_featuredRestaurants.count; i++) {
        
        YookaBackend *yooka = _featuredRestaurants[i];
        NSLog(@"Yooka Object = %@",yooka.Restaurant);
        
        y = (count * 70);
        
        new_dish_frame = CGRectMake(0, y, 170, 67);
        
        self.DishView = [[UIView alloc]initWithFrame:new_dish_frame];
        
//        UIColor *color = [self randomColor];
        
//        self.dishName = [[UILabel alloc]initWithFrame:CGRectMake(65, 8, 88, 50)];
//        self.dishName.textColor = [UIColor blackColor];
//        self.dishName.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16.0];
//        self.dishName.textAlignment = NSTextAlignmentLeft;
//        self.dishName.numberOfLines = 0;
//        [self.dishName setText:yooka.Restaurant];
//        self.dishName.adjustsFontSizeToFitWidth = YES;
//        self.dishName.layer.shadowColor = [[UIColor greenColor] CGColor];
//        self.dishName.layer.shadowRadius = 1;
//        self.dishName.layer.shadowOpacity = 1;
//        self.dishName.layer.shadowOffset = CGSizeZero;
//        self.dishName.layer.masksToBounds = NO;
//        [self.DishView addSubview:self.dishName];
        
        self.restaurantName = yooka.Restaurant;
//        if ([_restaurantName length] >= 20) _restaurantName = [_restaurantName substringToIndex:20];
        
//        CGRect rect1 = CGRectMake(22, -12, 70, 70);
//        UIFont * font1 = [UIFont fontWithName:@"Montserrat-Bold" size:18.0f];
//        UIColor * color1 = [UIColor whiteColor];
//        CoreTextArcView * cityLabel = [[CoreTextArcView alloc] initWithFrame:rect1
//                                                                         font:font1
//                                                                         text:restaurantName
//                                                                       radius:30
//                                                                      arcSize:125
//                                                                        color:color1];
        
        GSBorderLabel *cityLabel = [[GSBorderLabel alloc]initWithFrame:CGRectMake(80, 25, 120, 40)];
        cityLabel.backgroundColor = [UIColor clearColor];
        cityLabel.text = [NSString stringWithFormat:@" %@",[self.restaurantName uppercaseString]];
        cityLabel.textColor = [UIColor whiteColor];
        cityLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:12.0f];
        cityLabel.textAlignment = NSTextAlignmentJustified;
        cityLabel.numberOfLines = 0;
        cityLabel.borderColor = [UIColor darkGrayColor];
        cityLabel.borderWidth = 6;
        [self.DishView addSubview:cityLabel];

        self.dishNumber = [[UILabel alloc]initWithFrame:CGRectMake(5, 8, 10, 15)];
        self.dishNumber.textColor = [UIColor blackColor];
        [self.dishNumber setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
        self.dishNumber.text = [NSString stringWithFormat:@"%d",i+1];
        self.dishNumber.textAlignment = NSTextAlignmentLeft;
        self.dishNumber.adjustsFontSizeToFitWidth = YES;
//        self.dishNumber.layer.shadowColor = [[UIColor blackColor] CGColor];
//        self.dishNumber.layer.shadowRadius = 1;
//        self.dishNumber.layer.shadowOpacity = 1;
//        self.dishNumber.layer.shadowOffset = CGSizeMake(0.0, 3.0);
//        self.dishNumber.layer.masksToBounds = NO;
        [self.DishView addSubview:self.dishNumber];
        
//        if (i<_featuredRestaurants.count-1) {
//            UIImageView *white_line = [[UIImageView alloc]initWithFrame:CGRectMake(52, 60, 10, 20)];
//            white_line.image = [UIImage imageNamed:@"whiteline.png"];
//            [self.DishView addSubview:white_line];
//        }
        
        self.dishImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 5, 75, 75)];
//        self.dishImageView.layer.cornerRadius = self.dishImageView.frame.size.height / 2;
        self.dishImageView.clipsToBounds = YES;
        [self.dishImageView setImage:[UIImage imageNamed:@"whitecircle.png"]];
        [self getDishImage:yooka.Restaurant];
        [self.DishView addSubview:self.dishImageView];
        
        UIImageView *dishImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, 73, 73)];
        dishImage2.image = [UIImage imageNamed:@"yookalogo.png"];
        [self.dishImageView addSubview:dishImage2];
        
        self.dishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.dishButton  setFrame:CGRectMake( 0, 5, 100, 65)];
        [self.dishButton setBackgroundColor:[UIColor clearColor]];
        self.dishButton.tag = i;
        [self.dishButton addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
        [self.DishView addSubview:self.dishButton];
        
        [self.dishScrollView addSubview:self.DishView];
        
        size = 67;
        
        count++;
    }

    CGSize content_size = CGSizeMake(100, (size) * count);
    [self.dishScrollView setContentSize:content_size];
    
}

- (void)getFeaturedImages
{
    if (k<_featuredRestaurants.count) {
        YookaBackend *yooka = _featuredRestaurants[k];
//        NSLog(@"Yooka Object = %@",yooka.Restaurant);
        
        y2 = (count2 * 70);
        
        new_dish_frame2 = CGRectMake(0, y2, 170, 67);
        
        self.DishView = [[UIView alloc]initWithFrame:new_dish_frame2];
        
        //        UIColor *color = [self randomColor];
        
//        NSLog(@" email = %@ \n venue = %@",_emailId,yooka.Restaurant);
        _collectionName2 = @"yookaPosts2";
        _customEndpoint2 = @"NewsFeed";
        //        _fieldName2 = @"postDate";
        _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:_emailId,@"userEmail",_huntTitle,@"huntName",yooka.Restaurant,@"venueName",_collectionName2,@"collectionName",_fieldName2,@"fieldName2",nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
                
//                NSLog(@"Results = \n %@",results);
                _objects = [NSMutableArray arrayWithArray:results];
                if (_objects && _objects.count) {
//                    NSString *venue2 = [_objects[0] objectForKey:@"venueName"];
                    NSString *dishUrl = [[_objects[0] objectForKey:@"dishImage"]objectForKey:@"_downloadURL"];
//                    NSLog(@"venue = %@ dishUrl=%@",venue2,dishUrl);
                    
                    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:dishUrl]
                                                                        options:0
                                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
                     {
                         // progression tracking code
                     }
                                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                     {
                         if (image && finished)
                         {
                            NSString *restaurantName = yooka.Restaurant;
                            if ([restaurantName length] >= 20) restaurantName = [restaurantName substringToIndex:20];
                            
                            self.dishImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 5, 75, 75)];
                            //        self.dishImageView.layer.cornerRadius = self.dishImageView.frame.size.height / 2;
                            self.dishImageView.clipsToBounds = YES;
                            [self.dishImageView setImage:[UIImage imageNamed:@"whitecircle.png"]];
                            [self getDishImage:yooka.Restaurant];
                            [self.DishView addSubview:self.dishImageView];
                            
                            UIImageView *dishimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 9, 60, 60)];
                            dishimage2.layer.cornerRadius = dishimage2.frame.size.height / 2;
                            [dishimage2 setContentMode:UIViewContentModeScaleAspectFill];
                            [dishimage2 setClipsToBounds:YES];
                            [dishimage2 setImage:image];
                            [self.dishImageView addSubview:dishimage2];
                            
                            self.dishButton = [UIButton buttonWithType:UIButtonTypeCustom];
                            [self.dishButton  setFrame:CGRectMake( 0, 5, 100, 65)];
                            [self.dishButton setBackgroundColor:[UIColor clearColor]];
                            self.dishButton.tag = k;
                            [self.dishButton addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
                            [self.DishView addSubview:self.dishButton];
                            
                            [self.dishScrollView addSubview:self.DishView];
                            [self.dishScrollView addSubview:self.DishView];
                            
                            NSString *lat = yooka.latitude;
                            NSString *lon = yooka.longitude;
                            NSString *pinTitle = yooka.Restaurant;
                            //        NSLog(@"lat = %@, lon = %@, rest = %@",lat,lon,pinTitle);
                            
                            SFAnnotation *item1 = [[SFAnnotation alloc] init];
                            item1.latitude = lat;
                            item1.longitude = lon;
                            item1.pinTitle = pinTitle;
                            item1.tag = @"1";
                            
                            [self.mapAnnotations replaceObjectAtIndex:k withObject:item1];
                            //                            NSLog(@"map annotation = %@",_mapAnnotations);
                            //                            NSLog(@"item1 = %@",item1.tag);
                            [self.mapView addAnnotations:self.mapAnnotations];
                            
                            
                            size2 = 67;
                            
                            count2++;
                            k++;
                            [self getFeaturedImages];
                            
                         }
                     }];
                    
                    
//                    [[[AsyncImageDownloader alloc] initWithMediaURL:dishUrl successBlock:^(UIImage *image)  {
//                        
//                        NSString *restaurantName = yooka.Restaurant;
//                        if ([restaurantName length] >= 20) restaurantName = [restaurantName substringToIndex:20];
//                        
//                        self.dishImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2, 5, 75, 75)];
//                        //        self.dishImageView.layer.cornerRadius = self.dishImageView.frame.size.height / 2;
//                        self.dishImageView.clipsToBounds = YES;
//                        [self.dishImageView setImage:[UIImage imageNamed:@"whitecircle.png"]];
//                        [self getDishImage:yooka.Restaurant];
//                        [self.DishView addSubview:self.dishImageView];
//                        
//                        UIImageView *dishimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(8, 9, 60, 60)];
//                        dishimage2.layer.cornerRadius = dishimage2.frame.size.height / 2;
//                        [dishimage2 setContentMode:UIViewContentModeScaleAspectFill];
//                        [dishimage2 setClipsToBounds:YES];
//                        [dishimage2 setImage:image];
//                        [self.dishImageView addSubview:dishimage2];
//                        
//                        self.dishButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                        [self.dishButton  setFrame:CGRectMake( 0, 5, 100, 65)];
//                        [self.dishButton setBackgroundColor:[UIColor clearColor]];
//                        self.dishButton.tag = k;
//                        [self.dishButton addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
//                        [self.DishView addSubview:self.dishButton];
//                        
//                        [self.dishScrollView addSubview:self.DishView];
//                        [self.dishScrollView addSubview:self.DishView];
//                        
//                        NSString *lat = yooka.latitude;
//                        NSString *lon = yooka.longitude;
//                        NSString *pinTitle = yooka.Restaurant;
//                        //        NSLog(@"lat = %@, lon = %@, rest = %@",lat,lon,pinTitle);
//                        
//                        SFAnnotation *item1 = [[SFAnnotation alloc] init];
//                        item1.latitude = lat;
//                        item1.longitude = lon;
//                        item1.pinTitle = pinTitle;
//                        item1.tag = @"1";
//                        
//                        [self.mapAnnotations replaceObjectAtIndex:k withObject:item1];
//                        //                            NSLog(@"map annotation = %@",_mapAnnotations);
//                        //                            NSLog(@"item1 = %@",item1.tag);
//                        [self.mapView addAnnotations:self.mapAnnotations];
//                        
//                        
//                        size2 = 67;
//                        
//                        count2++;
//                        k++;
//                        [self getFeaturedImages];
//                    
//                    } failBlock:^(NSError *error) {
//                        NSLog(@"Failed to download image due to %@!", error);
//                    }] startDownload];
                    
                }else{
//                    [self.DishView addSubview:self.dishImageView];
//                    self.dishButton = [UIButton buttonWithType:UIButtonTypeCustom];
//                    [self.dishButton  setFrame:CGRectMake(0, 12, 280, 98)];
//                    [self.dishButton setBackgroundColor:[UIColor clearColor]];
//                    self.dishButton.tag = k;
//                    [self.dishButton addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
//                    [self.DishView addSubview:self.dishButton];
                    
//                    [self.dishScrollView addSubview:self.DishView];
                    size2 = 67;
                    
                    count2++;
                    k++;
                    [self getFeaturedImages];

                }
                
            }else{
                size2 = 67;
                
                count2++;
                k++;
                [self getFeaturedImages];
            }
        }];
        
        
    }
    if (k==_featuredRestaurants.count) {
        
//        NSLog(@"nice try 1 = %lu",(unsigned long)self.dishButton.tag+1);
//        NSLog(@"nice try 2 = %lu",(unsigned long)_featuredRestaurants.count);
        
//        if ([_huntDone isEqualToString:@"YES"]) {
//            [self showPopUp];
//        }


        if ([_huntDone isEqualToString:@"YES"]) {
            
            NSLog(@"nice try");
            
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                if (screenSize.height > 480.0f) {
                    /*Do iPhone 5 stuff here.*/
                    
                    UIImageView *badgeView = [[UIImageView alloc]initWithFrame:CGRectMake(176, 455, 143, 100)];
                    badgeView.image = [UIImage imageNamed:@"badge.png"];
                    badgeView.contentMode = UIViewContentModeScaleAspectFit;
                    [self.view addSubview:badgeView];
                    
                    NSString *logoUrl = _huntImageUrl;
                    
                    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:logoUrl]
                                                                        options:0
                                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
                     {
                         // progression tracking code
                     }
                                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                     {
                         if (image && finished)
                         {
                        UIImageView *badgeView2 = [[UIImageView alloc]initWithFrame:CGRectMake(220, 480, 55, 55)];
                        badgeView2.contentMode = UIViewContentModeScaleAspectFit;
                        badgeView2.image = image;
                        [self.view addSubview:badgeView2];
                        
                        UIImageView *badgeView3 = [[UIImageView alloc]initWithFrame:CGRectMake(215, 517, 72, 27)];
                        badgeView3.contentMode = UIViewContentModeCenter;
                        badgeView3.image = [UIImage imageNamed:@"yooka.png"];
                        UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                        badgeView3.backgroundColor = color;
                        [self.view addSubview:badgeView3];
                        
                        if (_emailId == [KCSUser activeUser].email) {
                            [self showPopUp];
                        }
                        

                        
                             
                         }
                     }];
                    
                } else {
                    /*Do iPhone Classic stuff here.*/
                    
                    UIImageView *badgeView = [[UIImageView alloc]initWithFrame:CGRectMake(176, 365, 143, 100)];
                    badgeView.image = [UIImage imageNamed:@"badge.png"];
                    badgeView.contentMode = UIViewContentModeScaleAspectFit;
                    [self.view addSubview:badgeView];
                    
                    NSString *logoUrl = _huntImageUrl;
                    
                    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:logoUrl]
                                                                        options:0
                                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize)
                     {
                         // progression tracking code
                     }
                                                                      completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                     {
                         if (image && finished)
                         {
                        UIImageView *badgeView2 = [[UIImageView alloc]initWithFrame:CGRectMake(220, 390, 55, 55)];
                        badgeView2.contentMode = UIViewContentModeScaleAspectFit;
                        badgeView2.image = image;
                        [self.view addSubview:badgeView2];
                        
                        UIImageView *badgeView3 = [[UIImageView alloc]initWithFrame:CGRectMake(215, 427, 72, 27)];
                        badgeView3.contentMode = UIViewContentModeCenter;
                        badgeView3.image = [UIImage imageNamed:@"yooka.png"];
                        UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
                        badgeView3.backgroundColor = color;
                        [self.view addSubview:badgeView3];
                        
                        if (_emailId == [KCSUser activeUser].email) {
                            [self showPopUp];
                        }
                        
                    }
                      }];
                    
                }
            } else {
                /*Do iPad stuff here.*/
            }
            
            
            
        }
    }
}


- (void)getDishImage:(NSString*)venue
{
//    NSLog(@" email = %@ \n venue = %@",_emailId,venue);
    _collectionName2 = @"yookaPosts";
    _customEndpoint2 = @"NewsFeed";
    //        _fieldName2 = @"postDate";
    _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:_emailId,@"userEmail",_huntTitle,@"huntName",venue,@"venueName",_collectionName2,@"collectionName",_fieldName2,@"fieldName2",nil];
    
    [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
        if ([results isKindOfClass:[NSArray class]]) {
            
//            NSLog(@"Results = \n %@",results);
            _objects = [NSMutableArray arrayWithArray:results];
            if (_objects && _objects.count) {
                
//                NSString *venue2 = [_objects[0] objectForKey:@"venueName"];
                NSString *dishUrl = [[_objects[0] objectForKey:@"dishImage"]objectForKey:@"_downloadURL"];
//                NSLog(@"venue = %@ dishUrl=%@",venue2,dishUrl);
                [[[AsyncImageDownloader alloc] initWithMediaURL:dishUrl successBlock:^(UIImage *image)  {
                    [self.dishImageView setImage:image];
                } failBlock:^(NSError *error) {
//                    NSLog(@"Failed to download image due to %@!", error);
                }] startDownload];
                
            }
        }else{
            
        }
    }];

}

- (void)gotoRestaurant:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;

    YookaBackend *yooka = _featuredRestaurants[b];
    _selectedRestaurantName = yooka.Restaurant;
    _selectedRestaurant = _featuredRestaurants[b];
    YookaHuntRestaurantViewController *media = [[YookaHuntRestaurantViewController alloc]init];
    media.selectedRestaurant = _selectedRestaurant;
    media.selectedRestaurantName = _selectedRestaurantName;
    media.huntTitle = _huntTitle;
    media.locationId = yooka.location_id;
    media.latitude = yooka.latitude;
    media.longitude = yooka.longitude;
    media.delegate = self;
    media.yookaGreen = _yookaGreen;
    media.yookaGreen2 = _yookaGreen2;
    media.yookaOrange = _yookaOrange;
    media.yookaOrange2 = _yookaOrange2;
    media.venueId = yooka.fsq_venue_id;
    [self.navigationController pushViewController:media animated:YES];
    
}

- (void)gotoPosts:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    YookaBackend *yooka = _featuredRestaurants[b];
    _selectedRestaurantName = yooka.Restaurant;
    _selectedRestaurant = _featuredRestaurants[b];
    YookaPostViewController *media = [[YookaPostViewController alloc]init];
    media.venueID = yooka.fsq_venue_id;
    media.venueSelected = _selectedRestaurantName;
    media.huntName = _huntTitle;
    [Foursquare2 venueGetDetail:yooka.fsq_venue_id callback:^(BOOL success, id result){
        if (success) {
            NSDictionary *dic = result;
            //            NSLog(@"venue data 1 = %@", dic);
            //            NSLog(@"venue data 1 = %@",[dic valueForKeyPath:@"response.venue.hours.timeframes.open.renderedTime"]);
            
            //            NSLog(@"venue data 2 = %@",[dic valueForKeyPath:@"response.venue.location.address"]);
            media.venueAddress = [dic valueForKeyPath:@"response.venue.location.address"];
            //            NSLog(@"venue data 3 = %@",[dic valueForKeyPath:@"response.venue.location.cc"]);
            media.venueCc = [dic valueForKeyPath:@"response.venue.location.cc"];
            //            NSLog(@"venue data 4 = %@",[dic valueForKeyPath:@"response.venue.location.city"]);
            media.venueCity = [dic valueForKeyPath:@"response.venue.location.city"];
            //            NSLog(@"venue data 5 = %@",[dic valueForKeyPath:@"response.venue.location.country"]);
            media.venueCountry = [dic valueForKeyPath:@"response.venue.location.country"];
            //            NSLog(@"venue data 6 = %@",[dic valueForKeyPath:@"response.venue.location.crossStreet"]);
            
            //            NSLog(@"venue data 7 = %@",[dic valueForKeyPath:@"response.venue.location.lat"]);
            media.venuePostalCode = [dic valueForKeyPath:@"response.venue.location.postalCode"];
            //            NSLog(@"venue data 10 = %@",[dic valueForKeyPath:@"response.venue.location.state"]);
            media.venueState = [dic valueForKeyPath:@"response.venue.location.state"];
            
            //            NSString *menus = [dic valueForKeyPath:@"response.menu.menus.count"];
            //            NSLog(@"venue data 2 = %@",menus);
            
            [self.navigationController pushViewController:media animated:YES];
        }

    }];
}

- (void)addAnnotation
{
    self.mapAnnotations = [[NSMutableArray alloc] init];
    
    for (i=0; i<_featuredRestaurants.count; i++) {
        
        YookaBackend *yooka = _featuredRestaurants[i];
        
        NSString *lat = yooka.latitude;
        NSString *lon = yooka.longitude;
        NSString *pinTitle = yooka.Restaurant;
//        NSLog(@"lat = %@, lon = %@, rest = %@",lat,lon,pinTitle);
        SFAnnotation *item1 = [[SFAnnotation alloc] init];
        item1.latitude = lat;
        item1.longitude = lon;
        item1.pinTitle = pinTitle;
        
        [self.mapAnnotations insertObject:item1 atIndex:i];
        
    }
    
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    [self.mapView addAnnotations:self.mapAnnotations];
    [self zoomToFitMapAnnotations:self.mapView];
    
}

- (void)buttonAction1:(id)sender {
    
//    if ([[UIScreen mainScreen] bounds].size.height == 568) {
//        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    
            [self.modalView removeFromSuperview];
            
            _selectedDishes = [NSMutableArray new];
            
            UIButton* button = sender;
            NSUInteger b = button.tag;
            //    NSLog(@"Button pressed %d",b);
            
            YookaBackend *yooka = _featuredRestaurants[b];
            
            _selectedDishes = [NSMutableArray arrayWithArray:yooka.Dishes];
            
            self.modalView = [[UIView alloc] initWithFrame:CGRectMake(85, 115, 225, 350)];
            _modalView.opaque = NO;
            _modalView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.95f];
            [self.view addSubview:_modalView];
            
            [self.view bringSubviewToFront:_modalView];
            
//            UIImageView *modalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 350)];
//            modalImageView.image = [UIImage imageNamed:@"transparentpopupbox.png"];
//            [self.modalView addSubview:modalImageView];
            
            self.restaurantTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 30)];
            self.restaurantTitleLabel.adjustsFontSizeToFitWidth = YES;
            UIFont *font = [UIFont fontWithName:@"Montserrat-Bold" size:18.0];
            self.restaurantTitleLabel.font = font;
            NSString* string1 = [yooka.Restaurant uppercaseString];
            NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:string1];
            [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
//            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];//TextColor
            UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
            NSNumber* underlineNumber = [NSNumber numberWithInteger:NSUnderlineStyleThick];
            [string addAttribute:NSUnderlineStyleAttributeName value:underlineNumber range:NSMakeRange(0, string.length)];
            //Underline color
            [string addAttribute:NSUnderlineColorAttributeName value:color range:NSMakeRange(0, string.length)];
            //TextColor
            self.restaurantTitleLabel. attributedText = string;
            self.restaurantTitleLabel.textColor = [UIColor grayColor];
            self.restaurantTitleLabel.textAlignment = NSTextAlignmentCenter;
            [self.modalView addSubview:self.restaurantTitleLabel];
            
            self.restaurantTitleButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.restaurantTitleButton2 setFrame:CGRectMake(5, 15, 170, 30)];
            [self.restaurantTitleButton2 setBackgroundColor:[UIColor clearColor]];
            self.restaurantTitleButton2.tag = b;
            [self.restaurantTitleButton2 addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView addSubview:self.restaurantTitleButton2];
            
//            self.restaurantTitleButton = [[FUIButton alloc]initWithFrame:CGRectMake(19, 15, 214, 43)];
//            self.restaurantTitleButton.buttonColor = _yookaGreen;
//            self.restaurantTitleButton.shadowColor = _yookaGreen2;
//            self.restaurantTitleButton.shadowHeight = 3.0f;
//            self.restaurantTitleButton.cornerRadius = 6.0f;
//            self.restaurantTitleButton.titleLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16.0];
//            self.restaurantTitleButton.titleLabel.adjustsFontSizeToFitWidth=YES;
//            [self.restaurantTitleButton setTitle:yooka.Restaurant forState:UIControlStateNormal];
//            [self.restaurantTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [self.restaurantTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//            self.restaurantTitleButton.tag = b;
//            [self.restaurantTitleButton addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
//            [self.modalView addSubview:self.restaurantTitleButton];
            
            self.restaurantDescriptionLabel = [[UILabel alloc]init];
            self.restaurantDescriptionLabel.textColor = [UIColor grayColor];
            self.restaurantDescriptionLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12.0];
            self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
            self.restaurantDescriptionLabel.numberOfLines = 0;
            
            CGSize labelSize = CGSizeMake(200, 150);
            CGSize theStringSize = [yooka.RestaurantDescription sizeWithFont:self.restaurantDescriptionLabel.font constrainedToSize:labelSize lineBreakMode:_restaurantDescriptionLabel.lineBreakMode];
            //    NSLog(@"string size = %f %f",theStringSize.width,theStringSize.height);
            
            if (theStringSize.height>80.0) {
                
                _gridScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 43, 205, 90)];
                _gridScrollView.contentSize= self.view.bounds.size;
                [self.modalView addSubview:_gridScrollView];
                [self.gridScrollView setContentSize:CGSizeMake(200, 150)];
                self.gridScrollView.showsHorizontalScrollIndicator = NO;
                self.restaurantDescriptionLabel.frame = CGRectMake(self.restaurantDescriptionLabel.frame.origin.x, _restaurantDescriptionLabel.frame.origin.y, theStringSize.width, theStringSize.height);
                [self.restaurantDescriptionLabel setText:yooka.RestaurantDescription];
                [self.restaurantDescriptionLabel sizeToFit];
                self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                [self.gridScrollView addSubview:self.restaurantDescriptionLabel];
                
            }else{
                
                self.restaurantDescriptionLabel.frame = CGRectMake(10, 43, 205, 90);
                [self.restaurantDescriptionLabel setText:yooka.RestaurantDescription];
                [self.restaurantDescriptionLabel sizeToFit];
                self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                [self.modalView addSubview:self.restaurantDescriptionLabel];
                
            }
            
//            [self.restaurantDescriptionLabel setText:yooka.RestaurantDescription];
//            [self.restaurantDescriptionLabel sizeToFit];
//            self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentJustified;
//            self.restaurantDescriptionLabel.autoresizesSubviews = YES;
//            [self.modalView addSubview:self.restaurantDescriptionLabel];
            
            self.youMight = [[UILabel alloc]initWithFrame:CGRectMake(22.5, 200, 180, 22)];
            self.youMight.adjustsFontSizeToFitWidth = YES;
            self.youMight.text = @"Get This:";
            self.youMight.textColor = [UIColor grayColor];
            self.youMight.textAlignment = NSTextAlignmentCenter;
            self.youMight.font = [UIFont fontWithName:@"Montserrat-Bold" size:12.0];
            self.youMight.autoresizesSubviews = YES;
            self.youMight.clipsToBounds = YES;
            [self.modalView addSubview:self.youMight];
            
            self.dishtableView = [[UITableView alloc]initWithFrame:CGRectMake(10.f, 226.f, 205.f, 191.f)];
            self.dishtableView.delegate = self;
            self.dishtableView.dataSource = self;
            [self.dishtableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
            self.dishtableView.backgroundColor = [UIColor clearColor];
            [self.dishtableView setSeparatorColor:[UIColor clearColor]];
            [self.modalView addSubview:self.dishtableView];
            
//            self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            [self.closeButton  setFrame:CGRectMake(25, 62, 36, 36)];
//            [self.closeButton setBackgroundColor:[UIColor clearColor]];
//            [self.closeButton setImage:[UIImage imageNamed:@"closeoverlay@2x.png"] forState:UIControlStateNormal];
//            [self.closeButton addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
//            [self.tabBarController.view addSubview:self.closeButton];
            
            self.closeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.closeButton2  setFrame:CGRectMake(180, 0, 35, 35)];
            [self.closeButton2 setBackgroundColor:[UIColor clearColor]];
            [self.closeButton2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.closeButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18.0]];
            [self.closeButton2 setTitle:@"X" forState:UIControlStateNormal];
            [self.closeButton2 addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView addSubview:self.closeButton2];
            
            if ([_emailId isEqualToString:_userEmail]) {
                self.uploadButton = [[FUIButton alloc]initWithFrame:CGRectMake(22.5, 160, 180, 30)];
                self.uploadButton.buttonColor = _yookaGreen;
                self.uploadButton.shadowColor = _yookaGreen2;
                self.uploadButton.shadowHeight = 3.0f;
                self.uploadButton.cornerRadius = 6.0f;
                self.uploadButton.titleLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12.0];
                [self.uploadButton setTitle:@"Upload Picture" forState:UIControlStateNormal];
                [self.uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                [self.uploadButton addTarget:self action:@selector(gotoPosts:) forControlEvents:UIControlEventTouchUpInside];
                self.uploadButton.tag = b;
                [self.modalView addSubview:self.uploadButton];
            }
            

            
//        } else {
//            
//            
//        }
//        
//    } else {
//        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//            
//
//            
//        } else {
//            
//
//            
//        }
//        
//    }
    
}

- (void)buttonAction2:(id)sender {
    
//    if ([[UIScreen mainScreen] bounds].size.height == 568) {
//        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    
            [self.modalView removeFromSuperview];
            
            _selectedDishes = [NSMutableArray new];
            
            UIButton* button = sender;
            NSUInteger b = button.tag;
            //    NSLog(@"Button pressed %d",b);
            
            YookaBackend *yooka = _featuredRestaurants[b];
            
            _selectedDishes = [NSMutableArray arrayWithArray:yooka.Dishes];
            
            self.modalView = [[UIView alloc] initWithFrame:CGRectMake(85, 115, 225, 350)];
            _modalView.opaque = NO;
            _modalView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
            [self.view addSubview:_modalView];
            
            [self.view bringSubviewToFront:_modalView];
            
            //            UIImageView *modalImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200, 350)];
            //            modalImageView.image = [UIImage imageNamed:@"transparentpopupbox.png"];
            //            [self.modalView addSubview:modalImageView];
            
            self.restaurantTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 30)];
            self.restaurantTitleLabel.adjustsFontSizeToFitWidth = YES;
            UIFont *font = [UIFont fontWithName:@"Montserrat-Bold" size:18.0];
            self.restaurantTitleLabel.font = font;
            NSString* string1 = [yooka.Restaurant uppercaseString];
            NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:string1];
            [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
            //            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];//TextColor
            UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
            NSNumber* underlineNumber = [NSNumber numberWithInteger:NSUnderlineStyleThick];
            [string addAttribute:NSUnderlineStyleAttributeName value:underlineNumber range:NSMakeRange(0, string.length)];
            //Underline color
            [string addAttribute:NSUnderlineColorAttributeName value:color range:NSMakeRange(0, string.length)];
            //TextColor
            self.restaurantTitleLabel. attributedText = string;
            self.restaurantTitleLabel.textColor = [UIColor grayColor];
            self.restaurantTitleLabel.textAlignment = NSTextAlignmentCenter;
            [self.modalView addSubview:self.restaurantTitleLabel];
            
            self.restaurantTitleButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.restaurantTitleButton2 setFrame:CGRectMake(5, 15, 170, 30)];
            [self.restaurantTitleButton2 setBackgroundColor:[UIColor clearColor]];
            self.restaurantTitleButton2.tag = b;
            [self.restaurantTitleButton2 addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView addSubview:self.restaurantTitleButton2];
            
            //            self.restaurantTitleButton = [[FUIButton alloc]initWithFrame:CGRectMake(19, 15, 214, 43)];
            //            self.restaurantTitleButton.buttonColor = _yookaGreen;
            //            self.restaurantTitleButton.shadowColor = _yookaGreen2;
            //            self.restaurantTitleButton.shadowHeight = 3.0f;
            //            self.restaurantTitleButton.cornerRadius = 6.0f;
            //            self.restaurantTitleButton.titleLabel.font = [UIFont fontWithName:@"Futura-CondensedExtraBold" size:16.0];
            //            self.restaurantTitleButton.titleLabel.adjustsFontSizeToFitWidth=YES;
            //            [self.restaurantTitleButton setTitle:yooka.Restaurant forState:UIControlStateNormal];
            //            [self.restaurantTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //            [self.restaurantTitleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
            //            self.restaurantTitleButton.tag = b;
            //            [self.restaurantTitleButton addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
            //            [self.modalView addSubview:self.restaurantTitleButton];
            
            self.restaurantDescriptionLabel = [[UILabel alloc]init];
            self.restaurantDescriptionLabel.textColor = [UIColor grayColor];
            self.restaurantDescriptionLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:12.0];
            self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
            self.restaurantDescriptionLabel.numberOfLines = 0;
            
            CGSize labelSize = CGSizeMake(200, 150);
            CGSize theStringSize = [yooka.RestaurantDescription sizeWithFont:self.restaurantDescriptionLabel.font constrainedToSize:labelSize lineBreakMode:_restaurantDescriptionLabel.lineBreakMode];
            //    NSLog(@"string size = %f %f",theStringSize.width,theStringSize.height);
            
            if (theStringSize.height>80.0) {
                
                _gridScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 43, 205, 90)];
                _gridScrollView.contentSize= self.view.bounds.size;
                [self.modalView addSubview:_gridScrollView];
                [self.gridScrollView setContentSize:CGSizeMake(200, 150)];
                self.gridScrollView.showsHorizontalScrollIndicator = NO;
                self.restaurantDescriptionLabel.frame = CGRectMake(self.restaurantDescriptionLabel.frame.origin.x, _restaurantDescriptionLabel.frame.origin.y, theStringSize.width, theStringSize.height);
                [self.restaurantDescriptionLabel setText:yooka.RestaurantDescription];
                [self.restaurantDescriptionLabel sizeToFit];
                self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                [self.gridScrollView addSubview:self.restaurantDescriptionLabel];
                
            }else{
                
                self.restaurantDescriptionLabel.frame = CGRectMake(10, 43, 205, 90);
                [self.restaurantDescriptionLabel setText:yooka.RestaurantDescription];
                [self.restaurantDescriptionLabel sizeToFit];
                self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                [self.modalView addSubview:self.restaurantDescriptionLabel];
                
            }
            
            self.youMight = [[UILabel alloc]initWithFrame:CGRectMake(22.5, 200, 180, 22)];
            self.youMight.adjustsFontSizeToFitWidth = YES;
            self.youMight.text = @"Get This:";
            self.youMight.textColor = [UIColor grayColor];
            self.youMight.textAlignment = NSTextAlignmentCenter;
            self.youMight.font = [UIFont fontWithName:@"Montserrat-Bold" size:12.0];
            self.youMight.autoresizesSubviews = YES;
            self.youMight.clipsToBounds = YES;
            [self.modalView addSubview:self.youMight];
            
            self.dishtableView = [[UITableView alloc]initWithFrame:CGRectMake(10.f, 226.f, 205.f, 191.f)];
            self.dishtableView.delegate = self;
            self.dishtableView.dataSource = self;
            [self.dishtableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
            self.dishtableView.backgroundColor = [UIColor clearColor];
            [self.dishtableView setSeparatorColor:[UIColor clearColor]];
            [self.modalView addSubview:self.dishtableView];
            
            self.closeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.closeButton2  setFrame:CGRectMake(180, 0, 35, 35)];
            [self.closeButton2 setBackgroundColor:[UIColor clearColor]];
            [self.closeButton2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [self.closeButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18.0]];
            [self.closeButton2 setTitle:@"X" forState:UIControlStateNormal];
            [self.closeButton2 addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView addSubview:self.closeButton2];
            
//        } else {
//            
//            
//            
//        }
//        
//    } else {
//        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//            
//            
//            
//        } else {
//            
//            
//            
//        }
//        
//    }
    
}

- (void)gotoRestaurant2:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    YookaBackend *yooka = _featuredRestaurants[b];
    _selectedRestaurantName = yooka.Restaurant;
    _selectedRestaurant = _featuredRestaurants[b];
    YookaHuntRestaurantViewController *media = [[YookaHuntRestaurantViewController alloc]init];
    media.selectedRestaurant = _selectedRestaurant;
    media.selectedRestaurantName = _selectedRestaurantName;
    media.huntTitle = _huntTitle;
    media.locationId = yooka.location_id;
    media.latitude = yooka.latitude;
    media.longitude = yooka.longitude;
    media.delegate = self;
    media.yookaGreen = _yookaGreen;
    media.yookaGreen2 = _yookaGreen2;
    media.yookaOrange = _yookaOrange;
    media.yookaOrange2 = _yookaOrange2;
    media.subscribed = @"subscribed";
    media.venueId = yooka.fsq_venue_id;
    [self.navigationController pushViewController:media animated:YES];
}

- (void)uploadBtnTouched:(id)sender
{
    
}

- (void)closeBtn
{
//    NSLog(@"close modal view");
    [self.modalView removeFromSuperview];
    [self.closeButton2 removeFromSuperview];
    [self.dishButton setEnabled:YES];
    [self.dishScrollView setUserInteractionEnabled:YES];

}

- (void)closeBtn2
{
    NSLog(@"close modal view");
    [self.modalView2 removeFromSuperview];
}

-(void)sendrestaurantDataToA:(NSString *)selectedHunt
{
//        NSLog(@"hunt %@",_huntTitle);
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedDishes) {
        return self.selectedDishes.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.dishtableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        // create a custom label:                                        x    y   width  height
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 205.0, 15.0)];
        [_descriptionLabel setTag:1];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        _descriptionLabel.textColor = [UIColor grayColor];
        _descriptionLabel.textAlignment = NSTextAlignmentCenter;
        [_descriptionLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:_descriptionLabel];
        
    }
    
    [(UILabel *)[cell.contentView viewWithTag:1] setText:self.selectedDishes[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.lastSelected==indexPath) return; // nothing to do
    //
    //    // deselect old
    //    UITableViewCell *old = [locationTableView cellForRowAtIndexPath:self.lastSelected];
    //    old.accessoryType = UITableViewCellAccessoryNone;
    //    old.backgroundColor = [UIColor blackColor];
    //    [old setSelected:FALSE animated:TRUE];
    //
    //    // select new
    //    UITableViewCell *cell = [locationTableView cellForRowAtIndexPath:indexPath];
    //    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    //    cell.backgroundColor = [UIColor purpleColor];
    //    [cell setSelected:TRUE animated:TRUE];
    
    
    // keep track of the last selected cell
//    self.lastSelected = indexPath;
//    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.dishtableView reloadData];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonClicked:(UIGestureRecognizer *)sender
{
//    UIView *button = sender.view;
    if([_tapTag isEqualToString:@"YES"])
    {
        // Do something to animate out to reveal the entire image
       _tapTag = @"NO";
        [self.navigationController setNavigationBarHidden:NO];
    }
    else if([_tapTag isEqualToString:@"NO"])
    {
        // Do something else to animate back to its original location
        _tapTag = @"YES";
        [self.navigationController setNavigationBarHidden:YES];

    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
