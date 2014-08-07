//
//  BDViewController+Private.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BDViewController+Private.h"
#import "YookaAppDelegate.h"
#import "YookaBackend.h"
#import "UIImageView+WebCache.h"

#define kNumberOfPhotos 25
@implementation BDViewController (Private)

-(void)buildBarButtons
{
//    UIBarButtonItem * reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"Lay it!"
//                                                                      style:UIBarButtonItemStylePlain
//                                                                     target:self 
//                                                                     action:@selector(animateReload)];
//
//    
//    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects: reloadButton, nil];

}

-(NSArray*)_imagesFromBundle
{   
    NSArray *images = [NSArray array];
//    NSBundle *bundle = [NSBundle mainBundle];
    for (int i=0; i< self.yookaImages.count; i++) {
//        NSString *path = [bundle pathForResource:[NSString stringWithFormat:@"%d", i + 1] ofType:@"jpg"];
        UIImage *image = self.yookaImages[i];
        if (image) {
            images = [images arrayByAddingObject:image];
        }
    }
    return images;
}


- (void)_demoAsyncDataLoading
{

    _items = [NSArray array];
//    NSArray *images = [self _imagesFromBundle];
    //load the placeholder image
    for (int i=0; i < self.myPosts.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
        imageView.frame = CGRectMake(0, 0, 44, 44);
        imageView.clipsToBounds = YES;
        _items = [_items arrayByAddingObject:imageView];
    }
    [self reloadData];

    j=0;
    
    self.myPicIds = [NSMutableArray new];
    self.myDishNames = [NSMutableArray new];
    self.myLikers = [NSMutableArray new];
    self.myLikes = [NSMutableArray new];
    [self loading2:_items];
        
//    [self stopActivityIndicator];
    
}

