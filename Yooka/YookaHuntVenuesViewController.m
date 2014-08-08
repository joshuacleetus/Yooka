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
#import "Foursquare2.h"
#import "YookaRestaurantViewController.h"
#import "YookaFeaturedHuntViewController.h"
#import "UIImage+Scale.h"
#import "UIImage+Crop.h"
#import "UIImage+Screenshot.h"

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

- (void)loadView
{
    [super loadView];
    
    _yookaGreen   = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    _yookaGreen2  = [UIColor colorWithRed:83/255.0f green:154/255.0f blue:142/255.0f alpha:1.0f];
    _yookaOrange  = [UIColor colorWithRed:245/255.0f green:135/255.0f blue:77/255.0f alpha:1.0f];
    _yookaOrange2 = [UIColor colorWithRed:221/255.0f green:117/255.0f blue:62/255.0f alpha:1.0f];
    
    contentSize = 350;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _huntDict1 = [defaults objectForKey:@"huntCount"];
    _hunt_count = [_huntDict1 objectForKey:_huntTitle];
    _locationNameDict = [defaults objectForKey:@"huntLocations"];
    NSLog(@"hunt dict = %@",[_locationNameDict objectForKey:_huntTitle]);
    NSLog(@"email = %@",_emailId);
    NSLog(@"email 2 = %@",_userEmail);
    
   if(self.presentingViewController.presentedViewController == self) {
        NSLog(@"presenting view = %@",self.presentingViewController);
       if ([self.presentingViewController isKindOfClass:[YookaFeaturedHuntViewController class]]) {
           NSLog(@"yes");
       }else{
           NSLog(@"no");
       }
   }else{
       NSLog(@"not presented view");
   }
    
    NSLog(@"finished venues= = %@",_finishedHuntVenues);

}

-(void) dealloc
{
    NSLog(@"- TEST dealloc()");
}

-(void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    //NSLog(@"swipe left");
}

-(void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    //Do what you want here
    //NSLog(@"swipe right");
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)showPopUp
{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (isiPhone5) {
            
            /*Do iPhone 5 stuff here.*/
            self.modalView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 586)];
            _modalView2.opaque = NO;
            _modalView2.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.85f];
            _modalView2.tag = 101;
            [self.view addSubview:_modalView2];
            
            [self.view bringSubviewToFront:_modalView2];
            
            UIImageView *purpleBg = [[UIImageView alloc]initWithFrame:CGRectMake(40, 85, 240, 400)];
            purpleBg.image = [UIImage imageNamed:@"postcard.jpg"];
            [self.modalView2 addSubview:purpleBg];
            
            UIImageView *x_box = [[UIImageView alloc]initWithFrame:CGRectMake(240, 95, 34, 34)];
            x_box.image = [UIImage imageNamed:@"x-box.png"];
            [self.modalView2 addSubview:x_box];
            
            UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [closeBtn  setFrame:CGRectMake(240, 95, 34, 34)];
            [closeBtn setBackgroundColor:[UIColor clearColor]];
            [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [closeBtn.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:17.0]];
            [closeBtn setTitle:@"X" forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(closeBtn2) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView2 addSubview:closeBtn];
            
            UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(71, 342, 185, 16)];
            label6.text = @"YOU'VE COMPLETED";
            label6.font = [UIFont fontWithName:@"OpenSans" size:17.f];
            label6.textColor = [UIColor whiteColor];
            [self.modalView2 addSubview:label6];
            
            UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(117, 361, 93, 16)];
            label7.text = @"THE HUNT";
            label7.font = [UIFont fontWithName:@"OpenSans" size:17.f];
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
            label8.font = [UIFont fontWithName:@"OpenSans" size:17.f];
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
            [closeBtn.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:17.0]];
            [closeBtn setTitle:@"X" forState:UIControlStateNormal];
            [closeBtn addTarget:self action:@selector(closeBtn2) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView2 addSubview:closeBtn];
            
            UIImageView *chatbubble = [[UIImageView alloc]initWithFrame:CGRectMake(95, 52, 132, 123)];
            chatbubble.image = [UIImage imageNamed:@"chatbubble.png"];
            [self.modalView2 addSubview:chatbubble];
            
            UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(150, 82, 75, 12)];
            label1.text = @"GOOD JOB!";
            label1.font = [UIFont fontWithName:@"OpenSans" size:12.f];
            label1.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(105, 58, 125, 26)];
            label2.text = @"HURRAY";
            label2.font = [UIFont fontWithName:@"OpenSans" size:26.f];
            label2.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label2];
            
            UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(103, 105, 76, 12)];
            label3.text = @"WAY TO GO!";
            label3.font = [UIFont fontWithName:@"OpenSans" size:12.f];
            label3.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label3];
            
            UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(180, 108, 45, 7)];
            label4.text = @"YOU DID IT";
            label4.font = [UIFont fontWithName:@"OpenSans" size:7.f];
            label4.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label4];
            
            UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(138, 120, 85, 15)];
            label5.text = @"AWESOME";
            label5.font = [UIFont fontWithName:@"OpenSans" size:15.f];
            label5.textColor = [UIColor purpleColor];
            [self.modalView2 addSubview:label5];
            
            UIImageView *badgeView = [[UIImageView alloc]initWithFrame:CGRectMake(86, 175, 143, 100)];
            badgeView.image = [UIImage imageNamed:@"badge.png"];
            badgeView.contentMode = UIViewContentModeScaleAspectFit;
            [self.modalView2 addSubview:badgeView];
            
            NSString *logoUrl = _huntImageUrl;
            
//            UIImageView *badgeView2 = [[UIImageView alloc]initWithFrame:CGRectMake(130, 200, 55, 55)];
//            badgeView2.contentMode = UIViewContentModeScaleAspectFit;
//            [badgeView2 setImageWithURL:[NSURL URLWithString:logoUrl]
//                           placeholderImage:nil
//                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                      
//                                      UIImageView *badgeView3 = [[UIImageView alloc]initWithFrame:CGRectMake(125, 237, 72, 27)];
//                                      badgeView3.contentMode = UIViewContentModeCenter;
//                                      badgeView3.image = [UIImage imageNamed:@"yooka.png"];
//                                      UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
//                                      badgeView3.backgroundColor = color;
//                                      [self.modalView2 addSubview:badgeView3];
//                                      
//                                  }];
//            [self.modalView2 addSubview:badgeView2];
            
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadWithURL:[NSURL URLWithString:logoUrl]
                             options:0
                            progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 // progression tracking code
             }
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
             {
                 if (image)
                 {
                     // do something with image
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

                 }
             }];

//            [[[AsyncImageDownloader alloc] initWithMediaURL:logoUrl successBlock:^(UIImage *image)  {
//                
//                UIImageView *badgeView2 = [[UIImageView alloc]initWithFrame:CGRectMake(130, 200, 55, 55)];
//                badgeView2.contentMode = UIViewContentModeScaleAspectFit;
//                badgeView2.image = image;
//                [self.modalView2 addSubview:badgeView2];
//                
//                UIImageView *badgeView3 = [[UIImageView alloc]initWithFrame:CGRectMake(125, 237, 72, 27)];
//                badgeView3.contentMode = UIViewContentModeCenter;
//                badgeView3.image = [UIImage imageNamed:@"yooka.png"];
//                UIColor *color = [UIColor colorWithRed:240/255.0f green:119/255.0f blue:36/255.0f alpha:1.0f];
//                badgeView3.backgroundColor = color;
//                [self.modalView2 addSubview:badgeView3];
//
//            } failBlock:^(NSError *error) {
//                //        NSLog(@"Failed to download image due to %@!", error);
//            }] startDownload];
            
            UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(71, 292, 185, 16)];
            label6.text = @"YOU'VE COMPLETED";
            label6.font = [UIFont fontWithName:@"OpenSans" size:17.f];
            label6.textColor = [UIColor whiteColor];
            [self.modalView2 addSubview:label6];
            
            UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(117, 321, 93, 16)];
            label7.text = @"THE HUNT";
            label7.font = [UIFont fontWithName:@"OpenSans" size:17.f];
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
            label8.font = [UIFont fontWithName:@"OpenSans" size:17.f];
            label8.textColor = [UIColor whiteColor];
            [self.modalView2 addSubview:label8];
        }
    } else {
        /*Do iPad stuff here.*/
    }
        
}

- (void)fbBtnTouched:(id)sender
{
        // Whenever a person opens the app, check for a cached session
                                                       
//                                                       CGSize imageSize = CGSizeMake(230, 155);
//                                                       if (NULL != UIGraphicsBeginImageContextWithOptions)
//                                                           UIGraphicsBeginImageContextWithOptions(imageSize, YES, 1.0);
//                                                       else
//                                                           UIGraphicsBeginImageContext(imageSize);
//                                                       
//                                                       CGContextRef context = UIGraphicsGetCurrentContext();
//                                                       
//                                                       // Iterate over every window from back to front
//                                                       for (UIWindow *window in [[UIApplication sharedApplication] windows])
//                                                       {
//                                                           if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
//                                                           {
//                                                               // -renderInContext: renders in the coordinate space of the layer,
//                                                               // so we must first apply the layer's geometry to the graphics context
//                                                               CGContextSaveGState(context);
//                                                               // Center the context around the window's anchor point
//                                                               CGContextTranslateCTM(context, [window center].x, [window center].y);
//                                                               // Apply the window's transform about the anchor point
//                                                               CGContextConcatCTM(context, [window transform]);
//                                                               // Offset by the portion of the bounds left of and above the anchor point
//                                                               CGContextTranslateCTM(context,
//                                                                                     -[window bounds].size.width * [[window layer] anchorPoint].x-42,
//                                                                                     (-[window bounds].size.height * [[window layer] anchorPoint].y)-212);
//                                                               
//                                                               // Render the layer hierarchy to the current context
//                                                               [[window layer] renderInContext:context];
//                                                               
//                                                               // Restore the context
//                                                               CGContextRestoreGState(context);
//                                                           }
//                                                       }
//                                                       

//                                                       //    NSString *mystring = @"My most popular Instagram #selfie photo via BeUrSelfie app. Now available in app store: \nhttps://itunes.apple.com/us/app/beurselfie/id732458094?ls=1&mt=8";
//                                                       // Retrieve the screenshot image
//
//                                                       UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//                                                       
//                                                       UIGraphicsEndImageContext();
//    
    
    UIImage *image = [UIImage screenshot];
    
    UIImage *imageToCrop = image;
    CGRect cropRect = CGRectMake(0, 150, 320, 427/2);
    
    UIImage *croppedImage = [imageToCrop crop:cropRect];
    
    UIImage *scaledImage = [croppedImage scaleToSize:CGSizeMake(640, 427)];

    
    NSString *mystring = @"I just finished this hunt! \nYooka app available in app store";
    
    // if we're not on iOS 6, SLComposeViewController won't be available. Then fallback on website.
    Class composeViewControllerClass = [SLComposeViewController class];
    
    if(composeViewControllerClass == nil || ![composeViewControllerClass isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        
    } else {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:mystring];
        [controller addURL:[NSURL URLWithString:@"http://www.getyooka.com"]];
        [controller addImage:scaledImage];

        [self presentViewController:controller animated:YES completion:Nil];
    }

//    }
}

// A function for parsing URL parameters returned by the Feed Dialog.
//- (NSDictionary*)parseURLParams:(NSString *)query {
//    NSArray *pairs = [query componentsSeparatedByString:@"&"];
//    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//    for (NSString *pair in pairs) {
//        NSArray *kv = [pair componentsSeparatedByString:@"="];
//        NSString *val =
//        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        params[kv[0]] = val;
//    }
//    return params;
//}

- (void)twitterBtnTouched:(id)sender
{
    //NSLog(@"twitter btn");
    
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
        NSString *mystring = @"I just finished this hunt! \nYooka app available in app store";
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
    //NSLog(@"insta btn");
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
    NSString *mystring = @"I just finished this hunt! \nYooka app available in app store";
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
    
    //NSLog(@"image saved");
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIGraphicsEndImageContext();
    NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
    //NSLog(@"jpg path %@",jpgPath);
    NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath]; //[[NSString alloc] initWithFormat:@"file://%@", jpgPath] ];
    //NSLog(@"with File path %@",newJpgPath);
    NSURL *igImageHookFile = [[NSURL alloc] initFileURLWithPath:newJpgPath];
    //NSLog(@"url Path %@",igImageHookFile);
    
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
    //NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

- (void)tumblrBtnTouched:(id)sender
{
    //NSLog(@"tumblr btn");
}

