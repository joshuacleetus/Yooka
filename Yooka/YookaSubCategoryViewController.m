//
//  YookaSubCategoryViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 6/18/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaSubCategoryViewController.h"
#import "YookaBackend.h"
#import "UIImageView+WebCache.h"
#import "YookaFeaturedHuntViewController.h"
#import "YookaHuntVenuesViewController.h"
#import "UIImage+Scale.h"
#import "UIImage+Crop.h"
#import "UIImage+Screenshot.h"

@interface YookaSubCategoryViewController ()

@end

@implementation YookaSubCategoryViewController

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
    
    i=0;
    j=0;
    item = 0;
    row = 0;
    col = 0;
    contentSize = 60;
    
    self.myEmail = [KCSUser activeUser].email;
    
    _huntDict1 = [NSMutableDictionary new];
    _huntDict2 = [NSMutableDictionary new];
    _huntDict3 = [NSMutableDictionary new];
    _huntDict4 = [NSMutableDictionary new];
    _huntDict5 = [NSMutableDictionary new];
    _huntDict6 = [NSMutableDictionary new];
    self.huntCounts = [NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _huntDict1 = [defaults objectForKey:@"huntDescription"];
    _huntDict2 = [defaults objectForKey:@"huntCount"];
    _huntDict3 = [defaults objectForKey:@"huntLogoUrl"];
//    _huntDict4 = [defaults objectForKey:@"huntPicsUrl"];
//    _huntDict5 = [defaults objectForKey:@"huntLocations"];
    _huntDict6 = [defaults objectForKey:@"huntPicUrl"];
    
    self.subscribedHunts=[defaults objectForKey:@"subscribedHuntNames"];
    

    self.thumbnails = [NSMutableArray new];
    
    self.view.backgroundColor=[self colorWithHexString:@"f8f8f8"];
    
    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    self.gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
    self.gridScrollView.contentSize= self.view.bounds.size;
    self.gridScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    [self.view addSubview:self.gridScrollView];
    
    UIImageView *top_blue_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [top_blue_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    [self.view addSubview:top_blue_bg];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:15]];
    titleLabel.text = [NSString stringWithFormat:@"%@",[self.subCategoryName uppercaseString]];
    titleLabel.adjustsFontSizeToFitWidth = YES;
    //    titleLabel.numberOfLines = 0;
    //    [titleLabel sizeToFit];
    titleLabel.layer.masksToBounds = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    _backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
    _backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
    [self.view addSubview:_backBtnImage];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setFrame:CGRectMake(0, 0, 60, 60)];
    [self.backBtn setTitle:@"" forState:UIControlStateNormal];
    [self.backBtn setBackgroundColor:[UIColor clearColor]];
    //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backBtn];
    
//    [self getsubCatPicture];
    
    
    [self getSubCatHuntPics];

//    [self getMyHuntCounts];
    
    
}

- (void)getsubCatPicture{
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.subCatPicUrl]
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
             UIImageView *subCatImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
             //[subCatImage setImage:image];
             [subCatImage setBackgroundColor:[UIColor clearColor]];
             [self.gridScrollView addSubview:subCatImage];
             
             UIImageView *modal_view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
             modal_view.opaque = NO;
             modal_view.backgroundColor = [self colorWithHexString:@"3ac0ec"];
                                           //colorWithAlphaComponent:0.86f];
             [self.gridScrollView addSubview:modal_view];
             
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
             
