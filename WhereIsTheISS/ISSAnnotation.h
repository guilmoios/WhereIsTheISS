//
//  ISSAnnotation.h
//  WhereIsTheISS
//
//  Created by Guilherme Mogames on 8/1/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ISSAnnotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coord;

@end
