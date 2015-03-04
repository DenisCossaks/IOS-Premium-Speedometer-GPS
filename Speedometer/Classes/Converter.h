//
//  Converter.h
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 04/26/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Converter : NSObject

+ (double)mpsToMph:(double)mps;
+ (double)mpsToKmh:(double)mps;
+ (double)meterToMiles:(double)meters;
+ (double)meterToKm:(double)meters;
+ (double)meterToFeet:(double)meters;

+ (NSDate*) startDate;
+ (void) releaseDate;
+ (NSString *)timeIntervalToString:(NSTimeInterval)time;
+ (NSString *) elapsedTime;
+ (float) elapsedTimeHours;
+ (NSString*) headingSymbol:(int)heading;
+ (NSString*) time24:(NSDate*)date;
+ (void) addCutTime:(NSTimeInterval)seconds;
+ (void) resetCutTime;
+ (NSInteger)accuracyLevel:(double)accuracy;

@end
