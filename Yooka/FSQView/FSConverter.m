//
//  FSConverter.m
//  Foursquare2-iOS
//
//  Created by Constantine Fry on 2/7/13.
//
//

#import "FSConverter.h"
#import "FSVenue.h"

@implementation FSConverter

- (NSArray *)convertToObjects:(NSArray *)venues {
    NSMutableArray *objects = [NSMutableArray arrayWithCapacity:venues.count];
    for (NSDictionary *v  in venues) {
        FSVenue *ann = [[FSVenue alloc]init];
        ann.name = v[@"name"];
        ann.venueId = v[@"id"];
        ann.location.address = v[@"location"][@"address"];
        ann.location.cc = v[@"location"][@"cc"];
        ann.location.city = v[@"location"][@"city"];
        ann.location.country = v[@"location"][@"country"];
        ann.location.crossStreet = v[@"location"][@"crossStreet"];
        ann.location.postalCode = v[@"location"][@"postalCode"];
        ann.location.state = v[@"location"][@"state"];
        ann.location.distance = v[@"location"][@"distance"];
        
        [ann.location setCoordinate:CLLocationCoordinate2DMake([v[@"location"][@"lat"] doubleValue],
                                                      [v[@"location"][@"lng"] doubleValue])];
        [objects addObject:ann];
    }
    return objects;
}

- (NSArray *)convertToMenuObjects:(NSArray *)menus {
    
    NSMutableArray *menuObjects = [NSMutableArray arrayWithCapacity:menus.count];
    for (NSDictionary *v  in menus) {
        FSVenue *ann = [[FSVenue alloc]init];
        ann.menuName = v[@"name"];
        [menuObjects addObject:ann];
    }
    return menuObjects;
}

@end