- (void)pinterestBtnTouched:(id)sender
{
    //NSLog(@"pinterest btn");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    k=0;
    p=0;
    count = 0,size=0;
    count2 = 0,size2=0;
    i=0, y= 0;
    y2=0;
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        _featuredRestaurants = [NSMutableArray new];
        
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        [[self navigationController] setNavigationBarHidden:YES animated:NO];
        
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
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (INTERFACE_IS_PHONE) {
            if (screenSize.height > 480.0f) {
                
                self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 60, 400, 600)];
                //Always center the dot and zoom in to an apropriate zoom level when position changes
                //        [_mapView setUserTrackingMode:MKUserTrackingModeFollow];
                self.mapView.delegate = self;
                
                // set Span
                // start off by default in San Francisco
                MKCoordinateRegion newRegion;
                newRegion.center.latitude = _currentLocation.coordinate.latitude;
                newRegion.center.longitude = _currentLocation.coordinate.longitude;
                
                //    NSLog(@"%f",_currentLocation.coordinate.latitude);
                //    NSLog(@"%f",_currentLocation.coordinate.longitude);
                //    newRegion.center.latitude = [_latitude doubleValue];
                //    newRegion.center.longitude = [_longitude doubleValue];
                
                newRegion.span.latitudeDelta = 0.122872;
                newRegion.span.longitudeDelta = 0.119863;
                
                [self.mapView setRegion:newRegion animated:YES];
                [self.mapView setShowsUserLocation:YES];
                [self.view addSubview:_mapView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(buttonClicked:)];
                _tapTag = @"YES";
                [self.view addGestureRecognizer:tap];
                
                _featuredRestaurants = [NSArray new];
                _selectedRestaurant = [NSMutableArray new];
                
                self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.menuBtn setFrame:CGRectMake(0, 225, 320, 60)];
                [self.menuBtn setTitle:nil forState:UIControlStateNormal];
                [self.menuBtn addTarget:self action:@selector(checkedMenu:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [self.menuBtn setBackgroundColor:[UIColor whiteColor]];
                [self.view addSubview:self.menuBtn];
                
                self.menuBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.menuBtn2 setFrame:CGRectMake(0, 508, 320, 60)];
                [self.menuBtn2 setTitle:nil forState:UIControlStateNormal];
                [self.menuBtn2 addTarget:self action:@selector(checkedMenu2:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [self.menuBtn2 setBackgroundColor:[UIColor whiteColor]];
                [self.view addSubview:self.menuBtn2];
                
                [self.menuBtn2 setHidden:YES];
                
                self.huntTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 65, 20, 190, 20)];
                self.huntTitleLabel.text = [_huntTitle uppercaseString];
                self.huntTitleLabel.textColor = [UIColor lightGrayColor];
                self.huntTitleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0];
                self.huntTitleLabel.adjustsFontSizeToFitWidth = YES;
                self.huntTitleLabel.textAlignment = NSTextAlignmentCenter;
                //    self.huntTitleLabel.numberOfLines = 0;
                [self.huntTitleLabel setBackgroundColor:[UIColor clearColor]];
                [self.menuBtn addSubview:self.huntTitleLabel];
                
                self.huntTitleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake( 65, 20, 190, 20)];
                self.huntTitleLabel2.text = [_huntTitle uppercaseString];
                self.huntTitleLabel2.textColor = [UIColor lightGrayColor];
                self.huntTitleLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0];
                self.huntTitleLabel2.adjustsFontSizeToFitWidth = YES;
                self.huntTitleLabel2.textAlignment = NSTextAlignmentCenter;
                //    self.huntTitleLabel2.numberOfLines = 0;
                [self.huntTitleLabel2 setBackgroundColor:[UIColor clearColor]];
                [self.menuBtn2 addSubview:self.huntTitleLabel2];
                
                self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 11, 37, 37)];
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
                [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
                [self.profileImageView setClipsToBounds:YES];
                [self.profileImageView setBackgroundColor:[UIColor whiteColor]];
                [self.menuBtn addSubview:self.profileImageView];
                
                UIImageView *gray_line = [[UIImageView alloc]initWithFrame:CGRectMake(65, 0, 1, 60)];
                [gray_line setBackgroundColor:[self colorWithHexString:@"f4f4f4"]];
                [self.menuBtn addSubview:gray_line];
                
                UIImageView *blue_bg = [[UIImageView alloc]initWithFrame:CGRectMake(260, 0, 60, 60)];
                [blue_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
                [self.menuBtn addSubview:blue_bg];
                
                self.profileImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(14, 11, 37, 37)];
                self.profileImageView2.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
                [self.profileImageView2 setContentMode:UIViewContentModeScaleAspectFill];
                [self.profileImageView2 setClipsToBounds:YES];
                [self.profileImageView2 setBackgroundColor:[UIColor whiteColor]];
                [self.menuBtn2 addSubview:self.profileImageView2];
                
                UIImageView *gray_line_2 = [[UIImageView alloc]initWithFrame:CGRectMake(65, 0, 1, 60)];
                [gray_line_2 setBackgroundColor:[self colorWithHexString:@"f4f4f4"]];
                [self.menuBtn2 addSubview:gray_line_2];
                
                UIImageView *blue_bg_2 = [[UIImageView alloc]initWithFrame: CGRectMake(260, 0, 60, 60)];
                [blue_bg_2 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
                [self.menuBtn2 addSubview:blue_bg_2];
                
                if ([self.emailId isEqualToString:[KCSUser activeUser].email]) {
                    
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    NSData* imageData = [ud objectForKey:@"MyProfilePic"];
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    if (image) {
                        
                        [self.profileImageView setImage:image];
                        [self.profileImageView2 setImage:image];
                        
                        
                    }else{
                        
                        [self getUserImage];
                        
                    }
                    
                }else{
                    
                    [self getUserImage];
                    
                }
                
                
                CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, 329.f);
                
                self.restaurantScrollView = [[UIScrollView alloc] initWithFrame:screenRect];
                self.restaurantScrollView.contentSize= self.view.bounds.size;
                self.restaurantScrollView.frame = CGRectMake(0.f, 285.f, 320.f, self.restaurantScrollView.frame.size.height);
                [self.restaurantScrollView setContentSize:CGSizeMake(320, contentSize)];
                [self.restaurantScrollView setBackgroundColor:[self colorWithHexString:@"f0f0f0"]];
                [self.view addSubview:self.restaurantScrollView];
                
                [self getFeaturedRestaurants];
                
                [self getHuntCount];
                
                UIImageView *top_blue_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
                [top_blue_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
                //[self.gridScrollView addSubview:top_blue_bg];
                [self.view addSubview:top_blue_bg];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
                titleLabel.textColor = [UIColor whiteColor];
                [titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:15]];
                titleLabel.text = [NSString stringWithFormat:@"MAP"];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.backgroundColor = [UIColor clearColor];
                [self.view addSubview:titleLabel];
                
                _backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
                _backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
                [self.view addSubview:_backBtnImage];
                
                _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_backBtn setFrame:CGRectMake(0, 0, 60, 60)];
                [_backBtn setTitle:@"" forState:UIControlStateNormal];
                [_backBtn setBackgroundColor:[UIColor clearColor]];
                //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:_backBtn];
                
                //    [self showPopUp];
                
            }
            else{
                
                self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 60, 400, 600)];
                //Always center the dot and zoom in to an apropriate zoom level when position changes
                //        [_mapView setUserTrackingMode:MKUserTrackingModeFollow];
                self.mapView.delegate = self;
                
                // set Span
                // start off by default in San Francisco
                MKCoordinateRegion newRegion;
                newRegion.center.latitude = _currentLocation.coordinate.latitude;
                newRegion.center.longitude = _currentLocation.coordinate.longitude;
                
                //    NSLog(@"%f",_currentLocation.coordinate.latitude);
                //    NSLog(@"%f",_currentLocation.coordinate.longitude);
                //    newRegion.center.latitude = [_latitude doubleValue];
                //    newRegion.center.longitude = [_longitude doubleValue];
                
                newRegion.span.latitudeDelta = 0.122872;
                newRegion.span.longitudeDelta = 0.119863;
                
                [self.mapView setRegion:newRegion animated:YES];
                [self.mapView setShowsUserLocation:YES];
                [self.view addSubview:_mapView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(buttonClicked:)];
                _tapTag = @"YES";
                [self.view addGestureRecognizer:tap];
                
                _featuredRestaurants = [NSArray new];
                _selectedRestaurant = [NSMutableArray new];
                
                self.menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.menuBtn setFrame:CGRectMake(0, 225, 320, 60)];
                [self.menuBtn setTitle:nil forState:UIControlStateNormal];
                [self.menuBtn addTarget:self action:@selector(checkedMenu:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [self.menuBtn setBackgroundColor:[UIColor whiteColor]];
                [self.view addSubview:self.menuBtn];
                
                self.menuBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.menuBtn2 setFrame:CGRectMake(0, 508, 320, 60)];
                [self.menuBtn2 setTitle:nil forState:UIControlStateNormal];
                [self.menuBtn2 addTarget:self action:@selector(checkedMenu2:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
                [self.menuBtn2 setBackgroundColor:[UIColor whiteColor]];
                [self.view addSubview:self.menuBtn2];
                
                [self.menuBtn2 setHidden:YES];
                
                self.huntTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 65, 20, 190, 20)];
                self.huntTitleLabel.text = [_huntTitle uppercaseString];
                self.huntTitleLabel.textColor = [UIColor lightGrayColor];
                self.huntTitleLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0];
                self.huntTitleLabel.adjustsFontSizeToFitWidth = YES;
                self.huntTitleLabel.textAlignment = NSTextAlignmentCenter;
                //    self.huntTitleLabel.numberOfLines = 0;
                [self.huntTitleLabel setBackgroundColor:[UIColor clearColor]];
                [self.menuBtn addSubview:self.huntTitleLabel];
                
                self.huntTitleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake( 65, 20, 190, 20)];
                self.huntTitleLabel2.text = [_huntTitle uppercaseString];
                self.huntTitleLabel2.textColor = [UIColor lightGrayColor];
                self.huntTitleLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0];
                self.huntTitleLabel2.adjustsFontSizeToFitWidth = YES;
                self.huntTitleLabel2.textAlignment = NSTextAlignmentCenter;
                //    self.huntTitleLabel2.numberOfLines = 0;
                [self.huntTitleLabel2 setBackgroundColor:[UIColor clearColor]];
                [self.menuBtn2 addSubview:self.huntTitleLabel2];
                
                self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(14, 11, 37, 37)];
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
                [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
                [self.profileImageView setClipsToBounds:YES];
                [self.profileImageView setBackgroundColor:[UIColor whiteColor]];
                [self.menuBtn addSubview:self.profileImageView];
                
                UIImageView *gray_line = [[UIImageView alloc]initWithFrame:CGRectMake(65, 0, 1, 60)];
                [gray_line setBackgroundColor:[self colorWithHexString:@"f4f4f4"]];
                [self.menuBtn addSubview:gray_line];
                
                UIImageView *blue_bg = [[UIImageView alloc]initWithFrame:CGRectMake(260, 0, 60, 60)];
                [blue_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
                [self.menuBtn addSubview:blue_bg];
                
                self.profileImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(14, 11, 37, 37)];
                self.profileImageView2.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
                [self.profileImageView2 setContentMode:UIViewContentModeScaleAspectFill];
                [self.profileImageView2 setClipsToBounds:YES];
                [self.profileImageView2 setBackgroundColor:[UIColor whiteColor]];
                [self.menuBtn2 addSubview:self.profileImageView2];
                
                UIImageView *gray_line_2 = [[UIImageView alloc]initWithFrame:CGRectMake(65, 0, 1, 60)];
                [gray_line_2 setBackgroundColor:[self colorWithHexString:@"f4f4f4"]];
                [self.menuBtn2 addSubview:gray_line_2];
                
                UIImageView *blue_bg_2 = [[UIImageView alloc]initWithFrame: CGRectMake(260, 0, 60, 60)];
                [blue_bg_2 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
                [self.menuBtn2 addSubview:blue_bg_2];
                
                if ([self.emailId isEqualToString:[KCSUser activeUser].email]) {
                    
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    NSData* imageData = [ud objectForKey:@"MyProfilePic"];
                    UIImage *image = [UIImage imageWithData:imageData];
                    
                    if (image) {
                        
                        [self.profileImageView setImage:image];
                        [self.profileImageView2 setImage:image];
                        
                        
                    }else{
                        
                        [self getUserImage];
                        
                    }
                    
                }else{
                    
                    [self getUserImage];
                    
                }
                
                
                CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, 329.f-88);
                
                self.restaurantScrollView = [[UIScrollView alloc] initWithFrame:screenRect];
                self.restaurantScrollView.contentSize= self.view.bounds.size;
                self.restaurantScrollView.frame = CGRectMake(0.f, 285.f, 320.f, self.restaurantScrollView.frame.size.height);
                [self.restaurantScrollView setContentSize:CGSizeMake(320, contentSize)];
                [self.restaurantScrollView setBackgroundColor:[self colorWithHexString:@"f0f0f0"]];
                [self.view addSubview:self.restaurantScrollView];
                
                [self getFeaturedRestaurants];
                
                [self getHuntCount];
                
                UIImageView *top_blue_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
                [top_blue_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
                //[self.gridScrollView addSubview:top_blue_bg];
                [self.view addSubview:top_blue_bg];
                
                UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
                titleLabel.textColor = [UIColor whiteColor];
                [titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:15]];
                titleLabel.text = [NSString stringWithFormat:@"MAP"];
                titleLabel.textAlignment = NSTextAlignmentCenter;
                titleLabel.backgroundColor = [UIColor clearColor];
                [self.view addSubview:titleLabel];
                
                _backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
                _backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
                [self.view addSubview:_backBtnImage];
                
                _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [_backBtn setFrame:CGRectMake(0, 0, 60, 60)];
                [_backBtn setTitle:@"" forState:UIControlStateNormal];
                [_backBtn setBackgroundColor:[UIColor clearColor]];
                //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:_backBtn];
                
                
            }
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

