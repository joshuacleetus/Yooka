//
//  YookaProfileViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 12/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaProfileViewController.h"
#import "YookaViewController.h"
#import "YookaAppDelegate.h"
#import "UserFollowingViewController.h"
#import "UserFollowersViewController.h"
#import <AsyncImageDownloader.h>
#import <QuartzCore/QuartzCore.h>
#import "YookaBackend.h"

#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

const NSInteger yookaThumbnailWidth = 160;
const NSInteger yookaThumbnailHeight = 160;
const NSInteger yookaImagesPerRow = 2;
const NSInteger yookaThumbnailSpace = 0;

@interface YookaProfileViewController ()

@end

@implementation YookaProfileViewController

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
    
    self.updateStore = [KCSLinkedAppdataStore storeWithOptions:@{
                                                                 KCSStoreKeyCollectionName : @"userPicture",
                                                                 KCSStoreKeyCollectionTemplateClass : [YookaBackend class]}];
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    
    [_gridScrollView removeFromSuperview];
    
    i=0;
    j=0;
    skip = 20;
    
    _myPosts = [NSMutableArray new];
    _thumbnails = [NSMutableArray new];
    _followerUsers = [NSMutableArray new];
    _followingUsers = [NSMutableArray new];
    
    _userEmail = [[KCSUser activeUser] email];
    
    CGRect screenRect = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    _gridScrollView=[[UIScrollView alloc] initWithFrame:screenRect];
    _gridScrollView.contentSize= self.view.bounds.size;
    _gridScrollView.frame = CGRectMake(0.f, 0.f, 320.f, self.view.frame.size.height);
    [self.view addSubview:_gridScrollView];
    
    if ([[UIScreen mainScreen] bounds].size.height == 568) {
        [_gridScrollView setContentSize:CGSizeMake(320, 500)];
    }else{
        [_gridScrollView setContentSize:CGSizeMake(320, 500)];
    }
    
    _profile_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 208)];
    [self.profile_bg setImage:[self blur:[UIImage imageNamed:@"profile_bg@2x.png"]]];
    [self.gridScrollView addSubview:_profile_bg];
    
    _userView = [[UIImageView alloc]initWithFrame:CGRectMake(115, 29, 90, 90)];
    self.userView.layer.cornerRadius = self.userView.frame.size.height / 2;
    [self.userView.layer setBorderWidth:4.0];
    [self.userView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
//    [self.userView setContentMode:UIViewContentModeScaleAspectFit];
//    [self.userView setClipsToBounds:YES];
//    self.userView.frame = self.view.bounds;
    [self.gridScrollView addSubview:_userView];
    
    self.circle_one = [[UIView alloc]initWithFrame:CGRectMake(105, 19, 110, 110)];
    self.circle_one.layer.cornerRadius = self.circle_one.frame.size.height / 2;
    [self.circle_one.layer setBorderWidth:4.0];
    [self.circle_one.layer setBorderColor:[[[UIColor whiteColor]colorWithAlphaComponent:0.10f] CGColor]];
    [self.profile_bg addSubview:self.circle_one];
    
    self.circle_two = [[UIView alloc]initWithFrame:CGRectMake(95, 9, 130, 130)];
    self.circle_two.layer.cornerRadius = self.circle_two.frame.size.height / 2;
    [self.circle_two.layer setBorderWidth:4.0];
    [self.circle_two.layer setBorderColor:[[[UIColor whiteColor]colorWithAlphaComponent:0.10f] CGColor]];
    [self.profile_bg addSubview:self.circle_two];
    
    _usernameLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 142, 280, 24)];
    _usernameLbl.textColor = [UIColor whiteColor];
    _usernameLbl.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0];
    _usernameLbl.text = _userFullName;
    _usernameLbl.textAlignment = NSTextAlignmentCenter;
    [self.gridScrollView addSubview:_usernameLbl];
    
    _profileLbl1 =[[UILabel alloc]initWithFrame:CGRectMake(0, 176, 320, 32)];
    [_profileLbl1 setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [self.gridScrollView addSubview:_profileLbl1];
    
    _profile_bg1 = [[UIImageView alloc]initWithFrame:CGRectMake(9, 187, 228, 9)];
    _profile_bg1.image = [UIImage imageNamed:@"profile_icons.png"];
    [self.gridScrollView addSubview:_profile_bg1];
    
    _userFollowingLbl = [[UILabel alloc]initWithFrame:CGRectMake(26, 183, 85, 17)];
    _userFollowingLbl.textColor = [UIColor whiteColor];
    _userFollowingLbl.text = @"0 Following";
    _userFollowingLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
    _userFollowingLbl.textAlignment = NSTextAlignmentLeft;
    [self.gridScrollView addSubview:_userFollowingLbl];
    
    _userpicturesLbl = [[UILabel alloc]initWithFrame:CGRectMake(137, 183, 85, 17)];
    _userpicturesLbl.textColor = [UIColor whiteColor];
    _userpicturesLbl.text = @"0 Pictures";
    _userpicturesLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
    _userpicturesLbl.textAlignment = NSTextAlignmentLeft;
    [self.gridScrollView addSubview:_userpicturesLbl];
    
    _userFollowersLbl = [[UILabel alloc]initWithFrame:CGRectMake(245, 183, 85, 17)];
    _userFollowersLbl.textColor = [UIColor whiteColor];
    _userFollowersLbl.text = @"0 Followers";
    _userFollowersLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
    _userFollowersLbl.textAlignment = NSTextAlignmentLeft;
    [self.gridScrollView addSubview:_userFollowersLbl];
    
    [self getMyPosts];
    
    [self getFollowingUsers];
    [self getFollowerUsers];
    
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    logoutButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.isOpen) {
        //        NSLog(@"Found a cached session");
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 //                      NSLog(@"username = %@",user.name);
                 //                      NSLog(@"user email = %@",[user objectForKey:@"email"]);
                 _userName = user.username;
                 _userFullName = user.name;
                 [self.navigationItem setTitle:[_userFullName uppercaseString]];
                 _userPicUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", _userName];
                 _userEmail = [user objectForKey:@"email"];
                 NSLog(@"user pic url = %@",_userPicUrl);
                 [self getUserImage];
                 
                 _usernameLbl.text = _userFullName;
                 
             }
         }];
        
        // If there's no cached session, we will show a login button
    } else {
        //        NSLog(@"Cannot found a cached session");
        _userEmail = [[KCSUser activeUser] email];
        _userFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
        _usernameLbl.text = _userFullName;
        [self.navigationItem setTitle:[_userFullName uppercaseString]];
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
                    
                    dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
                    dispatch_async(q, ^{
                        /* Fetch the image from the server... */
                        NSURL *url = [NSURL URLWithString:_userPicUrl];
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            /* This is the main thread again, where we set the tableView's image to
                             be what we just fetched. */
                            
                            _userView.image = img;
                            //                        [self.userView.layer setCornerRadius:self.userView.frame.size.width/2];
                            //                        [self.userView setClipsToBounds:YES];
                            [self.gridScrollView addSubview:_userView];
                            //                            NSLog(@"profile image");
                            
                        });
                    });
                }
                
            }
        }];
        
    }
    
    _userFollowingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userFollowingBtn  setFrame:CGRectMake(9, 179, 95, 25)];
    [_userFollowingBtn setBackgroundColor:[UIColor clearColor]];
    [_userFollowingBtn addTarget:self action:@selector(userFollowing:) forControlEvents:UIControlEventTouchUpInside];
    [self.gridScrollView addSubview:_userFollowingBtn];
    
    _userFollowersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_userFollowersBtn  setFrame:CGRectMake(225, 179, 90, 25)];
    [_userFollowersBtn setBackgroundColor:[UIColor clearColor]];
    [_userFollowersBtn addTarget:self action:@selector(userFollowers:) forControlEvents:UIControlEventTouchUpInside];
    [self.gridScrollView addSubview:_userFollowersBtn];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _userEmail = [[KCSUser activeUser] email];
    [self getMyPosts];
    [self getFollowingUsers];
    [self getFollowerUsers];
}

