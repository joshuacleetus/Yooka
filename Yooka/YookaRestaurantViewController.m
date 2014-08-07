//
//  YookaRestaurantViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 6/9/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaRestaurantViewController.h"
#import <Reachability.h>
#import "UIImageView+WebCache.h"
#import "Foursquare2.h"
#import "BridgeAnnotation.h"
#import "SFAnnotation.h"
#import "CustomAnnotationView.h"
#import "CustomMapItem.h"
#import "FSConverter.h"
#import "FSVenue.h"
#import "YookaBackend.h"
#import "YookaButton.h"
#import "YookaBackend.h"
#import "YookaPostViewController.h"

const NSInteger yookaThumbnailWidth2013 = 320;
const NSInteger yookaThumbnailHeight2013 = 600;
const NSInteger yookaImagesPerRow2013 = 1;
const NSInteger yookaThumbnailSpace2013 = 5;

@interface YookaRestaurantViewController ()

@end

@implementation YookaRestaurantViewController

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
    
    [self.view setBackgroundColor:[self colorWithHexString:@"f4f4f4"]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.thumbnails = [NSMutableArray new];
    self.likesData = [NSMutableArray new];
    self.likersData = [NSMutableArray new];
    self.venuePics = [NSMutableArray new];
    self.venuePicUrls = [NSMutableArray new];
    
    self.myEmail = [KCSUser activeUser].email;
    
    CGRect screenRect5 = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    self.gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect5];
    self.gridScrollView.contentSize= self.view.bounds.size;
    self.gridScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    [self.view addSubview:self.gridScrollView];
    
    UIImageView *top_blue_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
    [top_blue_bg setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    //[self.gridScrollView addSubview:top_blue_bg];
    [self.view addSubview:top_blue_bg];
    
    self.bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 320, 215)];
    [self.bgImageView setImage:[UIImage imageNamed:@"product_image.png"]];
    [self.gridScrollView addSubview:self.bgImageView];
    
    [self getBgImage];
    
    self.modalView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, 320, 215)];
    self.modalView.opaque = YES;
    //self.modalView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.30f];
    self.modalView.backgroundColor = [UIColor whiteColor];
    [self.gridScrollView addSubview:_modalView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 25, 260, 22)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setFont:[UIFont fontWithName:@"OpenSans-SemiBold" size:15]];
    titleLabel.text = [NSString stringWithFormat:@"%@",[self.selectedRestaurantName uppercaseString]];
    titleLabel.adjustsFontSizeToFitWidth = YES;
//    titleLabel.numberOfLines = 0;
//    [titleLabel sizeToFit];
    titleLabel.layer.masksToBounds = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:titleLabel];
    
    self.toggle = @"YES";
    
    NSLog(@"venue id = %@",_venueId);
    
    i = 0;
    j = 0;
    k = 0;
    l = 0;
    m = 0;
    n = 0;
    row = 0, col = 0;
    row2 = 0, col2 = 0;
    row3 = 0, col3 = 0;
    contentSize = 340;
    contentSize2 = 700;
    contentSize3 = 320;
    reviewRowHeight = 0;
    q=0;
    
    _user_pic_urls = [NSMutableArray new];
    _user_full_names = [NSMutableArray new];
    
    _backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
    _backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
    [self.view addSubview:_backBtnImage];
    
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setFrame:CGRectMake(10, 20, 40, 40)];
    [_backBtn setTitle:@"" forState:UIControlStateNormal];
    [_backBtn setBackgroundColor:[UIColor clearColor]];
    //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
//    self.bgImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 215, 320, 60)];
//    [self.bgImageView2 setImage:[UIImage imageNamed:@"slider_background.png"]];
//    [self.view addSubview:self.bgImageView2];
    
    self.reviewsView = [[UIView alloc]initWithFrame:CGRectMake(0, 275, 320, 305)];
    [self.reviewsView setBackgroundColor:[UIColor clearColor]];
    [self.gridScrollView addSubview:self.reviewsView];
    
    self.detailsView = [[UIView alloc]initWithFrame:CGRectMake(0, 275, 320, 530)];
    [self.detailsView setBackgroundColor:[UIColor clearColor]];
    [self.gridScrollView addSubview:self.detailsView];
    
    self.menuView = [[UIView alloc]initWithFrame:CGRectMake(0, 275, 320, 305)];
    [self.menuView setBackgroundColor:[UIColor clearColor]];
    [self.gridScrollView addSubview:self.menuView];
    
    [self.detailsView setHidden:YES];
    [self.menuView setHidden:YES];
    
    
    UIImageView *grayline = [[UIImageView alloc]initWithFrame:CGRectMake(0, 319, 320, 1)];
    [grayline setBackgroundColor:[self colorWithHexString:@"e5e4e4"]];
    [self.gridScrollView addSubview:grayline];
    
    UIImageView *review_bg_blue = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 106.67, 45)];
    [review_bg_blue setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    [self.reviewsView addSubview:review_bg_blue];
    

    
    UILabel *reviews_label = [[UILabel alloc]initWithFrame:CGRectMake(0, 13, 106.67, 20)];
    [reviews_label setText:@"REVIEWS"];
    reviews_label.textColor = [UIColor whiteColor];
    reviews_label.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13];
    reviews_label.textAlignment = NSTextAlignmentCenter;
    [self.reviewsView addSubview:reviews_label];
    
    UIImageView *details_bg_white = [[UIImageView alloc]initWithFrame:CGRectMake(106.67, 0, 105.67, 45)];
    [details_bg_white setBackgroundColor:[UIColor whiteColor]];
    [self.reviewsView addSubview:details_bg_white];
    
    UILabel *details_label = [[UILabel alloc]initWithFrame:CGRectMake(106.67, 13, 105.67, 20)];
    [details_label setText:@"DETAILS"];
    details_label.textColor = [UIColor lightGrayColor];
    details_label.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13];
    details_label.textAlignment = NSTextAlignmentCenter;
    [self.reviewsView addSubview:details_label];
    
    UIImageView *menu_bg_white = [[UIImageView alloc]initWithFrame:CGRectMake(214, 0, 105.67, 45)];
    [menu_bg_white setBackgroundColor:[UIColor whiteColor]];
    [self.reviewsView addSubview:menu_bg_white];
    
    UILabel *menu_label = [[UILabel alloc]initWithFrame:CGRectMake(214, 13, 105.67, 20)];
    [menu_label setText:@"MENU"];
    menu_label.textColor = [UIColor lightGrayColor];
    menu_label.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13];
    menu_label.textAlignment = NSTextAlignmentCenter;
    [self.reviewsView addSubview:menu_label];
    
    UIImageView *review_bg_white = [[UIImageView alloc]initWithFrame:CGRectMake(4, 0, 102.67, 45)];
    [review_bg_white setBackgroundColor:[UIColor whiteColor]];
    [self.detailsView addSubview:review_bg_white];
    
    UIImageView *details_bg_blue = [[UIImageView alloc]initWithFrame:CGRectMake(106.67, 0, 105.67, 45)];
    [details_bg_blue setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    [self.detailsView addSubview:details_bg_blue];
    
    UIImageView *menu_bg_white_2 = [[UIImageView alloc]initWithFrame:CGRectMake(213, 0, 105.67, 45)];
    [menu_bg_white_2 setBackgroundColor:[UIColor whiteColor]];
    [self.detailsView addSubview:menu_bg_white_2];
    
    UILabel *reviews_label_2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 13, 106.67, 20)];
    [reviews_label_2 setText:@"REVIEWS"];
    reviews_label_2.textColor = [UIColor lightGrayColor];
    reviews_label_2.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13];
    reviews_label_2.textAlignment = NSTextAlignmentCenter;
    [self.detailsView addSubview:reviews_label_2];
    
    UILabel *details_label_2 = [[UILabel alloc]initWithFrame:CGRectMake(106.67, 13, 105.67, 20)];
    [details_label_2 setText:@"DETAILS"];
    details_label_2.textColor = [UIColor whiteColor];
    details_label_2.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13];
    details_label_2.textAlignment = NSTextAlignmentCenter;
    [self.detailsView addSubview:details_label_2];
    
    UILabel *menu_label_2 = [[UILabel alloc]initWithFrame:CGRectMake(214, 13, 105.67, 20)];
    [menu_label_2 setText:@"MENU"];
    menu_label_2.textColor = [UIColor lightGrayColor];
    menu_label_2.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13];
    menu_label_2.textAlignment = NSTextAlignmentCenter;
    [self.detailsView addSubview:menu_label_2];
    
    UIImageView *grayline2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 322+85, 320, 1.3)];
    [grayline2 setBackgroundColor:[self colorWithHexString:@"e5e4e4"]];
    [self.detailsView addSubview:grayline2];
    
    UIImageView *grayline3 = [[UIImageView alloc]initWithFrame:CGRectMake(160, 140+85, 1.3, 68)];
    [grayline3 setBackgroundColor:[self colorWithHexString:@"e5e4e4"]];
    [self.detailsView addSubview:grayline3];
    
    UIImageView *grayline4 = [[UIImageView alloc]initWithFrame:CGRectMake(160, 260+85, 1.3, 63)];
    [grayline4 setBackgroundColor:[self colorWithHexString:@"e5e4e4"]];
    [self.detailsView addSubview:grayline4];
    
    
    UIImageView *review_bg_white_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 105.67, 45)];
    [review_bg_white_2 setBackgroundColor:[UIColor whiteColor]];
    [self.menuView addSubview:review_bg_white_2];
    
    UIImageView *details_bg_white_2 = [[UIImageView alloc]initWithFrame:CGRectMake(107.67, 0, 105.67, 45)];
    [details_bg_white_2 setBackgroundColor:[UIColor whiteColor]];
    [self.menuView addSubview:details_bg_white_2];
    
    UIImageView *menu_bg_blue = [[UIImageView alloc]initWithFrame:CGRectMake(213, 0, 106.67, 45)];
    [menu_bg_blue setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    [self.menuView addSubview:menu_bg_blue];
    
    UILabel *reviews_label_3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 13, 106.67, 20)];
    [reviews_label_3 setText:@"REVIEWS"];
    reviews_label_3.textColor = [UIColor lightGrayColor];
    reviews_label_3.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13];
    reviews_label_3.textAlignment = NSTextAlignmentCenter;
    [self.menuView addSubview:reviews_label_3];
    
    UILabel *details_label_3 = [[UILabel alloc]initWithFrame:CGRectMake(106.67, 13, 105.67, 20)];
    [details_label_3 setText:@"DETAILS"];
    details_label_3.textColor = [UIColor lightGrayColor];
    details_label_3.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13];
    details_label_3.textAlignment = NSTextAlignmentCenter;
    [self.menuView addSubview:details_label_3];
    
    UILabel *menu_label_3 = [[UILabel alloc]initWithFrame:CGRectMake(214, 13, 105.67, 20)];
    [menu_label_3 setText:@"MENU"];
    menu_label_3.textColor = [UIColor whiteColor];
    menu_label_3.font = [UIFont fontWithName:@"OpenSans-SemiBold" size:13];
    menu_label_3.textAlignment = NSTextAlignmentCenter;
    [self.menuView addSubview:menu_label_3];
    
    UIImageView *bg_blue = [[UIImageView alloc]initWithFrame:CGRectMake(0, 88+85, 320, 45)];
    [bg_blue setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    [self.detailsView addSubview:bg_blue];
    
    UIImageView *white_line = [[UIImageView alloc]initWithFrame:CGRectMake(160, 88+85, 1, 45)];
    [white_line setBackgroundColor:[UIColor whiteColor]];
    [self.detailsView addSubview:white_line];
    
    UIImageView *phone = [[UIImageView alloc]initWithFrame:CGRectMake(68, 95+85, 28, 28)];
    [phone setImage:[UIImage imageNamed:@"phone2.png"]];
    [self.detailsView addSubview:phone];
    
    UIImageView *clock = [[UIImageView alloc]initWithFrame:CGRectMake( 230, 95+85, 30, 30)];
    [clock setImage:[UIImage imageNamed:@"clock2.png"]];
    [self.detailsView addSubview:clock];
    
    UIImageView *bg_blue_2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 208+85, 320, 45)];
    [bg_blue_2 setBackgroundColor:[self colorWithHexString:@"3ac0ec"]];
    [self.detailsView addSubview:bg_blue_2];
    
    UIImageView *white_line_2 = [[UIImageView alloc]initWithFrame:CGRectMake(160, 208+85, 1, 45)];
    [white_line_2 setBackgroundColor:[UIColor whiteColor]];
    [self.detailsView addSubview:white_line_2];
    
    UIImageView *wallet= [[UIImageView alloc]initWithFrame:CGRectMake(65, 211+85, 35, 33)];
    [wallet setImage:[UIImage imageNamed:@"credit_card.png"]];
    [self.detailsView addSubview:wallet];
    
    UIImageView *gps= [[UIImageView alloc]initWithFrame:CGRectMake(225, 210+85, 30, 30)];
    [gps setImage:[UIImage imageNamed:@"pin_white.png"]];
    [self.detailsView addSubview:gps];
    
    self.reviewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.reviewsButton  setFrame:CGRectMake(0, 275, 108, 50)];
    [self.reviewsButton setBackgroundColor:[UIColor clearColor]];
    [self.reviewsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.reviewsButton addTarget:self action:@selector(reviewsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.reviewsButton.tag = 1;
    self.reviewsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.gridScrollView addSubview:self.reviewsButton];
    
    self.detailsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.detailsButton  setFrame:CGRectMake(115, 275, 105, 50)];
    [self.detailsButton setBackgroundColor:[UIColor clearColor]];
    [self.detailsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.detailsButton addTarget:self action:@selector(detailsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.detailsButton.tag = 1;
    self.detailsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.gridScrollView addSubview:self.detailsButton];
    
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.menuButton  setFrame:CGRectMake(215, 275, 100, 50)];
    [self.menuButton setBackgroundColor:[UIColor clearColor]];
    [self.menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(menuButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.menuButton.tag = 1;
    self.menuButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.gridScrollView addSubview:self.menuButton];
    

    self.locationId = self.venueId;

    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0+45, 320, 130)];
    //Always center the dot and zoom in to an apropriate zoom level when position changes
    //        [_mapView setUserTrackingMode:MKUserTrackingModeFollow];
    self.mapView.delegate = self;
    [self.detailsView addSubview:self.mapView];

    