- (void)back
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    // NSLog(@"%s: controller.view.window=%@", _func_, controller.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    if ([self.presentingViewController isKindOfClass:[YookaFeaturedHuntViewController class]]) {
        NSLog(@"yes");
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES
                                                                                   completion:^{ // Do something on completion
                                                                                   }];
    }else{
        NSLog(@"no");
        [self dismissViewControllerAnimated:NO completion:nil];
        
    }
    

}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)checkedMenu:(id)sender {
    NSLog(@"button pressed");
    [self zoomOut2];
//    [self.restaurantScrollView setHidden:YES];
//    [self.infoScrollView setHidden:YES];
//    [self.modalView setHidden:YES];
    
    [UIView animateWithDuration:0.5 animations:^{
        CGAffineTransform matOne = CGAffineTransformMakeTranslation(0, 283-88);
        [self.menuBtn setTransform:matOne];
        [self.restaurantScrollView setTransform:matOne];
        [self.infoScrollView setTransform:matOne];
        [self.modalView setTransform:matOne];

     }  completion:^(BOOL finished)
     {
//         [self.menuBtn setHidden:YES];
//         [self.menuBtn2 setHidden:NO];
         [self.menuBtn addTarget:self action:@selector(checkedMenu2:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];

     }];
    
}

- (void)checkedMenu2:(id)sender {
    NSLog(@"button 2 pressed");
    [self zoomOut];
//    [self.menuBtn setHidden:NO];
//    [self.menuBtn2 setHidden:YES];
    [self.restaurantScrollView setHidden:NO];
    [self.infoScrollView setHidden:NO];
    [self.modalView setHidden:NO];
    [UIView animateWithDuration:0.5 animations:^{
        CGAffineTransform matOne = CGAffineTransformMakeTranslation(0, 0);
        [self.menuBtn setTransform:matOne];
        [self.restaurantScrollView setTransform:matOne];
        [self.infoScrollView setTransform:matOne];
        [self.modalView setTransform:matOne];
    }  completion:^(BOOL finished)
     {

         [self.menuBtn addTarget:self action:@selector(checkedMenu:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchDragInside];
         
     }];
}

//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleBlackTranslucent;
//}

// handle the swipes here
-(void) swipeRight:(UISwipeGestureRecognizer *) recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
//        NSLog(@"swipe right");
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
//    [_delegate sendDataToA:_huntTitle];
    self.tabBarController.tabBar.hidden = NO;
    [self.view.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];    
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
            flagAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                            reuseIdentifier:SFAnnotationIdentifier];
            flagAnnotationView.canShowCallout = YES;
            
            SFAnnotation *myAnn = (SFAnnotation *)annotation;
            
            NSLog(@"tag = %@",myAnn.secondtag);
            
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
                
                flagAnnotationView.image = resizedImage;
                flagAnnotationView.opaque = NO;
                
                //            UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
                //            annotationView.leftCalloutAccessoryView = sfIconView;
                
                UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 22, 22)];
                tagLabel.textColor = [UIColor blackColor];
                tagLabel.font = [UIFont fontWithName:@"OpenSans" size:18.0];
                tagLabel.textAlignment = NSTextAlignmentCenter;
                tagLabel.tag = 42;
                [flagAnnotationView addSubview:tagLabel];
                
            }else if ([myAnn.tag isEqualToString:@"2"]){
                
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
                
                resizeRect = CGRectMake(0.f, 0.f, 20.f, 35.f);
                
                resizeRect.origin = CGPointMake(0.0, 0.0);
                UIGraphicsBeginImageContext(resizeRect.size);
                [flagImage drawInRect:resizeRect];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                flagAnnotationView.image = resizedImage;
                flagAnnotationView.opaque = NO;
                
                //            UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
                //            annotationView.leftCalloutAccessoryView = sfIconView;
                
                UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(1, 5, 15, 22)];
                tagLabel.textColor = [UIColor blackColor];
                tagLabel.font = [UIFont fontWithName:@"OpenSans" size:10.0];
                tagLabel.textAlignment = NSTextAlignmentCenter;
                tagLabel.tag = 42;
                [flagAnnotationView addSubview:tagLabel];
            
            }else{
                
               UIImage *flagImage = [UIImage imageNamed:@"mappin2.png"];
                
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
                
                resizeRect = CGRectMake(0.f, 0.f, 35.f, 35.f);
                
                resizeRect.origin = CGPointMake(0.0, 0.0);
                UIGraphicsBeginImageContext(resizeRect.size);
                [flagImage drawInRect:resizeRect];
                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                flagAnnotationView.image = resizedImage;
                flagAnnotationView.opaque = NO;
                
                //            UIImageView *sfIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"SFIcon.png"]];
                //            annotationView.leftCalloutAccessoryView = sfIconView;
                
                UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 35, 22)];
                tagLabel.textColor = [UIColor whiteColor];
                tagLabel.font = [UIFont fontWithName:@"OpenSans" size:10.0];
                tagLabel.textAlignment = NSTextAlignmentCenter;
                tagLabel.tag = 42;
                [flagAnnotationView addSubview:tagLabel];
                
            }
            
            // offset the flag annotation so that the flag pole rests on the map coordinate
            flagAnnotationView.centerOffset = CGPointMake( flagAnnotationView.centerOffset.x + flagAnnotationView.image.size.width/2, flagAnnotationView.centerOffset.y - flagAnnotationView.image.size.height/2 );
            
        }
        else
        {
            flagAnnotationView.annotation = annotation;
        }
        
        SFAnnotation *myAnn = (SFAnnotation *)annotation;
        
        NSLog(@"view = %@",[flagAnnotationView viewWithTag:42]);

        UILabel *tagLabel = (UILabel *)[flagAnnotationView viewWithTag:42];
        tagLabel.text = [NSString stringWithFormat:@"%@",myAnn.secondtag];

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
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 2.25;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 1.25;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 5.75;
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 3.75;
    // Add a little extra space on the sides
    
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

- (void)getUserPicUrl{
    
//    // Whenever a person opens the app, check for a cached session
//    if (FBSession.activeSession.isOpen) {
//        //        NSLog(@"Found a cached session");
//        
//        [[FBRequest requestForMe] startWithCompletionHandler:
//         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
//             if (!error) {
//                 //                      NSLog(@"username = %@",user.name);
//                 //                      NSLog(@"user email = %@",[user objectForKey:@"email"]);
//                 _userName = user.username;
//                 _userFullName = user.name;
//                 [self.navigationItem setTitle:[_userFullName uppercaseString]];
//                 _userPicUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", _userName];
//                 _userEmail = [user objectForKey:@"email"];
//                 //                      NSLog(@"user pic url = %@",_userPicUrl);
//                 [self getUserImage];
//                 
//                 
//             }
//         }];
//        
//        // If there's no cached session, we will show a login button
//    } else {
        //        NSLog(@"Cannot found a cached session");
//        _userEmail = [[KCSUser activeUser] email];
//        _userFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
        [self.navigationItem setTitle:[_userFullName uppercaseString]];
        _collectionName1 = @"userPicture";
        _customEndpoint1 = @"NewsFeed";
        _fieldName1 = @"_id";
        _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
                
                NSArray *results_array = [NSArray arrayWithArray:results];
                
                if (results_array && results_array.count) {
                    
                    _userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                    [self getUserImage];
                    
                    
                }else{
                    
                    _userPicUrl = @"http://s25.postimg.org/4qq1lj6nj/minion.jpg";
                    [self getUserImage];
                    
                }
                
            }else{
                
                _userPicUrl = @"http://s25.postimg.org/4qq1lj6nj/minion.jpg";
                [self getUserImage];
                
            }
        }];
        
//    }
    
}

- (void)getUserImage
{
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
//             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//             [defaults setObject:UIImagePNGRepresentation(image) forKey:@"MyProfilePic"];
//             [defaults synchronize];
             
             [self.profileImageView setImage:image];
             [self.profileImageView2 setImage:image];
             
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
                 NSLog(@"user pic url = %@",_userPicUrl);
                 
//                 [self getUserPicture];
                 
                 
             }else{
                 
             }
         }];
        
        // If there's no cached session, we will show a login button
    } else {
        
//        NSLog(@"Cannot found a cached session");
//        _userEmail = [[KCSUser activeUser] email];
//        _userFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
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
                    
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadWithURL:[NSURL URLWithString:_userPicUrl]
                                     options:0
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
                     {
                         // progression tracking code
                     }
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                     {
                         if (image)
                         {
                             // do something with image
                             _userImage = image;
                             UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 65, 61)];
                             buttonImage.layer.cornerRadius = 5.f;
                             buttonImage.clipsToBounds = YES;
                             buttonImage.image = image;
                             [self.userView addSubview:buttonImage];
                             [self.view addSubview:_userView];
                         }
                     }];
                    
                }else{
                    
                }
                
            }else{
                
            }
        }];
        
    }

}

- (void)getFeaturedRestaurants
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"ListRestaurants" ofClass:[YookaBackend class]];
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
            if ([_huntDone isEqualToString:@"YES"]) {
                
                [self addAnnotation];
                [self getFeaturedImages];
                
            }else{
                
//            [self filldishImages];
            [self getFeaturedImages];
            [self addAnnotation];
                
            }
            
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
    NSLog(@"i value = %d",p);
    if (p<_featuredRestaurants.count) {
        
        YookaBackend *yooka = _featuredRestaurants[p];
//        NSLog(@"Yooka Object = %@",yooka.popuppic);
//        NSString *popuppic = yooka.popuppic;
//        NSLog(@"popupic = %@",popuppic);
        
        y = (count * 70);
        
        new_dish_frame = CGRectMake(0, y, 320, 70);
        
        self.DishView = [[UIView alloc]initWithFrame:new_dish_frame];
        [self.DishView setBackgroundColor:[UIColor clearColor]];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[NSURL URLWithString:yooka.popuppic]
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image)
             {
                 // do something with image
                 UIImageView *bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
                 [bg_image setImage:image];
                 [bg_image setContentMode:UIViewContentModeCenter];
                 [bg_image setClipsToBounds:YES];
                 [self.DishView addSubview:bg_image];
                 
                 UIImageView *modal_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
                 modal_view.opaque = NO;
                 modal_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45f];
                 [self.DishView addSubview:modal_view];

                 
                 NSString *dish = yooka.tag;
                 if (dish) {
                     self.restaurantName = yooka.Dishes[0];
                 }else{
                     self.restaurantName = yooka.Restaurant;
                 }
                 
                 UILabel *venue_label = [[UILabel alloc]initWithFrame:CGRectMake(45, 15, 270, 30)];
                 venue_label.backgroundColor = [UIColor clearColor];
                 venue_label.text = [NSString stringWithFormat:@" %@",[self.restaurantName uppercaseString]];
                 venue_label.textColor = [UIColor whiteColor];
                 venue_label.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0f];
                 venue_label.textAlignment = NSTextAlignmentCenter;
                 venue_label.layer.shadowColor = [[UIColor blackColor] CGColor];
                 venue_label.layer.shadowRadius = 1;
                 venue_label.layer.shadowOpacity = 1;
                 venue_label.layer.shadowOffset = CGSizeMake(2.0, 3.0);
                 [self.DishView addSubview:venue_label];
                 
                 UILabel *dot_label = [[UILabel alloc]initWithFrame:CGRectMake(45, 35, 270, 25)];
                 dot_label.backgroundColor = [UIColor clearColor];
                 dot_label.text = [NSString stringWithFormat:@"..."];
                 dot_label.textColor = [UIColor whiteColor];
                 dot_label.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0f];
                 dot_label.textAlignment = NSTextAlignmentCenter;
                 [self.DishView addSubview:dot_label];
                 
                 self.dishNumber = [[UILabel alloc]initWithFrame:CGRectMake(30, 15, 15, 30)];
                 [self.dishNumber setBackgroundColor:[UIColor clearColor]];
                 self.dishNumber.textColor = [UIColor whiteColor];
                 [self.dishNumber setFont:[UIFont fontWithName:@"OpenSans-Bold" size:25]];
                 self.dishNumber.text = [NSString stringWithFormat:@"%d",p+1];
                 self.dishNumber.textAlignment = NSTextAlignmentLeft;
                 [self.DishView addSubview:self.dishNumber];
                 
                 self.dishButton = [UIButton buttonWithType:UIButtonTypeCustom];
                 [self.dishButton  setFrame:CGRectMake( 0, 0, 320, 70)];
                 [self.dishButton setBackgroundColor:[UIColor clearColor]];
                 self.dishButton.tag = p;
                 [self.dishButton addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
                 [self.DishView addSubview:self.dishButton];
                 
                 UIView *white_border_line = [[UIView alloc]initWithFrame:CGRectMake(0, 36, 320, 1)];
                 [white_border_line setBackgroundColor:[UIColor whiteColor]];
                 //[self.DishView addSubview:white_border_line];
                 
                 [self.restaurantScrollView addSubview:self.DishView];
                 
                 CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                 
                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                     if (screenSize.height > 480.0f) {
                         size = 75;
                     }else{
                         size = 75;
                     }
                 }
                 
                 count++;
                 p++;
                 [self filldishImages];
             }else{
                 count++;
                 p++;
                 [self filldishImages];
             }
         }];

    }

    CGSize content_size = CGSizeMake(320, ((size) * count)+10);
    [self.restaurantScrollView setContentSize:content_size];
    
}