//             UIImageView *userView = [[UIImageView alloc]initWithFrame:CGRectMake(135, 40, 50, 50)];
//             userView.layer.cornerRadius = userView.frame.size.height / 2;
//             [userView setContentMode:UIViewContentModeScaleAspectFill];
//             [userView.layer setBorderWidth:3.0];
//             [userView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//             [userView setClipsToBounds:YES];
//             
//             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//             NSData* imageData = [ud objectForKey:@"MyProfilePic"];
//             UIImage *image = [UIImage imageWithData:imageData];
//             if (image) {
//                 
//                 //if image is already there set it to userview.
//                 [userView setImage:image];
//                 
//             }else{
//                 
//                 //get the user image from facebook or kinvey if its not cached.
//                 //[self get_user_image];
//             }
             
             
             
             //[self.gridScrollView addSubview:userView];
             
             self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
             self.titleLabel.textColor = [UIColor whiteColor];
             self.titleLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:15];
             NSString *string = [self.subCategoryName uppercaseString];
             if (string) {
                 NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                 float spacing = 2.5f;
                 [attributedString addAttribute:NSKernAttributeName
                                          value:@(spacing)
                                          range:NSMakeRange(0, [string length])];
                 self.titleLabel.attributedText = attributedString;
             }
             self.titleLabel.textAlignment = NSTextAlignmentCenter;
             [self.titleLabel setBackgroundColor:[UIColor clearColor]];
             self.titleLabel.adjustsFontSizeToFitWidth = YES;
             //[self.gridScrollView addSubview:self.titleLabel];
             
//             UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
//             titleLabel.textColor = [UIColor whiteColor];
//             [titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:15]];
//             titleLabel.text = [NSString stringWithFormat:@"\n%@",string];
//             titleLabel.textAlignment = NSTextAlignmentCenter;
//             titleLabel.adjustsFontSizeToFitWidth = YES;
//             //titleLabel.numberOfLines = 0;
//            // [titleLabel sizeToFit];
//             titleLabel.layer.masksToBounds = NO;
//             titleLabel.backgroundColor = [UIColor clearColor];
//             [self.gridScrollView addSubview:titleLabel];
             
             UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
             titleLabel.textColor = [UIColor whiteColor];
             titleLabel.textAlignment = NSTextAlignmentCenter;
             [titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:15]];
             titleLabel.text = [NSString stringWithFormat:@"%@",string];
             titleLabel.adjustsFontSizeToFitWidth = YES;
             //    titleLabel.numberOfLines = 0;
             //    [titleLabel sizeToFit];
             titleLabel.layer.masksToBounds = NO;
             titleLabel.backgroundColor = [UIColor clearColor];
             [self.gridScrollView addSubview:titleLabel];
             
//             UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(120, 150, 75, 2)];
//             lineView.backgroundColor = [UIColor whiteColor];
//             [self.gridScrollView addSubview:lineView];
         }
     }];
}

