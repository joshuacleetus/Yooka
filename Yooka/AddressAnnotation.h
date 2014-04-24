//
//  AddressAnnotation.h
//  Neon
//
//  Created by Joshua Cleetus on 04/02/14.
//  Copyright (c) 2014 lovethe88. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface AddressAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D coordinate;
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) c;

@end
