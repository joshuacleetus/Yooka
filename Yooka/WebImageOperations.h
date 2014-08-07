//
//  WebImageOperations.h
//  Yooka
//
//  Created by Joshua Cleetus on 4/28/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebImageOperations : NSObject

// This takes in a string and imagedata object and returns imagedata processed on a background thread
+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback;

@end
