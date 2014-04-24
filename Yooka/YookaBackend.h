//
//  YookaBackend.h
//  Yooka
//
//  Created by Joshua Cleetus on 12/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <KinveyKit/KinveyKit.h>
#import <CoreLocation/CoreLocation.h>

@interface YookaBackend : NSObject<KCSPersistable>

@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSString* kinveyId;
@property (nonatomic, retain) NSString* userFullName;
@property (nonatomic, retain) NSString* userEmail;
@property (nonatomic, retain) NSString* dishName;
@property (nonatomic, retain) NSString* venueName;
@property (nonatomic, retain) NSString* venueId;
@property (nonatomic, retain) NSString* venueAddress;
@property (nonatomic, retain) NSString* venueCc;
@property (nonatomic, retain) NSString* venueCity;
@property (nonatomic, retain) NSString* venueCountry;
@property (nonatomic, retain) NSString* venuePostalCode;
@property (nonatomic, retain) NSString* venueState;
@property (nonatomic, retain) NSString* rateValue;
@property (nonatomic, retain) NSString* likes;
@property (nonatomic, retain) NSString* caption;
@property (nonatomic, retain) NSString* Description;
@property (nonatomic, retain) NSString* Name;
@property (nonatomic, retain) NSString* Count;
@property (nonatomic, retain) NSString* HuntName;
@property (nonatomic, retain) NSString* HuntDescription;
@property (nonatomic, retain) NSString* RestaurantDescription;
@property (nonatomic, retain) NSString* location_id;
@property (nonatomic, retain) NSString* address1;
@property (nonatomic, retain) NSString* address2;
@property (nonatomic, retain) NSString* businessType;
@property (nonatomic, retain) NSString* city;
@property (nonatomic, retain) NSString* country;
@property (nonatomic, retain) NSString* latitude;
@property (nonatomic, retain) NSString* linked_status;
@property (nonatomic, retain) NSString* longitude;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* outOfBusiness;
@property (nonatomic, retain) NSString* phone;
@property (nonatomic, retain) NSString* postcode;
@property (nonatomic, retain) NSString* pubishedAt;
@property (nonatomic, retain) NSString* region;
@property (nonatomic, retain) NSString* Restaurant;
@property (nonatomic, retain) NSString* price_range;
@property (nonatomic, retain) NSString* open_hours;
@property (nonatomic, retain) NSString* fsq_venue_id;
@property (nonatomic, retain) NSString* HuntLogoUrl;
@property (nonatomic, retain) NSString* postVote;
@property (nonatomic, retain) NSDate* postDate;
@property (nonatomic, retain) NSDate* userDate;//user profile created or updated date
@property (nonatomic, retain) UIImage* attachment;
@property (nonatomic, retain) UIImage* userImage;
@property (nonatomic, retain) UIImage* dishImage;
@property (nonatomic, retain) KCSMetadata* meta;
@property (nonatomic, retain) CLLocation* location;
@property (nonatomic, copy) NSArray* Dishes;
@property (nonatomic, copy) NSArray* HuntNames;
@property (nonatomic, copy) NSArray* NotTriedHuntNames;
@property (nonatomic, copy) NSArray* following_users;
@property (nonatomic, copy) NSArray* followers;
@property (nonatomic, copy) NSArray* likers;

@end
