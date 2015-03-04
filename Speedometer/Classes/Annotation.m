//
//  Annotation.m
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/25/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation
@synthesize coordinates = coordinates_;

-(id)initWithCoordinates:(CLLocationCoordinate2D)coords
{
    self = [super init];
    if (self) {
        coordinates_ = coords;
    }
    
    return self;
}

- (CLLocationCoordinate2D)coordinate;
{
    return coordinates_;
}

- (NSString *)title
{
    return @"Start";
}

// optional
- (NSString *)subtitle
{
    return @"";
}

- (void)dealloc
{
    [super dealloc];
}


@end
