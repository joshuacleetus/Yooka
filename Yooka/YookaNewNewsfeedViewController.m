//
//  YookaNewNewsfeedViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 7/30/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaNewNewsfeedViewController.h"
#import "YookaProfileViewController.h"
#import "YookaAppDelegate.h"
#import "YookaBackend.h"
#import <AsyncImageDownloader.h>
#import <QuartzCore/QuartzCore.h>
#import "BDViewController2.h"
#import "YookaHuntRestaurantViewController.h"
#import "YookaPostViewController.h"
#import <Reachability.h>
#import "UIImageView+WebCache.h"
#import "WebImageOperations.h"
#import "ImageCache.h"
#import "YookaRestaurantViewController.h"
#import "YookaButton.h"
#import "YookaProfileNewViewController.h"
#import "YookaClickProfileViewController.h"
#import "YookaHuntVenuesViewController.h"
#import "YookaFeaturedHuntViewController.h"
#import "UIImage+Crop.h"

const NSInteger yookaThumbnailWidth31 = 320;
const NSInteger yookaThumbnailHeight31 = 45+250+60;
const NSInteger yookaImagesPerRow31 = 1;
const NSInteger yookaThumbnailSpace31 = 5;

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface YookaNewNewsfeedViewController ()

@end

@implementation YookaNewNewsfeedViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    [super loadView];
    //Do loading here
    
    i=0;
    j=0;
    skip = 50;
    _userEmail = [KCSUser activeUser].email;
    _following_users = [NSMutableArray new];
    _queryArray = [NSArray new];
    _newsFeed = [NSMutableArray new];
    _newsFeed2 = [NSMutableArray new];
    _newsFeed3 = [NSMutableArray new];
    _newsFeed4 = [NSMutableArray new];
    _newsFeed5 = [NSMutableArray new];
    _thumbnails = [NSMutableArray new];
    _thumbnails2 = [NSMutableArray new];
    _likesData = [NSMutableArray new];
    _likersData = [NSMutableArray new];
    _userNames = [NSMutableArray new];
    _userEmails = [NSMutableArray new];
    _userPicUrls = [NSMutableArray new];
    
    _timeArray = [NSMutableArray new];
    _avgArray = [NSMutableArray new];
    contentSize = 370;
    
    self.newsfeed_caption = [NSMutableArray new];
    self.newsfeed_images = [NSMutableArray new];
    self.newsfeed_userimages = [NSMutableArray new];
    self.newsfeed_dishname = [NSMutableArray new];
    self.newsfeed_huntname = [NSMutableArray new];
    self.newsfeed_kinvey_id = [NSMutableArray new];
    self.newsfeed_postdate = [NSMutableArray new];
    self.newsfeed_posttype = [NSMutableArray new];
    self.newsfeed_postvote = [NSMutableArray new];
    self.newsfeed_useremail = [NSMutableArray new];
    self.newsfeed_userfullname = [NSMutableArray new];
    self.newsfeed_userid = [NSMutableArray new];
    self.newsfeed_venueaddress = [NSMutableArray new];
    self.newsfeed_venuecc = [NSMutableArray new];
    self.newsfeed_venuecity = [NSMutableArray new];
    self.newsfeed_venuecountry = [NSMutableArray new];
    self.newsfeed_venueid = [NSMutableArray new];
    self.newsfeed_venuename = [NSMutableArray new];
    self.newsfeed_venuepostalcode = [NSMutableArray new];
    self.newsfeed_venuestate = [NSMutableArray new];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //    _huntDict1 = [defaults objectForKey:@"huntDescription"];
    //    _huntDict2 = [defaults objectForKey:@"huntCount"];
    //    _huntDict3 = [defaults objectForKey:@"huntLogoUrl"];
    //    _huntDict4 = [defaults objectForKey:@"huntPicsUrl"];
    //    _huntDict5 = [defaults objectForKey:@"huntLocations"];
    //    _huntDict6 = [defaults objectForKey:@"huntPicUrl"];
    
    // GET THE SUBSCRIBED HUNT NAMES
    self.subscribedHunts = [defaults objectForKey:@"subscribedHuntNames"];
    self.unSubscribedHunts = [defaults objectForKey:@"unsubscribedHuntNames"];
    
    NSLog(@"SUBSCRIBED HUNTS = %@",self.subscribedHunts);
    
    //    [self.tabBarController.tabBar addObserver:self forKeyPath:@"selectedItem" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    
    //    [self showActivityIndicator];
    self.myEmail = [[KCSUser activeUser] email];
    
    self.reload_toggle = @"YES";
    
    KCSCollection* collection = [KCSCollection collectionFromString:@"yookaPosts2" ofClass:[YookaBackend class]];
    self.updateStore2 = [KCSLinkedAppdataStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:collection, KCSStoreKeyResource, [NSNumber numberWithInt:KCSCachePolicyBoth], KCSStoreKeyCachePolicy, nil]];
    
    KCSCollection* collection2 = [KCSCollection collectionFromString:@"userPicture2" ofClass:[YookaBackend class]];
    self.updateStore3 = [KCSLinkedAppdataStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:collection2, KCSStoreKeyResource, [NSNumber numberWithInt:KCSCachePolicyBoth], KCSStoreKeyCachePolicy, nil]];
    
    KCSCollection* collection3 = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
    self.updateStore4 = [KCSLinkedAppdataStore storeWithOptions:[NSDictionary dictionaryWithObjectsAndKeys:collection3, KCSStoreKeyResource, [NSNumber numberWithInt:KCSCachePolicyBoth], KCSStoreKeyCachePolicy, nil]];
    
    self.tabBarController.delegate = self;
    
    //    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    //    self.navigationController.navigationBar.backgroundColor = color;
    //    [self.navigationController.navigationBar setBarTintColor:color];
    //    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yooka.png"]];
    
