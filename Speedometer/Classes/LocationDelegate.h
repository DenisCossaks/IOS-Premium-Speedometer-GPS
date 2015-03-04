//
//  LocationDelegate.h
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 04/28/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProviderInfo.h"

@protocol LocationDelegate<NSObject>
@optional
- (void)updatedCompassInfoReceived:(ProviderInfo)info;
- (void)updatedCompassInfoFailed;

- (void)updatedLocationInfoReceived:(ProviderInfo)info;
- (void)updatedLocationInfoFailed;


- (void) updateAccuracyInfoReceived:(double)test;
@end
