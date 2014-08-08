//
//  YookaFeaturedHuntViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 6/4/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MPFlipEnumerations.h"
#import <KinveyKit/KinveyKit.h>

@class FlipView;
@class AnimationDelegate;

enum {
	MPTransitionModeFold,
	MPTransitionModeFlip
} typedef MPTransitionMode;

@interface YookaFeaturedHuntViewController : UIViewController<UIScrollViewDelegate,UIDynamicAnimatorDelegate>{
    
    int i;
    long total_hunts;
    CGRect new_page_frame;
    
    //the controller needs a reference to the delegate for control of the animation sequence
    AnimationDelegate *animationDelegate;
    AnimationDelegate *animationDelegate2;

}

@property (nonatomic, retain) FlipView *flipView;

@property (nonatomic, strong) NSString *myEmail;

@property (nonatomic, strong) IBOutlet UIButton *doneButton;
@property (nonatomic, strong) IBOutlet UIImageView *bgImage;
@property (nonatomic, strong) IBOutlet UIImageView *numberImage;
@property (nonatomic, strong) IBOutlet UIImageView *descriptionImage;
@property (nonatomic, strong) IBOutlet UIImageView *dividerImage;
@property (nonatomic, strong) IBOutlet UIImageView *placeImage;
@property (nonatomic, strong) IBOutlet UILabel *locationLabel;
@property (nonatomic, strong) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *huntDescriptionLabel;
@property (nonatomic, strong) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *restaurantLabel;
@property (nonatomic, strong) NSString *huntTitle;
@property (nonatomic, strong) NSString *huntCount;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *huntPicUrl;
@property (nonatomic, strong) NSString *huntDescription;
@property (nonatomic, strong) NSString *sponsored_hunt_name;

@property (nonatomic, strong) NSMutableDictionary *huntDescriptionDict;
@property (nonatomic, strong) NSMutableDictionary *huntCountDict;
@property (nonatomic, strong) NSMutableDictionary *huntLogoUrlDict;
@property (nonatomic, strong) NSMutableDictionary *huntPicUrlDict;

@property (nonatomic, strong) NSMutableDictionary *huntDict1;
@property (nonatomic, strong) NSMutableDictionary *huntDict2;
@property (nonatomic, strong) NSMutableDictionary *huntDict3;
@property (nonatomic, strong) NSMutableDictionary *huntDict4;
@property (nonatomic, strong) NSMutableDictionary *huntDict5;
@property (nonatomic, strong) NSMutableDictionary *huntDict6;
@property (nonatomic, strong) NSMutableDictionary *huntDict7;
@property (nonatomic, strong) NSMutableDictionary *huntDict8;
@property (nonatomic, strong) NSMutableDictionary *huntDict9;
@property (nonatomic, strong) NSMutableDictionary *huntDict10;

@property (nonatomic, strong) NSMutableArray *eatArray;
@property (nonatomic, strong) NSMutableArray *drinkArray;
@property (nonatomic, strong) NSMutableArray *playArray;
@property (nonatomic, strong) NSMutableArray *yookaArray;

@property (nonatomic, strong) NSMutableDictionary *eatDict;
@property (nonatomic, strong) NSMutableDictionary *drinkDict;
@property (nonatomic, strong) NSMutableDictionary *playDict;
@property (nonatomic, strong) NSMutableDictionary *yookaDict;


@property (nonatomic, strong) IBOutlet UIScrollView* gridScrollView;
@property (nonatomic, strong) IBOutlet UIButton *startButton;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView1;
@property (nonatomic, strong) IBOutlet UIView *FeaturedView;

@property (nonatomic, strong) IBOutlet UIImageView *bg_picImageView;
@property (nonatomic, strong) NSArray *featuredRestaurants;

@property (nonatomic, strong) NSMutableArray *subscribedHunts;
@property (nonatomic, strong) NSMutableArray *unsubscribedHunts;


@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (assign, nonatomic) MPFlipStyle flipStyle;

@property (nonatomic, retain) id<KCSStore> updateStore;

@property (nonatomic, strong) IBOutlet UIPageControl *hunts_pages;
@property (nonatomic, strong) IBOutlet UIImageView *profileImageView;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) NSDictionary *dict1;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;
@property (nonatomic, strong) NSMutableArray *sponsored_hunt_names;
@property (nonatomic, strong) NSMutableArray *featured_hunts;
@property (nonatomic, strong) NSMutableArray *featured_hunt;
@property (nonatomic, strong) NSMutableArray *featured_hunt_names;

@end
