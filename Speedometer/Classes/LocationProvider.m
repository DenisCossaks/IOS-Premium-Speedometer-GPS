
//
//  LocationProvider.m
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/27/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import "LocationProvider.h"
#import "LocationDelegate.h"


#define MAX_ELEMENT_COUNT   10
#define MAX_VALID_POINTS    4

@implementation LocationProvider (Formatter)

+ (NSString *)convertLatitudeToDMS:(double)degree
{
    if (degree == 0) {
        return @"";
    }
    
    // Use the non-negative value of degree. 
    double newDegree = degree < 0 ? degree * -1 : degree;
    
    // Get degree. Leaving fractional
    int iDegree = (int)newDegree;
    // Get minutes. Leaving fractional
    double dMinutes = fabs(newDegree - iDegree) * 60;
    int iMinutes = (int)dMinutes;
    // Get seconds. Leaving fractional
    double dSeconds = fabs(dMinutes - iMinutes) * 60;
    int iSeconds = (int)dSeconds;
    
    NSString * format = degree < 0 ? @"%d ̊%d'%d'' S" : @"%d ̊%d'%d'' N";
    NSString * result = [NSString stringWithFormat:format, iDegree, iMinutes, iSeconds];
    
    return result;
}

+ (NSString *)convertLongitudeToDMS:(double)degree
{
    if (degree == 0) {
        return @"";
    }
    
    // Use the non-negative value of degree. 
    double newDegree = degree < 0 ? degree * -1 : degree;
    
    // Get degree. Leaving fractional
    int iDegree = (int)newDegree;
    // Get minutes. Leaving fractional
    double dMinutes = fabs(newDegree - iDegree) * 60;
    int iMinutes = (int)dMinutes;
    // Get seconds. Leaving fractional
    double dSeconds = fabs(dMinutes - iMinutes) * 60;
    int iSeconds = (int)dSeconds;
    
    NSString * format = degree < 0 ? @"%d ̊%d'%d'' W" : @"%d ̊%d'%d'' E";
    NSString * result = [NSString stringWithFormat:format, iDegree, iMinutes, iSeconds];
    
    return result;
}

+ (NSString *)convertDegreeToGeoDirection:(double)degree
{
    NSString * direction = nil;
    int iDegree = (int)degree;
    
    if(iDegree >= 23 && iDegree <= 67){
        direction = @"NE";
    } else if(iDegree >= 68 && iDegree <= 112){
        direction = @"E";
    } else if(iDegree >= 113 && iDegree <= 167){
        direction = @"SE";
    } else if(iDegree >= 168 && iDegree <= 202){
        direction = @"S";
    } else if(iDegree >= 203 && iDegree <= 247){
        direction = @"SW";
    } else if(iDegree >= 248 && iDegree <= 293){
        direction = @"W";
    } else if(iDegree >= 294 && iDegree <= 337){
        direction = @"NW";
    } else if(iDegree >= 338 || iDegree <= 22){
        direction = @"N";
    }
    
    return direction;
}

@end

@implementation LocationProvider

@synthesize listeners = listeners_;
@synthesize locationMgr = locationMgr_;
@synthesize lInfo = lInfo_;
@synthesize cInfo = cInfo_;
@synthesize isActive = isActive_;
@synthesize valid = valid_;
@synthesize validSpeed = validSpeed_;

-(id)init
{
    if ((self = [super init]))
    {
        self.listeners = nil;
        self.locationMgr = [[CLLocationManager alloc] init];
        self.lInfo  = [[LocationInfo alloc] init];
        self.cInfo = [[CompassInfo alloc] init];
        self.lInfo.speed = -1;
        self.valid = [[NSMutableArray alloc] init];
        self.validSpeed = [[NSMutableArray alloc] init];
        failure_ = TRUE;
    }
    
    return self;
}

-(void)registerForLocationUpdate:(id)listener
{
    if (!self.listeners) {
        listeners_ = [[NSMutableArray alloc] initWithCapacity:1];
    }
    [self.listeners addObject:listener];
    
}

-(void)deregisterFromLocationUpdate:(id)listener
{
    if (self.listeners) {
        [self.listeners removeObject:listener];
    }
}

