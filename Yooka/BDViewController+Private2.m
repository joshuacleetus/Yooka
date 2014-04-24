//
//  BDViewController+Private.m
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BDViewController+Private2.h"
#import "YookaBackend.h"
#import "UIImageView+WebCache.h"

#define kNumberOfPhotos 25

@implementation BDViewController2 (Private)

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
    [self loading2:_items];
    
    [self stopActivityIndicator];
    
}

- (void)loading2:(NSArray *)items
{
    if (j < self.myPosts.count) {
        
        NSString *kinveyId = [self.myPosts[j] objectForKey:@"_id"];
        NSString *dishname = [self.myPosts[j] objectForKey:@"dishName"];
        
        NSString *picUrl = [[self.myPosts[j] objectForKey:@"dishImage"] objectForKey:@"_downloadURL"];
        //        NSLog(@"hahahaha = %@",picUrl);
        
//        dispatch_queue_t q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
//        dispatch_async(q, ^{
//            /* Fetch the image from the server... */
//            NSURL *url = [NSURL URLWithString:picUrl];
//            NSData *data = [NSData dataWithContentsOfURL:url];
//            UIImage *img = [[UIImage alloc] initWithData:data];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                /* This is the main thread again, where we set the tableView's image to
//                 be what we just fetched. */
        
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
                 
                 UIImageView *imageView = [items objectAtIndex:j];
//                 UIImage *image = image;
                 imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                 
                 UILabel *dishLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 130, 40)];
                 dishLabel.text = [dishname uppercaseString];
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
                 
                 //        NSLog(@"likes = %@",self.likes);
                 //        NSLog(@"user email = %@",self.userEmail);
                 
                 [store loadObjectWithID:kinveyId withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
                     if (errorOrNil == nil) {
                         if (objectsOrNil && objectsOrNil.count) {
                             
                             YookaBackend *backendObject = objectsOrNil[0];
                             NSMutableArray *myArray = [NSMutableArray arrayWithArray:backendObject.likers];
                             //                    NSLog(@"likers = %@",myArray);
                             self.likes = backendObject.likes;
                             
                             if ([self.likes integerValue]>0) {
                                 
                                 NSString *myEmail = [[KCSUser activeUser] email];
                                 
                                 if([myArray containsObject:myEmail]){
                                     //                            NSLog(@"try 1");
                                     
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
                                     //                            NSLog(@"try 2");
                                     
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
                                 
                                 //                        NSLog(@"try 3");
                                 
                                 
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
        
        [self.userpicturesLbl removeFromSuperview];
        self.userpicturesLbl = [[UILabel alloc]initWithFrame:CGRectMake(137, 183, 85, 17)];
        self.userpicturesLbl.textColor = [UIColor whiteColor];
        NSString *picCount = [NSString stringWithFormat:@"%lu Pictures",(unsigned long)self.myPosts.count];
        self.userpicturesLbl.text = picCount;
        self.userpicturesLbl.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11.0];
        self.userpicturesLbl.textAlignment = NSTextAlignmentLeft;
        [self.headerView addSubview:self.userpicturesLbl];
        
        [self stopActivityIndicator];
        
    }
}

- (void) animateUpdate:(NSArray*)objects
{
    UIImageView *imageView = [objects objectAtIndex:0];
    UIImage* image = [objects objectAtIndex:1];
    [UIView animateWithDuration:0.5
                     animations:^{
                         imageView.alpha = 0.f;
                     } completion:^(BOOL finished) {
                         imageView.image = image;
                         
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              imageView.alpha = 1;
                                          } completion:^(BOOL finished) {
                                              NSArray *visibleRowInfos =  [self visibleRowInfos];
                                              for (BDRowInfo2 *rowInfo in visibleRowInfos) {
                                                  [self updateLayoutWithRow:rowInfo animiated:YES];
                                              }
                                          }];
                     }];
}

- (void)showReloadButton {
    
    UIBarButtonItem * reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(animateReload)];
    reloadButton.tintColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = reloadButton;
    
}

- (void)showActivityIndicator {
    
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(315, 9, 27, 27)];
    [activityIndicator startAnimating];
    UIBarButtonItem *activityItem =
    [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    self.navigationItem.rightBarButtonItem = activityItem;
}

- (void)stopActivityIndicator {
    UIActivityIndicatorView *activityIndicator =
    [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(315, 9, 27, 27)];
    [activityIndicator stopAnimating];
    self.navigationItem.rightBarButtonItem = nil;
    [self showReloadButton];
}


@end