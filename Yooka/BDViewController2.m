//
//  BDViewController.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BDViewController2.h"
#import "BDViewController+Private2.h"
#import "BDRowInfo2.h"
#import "YookaBackend.h"
#import <Reachability.h>

@interface BDViewController2 (){
}

@end

@implementation BDViewController2
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    self.navigationController.navigationBar.backgroundColor = color;
    [self.navigationController.navigationBar setBarTintColor:color];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
    
    [self showActivityIndicator];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    } else {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    }
    
    
    self.delegate = self;
    
    self.onLongPress = ^(UIView* view, NSInteger viewIndex){
//        NSLog(@"Long press on %@, at %ld", view, (long)viewIndex);
    };
    
    __weak BDViewController2 *self_ = self; // that's enough

    self.onDoubleTap = ^(UIView* view, NSInteger viewIndex){
//        NSLog(@"Double tap on %@, at %ld", view, (long)viewIndex);
//        NSLog(@"my email = %@",self_.myEmail);
        [self_.view setUserInteractionEnabled:NO];
        self_.postLikers = [NSMutableArray new];
        
        //        UIButton* button = [self.thumbnails objectAtIndex:view.tag];
        
        self_.postId = [self_.myPosts[(long)viewIndex] objectForKey:@"_id"];
        //    NSLog(@"post id = %@",_postId);
        //        _postHuntName = [_newsFeed[view.tag] objectForKey:@"HuntName"];
        //    NSLog(@"hunt name = %@",_postHuntName);
        //        _postCaption = [_newsFeed[view.tag] objectForKey:@"caption"];
        //    NSLog(@"caption = %@",_postCaption);
        //        _postDishImageUrl = [[_newsFeed[view.tag] objectForKey:@"dishImage"]objectForKey:@"_downloadURL"];
        //    NSLog(@"dish image url = %@",_postDishImageUrl);
        //        _postDishName = [_newsFeed[view.tag] objectForKey:@"dishName"];
        //    NSLog(@"dish name = %@",_postDishName);
        
        KCSCollection *yookaObjects = [KCSCollection collectionFromString:@"LikesDB" ofClass:[YookaBackend class]];
        KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:yookaObjects options:nil];
        
        [store loadObjectWithID:self_.postId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
            if (errorOrNil == nil) {
                if (objectsOrNil && objectsOrNil.count) {
                    
                    YookaBackend *backendObject = objectsOrNil[0];
                    self_.postLikers = [NSMutableArray arrayWithArray:backendObject.likers];
                    self_.postLikes = backendObject.likes;
                    
                    if ([self_.postLikes intValue]==0) {
                        self_.likeStatus = @"NO";
                    }
//                    NSLog(@"likes = %@",self_.postLikes);
                    
                    if (!(self_.postLikers == (id)[NSNull null])) {
                        if ([self_.postLikers containsObject:self_.myEmail]) {
                            self_.likeStatus = @"YES";
                        }else{
                            self_.likeStatus = @"NO";
                        }
                    }else{
                        self_.likeStatus = @"NO";
                        //        NSLog(@"try try try");
                    }
                    
//                    NSLog(@"like status = %@",self_.likeStatus);
                    
                    
                    if ([self_.likeStatus isEqualToString:@"YES"]) {
                        
                        int post_likes = [self_.postLikes intValue];
                        post_likes = post_likes-1;
                        self_.postLikes = [NSString stringWithFormat:@"%d",post_likes];
                        
                        if (self_.postLikers==(id)[NSNull null]) {
                            //                        [_likersData replaceObjectAtIndex:view.tag withObject:[NSNull null]];
                        }else{
                            [self_.postLikers removeObject:self_.myEmail];
                        }
                        
                        //        NSLog(@"likes data 2 = %@",_likesData);
                        //        NSLog(@"likers data 2 = %@",_likersData);
                        
                        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 26, 23)];
                        likesImageView.image = [UIImage imageNamed:@"heartempty.png"];
                        [view addSubview:likesImageView];
                        
                        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5, 8.5, 21, 7.5)];
                        likesLabel.textColor = [UIColor orangeColor];
                        [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:7.5]];
                        likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                        likesLabel.textAlignment = NSTextAlignmentCenter;
                        likesLabel.adjustsFontSizeToFitWidth = YES;
                        [likesImageView addSubview:likesLabel];
                        
                        //                [self saveSelectedPost];
                        [self_ saveLikes];
                        self_.likeStatus = @"NO";
                        
                    }else{
                        
                        if (self_.postLikers == (id)[NSNull null]) {
                            //            NSLog(@"post likers 2 = %@",_postLikers);
                            
                            self_.postLikers = [NSMutableArray arrayWithObject:self_.myEmail];
                            //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                            
                        }else{
                            //            NSLog(@"post likers 3 = %@",_postLikers);
                            [self_.postLikers addObject:self_.myEmail];
                            //                        [_likersData replaceObjectAtIndex:view.tag withObject:_postLikers];
                            
                        }
                        
                        int post_likes = [self_.postLikes intValue];
                        post_likes=post_likes+1;
                        self_.postLikes = [NSString stringWithFormat:@"%d",post_likes];
                        //                    [_likesData replaceObjectAtIndex:view.tag withObject:_postLikes];
                        
                        //        NSLog(@"likes data 2 = %@",_likesData);
                        //        NSLog(@"likers data 2 = %@",_likersData);
                        
                        UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 26, 23)];
                        likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
                        [view addSubview:likesImageView];
                        
                        UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5, 8.5, 21, 7.5)];
                        likesLabel.textColor = [UIColor whiteColor];
                        [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:7.5]];
                        likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                        likesLabel.textAlignment = NSTextAlignmentCenter;
                        likesLabel.adjustsFontSizeToFitWidth = YES;
                        [likesImageView addSubview:likesLabel];
                        
                        //                [self saveSelectedPost];
                        [self_ saveLikes];
                        self_.likeStatus = @"YES";
                        
                    }
                    
                    
                }else{
                    
                    self_.postLikes = @"0";
                    
                    self_.likeStatus = @"NO";
//                    NSLog(@"likes = %@",self_.postLikes);
                    
                    self_.postLikers = [NSMutableArray arrayWithObject:self_.myEmail];
                    
                    
                    int post_likes = [self_.postLikes intValue];
                    post_likes=post_likes+1;
                    self_.postLikes = [NSString stringWithFormat:@"%d",post_likes];
                    
                    //        NSLog(@"likes data 2 = %@",_likesData);
                    //        NSLog(@"likers data 2 = %@",_likersData);
                    
                    UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 26, 23)];
                    likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
                    [view addSubview:likesImageView];
                    
                    UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5, 8.5, 21, 7.5)];
                    likesLabel.textColor = [UIColor whiteColor];
                    [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:7.5]];
                    likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                    likesLabel.textAlignment = NSTextAlignmentCenter;
                    likesLabel.adjustsFontSizeToFitWidth = YES;
                    [likesImageView addSubview:likesLabel];
                    
                    //                [self saveSelectedPost];
                    [self_ saveLikes];
                    self_.likeStatus = @"YES";
                    
                }
                
            }else{
                
                self_.postLikes = @"0";
                
                self_.likeStatus = @"NO";
//                NSLog(@"likes = %@",self_.postLikes);
                
                self_.postLikers = [NSMutableArray arrayWithObject:self_.myEmail];
                
                int post_likes = [self_.postLikes intValue];
                post_likes=post_likes+1;
                self_.postLikes = [NSString stringWithFormat:@"%d",post_likes];
                
                //        NSLog(@"likes data 2 = %@",_likesData);
                //        NSLog(@"likers data 2 = %@",_likersData);
                
                UIImageView *likesImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 115, 26, 23)];
                likesImageView.image = [UIImage imageNamed:@"heartfilled.png"];
                [view addSubview:likesImageView];
                
                UILabel *likesLabel = [[UILabel alloc]initWithFrame:CGRectMake(2.5, 8.5, 21, 7.5)];
                likesLabel.textColor = [UIColor whiteColor];
                [likesLabel setFont:[UIFont fontWithName:@"Montserrat-Regular" size:7.5]];
                likesLabel.text = [NSString stringWithFormat:@"%d",post_likes];
                likesLabel.textAlignment = NSTextAlignmentCenter;
                likesLabel.adjustsFontSizeToFitWidth = YES;
                [likesImageView addSubview:likesLabel];
                
                //                [self saveSelectedPost];
                [self_ saveLikes];
                self_.likeStatus = @"YES";
                
            }
            
        } withProgressBlock:nil];
        
        
    };
    [self animateReload];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No internet connection."
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
        
        [alert show];
    }
    //    [self buildBarButtons];
}

