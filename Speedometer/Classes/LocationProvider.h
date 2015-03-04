//
//  LocationProvider.h
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/27/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#import "ProviderInfo.h"

@interface LocationProvider : NSObject<CLLocationManagerDelegate> {

@private
    NSMutableArray *listeners_;
    CLLocationManager * locationMgr_;
    
    LocationInfo * lInfo_;
    CompassInfo * cInfo_;
    
    // Active service flag
    BOOL isActive_;
    
    // Last accurate speed
    double lastSpeed_;
    
    // Valid location points
    NSMutableArray * valid_;
    // Valid speed points
    NSMutableArray * validSpeed_;
    
    BOOL failure_;
    
    NSInteger failuresCount_;
}

@property(readwrite, assign) NSMutableArray *listeners;
@property(readwrite, assign) CLLocationManager * locationMgr;
@property(readwrite, retain) LocationInfo * lInfo;
@property(readwrite, retain) CompassInfo * cInfo;
@property(readonly) BOOL isActive;
@property(nonatomic, retain) NSMutableArray * valid;
@property(nonatomic, retain) NSMutableArray * validSpeed;

-(void)registerForLocationUpdate:(id)listener;
-(void)deregisterFromLocationUpdate:(id)listener;
-(void)start;
-(void)stop;

@end

@interface LocationProvider (Formatter)

+ (NSString *)convertLatitudeToDMS:(double)degree;
+ (NSString *)convertLongitudeToDMS:(double)degree;
+ (NSString *)convertDegreeToGeoDirection:(double)degree;

@end