- (UIImage*) blur:(UIImage*)theImage
{
    // create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
    
    // setting up Gaussian Blur (we could use one of many filters offered by Core Image)
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    // CIGaussianBlur has a tendency to shrink the image a little,
    // this ensures it matches up exactly to the bounds of our original image
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    return [UIImage imageWithCGImage:cgImage];
    
    // if you need scaling
    // return [[self class] scaleIfNeeded:cgImage];
}

- (void)userFollowing:(id)sender
{
    NSLog(@"Following Button pressed");
    UserFollowingViewController *media = [[UserFollowingViewController alloc]init];
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
//    self.navigationItem.backBarButtonItem = backBtn;
//    [self.navigationItem setBackBarButtonItem: backBtn];
    media.userFullName = _userFullName;
    media.followingUsers = _followingUsers;
    [self.navigationController pushViewController:media animated:YES];
}

- (void)userFollowers:(id)sender
{
    NSLog(@"Followers Button pressed");
    UserFollowersViewController *media = [[UserFollowersViewController alloc]init];
//    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
//    self.navigationItem.backBarButtonItem = backBtn;
//    [self.navigationItem setBackBarButtonItem: backBtn];
    media.userFullName = _userFullName;
    media.followers = _followerUsers;
    [self.navigationController pushViewController:media animated:YES];
}