- (void)getFeaturedImages
{
    if (k<_featuredRestaurants.count) {
        
        YookaBackend *yooka = _featuredRestaurants[k];
        
        NSString *restaurant_name;
        NSString *dish = yooka.tag;
        if (dish) {
            restaurant_name = yooka.Dishes[0];
        }else{
            restaurant_name = yooka.Restaurant;
        }
        
        y2 = (count2 * 70);
        
        new_dish_frame2 = CGRectMake(0, y2, 320, 70);
        
        UIView *dish_view = [[UIView alloc]initWithFrame:new_dish_frame2];
        [dish_view setBackgroundColor:[UIColor clearColor]];
        
        _collectionName2 = @"yookaPosts2";
        _customEndpoint2 = @"NewsFeed";
        //        _fieldName2 = @"postDate";
        _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:_emailId,@"userEmail",_huntTitle,@"huntName",yooka.Restaurant,@"venueName",_collectionName2,@"collectionName",_fieldName2,@"fieldName2",nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
            if ([results isKindOfClass:[NSArray class]]) {
                
                //                NSLog(@"Results = \n %@",results);
                _objects = [NSMutableArray arrayWithArray:results];
                if (_objects && _objects.count) {
                    
//                    NSString *kinveyId = [_objects[0] objectForKey:@"_id"];
                    NSString *dishUrl = [[_objects[0] objectForKey:@"dishImage"]objectForKey:@"_downloadURL"];
                    NSLog(@"dishUrl=%@",dishUrl);
                    
//                    [self.dishUrlDict setObject:dishUrl forKey:self.finishedHuntVenues[k]];
                    
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
                                     
//                                     UIImage *scaledImage = [image scaleToSize:CGSizeMake(32.0f, 34.0f)];

                                     // do something with image
                                     UIImageView *bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
                                     [bg_image setImage:image];
                                     [bg_image setContentMode:UIViewContentModeCenter];
                                     [bg_image setClipsToBounds:YES];
                                     [dish_view addSubview:bg_image];
                                     
                                     UIImageView *modal_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
                                     modal_view.opaque = NO;
//                                     modal_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45f];
                                     [modal_view setImage:[UIImage imageNamed:@"shadow_maplist.png"]];
                                     [dish_view addSubview:modal_view];
                                     
                                     UILabel *venue_label = [[UILabel alloc]initWithFrame:CGRectMake(45, 15, 270, 30)];
                                     venue_label.backgroundColor = [UIColor clearColor];
                                     venue_label.text = [NSString stringWithFormat:@" %@",[restaurant_name uppercaseString]];
                                     venue_label.textColor = [UIColor whiteColor];
                                     venue_label.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0f];
                                     venue_label.textAlignment = NSTextAlignmentCenter;
//                                     venue_label.layer.shadowColor = [[UIColor blackColor] CGColor];
//                                     venue_label.layer.shadowRadius = 1;
//                                     venue_label.layer.shadowOpacity = 1;
//                                     venue_label.layer.shadowOffset = CGSizeMake(2.0, 3.0);
                                     [dish_view addSubview:venue_label];
                                     
                                     UILabel *dot_label = [[UILabel alloc]initWithFrame:CGRectMake(45, 35, 270, 25)];
                                     dot_label.backgroundColor = [UIColor clearColor];
                                     dot_label.text = [NSString stringWithFormat:@"..."];
                                     dot_label.textColor = [UIColor whiteColor];
                                     dot_label.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0f];
                                     dot_label.textAlignment = NSTextAlignmentCenter;
                                     [dish_view addSubview:dot_label];
                                     
                                     UIImageView *check_mark = [[UIImageView alloc]initWithFrame:CGRectMake(25, 15, 30, 30)];
                                     [check_mark setBackgroundColor:[UIColor clearColor]];
                                     [check_mark setImage:[UIImage imageNamed:@"check.png"]];
                                     [dish_view addSubview:check_mark];
                                     
                                     UIButton *dish_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                     [dish_button  setFrame:CGRectMake( 0, 0, 320, 70)];
                                     [dish_button setBackgroundColor:[UIColor clearColor]];
                                     dish_button.tag = k;
                                     [dish_button addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
                                     [dish_view addSubview:dish_button];
                                     
                                     UIView *white_border_line = [[UIView alloc]initWithFrame:CGRectMake(0, 69, 320, 1)];
                                     [white_border_line setBackgroundColor:[UIColor whiteColor]];
                                     [dish_view addSubview:white_border_line];
                                     
                                     [self.restaurantScrollView addSubview:dish_view];
                                     
                                     CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                                     
                                     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                                         if (screenSize.height > 480.0f) {
                                             size2 = 75;
                                         }else{
                                             size2 = 75;
                                         }
                                     }
                                     
                                     count2++;
                                     k++;
                                     [self getFeaturedImages];

                                 }else{
                                     
                                     SDWebImageManager *manager = [SDWebImageManager sharedManager];
                                     [manager downloadWithURL:[NSURL URLWithString:yooka.popuppic]
                                                      options:0
                                                     progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                      {
                                          // progression tracking code
                                      }
                                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                                      {
                                          if (image)
                                          {
                                              // do something with image
                                              UIImageView *bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
                                              [bg_image setImage:image];
                                              [bg_image setContentMode:UIViewContentModeCenter];
                                              [bg_image setClipsToBounds:YES];
                                              [dish_view addSubview:bg_image];
                                              
                                              UIImageView *modal_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
                                              modal_view.opaque = NO;
//                                              modal_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45f];
                                              [modal_view setImage:[UIImage imageNamed:@"shadow_maplist.png"]];
                                              [dish_view addSubview:modal_view];
                                              
                                              
                                              NSString *dish = yooka.tag;
                                              if (dish) {
                                                  self.restaurantName = yooka.Dishes[0];
                                              }else{
                                                  self.restaurantName = yooka.Restaurant;
                                              }
                                              
                                              UILabel *venue_label = [[UILabel alloc]initWithFrame:CGRectMake(45, 15, 270, 30)];
                                              venue_label.backgroundColor = [UIColor clearColor];
                                              venue_label.text = [NSString stringWithFormat:@" %@",[self.restaurantName uppercaseString]];
                                              venue_label.textColor = [UIColor whiteColor];
                                              venue_label.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0f];
                                              venue_label.textAlignment = NSTextAlignmentCenter;
//                                              venue_label.layer.shadowColor = [[UIColor blackColor] CGColor];
//                                              venue_label.layer.shadowRadius = 1;
//                                              venue_label.layer.shadowOpacity = 1;
//                                              venue_label.layer.shadowOffset = CGSizeMake(2.0, 3.0);
                                              [dish_view addSubview:venue_label];
                                              
                                              UILabel *dot_label = [[UILabel alloc]initWithFrame:CGRectMake(45, 35, 270, 25)];
                                              dot_label.backgroundColor = [UIColor clearColor];
                                              dot_label.text = [NSString stringWithFormat:@"..."];
                                              dot_label.textColor = [UIColor whiteColor];
                                              dot_label.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0f];
                                              dot_label.textAlignment = NSTextAlignmentCenter;
                                              [dish_view addSubview:dot_label];
                                              
                                              self.dishNumber = [[UILabel alloc]initWithFrame:CGRectMake(30, 15, 15, 30)];
                                              [self.dishNumber setBackgroundColor:[UIColor clearColor]];
                                              self.dishNumber.textColor = [UIColor whiteColor];
                                              [self.dishNumber setFont:[UIFont fontWithName:@"OpenSans-Bold" size:25]];
                                              self.dishNumber.text = [NSString stringWithFormat:@"%d",k+1];
                                              self.dishNumber.textAlignment = NSTextAlignmentLeft;
                                              [dish_view addSubview:self.dishNumber];
                                              
                                              self.dishButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                              [self.dishButton  setFrame:CGRectMake( 0, 0, 320, 70)];
                                              [self.dishButton setBackgroundColor:[UIColor clearColor]];
                                              self.dishButton.tag = k;
                                              [self.dishButton addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
                                              [dish_view addSubview:self.dishButton];
                                              
                                              UIView *white_border_line = [[UIView alloc]initWithFrame:CGRectMake(0, 69, 320, 2)];
                                              [white_border_line setBackgroundColor:[UIColor whiteColor]];
                                              [dish_view addSubview:white_border_line];
                                              
                                              [self.restaurantScrollView addSubview:dish_view];
                                              
                                              CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                                              
                                              if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                                                  if (screenSize.height > 480.0f) {
                                                      size2 = 75;
                                                  }else{
                                                      size2 = 75;
                                                  }
                                              }
                                              
                                              count2++;
                                              k++;
                                              [self getFeaturedImages];
                                              
                                          }else{
                                              count2++;
                                              k++;
                                              [self getFeaturedImages];
                                          }
                                      }];

                                 }
                             }];
                    
                }else{
                    
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    [manager downloadWithURL:[NSURL URLWithString:yooka.popuppic]
                                     options:0
                                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
                     {
                         // progression tracking code
                     }
                                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                     {
                         if (image)
                         {
                             // do something with image
                             UIImageView *bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
                             [bg_image setImage:image];
                             [bg_image setContentMode:UIViewContentModeCenter];
                             [bg_image setClipsToBounds:YES];
                             [dish_view addSubview:bg_image];
                             
                             UIImageView *modal_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
                             modal_view.opaque = NO;
//                             modal_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45f];
                             [modal_view setImage:[UIImage imageNamed:@"shadow_maplist.png"]];
                             [dish_view addSubview:modal_view];
                             
                             
                             NSString *dish = yooka.tag;
                             if (dish) {
                                 self.restaurantName = yooka.Dishes[0];
                             }else{
                                 self.restaurantName = yooka.Restaurant;
                             }
                             
                             UILabel *venue_label = [[UILabel alloc]initWithFrame:CGRectMake(45, 15, 270, 30)];
                             venue_label.backgroundColor = [UIColor clearColor];
                             venue_label.text = [NSString stringWithFormat:@" %@",[self.restaurantName uppercaseString]];
                             venue_label.textColor = [UIColor whiteColor];
                             venue_label.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0f];
                             venue_label.textAlignment = NSTextAlignmentCenter;
//                             venue_label.layer.shadowColor = [[UIColor blackColor] CGColor];
//                             venue_label.layer.shadowRadius = 1;
//                             venue_label.layer.shadowOpacity = 1;
//                             venue_label.layer.shadowOffset = CGSizeMake(2.0, 3.0);
                             [dish_view addSubview:venue_label];
                             
                             UILabel *dot_label = [[UILabel alloc]initWithFrame:CGRectMake(45, 35, 270, 25)];
                             dot_label.backgroundColor = [UIColor clearColor];
                             dot_label.text = [NSString stringWithFormat:@"..."];
                             dot_label.textColor = [UIColor whiteColor];
                             dot_label.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0f];
                             dot_label.textAlignment = NSTextAlignmentCenter;
                             [dish_view addSubview:dot_label];
                             
                             self.dishNumber = [[UILabel alloc]initWithFrame:CGRectMake(30, 15, 15, 30)];
                             [self.dishNumber setBackgroundColor:[UIColor clearColor]];
                             self.dishNumber.textColor = [UIColor whiteColor];
                             [self.dishNumber setFont:[UIFont fontWithName:@"OpenSans-Bold" size:25]];
                             self.dishNumber.text = [NSString stringWithFormat:@"%d",k+1];
                             self.dishNumber.textAlignment = NSTextAlignmentLeft;
                             [dish_view addSubview:self.dishNumber];
                             
                             self.dishButton = [UIButton buttonWithType:UIButtonTypeCustom];
                             [self.dishButton  setFrame:CGRectMake( 0, 0, 320, 70)];
                             [self.dishButton setBackgroundColor:[UIColor clearColor]];
                             self.dishButton.tag = k;
                             [self.dishButton addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
                             [dish_view addSubview:self.dishButton];
                             
                             UIView *white_border_line = [[UIView alloc]initWithFrame:CGRectMake(0, 69, 320, 1)];
                             [white_border_line setBackgroundColor:[UIColor whiteColor]];
                             [dish_view addSubview:white_border_line];
                             
                             [self.restaurantScrollView addSubview:dish_view];
                             
                             CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                             
                             if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                                 if (screenSize.height > 480.0f) {
                                     size2 = 75;
                                 }else{
                                     size2 = 75;
                                 }
                             }
                             
                             count2++;
                             k++;
                             [self getFeaturedImages];
                             
                         }else{
                             count2++;
                             k++;
                             [self getFeaturedImages];
                         }
                     }];
                    
                }
                
            }else{
                
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                [manager downloadWithURL:[NSURL URLWithString:yooka.popuppic]
                                 options:0
                                progress:^(NSInteger receivedSize, NSInteger expectedSize)
                 {
                     // progression tracking code
                 }
                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
                 {
                     if (image)
                     {
                         // do something with image
                         UIImageView *bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
                         [bg_image setImage:image];
                         [bg_image setContentMode:UIViewContentModeCenter];
                         [bg_image setClipsToBounds:YES];
                         [dish_view addSubview:bg_image];
                         
                         UIImageView *modal_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)];
                         modal_view.opaque = NO;
//                         modal_view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.45f];
                         [modal_view setImage:[UIImage imageNamed:@"shadow_maplist.png"]];
                         [dish_view addSubview:modal_view];
                         
                         
                         NSString *dish = yooka.tag;
                         if (dish) {
                             self.restaurantName = yooka.Dishes[0];
                         }else{
                             self.restaurantName = yooka.Restaurant;
                         }
                         
                         UILabel *venue_label = [[UILabel alloc]initWithFrame:CGRectMake(45, 15, 270, 30)];
                         venue_label.backgroundColor = [UIColor clearColor];
                         venue_label.text = [NSString stringWithFormat:@" %@",[self.restaurantName uppercaseString]];
                         venue_label.textColor = [UIColor whiteColor];
                         venue_label.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0f];
                         venue_label.textAlignment = NSTextAlignmentCenter;
//                         venue_label.layer.shadowColor = [[UIColor blackColor] CGColor];
//                         venue_label.layer.shadowRadius = 1;
//                         venue_label.layer.shadowOpacity = 1;
//                         venue_label.layer.shadowOffset = CGSizeMake(2.0, 3.0);
                         [dish_view addSubview:venue_label];
                         
                         UILabel *dot_label = [[UILabel alloc]initWithFrame:CGRectMake(45, 35, 270, 25)];
                         dot_label.backgroundColor = [UIColor clearColor];
                         dot_label.text = [NSString stringWithFormat:@"..."];
                         dot_label.textColor = [UIColor whiteColor];
                         dot_label.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0f];
                         dot_label.textAlignment = NSTextAlignmentCenter;
                         [dish_view addSubview:dot_label];
                         
                         self.dishNumber = [[UILabel alloc]initWithFrame:CGRectMake(30, 15, 15, 30)];
                         [self.dishNumber setBackgroundColor:[UIColor clearColor]];
                         self.dishNumber.textColor = [UIColor whiteColor];
                         [self.dishNumber setFont:[UIFont fontWithName:@"OpenSans-Bold" size:25]];
                         self.dishNumber.text = [NSString stringWithFormat:@"%d",k+1];
                         self.dishNumber.textAlignment = NSTextAlignmentLeft;
                         [dish_view addSubview:self.dishNumber];
                         
                         self.dishButton = [UIButton buttonWithType:UIButtonTypeCustom];
                         [self.dishButton  setFrame:CGRectMake( 0, 0, 320, 70)];
                         [self.dishButton setBackgroundColor:[UIColor clearColor]];
                         self.dishButton.tag = k;
                         [self.dishButton addTarget:self action:@selector(buttonAction1:) forControlEvents:UIControlEventTouchUpInside];
                         [dish_view addSubview:self.dishButton];
                         
                         UIView *white_border_line = [[UIView alloc]initWithFrame:CGRectMake(0, 69, 320, 1)];
                         [white_border_line setBackgroundColor:[UIColor whiteColor]];
                         [dish_view addSubview:white_border_line];
                         
                         [self.restaurantScrollView addSubview:dish_view];
                         
                         CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                         
                         if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                             if (screenSize.height > 480.0f) {
                                 size2 = 75;
                             }else{
                                 size2 = 75;
                             }
                         }
                         
                         count2++;
                         k++;
                         [self getFeaturedImages];
                         
                     }else{
                         count2++;
                         k++;
                         [self getFeaturedImages];
                     }
                 }];
                
            }
        }];
        
    }
    
    CGSize content_size = CGSizeMake(320, ((size2) * count2)+10);
    [self.restaurantScrollView setContentSize:content_size];

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
                
            }else{
                
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
//    YookaHuntRestaurantViewController *media = [[YookaHuntRestaurantViewController alloc]init];
//    media.selectedRestaurant = _selectedRestaurant;
//    media.selectedRestaurantName = _selectedRestaurantName;
//    media.huntTitle = _huntTitle;
//    media.locationId = yooka.location_id;
//    media.latitude = yooka.latitude;
//    media.longitude = yooka.longitude;
//    media.delegate = self;
//    media.yookaGreen = _yookaGreen;
//    media.yookaGreen2 = _yookaGreen2;
//    media.yookaOrange = _yookaOrange;
//    media.yookaOrange2 = _yookaOrange2;
//    media.venueId = yooka.fsq_venue_id;
//    [self.navigationController pushViewController:media animated:YES];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    YookaRestaurantViewController* media = [[YookaRestaurantViewController alloc]init];
    media.selectedRestaurant = _selectedRestaurant;
    media.selectedRestaurantName = _selectedRestaurantName;
    media.huntTitle = _huntTitle;
    media.locationId = yooka.location_id;
    media.latitude = yooka.latitude;
    media.longitude = yooka.longitude;
    media.yookaGreen = _yookaGreen;
    media.yookaGreen2 = _yookaGreen2;
    media.yookaOrange = _yookaOrange;
    media.yookaOrange2 = _yookaOrange2;
    media.venueId = yooka.fsq_venue_id;
    [self presentViewController:media animated:NO completion:nil];
    
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
    media.huntCount = [NSString stringWithFormat:@"%ld",[self.my_hunt_count integerValue]+1];
    media.totalHuntCount = self.hunt_count;
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
        item1.secondtag = [NSString stringWithFormat:@"%d",i+1];
        
        if ([_finishedHuntVenues containsObject:yooka.Restaurant]) {
            item1.tag = @"1";
        }
        
        [self.mapAnnotations addObject:item1];
        
    }
    
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    [self.mapView addAnnotations:self.mapAnnotations];
    [self zoomToFitMapAnnotations:self.mapView];
    
}