- (void)loading2:(NSArray *)items
{
    if (j < self.myPosts.count) {
        
        NSString *kinveyId = [self.myPosts[j] objectForKey:@"_id"];
        [self.myPicIds addObject:kinveyId];
        NSString *dishname = [self.myPosts[j] objectForKey:@"dishName"];
        [self.myDishNames addObject:dishname];
        
        NSString *picUrl = [[self.myPosts[j] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
        
        //        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        //        dispatch_async(q, ^{
        //            /* Fetch the image from the server... */
        //            NSURL *url = [NSURL URLWithString:picUrl];
        //            NSData *data = [NSData dataWithContentsOfURL:url];
        //            UIImage *img = [[UIImage alloc] initWithData:data];
        //            dispatch_async(dispatch_get_main_queue(), ^{
        
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
                 
                 if (j==0) {
                     [self.profile_bg setImage:[self blur:image]];
                 }
                 
                 NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                 [defaults setObject:UIImagePNGRepresentation(image) forKey:kinveyId];
                 [defaults synchronize];
                 
//                 [[SDImageCache sharedImageCache] storeImage:image forKey:kinveyId];
                 
                 UIImageView *imageView = [items objectAtIndex:j];
                 imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                 
                 UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 130, 40)];
                 dishLabel.text =[dishname uppercaseString];
                 dishLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:15.f];
                 dishLabel.textAlignment = NSTextAlignmentLeft;
                 dishLabel.textColor = [UIColor whiteColor];
                 dishLabel.adjustsFontSizeToFitWidth = YES;
                 dishLabel.numberOfLines = 0;
                 [dishLabel sizeToFit];
                 dishLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
                 dishLabel.layer.shadowRadius = 1;
                 dishLabel.layer.shadowOpacity = 1;
                 dishLabel.layer.shadowOffset = CGSizeMake(1.0, 3.0);
                 dishLabel.layer.masksToBounds = NO;
                 [imageView addSubview:dishLabel];
                 
                 KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
                 KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
                 
                 //        NSString *kinveyId = self.postIdData[j];
                 //        NSLog(@"likes = %@",self.likes);
                 //        NSLog(@"user email = %@",self.userEmail);
                 
                 [store loadObjectWithID:kinveyId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                     if (errorOrNil == nil) {
                         if (objectsOrNil && objectsOrNil.count) {
                             
                             YookaBackend *backendObject = objectsOrNil[0];
                             NSMutableArray *myArray = [NSMutableArray arrayWithArray:backendObject.likers];
                             //                    NSLog(@"likers = %@",myArray);
                             self.likes = backendObject.likes;
                             //                    NSLog(@"likers = %@",myArray);
                             if (self.likes && [self.likes integerValue]>0) {
                                 [self.myLikers addObject:myArray];
                                 [self.myLikes addObject:self.likes];
                             }else{
                                 [self.myLikers addObject:@""];
                                 [self.myLikes addObject:@"0"];
                             }
                             
                             if ([self.likes integerValue]>0) {
                                 
                                 NSString *myEmail = [[KCSUser activeUser] email];
                                 
                                 if([myArray containsObject:myEmail]){
                                     //NSLog(@"try 1");
                                     
                                     UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 26, 23)];
                                     likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
                                     [imageView addSubview:likesImageView];
                                     
                                     UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5, 8.5, 21, 7.5)];
                                     likesLabel.textColor = [UIColor whiteColor];
                                     [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:7.5]];
                                     likesLabel.text = [NSString stringWithFormat:@"%@",self.likes];
                                     likesLabel.textAlignment = NSTextAlignmentCenter;
                                     likesLabel.adjustsFontSizeToFitWidth = YES;
                                     [likesImageView addSubview:likesLabel];
                                     
                                     [imageView addSubview:likesImageView];
                                     
                                 }else{
                                     // NSLog(@"try 2");
                                     
                                     UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 26, 23)];
                                     likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                                     [imageView addSubview:likesImageView];
                                     
                                     UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5, 8.5, 21, 7.5)];
                                     likesLabel.textColor = [UIColor orangeColor];
                                     [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:7.5]];
                                     likesLabel.text = [NSString stringWithFormat:@"%@",self.likes];
                                     likesLabel.textAlignment = NSTextAlignmentCenter;
                                     likesLabel.adjustsFontSizeToFitWidth = YES;
                                     [likesImageView addSubview:likesLabel];
                                     
                                     [imageView addSubview:likesImageView];
                                     
                                 }
                                 
                             }else{
                                 
                                 //NSLog(@"try 3");
                                 
                                 self.likes = @"0";
                                 
                                 UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 26, 23)];
                                 likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                                 [imageView addSubview:likesImageView];
                                 
                                 UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5, 8.5, 21, 7.5)];
                                 likesLabel.textColor = [UIColor orangeColor];
                                 [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:7.5]];
                                 likesLabel.text = [NSString stringWithFormat:@"%@",self.likes];
                                 likesLabel.textAlignment = NSTextAlignmentCenter;
                                 likesLabel.adjustsFontSizeToFitWidth = YES;
                                 [likesImageView addSubview:likesLabel];
                                 
                                 [imageView addSubview:likesImageView];
                                 
                             }
                             
                             //                                                NSLog(@"successful reload: %@", backendObject.likers); // event updated
                             //                                                NSLog(@"successful reload: %@", backendObject.likes); // event updated
                             
                         }else{
                             
                             //                    NSLog(@"try 4");
                             [self.myLikers addObject:@""];
                             [self.myLikes addObject:@"0"];
                             
                             self.likes = @"0";
                             
                             UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 26, 23)];
                             likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                             [imageView addSubview:likesImageView];
                             
                             UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5, 8.5, 21, 7.5)];
                             likesLabel.textColor = [UIColor orangeColor];
                             [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:7.5]];
                             likesLabel.text = [NSString stringWithFormat:@"%@",self.likes];
                             likesLabel.textAlignment = NSTextAlignmentCenter;
                             likesLabel.adjustsFontSizeToFitWidth = YES;
                             [likesImageView addSubview:likesLabel];
                             
                             [imageView addSubview:likesImageView];
                             
                         }
                         
                         [self performSelector:@selector(animateUpdate:)
                                    withObject:[NSArray arrayWithObjects:imageView, image, nil]
                                    afterDelay:0.2 + (arc4random()%3) + (arc4random() %10 * 0.1)];
                         j++;
                         
                         [self loading2:items];
                         
                     } else {
                         
//                                            NSLog(@"error occurred: %@", errorOrNil);
                         
                         [self.myLikers addObject:@""];
                         [self.myLikes addObject:@"0"];
                         
                         self.likes = @"0";
                         
                         UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 26, 23)];
                         likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                         [imageView addSubview:likesImageView];
                         
                         UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5, 8.5, 21, 7.5)];
                         likesLabel.textColor = [UIColor orangeColor];
                         [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:7.5]];
                         likesLabel.text = [NSString stringWithFormat:@"%@",self.likes];
                         likesLabel.textAlignment = NSTextAlignmentCenter;
                         likesLabel.adjustsFontSizeToFitWidth = YES;
                         [likesImageView addSubview:likesLabel];
                         
                         [imageView addSubview:likesImageView];
                         
                         j++;
                         
                         [self performSelector:@selector(animateUpdate:)
                                    withObject:[NSArray arrayWithObjects:imageView, image, nil]
                                    afterDelay:0.2 + (arc4random()%3) + (arc4random() %10 * 0.1)];
                         [self loading2:items];
                         
                     }
                 } withProgressBlock:nil];
                 
             }
         }];
        
        //            });
        //        });
        
    }
    if (j==self.myPosts.count) {
        
//        NSLog(@"cacke ids = %@",self.myPicIds);
//        NSLog(@"cache dish name = %@",self.myDishNames);
//        NSLog(@"my likers = %@",self.myLikers);
//        NSLog(@"my likes = %@",self.myLikes);
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.myPicIds forKey:@"MyPicIds"];
        [defaults setObject:self.myDishNames forKey:@"MyDishNames"];
        [defaults setObject:self.myLikers forKey:@"MyLikers"];
        [defaults setObject:self.myLikes forKey:@"MyLikes"];
        [defaults synchronize];
        
        [self.userpicturesLbl removeFromSuperview];
        self.userpicturesLbl = [[UILabel alloc]initWithFrame:CGRectMake(137, 183, 85, 17)];
        self.userpicturesLbl.textColor = [UIColor whiteColor];
        NSString *picCount = [NSString stringWithFormat:@"%lu Pictures",(unsigned long)self.myPosts.count];
        self.userpicturesLbl.text = picCount;
        self.userpicturesLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
        self.userpicturesLbl.textAlignment = NSTextAlignmentLeft;
        [self.headerView addSubview:self.userpicturesLbl];
        
        [self stopActivityIndicator];
        [self showLogoutButton];
        
    }
}

