//
//  YookaBackend.m
//  Yooka
//
//  Created by Joshua Cleetus on 12/02/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import "YookaBackend.h"

@implementation YookaBackend

// Kinvey code use: any "KCSPersistable" has to implement this mapping method
- (NSDictionary *)hostToKinveyPropertyMapping
{
    return @{
             @"text"       : @"text",
             @"userFullName"   : @"userFullName",
             @"userEmail"  : @"userEmail",
             @"postDate"   : @"postDate",
             @"userDate"   : @"userDate",
             @"dishName"   : @"dishName",
             @"venueName" : @"venueName",
             @"venueId" : @"venueId",
             @"venueAddress" : @"venueAddress",
             @"venueCc" : @"venueCc",
             @"venueCity" : @"venueCity",
             @"venueCountry" : @"venueCountry",
             @"venuePostalCode" : @"venuePostalCode",
             @"venueState" : @"venueState",
             @"rateValue" : @"rateValue",
             @"likes" : @"likes",
             @"caption" : @"caption",
             @"attachment" : @"attachment",
             @"userImage" : @"userImage",
             @"dishImage" : @"dishImage",
             @"following_users" : @"following_users",
             @"followers" : @"followers",
             @"Description" : @"Description",
             @"Name" : @"Name",
             @"Count" : @"Count",
             @"HuntName" : @"HuntName",
             @"Dishes" : @"Dishes",
             @"HuntDescription" : @"HuntDescription",
             @"RestaurantDescription" : @"RestaurantDescription",
             @"location_id" : @"location_id",
             @"address1" : @"address1",
             @"address2" : @"address2",
             @"businessType" : @"businessType",
             @"city" : @"city",
             @"country" : @"country",
             @"latitude" : @"latitude",
             @"linked_status" : @"linked_status",
             @"longitude" : @"longitude",
             @"name" : @"name",
             @"outOfBusiness" : @"outOfBusiness",
             @"phone" : @"phone",
             @"postcode" : @"postcode",
             @"pubishedAt" : @"pubishedAt",
             @"region" : @"region",
             @"HuntNames" : @"HuntNames",
             @"NotTriedHuntNames" : @"NotTriedHuntNames",
             @"Restaurant" : @"Restaurant",
             @"price_range" : @"price_range",
             @"open_hours" : @"open_hours",
             @"fsq_venue_id" : @"fsq_venue_id",
             @"HuntLogoUrl" : @"HuntLogoUrl",
             @"likers" : @"likers",
             @"postVote" : @"postVote",
             @"meta"       : KCSEntityKeyMetadata,
             @"kinveyId"   : KCSEntityKeyId,
             @"location"   : KCSEntityKeyGeolocation,
             };
}


+ (NSDictionary *)kinveyPropertyToCollectionMapping
{
    return @{@"attachment":KCSFileStoreCollectionName,
             @"userImage":KCSFileStoreCollectionName,
             @"dishImage":KCSFileStoreCollectionName
             };
}

@end