- (void)addAnnotation2
{
    self.mapAnnotations2 = [[NSMutableArray alloc] init];
    
    for (int b=0; b<_featuredRestaurants.count; b++) {
        
        YookaBackend *yooka = _featuredRestaurants[b];
        
        NSString *lat = yooka.latitude;
        NSString *lon = yooka.longitude;
        NSString *pinTitle = yooka.Restaurant;
        //        NSLog(@"lat = %@, lon = %@, rest = %@",lat,lon,pinTitle);
        SFAnnotation *item1 = [[SFAnnotation alloc] init];
        item1.latitude = lat;
        item1.longitude = lon;
        item1.pinTitle = pinTitle;
        item1.tag = @"2";
        item1.secondtag = [NSString stringWithFormat:@"%d",b+1];
        [self.mapAnnotations2 insertObject:item1 atIndex:b];
        
    }
    
    [self.mapView2 removeAnnotations:self.mapView2.annotations];  // remove any annotations that exist
    [self.mapView2 addAnnotations:self.mapAnnotations2];
//    [self zoomToFitMapAnnotations:self.mapView];
    
}

- (void)buttonAction1:(id)sender {
    
//    if ([[UIScreen mainScreen] bounds].size.height == 568) {
//        
//        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    
     UIButton* button = sender;
     NSUInteger b = button.tag;
    
//    [self zoomInToMyLocation:b];
    [self zoomIn:b];
    
    [self.infoScrollView removeFromSuperview];
    [self.modalView removeFromSuperview];
    
    CGPoint bottomOffset = CGPointMake(0, (70*b));
    [self.restaurantScrollView setContentOffset:bottomOffset animated:NO];
    
            viewExpanded = YES;
    
            _selectedDishes = [NSMutableArray new];
            

            //    NSLog(@"Button pressed %d",b);
            
            YookaBackend *yooka = _featuredRestaurants[b];
            
            //    NSLog(@"tag = %@",yooka.tag);
            NSString *dish = yooka.tag;
            
            self.modalView = [[UIView alloc] initWithFrame:CGRectMake(0, 285, 320, 320)];
            _modalView.opaque = NO;
//            _modalView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.95f];
            _modalView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:_modalView];
    
    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, 320.f);
    
    self.infoScrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    self.infoScrollView.contentSize= self.view.bounds.size;
    self.infoScrollView.frame = CGRectMake(0.f, 70.f, 320.f, 320.f);
    [self.infoScrollView setContentSize:CGSizeMake(320, 440)];
    [self.infoScrollView setBackgroundColor:[UIColor whiteColor]];
    [self.modalView addSubview:self.infoScrollView];
    
            [self.view bringSubviewToFront:self.infoScrollView];
    
            if (dish) {
                
                self.dishTag = @"YES";
                
                NSString *dish_name = yooka.Dishes[0];
                
                b1=(int)b;
                
                self.restaurant_name = [yooka.Restaurant uppercaseString];
                
                self.restaurantTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 200, 30)];
                self.restaurantTitleLabel.adjustsFontSizeToFitWidth = YES;
                UIFont *font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
                self.restaurantTitleLabel.font = font;
                NSString* string1 = [dish_name uppercaseString];
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
                self.restaurantTitleLabel.textColor = [UIColor whiteColor];
                self.restaurantTitleLabel.textAlignment = NSTextAlignmentCenter;
                [self.infoScrollView addSubview:self.restaurantTitleLabel];
                
                self.restaurantTitleButton = [[UIButton alloc]initWithFrame:CGRectMake(250, 50, 60, 43)];
                //                [self.restaurantTitleButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                self.restaurantTitleButton.tag = b;
                [self.restaurantTitleButton addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
                [self.restaurantTitleButton setBackgroundColor:[UIColor redColor]];
                [self.infoScrollView addSubview:self.restaurantTitleButton];
                
                self.restaurantDescriptionLabel = [[UILabel alloc]init];
                self.restaurantDescriptionLabel.textColor = [UIColor whiteColor];
                self.restaurantDescriptionLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0];
                self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                self.restaurantDescriptionLabel.numberOfLines = 0;
                
                CGSize labelSize = CGSizeMake(200, 150);
                CGSize theStringSize = [yooka.RestaurantDescription sizeWithFont:self.restaurantDescriptionLabel.font constrainedToSize:labelSize lineBreakMode:_restaurantDescriptionLabel.lineBreakMode];
                //    NSLog(@"string size = %f %f",theStringSize.width,theStringSize.height);
                
                if (theStringSize.height>80.0) {
                    
                    _gridScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 43, 205, 90)];
                    _gridScrollView.contentSize= self.view.bounds.size;
                    [self.modalView addSubview:_gridScrollView];
                    [self.gridScrollView setContentSize:CGSizeMake(200, theStringSize.height+70)];
                    self.gridScrollView.showsHorizontalScrollIndicator = NO;
                    self.restaurantDescriptionLabel.frame = CGRectMake(self.restaurantDescriptionLabel.frame.origin.x, _restaurantDescriptionLabel.frame.origin.y, theStringSize.width, theStringSize.height);
                    [self.restaurantDescriptionLabel setText:yooka.RestaurantDescription];
                    [self.restaurantDescriptionLabel sizeToFit];
                    self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                    [self.gridScrollView addSubview:self.restaurantDescriptionLabel];
                    
                }else{
                    
                    self.restaurantDescriptionLabel.frame = CGRectMake(10, 43, 205, 80);
                    [self.restaurantDescriptionLabel setText:yooka.RestaurantDescription];
                    [self.restaurantDescriptionLabel sizeToFit];
                    self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                    [self.infoScrollView addSubview:self.restaurantDescriptionLabel];
                    
                }
                
                self.closeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.closeButton2  setFrame:CGRectMake(180, 0, 35, 35)];
                [self.closeButton2 setBackgroundColor:[UIColor redColor]];
                [self.closeButton2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.closeButton2.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18.0]];
                [self.closeButton2 setTitle:@"X" forState:UIControlStateNormal];
                [self.closeButton2 addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
                [self.infoScrollView addSubview:self.closeButton2];
                
                if ([_emailId isEqualToString:[KCSUser activeUser].email]) {
                    self.uploadButton = [[UIButton alloc]initWithFrame:CGRectMake(145, 480, 60, 60)];
                    [self.uploadButton setImage:[UIImage imageNamed:@"camera_blue.png"] forState:UIControlStateNormal];
                    [self.uploadButton addTarget:self action:@selector(uploadBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                    self.uploadButton.tag = b;
                    [self.infoScrollView addSubview:self.uploadButton];
                }
                
                self.youMight = [[UILabel alloc]initWithFrame:CGRectMake(10, 210, 210, 22)];
                self.youMight.text = @"RECOMMENDED RESTAURANTS :";
                self.youMight.textColor = [UIColor lightGrayColor];
                self.youMight.textAlignment = NSTextAlignmentLeft;
                self.youMight.font = [UIFont fontWithName:@"OpenSans" size:11.0];
                self.youMight.autoresizesSubviews = YES;
                self.youMight.clipsToBounds = YES;
                [self.infoScrollView addSubview:self.youMight];
                
                _selectedDishes = [NSMutableArray arrayWithObject:_restaurantName];
                
                UILabel *dishName = [[UILabel alloc]initWithFrame:CGRectMake(10, 230, 300, 40)];
                NSString *string2 = [self.selectedDishes componentsJoinedByString:@", "];
                dishName.text = string2;
                dishName.textColor = [UIColor lightGrayColor];
                dishName.textAlignment = NSTextAlignmentLeft;
                dishName.font = [UIFont fontWithName:@"OpenSans" size:11.0];
                dishName.autoresizesSubviews = YES;
                dishName.clipsToBounds = YES;
                dishName.numberOfLines = 0;
                [dishName setBackgroundColor:[UIColor clearColor]];
                [dishName sizeToFit];
                [self.infoScrollView addSubview:dishName];
                
                
            }else{
                
                self.dishTag = @"NO";
                
                _selectedDishes = [NSMutableArray arrayWithArray:yooka.Dishes];
                
//                UIImageView *bgColor = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 320, 320)];
//                [bgColor setBackgroundColor:[UIColor whiteColor]];
//                [self.modalView addSubview: bgColor];
                
                UILabel *title_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 320, 22)];
                title_label.adjustsFontSizeToFitWidth = YES;
                title_label.text = @"INFORMATION";
                title_label.textColor = [UIColor lightGrayColor];
                title_label.textAlignment = NSTextAlignmentCenter;
                title_label.font = [UIFont fontWithName:@"OpenSans" size:14.0];
                title_label.autoresizesSubviews = YES;
                title_label.clipsToBounds = YES;
                [self.infoScrollView addSubview:title_label];
                
                UIImageView *info_icon = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 43)];
                [info_icon setBackgroundColor:[UIColor clearColor]];
                info_icon.image=[UIImage imageNamed:@"info_icon.png"];
                [self.infoScrollView addSubview: info_icon];
                
                UIImageView *gray_line3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 42, 320, 1)];
                [gray_line3 setBackgroundColor:[self colorWithHexString:@"f4f4f4"]];
                [self.infoScrollView addSubview:gray_line3];
                
                UIImageView *gray_line4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
                [gray_line4 setBackgroundColor:[self colorWithHexString:@"f4f4f4"]];
                [self.infoScrollView addSubview:gray_line4];
                
                self.restaurantTitleButton = [[UIButton alloc]initWithFrame:CGRectMake(270, 0, 50, 40)];
                //                [self.restaurantTitleButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                self.restaurantTitleButton.tag = b;
                [self.restaurantTitleButton addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
                [self.restaurantTitleButton setBackgroundColor:[UIColor clearColor]];
                //[self.restaurantTitleButton setBackgroundImage:[UIImage imageNamed:@"next_information.png"] forState:UIControlStateNormal];
                [self.infoScrollView addSubview:self.restaurantTitleButton];
                
                UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 20, 33)];
                [arrow setBackgroundColor:[UIColor clearColor]];
                arrow.image=[UIImage imageNamed:@"next_information.png"];
                [self.restaurantTitleButton addSubview: arrow];
                
                self.restaurantDescriptionLabel = [[UILabel alloc]init];
                self.restaurantDescriptionLabel.textColor = [UIColor lightGrayColor];
                self.restaurantDescriptionLabel.font = [UIFont fontWithName:@"OpenSans" size:11.0];
                self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                self.restaurantDescriptionLabel.numberOfLines = 0;
                [self.restaurantDescriptionLabel setBackgroundColor:[UIColor clearColor]];
                
                CGSize labelSize = CGSizeMake(300, 150);
                CGSize theStringSize = [yooka.RestaurantDescription sizeWithFont:self.restaurantDescriptionLabel.font constrainedToSize:labelSize lineBreakMode:_restaurantDescriptionLabel.lineBreakMode];
                //    NSLog(@"string size = %f %f",theStringSize.width,theStringSize.height);
                
                if (theStringSize.height>80.0) {
                    
                    _gridScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 60, 300, 100)];
                    _gridScrollView.contentSize= self.view.bounds.size;
                    [self.infoScrollView addSubview:_gridScrollView];
                    [self.gridScrollView setContentSize:CGSizeMake(300, theStringSize.height+70)];
                    self.gridScrollView.showsHorizontalScrollIndicator = NO;
                    self.restaurantDescriptionLabel.frame = CGRectMake(self.restaurantDescriptionLabel.frame.origin.x, _restaurantDescriptionLabel.frame.origin.y, theStringSize.width, theStringSize.height);
                    [self.restaurantDescriptionLabel setText:yooka.RestaurantDescription];
                    [self.restaurantDescriptionLabel sizeToFit];
                    self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                    [self.gridScrollView addSubview:self.restaurantDescriptionLabel];
                    
                }else{
                    
                    self.restaurantDescriptionLabel.frame = CGRectMake(10, 60, 300, 100);
                    [self.restaurantDescriptionLabel setText:yooka.RestaurantDescription];
                    [self.restaurantDescriptionLabel sizeToFit];
                    self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
                    [self.infoScrollView addSubview:self.restaurantDescriptionLabel];
                    
                }
                
                self.youMight = [[UILabel alloc]initWithFrame:CGRectMake(10, 160, 210, 22)];
                self.youMight.text = @"RECOMMENDED DISHES :";
                self.youMight.textColor = [UIColor lightGrayColor];
                self.youMight.textAlignment = NSTextAlignmentLeft;
                self.youMight.font = [UIFont fontWithName:@"OpenSans" size:11.0];
                self.youMight.autoresizesSubviews = YES;
                self.youMight.clipsToBounds = YES;
                [self.infoScrollView addSubview:self.youMight];
                
                UILabel *dishName = [[UILabel alloc]initWithFrame:CGRectMake(10, 180, 300, 40)];
                NSString *string2 = [self.selectedDishes componentsJoinedByString:@", "];
                dishName.text = string2;
                dishName.textColor = [UIColor lightGrayColor];
                dishName.textAlignment = NSTextAlignmentLeft;
                dishName.font = [UIFont fontWithName:@"OpenSans" size:11.0];
                dishName.autoresizesSubviews = YES;
                dishName.clipsToBounds = YES;
                dishName.numberOfLines = 0;
                [dishName setBackgroundColor:[UIColor clearColor]];
                [dishName sizeToFit];
                [self.infoScrollView addSubview:dishName];
                
                self.closeButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.closeButton2  setFrame:CGRectMake(0, 0, 320, 70)];
                [self.closeButton2 setBackgroundColor:[UIColor clearColor]];
                [self.closeButton2 addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
                [self.modalView addSubview:self.closeButton2];
                
                if ([_emailId isEqualToString:[KCSUser activeUser].email]) {
                    self.uploadButton = [[UIButton alloc]initWithFrame:CGRectMake(133, 260, 45, 45)];
                    [self.uploadButton setImage:[UIImage imageNamed:@"camera_blue.png"] forState:UIControlStateNormal];
                    [self.uploadButton addTarget:self action:@selector(uploadBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                    self.uploadButton.tag = b;
                    [self.infoScrollView addSubview:self.uploadButton];
                }
                
            }
    
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
            UIFont *font = [UIFont fontWithName:@"OpenSans-Bold" size:18.0];
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
            self.restaurantDescriptionLabel.font = [UIFont fontWithName:@"OpenSans" size:12.0];
            self.restaurantDescriptionLabel.textAlignment = NSTextAlignmentLeft;
            self.restaurantDescriptionLabel.numberOfLines = 0;
            
            CGSize labelSize = CGSizeMake(200, 150);
            CGSize theStringSize = [yooka.RestaurantDescription sizeWithFont:self.restaurantDescriptionLabel.font constrainedToSize:labelSize lineBreakMode:_restaurantDescriptionLabel.lineBreakMode];
            //    NSLog(@"string size = %f %f",theStringSize.width,theStringSize.height);
            
            if (theStringSize.height>80.0) {
                
                _gridScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 43, 205, 90)];
                _gridScrollView.contentSize= self.view.bounds.size;
                [self.modalView addSubview:_gridScrollView];
                [self.gridScrollView setContentSize:CGSizeMake(200, theStringSize.height+70)];
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
            self.youMight.font = [UIFont fontWithName:@"OpenSans-Bold" size:12.0];
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
            [self.closeButton2.titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:18.0]];
            [self.closeButton2 setTitle:@"X" forState:UIControlStateNormal];
            [self.closeButton2 addTarget:self action:@selector(closeBtn) forControlEvents:UIControlEventTouchUpInside];
            [self.modalView addSubview:self.closeButton2];
    
}