//    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.reviewScrollView.frame.size.height);
//    
//    self.reviewScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
//    self.reviewScrollView.contentSize= self.view.bounds.size;
//    self.reviewScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.reviewsView.frame.size.height);
//    [self.reviewsView addSubview:self.reviewScrollView];
//    [self.reviewScrollView setContentSize:CGSizeMake(320, 500)];
//    [self.reviewScrollView setBackgroundColor:[self colorWithHexString:@"f3f3f3"]];
    
//    CGRect screenRect2 = CGRectMake(0.f, 0.f, 320.f, self.detailsView.frame.size.height);
//    
//    self.detailScrollView = [[UIScrollView alloc] initWithFrame:screenRect2];
//    self.detailScrollView.contentSize = self.view.bounds.size;
//    self.detailScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.detailsView.frame.size.height);
//    [self.detailsView addSubview:self.detailScrollView];
//    [self.detailScrollView setContentSize:CGSizeMake(320, 500)];
//    [self.detailScrollView setBackgroundColor:[self colorWithHexString:@"f3f3f3"]];
//    
//    CGRect screenRect3 = CGRectMake(0.f, 0.f, 320.f, self.menuView.frame.size.height);
//    
//    self.menuScrollView = [[UIScrollView alloc] initWithFrame:screenRect3];
//    self.menuScrollView.contentSize = self.view.bounds.size;
//    self.menuScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.menuView.frame.size.height);
//    [self.menuView addSubview:self.menuScrollView];
//    [self.menuScrollView setContentSize:CGSizeMake(320, 500)];
//    [self.menuScrollView setBackgroundColor:[self colorWithHexString:@"f3f3f3"]];
    
    [self setupNewsFeed];
    
//    self.telephonesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
//    [self.telephonesImageView setBackgroundColor:[self colorWithHexString:@"43444F"]];
//    [self.detailsView addSubview:self.telephonesImageView];
//    
//    self.clockImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 50, 320, 50)];
//    [self.clockImageView setBackgroundColor:[self colorWithHexString:@"595960"]];
//    [self.detailsView addSubview:self.clockImageView];
//    
//    self.priceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 100, 320, 50)];
//    [self.priceImageView setBackgroundColor:[self colorWithHexString:@"43444F"]];
//    [self.detailsView addSubview:self.priceImageView];
    
    [self getRestaurantDetails];
    
    self.menuTableView = [[UITableView alloc]initWithFrame:CGRectMake(-20.f, 320.f, 340.f, self.gridScrollView.frame.size.height)];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    [self.menuTableView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    //    self.menuTableView.backgroundColor = [self colorWithHexString:@"43444F"];
    [self.menuTableView setSeparatorColor:[UIColor lightGrayColor]];
    self.menuTableView.scrollEnabled = NO;
    [self.gridScrollView addSubview:_menuTableView];
    
    [self.menuTableView setHidden:YES];
    
    //    self.menuSearch = [[UISearchBar alloc]initWithFrame:CGRectMake(0.f, 0.f, 320.f, 44.f)];
    //    self.menuSearch.showsCancelButton = NO;
    //    self.menuSearch.delegate = self;
    //    self.menuSearch.placeholder = @"Search Menu";
    //    self.menuSearch.autocorrectionType=UITextAutocorrectionTypeNo;
    //    self.menuSearch.autocapitalizationType=UITextAutocapitalizationTypeNone;
    //    self.menuTableView.tableHeaderView = self.menuSearch;
    //    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.menuSearch contentsController:self];
    //    searchDisplayController.delegate = self;
    //    searchDisplayController.searchResultsDataSource = self;
    //    [searchDisplayController setSearchResultsDelegate:self];
    
    [self getMenuForVenue];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if (scrollView == self.topScrollView) {
        self.hunts_pages.currentPage = page;
        
    }

}


- (void)getBgImage{
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"ListRestaurants" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"fsq_venue_id" withExactMatchForValue:self.venueId];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            //            _unsubscribedHunts = _featuredHunts;
            //            [self modifyFeaturedHunts];
            
            //            NSLog(@"try 1");
            
        } else {
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
                //                NSLog(@"try 2002");
                [self getRestaurantImages];
                
            } else {
                

                YookaBackend *yooka = objectsOrNil[0];
                self.teampic_url = yooka.popuppic;
//                NSString *fsq_venue_id = yooka.fsq_venue_id;
//                NSLog(@"rest pic url = %@",yooka.teampic);
                
                [self.venuePicUrls addObject:self.teampic_url];

                [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.teampic_url]
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
                         [self.bgImageView setImage:image];
                         
                         [self getRestaurantImages];
                         
                     }
                 }];
                
            }
            
        }
    } withProgressBlock:nil];
    
}

- (void)getRestaurantImages{
    [Foursquare2 venueGetPhotos:_venueId limit:@5 offset:nil callback:^(BOOL success, id result){
        
        if (success) {
            NSLog(@"%@",result);
            NSDictionary *dic = result;
            self.venuePics = [dic valueForKeyPath:@"response.photos.items"];
            
            
            [self getRestaurantImagesUrl];
        }
        
    }];
}

- (void)getRestaurantImagesUrl{
    
    int x;
    for (x=0; x<self.venuePics.count; x++) {
        NSDictionary *dic = self.venuePics[x];
        NSString *prefix = [dic objectForKey:@"prefix"];
        NSString *suffix = [dic objectForKey:@"suffix"];
        NSString *height = [dic objectForKey:@"height"];
        NSString *width = [dic objectForKey:@"width"];
        NSString *pic_url = [NSString stringWithFormat:@"%@%@x%@%@",prefix,width,height,suffix];
        [self.venuePicUrls addObject:pic_url];
    }
    
    if (x==self.venuePics.count) {
        
        self.topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, 320, 215)];
        [self.topScrollView setBackgroundColor:[UIColor clearColor]];
        self.topScrollView.delegate = self;
        [self.gridScrollView addSubview:self.topScrollView];
        
        [self.topScrollView setPagingEnabled:YES];
        self.topScrollView.showsHorizontalScrollIndicator = NO;
        
        self.hunts_pages = [[UIPageControl alloc] init];
        self.hunts_pages.frame = CGRectMake(141,230,39,37);
        self.hunts_pages.enabled = TRUE;
        [self.hunts_pages setHighlighted:YES];
        [self.gridScrollView addSubview:self.hunts_pages];
        
        self.hunts_pages.backgroundColor = [UIColor clearColor];
        self.hunts_pages.numberOfPages = self.venuePicUrls.count;
        self.hunts_pages.currentPage = 0;
        
        self.topScrollView.contentSize = CGSizeMake(self.topScrollView.frame.size.width * self.venuePics.count, self.topScrollView.frame.size.height);
        [self placetheFoursquareImages];
        
        _backBtnImage = [[UIImageView alloc]initWithFrame:CGRectMake(12, 28, 19, 18)];
        _backBtnImage.image = [UIImage imageNamed:@"back_artisse_2.png"];
        [self.gridScrollView addSubview:_backBtnImage];
        
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setFrame:CGRectMake(10, 20, 40, 40)];
        [_backBtn setTitle:@"" forState:UIControlStateNormal];
        [_backBtn setBackgroundColor:[UIColor clearColor]];
        //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [self.gridScrollView addSubview:_backBtn];
        
//        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 270, 22)];
//        titleLabel.textColor = [UIColor whiteColor];
//        [titleLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:20]];
//        titleLabel.text = [NSString stringWithFormat:@"%@",[self.selectedRestaurantName uppercaseString]];
//        titleLabel.textAlignment = NSTextAlignmentCenter;
//        titleLabel.adjustsFontSizeToFitWidth = YES;
//        titleLabel.numberOfLines = 0;
//        [titleLabel sizeToFit];
//        titleLabel.layer.masksToBounds = NO;
//        titleLabel.backgroundColor = [UIColor clearColor];
//        [self.view addSubview:titleLabel];

    }
    
}

- (void)placetheFoursquareImages{
    if (q<self.venuePicUrls.count) {
        
        new_page_frame = CGRectMake(q * 320, 0, 320, 215);
        self.FeaturedView = [[UIView alloc]initWithFrame:new_page_frame];
        
        [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:self.venuePicUrls[q]]
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
                 UIImageView *bg_image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 215)];
                 [bg_image setImage:image];
                 bg_image.opaque = YES;
                 bg_image.contentMode = UIViewContentModeScaleAspectFill;

                 [self.FeaturedView addSubview:bg_image];
                 [self.FeaturedView setBackgroundColor:[UIColor clearColor]];
                 
                 [self.topScrollView addSubview:self.FeaturedView];
                 
                 q++;
                 
                 [self placetheFoursquareImages];
                 
             }
         }];
        
        
        
    }
}

- (void)addMenu
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Add a Menu", @"title")
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                          otherButtonTitles:@"Submit",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != [alertView cancelButtonIndex])
    {
        if (_menuObjects.count==1) {
            _menuObjects = [NSMutableArray new];
        }
        NSString *entered = [alertView textFieldAtIndex:0].text;
        //NSLog(@"entered = %@",entered);
        [self.menuObjects insertObject:entered atIndex:0];
        [self.menuTableView reloadData];
    }
}

- (void)reviewsButtonClicked:(id)sender{
    
    [self.gridScrollView setContentSize:CGSizeMake(320, contentSize)];
    
    [self.reviewsImageView setHidden:NO];
    [self.detailsImageView setHidden:YES];
    [self.menuImageView setHidden:YES];
    
    [self.reviewsView setHidden:NO];
    [self.detailsView setHidden:YES];
    [self.menuView setHidden:YES];
    [self.menuTableView setHidden:YES];

}

- (void)detailsButtonClicked:(id)sender{
    
    [self.gridScrollView setContentSize:CGSizeMake(320, contentSize2)];
    
    [self.reviewsImageView setHidden:YES];
    [self.detailsImageView setHidden:NO];
    [self.menuImageView setHidden:YES];
    
    [self.reviewsView setHidden:YES];
    [self.detailsView setHidden:NO];
    [self.menuView setHidden:YES];
    [self.menuTableView setHidden:YES];
}

