//
//  SelectedUserViewController.m
//  Yooka
//
//  Created by Joshua Cleetus on 3/4/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "SelectedUserViewController.h"
#import "UserFollowingViewController.h"
#import "UserFollowersViewController.h"
#import "YookaBackend.h"
#import <Reachability.h>

const NSInteger yookaThumbnailWidth2 = 160;
const NSInteger yookaThumbnailHeight2 = 160;
const NSInteger yookaImagesPerRow2 = 2;
const NSInteger yookaThumbnailSpace2 = 0;

@interface SelectedUserViewController ()

@end

@implementation SelectedUserViewController

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
    
    [_gridScrollView removeFromSuperview];
    
    i=0;
    j=0;
    skip = 20;
    
    _following_users = [NSMutableArray new];
    _following_users2 = [NSMutableArray new];
    _followers = [NSMutableArray new];
    _followers2 = [NSMutableArray new];
    _myPosts = [NSMutableArray new];
    _thumbnails = [NSMutableArray new];
    _followerUsers = [NSMutableArray new];
    _followingUsers = [NSMutableArray new];
    
    _myEmail = [[KCSUser activeUser] email];
    
    _myFullName = [NSString stringWithFormat:@"%@ %@",[KCSUser activeUser].givenName,[KCSUser activeUser].surname];
    
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
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationItem setTitle:_userFullName];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    _userView = [[UIImageView alloc]initWithFrame:CGRectMake(115, 29, 90, 90)];
    self.userView.layer.cornerRadius = self.userView.frame.size.height / 2;
    [self.userView.layer setBorderWidth:4.0];
    [self.userView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.userView setContentMode:UIViewContentModeCenter];
    [self.userView setClipsToBounds:YES];
    [self.gridScrollView addSubview:_userView];
    
    _profile_bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 208)];
    [self.profile_bg setImage:[self blur:[UIImage imageNamed:@"profile_bg@2x.png"]]];
    [self.gridScrollView addSubview:_profile_bg];
    
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
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    [self getUser_Pic];
    
    [self getMyPosts];
    
    [self getFollowerUsers];
    [self getFollowingUsers];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getUser_Pic
{
//    _collectionName1 = @"userPicture";
//    _customEndpoint1 = @"NewsFeed";
//    _dict = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
//    
//    [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict completionBlock:^(id results, NSError *error){
//        if (results) {
//            
//            NSLog(@"User Search Results = \n %@",[[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"]);
//            _userPicUrl = [[results[0] objectForKey:@"userImage"]objectForKey:@"_downloadURL"];
    
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
                    [self.userView.layer setCornerRadius:self.userView.frame.size.width/2];
                    [self.userView setClipsToBounds:YES];
                    [self.gridScrollView addSubview:_userView];
                    NSLog(@"profile image");
                    [self checkforUserFollowing];

                });
            });

//        }
//    }];
}

- (void)checkforUserFollowing
{
    if ([_userEmail isEqualToString:_myEmail]) {
        //do nothing
    }else{
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        [store loadObjectWithID:_myEmail withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                if (objectsOrNil && objectsOrNil.count) {
                    YookaBackend *backendObject = objectsOrNil[0];
                    _following_users = [NSMutableArray arrayWithArray:backendObject.following_users];

                    [self checkUserInMyArray];
                    NSLog(@"successful reload: %@", backendObject.following_users); // event updated
                }

            } else {
                NSLog(@"error occurred: %@", errorOrNil);
                [self showFollowBtn];
            }
        } withProgressBlock:nil];
    }

}

- (void) checkforUserFollowers
{
    if ([_userEmail isEqualToString:_myEmail]) {
        //do nothing
    }else{
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        [store loadObjectWithID:_userEmail withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                if (objectsOrNil && objectsOrNil.count) {
                    YookaBackend *backendObject = objectsOrNil[0];
                    _followers = [NSMutableArray arrayWithArray:backendObject.followers];
                    
                    NSLog(@"successful reload: %@", backendObject.followers); // event updated
                }
                
            } else {
                NSLog(@"error occurred: %@", errorOrNil);
                [self showFollowBtn];
            }
        } withProgressBlock:nil];
    }
}

- (void)checkUserInMyArray
{
    if ([_following_users containsObject:_userEmail]) {
        [self showUnfollowBtn];
    }else{
        [self showFollowBtn];
    }
}

