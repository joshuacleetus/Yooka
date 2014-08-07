//
//  YookaCategoryViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 6/2/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaCategoryViewController.h"
#import "YookaBackend.h"
#import "UIImageView+WebCache.h"
#import "YookaSubCategoryViewController.h"
#import "UIImage+Scale.h"
#import "UIImage+Crop.h"
#import "UIImage+Screenshot.h"

@interface YookaCategoryViewController ()

@end

@implementation YookaCategoryViewController

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
    
    self.featuredHunts = [NSMutableArray new];
    self.thumbnails = [NSMutableArray new];
    
    i = 0;
    row = 0;
    contentSize = 60;
    item = 0;
    
    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    self.gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
    self.gridScrollView.contentSize= self.view.bounds.size;
    self.gridScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    [self.view addSubview:self.gridScrollView];
    
    UIImageView *top_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    [top_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    [self.gridScrollView addSubview:top_bg];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 70, 260, 120)];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:22]];
    titleLabel.text = [NSString stringWithFormat:@"CHOOSE \nYOUR INTEREST"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.numberOfLines = 0;
    [titleLabel sizeToFit];
    titleLabel.layer.masksToBounds = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.gridScrollView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(120, 150, 80, 2)];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.gridScrollView addSubview:lineView];
    
    self.backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
    self.backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
    [self.gridScrollView addSubview:self.backBtnImage];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setFrame:CGRectMake(10, 20, 40, 40)];
    [self.backBtn setTitle:@"" forState:UIControlStateNormal];
    [self.backBtn setBackgroundColor:[UIColor clearColor]];
    //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.gridScrollView addSubview:self.backBtn];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 10, 120, 60)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"OpenSans-Semibold" size:25.0];
    NSString *string = self.categoryName;
    if (string) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        float spacing = 2.5f;
        [attributedString addAttribute:NSKernAttributeName
                                 value:@(spacing)
                                 range:NSMakeRange(0, [string length])];
        self.titleLabel.attributedText = attributedString;
    }
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    //[self.gridScrollView addSubview:self.titleLabel];
        
    NSLog(@"category array = %@",_categoryArray);
    
    [self getCategoryHunts];
    
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
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)getCategoryHunts
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Subcategory" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"Category" withExactMatchForValue:self.categoryName];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            
            // If the error requires people using an app to make an action outside of the app in order to recover
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error occured"
                                                            message:@"Pls check your connection and try again."
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles:nil];
            [alert show];
            //            [self stopActivityIndicator];
            
        } else {
            //got all events back from server -- update table view
            //            NSLog(@"featured hunts = %@",objectsOrNil);
            self.featuredHunts = [NSMutableArray arrayWithArray:objectsOrNil];
            NSLog(@"featured hunts = %@",self.featuredHunts);
            [self fillSubCats];
            
        }
    } withProgressBlock:nil];
}

- (void)fillSubCats{
    if (i<self.featuredHunts.count) {
        
        YookaBackend *yooka = self.featuredHunts[i];
        NSLog(@"subcat name = %@",yooka.subcatName);
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                      200+(i*70),
                                                                      320,
                                                                      70)];
        contentSize += 70;
        button.tag = item;
        button.userInteractionEnabled = YES;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        //        [button addGestureRecognizer:tapOnce]; //remove the other button action which calls method `button`
        //        [button addGestureRecognizer:tapTwice];
        //        [button addGestureRecognizer:tapTrice];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[NSURL URLWithString:yooka.subcatPicUrl]
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
                 //set image
                 UIImageView *subcatImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
                 subcatImage.layer.cornerRadius = subcatImage.frame.size.height / 2;
                 //subcatImage.layer.cornerRadius = subcatImage.frame.size.width / 2;
                 [subcatImage setContentMode:UIViewContentModeScaleAspectFill];
                 [subcatImage setClipsToBounds:YES];
                 //UIImage *scaledImage = [image scaleToSize:CGSizeMake(30, 30)];
                //subcatImage.image = scaledImage;
                 subcatImage.image = image;
                 [subcatImage setBackgroundColor:[UIColor clearColor]];

                 [button addSubview:subcatImage];
                 