- (void)menuButtonClicked:(id)sender{
    
    [self.gridScrollView setContentSize:CGSizeMake(320, self.view.frame.size.height+320)];
    
    [self.reviewsImageView setHidden:YES];
    [self.detailsImageView setHidden:YES];
    [self.menuImageView setHidden:NO];
    
    [self.reviewsView setHidden:YES];
    [self.detailsView setHidden:YES];
    [self.menuView setHidden:NO];
    [self.menuTableView setHidden:NO];
    
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

- (IBAction)navButtonClicked:(id)sender {
    
    UIButton *button = sender;
    switch (button.tag) {
        case 0: {
            self.navButton.tag = 1;
            self.navButton3.tag = 1;
            [_delegate movePanelToOriginalPosition];
            
            break;
        }
            
        case 1: {
            
            self.navButton.tag = 0;
            self.navButton3.tag = 0;
            [_delegate movePanelRight];
            
            break;
        }
            
        default:
            break;
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
    
    // NSLog(@"%s: controller.view.window=%@", _func_, controller.view.window);
    UIView *containerView = self.view.window;
    [containerView.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setupNewsFeed
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
        _collectionName1 = @"yookaPosts2";
        _customEndpoint1 = @"VenueImage";
        _fieldName1 = @"postDate";
        //NSLog(@"selected restaurant = %@",_selectedRestaurantName);
        _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_collectionName1,@"collectionName",_fieldName1,@"fieldName",_selectedRestaurantName,@"venueName", nil];
        
        [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
            
            if ([results isKindOfClass:[NSArray class]]) {
                _newsFeed = [NSMutableArray arrayWithArray:results];
                if (_newsFeed && _newsFeed.count) {
                    
                    
                    [self fillPictures];
                    
                }else{
                    
                    if (!self.newsFeed.count){
                        UIImageView *header_strip2 = [[UIImageView alloc]initWithFrame:CGRectMake(35, 45, 250, 170)];
                        [header_strip2 setImage:[UIImage imageNamed:@"doggy.png"]];
                        [header_strip2 setBackgroundColor:[UIColor clearColor]];
                        [self.reviewsView addSubview:header_strip2];
                        
                        UILabel* share_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 185, 320, 30)];
                        share_label.text = [NSString stringWithFormat:@"SHARE YOUR EXPERIENCE"];
                        //share_label.textColor = [self colorWithHexString:@"e5e4e4"];
                        share_label.textColor = [UIColor lightGrayColor];
                        [share_label setFont:[UIFont fontWithName:@"OpenSans-Bold" size:20]];
                        share_label.textAlignment = NSTextAlignmentCenter;
                        [self.reviewsView addSubview:share_label];
                        
                        
                        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 245, 320, 1)];
                        lineView.backgroundColor = [self colorWithHexString:@"e5e4e4"];
                        [self.reviewsView addSubview:lineView];
                        
                        if ([KCSUser activeUser].email) {
                            self.uploadButton = [[UIButton alloc]initWithFrame:CGRectMake(133, 247, 43, 43)];
                            [self.uploadButton setImage:[UIImage imageNamed:@"camera_blue.png"] forState:UIControlStateNormal];
                            [self.uploadButton addTarget:self action:@selector(uploadBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                            //self.uploadButton.tag = b;
                            [self.reviewsView addSubview:self.uploadButton];
                        }
                        
                    }
                    
                    
                    
                }
                
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

- (void)uploadBtnTouched:(id)sender
{
  
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
    media.venueID = self.venueID;
    media.venueSelected = self.selectedRestaurantName;
    //media.huntName = _huntTitle;
    //media.huntCount = [NSString stringWithFormat:@"%d",[self.my_hunt_count intValue]+1];
    //media.totalHuntCount = _hunt_count;
    [self presentViewController:media animated:NO completion:nil];
    
}

- (void)fillPictures
{

    
    
    if (i==self.newsFeed.count) {
    }
    if (i<self.newsFeed.count) {
        
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                 (row*400)+55,
                                                                 yookaThumbnailWidth2013,
                                                                 yookaThumbnailHeight2013)];
            
            contentSize += (yookaThumbnailHeight2013);
            button.tag = i;
//            [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundColor:[UIColor clearColor]];
            row++;
        
            [self.gridScrollView setContentSize:CGSizeMake(320, contentSize)];
            [self.reviewsView addSubview:button];
            [self.thumbnails addObject:button];
        

        
        NSString *dishName = [self.newsFeed[i] objectForKey:@"dishName"];
        NSString *venueName = [self.newsFeed[i] objectForKey:@"venueName"];
        NSString *venueAddress = [self.newsFeed[i] objectForKey:@"venueAddress"];
        NSString *caption = [self.newsFeed[i] objectForKey:@"caption"];
        NSString *post_vote = [self.newsFeed[i] objectForKey:@"postVote"];
        NSString *kinveyId = [self.newsFeed[i] objectForKey:@"_id"];
        NSString *hunt_name = [self.newsFeed[i] objectForKeyedSubscript:@"HuntName"];
        NSString *picUrl = [[self.newsFeed[i] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
        
                
                [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:picUrl]
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
                         UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(14, 40, 286, 280)];
                         buttonImage.image = image;
                         [button addSubview:buttonImage];
                         
                         UIImageView *header_strip = [[UIImageView alloc]initWithFrame:CGRectMake(10, -1.5, 290, 46.5)];
                         [header_strip setImage:[UIImage imageNamed:@"Header_strip.png"]];
                         [button addSubview:header_strip];
                         
                         UIImageView *white_bg = [[UIImageView alloc]initWithFrame:CGRectMake(14, 320, 286, 70)];
                         [white_bg setBackgroundColor:[UIColor whiteColor]];
                         [button addSubview:white_bg];
                         
                         UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 325, 270, 25)];
                         dishLabel.textColor = [UIColor lightGrayColor];
                         [dishLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:13]];
                         dishLabel.text = [dishName uppercaseString];
                         dishLabel.textAlignment = NSTextAlignmentLeft;
                         dishLabel.adjustsFontSizeToFitWidth = NO;
                         dishLabel.clipsToBounds = YES;
                         dishLabel.layer.masksToBounds = NO;
                         dishLabel.backgroundColor = [UIColor clearColor];
                         [button addSubview:dishLabel];
                         
                         UILabel *captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 342, 270, 25)];
                         captionLabel.textColor = [UIColor lightGrayColor];
                         [captionLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:11]];
                         captionLabel.text = [NSString stringWithFormat:@"\"%@\"",caption];
                         captionLabel.textAlignment = NSTextAlignmentLeft;
                         captionLabel.clipsToBounds = YES;
//                         captionLabel.adjustsFontSizeToFitWidth = YES;
//                         captionLabel.numberOfLines = 0;
//                         [captionLabel sizeToFit];
                         captionLabel.layer.masksToBounds = NO;
                         captionLabel.backgroundColor = [UIColor clearColor];
                         [button addSubview:captionLabel];
                         
                         NSDate *createddate = [_newsFeed[i] objectForKey:@"postDate"];
                         NSDate *now = [NSDate date];
                         NSString *str;
                         NSMutableString *myString = [NSMutableString string];
                         
                         NSTimeInterval secondsBetween = [now timeIntervalSinceDate:createddate];
                         if (secondsBetween<60) {
                             int duration = secondsBetween;
                             str = [NSString stringWithFormat:@"%d sec",duration]; //%d or %i both is ok.
                             [myString appendString:str];
                         }else if (secondsBetween<3600) {
                             int duration = secondsBetween / 60;
                             str = [NSString stringWithFormat:@"%d min",duration]; //%d or %i both is ok.
                             [myString appendString:str];
                         }else if (secondsBetween<86400){
                             int duration = secondsBetween / 3600;
                             if (duration == 1) {
                                 str = [NSString stringWithFormat:@"%d hr",duration]; //%d or %i both is ok.
                                 [myString appendString:str];
                             }else{
                                 str = [NSString stringWithFormat:@"%d hrs",duration]; //%d or %i both is ok.
                                 [myString appendString:str];
                             }

                         }else if (secondsBetween<604800){
                             int duration = secondsBetween / 86400;
                             if (duration==1) {
                                 str = [NSString stringWithFormat:@"%d day",duration]; //%d or %i both is ok.
                                 [myString appendString:str];
                             }else{
                                 str = [NSString stringWithFormat:@"%d days",duration]; //%d or %i both is ok.
                                 [myString appendString:str];
                             }

                         }else {
                             int duration = secondsBetween / 604800;
                             if(duration==1) {
                                 str = [NSString stringWithFormat:@"%d week",duration]; //%d or %i both is ok.
                             }else{
                                 str = [NSString stringWithFormat:@"%d weeks",duration]; //%d or %i both is ok.
                             }
                             [myString appendString:str];
                         }
                         
//                         UIImageView *clockView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 360, 20, 28)];
//                         clockView.image = [UIImage imageNamed:@"timestamp_clock.png"];
//                         [button addSubview:clockView];
                         
                         UILabel* time_label = [[UILabel alloc] initWithFrame:CGRectMake(25, 365, 150, 12)];
                         time_label.text = [NSString stringWithFormat:@"🕔 %@ ago",myString];
                         time_label.textColor = [UIColor lightGrayColor];
                         [time_label setFont:[UIFont fontWithName:@"Montserrat-Regular" size:9]];
                         time_label.textAlignment = NSTextAlignmentLeft;
                         [button addSubview:time_label];
                         
                         UIImageView *rateView = [[UIImageView alloc]initWithFrame:CGRectMake(235, 290, 25, 20)];
                         rateView.image = [UIImage imageNamed:@"rating.png"];
                         [button addSubview:rateView];
                         
                         UILabel *rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(262, 293, 35, 15)];
                         rateLabel.textColor = [UIColor whiteColor];
                         rateLabel.backgroundColor=[UIColor clearColor];
                         [rateLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12]];
                         if ([post_vote isEqualToString:@"YAY"]) {
                             rateLabel.text = [NSString stringWithFormat:@"100%%"];
                         }else{
                             rateLabel.text = [NSString stringWithFormat:@"0%%"];
                         }
                         rateLabel.textAlignment = NSTextAlignmentLeft;
                         rateLabel.adjustsFontSizeToFitWidth = YES;
                         [button addSubview:rateLabel];
                         i++;
                         if (i==self.newsFeed.count) {
                             [self loadImages2];
                         }
                         [self fillPictures];
                         
                     }
                 }];
        
    }
    
}