- (void)backAction
{
    NSLog(@"BACK BUTTON");
}

- (void)getFollowingUsers
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:_userEmail];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            //            _unsubscribedHunts = _featuredHunts;
            //            [self modifyFeaturedHunts];
        } else {
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {
               
            } else {
                YookaBackend *yooka = objectsOrNil[0];

                _followingUsers = [NSMutableArray arrayWithArray:yooka.following_users];
                
                [_userFollowingLbl removeFromSuperview];
                
                _userFollowingLbl = [[UILabel alloc]initWithFrame:CGRectMake(26, 183, 85, 17)];
                _userFollowingLbl.textColor = [UIColor whiteColor];
                NSString *followingCount = [NSString stringWithFormat:@"%lu Following",(unsigned long)_followingUsers.count];
                _userFollowingLbl.text = followingCount;
                _userFollowingLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
                _userFollowingLbl.textAlignment = NSTextAlignmentLeft;
                [self.gridScrollView addSubview:_userFollowingLbl];
            }
            
        }
    } withProgressBlock:nil];
}

- (void)getFollowerUsers
{
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    KCSQuery *query = [KCSQuery queryOnField:@"_id" withExactMatchForValue:_userEmail];
    
    [store queryWithQuery:query withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //An error happened, just log for now
            //            NSLog(@"An error occurred on fetch: %@", errorOrNil);
            //            _unsubscribedHunts = _featuredHunts;
            //            [self modifyFeaturedHunts];
        } else {
            //got all events back from server -- update table view
            if (!objectsOrNil || !objectsOrNil.count) {

            } else {
                YookaBackend *yooka = objectsOrNil[0];
                
                _followerUsers = [NSMutableArray arrayWithArray:yooka.followers];
                
                [_userFollowersLbl removeFromSuperview];
                
                _userFollowersLbl = [[UILabel alloc]initWithFrame:CGRectMake(245, 183, 85, 17)];
                _userFollowersLbl.textColor = [UIColor whiteColor];
                NSString *followersCount = [NSString stringWithFormat:@"%lu Followers",(unsigned long)_followerUsers.count];
                _userFollowersLbl.text = followersCount;
                _userFollowersLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
                _userFollowersLbl.textAlignment = NSTextAlignmentLeft;
                [self.gridScrollView addSubview:_userFollowersLbl];
            }
            
        }
    } withProgressBlock:nil];
}

- (void)getUserImage
{
    [[[AsyncImageDownloader alloc] initWithMediaURL:_userPicUrl successBlock:^(UIImage *image)  {
        _userImage = image;
        _userView.image = image;
//        [self.userView.layer setCornerRadius:self.userView.frame.size.width/2];
//        [self.userView setClipsToBounds:YES];
        [self.gridScrollView addSubview:_userView];
        NSLog(@"get user image");
        [self saveUserImage];
    } failBlock:^(NSError *error) {
//        NSLog(@"Failed to download image due to %@!", error);
    }] startDownload];
}

- (void)saveUserImage
{
    
        NSLog(@"profile image");
        YookaBackend *yookaObject = [[YookaBackend alloc]init];
        yookaObject.kinveyId = _userEmail;
        if (_userImage) {
            yookaObject.userImage = _userImage;
        }else{
            yookaObject.userImage = [UIImage imageNamed:@"minion.jpg"];
        }
        yookaObject.userFullName = _userFullName;
        yookaObject.userEmail = _userEmail;
        
        //Kinvey use code: add a new update to the updates collection
        [self.updateStore saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                NSLog(@"saved successfully");
                YookaAppDelegate* appDelegate = (id)[UIApplication sharedApplication].delegate;
                [appDelegate userLoggedIn];
            } else {
                NSLog(@"save failed %@",errorOrNil);
            }
        } withProgressBlock:nil];
    
    
}

-(void)doAnimations
{
    CGAffineTransform scale = CGAffineTransformMakeScale(1.0f / 2, 1.0f / 2);
    CGAffineTransform rotate = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180.0f));
    self.user_image.transform = CGAffineTransformConcat(scale, rotate);
    
    [UIView beginAnimations:@"animate_user_profile" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:.4];
    [UIView setAnimationDelay:0];
    
    scale = CGAffineTransformMakeScale(1.0f, 1.0f);
    rotate = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0.0f));
    self.user_image.alpha = 1.0;
    self.user_image.transform = CGAffineTransformConcat(scale, rotate);
    
    [UIView commitAnimations];
    
    // --
    
    [UIView beginAnimations:@"animate_circle_one" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationDelay:0.4];
    
    self.circle_one.alpha = 0.10f;
    
    [UIView commitAnimations];
    
    // --
    
    [UIView beginAnimations:@"animate_circle_two" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationDelay:1.0];
    
    self.circle_two.alpha = 0.10f;
    
    [UIView commitAnimations];
}