//                 UIImageView *notification_icon = [[UIImageView alloc]initWithFrame:CGRectMake(-5, -5, 25, 35)];
//                 [notification_icon setImage:[UIImage imageNamed:@"notification.png"]];
//                 [subcatImage addSubview:notification_icon];
                 
                 //set arrow
                 UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(285, 23, 21, 29)];
                 [arrow setImage:[UIImage imageNamed:@"next_information.png"]];
                 [button addSubview:arrow];

                 
                 UILabel *subCatLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 20, 200, 20)];
                 subCatLabel.textColor = [UIColor lightGrayColor];
                 [subCatLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:18]];
                 subCatLabel.text = [yooka.subcatName uppercaseString];
                 subCatLabel.textAlignment = NSTextAlignmentLeft;
                 subCatLabel.adjustsFontSizeToFitWidth = NO;
                 [subCatLabel setBackgroundColor:[UIColor clearColor]];
                 [button addSubview:subCatLabel];
                 
                 UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 43, 200, 10)];
                 countLabel.textColor = [UIColor lightGrayColor];
                 [countLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:10]];
                 countLabel.text = [NSString stringWithFormat:@"%lu ITEMS",(unsigned long)[yooka.subcatHuntNames count]];
                 countLabel.textAlignment = NSTextAlignmentLeft;
                 countLabel.adjustsFontSizeToFitWidth = NO;
                 [countLabel setBackgroundColor:[UIColor clearColor]];
                 [button addSubview:countLabel];
                 
                 [button setBackgroundColor:[UIColor clearColor]];
                 
                 UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 69, self.view.bounds.size.width, 1)];
                 lineView.backgroundColor = [self colorWithHexString:@"f5f5f5"];
                 [button addSubview:lineView];
                 
                 [self.gridScrollView addSubview:button];
                 [self.thumbnails addObject:button];
                 
                 [_gridScrollView setContentSize:CGSizeMake(320, contentSize)];
                 
                 item++;
                 i++;
                 
                 [self fillSubCats];
                 
             }
         }];
        
    }
}

- (void)buttonAction:(id)sender{
    
    UIButton* button = sender;
    NSUInteger b = button.tag;
    NSLog(@"button %lu pressed",(unsigned long)b);
    
    YookaBackend *yooka = self.featuredHunts[b];
    NSLog(@"subcat hunt name = %@",yooka.subcatPicUrl);
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromRight;
    
    // NSLog(@"%s: self.view.window=%@", _func_, self.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    YookaSubCategoryViewController* media = [[YookaSubCategoryViewController alloc]init];
    media.categoryName = self.categoryName;
    media.subCategoryName = yooka.subcatName;
    media.categoryArray = self.categoryArray;
    media.subCategoryArray = [NSMutableArray arrayWithArray:yooka.subcatHuntNames];
    media.subCatPicUrl = yooka.subcatPicUrl;
    media.subscribedHunts = self.subscribedHunts;
    media.unsubscribedHunts = self.unsubscribedHunts;
    [self presentViewController:media animated:NO completion:nil];
    
}

- (void)fillSubCategories{
    
    item = 0;
    row = 0;
    col = 0;
    for (item=0;item<self.featuredHunts.count;item++) {
        
//        UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapOnce:)];
//        UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapTwice:)];
//        UITapGestureRecognizer *tapTrice = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapThrice:)];
        
//        tapOnce.numberOfTapsRequired = 1;
//        //        tapTwice.numberOfTapsRequired = 2;
//        tapTrice.numberOfTapsRequired = 3;
//        //stops tapOnce from overriding tapTwice
//        [tapOnce requireGestureRecognizerToFail:tapTrice];
//        //        [tapTwice requireGestureRecognizerToFail:tapTrice];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                             200,
                                                             320,
                                                             200)];
        contentSize += 200;
        button.tag = item;
        button.userInteractionEnabled = YES;
        //        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//        [button addGestureRecognizer:tapOnce]; //remove the other button action which calls method `button`
//        [button addGestureRecognizer:tapTwice];
//        [button addGestureRecognizer:tapTrice];
        
        
        [self.gridScrollView addSubview:button];
        [self.thumbnails addObject:button];
        
    }
    
    [_gridScrollView setContentSize:CGSizeMake(320, contentSize)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