- (void)getMyHuntCounts
{
    
    if (j<self.subCategoryArray.count) {
        

        
        NSString *hunt_name = self.subCategoryArray[j];
        
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        KCSQuery* query = [KCSQuery queryOnField:@"userEmail" withExactMatchForValue:_myEmail];
        KCSQuery* query2 = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:self.subCategoryArray[j]];
        KCSQuery* query3 = [KCSQuery queryOnField:@"postType" usingConditional:kKCSNotEqual forValue:@"started hunt"];
        KCSQuery* query4 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2,query3, nil];
        
        [store queryWithQuery:query4 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil != nil) {
                //An error happened, just log for now
                NSLog(@"An error occurred on fetch: %@", errorOrNil);
                [self.huntCounts addObject:[NSString stringWithFormat:@"0/%@",[_huntDict2 objectForKey:self.subCategoryArray[j]]]];
                
                if ([self.subscribedHunts containsObject:hunt_name]) {
                    UIButton *button = self.thumbnails[j];

                    UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 100, 40, 40)];
                    huntCountLabel.text =self.huntCounts[j];
                    huntCountLabel.font = [UIFont fontWithName:@"OpenSans" size:15.f];
                    huntCountLabel.textAlignment = NSTextAlignmentCenter;
                    huntCountLabel.textColor = [UIColor grayColor];
                    huntCountLabel.adjustsFontSizeToFitWidth = YES;
                    huntCountLabel.numberOfLines = 0;
                    [huntCountLabel sizeToFit];
                    huntCountLabel.layer.masksToBounds = NO;
                   // [button addSubview:huntCountLabel];
                }
                
                j++;
                [self getMyHuntCounts];
                
            } else {
                //got all events back from server -- update table view
                NSLog(@"featured hunt count = %lu",(unsigned long)objectsOrNil.count);
                
                NSLog(@"1");
                
                if (objectsOrNil.count >=[[_huntDict2 objectForKey:self.subCategoryArray[j]]integerValue]) {
                    
                    NSLog(@"2");

                    
//                    [self.finishedHuntNames addObject:_subscribedHuntNames[j]];
                    [self.huntCounts addObject:[NSString stringWithFormat:@"%@/%@",[_huntDict2 objectForKey:self.subCategoryArray[j]],[_huntDict2 objectForKey:self.subCategoryArray[j]]]];
                    
                    if ([self.subscribedHunts containsObject:hunt_name]) {
                        UIButton *button = self.thumbnails[j];

                        UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 100, 40, 40)];
                        huntCountLabel.text =self.huntCounts[j];
                        //                 NSLog(@"try = %@",_inProgressHuntNames[k]);
                        huntCountLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:15.f];
                        huntCountLabel.textAlignment = NSTextAlignmentCenter;
                        huntCountLabel.textColor = [UIColor redColor];
                        huntCountLabel.adjustsFontSizeToFitWidth = YES;
                        huntCountLabel.numberOfLines = 0;
                        [huntCountLabel sizeToFit];
                        huntCountLabel.layer.masksToBounds = NO;
                       // [button addSubview:huntCountLabel];
                        j++;
                        [self getMyHuntCounts];
                        
                    }else{
                        j++;
                        [self getMyHuntCounts];
                    }
                    
                }else{
                    

//                    [self.inProgressHuntNames addObject:_subscribedHuntNames[j]];
                    [self.huntCounts addObject:[NSString stringWithFormat:@"%lu/%@",(unsigned long)objectsOrNil.count,[_huntDict2 objectForKey:self.subCategoryArray[j]]]];
                    
                    if ([self.subscribedHunts containsObject:hunt_name]) {
                        UIButton *button = self.thumbnails[j];

                        UILabel *huntCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 100, 40, 40)];
                        huntCountLabel.text =self.huntCounts[j];
                        huntCountLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:15.f];
                        huntCountLabel.textAlignment = NSTextAlignmentCenter;
                        huntCountLabel.textColor = [UIColor redColor];
                        huntCountLabel.adjustsFontSizeToFitWidth = YES;
                        huntCountLabel.numberOfLines = 0;
                        [huntCountLabel sizeToFit];
                        //                 huntCountLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
                        //                 huntCountLabel.layer.shadowRadius = 1;
                        //                 huntCountLabel.layer.shadowOpacity = 1;
                        //                 huntCountLabel.layer.shadowOffset = CGSizeMake(1.0, 3.0);
                        huntCountLabel.layer.masksToBounds = NO;
                       // [button addSubview:huntCountLabel];
                        j++;
                        [self getMyHuntCounts];
                        
                    }else{
                        j++;
                        [self getMyHuntCounts];
                    }
                }
//                NSLog(@"hunt counts = %@",self.huntDict2);


                
            }
        } withProgressBlock:nil];
        
    }else{
        
    }
    
}