- (void)logout:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Log out", nil];
    alert.tag = 0;
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==0) {
        
        if (buttonIndex == 0){
            //cancel clicked ...do your action
        }else{
            //log out clicked
            
            [[KCSUser activeUser] logout];
            
            NSUserDefaults * myNSUserDefaults = [NSUserDefaults standardUserDefaults];
            NSDictionary * dict = [myNSUserDefaults dictionaryRepresentation];
            for (id key in dict) {
                
                //heck the keys if u need
                [myNSUserDefaults removeObjectForKey:key];
            }
            [myNSUserDefaults synchronize];
            
            // Close the session and remove the access token from the cache
            // The session state handler (in the app delegate) will be called automatically
            [FBSession.activeSession closeAndClearTokenInformation];
            // If there's no cached session, we will show a login button
            YookaAppDelegate* appDelegate = (id)[UIApplication sharedApplication].delegate;
            [appDelegate userLoggedOut];
            
        }
        
    } else {
        
        if (buttonIndex == 0) {
            
        } else {
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMyPosts
{
    _collectionName1 = @"yookaPosts2";
    _customEndpoint1 = @"NewsFeed";
    _fieldName1 = @"postDate";
//    NSString *huntName = @"";
//    NSString *venueName = @"";
//    huntName,@"huntName",venueName,@"venueName"
    _dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
    
    [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict1 completionBlock:^(id results, NSError *error){
        if ([results isKindOfClass:[NSArray class]]) {
            _myPosts = [NSMutableArray arrayWithArray:results];
            if (_myPosts && _myPosts.count) {
//                NSLog(@"%@",_myPosts);

                [self fillPictures];
                
            }else{
//                NSLog(@"User Search Results = \n %@",results);

            }
            
        }
    }];
}

- (void)fillPictures
{
    item = 0;
    row = 0;
    col = 0;
    contentSize = 500;
    for (item=0;item<self.myPosts.count;item++) {
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(col*yookaThumbnailWidth,
                                                                      (row*yookaThumbnailHeight)+208,
                                                                      yookaThumbnailWidth,
                                                                      yookaThumbnailHeight)];
        if (_myPosts.count>2) {
            contentSize += (yookaThumbnailHeight/2);
        }
        button.tag = item;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        ++col;
        
        if (col >= yookaImagesPerRow) {
            row++;
            col = 0;
        }
        
        [self.gridScrollView addSubview:button];
        [self.thumbnails addObject:button];
    }
    
    [_gridScrollView setContentSize:CGSizeMake(320, contentSize)];
    
    [self loadImages];
}

- (void)loadImages
{
    if (i<_myPosts.count) {
//        NSLog(@"hahahah");
        NSString *picUrl = [[_myPosts[i] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
//        NSLog(@"hahahaha = %@",picUrl);

        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(q, ^{
            /* Fetch the image from the server... */
            NSURL *url = [NSURL URLWithString:picUrl];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                /* This is the main thread again, where we set the tableView's image to
                 be what we just fetched. */
                if (i==0) {
                    [self.profile_bg setImage:[self blur:img]];
                }
                UIButton* button = [self.thumbnails objectAtIndex:i];
                [button setBackgroundColor:[UIColor redColor]];
                UIImageView *buttonImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 160, 160)];
                buttonImage.image = img;
                [button addSubview:buttonImage];
                i++;
                [self loadImages];
                
            });
        });
        
    }
    if (_myPosts && _myPosts.count) {
        
        [self.userpicturesLbl removeFromSuperview];
        _userpicturesLbl = [[UILabel alloc]initWithFrame:CGRectMake(137, 183, 85, 17)];
        _userpicturesLbl.textColor = [UIColor whiteColor];
        NSString *picCount = [NSString stringWithFormat:@"%lu Pictures",(unsigned long)_myPosts.count];
        _userpicturesLbl.text = picCount;
        _userpicturesLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
        _userpicturesLbl.textAlignment = NSTextAlignmentLeft;
        [self.gridScrollView addSubview:_userpicturesLbl];

    }
}

- (void)buttonAction:(id)sender
{
    UIButton* button = sender;
    NSUInteger b = button.tag;
    NSLog(@"button %lu pressed",(unsigned long)b);
    
}

@end
