//
//  BDViewController+Private.h
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BDViewController.h"

@interface BDViewController (Private) 
- (void) _demoAsyncDataLoading;
- (void) _demoAsyncDataLoading2;
//- (void) _demoAsyncDataLoading3;
- (void) buildBarButtons;

- (void)showActivityIndicator;
- (void)stopActivityIndicator;
- (void)stopActivityIndicator2;

- (void)showReloadButton;
- (void)showLogoutButton;

@end