- (void)gotoRestaurant2:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    YookaBackend *yooka = _featuredRestaurants[b];
    _selectedRestaurantName = yooka.Restaurant;
    _selectedRestaurant = _featuredRestaurants[b];
//    YookaHuntRestaurantViewController *media = [[YookaHuntRestaurantViewController alloc]init];
//    media.selectedRestaurant = _selectedRestaurant;
//    media.selectedRestaurantName = _selectedRestaurantName;
//    media.huntTitle = _huntTitle;
//    media.locationId = yooka.location_id;
//    media.latitude = yooka.latitude;
//    media.longitude = yooka.longitude;
//    media.delegate = self;
//    media.yookaGreen = _yookaGreen;
//    media.yookaGreen2 = _yookaGreen2;
//    media.yookaOrange = _yookaOrange;
//    media.yookaOrange2 = _yookaOrange2;
//    media.subscribed = @"subscribed";
//    media.venueId = yooka.fsq_venue_id;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    YookaRestaurantViewController* media = [[YookaRestaurantViewController alloc]init];
    [self presentViewController:media animated:NO completion:nil];
    
}

- (void)uploadBtnTouched:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    YookaBackend *yooka = _featuredRestaurants[b];
    _selectedRestaurantName = yooka.Restaurant;
    _selectedRestaurant = _featuredRestaurants[b];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    YookaPostViewController *media = [[YookaPostViewController alloc]init];
    media.venueID = yooka.fsq_venue_id;
    media.venueSelected = _selectedRestaurantName;
    media.huntName = _huntTitle;
    media.huntCount = [NSString stringWithFormat:@"%d",[self.my_hunt_count intValue]+1];
    media.totalHuntCount = _hunt_count;
    [self presentViewController:media animated:NO completion:nil];

}

- (void)closeBtn
{
//    NSLog(@"close modal view");
    viewExpanded = NO;
    CGPoint bottomOffset = CGPointMake(0, 0);
    [self.restaurantScrollView setContentOffset:bottomOffset animated:NO];
    
    [self zoomOut];
    
    [self.modalView removeFromSuperview];
    [self.infoScrollView removeFromSuperview];
    [self.closeButton2 removeFromSuperview];
    [self.dishButton setEnabled:YES];
    [self.dishScrollView setUserInteractionEnabled:YES];
}

- (void)closeBtn2
{
//    NSLog(@"close modal view");
    [self.modalView2 removeFromSuperview];
    [self.mapView2 removeFromSuperview];

}

-(void)zoomInToMyLocation:(NSUInteger)b
{
    NSLog(@"b=%lu",(unsigned long)b);
    
    YookaBackend *yooka = _featuredRestaurants[b];
    
    NSString *lat = yooka.latitude;
    NSString *lon = yooka.longitude;
    
    NSLog(@"lat = %@",lat);
    NSLog(@"lon = %@",lon);
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = [lat doubleValue] ;
    region.center.longitude = [lon doubleValue];
    region.span.longitudeDelta = 0.0015f;
    region.span.latitudeDelta = 0.0000015f;
    [self.mapView setRegion:region animated:YES];
}

-(void)zoomIn:(NSUInteger)b
{

    NSLog(@"b=%lu",(unsigned long)b);
    
    YookaBackend *yooka = _featuredRestaurants[b];
    
    NSString *lat = yooka.latitude;
    NSString *lon = yooka.longitude;
    
    NSLog(@"lat = %@",lat);
    NSLog(@"lon = %@",lon);
    
    [self.mapView setFrame:CGRectMake(-60, 60, 400, 200)];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
    [self moveCenterByOffset:CGPointMake(0, 0) from:coord];
    
}