- (void)loadImages2
{
    //    NSLog(@"load images");
    if (j<_newsFeed.count) {

        NSString *venueName = [_newsFeed[j] objectForKey:@"venueName"];
        NSString *venueAddress = [_newsFeed[j] objectForKey:@"venueAddress"];
        NSString *venueState = [_newsFeed[j] objectForKey:@"venueState"];
        
        
        UIButton* button = [self.thumbnails objectAtIndex:j];
        

        
        if(venueAddress){
            UILabel *venueLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 15, 200, 20)];
            venueLabel.textColor = [UIColor whiteColor];
            [venueLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:8]];
            venueLabel.text = [NSString stringWithFormat:@"%@, %@",[venueAddress uppercaseString],[venueState uppercaseString]];
            venueLabel.textAlignment = NSTextAlignmentLeft;
            venueLabel.adjustsFontSizeToFitWidth = YES;
            [venueLabel setBackgroundColor:[UIColor clearColor]];
            [button addSubview:venueLabel];
        }
        
        NSString *userId = [_newsFeed[j] objectForKey:@"userEmail"];
        

            
            //            NSString *venueName = [_newsFeed[j] objectForKey:@"venueName"];
            
            [[SDImageCache sharedImageCache] queryDiskCacheForKey:userId done:^(UIImage *image, SDImageCacheType cacheType)
             {
                 if(image){
                     
                     //                     UIImageView *buttonImage3 = [[UIImageView alloc]initWithFrame:CGRectMake( 4.5, 5, 34, 39)];
                     //                     buttonImage3.image = [UIImage imageNamed:@"regular_timeline_imagesize.png"];
                     //                     [button addSubview:buttonImage3];
                     
                     UIImageView *buttonImage4 = [[UIImageView alloc]initWithFrame:CGRectMake( 14, 2, 35, 35)];
                     buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                     [buttonImage4.layer setBorderWidth:2.0];
                     [buttonImage4.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                     [buttonImage4 setContentMode:UIViewContentModeScaleAspectFit];
                     buttonImage4.clipsToBounds = YES;
                     buttonImage4.image = nil;
                     buttonImage4.opaque = YES;
                     
                     buttonImage4.image = image;
                     [button addSubview:buttonImage4];
                     
                     UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
                     [user_button  setFrame:CGRectMake(14, 2, 35, 35)];
                     [user_button setBackgroundColor:[UIColor clearColor]];
                     user_button.tag = j;
                     [user_button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
                     [button addSubview:user_button];
                     
                     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                     NSString *userFullName = [ud objectForKey:userId];
                     NSLog(@"user id = %@",userId);
                     NSLog(@"user full name = %@",userFullName);
                     
                     if (userFullName) {
                         
                         UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 230, 15)];
                         userLabel.textColor = [UIColor whiteColor];
                         userLabel.textAlignment = NSTextAlignmentLeft;
                         userLabel.clipsToBounds = YES;
                         userLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
                         if ([_newsFeed[j] objectForKey:@"postType"]) {
                             NSLog(@"type yes");
                             userLabel.text = [[_newsFeed[j] objectForKey:@"postCaption"] uppercaseString];
                             
                         }else{
                             
                             NSLog(@"type no");
                             userLabel.text = [NSString stringWithFormat:@"%@ IS AT %@",[userFullName uppercaseString],[venueName uppercaseString]];                         }
                         [userLabel setBackgroundColor:[UIColor clearColor]];
//                         userLabel.adjustsFontSizeToFitWidth = YES;
                         //                     userLabel.numberOfLines = 0;
                         [button addSubview:userLabel];
                         
                         j++;
                         if (j == _newsFeed.count) {
                             
                             [self loadlikes];
                         }
                         
                         [self loadImages2];
                         
                     }else{
                         
                         _collectionName2 = @"userPicture";
                         _customEndpoint2 = @"NewsFeed";
                         _fieldName2 = @"_id";
                         _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"userEmail",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
                         
                         //        [[button subviews]
                         //         makeObjectsPerformSelector:@selector(removeFromSuperview)];
                         
                         [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
                             if ([results isKindOfClass:[NSArray class]]) {
                                 NSArray *results_array = [NSArray arrayWithArray:results];
                                 if (results_array && results_array.count) {
                                     
                                     //                    NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                                     NSString *userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                                     [_userPicUrls addObject:userPicUrl];
                                     NSString *userFullName = [results[0] objectForKey:@"userFullName"];
                                     [_userNames addObject:userFullName];
                                     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                     [ud setObject:userFullName forKey:userId];
                                     NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
                                     [ud setObject:userPicUrl forKey:userId2];
                                     [ud synchronize];
                                     
                         UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 230, 15)];
                                     userLabel.textColor = [UIColor whiteColor];
                                     userLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
                                     if ([_newsFeed[j] objectForKey:@"postType"]) {
                                         NSLog(@"type yes");
                                         userLabel.text = [[_newsFeed[j] objectForKey:@"postCaption"]uppercaseString];
                                         
                                     }else{
                                         NSLog(@"type no");
                                         userLabel.text = [NSString stringWithFormat:@"%@ IS AT %@",[userFullName uppercaseString],[venueName uppercaseString]];
                                     }
                                     userLabel.textAlignment = NSTextAlignmentLeft;
                                     userLabel.adjustsFontSizeToFitWidth = YES;
                                     //                     userLabel.numberOfLines = 0;
                                     [button addSubview:userLabel];
                                     
                                     
                                     j++;
                                     if (j == _newsFeed.count) {
                                         
                                         [self loadlikes];
                                     }
                                     
                                     [self loadImages2];
                                     
                                 }else{
                                     
                                     j++;
                                     if (j == _newsFeed.count) {
                                         
                                         [self loadlikes];
                                     }
                                     
                                     [self loadImages2];
                                     
                                 }
                                 
                             }else{
                                 
                                 j++;
                                 if (j == _newsFeed.count) {
                                     
                                     [self loadlikes];
                                 }
                                 
                                 [self loadImages2];
                                 
                             }
                             
                         }];
                         
                     }
                     
                     //                [_gridScrollView addSubview:button];
                     //
                     //                 j++;
                     //                 if (j == _newsFeed.count) {
                     //
                     //                     [self loadlikes];
                     //                 }
                     //
                     //                 [self loadImages2];
                     
                 }else{
                     
                     //                 NSLog(@"no cache");
                     _collectionName2 = @"userPicture";
                     _customEndpoint2 = @"NewsFeed";
                     _fieldName2 = @"_id";
                     _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"userEmail",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
                     
                     //        [[button subviews]
                     //         makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     
                     [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
                         if ([results isKindOfClass:[NSArray class]]) {
                             NSArray *results_array = [NSArray arrayWithArray:results];
                             if (results_array && results_array.count) {
                                 //                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                                 NSString *userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                                 [_userPicUrls addObject:userPicUrl];
                                 NSString *userFullName = [results[0] objectForKey:@"userFullName"];
                                 [_userNames addObject:userFullName];
                                 NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                 [ud setObject:userFullName forKey:userId];
                                 NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
                                 [ud setObject:userPicUrl forKey:userId2];
                                 [ud synchronize];
                                 
                                 if (userPicUrl) {
                                     
                                     //                                     UIImageView *buttonImage3 = [[UIImageView alloc]initWithFrame:CGRectMake( 4.5, 5, 34, 39)];
                                     //                                     buttonImage3.image = [UIImage imageNamed:@"regular_timeline_imagesize.png"];
                                     //                                     [button addSubview:buttonImage3];
                                     
                                     UIImageView *buttonImage4 = [[UIImageView alloc]initWithFrame:CGRectMake( 14, 2, 35, 35)];
                                     buttonImage4.layer.cornerRadius = buttonImage4.frame.size.height / 2;
                                     [buttonImage4.layer setBorderWidth:2.0];
                                     [buttonImage4.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                                     [buttonImage4 setContentMode:UIViewContentModeScaleAspectFit];
                                     buttonImage4.clipsToBounds = YES;
                                     buttonImage4.image = nil;
                                     buttonImage4.opaque = YES;
                                     

                                     
                                     [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:userPicUrl]
                                                                                         options:0
                                                                                        progress:^(NSInteger receivedSize, NSInteger expectedSize)
                                      {
                                          // progression tracking code
                                      }
                                                                                       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
                                      {
                                          if (image && finished)
                                          {
                                              //                                         NSLog(@"found image");
                                              [[SDImageCache sharedImageCache] storeImage:image forKey:userId];
                                              
                                              buttonImage4.image = image;
                                              [button addSubview:buttonImage4];
                                              
                                              UIButton *user_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                              [user_button  setFrame:CGRectMake(14, 2, 35, 35)];
                                              [user_button setBackgroundColor:[UIColor clearColor]];
                                              user_button.tag = j;
                                              [user_button addTarget:self action:@selector(buttonAction2:) forControlEvents:UIControlEventTouchUpInside];
                                              [button addSubview:user_button];
                                              
                         UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 5, 230, 15)];
                                              userLabel.textColor = [UIColor whiteColor];
                                              userLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0];
                                              if ([_newsFeed[j] objectForKey:@"postType"]) {
                                                  userLabel.text = [[_newsFeed[j] objectForKey:@"postCaption"]uppercaseString];
                                                  
                                              }else{
                                                  
                                                  userLabel.text = [NSString stringWithFormat:@"%@ IS AT %@",[userFullName uppercaseString],[venueName uppercaseString]];
                                              }
                                              userLabel.textAlignment = NSTextAlignmentLeft;
                                              userLabel.adjustsFontSizeToFitWidth = YES;
                                              [button addSubview:userLabel];
                                              
                                              j++;
                                              if (j == _newsFeed.count) {
                                                  
                                                  [self loadlikes];
                                              }
                                              
                                              [self loadImages2];
                                          }else{
                                              j++;
                                              if (j == _newsFeed.count) {
                                                  
                                                  [self loadlikes];
                                              }
                                              
                                              [self loadImages2];
                                          }
                                          
                                      }];
                                     
                                     //                                     }
                                     //                                 }];
                                     
                                 }else{
                                     
                                     //                        NSLog(@"fail 3");
                                     j++;
                                     if (j == _newsFeed.count) {
                                         
                                         [self loadlikes];
                                         
                                         //                                    [self stopActivityIndicator];
                                         //        NSLog(@"user pic url = %@",_userPicUrls);
                                         
                                     }
                                     
                                     [self loadImages2];
                                     
                                 }
                                 
                                 
                             }else{
                                 //                    NSLog(@"fail 1");
                                 j++;
                                 if (j == _newsFeed.count) {
                                     
                                     [self loadlikes];
                                     
                                     //                                [self stopActivityIndicator];
                                     //        NSLog(@"user pic url = %@",_userPicUrls);
                                     
                                 }
                                 
                                 [self loadImages2];
                             }
                             
                         }else{
                             
                             //                NSLog(@"fail 2");
                             j++;
                             if (j == _newsFeed.count) {
                                 
                                 [self loadlikes];
                                 
                                 //                            [self stopActivityIndicator];
                                 //        NSLog(@"user pic url = %@",_userPicUrls);
                                 
                             }
                             
                             [self loadImages2];
                             
                         }
                     }];
                     
                 }
             }];
            
        }
        
}

- (void)loadlikes
{
    if(k<_newsFeed.count){
        
            NSString *kinveyId = [_newsFeed[k] objectForKey:@"_id"];
            //        NSLog(@"kinveyId = %@",kinveyId);
            
            UIButton* button = [self.thumbnails objectAtIndex:k];
            
            KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
            KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
            
            [store loadObjectWithID:kinveyId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                if (errorOrNil == nil) {
                    if (objectsOrNil && objectsOrNil.count) {
                        
                        YookaBackend *backendObject = objectsOrNil[0];
                        NSMutableArray *myArray = [NSMutableArray arrayWithArray:backendObject.likers];
                        _likes = backendObject.likes;
                        
                        if ([_likes integerValue]>0) {
                            
                            [_likesData addObject:_likes];
                            [_likersData addObject:myArray];
                            
                            if([myArray containsObject:[KCSUser activeUser].email]){
                                
                                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(205, 210, 35, 35)];
                                likesImageView.image = [UIImage imageNamed:@"Heart_fill.png"];
                                [likesImageView setTag:220];
                                [button addSubview:likesImageView];
                                
                                UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 220, 18, 15)];
                                likesLabel.textColor = [UIColor whiteColor];
                                likesLabel.backgroundColor=[UIColor clearColor];
                                [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14]];
                                likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                                likesLabel.textAlignment = NSTextAlignmentLeft;
                                likesLabel.adjustsFontSizeToFitWidth = YES;
                                [likesLabel setTag:221];
                                [button addSubview:likesLabel];
                                
                                UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                [like_button  setFrame:CGRectMake(205, 210, 35, 35)];
                                [like_button setBackgroundColor:[UIColor clearColor]];
                                like_button.tag = k;
                                [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                                [button addSubview:like_button];
                                k++;
                                
                                [self loadlikes];
                                
                            }else{
                                
                                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(205, 210, 35, 35)];
                                likesImageView.backgroundColor=[UIColor clearColor];
                                [likesImageView setTag:220];
                                likesImageView.image = [UIImage imageNamed:@"Wheart.png"];
                                [button addSubview:likesImageView];
                                
                                UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 220, 18, 15)];
                                likesLabel.textColor = [UIColor whiteColor];
                                likesLabel.backgroundColor=[UIColor clearColor];
                                [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14]];
                                likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                                likesLabel.textAlignment = NSTextAlignmentLeft;
                                likesLabel.adjustsFontSizeToFitWidth = YES;
                                [likesLabel setTag:221];
                                [button addSubview:likesLabel];
                                
                                UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                                [like_button  setFrame:CGRectMake(205, 210, 35, 35)];
                                [like_button setBackgroundColor:[UIColor clearColor]];
                                like_button.tag = k;
                                [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                                [button addSubview:like_button];
                                k++;
                                
                                [self loadlikes];
                                
                            }
                            
                        }else{
                            
                            _likes = @"0";
                            
                            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(205, 210, 35, 35)];
                            likesImageView.backgroundColor=[UIColor clearColor];
                            [likesImageView setTag:220];
                            likesImageView.image = [UIImage imageNamed:@"Wheart.png"];
                            [button addSubview:likesImageView];
                            
                            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 220, 18, 15)];
                            likesLabel.textColor = [UIColor whiteColor];
                            likesLabel.backgroundColor=[UIColor clearColor];
                            [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14]];
                            likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                            likesLabel.textAlignment = NSTextAlignmentLeft;
                            likesLabel.adjustsFontSizeToFitWidth = YES;
                            [likesLabel setTag:221];
                            [button addSubview:likesLabel];
                            
                            [_likesData addObject:@"0"];
                            [_likersData addObject:[NSNull null]];
                            
                            UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                            [like_button  setFrame:CGRectMake(205, 210, 35, 35)];
                            [like_button setBackgroundColor:[UIColor clearColor]];
                            like_button.tag = k;
                            [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                            [button addSubview:like_button];
                            k++;
                            
                            [self loadlikes];
                            
                        }
                        
                    }else{
                        
                        _likes = @"0";
                        [_likesData addObject:_likes];
                        [_likersData addObject:[NSNull null]];
                        
                        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(205, 210, 35, 35)];
                        likesImageView.backgroundColor=[UIColor clearColor];
                        likesImageView.image = [UIImage imageNamed:@"Wheart.png"];
                        [likesImageView setTag:220];
                        [button addSubview:likesImageView];
                        
                        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 220, 18, 15)];
                        likesLabel.textColor = [UIColor whiteColor];
                        likesLabel.backgroundColor=[UIColor clearColor];
                        [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14]];
                        likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                        likesLabel.textAlignment = NSTextAlignmentLeft;
                        likesLabel.adjustsFontSizeToFitWidth = YES;
                        [likesLabel setTag:221];
                        [button addSubview:likesLabel];
                        
                        UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                        [like_button  setFrame:CGRectMake(205, 210, 35, 35)];
                        [like_button setBackgroundColor:[UIColor clearColor]];
                        like_button.tag = k;
                        [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                        [button addSubview:like_button];
                        k++;
                        
                        [self loadlikes];
                        
                    }
                    
                } else {
                    
                    //                                            NSLog(@"error occurred: %@", errorOrNil);
                    _likes = @"0";
                    [_likesData addObject:_likes];
                    [_likersData addObject:[NSNull null]];
                    
                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(205, 210, 35, 35)];
                    likesImageView.backgroundColor=[UIColor clearColor];
                    likesImageView.image = [UIImage imageNamed:@"Wheart.png"];
                    [likesImageView setTag:220];
                    [button addSubview:likesImageView];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(235, 220, 18, 15)];
                    likesLabel.textColor = [UIColor whiteColor];
                    likesLabel.backgroundColor=[UIColor clearColor];
                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:14]];
                    likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                    likesLabel.textAlignment = NSTextAlignmentLeft;
                    likesLabel.adjustsFontSizeToFitWidth = YES;
                    [likesLabel setTag:221];
                    [button addSubview:likesLabel];
                    
                    UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                    [like_button  setFrame:CGRectMake(205, 210, 35, 35)];
                    [like_button setBackgroundColor:[UIColor clearColor]];
                    like_button.tag = k;
                    [like_button addTarget:self action:@selector(tapTwice2:) forControlEvents:UIControlEventTouchUpInside];
                    [button addSubview:like_button];
                    k++;
                    
                    [self loadlikes];
                    
                }
            } withProgressBlock:nil];
            
        }
    
}

