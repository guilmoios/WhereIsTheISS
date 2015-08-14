//
//  MainViewController.h
//  WhereIsTheISS
//
//  Created by Guilherme Mogames on 8/1/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

// Icons
typedef NS_ENUM(NSUInteger, MapIcons) {
    MapIconsRocket      = 1,
    MapIconsSaucer      = 2,
    MapIconsAstronaut   = 3,
    MapIconsSatellite   = 4
};

// Times
typedef NS_ENUM(NSUInteger, MapRefreshTime) {
    MapRefreshTimeFive      = 5,
    MapRefreshTimeFifteen   = 15,
    MapRefreshTimeThrirty   = 30,
    MapRefreshTimeSixty     = 60
};

@interface MainViewController : UIViewController

// Map
@property(nonatomic,assign) CLLocationCoordinate2D ISSLocation;
@property(nonatomic,assign) double timestamp;

// Settings
@property(nonatomic,assign) double timeInterval;
@property(nonatomic,assign) BOOL centerMap;
@property(nonatomic,strong) UIImage *mapIcon;

// ISS API Pooling Methods
- (void)startPooling;
- (void)restartPooling;
- (void)dataReceived:(NSData *)theData;

// Location API Pooling Properties & Methods
@property (nonatomic, strong) NSTimer *locationPoolingTimer;
@property (nonatomic, strong) NSString *nearLocationString;

- (void)startLocationPooling;
- (void)restartLocationPooling;
- (void)locationReceived:(NSData *)theData;

// Refresh ISS update Time
- (void)updateRefreshTime:(NSInteger)time;


@end