- (void)_demoAsyncDataLoading2
{
//    NSLog(@"came here");
    _items = [NSArray array];
    //    NSArray *images = [self _imagesFromBundle];
    //load the placeholder image
    for (int i=0; i < self.cacheMyPicIds.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placeholder.png"]];
        imageView.frame = CGRectMake(0, 0, 44, 44);
        imageView.clipsToBounds = YES;
        _items = [_items arrayByAddingObject:imageView];
    }
    [self reloadData];
    
    j=0;
    
    [self loading3:_items];
    
    //    [self stopActivityIndicator];
    
}

- (void)loading3:(NSArray *)items
{
//    NSLog(@"reached here j=%d hunt number = %lu",j,(unsigned long)self.cacheMyPicIds.count);

    if (j<self.cacheMyPicIds.count) {
        
//        NSString *picId = self.cacheMyPicIds[j];
//        NSLog(@"pic id = %@",picId);
        
//        [[SDImageCache sharedImageCache] queryDiskCacheForKey:picId done:^(UIImage *image, SDImageCacheType cacheType)
//         {
//             // image is not nil if image was found
//             if (image) {
//             }else{
//                 
//             }
//         }];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSData* imageData = [ud objectForKey:self.cacheMyPicIds[j]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        if (image) {
//            NSLog(@"yes image");
        }else{
//            NSLog(@"no image");
        }
        
        UIImageView *imageView = [items objectAtIndex:j];
        imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        
        UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 130, 40)];
        dishLabel.text =[self.cacheMyDishNames[j] uppercaseString];
        dishLabel.font = [UIFont fontWithName:@"Montserrat-Bold" size:15.f];
        dishLabel.textAlignment = NSTextAlignmentLeft;
        dishLabel.textColor = [UIColor whiteColor];
        dishLabel.adjustsFontSizeToFitWidth = YES;
        dishLabel.numberOfLines = 0;
        [dishLabel sizeToFit];
        dishLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        dishLabel.layer.shadowRadius = 1;
        dishLabel.layer.shadowOpacity = 1;
        dishLabel.layer.shadowOffset = CGSizeMake(1.0, 3.0);
        dishLabel.layer.masksToBounds = NO;
        [imageView addSubview:dishLabel];
        
        NSMutableArray *myArray = self.cacheMyLikers[j];
