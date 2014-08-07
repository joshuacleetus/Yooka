//
//  YookaMapViewController.h
//  Yooka
//
//  Created by Joshua Cleetus on 7/17/14.
//  Copyright (c) 2014 Yooka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanelDelegate.h"
#import <MapKit/MapKit.h>

@interface YookaMapViewController : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>{
    int i;
}

@property (nonatomic, assign) id<PanelDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *navButton;
@property (strong, nonatomic) IBOutlet UIButton *navButton2;
@property (strong, nonatomic) IBOutlet UIButton *navButton3;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UIButton *topCommentButton;

@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) BOOL panelMovedRight;
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) NSTimer *locationTimer;
@property (nonatomic, retain) CLLocation* oldLocation;
@property (nonatomic, strong) CLLocation* currentLocation;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *mapAnnotations;
@property (nonatomic, strong) NSArray *featuredRestaurants;

@end