-(void)start
{
    self.locationMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    self.locationMgr.distanceFilter = kCLDistanceFilterNone;
    self.locationMgr.delegate = self;
    
    if ([CLLocationManager locationServicesEnabled])
    {
        [self.locationMgr startUpdatingLocation];
        isActive_ = TRUE;
    }
    else
    {
        for (id listener in self.listeners) {
            if ([listener respondsToSelector:@selector(updatedLocationInfoFailed)]) {
                [listener updatedLocationInfoFailed];
            }
        }
        
    }
    
    //Start the compass updates.
    if ([CLLocationManager headingAvailable]) 
    {
        [self.locationMgr startUpdatingHeading];
    }
    
    lastSpeed_ = 0;
}

-(void)stop
{
    [self.locationMgr stopUpdatingLocation];
    [self.locationMgr stopUpdatingHeading];
    isActive_ = FALSE;
}

-(void)updateHeadingOrientation:(CLDeviceOrientation)newHeadingOrientation
{
    self.locationMgr.headingOrientation = newHeadingOrientation;
}

#pragma mark -
#pragma mark CLLocationManagerDelegate methods

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    cInfo_.accuracy = newHeading.headingAccuracy;
    cInfo_.magneticHeading = newHeading.magneticHeading;
    cInfo_.trueHeading = newHeading.trueHeading;
    
    for (id listener in self.listeners) {
        if ([listener respondsToSelector:@selector(updatedCompassInfoReceived:)]) {
            ProviderInfo info;
            info.compassInfo_ = cInfo_;
            [listener updatedCompassInfoReceived:info];
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    failure_ = TRUE;
    
    for (id listener in self.listeners) {
        if ([listener respondsToSelector:@selector(updatedLocationInfoFailed)]) {
            [listener updatedLocationInfoFailed];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
   // NSLog(@"%.6f   %.6f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    
    for (id listener in self.listeners) {
        if ([listener respondsToSelector:@selector(updateAccuracyInfoReceived:)]) {
            [listener updateAccuracyInfoReceived:newLocation.horizontalAccuracy];
        }
    }
    
    static int iValidCount = 0;
    static BOOL bComplete = FALSE;
    NSLog(@"horizontalAccuracy: %.4f", newLocation.horizontalAccuracy);
    if (newLocation == nil || (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > 50) || failure_) 
    {
        failure_ = FALSE;
        [self.valid removeAllObjects];
        bComplete = FALSE;
        iValidCount = 0;
        return;
    }
    
    // Get the first several points for making average
    if (newLocation.horizontalAccuracy > 0 && iValidCount < 3 && !bComplete) {
        
        [self.valid addObject:newLocation];
        ++iValidCount;
        
        // send to listener
        lInfo_.horizontalAccuracy = newLocation.horizontalAccuracy;
        lInfo_.longitude = newLocation.coordinate.longitude;
        lInfo_.latitude = newLocation.coordinate.latitude;
        lInfo_.speed = newLocation.speed;
        lastSpeed_ = newLocation.speed;
        lInfo_.distance = 0;
        for (id listener in self.listeners) {
            if ([listener respondsToSelector:@selector(updatedLocationInfoReceived:)]) {
                ProviderInfo info;
                info.locationInfo_ = lInfo_;
                [listener updatedLocationInfoReceived:info];
            }
        }
        return;
    }
    
    if (iValidCount == 3) {
        bComplete = TRUE;
    }
    
    double distance = 0;
    
    CLLocation * lastLocation = [self.valid lastObject];
    CLLocation * lastPrevLocation = [self.valid objectAtIndex:1];
    CLLocationDistance distancePrevChange = [lastLocation distanceFromLocation:lastPrevLocation];
    CLLocationDistance distanceChange = [newLocation distanceFromLocation:lastLocation];
    NSTimeInterval sinceLastPrevUpdate = [lastLocation.timestamp timeIntervalSinceDate:lastPrevLocation.timestamp];
    NSTimeInterval sinceLastUpdate = [newLocation.timestamp timeIntervalSinceDate:lastLocation.timestamp];
    double newSpeed = distanceChange / sinceLastUpdate;
    double newPrevSpeed = distancePrevChange / sinceLastPrevUpdate;
    double acceleration = ((fabs(newPrevSpeed - newSpeed)) / sinceLastUpdate);
    //NSLog(@"horizontalAccuracy: %.2f", newLocation.horizontalAccuracy);
    if (acceleration > 5.0) {
        // send to listener
        
        lInfo_.horizontalAccuracy = newLocation.horizontalAccuracy;
        lInfo_.longitude = newLocation.coordinate.longitude;
        lInfo_.latitude = newLocation.coordinate.latitude;
        lInfo_.speed = lastSpeed_;
        lInfo_.distance = 0;
        lInfo_.avgSpeed = 0;
        for (id listener in self.listeners) {
            if ([listener respondsToSelector:@selector(updatedLocationInfoReceived:)]) {
                ProviderInfo info;
                info.locationInfo_ = lInfo_;
                [listener updatedLocationInfoReceived:info];
            }
        }
        return;
    }
    
    [self.valid replaceObjectAtIndex:0 withObject:[self.valid objectAtIndex:1]];
    [self.valid replaceObjectAtIndex:1 withObject:[self.valid objectAtIndex:2]];
    [self.valid replaceObjectAtIndex:2 withObject:newLocation];
    
    double sAv = 0;
    
    for (int i = 0; i < 2; ++i) {
        CLLocation * prevLocation = [self.valid objectAtIndex:i];
        CLLocation * nextLocation = [self.valid objectAtIndex:i+1];
        CLLocationDistance distanceChange = [nextLocation distanceFromLocation:prevLocation];
        NSTimeInterval sinceLastUpdate = [nextLocation.timestamp timeIntervalSinceDate:prevLocation.timestamp];
        
        if (i != 0) {
            distance += distanceChange;
            sAv = distanceChange / sinceLastUpdate;
        }
    }
    
    lastSpeed_ = 2 / ((lInfo_.speed == 0 ? 0 : 1/lInfo_.speed) + 1/sAv);
    
    lInfo_.speed = lastSpeed_ < 0 ? 0 : lastSpeed_;
    lInfo_.distance = distance;

    double accuracy = newLocation.horizontalAccuracy;
    lInfo_.horizontalAccuracy = accuracy;
    
    // Check horizontal accuracy
    if (accuracy < 0) {
        lInfo_.longitude = -1;
        lInfo_.latitude = -1;
    }
    else
    {        
        lInfo_.longitude = newLocation.coordinate.longitude;
        lInfo_.latitude = newLocation.coordinate.latitude;
    }
    
    // Check vertical accuracy
    if (newLocation.verticalAccuracy < 0) {
        lInfo_.altitude = newLocation.altitude;
    }
    else
    {
        lInfo_.altitude = newLocation.altitude;
    }
    NSLog(@"Corse:  %f", newLocation.course);
    lInfo_.course = newLocation.course;
    for (id listener in self.listeners) {
        if ([listener respondsToSelector:@selector(updatedLocationInfoReceived:)]) {
            ProviderInfo info;
            info.locationInfo_ = lInfo_;
            [listener updatedLocationInfoReceived:info];
        }
    }
}

/******************Old Code**********************
 if (newLocation == nil || (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > 50)) 
 {
 return;
 }
 
 double accuracy = newLocation.horizontalAccuracy;
 lInfo_.horizontalAccuracy = accuracy;
 
 // Check horizontal accuracy
 if (accuracy < 0) {
 lInfo_.longitude = -1;
 lInfo_.latitude = -1;
 }
 else
 {        
 lInfo_.longitude = newLocation.coordinate.longitude;
 lInfo_.latitude = newLocation.coordinate.latitude;
 }
 
 if(oldLocation != nil && oldLocation.horizontalAccuracy > 0 && oldLocation.horizontalAccuracy < 50)
 {
 CLLocationDistance distanceChange = [newLocation distanceFromLocation:oldLocation];
 NSTimeInterval sinceLastUpdate = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
 double newSpeed = distanceChange / sinceLastUpdate;
 double acceleration = ((fabs(lastSpeed_ - newSpeed)) / sinceLastUpdate);
 if (sinceLastUpdate != 0 && acceleration < 7.0) {
 lInfo_.speed = newSpeed;
 lastSpeed_ = newSpeed;
 }
 else
 {
 lInfo_.speed = lastSpeed_ == 0 ? -1 : lastSpeed_;
 }
 
 lastSpeed_ = newSpeed;
 lInfo_.distance = distanceChange;
 }
 else if (newLocation.speed > 0) 
 {
 lInfo_.speed = newLocation.speed;
 lastSpeed_ = newLocation.speed;
 }
 else
 {
 lInfo_.speed = -1;
 }
 
 // Check vertical accuracy
 if (newLocation.verticalAccuracy < 0) {
 lInfo_.altitude = newLocation.altitude;
 }
 else
 {
 lInfo_.altitude = newLocation.altitude;
 }
 lInfo_.course = newLocation.course;
 if ([listener_ respondsToSelector:@selector(updatedLocationInfoReceived:)]) {
 ProviderInfo info;
 info.locationInfo_ = lInfo_;
 [listener_ updatedLocationInfoReceived:info];
 }
 ****************************************/

/******************New Code**********************
 
 static int iValidCount = 0;
 static BOOL bComplete = FALSE;
 
 if (newLocation == nil || (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > 50) || failure_) 
 {
 failure_ = FALSE;
 [self.valid removeAllObjects];
 bComplete = FALSE;
 iValidCount = 0;
 return;
 }
 
 // Get the first several points for making average
 if (newLocation.horizontalAccuracy > 0 && iValidCount < 3 && !bComplete) {
 
 [self.valid addObject:newLocation];
 ++iValidCount;
 
 // send to listener
 lInfo_.horizontalAccuracy = newLocation.horizontalAccuracy;
 lInfo_.longitude = newLocation.coordinate.longitude;
 lInfo_.latitude = newLocation.coordinate.latitude;
 lInfo_.speed = newLocation.speed;
 lastSpeed_ = newLocation.speed;
 lInfo_.distance = 0;
 if ([listener_ respondsToSelector:@selector(updatedLocationInfoReceived:)]) {
 ProviderInfo info;
 info.locationInfo_ = lInfo_;
 [listener_ updatedLocationInfoReceived:info];
 }
 return;
 }
 
 if (iValidCount == 3) {
 bComplete = TRUE;
 }
 
 double distance = 0;
 
 CLLocation * lastLocation = [self.valid lastObject];
 CLLocation * lastPrevLocation = [self.valid objectAtIndex:1];
 CLLocationDistance distancePrevChange = [lastLocation distanceFromLocation:lastPrevLocation];
 CLLocationDistance distanceChange = [newLocation distanceFromLocation:lastLocation];
 NSTimeInterval sinceLastPrevUpdate = [lastLocation.timestamp timeIntervalSinceDate:lastPrevLocation.timestamp];
 NSTimeInterval sinceLastUpdate = [newLocation.timestamp timeIntervalSinceDate:lastLocation.timestamp];
 double newSpeed = distanceChange / sinceLastUpdate;
 double newPrevSpeed = distancePrevChange / sinceLastPrevUpdate;
 double acceleration = ((fabs(newPrevSpeed - newSpeed)) / sinceLastUpdate);
 if (acceleration > 5.0) {
 // send to listener
 lInfo_.horizontalAccuracy = newLocation.horizontalAccuracy;
 lInfo_.longitude = newLocation.coordinate.longitude;
 lInfo_.latitude = newLocation.coordinate.latitude;
 lInfo_.speed = lastSpeed_;
 lInfo_.distance = 0;
 if ([listener_ respondsToSelector:@selector(updatedLocationInfoReceived:)]) {
 ProviderInfo info;
 info.locationInfo_ = lInfo_;
 [listener_ updatedLocationInfoReceived:info];
 }
 return;
 }
 
 [self.valid replaceObjectAtIndex:0 withObject:[self.valid objectAtIndex:1]];
 [self.valid replaceObjectAtIndex:1 withObject:[self.valid objectAtIndex:2]];
 [self.valid replaceObjectAtIndex:2 withObject:newLocation];
 
 double s1 = 0;
 double s2 = 0;
 
 for (int i = 0; i < 2; ++i) {
 CLLocation * prevLocation = [self.valid objectAtIndex:i];
 CLLocation * nextLocation = [self.valid objectAtIndex:i+1];
 CLLocationDistance distanceChange = [nextLocation distanceFromLocation:prevLocation];
 NSTimeInterval sinceLastUpdate = [nextLocation.timestamp timeIntervalSinceDate:prevLocation.timestamp];
 
 if (i == 0) {
 s1 = distanceChange / sinceLastUpdate;
 }
 else {
 s2 = distanceChange / sinceLastUpdate;
 distance += distanceChange;
 }
 }
 
 lastSpeed_ = 2 / (1/s1 + 1/s2);
 lastSpeed_ = 2 / (1/lastSpeed_ + 1/s2);
 
 lInfo_.speed = lastSpeed_;
 lInfo_.distance = distance;
 
 double accuracy = newLocation.horizontalAccuracy;
 lInfo_.horizontalAccuracy = accuracy;
 
 // Check horizontal accuracy
 if (accuracy < 0) {
 lInfo_.longitude = -1;
 lInfo_.latitude = -1;
 }
 else
 {        
 lInfo_.longitude = newLocation.coordinate.longitude;
 lInfo_.latitude = newLocation.coordinate.latitude;
 }
 
 // Check vertical accuracy
 if (newLocation.verticalAccuracy < 0) {
 lInfo_.altitude = newLocation.altitude;
 }
 else
 {
 lInfo_.altitude = newLocation.altitude;
 }
 lInfo_.course = newLocation.course;
 if ([listener_ respondsToSelector:@selector(updatedLocationInfoReceived:)]) {
 ProviderInfo info;
 info.locationInfo_ = lInfo_;
 [listener_ updatedLocationInfoReceived:info];
 }
 ****************************************/

/****************************UN TESTED****************************
 static int iValidCount = -1;
 static BOOL bComplete = FALSE;
 
 if (newLocation == nil || (newLocation.horizontalAccuracy < 0 || newLocation.horizontalAccuracy > 50) || failure_) 
 {
 failure_ = FALSE;
 [self.valid removeAllObjects];
 [self.validSpeed removeAllObjects];
 bComplete = FALSE;
 iValidCount = -1;
 return;
 }
 
 // Get the first several points for making average
 if (newLocation.horizontalAccuracy > 0 && iValidCount < 4 && !bComplete) {
 
 // Skip first point
 if (iValidCount == -1) {
 ++iValidCount;
 return;
 }
 
 [self.valid addObject:newLocation];
 
 // send to listener
 lInfo_.horizontalAccuracy = newLocation.horizontalAccuracy;
 lInfo_.longitude = newLocation.coordinate.longitude;
 lInfo_.latitude = newLocation.coordinate.latitude;
 lInfo_.speed = newLocation.speed;
 lastSpeed_ = newLocation.speed;
 lInfo_.distance = 0;
 if ([listener_ respondsToSelector:@selector(updatedLocationInfoReceived:)]) {
 ProviderInfo info;
 info.locationInfo_ = lInfo_;
 [listener_ updatedLocationInfoReceived:info];
 }
 
 // update speed container
 if (iValidCount > 0) {
 [self.validSpeed addObject:[NSNumber numberWithDouble:newLocation.speed]];
 }
 
 ++iValidCount;
 
 return;
 }
 
 if (iValidCount == 4) {
 bComplete = TRUE;
 }
 
 // Replace locations with updated
 [self.valid replaceObjectAtIndex:0 withObject:[self.valid objectAtIndex:1]];
 [self.valid replaceObjectAtIndex:1 withObject:[self.valid objectAtIndex:2]];
 [self.valid replaceObjectAtIndex:2 withObject:[self.valid objectAtIndex:3]];
 [self.valid replaceObjectAtIndex:3 withObject:newLocation];
 
 // Find the next possible value for speed
 CLLocation * loc0 = [self.valid objectAtIndex:0];
 CLLocation * loc1 = [self.valid objectAtIndex:1];
 CLLocation * loc2 = [self.valid objectAtIndex:2];
 CLLocation * loc3 = [self.valid objectAtIndex:3];
 NSTimeInterval ti0 = [loc1.timestamp timeIntervalSinceDate:loc0.timestamp];
 NSTimeInterval ti1 = [loc2.timestamp timeIntervalSinceDate:loc1.timestamp];
 NSTimeInterval ti2 = [loc3.timestamp timeIntervalSinceDate:loc2.timestamp];
 double dDeviceSpeedPrev = [[self.validSpeed objectAtIndex:2] doubleValue];
 double dDeviceSpeedLast = [loc3 distanceFromLocation:loc2] / ti2;
 double acceleration = ((fabs(dDeviceSpeedPrev - dDeviceSpeedLast)) / (ti1 + ti2));
 if (acceleration > 5.0) {
 // extrapolate speed
 double dSpeed0 = [[self.validSpeed objectAtIndex:0] doubleValue];
 double dSpeed1 = [[self.validSpeed objectAtIndex:1] doubleValue];
 double dSpeed2 = [[self.validSpeed objectAtIndex:2] doubleValue];
 
 double extrapolatedSpeed = 0.0f;
 
 // Speed increasing
 if (dSpeed0 < dSpeed1 && dSpeed1 < dSpeed2) {
 double delta1 = (dSpeed1 - dSpeed0) / ti0;
 double delta2 = (dSpeed2 - dSpeed1) / ti1;
 extrapolatedSpeed = dSpeed0 + (delta1 + delta2) * 0.5 * (ti0 + ti1 + ti2);
 }
 // Speed flickering
 else if ((dSpeed0 < dSpeed1 && dSpeed1 > dSpeed2) || 
 (dSpeed0 > dSpeed1 && dSpeed1 < dSpeed2))
 {
 double delta1 = (dSpeed1 - dSpeed0) / ti0;
 double delta2 = (dSpeed2 - dSpeed1) / ti1;
 extrapolatedSpeed = dSpeed0 + (delta1 + delta2) * 0.5;
 }
 // Speed decreasing
 else if (dSpeed0 > dSpeed1 && dSpeed1 > dSpeed2)
 {
 double delta1 = (dSpeed1 - dSpeed0) / ti0;
 double delta2 = (dSpeed2 - dSpeed1) / ti1;
 extrapolatedSpeed = dSpeed0 + (delta1 + delta2) * 0.5 * (ti0 + ti1 + ti2);
 }
 
 lastSpeed_ = extrapolatedSpeed;
 
 // send to listener
 lInfo_.horizontalAccuracy = newLocation.horizontalAccuracy;
 lInfo_.longitude = newLocation.coordinate.longitude;
 lInfo_.latitude = newLocation.coordinate.latitude;
 lInfo_.speed = lastSpeed_;
 lInfo_.distance = 0;
 if ([listener_ respondsToSelector:@selector(updatedLocationInfoReceived:)]) {
 ProviderInfo info;
 info.locationInfo_ = lInfo_;
 [listener_ updatedLocationInfoReceived:info];
 }
 
 [self.validSpeed replaceObjectAtIndex:0 withObject:[self.validSpeed objectAtIndex:1]];
 [self.validSpeed replaceObjectAtIndex:1 withObject:[self.validSpeed objectAtIndex:2]];
 [self.validSpeed replaceObjectAtIndex:2 withObject:[NSNumber numberWithDouble:lastSpeed_]];
 
 return;
 }
 
 [self.validSpeed replaceObjectAtIndex:0 withObject:[self.validSpeed objectAtIndex:1]];
 [self.validSpeed replaceObjectAtIndex:1 withObject:[self.validSpeed objectAtIndex:2]];
 [self.validSpeed replaceObjectAtIndex:2 withObject:[NSNumber numberWithDouble:dDeviceSpeedLast]];
 
 double distance = 0;
 
 for (int i = 0; i < 3; ++i) {
 CLLocation * prevLocation = [self.valid objectAtIndex:i];
 CLLocation * nextLocation = [self.valid objectAtIndex:i+1];
 CLLocationDistance distanceChange = [nextLocation distanceFromLocation:prevLocation];
 
 if (i > 1) {
 distance += distanceChange;
 }
 }
 
 NSLog(@"Original speed: %f", newLocation.speed * 3.6);
 
 lastSpeed_ = (dDeviceSpeedLast < 0.0) ? 0.0 : dDeviceSpeedLast; 
 
 lInfo_.speed = lastSpeed_;
 lInfo_.distance = distance;
 
 double accuracy = newLocation.horizontalAccuracy;
 lInfo_.horizontalAccuracy = accuracy;
 
 // Check horizontal accuracy
 if (accuracy < 0) {
 lInfo_.longitude = -1;
 lInfo_.latitude = -1;
 }
 else
 {        
 lInfo_.longitude = newLocation.coordinate.longitude;
 lInfo_.latitude = newLocation.coordinate.latitude;
 }
 
 // Check vertical accuracy
 if (newLocation.verticalAccuracy < 0) {
 lInfo_.altitude = newLocation.altitude;
 }
 else
 {
 lInfo_.altitude = newLocation.altitude;
 }
 lInfo_.course = newLocation.course;
 if ([listener_ respondsToSelector:@selector(updatedLocationInfoReceived:)]) {
 ProviderInfo info;
 info.locationInfo_ = lInfo_;
 [listener_ updatedLocationInfoReceived:info];
 }
 ****************************************************************/

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager
{
    return NO;
}

- (BOOL)significantLocationChangeMonitoringAvailable
{
    return YES;
}

#pragma mark - 
#pragma mark Data management

-(void)dealloc
{
    [locationMgr_ release];
    [lInfo_ release];
    [cInfo_ release];
    [super dealloc];
}


@end