- (void)buttonAction:(id)sender
{
    UIButton* button1 = sender;
    NSUInteger b = button1.tag;
    
    UIButton* button = [self.thumbnails objectAtIndex:b];
    
    if (p==1){
        self.toggle = @"NO";
    }
    
    if ([self.toggle  isEqual: @"YES"]) {
        
        self.detailsModalView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
        self.detailsModalView.opaque = NO;
        //self.detailsModalView.backgroundColor = [[self colorWithHexString:(@"88888D")] colorWithAlphaComponent:0.46f];
        self.detailsModalView.backgroundColor = [UIColor whiteColor];
        [button addSubview:self.detailsModalView];
        self.toggle = @"NO";
        
        
        if (button.frame.size.width==145){
            
            self.linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.linkButton  setFrame:CGRectMake((button.frame.size.width/4)-23, (button.frame.size.height/4)+14, 41, 44)];
            [self.linkButton setBackgroundColor:[UIColor clearColor]];
            [self.linkButton setBackgroundImage:[[UIImage imageNamed:@"link.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.linkButton setTag:b];
            [self.linkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.linkButton addTarget:self action:@selector(linkBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.linkButton];
            
            self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.likeButton  setFrame:CGRectMake((button.frame.size.width/4)+11, (button.frame.size.height/4)+8, 45, 55)];
            [self.likeButton setBackgroundColor:[UIColor clearColor]];
            [self.likeButton setBackgroundImage:[[UIImage imageNamed:@"like_new.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.likeButton setTag:b];
            [self.likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.likeButton addTarget:self action:@selector(likeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.likeButton];
            
            self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.commentButton  setFrame:CGRectMake((button.frame.size.width/4)+49, (button.frame.size.height/4)+16, 40, 40)];
            [self.commentButton setBackgroundColor:[UIColor clearColor]];
            [self.commentButton setBackgroundImage:[[UIImage imageNamed:@"comments.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.commentButton setTag:b];
            [self.commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.commentButton addTarget:self action:@selector(commentsBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.commentButton];
            
        }else{
            
            self.linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.linkButton  setFrame:CGRectMake((button.frame.size.width/4)+19, (button.frame.size.height/4)+19, 41, 44)];
            [self.linkButton setBackgroundColor:[UIColor clearColor]];
            [self.linkButton setBackgroundImage:[[UIImage imageNamed:@"link.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.linkButton setTag:b];
            [self.linkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.linkButton addTarget:self action:@selector(linkBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.linkButton];
            
            self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.likeButton  setFrame:CGRectMake((button.frame.size.width/4)+53, (button.frame.size.height/4)+13, 45, 55)];
            [self.likeButton setBackgroundColor:[UIColor clearColor]];
            [self.likeButton setBackgroundImage:[[UIImage imageNamed:@"like_new.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.likeButton setTag:b];
            [self.likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.likeButton addTarget:self action:@selector(likeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.likeButton];
            
            self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.commentButton  setFrame:CGRectMake((button.frame.size.width/4)+91, (button.frame.size.height/4)+21, 40, 40)];
            [self.commentButton setBackgroundColor:[UIColor clearColor]];
            [self.commentButton setBackgroundImage:[[UIImage imageNamed:@"comments.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.commentButton setTag:b];
            [self.commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.commentButton addTarget:self action:@selector(commentsBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.commentButton];
            
        }
        
    }else if([self.toggle isEqual:@"NO"]){
        
        self.toggle = @"YES";
        [self.detailsModalView removeFromSuperview];
        [self.linkButton removeFromSuperview];
        [self.likeButton removeFromSuperview];
        [self.commentButton removeFromSuperview];
        
    }else{
        
        
    }
    
}

- (void)buttonAction2:(NSUInteger)tag2
{

    NSUInteger b = tag2;
    
    UIButton* button = [self.thumbnails objectAtIndex:b];
    
    if (p==1){
        self.toggle = @"NO";
    }
    
    if ([self.toggle  isEqual: @"YES"]) {
        
        self.detailsModalView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
        self.detailsModalView.opaque = NO;
        //self.detailsModalView.backgroundColor = [[self colorWithHexString:(@"88888D")] colorWithAlphaComponent:0.46f];
        self.detailsModalView.backgroundColor = [UIColor whiteColor];
        [button addSubview:self.detailsModalView];
        self.toggle = @"NO";
        

        
        
        
        if (button.frame.size.width==145){
            
            self.linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.linkButton  setFrame:CGRectMake((button.frame.size.width/4)-23, (button.frame.size.height/4)+14, 41, 44)];
            [self.linkButton setBackgroundColor:[UIColor clearColor]];
            [self.linkButton setBackgroundImage:[[UIImage imageNamed:@"link.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.linkButton setTag:b];
            [self.linkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.linkButton addTarget:self action:@selector(linkBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.linkButton];
            
            self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.likeButton  setFrame:CGRectMake((button.frame.size.width/4)+11, (button.frame.size.height/4)+8, 45, 55)];
            [self.likeButton setBackgroundColor:[UIColor clearColor]];
            [self.likeButton setBackgroundImage:[[UIImage imageNamed:@"like_new.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.likeButton setTag:b];
            [self.likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.likeButton addTarget:self action:@selector(likeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.likeButton];
            
            self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.commentButton  setFrame:CGRectMake((button.frame.size.width/4)+49, (button.frame.size.height/4)+16, 40, 40)];
            [self.commentButton setBackgroundColor:[UIColor clearColor]];
            [self.commentButton setBackgroundImage:[[UIImage imageNamed:@"comments.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.commentButton setTag:b];
            [self.commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.commentButton addTarget:self action:@selector(commentsBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.commentButton];
            
        }else{
            
            self.linkButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.linkButton  setFrame:CGRectMake((button.frame.size.width/4)+19, (button.frame.size.height/4)+19, 41, 44)];
            [self.linkButton setBackgroundColor:[UIColor clearColor]];
            [self.linkButton setBackgroundImage:[[UIImage imageNamed:@"link.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.linkButton setTag:b];
            [self.linkButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.linkButton addTarget:self action:@selector(linkBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.linkButton];
            
            self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.likeButton  setFrame:CGRectMake((button.frame.size.width/4)+53, (button.frame.size.height/4)+13, 45, 55)];
            [self.likeButton setBackgroundColor:[UIColor clearColor]];
            [self.likeButton setBackgroundImage:[[UIImage imageNamed:@"like_new.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.likeButton setTag:b];
            [self.likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.likeButton addTarget:self action:@selector(likeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.likeButton];
            
            self.commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.commentButton  setFrame:CGRectMake((button.frame.size.width/4)+91, (button.frame.size.height/4)+21, 40, 40)];
            [self.commentButton setBackgroundColor:[UIColor clearColor]];
            [self.commentButton setBackgroundImage:[[UIImage imageNamed:@"comments.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
            [self.commentButton setTag:b];
            [self.commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.commentButton addTarget:self action:@selector(commentsBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
            [button addSubview:self.commentButton];
            
        }
        
    }else if([self.toggle isEqual:@"NO"]){
        
        self.toggle = @"YES";
        [self.captionModalView removeFromSuperview];
        [self.linkButton removeFromSuperview];
        [self.likeButton removeFromSuperview];
        [self.commentButton removeFromSuperview];
        
    }else{
        
        
    }
    
}


- (void)linkBtnTouched:(id)sender{
    
    UIButton* button1 = sender;
    NSUInteger b = button1.tag;
    
    self.toggle = @"YES";
    [self.detailsModalView removeFromSuperview];
    [self.linkButton removeFromSuperview];
    [self.likeButton removeFromSuperview];
    [self.commentButton removeFromSuperview];
    
}

- (void)likeBtnTouched:(id)sender{
    
    UIButton* button1 = sender;
    NSUInteger b = button1.tag;
    
    self.toggle = @"YES";
    [self.detailsModalView removeFromSuperview];
    [self.linkButton removeFromSuperview];
    [self.likeButton removeFromSuperview];
    [self.commentButton removeFromSuperview];
    

    _postLikers = [NSMutableArray new];
    
    UIButton* button = [self.thumbnails objectAtIndex:b];
    
    _postId = [_newsFeed[b] objectForKey:@"_id"];
    

    
    if ([button viewWithTag:5]!=nil) {
        
 
        UIView* removeButton = [button viewWithTag:5];
        [removeButton removeFromSuperview];
        
    }else{

        
        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 110, 20, 20)];
        likesImageView.image = [UIImage imageNamed:@"smallheart.png"];
        likesImageView.tag = 5;
        [button addSubview:likesImageView];
        
    }
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store loadObjectWithID:_postId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            if (objectsOrNil && objectsOrNil.count) {
                
                YookaBackend *backendObject = objectsOrNil[0];
                _postLikers = [NSMutableArray arrayWithArray:backendObject.likers];
                _postLikes = backendObject.likes;
                
                if ([_postLikes intValue]==0) {
                    _likeStatus = @"NO";
                }
                

                
                if (!(_postLikers == (id)[NSNull null])) {
                    if ([_postLikers containsObject:_myEmail]) {
                        _likeStatus = @"YES";
                    }else{
                        _likeStatus = @"NO";
                    }
                }else{
                    _likeStatus = @"NO";
                    //        NSLog(@"try try try");
                }
                
                //    NSLog(@"like status = %@",_likeStatus);
                
                if ([_likeStatus isEqualToString:@"YES"]) {
                    
                    NSLog(@"try 1");
                    
                    int post_likes = [_postLikes intValue];
                    post_likes = post_likes-1;
                    _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                    
                    if (_postLikers==(id)[NSNull null]) {
                        //                        [_likersData replaceObjectAtIndex:view.tag withObject:[NSNull null]];
                    }else{
                        [_postLikers removeObject:_myEmail];
                    }
                    
                    //        NSLog(@"likes data 2 = %@",_likesData);
                    //        NSLog(@"likers data 2 = %@",_likersData);
                    
                    //                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 110, 100, 20)];
                    //                    likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                    //                    [button addSubview:likesImageView];
                    
                    //                    NSLog(@"view = %@",[button subviews]);
                    
                    
                    UIView* removeButton2 = [button viewWithTag:6];
                    [removeButton2 removeFromSuperview];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 110, 30, 20)];
                    likesLabel.textColor = [UIColor whiteColor];
                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
                    likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                    likesLabel.textAlignment = NSTextAlignmentCenter;
                    likesLabel.adjustsFontSizeToFitWidth = YES;
                    likesLabel.tag = 6;
                    [button addSubview:likesLabel];
                    
                    //                [self saveSelectedPost];
                    [self saveLikes];
                    _likeStatus = @"NO";
                    
                }else{
                    
                    NSLog(@"try 2");
                    
                    if (_postLikers == (id)[NSNull null]) {
                        //            NSLog(@"post likers 2 = %@",_postLikers);
                        _postLikers = [NSMutableArray arrayWithObject:_myEmail];
                        //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                        
                    }else{
                        //            NSLog(@"post likers 3 = %@",_postLikers);
                        
                        [_postLikers addObject:_myEmail];
                        //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                        
                    }
                    
                    int post_likes = [_postLikes intValue];
                    post_likes=post_likes+1;
                    _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                    //                    [_likesData replaceObjectAtIndex:view.tag withObject:_postLikes];
                    
                    //        NSLog(@"likes data 2 = %@",_likesData);
                    //        NSLog(@"likers data 2 = %@",_likersData);
                    
                    //                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 110, 20, 20)];
                    //                    likesImageView.image = [UIImage imageNamed:@"smallheart.png"];
                    //                    likesImageView.tag = 5;
                    //                    [button addSubview:likesImageView];
                    
                    UIView* removeButton2 = [button viewWithTag:6];
                    [removeButton2 removeFromSuperview];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 110, 30, 20)];
                    likesLabel.textColor = [UIColor whiteColor];
                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
                    likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                    likesLabel.textAlignment = NSTextAlignmentCenter;
                    likesLabel.adjustsFontSizeToFitWidth = YES;
                    likesLabel.tag = 6;
                    [button addSubview:likesLabel];
                    
                    //                [self saveSelectedPost];
                    [self saveLikes];
                    _likeStatus = @"YES";
                    
                }
                
            }else{
                
                NSLog(@"try 3");
                
                _postLikes = @"0";
                
                _likeStatus = @"NO";
                //                NSLog(@"likes = %@",_postLikes);
                
                _postLikers = [NSMutableArray arrayWithObject:_myEmail];
                
                
                int post_likes = [_postLikes intValue];
                post_likes=post_likes+1;
                _postLikes = [NSString stringWithFormat:@"%d",post_likes];
                
                NSLog(@"likes data 2 = %@",_likesData);
                NSLog(@"likers data 2 = %@",_likersData);
                
                //                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 110, 20, 20)];
                //                likesImageView.image = [UIImage imageNamed:@"smallheart.png"];
                //                likesImageView.tag = 5;
                //                [button addSubview:likesImageView];
                
                UIView* removeButton2 = [button viewWithTag:6];
                [removeButton2 removeFromSuperview];
                
                UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 110, 30, 20)];
                likesLabel.textColor = [UIColor whiteColor];
                [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
                likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                likesLabel.textAlignment = NSTextAlignmentCenter;
                likesLabel.adjustsFontSizeToFitWidth = YES;
                likesLabel.tag = 6;
                [button addSubview:likesLabel];
                
                //                [self saveSelectedPost];
                [self saveLikes];
                _likeStatus = @"YES";
                
            }
            
        }else{
            
            //            NSLog(@"try 4");
            
            _postLikes = @"0";
            
            _likeStatus = @"NO";
            //            NSLog(@"likes = %@",_postLikes);
            
            _postLikers = [NSMutableArray arrayWithObject:_myEmail];
            int post_likes = [_postLikes intValue];
            post_likes=post_likes+1;
            _postLikes = [NSString stringWithFormat:@"%d",post_likes];
            
            //        NSLog(@"likes data 2 = %@",_likesData);
            //        NSLog(@"likers data 2 = %@",_likersData);
            
            //            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 110, 20, 20)];
            //            likesImageView.image = [UIImage imageNamed:@"smallheart.png"];
            //            likesImageView.tag = 5;
            //            [button addSubview:likesImageView];
            
            UIView* removeButton2 = [button viewWithTag:6];
            [removeButton2 removeFromSuperview];
            
            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 110, 30, 20)];
            likesLabel.textColor = [UIColor whiteColor];
            [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
            likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
            likesLabel.textAlignment = NSTextAlignmentCenter;
            likesLabel.adjustsFontSizeToFitWidth = YES;
            likesLabel.tag = 6;
            [button addSubview:likesLabel];
            
            //                [self saveSelectedPost];
            [self saveLikes];
            _likeStatus = @"YES";
            
        }
        
    } withProgressBlock:nil];
    
}

- (void)saveLikes
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _postId;
    yookaObject.likes = _postLikes;
    yookaObject.likers = _postLikers;
    [yookaObject.meta setGloballyReadable:YES];
    [yookaObject.meta setGloballyWritable:YES];
    
    KCSUser* myFriend = [KCSUser activeUser];
    [yookaObject.meta.readers addObject:myFriend.userId];
    //add 'myFriend' to the writers list as well
    [yookaObject.meta.writers addObject:myFriend.userId];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            //            NSLog(@"Not saved event (error= %@).",errorOrNil);
            
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                //                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                
            }
        }
    } withProgressBlock:nil];
}


- (void)commentsBtnTouched:(id)sender{
    
    p=1;
    
    NSLog(@"comment button touched");
    UIButton* button1 = sender;
    NSUInteger b = button1.tag;
    NSLog(@"comment button %lu pressed",(unsigned long)b);
    
    self.toggle = @"NO";
    
    NSLog(@"remove");
    
    [self.detailsModalView removeFromSuperview];
    [self.linkButton removeFromSuperview];
    [self.likeButton removeFromSuperview];
    [self.commentButton removeFromSuperview];
    
    UIButton* button = [self.thumbnails objectAtIndex:b];
    
    self.captionModalView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
    self.captionModalView.opaque = NO;
    self.captionModalView.backgroundColor = [[self colorWithHexString:(@"88888D")] colorWithAlphaComponent:0.7f];
    [self.captionModalView setTag:b];
    [button addSubview:self.captionModalView];
    
    NSString *caption = [self.newsFeed[b] objectForKey:@"caption"];
    NSLog(@"caption = %@",caption);
    
    if (button.frame.size.width==145){
        
        UILabel *captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 75, self.captionModalView.frame.size.width-10, self.captionModalView.frame.size.height-75)];
        captionLabel.textColor = [UIColor whiteColor];
        [captionLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:13]];
        captionLabel.text = [NSString stringWithFormat:@"%@",caption];
        captionLabel.textAlignment = NSTextAlignmentCenter;
        captionLabel.adjustsFontSizeToFitWidth = YES;
        captionLabel.numberOfLines = 0;
        [captionLabel sizeToFit];
        CGRect myFrame = captionLabel.frame;
        // Resize the frame's width to 280 (320 - margins)
        // width could also be myOriginalLabelFrame.size.width
        myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, self.captionModalView.frame.size.width-10, myFrame.size.height);
        captionLabel.frame = myFrame;
        [captionLabel setBackgroundColor:[UIColor clearColor]];
        
        [captionLabel setTag:10];
        [self.captionModalView addSubview:captionLabel];
        

        
        NSString *userId = [_newsFeed[b] objectForKey:@"userEmail"];
        NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
        NSString *userId3 = [NSString stringWithFormat:@"%@%@",userId,userId2];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData* imageData = [ud objectForKey:userId3];
        UIImage *image = [UIImage imageWithData:imageData];
        
        
        if (image) {
            UIImageView *userView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 60, 60)];
            userView.layer.cornerRadius = userView.frame.size.height / 2;
            [userView.layer setBorderWidth:2.0];
            [userView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [userView setContentMode:UIViewContentModeScaleAspectFill];
            [userView setClipsToBounds:YES];
            [userView setImage:image];
            [button addSubview:userView];
            //pm
            [userView setTag:11];
        }else{
            [self getUserImage:b];
        }
        
    }else{
        
        UILabel *captionLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 30, self.captionModalView.frame.size.width-75, self.captionModalView.frame.size.height-30)];
        captionLabel.textColor = [UIColor whiteColor];
        [captionLabel setFont:[UIFont fontWithName:@"Montserrat-Bold" size:13]];
        captionLabel.text = [NSString stringWithFormat:@"%@",caption];
        captionLabel.textAlignment = NSTextAlignmentLeft;
        captionLabel.adjustsFontSizeToFitWidth = YES;
        captionLabel.numberOfLines = 0;
        //        [captionLabel sizeToFit];
        [captionLabel setBackgroundColor:[UIColor clearColor]];
        [self.captionModalView addSubview:captionLabel];
        
        NSString *userId = [_newsFeed[b] objectForKey:@"userEmail"];
        NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
        NSString *userId3 = [NSString stringWithFormat:@"%@%@",userId,userId2];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData* imageData = [ud objectForKey:userId3];
        UIImage *image = [UIImage imageWithData:imageData];
        
        
        if (image) {
            UIImageView *userView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 50, 50)];
            userView.layer.cornerRadius = userView.frame.size.height / 2;
            [userView.layer setBorderWidth:2.0];
            [userView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
            [userView setContentMode:UIViewContentModeScaleAspectFill];
            [userView setClipsToBounds:YES];
            [userView setImage:image];
            [button addSubview:userView];
            //pm
            [userView setTag:11];
            
        }else{
            [self getUserImage:b];
        }
        
    }
    
    YookaButton* closeButton = [YookaButton buttonWithType:UIButtonTypeCustom];
    [closeButton  setFrame:CGRectMake((button.frame.size.width)-44, -1,45,25)];
    [closeButton setBackgroundColor:[UIColor clearColor]];
    [closeButton setBackgroundImage:[[UIImage imageNamed:@"close_button.png"]stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0] forState:UIControlStateNormal];
    [closeButton setTag:9];
    closeButton.fourthTag=b;
    
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [button addSubview:closeButton];
    
}

- (void)getUserLikes:(NSUInteger)num{
    
    //    if (n<self.newsFeed.count) {
    NSString *kinveyId = [_newsFeed[num] objectForKey:@"_id"];
    //        NSLog(@"kinveyId = %@",kinveyId);
    
    UIButton* button = [self.thumbnails objectAtIndex:num];
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store loadObjectWithID:kinveyId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            if (objectsOrNil && objectsOrNil.count) {
                
                YookaBackend *backendObject = objectsOrNil[0];
                NSMutableArray *myArray = [NSMutableArray arrayWithArray:backendObject.likers];
                _likes = backendObject.likes;
                
                if ([_likes integerValue]>0) {
                    
                    [_likesData addObject:_likes];
                    [_likersData addObject:myArray];
                    
                    if([myArray containsObject:self.myEmail]){
                        
                        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 110, 20, 20)];
                        likesImageView.image = [UIImage imageNamed:@"smallheart.png"];
                        likesImageView.tag = 5;
                        [button addSubview:likesImageView];
                        
                        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 110, 30, 20)];
                        likesLabel.textColor = [UIColor whiteColor];
                        [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
                        likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                        likesLabel.textAlignment = NSTextAlignmentCenter;
                        likesLabel.adjustsFontSizeToFitWidth = YES;
                        likesLabel.tag = 6;
                        [button addSubview:likesLabel];
                        
                        //                            n++;
                        //                            [self getUserLikes];
                        
                    }else{
                        
                        //                            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 110, 20, 20)];
                        //                            likesImageView.image = [UIImage imageNamed:@"smallheart.png"];
                        //                            [button addSubview:likesImageView];
                        
                        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 110, 30, 20)];
                        likesLabel.textColor = [UIColor whiteColor];
                        [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
                        likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                        likesLabel.textAlignment = NSTextAlignmentCenter;
                        likesLabel.adjustsFontSizeToFitWidth = YES;
                        likesLabel.tag = 6;
                        [button addSubview:likesLabel];
                        
                        //                            UIButton *like_button = [UIButton buttonWithType:UIButtonTypeCustom];
                        //                            [like_button  setFrame:CGRectMake(255, 260, 50, 45)];
                        //                            [like_button setBackgroundColor:[UIColor clearColor]];
                        //                            like_button.tag = k;
                        //                            [like_button addTarget:self action:@selector(likeBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
                        //                            [button addSubview:like_button];
                        
                        //                            n++;
                        //                            [self getUserLikes];
                        
                    }
                    
                }else{
                    
                    _likes = @"0";
                    
                    //                        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 110, 20, 20)];
                    //                        likesImageView.image = [UIImage imageNamed:@"smallheart.png"];
                    //                        [button addSubview:likesImageView];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 110, 30, 20)];
                    likesLabel.textColor = [UIColor whiteColor];
                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
                    likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                    likesLabel.textAlignment = NSTextAlignmentCenter;
                    likesLabel.adjustsFontSizeToFitWidth = YES;
                    likesLabel.tag = 6;
                    [button addSubview:likesLabel];
                    
                    [_likesData addObject:@"0"];
                    [_likersData addObject:[NSNull null]];
                    
                    //                        n++;
                    //                        [self getUserLikes];
                    
                }
                
            }else{
                
                _likes = @"0";
                
                //                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 110, 20, 20)];
                //                    likesImageView.image = [UIImage imageNamed:@"smallheart.png"];
                //                    [button addSubview:likesImageView];
                
                UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 110, 30, 20)];
                likesLabel.textColor = [UIColor whiteColor];
                [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:10]];
                likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
                likesLabel.textAlignment = NSTextAlignmentCenter;
                likesLabel.adjustsFontSizeToFitWidth = YES;
                likesLabel.tag = 6;
                [button addSubview:likesLabel];
                
                [_likesData addObject:@"0"];
                [_likersData addObject:[NSNull null]];
                
                
            }
            
        } else {
            
            //                                            NSLog(@"error occurred: %@", errorOrNil);
            _likes = @"0";
            
            //                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 110, 100, 20)];
            //                likesImageView.image = [UIImage imageNamed:@"smallheart.png"];
            //                likesImageView.tag = 5;
            //                [button addSubview:likesImageView];
            
            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 110, 100, 20)];
            likesLabel.textColor = [UIColor whiteColor];
            [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:15]];
            likesLabel.text = [NSString stringWithFormat:@"%@",_likes];
            likesLabel.textAlignment = NSTextAlignmentCenter;
            likesLabel.adjustsFontSizeToFitWidth = YES;
            likesLabel.tag = 6;
            [button addSubview:likesLabel];
            
            [_likesData addObject:@"0"];
            [_likersData addObject:[NSNull null]];
            
            
        }
    } withProgressBlock:nil];
    
    //    }
    
}

