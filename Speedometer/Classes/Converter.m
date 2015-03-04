//
//  Converter.m
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 04/26/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import "Converter.h"
#define METERPERSECOND_TO_KMH   3.6
#define METERPERSECOND_TO_MPH   2.23
#define METER_TO_MILE           0.0006214
#define METER_TO_KM             0.001
#define KMH_TO_MPH              0.62
#define METER_TO_FEET           3.2808399

@implementation Converter
static NSDateFormatter *formatter_ = nil;
static NSDate *date_ = nil;
static NSTimeInterval cutTime = 0;

+ (double)mpsToMph:(double)mps
{
    return mps * METERPERSECOND_TO_MPH;
}

+ (double)mpsToKmh:(double)mps
{
    return mps * METERPERSECOND_TO_KMH;
}

+ (double)meterToMiles:(double)meters
{
    return meters * METER_TO_MILE;
}

+ (double)meterToKm:(double)meters
{
    return meters * METER_TO_KM;
}


+ (double)meterToFeet:(double)meters
{
    return meters * METER_TO_FEET;
}

+ (NSString *)timeIntervalToString:(NSTimeInterval)time
{
    int hours = time / 3600;
    int minutes = floor(time / 60) - hours * 60;
    int seconds = trunc(time - minutes * 60 - hours * 3600);
    
    NSString * sHours = nil;
    NSString * sMinutes = nil;
    NSString * sSeconds = nil;
    
    sHours = (hours < 10) ? [NSString stringWithFormat:@"0%d", hours] : [NSString stringWithFormat:@"%d", hours];
    sMinutes = (minutes < 10) ? [NSString stringWithFormat:@"0%d", minutes] : [NSString stringWithFormat:@"%d", minutes];
    sSeconds = (seconds < 10) ? [NSString stringWithFormat:@"0%d", seconds] : [NSString stringWithFormat:@"%d", seconds];
    
    return [NSString stringWithFormat:@"%@:%@:%@", sHours, sMinutes, sSeconds];
}


+ (NSInteger)accuracyLevel:(double)accuracy
{
    // If horizontal accuracy outside of 1km range treat as invalid
    if (accuracy <= 10) {
        return 5;
    }else if (accuracy <= 20) {
        return 4;
    }else if (accuracy <= 25) {
        return 3;
    }else if (accuracy <= 35) {
        return 2;
    } if (accuracy <= 50) {
        return 1;
    }
    
    return 0;
}

+ (NSDateFormatter*) formatter
{
    if (!formatter_) {
        formatter_ = [[NSDateFormatter alloc] init];
        [formatter_ setDateFormat:@"hh:mm:ssa"];
        [formatter_ setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    }
    return formatter_;
}

+ (NSDate*) startDate
{
    if (!date_) {
        date_ = [[NSDate alloc] init];
    }
    return date_;
}

+ (NSString *) elapsedTime
{
    if (!date_) {
        return @"00:00:00";
    }
    NSTimeInterval timeInterval = -1 * [date_ timeIntervalSinceNow];
    timeInterval -= cutTime;
    timeInterval = timeInterval < 0 ? 0 : timeInterval;
    return [Converter timeIntervalToString:timeInterval];
}

+ (float) elapsedTimeHours
{
    if (!date_) {
        return .0f;
    }
    NSTimeInterval timeInterval = -1 * [date_ timeIntervalSinceNow];
    timeInterval -= cutTime;
    timeInterval = timeInterval < 0 ? 0 : timeInterval;
    return ( (float)timeInterval / 3600.f );
}

+ (void) releaseDate;
{
    [date_ release];
    date_ = nil;
}


+ (NSString*) time24:(NSDate*)date
{
    NSDateFormatter *formatter_ = [[NSDateFormatter alloc] init];
    [formatter_ setDateFormat:@"HH:mm:ss"];
    NSString *time = [formatter_ stringFromDate:date];
    [formatter_ release];
    return time;
}

+ (void) addCutTime:(NSTimeInterval)seconds
{
    cutTime += seconds;
}

+ (void) resetCutTime
{
    cutTime = 0;
}

+ (NSString*) headingSymbol:(int)heading
{
    if ((heading >= 339) || (heading <= 22))
        return  @" N";
    else if ((heading > 22) && (heading <= 68))
        return @" NE";
    else if ((heading > 68) && (heading <= 113))
        return @" E";
    else if ((heading > 113) && (heading <= 158))
        return  @" SE";
    else if ((heading > 158) && (heading <= 203))
        return @" S";
    else if ((heading > 203) && (heading <= 248))
        return @" SW";
    else if ((heading > 248) && (heading <= 293))
        return @" W";
    else if ((heading > 293) && (heading <= 338))
        return @" NW";
    
    return  @"";
}

@end
