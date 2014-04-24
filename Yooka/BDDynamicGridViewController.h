//
//  BDDynamicGridViewController.h
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//
//  Copyright (c) 2012, Norsez Orankijanan (Bluedot) All Rights Reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, 
//  this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, 
//  this list of conditions and the following disclaimer in the documentation 
//  and/or other materials provided with the distribution.
//
//  3. Neither the name of Bluedot nor the names of its contributors may be used 
//  to endorse or promote products derived from this software without specific
//  prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE 
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
//  POSSIBILITY OF SUCH DAMAGE.


#import <UIKit/UIKit.h>
#import "BDDynamicGridViewDelegate.h"
#import <KinveyKit/KinveyKit.h>
#import <FacebookSDK.h>
/**

 
 */
@interface BDDynamicGridViewController : UIViewController {
    int j;
    int k;
}

/**
 @name Tasks
 */

/**
 Retrieve the view at the specified index.
 @param index the index of the view.
 @return the view, or nil if the view is not currently visible.
 */
- (UIView*) viewAtIndex:(NSUInteger)index;

/**
 @return the views that are currently visible.
 */
- (NSArray*) visibleViews;

/**
 
 @return BDRowInfo instances for the currently visible rows 
 */
- (NSArray*) visibleRowInfos;

/**
 Metadata of the current layout rows.
 @return list of BDRowInfo. Each BDRowInfo instance describes layout info of the current row.
 */
- (NSArray*) rowInfos;

/**
 Reload the entire view by asking the delegate for the latest data.
 */
- (void)reloadData;

/**
 Relayout with a grid pattern. 
 @param gridPattern array of NSNumber specifying each row's number of views.
 */
- (void)reloadDataWithGridPattern:(NSArray*)gridPattern;

/**
 Reload the views in rows specified by the input BDRowInfo objects.
 @param rowInfos list of BDRowInfo to be reloaded.
 */
- (void)reloadRows:(NSArray*)rowInfos;

/**
 Refresh layout on a specific row.
 @param rowInfo the row
 @param animated YES to see animation of layout refresh.
 */
- (void)updateLayoutWithRow:(BDRowInfo*)rowInfo animiated:(BOOL)animated;

/**
 Programmatically scroll to the specified row.
 @param row the row to scroll to.
 @param scrollPosition postion of the specified row when scrolling stops.
 @param animated animating flag of scrolling
 */
- (void)scrollToRow:(BDRowInfo*)row atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

/**
 @param color color for the background.
 */
- (void)setBackgroundColor:(UIColor*)color;

/**
 @name Properties
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;


/**
 The delegate of this class. Can be nil, but nothing will display.
 */
@property (nonatomic, strong) id<BDDynamicGridViewDelegate> delegate;

/**
 Top, left, right, buttom margin of each UIView in layout.
 */
@property (nonatomic, assign) CGFloat borderWidth;


/**
 The table view which is used for implementing this class.
 */
- (UITableView*)tableView;

/**
 @name Method delegator blocks
 */

/**
 Block executed when a UIView is long pressed. 
 The block is supplied by the view and its index in the UIView list.
 */
@property (nonatomic, copy) void (^onLongPress)(UIView*, NSInteger);

/**
 Block executed when a UIView is single tapped.
 The block is supplied by the view and its index in the UIView list.
 */
@property (nonatomic, copy) void (^onSingleTap)(UIView*, NSInteger);


/**
 Block executed when a UIView is double tapped.
 The block is supplied by the view and its index in the UIView list.
 */
@property (nonatomic, copy) void (^onDoubleTap)(UIView*, NSInteger);

@property (nonatomic, strong) UIScrollView* gridScrollView;
@property (nonatomic, strong) IBOutlet UIImageView *profile_bg;
@property (nonatomic, strong) IBOutlet UIView *circle_one;
@property (nonatomic, strong) IBOutlet UIView *circle_two;
@property (nonatomic, strong) IBOutlet UIView *headerView;
@property (nonatomic, strong) IBOutlet UIImageView *userView;
@property (nonatomic, strong) IBOutlet UILabel *usernameLbl;
@property (nonatomic, strong) NSString *userFullName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userEmail;
@property (nonatomic, strong) NSString *userPicUrl;
@property (nonatomic, strong) NSString *collectionName1;
@property (nonatomic, strong) NSString *customEndpoint1;
@property (nonatomic, strong) NSString *fieldName1;
@property (nonatomic, strong) NSDictionary *dict1;
@property (nonatomic, strong) UIImage* userImage;
@property (nonatomic, strong) IBOutlet UILabel *userFollowingLbl;
@property (nonatomic, strong) IBOutlet UIButton *userFollowingBtn;
@property (nonatomic, strong) IBOutlet UILabel *userpicturesLbl;
@property (nonatomic, strong) IBOutlet UILabel *userFollowersLbl;
@property (nonatomic, strong) IBOutlet UIButton *userFollowersBtn;
@property (nonatomic, strong) NSMutableArray* followingUsers;
@property (nonatomic, strong) NSMutableArray* followerUsers;
@property (nonatomic, strong) IBOutlet UIImageView *profile_bg1;
@property (nonatomic, strong) IBOutlet UILabel *profileLbl1;
@property (nonatomic, strong) NSMutableArray *myPosts;
@property (nonatomic, strong) NSMutableArray *yookaImages;
@property (nonatomic, strong) NSMutableArray *likesData;
@property (nonatomic, strong) NSMutableArray *likersData;
@property (nonatomic, strong) NSMutableArray *dishData;
@property (nonatomic, strong) NSMutableArray *postIdData;
@property (nonatomic, strong) NSString *likes;
@property (nonatomic, strong) NSMutableArray *postLikers;
@property (nonatomic, strong) NSString *postId;
@property (nonatomic, strong) NSString *postLikes;
@property (nonatomic, strong) NSString *likeStatus;

@property (nonatomic, retain) id<KCSStore> updateStore;


- (UIImage*) blur:(UIImage*)theImage;

- (void)getFollowingUsers;
- (void)getFollowerUsers;

@end
