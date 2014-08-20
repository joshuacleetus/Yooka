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
#import "Flurry.h"

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
    self.image_array = [NSMutableArray new];
    
    i = 0;
    row = 0;
    contentSize = 240;
    item = 0;
    
    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    self.gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
    self.gridScrollView.contentSize= self.view.bounds.size;
    self.gridScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    [self.view addSubview:self.gridScrollView];
    
    UIImageView *top_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 240)];
    [top_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    [self.view addSubview:top_bg];
    
    
    NSLog(@"category name = %@",self.categoryName);
    
    UIImageView *top_bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 320, 180)];
    [self.view addSubview:top_bg_image];
    
    UILabel *categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
    categoryLabel.textColor = [UIColor whiteColor];
    categoryLabel.textAlignment = NSTextAlignmentCenter;
    [categoryLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:17]];
    categoryLabel.text = [NSString stringWithFormat:@"%@",[self.categoryName uppercaseString]];
    categoryLabel.adjustsFontSizeToFitWidth = YES;
    //    titleLabel.numberOfLines = 0;
    //    [titleLabel sizeToFit];
    categoryLabel.layer.masksToBounds = NO;
    categoryLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:categoryLabel];
    
    UIImageView *bg_layover = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 320, 180)];
    [bg_layover setBackgroundColor:[[self colorWithHexString:@"091229"]colorWithAlphaComponent:0.5f]];
    [self.view addSubview:bg_layover];
    
    UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 125, 320, 40)];
    descriptionLabel.textColor = [UIColor whiteColor];
    [descriptionLabel setFont:[UIFont fontWithName:@"OpenSans-Semibold" size:25]];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.adjustsFontSizeToFitWidth = YES;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.layer.masksToBounds = NO;
    descriptionLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:descriptionLabel];
    
    if ([self.categoryName isEqualToString:@"EAT"]) {
        
        [top_bg_image setImage:[UIImage imageNamed:@"header_picture.png"]];
        descriptionLabel.text = [[NSString stringWithFormat:@"Plan the perfect outing"] capitalizedString];
        
    }else if ([self.categoryName isEqualToString:@"DRINK"]){
        descriptionLabel.text = [[NSString stringWithFormat:@"What would you like to drink?"]capitalizedString];
    }else if ([self.categoryName isEqualToString:@"PLAY"]){
        descriptionLabel.text = [[NSString stringWithFormat:@"How would you like to play?"]capitalizedString];
    }else if ([self.categoryName isEqualToString:@"YOOKA"]){
        descriptionLabel.text = [NSString stringWithFormat:@"Plan the perfect yooka"];
    }
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 142, 325, 60)];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setFont:[UIFont fontWithName:@"OpenSans" size:15]];
    titleLabel.text = [NSString stringWithFormat:@"CHOOSE BELOW"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.numberOfLines = 0;
    titleLabel.layer.masksToBounds = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    self.backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
    self.backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
    [self.view addSubview:self.backBtnImage];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setFrame:CGRectMake( 0, 0, 60, 60)];
    [self.backBtn setTitle:@"" forState:UIControlStateNormal];
    [self.backBtn setBackgroundColor:[UIColor clearColor]];
    //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
    
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
            [self fillSubCats];
            
        }
    } withProgressBlock:nil];
}

