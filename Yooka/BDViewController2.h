//
//  BDViewController.h
//  BDDynamicGridViewDemo
//
//  Created by Nor Oh on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDDynamicGridViewController2.h"
@interface BDViewController2 : BDDynamicGridViewController2 <BDDynamicGridViewDelegate2>{
    NSArray * _items;
}

- (void)animateReload;

@end