- (void)moveCenterByOffset:(CGPoint)offset from:(CLLocationCoordinate2D)coordinate
{
    CGPoint point = [self.mapView convertCoordinate:coordinate toPointToView:self.mapView];
    point.x += offset.x;
    point.y += offset.y;
    CLLocationCoordinate2D center = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    [self.mapView setCenterCoordinate:center animated:YES];
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = center.latitude ;
    region.center.longitude = center.longitude;
//    region.span.longitudeDelta = 0.0075f;
//    region.span.latitudeDelta = 0.00015f;
    [self.mapView setRegion:region animated:YES];
    
//    MKCoordinateSpan span = MKCoordinateSpanMake(0.00015f,0.0075f);
//    CLLocationCoordinate2D coordinate2 = center;
//    MKCoordinateRegion region = {coordinate2, span};
//    MKCoordinateRegion regionThatFits = [self.mapView regionThatFits:region];
//    [self.mapView setRegion:regionThatFits animated:YES];

}

-(void)zoomOut
{
    [self.mapView setFrame:CGRectMake(0, 60, 400, 600)];
    
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
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 2.25;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 1.25;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 6.75;
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 3.75;
    // Add a little extra space on the sides
    
    region = [self.mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
    
}

-(void)zoomOut2
{
    [self.mapView setFrame:CGRectMake(0, 60, 400, 600)];
    
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
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.75;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.75;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 2.5;
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude);
    // Add a little extra space on the sides
    
    region = [self.mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
    
}

-(void)sendrestaurantDataToA:(NSString *)selectedHunt
{
//        NSLog(@"hunt %@",_huntTitle);
}

- (void)getHuntCount{
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery* query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:_userEmail];
    KCSQuery* query2 = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue: _huntTitle];
    KCSQuery* query3 = [KCSQuery queryOnField:@"postType" usingConditional:kKCSNotEqual forValue:@"started hunt"];
    KCSQuery* query4 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2,query3, nil];
    
    [store queryWithQuery:query4 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //                         NSLog(@"An error occurred on fetch: %@", errorOrNil);
            _my_hunt_count = @"0";
            
            self.huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 15, 60, 30)];
            self.huntCountLabel.text = [NSString stringWithFormat:@"0/%@",_hunt_count];
            NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:self.huntCountLabel.text];
            
            float spacing5 = 4.5f;
            [attributedString5 addAttribute:NSKernAttributeName
                                      value:@(spacing5)
                                      range:NSMakeRange(0, [self.huntCountLabel2.text length])];
            
            self.huntCountLabel.attributedText = attributedString5;
            self.huntCountLabel.textColor = [UIColor whiteColor];
            self.huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0];
            self.huntCountLabel.adjustsFontSizeToFitWidth = YES;
            self.huntCountLabel.textAlignment = NSTextAlignmentCenter;
            self.huntCountLabel.numberOfLines = 0;
            [self.huntCountLabel setBackgroundColor:[UIColor clearColor]];
            [self.menuBtn addSubview:self.huntCountLabel];
            
            self.huntCountLabel2 = [[UILabel alloc]initWithFrame:CGRectMake( 260, 15, 60, 30)];
            self.huntCountLabel2.text = [NSString stringWithFormat:@"0/%@",_hunt_count];
            NSMutableAttributedString *attributedString6 = [[NSMutableAttributedString alloc] initWithString:self.huntCountLabel2.text];

            float spacing6 = 4.5f;
            [attributedString6 addAttribute:NSKernAttributeName
                                      value:@(spacing6)
                                      range:NSMakeRange(0, [self.huntCountLabel2.text length])];
            
            self.huntCountLabel2.attributedText = attributedString6;
            self.huntCountLabel2.textColor = [UIColor whiteColor];
            self.huntCountLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0];
            self.huntCountLabel2.adjustsFontSizeToFitWidth = YES;
            self.huntCountLabel2.textAlignment = NSTextAlignmentCenter;
            self.huntCountLabel2.numberOfLines = 0;
            [self.huntCountLabel2 setBackgroundColor:[UIColor clearColor]];
            [self.menuBtn2 addSubview:self.huntCountLabel2];

        } else {
            //got all events back from server -- update table view
            //                        NSLog(@"featured hunt count = %@",objectsOrNil);
            if (!objectsOrNil || !objectsOrNil.count) {
                _my_hunt_count = @"0";
                _huntDone = @"NO";
                self.huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake( 260, 15, 60, 30)];
                self.huntCountLabel.text = [NSString stringWithFormat:@"0/%@",_hunt_count];
                NSMutableAttributedString *attributedString5 = [[NSMutableAttributedString alloc] initWithString:self.huntCountLabel.text];
                
                float spacing5 = 4.5f;
                [attributedString5 addAttribute:NSKernAttributeName
                                          value:@(spacing5)
                                          range:NSMakeRange(0, [self.huntCountLabel2.text length])];
                
                self.huntCountLabel.attributedText = attributedString5;                self.huntCountLabel.textColor = [UIColor whiteColor];
                self.huntCountLabel.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0];
                self.huntCountLabel.adjustsFontSizeToFitWidth = YES;
                self.huntCountLabel.textAlignment = NSTextAlignmentCenter;
                self.huntCountLabel.numberOfLines = 0;
                [self.huntCountLabel setBackgroundColor:[UIColor clearColor]];
                [self.menuBtn addSubview:self.huntCountLabel];
                
                self.huntCountLabel2 = [[UILabel alloc]initWithFrame:CGRectMake( 260, 15, 60, 30)];
                self.huntCountLabel2.text = [NSString stringWithFormat:@"0/%@",_hunt_count];
                NSMutableAttributedString *attributedString6 = [[NSMutableAttributedString alloc] initWithString:self.huntCountLabel2.text];
                
                float spacing6 = 4.5f;
                [attributedString6 addAttribute:NSKernAttributeName
                                          value:@(spacing6)
                                          range:NSMakeRange(0, [self.huntCountLabel2.text length])];
                
                self.huntCountLabel2.attributedText = attributedString6;
                self.huntCountLabel2.textColor = [UIColor whiteColor];
                self.huntCountLabel2.font = [UIFont fontWithName:@"OpenSans-Bold" size:17.0];
                //self.huntCountLabel2.adjustsFontSizeToFitWidth = YES;
                self.huntCountLabel2.textAlignment = NSTextAlignmentCenter;
                self.huntCountLabel2.numberOfLines = 0;
                [self.huntCountLabel2 setBackgroundColor:[UIColor clearColor]];
                [self.menuBtn2 addSubview:self.huntCountLabel2];
                
            }else{
                
                _my_hunt_count = [NSString stringWithFormat:@"%lu",(unsigned long)objectsOrNil.count];
                
                if ([_my_hunt_count integerValue] >= [_hunt_count integerValue]) {
                    
                    _huntDone = @"YES";
                    self.huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake( 260, 15, 60, 30)];
                    self.huntCountLabel.text = [NSString stringWithFormat:@"%@/%@",_hunt_count,_hunt_count];
                    self.huntCountLabel.textColor = [UIColor whiteColor];
                    self.huntCountLabel.font = [UIFont fontWithName:@"OpenSans" size:15.0];
                    //self.huntCountLabel.adjustsFontSizeToFitWidth = YES;
                    self.huntCountLabel.textAlignment = NSTextAlignmentCenter;
                    self.huntCountLabel.numberOfLines = 0;
                    [self.huntCountLabel setBackgroundColor:[UIColor clearColor]];
                    [self.menuBtn addSubview:self.huntCountLabel];
                    
                    self.huntCountLabel2 = [[UILabel alloc]initWithFrame:CGRectMake( 260, 15, 60, 30)];
                    self.huntCountLabel2.text = [NSString stringWithFormat:@"%@/%@",_hunt_count,_hunt_count];
                    self.huntCountLabel2.textColor = [UIColor whiteColor];
                    self.huntCountLabel2.font = [UIFont fontWithName:@"OpenSans" size:15.0];
                   // self.huntCountLabel2.adjustsFontSizeToFitWidth = YES;
                    self.huntCountLabel2.textAlignment = NSTextAlignmentCenter;
                    self.huntCountLabel2.numberOfLines = 0;
                    [self.huntCountLabel2 setBackgroundColor:[UIColor clearColor]];
                    [self.menuBtn2 addSubview:self.huntCountLabel2];

                }else{
                    
                    _huntDone = @"NO";
                    self.huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake( 260, 15, 60, 30)];
                    self.huntCountLabel.text = [NSString stringWithFormat:@"%@/%@",_my_hunt_count,_hunt_count];
                    self.huntCountLabel.textColor = [UIColor whiteColor];
                    self.huntCountLabel.font = [UIFont fontWithName:@"OpenSans" size:15.0];
                    //self.huntCountLabel.adjustsFontSizeToFitWidth = YES;
                    self.huntCountLabel.textAlignment = NSTextAlignmentCenter;
                    self.huntCountLabel.numberOfLines = 0;
                    [self.huntCountLabel setBackgroundColor:[UIColor clearColor]];
                    [self.menuBtn addSubview:self.huntCountLabel];
                    
                    self.huntCountLabel2= [[UILabel alloc]initWithFrame:CGRectMake( 260, 15, 60, 30)];
                    self.huntCountLabel2.text = [NSString stringWithFormat:@"%@/%@",_my_hunt_count,_hunt_count];
                    self.huntCountLabel2.textColor = [UIColor whiteColor];
                    self.huntCountLabel2.font = [UIFont fontWithName:@"OpenSans" size:15.0];
                   // self.huntCountLabel2.adjustsFontSizeToFitWidth = YES;
                    self.huntCountLabel2.textAlignment = NSTextAlignmentCenter;
                    self.huntCountLabel2.numberOfLines = 0;
                    [self.huntCountLabel2 setBackgroundColor:[UIColor clearColor]];
                    [self.menuBtn2 addSubview:self.huntCountLabel2];

                }
            }
            
            NSLog(@"hunt count = %@",_my_hunt_count);
            NSLog(@"hunt done = %@",_huntDone);
            if ([_huntDone isEqualToString:@"YES"]) {
                NSLog(@"hunt done = %@",_huntDone);
                [self showPostCard];
//                [self getFeaturedImages];
                
            }
            
        }
    } withProgressBlock:nil];
    
}

- (void)showPostCard{
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        //do iphone stuff here
    if (isiPhone5) {
        
        self.modalView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 586)];
        _modalView2.opaque = NO;
        _modalView2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
        _modalView2.tag = 101;
        [self.view addSubview:_modalView2];
        
        [self.view bringSubviewToFront:_modalView2];
        
        UIImageView *purpleBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 150, 320, 427/2)];
        purpleBg.image = [UIImage imageNamed:@"postcard_try.jpg"];
        [self.modalView2 addSubview:purpleBg];
        
//        UIImageView *stamp_bg = [[UIImageView alloc]initWithFrame:CGRectMake(43, 212, 33, 30)];
//        [stamp_bg setBackgroundColor:[UIColor whiteColor]];
//        UIImage *scaledImage = [[UIImage imageNamed:@"yooka_stamp2x.png"] scaleToSize:CGSizeMake(33.0f, 30.0f)];
//        stamp_bg.image = scaledImage;
//        [self.modalView2 addSubview:stamp_bg];
//        
//        UILabel *add_lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(122.0, 217, 35.0, 5.5)];
//        [add_lbl1 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//        add_lbl1.textColor = [UIColor darkGrayColor];
//        add_lbl1.text = [NSString stringWithFormat:@"YOOKA INC,"];
//        add_lbl1.textAlignment = NSTextAlignmentLeft;
//        [add_lbl1 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:5.5]];
//        // custom views should be added as subviews of the cell's contentView:
//        [add_lbl1 setBackgroundColor:[UIColor whiteColor]];
//        [self.modalView2 addSubview:add_lbl1];
//        
//        UILabel *add_lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(122.0, 222, 35.0, 5.0)];
//        [add_lbl2 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//        add_lbl2.textColor = [UIColor darkGrayColor];
//        add_lbl2.text = [NSString stringWithFormat:@"20 W 20TH STREET"];
//        add_lbl2.textAlignment = NSTextAlignmentLeft;
//        [add_lbl2 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:3.25]];
//        // custom views should be added as subviews of the cell's contentView:
//        [add_lbl2 setBackgroundColor:[UIColor whiteColor]];
//        [self.modalView2 addSubview:add_lbl2];
//        
//        UILabel *add_lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(122.0, 227, 35.0, 4.0)];
//        [add_lbl3 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//        add_lbl3.textColor = [UIColor darkGrayColor];
//        add_lbl3.text = [NSString stringWithFormat:@"NEW YORK, NY 10011"];
//        add_lbl3.textAlignment = NSTextAlignmentCenter;
//        [add_lbl3 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:3.25]];
//        // custom views should be added as subviews of the cell's contentView:
//        [add_lbl3 setBackgroundColor:[UIColor whiteColor]];
//        [self.modalView2 addSubview:add_lbl3];
        
        UIImageView *x_box = [[UIImageView alloc]initWithFrame:CGRectMake(275, 20, 34, 34)];
        x_box.image = [UIImage imageNamed:@"x-box.png"];
        [self.modalView2 addSubview:x_box];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn  setFrame:CGRectMake(275.5, 20.5, 34, 34)];
        [closeBtn setBackgroundColor:[UIColor clearColor]];
        [closeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closeBtn.titleLabel setFont:[UIFont fontWithName:@"OpenSans-Bold" size:17.0]];
        [closeBtn setTitle:@"X" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtn2) forControlEvents:UIControlEventTouchUpInside];
        [self.modalView2 addSubview:closeBtn];
        