//    [_gridScrollView removeFromSuperview];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *top_bar = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [top_bar setBackgroundColor:[self colorWithHexString:@"75bfea"]];
    [self.view addSubview:top_bar];
    
    self.postsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0.f, 60.f, 320.f, self.view.frame.size.height-60)];
    self.postsTableView.delegate = self;
    self.postsTableView.dataSource = self;
    [self.postsTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
//    self.postsTableView.backgroundColor = [self colorWithHexString:@"43444F"];
    [self.postsTableView setSeparatorColor:[UIColor lightGrayColor]];
    [self.view addSubview:self.postsTableView];
    
    [self setupNewsFeed];
        
    self.navButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton3  setFrame:CGRectMake(0, 0, 60, 70)];
    [self.navButton3 setBackgroundColor:[UIColor clearColor]];
    [self.navButton3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton3 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navButton3.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
    self.navButton3.tag = 1;
    self.navButton3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton3];
    
    self.navButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton  setFrame:CGRectMake(10, 23, 25, 21)];
    [self.navButton setBackgroundColor:[UIColor clearColor]];
    [self.navButton setBackgroundImage:[[UIImage imageNamed:@"menubar_white.png"]stretchableImageWithLeftCapWidth:2.0 topCapHeight:2.0] forState:UIControlStateNormal];
    [self.navButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navButton.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
    self.navButton.tag = 1;
    self.navButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton];
    
    self.navButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navButton2  setFrame:CGRectMake(0, 63, 60, 520)];
    [self.navButton2 setBackgroundColor:[UIColor clearColor]];
    [self.navButton2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.navButton2 addTarget:self action:@selector(navButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.navButton2.titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:18]];
    self.navButton2.tag = 0;
    self.navButton2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.view addSubview:self.navButton2];
    
    [self.navButton2 setHidden:YES];
    
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

// navButton tag = 1 when created in Interface Builder

- (IBAction)navButtonClicked:(id)sender {
    
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            self.navButton.tag = 1;
            self.navButton2.tag = 1;
            self.navButton3.tag = 1;
            [self.navButton2 setHidden:YES];
            [_delegate movePanelToOriginalPosition];
            
            break;
        }
            
        case 1: {
            self.navButton.tag = 0;
            self.navButton3.tag = 0;
            self.navButton2.tag = 0;
            [_delegate movePanelRight];
            [self.navButton2 setHidden:NO];
            
            break;
        }
            
        default:
            break;
    }
}

- (void)setupNewsFeed
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        i=0;
        j=0;
        k=0;
        
        _userEmails = [NSMutableArray new];
        _userNames = [NSMutableArray new];
        _newsFeed = [NSMutableArray new];
        _thumbnails = [NSMutableArray new];
        _likesData = [NSMutableArray new];
        _likersData = [NSMutableArray new];
        _userEmails = [NSMutableArray new];
        _userPicUrls = [NSMutableArray new];
        
        _collectionName1 = @"yookaPosts2";
        _customEndpoint1 = @"Posts";
        _fieldName1 = @"postDate";
        
        _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
            if (results) {
                
                if ([results isKindOfClass:[NSArray class]]) {
                    _newsFeed = [NSMutableArray arrayWithArray:results];
                    if (_newsFeed && _newsFeed.count) {
                        
                        NSLog(@"results 1 = %@",_newsFeed[0]);
                        [self.postsTableView reloadData];
                        
                    }else{
                        //                    NSLog(@"User Search Results = \n %@",results);
                    }
                    
                }else{
                    //                NSLog(@"results 2 = %@",results);
                }
            }else{
                //            NSLog(@"results 3 = %@",error);
            }
            
        }];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
        
    }
    
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.newsFeed.count) {
        return self.newsFeed.count;
    }else{
        return 10;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.postsTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.imageView.image = nil;

    if (self.newsFeed.count>0) {
        NSString *dishPicUrl = [[self.newsFeed[indexPath.row] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
        
        // Here we use the new provided setImageWithURL: method to load the web image
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:dishPicUrl]
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
                 cell.imageView.image = image;
             }
         }];
        
    }
    
    return cell;
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
