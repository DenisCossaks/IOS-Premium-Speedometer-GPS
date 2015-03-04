//
//  ProviderInfo.h
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 04/12/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface LocationInfo : NSObject

@property (nonatomic)  double speed;
@property (nonatomic)  double avgSpeed;
@property (nonatomic)  double altitude;
@property (nonatomic)  double course;
@property (nonatomic)  double latitude;
@property (nonatomic)  double longitude;
@property (nonatomic)  double distance;
@property (nonatomic)  double horizontalAccuracy;

@end



@interface CompassInfo : NSObject

@property (nonatomic)  double magneticHeading;
@property (nonatomic)  double trueHeading;
@property (nonatomic)  double accuracy;


typedef union ProviderInfo_
{
    LocationInfo * locationInfo_;
    CompassInfo  * compassInfo_;
}ProviderInfo;

@end



