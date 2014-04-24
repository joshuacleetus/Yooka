//
//  AddressAnnotation.m
//  Neon
//
//  Created by Joshua Cleetus on 04/02/14.
//  Copyright (c) 2014 lovethe88. All rights reserved.
//

#import "AddressAnnotation.h"

@implementation AddressAnnotation
@synthesize coordinate;

- (NSString *)subtitle{
	return nil;
}

- (NSString *)title{
	return nil;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	return self;
}

@end