//        self.mapView2 = [[MKMapView alloc] initWithFrame:CGRectMake(159, 211, 117.5, 157)];
//        //Always center the dot and zoom in to an apropriate zoom level when position changes
//        //        [_mapView setUserTrackingMode:MKUserTrackingModeFollow];
//        self.mapView2.delegate = self;
//        
//        // set Span
//        // start off by default in San Francisco
//        MKCoordinateRegion newRegion;
//        newRegion.center.latitude = _currentLocation.coordinate.latitude;
//        newRegion.center.longitude = _currentLocation.coordinate.longitude;
//        
//        //    NSLog(@"%f",_currentLocation.coordinate.latitude);
//        //    NSLog(@"%f",_currentLocation.coordinate.longitude);
//        //    newRegion.center.latitude = [_latitude doubleValue];
//        //    newRegion.center.longitude = [_longitude doubleValue];
//        
//        newRegion.span.latitudeDelta = 0.122872;
//        newRegion.span.longitudeDelta = 0.119863;
//        
//        [self.mapView2 setRegion:newRegion animated:YES];
//        [self.mapView2 setShowsUserLocation:YES];
//        [self.view addSubview:_mapView2];
//        
//        [self addAnnotation2];
        
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
        
//        // check if image is already cached in userdefaults.
//        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//        NSData* imageData = [ud objectForKey:@"MyProfilePic"];
//        UIImage *image = [UIImage imageWithData:imageData];
//        
//        UIImage *scaledImage2 = [image scaleToSize:CGSizeMake(80, 80)];
//        
//        if (scaledImage2) {
//            
//            self.profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(88, 236, 19, 19)];
//            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
//            [self.profileImageView setContentMode:UIViewContentModeScaleAspectFit];
//            [self.profileImageView setClipsToBounds:YES];
//            [self.profileImageView setImage:image];
//            [self.modalView2 addSubview:self.profileImageView];
//            
//        }
//        
//        NSString *first_name = [[[KCSUser activeUser]givenName]uppercaseString];
//        
//        UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 258.0, 100.0, 8.0)];
//        [lbl1 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//        lbl1.textColor = [UIColor darkGrayColor];
//        lbl1.text = [NSString stringWithFormat:@"%@ WENT TO ALL OF THE BEST",first_name];
//        lbl1.textAlignment = NSTextAlignmentCenter;
//        [lbl1 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:4.5]];
//        // custom views should be added as subviews of the cell's contentView:
//        [self.modalView2 addSubview:lbl1];
//        
//        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(50.0, 266.0, 100.0, 10.0)];
//        [lbl2 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//        lbl2.textColor = [UIColor darkGrayColor];
//        lbl2.text = [NSString stringWithFormat:@"%@",[_huntTitle uppercaseString]];
//        lbl2.textAlignment = NSTextAlignmentCenter;
//        [lbl2 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:8.5]];
//        // custom views should be added as subviews of the cell's contentView:
//        [self.modalView2 addSubview:lbl2];
//        
//        UIImageView *bg_view = [[UIImageView alloc]initWithFrame:CGRectMake(42, 275, 116, 92)];
//        [bg_view setBackgroundColor:[UIColor whiteColor]];
//        [self.modalView2 addSubview:bg_view];
        
//        for (int c=0; c<4; c++) {
//            
//            if (c==0) {
//                UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(55.0, (288.0 + (c*20)), 40.0, 8.0)];
//                [lbl3 setBackgroundColor:[UIColor redColor]]; // transparent label background
//                lbl3.textColor = [UIColor darkGrayColor];
//                lbl3.text = [NSString stringWithFormat:@"%@",[_finishedHuntVenues[c] uppercaseString]];
//                lbl3.textAlignment = NSTextAlignmentLeft;
//                [lbl3 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:6.0]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl3];
//                
//                UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(55.0, (296.0 + (c*20)), 42.0, 5.0)];
//                [lbl4 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//                lbl4.textColor = [UIColor darkGrayColor];
//                lbl4.text = [NSString stringWithFormat:@"%@",[[[_locationNameDict objectForKey:_huntTitle] objectForKey:_finishedHuntVenues[c]] uppercaseString]];
//                lbl4.textAlignment = NSTextAlignmentLeft;
//                [lbl4 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:4.5]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl4];
//            }
//            
//            if (c==1) {
//                UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(55.0, (288.0 + (c*20))-1, 40.0, 8.0)];
//                [lbl3 setBackgroundColor:[UIColor redColor]]; // transparent label background
//                lbl3.textColor = [UIColor darkGrayColor];
//                lbl3.text = [NSString stringWithFormat:@"%@",[_finishedHuntVenues[c] uppercaseString]];
//                lbl3.textAlignment = NSTextAlignmentLeft;
//                [lbl3 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:6.0]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl3];
//                
//                UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(55.0, (296.0 + (c*20))-1, 42.0, 5.0)];
//                [lbl4 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//                lbl4.textColor = [UIColor darkGrayColor];
//                lbl4.text = [NSString stringWithFormat:@"%@",[[[_locationNameDict objectForKey:_huntTitle] objectForKey:_finishedHuntVenues[c]] uppercaseString]];
//                lbl4.textAlignment = NSTextAlignmentLeft;
//                [lbl4 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:4.5]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl4];
//            }
//            
//            if (c==2) {
//                UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(60.0, (288.0 + (c*20)), 40.0, 8.0)];
//                [lbl3 setBackgroundColor:[UIColor redColor]]; // transparent label background
//                lbl3.textColor = [UIColor darkGrayColor];
//                lbl3.text = [NSString stringWithFormat:@"%@",[_finishedHuntVenues[c] uppercaseString]];
//                lbl3.textAlignment = NSTextAlignmentLeft;
//                [lbl3 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:6.0]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl3];
//                
//                UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(60.0, (296.0 + (c*20)), 42.0, 5.0)];
//                [lbl4 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//                lbl4.textColor = [UIColor darkGrayColor];
//                lbl4.text = [NSString stringWithFormat:@"%@",[[[_locationNameDict objectForKey:_huntTitle] objectForKey:_finishedHuntVenues[c]] uppercaseString]];
//                lbl4.textAlignment = NSTextAlignmentLeft;
//                [lbl4 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:4.5]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl4];
//            }
//            
//            if (c==3) {
//                UILabel *lbl3 = [[UILabel alloc] initWithFrame:CGRectMake(60.0, (289.0 + (c*20)), 40.0, 8.0)];
//                [lbl3 setBackgroundColor:[UIColor redColor]]; // transparent label background
//                lbl3.textColor = [UIColor darkGrayColor];
//                lbl3.text = [NSString stringWithFormat:@"%@",[_finishedHuntVenues[c] uppercaseString]];
//                lbl3.textAlignment = NSTextAlignmentLeft;
//                [lbl3 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:6.0]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl3];
//                
//                UILabel *lbl4 = [[UILabel alloc] initWithFrame:CGRectMake(60.0, (297.0 + (c*20)), 42.0, 5.0)];
//                [lbl4 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//                lbl4.textColor = [UIColor darkGrayColor];
//                lbl4.text = [NSString stringWithFormat:@"%@",[[[_locationNameDict objectForKey:_huntTitle] objectForKey:_finishedHuntVenues[c]] uppercaseString]];
//                lbl4.textAlignment = NSTextAlignmentLeft;
//                [lbl4 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:4.5]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl4];
//            }
//            
//        }
//        
//        for (int d=4; d<7; d++) {
//            
//            if (d==4) {
//                UILabel *lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(121.0, (288.0 + ((d-4)*20)), 37.0, 8.0)];
//                [lbl5 setBackgroundColor:[UIColor redColor]]; // transparent label background
//                lbl5.textColor = [UIColor darkGrayColor];
//                lbl5.text = [NSString stringWithFormat:@"%@",[_finishedHuntVenues[d] uppercaseString]];
//                lbl5.textAlignment = NSTextAlignmentLeft;
//                [lbl5 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:6.0]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl5];
//                
//                UILabel *lbl6 = [[UILabel alloc] initWithFrame:CGRectMake(121.0, (296.0 + ((d-4)*20)), 37.0, 5.0)];
//                [lbl6 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//                lbl6.textColor = [UIColor darkGrayColor];
//                lbl6.text = [NSString stringWithFormat:@"%@",[[[_locationNameDict objectForKey:_huntTitle] objectForKey:_finishedHuntVenues[d]] uppercaseString]];
//                lbl6.textAlignment = NSTextAlignmentLeft;
//                [lbl6 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:4.5]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl6];
//            }
//            
//            if (d==5) {
//                UILabel *lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(121.0, (287.0 + ((d-4)*20)), 37.0, 8.0)];
//                [lbl5 setBackgroundColor:[UIColor redColor]]; // transparent label background
//                lbl5.textColor = [UIColor darkGrayColor];
//                lbl5.text = [NSString stringWithFormat:@"%@",[_finishedHuntVenues[d] uppercaseString]];
//                lbl5.textAlignment = NSTextAlignmentLeft;
//                [lbl5 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:6.0]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl5];
//                
//                UILabel *lbl6 = [[UILabel alloc] initWithFrame:CGRectMake(121.0, (295.0 + ((d-4)*20)), 37.0, 5.0)];
//                [lbl6 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//                lbl6.textColor = [UIColor darkGrayColor];
//                lbl6.text = [NSString stringWithFormat:@"%@",[[[_locationNameDict objectForKey:_huntTitle] objectForKey:_finishedHuntVenues[d]] uppercaseString]];
//                lbl6.textAlignment = NSTextAlignmentLeft;
//                [lbl6 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:4.5]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl6];
//            }
//            
//            if (d==6) {
//                UILabel *lbl5 = [[UILabel alloc] initWithFrame:CGRectMake(121.0, (288.0 + ((d-4)*20)), 37.0, 8.0)];
//                [lbl5 setBackgroundColor:[UIColor redColor]]; // transparent label background
//                lbl5.textColor = [UIColor darkGrayColor];
//                lbl5.text = [NSString stringWithFormat:@"%@",[_finishedHuntVenues[d] uppercaseString]];
//                lbl5.textAlignment = NSTextAlignmentLeft;
//                [lbl5 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:6.0]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl5];
//                
//                UILabel *lbl6 = [[UILabel alloc] initWithFrame:CGRectMake(121.0, (296.0 + ((d-4)*20))-1, 37.0, 5.0)];
//                [lbl6 setBackgroundColor:[UIColor whiteColor]]; // transparent label background
//                lbl6.textColor = [UIColor darkGrayColor];
//                lbl6.text = [NSString stringWithFormat:@"%@",[[[_locationNameDict objectForKey:_huntTitle] objectForKey:_finishedHuntVenues[d]] uppercaseString]];
//                lbl6.textAlignment = NSTextAlignmentLeft;
//                [lbl6 setFont:[UIFont fontWithName:@"OpenSans-Bold" size:4.5]];
//                // custom views should be added as subviews of the cell's contentView:
//                [self.modalView2 addSubview:lbl6];
//            }
//            
//        }
        
    }else{
        
    }
        
    }else{
        //do ipad stuff here
    }
    
}

-(void)needIos6Landscape {
}
- (BOOL)shouldAutorotate
{
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
        [_descriptionLabel setFont:[UIFont fontWithName:@"OpenSans" size:12]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:_descriptionLabel];
        if ([self.dishTag isEqualToString:@"YES"]) {
            self.restaurantTitleButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.restaurantTitleButton2 setFrame:CGRectMake(0.0, 0.0, 205.0, 35.0)];
            [self.restaurantTitleButton2 setBackgroundColor:[UIColor clearColor]];
            self.restaurantTitleButton2.tag = b1;
            [self.restaurantTitleButton2 addTarget:self action:@selector(gotoRestaurant:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:self.restaurantTitleButton2];
        }
        
    }
    if ([self.dishTag isEqualToString:@"YES"]) {
        [(UILabel *)[cell.contentView viewWithTag:1] setText:self.restaurant_name];
    }else{
    [(UILabel *)[cell.contentView viewWithTag:1] setText:self.selectedDishes[indexPath.row]];
    }
    
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
//    if([_tapTag isEqualToString:@"YES"])
//    {
//        // Do something to animate out to reveal the entire image
//       _tapTag = @"NO";
//        [self.navigationController setNavigationBarHidden:NO];
//    }
//    else if([_tapTag isEqualToString:@"NO"])
//    {
//        // Do something else to animate back to its original location
//        _tapTag = @"YES";
//        [self.navigationController setNavigationBarHidden:YES];
//
//    }
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