- (void)fillSubCats{
    if (i<self.featuredHunts.count) {
        
        YookaBackend *yooka = self.featuredHunts[i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                      240+(i*65),
                                                                      320,
                                                                      70)];
        contentSize += 65;
        button.tag = item;
        button.userInteractionEnabled = YES;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [[SDImageCache sharedImageCache] queryDiskCacheForKey:yooka.subcatPicUrl done:^(UIImage *image, SDImageCacheType cacheType)
         {
             if (image) {
                 
                 //set image
                 UIImageView *subcatImage = [[UIImageView alloc]initWithFrame:CGRectMake( 8, 8, 48, 48)];
                 subcatImage.layer.cornerRadius = subcatImage.frame.size.height / 2;
                 [subcatImage setContentMode:UIViewContentModeScaleAspectFill];
                 [subcatImage setClipsToBounds:YES];
                 
                 subcatImage.image = image;
                 [self.image_array addObject:image];
                 [subcatImage setBackgroundColor:[UIColor clearColor]];
                 [button addSubview:subcatImage];
                 
                 //set arrow
                 UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(285, 8, 35, 50)];
                 [arrow setImage:[UIImage imageNamed:@"arrow_dark.png"]];
                 [button addSubview:arrow];
                 
                 UILabel *subCatLabel = [[UILabel alloc]initWithFrame:CGRectMake(67, 15, 200, 20)];
                 subCatLabel.textColor = [self colorWithHexString:@"222730"];
                 [subCatLabel setFont:[UIFont fontWithName:@"OpenSans" size:20]];
                 subCatLabel.text = yooka.subcatName;
                 subCatLabel.textAlignment = NSTextAlignmentLeft;
                 subCatLabel.adjustsFontSizeToFitWidth = NO;
                 [subCatLabel setBackgroundColor:[UIColor clearColor]];
                 [button addSubview:subCatLabel];
                 
                 UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(67, 36, 200, 15)];
                 countLabel.textColor = [UIColor grayColor];
                 [countLabel setFont:[UIFont fontWithName:@"OpenSans" size:11]];
                 countLabel.text = [NSString stringWithFormat:@"%lu places",(unsigned long)[yooka.subcatHuntNames count]];
                 countLabel.textAlignment = NSTextAlignmentLeft;
                 countLabel.adjustsFontSizeToFitWidth = NO;
                 [countLabel setBackgroundColor:[UIColor clearColor]];
                 [button addSubview:countLabel];
                 
                 [button setBackgroundColor:[UIColor clearColor]];
                 
                 UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake( 8, 64, self.view.bounds.size.width, 1)];
                 lineView.backgroundColor = [self colorWithHexString:@"f0f0f0"];
                 [button addSubview:lineView];
                 
                 [self.gridScrollView addSubview:button];
                 [self.thumbnails addObject:button];
                 
                 [_gridScrollView setContentSize:CGSizeMake(320, contentSize)];
                 
                 item++;
                 i++;
                 
                 [self fillSubCats];
                 
             }else{
                 
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
                          UIImageView *subcatImage = [[UIImageView alloc]initWithFrame:CGRectMake( 8, 8, 48, 48)];
                          subcatImage.layer.cornerRadius = subcatImage.frame.size.height / 2;
                          [subcatImage setContentMode:UIViewContentModeScaleAspectFill];
                          [subcatImage setClipsToBounds:YES];
                          
                          subcatImage.image = image;
                          [self.image_array addObject:image];

                          [subcatImage setBackgroundColor:[UIColor clearColor]];
                          [button addSubview:subcatImage];
                          
                          [[SDImageCache sharedImageCache] storeImage:image forKey:yooka.subcatPicUrl];
                          
                          //set arrow
                          UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake(285, 8, 35, 50)];
                          [arrow setImage:[UIImage imageNamed:@"arrow_dark.png"]];
                          [button addSubview:arrow];
                          
                          UILabel *subCatLabel = [[UILabel alloc]initWithFrame:CGRectMake(67, 15, 200, 20)];
                          subCatLabel.textColor = [self colorWithHexString:@"222730"];
                          [subCatLabel setFont:[UIFont fontWithName:@"OpenSans" size:20]];
                          subCatLabel.text = yooka.subcatName;
                          subCatLabel.textAlignment = NSTextAlignmentLeft;
                          subCatLabel.adjustsFontSizeToFitWidth = NO;
                          [subCatLabel setBackgroundColor:[UIColor clearColor]];
                          [button addSubview:subCatLabel];
                          
                          UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(67, 36, 200, 15)];
                          countLabel.textColor = [UIColor grayColor];
                          [countLabel setFont:[UIFont fontWithName:@"OpenSans" size:11]];
                          countLabel.text = [NSString stringWithFormat:@"%lu places",(unsigned long)[yooka.subcatHuntNames count]];
                          countLabel.textAlignment = NSTextAlignmentLeft;
                          countLabel.adjustsFontSizeToFitWidth = NO;
                          [countLabel setBackgroundColor:[UIColor clearColor]];
                          [button addSubview:countLabel];
                          
                          [button setBackgroundColor:[UIColor clearColor]];
                          
                          UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake( 8, 64, self.view.bounds.size.width, 1)];
                          lineView.backgroundColor = [self colorWithHexString:@"f0f0f0"];
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
         }];
        
        
    }
}

- (void)buttonAction:(id)sender{
    
    UIButton* button = sender;
    NSUInteger b = button.tag;

    
    YookaBackend *yooka = self.featuredHunts[b];
    NSDictionary *articleParams = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self.categoryName,@"Category_Name",
                                   yooka.subcatName, @"Sub_Category_Name",
                                   nil];
    
    [Flurry logEvent:@"Sub_Category_Clicked" withParameters:articleParams];
    
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
    media.category_image = self.image_array[b];
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
