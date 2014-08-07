//
//  WebImageOperations.m
//  Yooka
//
//  Created by Joshua Cleetus on 4/28/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "WebImageOperations.h"
#import <QuartzCore/QuartzCore.h>

@implementation WebImageOperations

+ (void) loadFromURL: (NSURL*) url callback:(void (^)(UIImage *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:imageData];
            callback(image);
        });
    });
}

@end