- (void)getUserImage:(NSUInteger)b{
    
    NSString *picUrl = self.user_pic_urls[b];
    NSString *userId = [self.newsFeed[b] objectForKey:@"userEmail"];
    NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
    NSString *userId3 = [NSString stringWithFormat:@"%@%@",userId,userId2];
    
    UIButton* button = [self.thumbnails objectAtIndex:b];
    
    [SDWebImageDownloader.sharedDownloader downloadImageWithURL:[NSURL URLWithString:picUrl]
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
             
             if (button.frame.size.width==145){
                 
                 UIImageView *userView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 60, 60)];
                 userView.layer.cornerRadius = userView.frame.size.height / 2;
                 [userView.layer setBorderWidth:2.0];
                 [userView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                 [userView setContentMode:UIViewContentModeScaleAspectFill];
                 [userView setClipsToBounds:YES];
                 [userView setImage:image];
                 [button addSubview:userView];
                 
             }else{
                 
                 UIImageView *userView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 80, 50, 50)];
                 userView.layer.cornerRadius = userView.frame.size.height / 2;
                 [userView.layer setBorderWidth:2.0];
                 [userView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
                 [userView setContentMode:UIViewContentModeScaleAspectFill];
                 [userView setClipsToBounds:YES];
                 [userView setImage:image];
                 [button addSubview:userView];
                 
             }
             
             
             
             
             NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
             [defaults setObject:UIImagePNGRepresentation(image) forKey:userId3];
             [defaults synchronize];
             
             
         }
     }];
    
}