//        NSLog(@"likers array = %@",myArray);
        self.likes = self.cacheMyLikes[j];
        
        NSString *myEmail = [[KCSUser activeUser] email];
        
        if([self.likes integerValue]>0 && [myArray containsObject:myEmail]){
            
//            NSLog(@"try 1");
            
            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 26, 23)];
            likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
            [imageView addSubview:likesImageView];
            
            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5, 8.5, 21, 7.5)];
            likesLabel.textColor = [UIColor whiteColor];
            [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:7.5]];
            likesLabel.text = [NSString stringWithFormat:@"%@",self.likes];
            likesLabel.textAlignment = NSTextAlignmentCenter;
            likesLabel.adjustsFontSizeToFitWidth = YES;
            [likesImageView addSubview:likesLabel];
            
            [imageView addSubview:likesImageView];
            
        }else{
            
//            NSLog(@"try 2");
            
            UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 26, 23)];
            likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
            [imageView addSubview:likesImageView];
            
            UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5, 8.5, 21, 7.5)];
            likesLabel.textColor = [UIColor orangeColor];
            [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:7.5]];
            likesLabel.text = [NSString stringWithFormat:@"%@",self.likes];
            likesLabel.textAlignment = NSTextAlignmentCenter;
            likesLabel.adjustsFontSizeToFitWidth = YES;
            [likesImageView addSubview:likesLabel];
            
            [imageView addSubview:likesImageView];
            
        }
        
        [self performSelector:@selector(animateUpdate:)
                   withObject:[NSArray arrayWithObjects:imageView, image, nil]
                   afterDelay:0.2 + (arc4random()%3) + (arc4random() %10 * 0.1)];
        j++;
        
        [self loading3:items];
        
    }
    
    if (j==self.cacheMyPicIds.count) {
        
        [self.userpicturesLbl removeFromSuperview];
        self.userpicturesLbl = [[UILabel alloc]initWithFrame:CGRectMake(137, 183, 85, 17)];
        self.userpicturesLbl.textColor = [UIColor whiteColor];
        NSString *picCount = [NSString stringWithFormat:@"%lu Pictures",(unsigned long)self.cacheMyPicIds.count];
        self.userpicturesLbl.text = picCount;
        self.userpicturesLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
        self.userpicturesLbl.textAlignment = NSTextAlignmentLeft;
        [self.headerView addSubview:self.userpicturesLbl];
        
        [self stopActivityIndicator];

    }
}


- (void)loadCachedImages
{
    
}

- (void) animateUpdate:(NSArray*)objects
{
    UIImageView *imageView = [objects objectAtIndex:0];
    UIImage* image = [objects objectAtIndex:1];
    [UIView animateWithDuration:1.0
                     animations:^{
                         imageView.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         imageView.image = image;
                         
                         [UIView animateWithDuration:1.0
                                          animations:^{
                                              imageView.alpha = 1;
                                          } completion:^(BOOL finished) {
                                              NSArray *visibleRowInfos =  [self visibleRowInfos];
                                              for (BDRowInfo *rowInfo in visibleRowInfos) {
                                                  [self updateLayoutWithRow:rowInfo animiated:YES];
                                              }
                                          }];
                     }];
}

- (void)showReloadButton {
    
    UIBarButtonItem * reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(animateReload)];
    reloadButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = reloadButton;
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    logoutButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
}

- (void)showLogoutButton
{
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logout:)];
    logoutButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = logoutButton;
}

- (void)showActivityIndicator {
    self.navigationItem.leftBarButtonItem = nil;
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 9, 27, 27)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.leftBarButtonItem = activityItem;
}

- (void)stopActivityIndicator {
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 9, 27, 27)];
    [activityIndicator stopAnimating];
    self.navigationItem.leftBarButtonItem = nil;
    [self showReloadButton];
}

- (void)stopActivityIndicator2 {
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 9, 27, 27)];
    [activityIndicator stopAnimating];
    self.navigationItem.leftBarButtonItem = nil;
    UIBarButtonItem * reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(animateReload)];
    reloadButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = reloadButton;
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
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ThisUserHasLaunchedOnce"];
            [[NSUserDefaults standardUserDefaults] synchronize];


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


@end