- (void)getSubCatHuntPics{
    
    if (i<self.subCategoryArray.count) {
        
        NSString *hunt_name = self.subCategoryArray[i];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(col*160,
                                                                 (row*172)+60,
                                                                 160,
                                                                 169)];
            button.tag = i;
            button.userInteractionEnabled = YES;
            
            ++col;
            
            if (col >= 2) {
                row++;
                col = 0;
            }else{
                contentSize += 172;
            }
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *hunt_pic_url = [_huntDict6 objectForKey:hunt_name];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[NSURL URLWithString:hunt_pic_url]
                         options:0
                        progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             // progression tracking code
         }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image)
             {

                
                 UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 1, 160, 157)];
                 buttonImage.image = image;
                 buttonImage.contentMode = UIViewContentModeScaleToFill;
                 [buttonImage setBackgroundColor:[UIColor clearColor]];
                 [button addSubview:buttonImage];
                 
                 UIView *huntLabel_bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, 140, 160, 30)];
                 huntLabel_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                 [button addSubview:huntLabel_bg2];
                 
                 UILabel *huntLabel = [[UILabel alloc]initWithFrame:CGRectMake(9, 139, 150, 33)];
                 
                 huntLabel.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.f];
                 huntLabel.textAlignment = NSTextAlignmentLeft;
                 
                 NSString *string = [hunt_name uppercaseString];
                 huntLabel.textColor = [self colorWithHexString:@"9a8e92"];
    
                 if (string) {
                     NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                     float spacing = 1.2f;
                     [attributedString addAttribute:NSKernAttributeName
                                              value:@(spacing)
                                              range:NSMakeRange(0, [string length])];
                     huntLabel.attributedText = attributedString;
                 }
                 [button addSubview:huntLabel];
                 
                 UIView *ver_bg2 = [[UIView alloc]initWithFrame:CGRectMake(159, 0, 1, 140)];
                 ver_bg2.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                 [button addSubview:ver_bg2];
                 
                 UIView *ver_bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 140)];
                 ver_bg3.backgroundColor = [self colorWithHexString:@"f8f8f8"];
                 [button addSubview:ver_bg3];
                 
                
                 
                 [self.gridScrollView addSubview:button];
                 [self.thumbnails addObject:button];
                 
                 [_gridScrollView setContentSize:CGSizeMake(320, contentSize)];
                 
                 i++;
                 if (i==self.subCategoryArray.count) {
                     [self getMyHuntCounts];
                 }
                 [self getSubCatHuntPics];
                 
                 
             }else{
                 i++;
                 if (i==self.subCategoryArray.count) {
                     [self getMyHuntCounts];
                 }
                 [self.gridScrollView addSubview:button];
                 [self.thumbnails addObject:button];
                 [self getSubCatHuntPics];

             }
         }];

    }
    

    
}


- (void)buttonAction:(id)sender{
    
    UIButton* button = sender;
    NSUInteger b = button.tag;
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    self.subscribedHunts=[defaults objectForKey:@"subscribedHuntNames"];

    
    if ([self.subscribedHunts containsObject:self.subCategoryArray[b]]) {
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.35;
        transition.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromRight;
        
        UIView *containerView = self.view.window;
        [containerView.layer addAnimation:transition forKey:nil];
        
        YookaHuntVenuesViewController* media = [[YookaHuntVenuesViewController alloc]init];
        media.huntTitle = self.subCategoryArray[b];
        media.userEmail = self.myEmail;
        media.emailId = self.myEmail;
        media.subscribedHunts = self.subscribedHunts;
        media.unsubscribedHunts = self.unsubscribedHunts;
        [self presentViewController:media animated:NO completion:nil];
        
    }else{
        
        YookaFeaturedHuntViewController *media = [[YookaFeaturedHuntViewController alloc]init];
        media.huntTitle = self.subCategoryArray[b];
        media.subscribedHunts = self.subscribedHunts;
        media.unsubscribedHunts = self.unsubscribedHunts;
        [self presentViewController:media animated:YES completion:nil];
        
    }
    
}

- (void)back
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.35;
    transition.timingFunction =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromLeft;
    
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)getSubCategoryHunts{
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"ListPopup" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"Category" withExactMatchForValue:self.categoryName];
    KCSQuery* query2 = [KCSQuery queryOnField:@"Subcat" withExactMatchForValue:self.subCategoryName];
    KCSQuery* query3 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2, nil];
    
    [store queryWithQuery:query3 withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            
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
            
        }
    } withProgressBlock:nil];
    
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