- (void)getUserDetails:(NSUInteger)num{
    
    NSLog(@"m1=%lu",(unsigned long)num);
    //    if (==self.newsFeed.count) {
    
    //    }
    //    if (m<self.newsFeed.count) {
    NSLog(@"m2=%lu",(unsigned long)num);
    NSLog(@"newsfeed count=%lu",(unsigned long)self.newsFeed.count);
    
    NSString *userId = [_newsFeed[num] objectForKey:@"userEmail"];
    
    NSLog(@"user id = %@",userId);
    
    _collectionName2 = @"userPicture";
    _customEndpoint2 = @"NewsFeed";
    _fieldName2 = @"_id";
    _dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:userId,@"userEmail",_collectionName2,@"collectionName",_fieldName2,@"fieldName", nil];
    
    //        [[button subviews]
    //         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [KCSCustomEndpoints callEndpoint:_customEndpoint2 params:_dict2 completionBlock:^(id results, NSError *error){
        if ([results isKindOfClass:[NSArray class]]) {
            NSArray *results_array = [NSArray arrayWithArray:results];
            if (results_array && results_array.count) {
                
                NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
                NSString *userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
                NSString *userFullName = [results[0] objectForKey:@"userFullName"];
                
                [self.user_full_names addObject:userFullName];
                [self.user_pic_urls addObject:userPicUrl];
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:userFullName forKey:userId];
                NSString *userId2 = [NSString stringWithFormat:@"%@%@",userId,userId];
                [ud setObject:userPicUrl forKey:userId2];
                [ud synchronize];
                
                UIButton* button = [self.thumbnails objectAtIndex:num];
                
                if (button.frame.size.width==145){
                    
                    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 110, 100, 20)];
                    nameLabel.textColor = [UIColor whiteColor];
                    [nameLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12]];
                    nameLabel.text = [userFullName uppercaseString];
                    nameLabel.textAlignment = NSTextAlignmentLeft;
                    //                        nameLabel.adjustsFontSizeToFitWidth = YES;
                    nameLabel.numberOfLines = 0;
                    [button addSubview:nameLabel];
                    
                }else{
                    
                    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 160, 150, 20)];
                    nameLabel.textColor = [UIColor whiteColor];
                    [nameLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:12]];
                    nameLabel.text = [userFullName uppercaseString];
                    nameLabel.textAlignment = NSTextAlignmentLeft;
                    //                        nameLabel.adjustsFontSizeToFitWidth = YES;
                    nameLabel.numberOfLines = 0;
                    [button addSubview:nameLabel];
                    
                }
                
                NSLog(@"TRY 1");
                
                //                    m++;
                //                    [self getUserDetails];
                
            }else{
                
                NSLog(@"TRY 2");
                
                
                [self.user_full_names addObject:@""];
                [self.user_pic_urls addObject:@""];
                
                //                    m++;
                //                    [self getUserDetails];
                
            }
            
        }else{
            
            NSLog(@"TRY 3");
            
            
            [self.user_full_names addObject:@""];
            [self.user_pic_urls addObject:@""];
            
            //                m++;
            //                [self getUserDetails];
            
        }
        
    }];
    
    //    }
    
}

- (void)closeBtnTouched:(id)sender{
    
    p=0;
    

    
    [self.detailsModalView removeFromSuperview];
    
    YookaButton *b3 = (YookaButton*)sender;
    
    NSLog(@"close button touched");
    UIButton* button1 = sender;
    NSUInteger b = button1.tag;
    NSLog(@"close button %lu pressed",(unsigned long)b);
    
    
    UIButton* button = [self.thumbnails objectAtIndex:b3.fourthTag];
    NSLog(@"button subviews = %@",[button subviews]);
    UIView* removeCaption = [button viewWithTag:10];
    UIView* removeProfile = [button viewWithTag:11];
   // UIView* removeButton = [[button subviews]objectAtIndex:4];
    
    UIView* removeCloseButton = [button viewWithTag:9];

    [removeCloseButton removeFromSuperview];
    //[removeButton removeFromSuperview];
    [removeProfile removeFromSuperview];
    [removeCaption removeFromSuperview];
    
    self.toggle = @"NO";
    [self.captionModalView removeFromSuperview];
    //[self.detailsModalView removeFromSuperview];
    NSLog(@"close button %lu pressed",(unsigned long)b3.secondTag);
    [self buttonAction2: (NSUInteger) b3.secondTag];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            
            
            UIImage *flagImage = [UIImage imageNamed:@"pin.png"];
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
            
            //                UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 5, 22, 22)];
            //                tagLabel.textColor = [UIColor blackColor];
            //                tagLabel.font = [UIFont fontWithName:@"Montserrat-Regular" size:18.0];
            //                tagLabel.textAlignment = NSTextAlignmentCenter;
            //                tagLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[_mapAnnotations indexOfObject:annotation]+1];
            //                [annotationView addSubview:tagLabel];
            
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

- (void)addAnnotation
{
    self.mapAnnotations = [[NSMutableArray alloc] init];
    
    NSString *lat = _latitude;
    NSString *lon = _longitude;
    NSString *pinTitle = _selectedRestaurantName;
    //        NSLog(@"lat = %@, lon = %@, rest = %@",lat,lon,pinTitle);
    SFAnnotation *item1 = [[SFAnnotation alloc] init];
    item1.latitude = lat;
    item1.longitude = lon;
    item1.pinTitle = pinTitle;
    
    [self.mapAnnotations insertObject:item1 atIndex:0];
    
    [self.mapView removeAnnotations:self.mapView.annotations];  // remove any annotations that exist
    [self.mapView addAnnotations:self.mapAnnotations];
    
}


- (void)getRestaurantDetails
{
    
    [Foursquare2 venueGetDetail:_venueId callback:^(BOOL success, id result){
        
        if (success) {
            
            CGRect screenRect5 = CGRectMake(161.f, 132.f+85, 155.f, 78.f);
            UIScrollView *timeScrollview=[[UIScrollView alloc] initWithFrame:screenRect5];
            [timeScrollview setContentSize:CGSizeMake(155,78.f)];
            timeScrollview.frame = CGRectMake(161.f, 132.f+85, 155.f, 78.f);
            [timeScrollview setBackgroundColor:[UIColor clearColor]];
            timeScrollview.showsHorizontalScrollIndicator = NO;
            [self.detailsView addSubview:timeScrollview];
            
            NSDictionary *dic = result;
            NSLog(@"venue dic 1");
            if ([dic valueForKeyPath:@"response.venue.attributes.groups"]) {
                NSLog(@"price data = %@",[dic valueForKeyPath:@"response.venue.attributes.groups"]);
                NSArray *attributes_array = [dic valueForKeyPath:@"response.venue.attributes.groups"];
                if (attributes_array.count>0) {
                    NSLog(@"attributes = %@",[attributes_array[0] objectForKey:@"summary"]);
                    NSString *price_string = [attributes_array[0] objectForKey:@"summary"];
                    NSArray *array1 = [dic valueForKeyPath:@"response.venue.hours.timeframes.days"];
                    NSLog(@"array 1 = %@",array1);
                    
                    NSArray *array2 = [dic valueForKeyPath:@"response.venue.hours.timeframes.open.renderedTime"];
                    NSLog(@"array 2 = %@",array2);
                    
                    if (array1.count>0) {
                        for (int a=0; a<array1.count; a++) {
                            
                            self.hoursLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, (a*35)+5, 150, 15)];
                            UIFont *font = [UIFont fontWithName:@"Montserrat-Regular" size:11.0];
                            self.hoursLabel.textAlignment = NSTextAlignmentLeft;
                            NSString* string1 = [[array1[a] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] uppercaseString];
                            NSMutableAttributedString* string = [[NSMutableAttributedString alloc]initWithString:string1];
                            [string addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string.length)];
                            //            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];//TextColor
                            
                            float spacing = 2.4f;
                            [string addAttribute:NSKernAttributeName
                                           value:@(spacing)
                                           range:NSMakeRange(0, [string length])];
                            UIColor * color = [UIColor grayColor];
                            NSNumber* underlineNumber = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
                            [string addAttribute:NSUnderlineStyleAttributeName value:underlineNumber range:NSMakeRange(0, string.length)];
                            //Underline color
                            [string addAttribute:NSUnderlineColorAttributeName value:color range:NSMakeRange(0, string.length)];
                            self.hoursLabel.attributedText = string;
                            [self.hoursLabel setBackgroundColor:[UIColor clearColor]];
                            self.hoursLabel.textColor = [UIColor grayColor];
                            [timeScrollview addSubview:self.hoursLabel];
                            
                            UILabel *time_label = [[UILabel alloc]initWithFrame:CGRectMake(10, (a*35)+20, 150, 15)];
                            time_label.font = [UIFont fontWithName:@"OpenSans" size:10.0];
                            time_label.textAlignment = NSTextAlignmentLeft;
                            NSArray *array_string = array2[a];
                            time_label.text = [array_string[0] uppercaseString];
                            [time_label setBackgroundColor:[UIColor clearColor]];
                            time_label.textColor = [UIColor grayColor];
                            [timeScrollview addSubview:time_label];
                            [timeScrollview setContentSize:CGSizeMake(155,(a*55)+10)];
                            
                        }
                        
                        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 255+85, 270, 50)];
                        self.priceLabel.font = [UIFont fontWithName:@"OpenSans" size:14.0];
                        self.priceLabel.textAlignment = NSTextAlignmentLeft;
                        self.priceLabel.textColor = [UIColor lightGrayColor];
                        NSString *string3;
                        if (price_string.length == 1) {
                            string3 = [NSString stringWithFormat:@"%@$$$",price_string];
                        }else if(price_string.length == 2){
                            string3 = [NSString stringWithFormat:@"%@$$",price_string];
                        }else if (price_string.length == 3){
                            string3 = [NSString stringWithFormat:@"%@$",price_string];
                        }else if(price_string.length == 4){
                            string3 = [NSString stringWithFormat:@"%@",price_string];
                        }else{
                            price_string = @"$$$$";
                            string3 = @"$$$$";
                        }
                        NSMutableAttributedString *attributedString3 = [[NSMutableAttributedString alloc] initWithString:string3];
                        [attributedString3 addAttribute:NSForegroundColorAttributeName
                                                  value:[UIColor darkGrayColor]
                                                  range:NSMakeRange(0, price_string.length)];
                        float spacing3 = 2.4f;
                        [attributedString3 addAttribute:NSKernAttributeName
                                                  value:@(spacing3)
                                                  range:NSMakeRange(0, [string3 length])];
                        self.priceLabel.attributedText = attributedString3;
                        [self.priceLabel setBackgroundColor:[UIColor clearColor]];
                        [self.detailsView addSubview:self.priceLabel];
                    }
                    
                }

            }
            
            _venueAddress = [dic valueForKeyPath:@"response.venue.location.address"];
            _venueCc = [dic valueForKeyPath:@"response.venue.location.cc"];
            _venueCity = [dic valueForKeyPath:@"response.venue.location.city"];
            _venueCountry = [dic valueForKeyPath:@"response.venue.location.country"];
            _venuePostalCode = [dic valueForKeyPath:@"response.venue.location.postalCode"];
            _venueState = [dic valueForKeyPath:@"response.venue.location.state"];
            _phoneLabel = [dic valueForKeyPath:@"response.venue.contact.formattedPhone"];
            _latitude = [NSString stringWithFormat:@"%@",[dic valueForKeyPath:@"response.venue.location.lat"]];
            _longitude = [NSString stringWithFormat:@"%@",[dic valueForKeyPath:@"response.venue.location.lng"]];
            
            
            // set Span
            // start off by default in San Francisco
            MKCoordinateRegion newRegion;
            newRegion.center.latitude = [_latitude doubleValue];
            newRegion.center.longitude = [_longitude doubleValue];

            //    newRegion.center.latitude = [_latitude doubleValue];
            //    newRegion.center.longitude = [_longitude doubleValue];
            newRegion.span.latitudeDelta = 0.00312872;
            newRegion.span.longitudeDelta = 0.00309863;
            
            [self.mapView setRegion:newRegion animated:YES];
            [self.mapView setShowsUserLocation:NO];