- (void)saveLikes
{
    YookaBackend *yookaObject = [[YookaBackend alloc]init];
    yookaObject.kinveyId = self.postId;
    yookaObject.likes = self.postLikes;
    yookaObject.likers = self.postLikers;
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
            [self.view setUserInteractionEnabled:YES];
        } else {
            //save was successful
            if (objectsOrNil && objectsOrNil.count) {
                //NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
                [self.view setUserInteractionEnabled:YES];
                
            }
        }
    } withProgressBlock:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    [self animateReload];
    
    UIColor * color = [UIColor colorWithRed:145/255.0f green:208/255.0f blue:194/255.0f alpha:1.0f];
    [self.view setBackgroundColor:color];
}



- (void)animateReload
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    [networkReachability startNotifier];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if ((networkStatus == ReachableViaWiFi) || (networkStatus == ReachableViaWWAN)) {
        
    [self showActivityIndicator];
    [self getFollowingUsers];
    [self getFollowerUsers];
    _items = [NSArray new];
    self.myPosts = [NSMutableArray new];
    self.yookaImages = [NSMutableArray new];
    self.likesData = [NSMutableArray new];
    self.likersData = [NSMutableArray new];
    self.dishData = [NSMutableArray new];
    self.postIdData = [NSMutableArray new];
    k=0;
    self.collectionName1 = @"yookaPosts2";
    self.customEndpoint1 = @"NewsFeed";
    self.fieldName1 = @"postDate";
    //    NSString *huntName = @"";
    //    NSString *venueName = @"";
    //    huntName,@"huntName",venueName,@"venueName"
    self.dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:self.userEmail,@"userEmail",self.collectionName1,@"collectionName",self.fieldName1,@"fieldName", nil];
    
    [KCSCustomEndpoints callEndpoint:self.customEndpoint1 params:self.dict1 completionBlock:^(id results, NSError *error){
        if ([results isKindOfClass:[NSArray class]]) {
            self.myPosts = [NSMutableArray arrayWithArray:results];
            
            
            if (self.myPosts && self.myPosts.count) {
                //                    NSLog(@"%@",self.myPosts);
                
                [self _demoAsyncDataLoading];
                

                
            }else{
                //                NSLog(@"User Search Results = \n %@",results);
                [self stopActivityIndicator];
            }
            
        }else{
            [self stopActivityIndicator];
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

- (void)loadImages
{
    if (k<self.myPosts.count) {
        //        NSLog(@"newsfeed = %@",self.myPosts[k]);
        NSString *kinveyId = [self.myPosts[k] objectForKey:@"_id"];
        NSString *dishname = [self.myPosts[k] objectForKey:@"dishName"];
        [self.dishData addObject:dishname];
        [self.postIdData addObject:kinveyId];
        
        NSString *picUrl = [[self.myPosts[k] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
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
                if (k==0) {
                    [self.profile_bg setImage:[self blur:img]];
                }
                [self.yookaImages addObject:img];
                k++;
                [self loadImages];
                
            });
        });
        
    }
    if (k==self.myPosts.count) {
        
        [self.userpicturesLbl removeFromSuperview];
        self.userpicturesLbl = [[UILabel alloc]initWithFrame:CGRectMake(137, 183, 85, 17)];
        self.userpicturesLbl.textColor = [UIColor whiteColor];
        NSString *picCount = [NSString stringWithFormat:@"%lu Pictures",(unsigned long)self.myPosts.count];
        self.userpicturesLbl.text = picCount;
        self.userpicturesLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
        self.userpicturesLbl.textAlignment = NSTextAlignmentLeft;
        [self.headerView addSubview:self.userpicturesLbl];
        
        [self _demoAsyncDataLoading];
        
    }
}

- (NSUInteger)numberOfViews
{
    return _items.count;
}

-(NSUInteger)maximumViewsPerCell
{
    return 2;
}

- (UIView *)viewAtIndex:(NSUInteger)index rowInfo:(BDRowInfo2 *)rowInfo
{
    UIImageView * imageView = [_items objectAtIndex:index];
    return imageView;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //Call super when overriding this method, in order to benefit from auto layout.
    [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    return YES;
}

- (CGFloat)rowHeightForRowInfo:(BDRowInfo2 *)rowInfo
{
//    if (rowInfo.viewsPerCell == 1) {
//        return 125  + (arc4random() % 55);
//    }else {
//        return 100;
//    }
    return 150;
}

@end
