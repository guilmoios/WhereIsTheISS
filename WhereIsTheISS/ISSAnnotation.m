//
//  ISSAnnotation.m
//  WhereIsTheISS
//
//  Created by Guilherme Mogames on 8/1/15.
//  Copyright (c) 2015 Mogames. All rights reserved.
//

#import "ISSAnnotation.h"

@implementation ISSAnnotation

- (id) initWithCoordinate:(CLLocationCoordinate2D)coord
{
    
    self = [super init];
    if (self) {
        _coordinate = coord;
    }
    return self;
}

@end
