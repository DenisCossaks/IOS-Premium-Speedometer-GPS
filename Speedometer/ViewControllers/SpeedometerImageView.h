//
//  SpeedometerImageView.h
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/19/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    CF_CAR,
    CF_BIKE,
} CiferblatMode;

#define MAX_GPS_STRENGTH  5
#define CENTER_X 143
#define CENTER_Y 143

#define ZERO_ANGLE_OFFSET_IPHONE_ARROW  -92.0
#define MAX_ANGLE_OFFSET_IPHONE_ARROW   174.2

#define CAR_MIL_START_SPEED             10.0
#define CAR_MIL_MAX_SPEED             140.0
#define CAR_MIL_TO_ANGLE  (MAX_ANGLE_OFFSET_IPHONE_ARROW - ZERO_ANGLE_OFFSET_IPHONE_ARROW) / (CAR_MIL_MAX_SPEED - CAR_MIL_START_SPEED)

#define CAR_KM_START_SPEED             0
#define CAR_KM_MAX_SPEED             260
#define CAR_KM_TO_ANGLE   (MAX_ANGLE_OFFSET_IPHONE_ARROW - ZERO_ANGLE_OFFSET_IPHONE_ARROW) / (CAR_KM_MAX_SPEED - CAR_KM_START_SPEED)

#define BIKE_MIL_START_SPEED             0.0
#define BIKE_MIL_MAX_SPEED             52
#define BIKE_MIL_TO_ANGLE  (MAX_ANGLE_OFFSET_IPHONE_ARROW - ZERO_ANGLE_OFFSET_IPHONE_ARROW) / (BIKE_MIL_MAX_SPEED - BIKE_MIL_START_SPEED)

#define BIKE_KM_START_SPEED             0
#define BIKE_KM_MAX_SPEED             104
#define BIKE_KM_TO_ANGLE   (MAX_ANGLE_OFFSET_IPHONE_ARROW - ZERO_ANGLE_OFFSET_IPHONE_ARROW) / (BIKE_KM_MAX_SPEED - BIKE_KM_START_SPEED)


@interface SpeedometerImageView : UIImageView {
    //car KM/H nad MP/H Scale Image View
    UIImageView * carKMHScaleImageView;
    UIImageView * carMPHScaleImageView;
    
    //bike KM/H nad MP/H Scale Image View
    UIImageView * bikeKMHScaleImageView;
    UIImageView * bikeMPHScaleImageView;
    
    UIImageView * needleImageView;
    UIButton * mphButton;
    UIButton * kmhButton;
    UILabel * speedLabel;
    UILabel * typeLabel;
    UILabel * directionLabel;
    CiferblatMode ciferblatMode;
    NSMutableArray * gpsLights;
}

@property (nonatomic,assign) CiferblatMode ciferblatMode;
-(void) createOrUpdateButtonsOnSuperview:(CGRect) frame;
-(void) setSpeed:(double) speed animate:(BOOL) animate;
-(void) setDirectionDegree:(double) degree;
-(BOOL) isKmhUnit;
-(NSString *) getSpeedString;
-(NSString *) getDirectionString;
-(void) setGpsStrength:(NSInteger) strength ;

@end