//            [self.detailsView addSubview:_mapView];
            
            [self addAnnotation];
            
            
            
            UILabel *call_title = [[UILabel alloc]initWithFrame:CGRectMake(15, 140+85, 150, 20)];
            UIFont *font = [UIFont fontWithName:@"OpenSans" size:14.0];
            call_title.textAlignment = NSTextAlignmentLeft;
            NSString* string12 = @"CALL";
            NSMutableAttributedString* string13 = [[NSMutableAttributedString alloc]initWithString:string12];
            [string13 addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, string13.length)];
            
            float spacing = 2.4f;
            [string13 addAttribute:NSKernAttributeName
                                     value:@(spacing)
                                     range:NSMakeRange(0, [string12 length])];
            //            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];//TextColor
            UIColor * color = [UIColor grayColor];
            NSNumber* underlineNumber = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
            [string13 addAttribute:NSUnderlineStyleAttributeName value:underlineNumber range:NSMakeRange(0, string13.length)];
            //Underline color
            [string13 addAttribute:NSUnderlineColorAttributeName value:color range:NSMakeRange(0, string13.length)];
            call_title.attributedText = string13;
            call_title.textColor = [UIColor grayColor];
            [self.detailsView addSubview:call_title];
            
            if ([dic valueForKeyPath:@"response.venue.contact.formattedPhone"]) {
                self.phoneLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(13, 165+85, 150, 20)];
                self.phoneLabel2.font = [UIFont fontWithName:@"OpenSans" size:12.0];
                self.phoneLabel2.textAlignment = NSTextAlignmentLeft;
                NSString *string = [dic valueForKeyPath:@"response.venue.contact.formattedPhone"];
                self.phoneLabel2.text = string;
                [self.phoneLabel2 setBackgroundColor:[UIColor clearColor]];
                self.phoneLabel2.textColor = [UIColor grayColor];
                [self.detailsView addSubview:self.phoneLabel2];
                
                UIButton *call_button = [UIButton buttonWithType:UIButtonTypeCustom];
                [call_button setFrame:CGRectMake(5, 180, 150, 110)];
                [call_button setBackgroundColor:[UIColor clearColor]];
                //    [_backBtn setBackgroundImage:[[UIImage imageNamed:@"dismiss_Btn.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal];
                [call_button addTarget:self action:@selector(phoneCallAction) forControlEvents:UIControlEventTouchUpInside];
                [self.detailsView addSubview:call_button];
                
            }
            
            UILabel *location_title = [[UILabel alloc]initWithFrame:CGRectMake(170, 247+85, 220, 39)];
            UIFont *font2 = [UIFont fontWithName:@"OpenSans-SemiBold" size:11.0];
            location_title.textAlignment = NSTextAlignmentLeft;
            NSString* string10 = @"LOCATION";
            NSMutableAttributedString* string11 = [[NSMutableAttributedString alloc]initWithString:string10];
            [string11 addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(0, string11.length)];
            //float spacing = 2.4f;
            [string11 addAttribute:NSKernAttributeName
                                     value:@(spacing)
                                     range:NSMakeRange(0, [string10 length])];
            //            [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, string.length)];//TextColor
            UIColor * color2 = [UIColor grayColor];
            NSNumber* underlineNumber2 = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
            [string11 addAttribute:NSUnderlineStyleAttributeName value:underlineNumber2 range:NSMakeRange(0, string11.length)];
            //Underline color
            [string11 addAttribute:NSUnderlineColorAttributeName value:color2 range:NSMakeRange(0, string11.length)];
            location_title.attributedText = string11;
            location_title.textColor = [UIColor grayColor];            
            [self.detailsView addSubview:location_title];
            
            self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 275+85, 220, 39)];
            self.addressLabel.font = [UIFont fontWithName:@"OpenSans" size:11.0];
            self.addressLabel.textAlignment = NSTextAlignmentLeft;
            self.addressLabel.text = [NSString stringWithFormat:@"%@\n%@, %@",_venueAddress,_venueCity,_venuePostalCode];
            self.addressLabel.textColor = [UIColor grayColor];
            self.addressLabel.adjustsFontSizeToFitWidth = YES;
            self.addressLabel.numberOfLines = 0;
            [self.detailsView addSubview:_addressLabel];
            
        }
        
    }];
    
}

- (void)phoneCallAction
{
    UIDevice *device = [UIDevice currentDevice];
    if ([[device model] isEqualToString:@"iPhone"] ) {
        NSString *cleanedString = [[_phoneLabel componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
        NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", cleanedString]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",telURL]]];
    } else {
        UIAlertView *notPermitted=[[UIAlertView alloc] initWithTitle:@"Alert" message:@"Your device doesn't support this feature." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [notPermitted show];
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        contentSize3 = 320+(int)(50*self.filteredArray.count);
        return [self.filteredArray count];
        
    } else {
        contentSize3 = 320+(int)(50*self.menuObjects.count);
        return self.menuObjects.count;
    }}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (self.filteredArray.count) {
            return 1;
        }
    } else {
        if (self.menuObjects.count) {
            return 1;
        }    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_menuTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        //        if(indexPath.row % 2 == 0)
        //            cell.backgroundColor = [self colorWithHexString:@"43444F"];
        //        else
        //            cell.backgroundColor = [self colorWithHexString:@"2F2F36"];
        
        // create a custom label:                                        x    y   width  height
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(40.0, 0.0, 260.0, 40.0)];
        [_descriptionLabel setTag:1];
        [_descriptionLabel setBackgroundColor:[UIColor clearColor]]; // transparent label background
        _descriptionLabel.textColor = [UIColor lightGrayColor];
        _descriptionLabel.textAlignment = NSTextAlignmentLeft;
        [_descriptionLabel setFont:[UIFont fontWithName:@"OpenSans" size:17]];
        // custom views should be added as subviews of the cell's contentView:
        [cell.contentView addSubview:_descriptionLabel];

    }
    
    //    cell.textLabel.text = self.menuObjects[indexPath.row];
    //    FSVenue *venue = self.nearbyVenues[indexPath.row];
    //    if (venue.location.address) {
    //        //        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m, %@",
    //        //                                     venue.location.distance,
    //        //                                     venue.location.address];
    //    } else {
    //        //        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@m",
    //        //                                     venue.location.distance];
    //    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [(UILabel *)[cell.contentView viewWithTag:1] setText:self.filteredArray[indexPath.row]];
    } else {
        [(UILabel *)[cell.contentView viewWithTag:1] setText:self.menuObjects[indexPath.row]];
    }
    
    //    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(20,6, 30, 31)];
    //    imv.image=[UIImage imageNamed:@"check_box.jpeg"];
    //    [cell.contentView addSubview:imv];
    
    return cell;
}

- (void)tableView: (UITableView *)tableView willDisplayCell: (UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath *)indexPath {
    
//    if(indexPath.row % 2 == 0)
//        cell.backgroundColor = [self colorWithHexString:@"43444F"];
//    else
//        cell.backgroundColor = [self colorWithHexString:@"2F2F36"];
}

#pragma mark - Table view delegate

- (void)checkin {
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    //    CheckinViewController *checkin = [storyboard instantiateViewControllerWithIdentifier:@"CheckinVC"];
    //    checkin.venue = self.selected;
    //    [self.navigationController pushViewController:checkin animated:YES];
}

- (void)userDidSelectVenue {
    
    //    YookaPostViewController *media = [[YookaPostViewController alloc]init];
    //    NSLog(@"venue id = %@",_venueID);
    //    NSLog(@"venue name = %@",_venueSelected);
    //    media.venueID = _venueID;
    //    media.venueSelected = _venueSelected;
    //    media.menuSelected = _menuSelected;
    //    media.huntName = _huntName;
    //    media.venueAddress = _venueAddress;
    //    media.venueCc = _venueCc;
    //    media.venueCity = _venueCity;
    //    media.venueCountry = _venueCountry;
    //    media.venueState = _venueState;
    //    media.venuePostalCode = _venuePostalCode;
    //    [self.navigationController pushViewController:media animated:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* theCell = [tableView cellForRowAtIndexPath:indexPath];
    //Deselect the cell
    ////theCell.selectionStyle = UITableViewCellSelectionStyleNone;
    theCell.textLabel.backgroundColor = [UIColor clearColor];
    
    theCell.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    

    
}

- (void)getVenuesForLocation:(CLLocation *)location {
    
    [Foursquare2 venueSearchNearByLatitude:@(location.coordinate.latitude)
                                 longitude:@(location.coordinate.longitude)
                                     query:@"restaurant"
                                     limit:@(100)
                                    intent:intentBrowse
                                    radius:@(1000)
                                categoryId:nil
                                  callback:^(BOOL success, id result){
                                      if (success) {
                                          NSDictionary *dic = result;
                                          //NSLog(@"dic = %@",dic);
                                          NSArray *venues = [dic valueForKeyPath:@"response.venues"];
                                          FSConverter *converter = [[FSConverter alloc]init];
                                          self.menu = [converter convertToObjects:venues];
                                          [_menuTableView reloadData];
                                          //                                          [self proccessAnnotations];
                                          
                                      }
                                  }];
}

- (void)getMenuForVenue {
    
    [Foursquare2 venueGetMenu:self.venueId
                     callback:^(BOOL success, id result){
                         if (success) {
                             NSDictionary *dic = result;
                             NSString *menus = [dic valueForKeyPath:@"response.menu.menus.count"];
                             
                             if (!([menus isEqual:0])) {
                                 
                                 NSString *menu1 = [result valueForKeyPath:@"response.menu.menus.items.entries.items.entries.items.name"];
                                 if (menu1) {
                                     NSData *jsonData = [NSJSONSerialization dataWithJSONObject:menu1 options:NSJSONWritingPrettyPrinted error:nil];
                                     NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                     
                                     _menuObjects = [NSMutableArray array];
                                     NSScanner *scanner = [NSScanner scannerWithString:jsonString];
                                     NSString *tmp;
                                     
                                     while ([scanner isAtEnd] == NO)
                                     {
                                         [scanner scanUpToString:@"\"" intoString:NULL];
                                         [scanner scanString:@"\"" intoString:NULL];
                                         [scanner scanString:@"\\" intoString:NULL];
                                         [scanner scanUpToString:@"\"" intoString:&tmp];
                                         if ([scanner isAtEnd] == NO)
                                             [_menuObjects addObject:tmp];
                                         [scanner scanString:@"\"" intoString:NULL];
                                     }
                                     
                                         [self getYookaMenuForVenue];
                                 }else{
                                     [self getYookaMenuForVenue];
                                 }

                             }
                             
                         }
                     }];
}

- (void)getYookaMenuForVenue{
    //    NSString *string = @"Add a Menu";
    //    [_menuObjects insertObject:string atIndex:0];
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"yookaMenuDB" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery* query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:self.venueId];
    //    KCSQuery* query2 = [KCSQuery queryOnField:@"HuntName" withExactMatchForValue:_cachesubscribedHuntNames[j]];
    //    KCSQuery* query3 = [KCSQuery queryOnField:@"postType" usingConditional:kKCSNotEqual forValue:@"started hunt"];
    //    KCSQuery* query4 = [KCSQuery queryForJoiningOperator:kKCSAnd onQueries:query,query2,query3, nil];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            [self.menuTableView reloadData];
        } else {
            
            //got all events back from server -- update table view
            NSMutableArray *array1 = [NSMutableArray new];
            
            if (objectsOrNil.count>0) {
                YookaBackend *yooka = objectsOrNil[0];
                array1 = [NSMutableArray arrayWithArray:yooka.menu_list];
                [array1 addObjectsFromArray:self.menuObjects];
                self.menuObjects = array1;
                [self.menuTableView reloadData];
            }else{
                [self.menuTableView reloadData];
            }
            
        }
    } withProgressBlock:nil];
    
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    [self.filteredArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    self.filteredArray = [NSMutableArray arrayWithArray:[self.menuObjects filteredArrayUsingPredicate:predicate]];
    [self.menuTableView reloadData];
    
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    
    return YES;
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
