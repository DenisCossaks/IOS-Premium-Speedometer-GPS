//
//  ProviderInfo.m
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 04/12/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import "ProviderInfo.h"

@implementation LocationInfo

@synthesize speed;
@synthesize avgSpeed;
@synthesize altitude;
@synthesize course ;
@synthesize latitude;
@synthesize longitude;
@synthesize distance;
@synthesize horizontalAccuracy;

@end

@implementation CompassInfo

@synthesize magneticHeading;
@synthesize trueHeading;
@synthesize accuracy;

@end