- (void)showFollowBtn
{
    [self.unFollowBtn setHidden:YES];
    
    self.followBtn = [[FUIButton alloc]initWithFrame:CGRectMake(104, 109, 110, 24)];
    UIColor * color4 = [UIColor colorWithRed:245/255.0f green:135/255.0f blue:77/255.0f alpha:1.0f];
    self.followBtn.buttonColor = color4;
    UIColor * color5 = [UIColor colorWithRed:221/255.0f green:117/255.0f blue:62/255.0f alpha:1.0f];
    self.followBtn.shadowColor = color5;
    self.followBtn.shadowHeight = 3.0f;
    self.followBtn.cornerRadius = 6.0f;
    self.followBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
    [self.followBtn setTitle:@"Follow" forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.followBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.followBtn addTarget:self action:@selector(followBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.gridScrollView addSubview:self.followBtn];
}

- (void)followBtnTouched:(id)sender
{
    [self.followBtn setHidden:YES];
    
    [_following_users addObject:_userEmail];
    
    [self savefollowingUsers];
    [self showUnfollowBtn];
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store loadObjectWithID:_userEmail withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            if (objectsOrNil && objectsOrNil.count) {
                YookaBackend *backendObject = objectsOrNil[0];
                _followers = [NSMutableArray arrayWithArray:backendObject.followers];
                if ([_followers containsObject:_myEmail]) {
                    
                }else{
                    [_followers addObject:_myEmail];
                }
                [self saveFollowers];
                
                NSLog(@"successful reload: %@", backendObject.followers); // event updated
            }else{
                [_followers addObject:_myEmail];
                [self saveFollowers];
            }

        } else {
            NSLog(@"error occurred: %@", errorOrNil);
            [_followers addObject:_myEmail];
            [self saveFollowers];
            
        }
    } withProgressBlock:nil];
    
}

- (void)savefollowingUsers
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _myEmail;
    yookaObject.userFullName = _myFullName;
    yookaObject.following_users = _following_users;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);

        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            }
        }
    } withProgressBlock:nil];
}

- (void)savefollowingUsers2
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _myEmail;
    yookaObject.userFullName = _myFullName;
    yookaObject.following_users = _following_users2;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Following" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
            
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            }
        }
    } withProgressBlock:nil];
}

- (void)saveFollowers
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _userEmail;
    yookaObject.userFullName = _userFullName;
    yookaObject.followers = _followers;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
            
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            }
        }
    } withProgressBlock:nil];
    _userFollowersLbl.text = [NSString stringWithFormat:@"%lu Followers",(unsigned long)_following_users.count];
}

- (void)saveFollowers2
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = _userEmail;
    yookaObject.userFullName = _userFullName;
    yookaObject.followers = _followers2;
    
    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    [store saveObject:yookaObject withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            NSLog(@"Not saved event (error= %@).",errorOrNil);
            
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
            }
        }
    } withProgressBlock:nil];
    _userFollowersLbl.text = [NSString stringWithFormat:@"%lu Followers",(unsigned long)_following_users.count];
}

- (void)showUnfollowBtn
{
    self.unFollowBtn = [[FUIButton alloc]initWithFrame:CGRectMake(104, 109, 110, 24)];
    UIColor * color4 = [UIColor colorWithRed:67/255.0f green:125/255.0f blue:162/255.0f alpha:1.0f];
    self.unFollowBtn.buttonColor = color4;
    UIColor * color5 = [UIColor colorWithRed:45/255.0f green:93/255.0f blue:124/255.0f alpha:1.0f];
    self.unFollowBtn.shadowColor = color5;
    self.unFollowBtn.shadowHeight = 3.0f;
    self.unFollowBtn.cornerRadius = 6.0f;
    self.unFollowBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
    [self.unFollowBtn setTitle:@"Unfollow" forState:UIControlStateNormal];
    [self.unFollowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.unFollowBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.unFollowBtn addTarget:self action:@selector(unFollowBtnTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.gridScrollView addSubview:self.unFollowBtn];
}

- (void)unFollowBtnTouched:(id)sender
{
    [self.unFollowBtn setHidden:YES];
    [self showFollowBtn];
    [self unFollowUser];
    [self removeFollower2];
}

- (void)unFollowUser
{
    if ([_following_users containsObject:_userEmail]) {
        [_following_users removeObject:_userEmail];
        [self savefollowingUsers];
    }
}

- (void)removeFollower2
{

    KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"Followers" ofClass:[YookaBackend class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
    
    [store loadObjectWithID:_userEmail withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil == nil) {
            if (objectsOrNil && objectsOrNil.count) {
                [_followers removeAllObjects];
                YookaBackend *backendObject = objectsOrNil[0];
                _followers2 = [NSMutableArray arrayWithArray:backendObject.followers];
                [_followers2 removeObject:_myEmail];
                [self saveFollowers2];
                NSLog(@"successful reload: %@", backendObject.followers); // event updated
            }
            
        } else {
            NSLog(@"error occurred: %@", errorOrNil);
            [self showFollowBtn];
        }
    } withProgressBlock:nil];
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

- (void)getMyPosts
{
    _collectionName1 = @"yookaPosts2";
    _customEndpoint1 = @"NewsFeed";
    _fieldName1 = @"postDate";
    //    NSString *huntName = @"";
    //    NSString *venueName = @"";
    //    huntName,@"huntName",venueName,@"venueName"
    _dict = [[NSDictionary alloc]initWithObjectsAndKeys:_userEmail,@"userEmail",_collectionName1,@"collectionName",_fieldName1,@"fieldName", nil];
    
    [KCSCustomEndpoints callEndpoint:_customEndpoint1 params:_dict completionBlock:^(id results, NSError *error){
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
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(col*yookaThumbnailWidth2,
                                                                      (row*yookaThumbnailHeight2)+208,
                                                                      yookaThumbnailWidth2,
                                                                      yookaThumbnailHeight2)];
        if (_myPosts.count>2) {
            contentSize += (yookaThumbnailHeight2/2);
        }
        button.tag = item;
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        ++col;
        
        if (col >= yookaImagesPerRow2) {
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
