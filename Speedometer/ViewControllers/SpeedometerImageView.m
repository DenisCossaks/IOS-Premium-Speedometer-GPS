//
//  SpeedometerImageView.m
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/19/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import "SpeedometerImageView.h"
#import "Converter.h"
#import <QuartzCore/QuartzCore.h>

@implementation SpeedometerImageView
@synthesize ciferblatMode;

- (id)init
{
    self = [super initWithImage:[UIImage imageNamed:@"SpeedBGPort.png"]];
    if (self) {
        self.userInteractionEnabled = YES;
        // Initialization code
        
        carKMHScaleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carKmh.png"]];
        carKMHScaleImageView.center = CGPointMake(CENTER_X, CENTER_Y);
        [self addSubview:carKMHScaleImageView];
        
        carMPHScaleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carMph.png"]];
        carMPHScaleImageView.center = CGPointMake(CENTER_X, CENTER_Y);
        carMPHScaleImageView.hidden = YES;
        [self addSubview:carMPHScaleImageView];
        
        bikeKMHScaleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bikeKmh.png"]];
        bikeKMHScaleImageView.center = CGPointMake(CENTER_X, CENTER_Y);
        bikeKMHScaleImageView.hidden = YES;
        [self addSubview:bikeKMHScaleImageView];
        
        bikeMPHScaleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bikeMph.png"]];
        bikeMPHScaleImageView.center = CGPointMake(CENTER_X, CENTER_Y);
        bikeMPHScaleImageView.hidden = YES;
        [self addSubview:bikeMPHScaleImageView];
        
        UIView * scaleGridView = [[UIView alloc] initWithFrame:carKMHScaleImageView.frame];
        [self addSubview:scaleGridView];
        [scaleGridView release];
        
        needleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
        needleImageView.frame = CGRectMake(scaleGridView.frame.size.width / 4.0 - 12, scaleGridView.frame.size.height / 2.0 - needleImageView.frame.size.height / 2.0, needleImageView.frame.size.width, needleImageView.frame.size.height);
        
        needleImageView.layer.anchorPoint = CGPointMake(1 - 12.0 / needleImageView.frame.size.width, needleImageView.layer.anchorPoint.y);
        [scaleGridView addSubview:needleImageView];
        
        UIImageView * cirlce = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 163, 163)];
        
        [self addSubview:cirlce];
        cirlce.center = CGPointMake(CENTER_X - 4, CENTER_Y - 2);
        
        
        speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cirlce.frame.size.width, 65)];
        speedLabel.center = CGPointMake(cirlce.frame.size.width / 2.0 + 7, cirlce.frame.size.height / 2.0 + 5 );
        speedLabel.text = @"0.0";
        speedLabel.font = [UIFont fontWithName:@"Digital-7" size:65];
        speedLabel.textColor = [UIColor whiteColor];
        speedLabel.textAlignment = UITextAlignmentCenter;
        speedLabel.backgroundColor = [UIColor clearColor];
        [cirlce addSubview:speedLabel];
        
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, speedLabel.frame.origin.y + speedLabel.frame.size.height - 10, cirlce.frame.size.width, 40)];
        typeLabel.text = @"MPH";
        typeLabel.font = [UIFont fontWithName:@"Digital-7" size:30];
        typeLabel.textColor = [UIColor whiteColor];
        typeLabel.textAlignment = UITextAlignmentCenter;
        typeLabel.backgroundColor = [UIColor clearColor];
        [cirlce addSubview:typeLabel];
        
        directionLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 22 , cirlce.frame.size.width, 40)];
        directionLabel.text = @"N 0";
        directionLabel.font = [UIFont fontWithName:@"Digital-7" size:22];
        directionLabel.textColor = [UIColor whiteColor];
        directionLabel.textAlignment = UITextAlignmentCenter;
        directionLabel.backgroundColor = [UIColor clearColor];
        [cirlce addSubview:directionLabel];
        
        gpsLights = [[NSMutableArray alloc] init];
        for(int i = 0; i < MAX_GPS_STRENGTH; ++i) {
            UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gpslight.png"]];
            [gpsLights addObject:imageView];
            [self addSubview:imageView];
            [imageView release];
        }
        
        UIImageView * imageView = [gpsLights objectAtIndex:0];
        imageView.frame = CGRectMake(15  , 240, imageView.frame.size.width, imageView.frame.size.height);
        imageView = [gpsLights objectAtIndex:1];
        imageView.frame = CGRectMake(22  , 247, imageView.frame.size.width, imageView.frame.size.height);
        imageView = [gpsLights objectAtIndex:2];
        imageView.frame = CGRectMake(30  , 254, imageView.frame.size.width, imageView.frame.size.height);
        imageView = [gpsLights objectAtIndex:3];
        imageView.frame = CGRectMake(39  , 261, imageView.frame.size.width, imageView.frame.size.height);
        imageView = [gpsLights objectAtIndex:4];
        imageView.frame = CGRectMake(48  , 268, imageView.frame.size.width, imageView.frame.size.height);

        
        [self setSpeed:0 animate:NO];
        [self setCiferblatMode:CF_CAR];
        [self setGpsStrength:0];
    }
    return self;
}


-(void) setGpsStrength:(NSInteger) strength {
    for(int i = 0 ; i < 5; ++i) {
        UIImageView * gpsLight = [gpsLights objectAtIndex:i];
        if(i < strength) {
            [gpsLight setImage:[UIImage imageNamed:@"gpsYellow.png"]];
        } else {
            [gpsLight setImage:[UIImage imageNamed:@"gpslight.png"]];
        }
    }
}
-(void) setCiferblatMode:(CiferblatMode)mode {
    ciferblatMode = mode;
    if(mode == CF_CAR) {
        bikeKMHScaleImageView.hidden = YES;
        bikeMPHScaleImageView.hidden = YES;
        
        carKMHScaleImageView.hidden = ![self isKmhUnit];
        carMPHScaleImageView.hidden = [self isKmhUnit];
    } else {
        carKMHScaleImageView.hidden = YES;
        carMPHScaleImageView.hidden = YES;
        
        bikeKMHScaleImageView.hidden = ![self isKmhUnit];
        bikeMPHScaleImageView.hidden = [self isKmhUnit];;
    }
}

-(void) createOrUpdateButtonsOnSuperview:(CGRect) frame {
    UIImage * mphButtonImage = [UIImage imageNamed:@"mph.png"];
    if(mphButton == nil) {
        mphButton = [[UIButton alloc] init];
        [mphButton setBackgroundImage:mphButtonImage forState:UIControlStateNormal];
        [mphButton setBackgroundImage:[UIImage imageNamed:@"mphPush.png"] forState:UIControlStateSelected];
        [mphButton addTarget:self action:@selector(changeSpeedTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.superview addSubview:mphButton];
    }
    mphButton.frame = CGRectMake(190 + frame.origin.x, 224 + frame.origin.y, mphButtonImage.size.width, mphButtonImage.size.height);
    
    
    UIImage * kmhButtonImage = [UIImage imageNamed:@"kmh.png"];
    if(kmhButton == nil) {
        kmhButton = [[UIButton alloc] init];
        [kmhButton setBackgroundImage:kmhButtonImage forState:UIControlStateNormal];
        [kmhButton setBackgroundImage:[UIImage imageNamed:@"kmhPush.png"] forState:UIControlStateSelected];
        [kmhButton addTarget:self action:@selector(changeSpeedTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self changeSpeedTypeButtonAction:kmhButton];
        [self.superview addSubview:kmhButton];
    }
    kmhButton.frame = CGRectMake(235 + frame.origin.x, 173 + frame.origin.y, kmhButtonImage.size.width, kmhButtonImage.size.height);
}

-(void) rotateIt:(float)angl animate:(BOOL) animate
{
    if(animate) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0f];
    }
	
	[needleImageView setTransform: CGAffineTransformMakeRotation((M_PI / 180) *angl)];
	
    if(animate) {
        [UIView commitAnimations];
    }
}

-(void) changeSpeedTypeButtonAction:(UIButton *) button {
    kmhButton.selected = (button == kmhButton);
    mphButton.selected = !kmhButton.selected;
    
    if(ciferblatMode == CF_CAR) {
        carKMHScaleImageView.hidden = !kmhButton.selected;
        carMPHScaleImageView.hidden = !mphButton.selected;
    } else {
        bikeKMHScaleImageView.hidden = !kmhButton.selected;
        bikeMPHScaleImageView.hidden = !mphButton.selected;
    }
    
    if(kmhButton.selected) {
        typeLabel.text = @"KM/H";
    } else {
        typeLabel.text = @"MPH";
    }
}

-(BOOL) isKmhUnit {
    return kmhButton.selected;
}


-(double) calculateAngleFromSpeed:(double ) speed {
    float angle = ZERO_ANGLE_OFFSET_IPHONE_ARROW;
    
    if ([self isKmhUnit] ) {
        if(ciferblatMode == CF_CAR) {
            angle = ZERO_ANGLE_OFFSET_IPHONE_ARROW + (speed - CAR_KM_START_SPEED ) * CAR_KM_TO_ANGLE;
        } else {
            angle = ZERO_ANGLE_OFFSET_IPHONE_ARROW + (speed - BIKE_KM_START_SPEED ) * BIKE_KM_TO_ANGLE;
        }
    }else {
        if(ciferblatMode == CF_CAR) {
            angle = ZERO_ANGLE_OFFSET_IPHONE_ARROW + (speed - CAR_MIL_START_SPEED )* CAR_MIL_TO_ANGLE;
        } else {
            angle = ZERO_ANGLE_OFFSET_IPHONE_ARROW + (speed - BIKE_MIL_START_SPEED )* BIKE_MIL_TO_ANGLE;
        }
    }
    
    if(angle < ZERO_ANGLE_OFFSET_IPHONE_ARROW) return ZERO_ANGLE_OFFSET_IPHONE_ARROW;
    if(angle > MAX_ANGLE_OFFSET_IPHONE_ARROW) return MAX_ANGLE_OFFSET_IPHONE_ARROW;
    
    return angle;
}

-(void) setSpeed:(double) speed animate:(BOOL) animate{
    
    double realSpeed = [self isKmhUnit] ? [Converter mpsToKmh:speed] : [Converter mpsToMph:speed];
    [self setRealSpeed:realSpeed animate:animate];
}

-(void) setDirectionDegree:(double) degree {
    directionLabel.text = [NSString stringWithFormat:@"%@ %.f", [Converter headingSymbol:degree], degree];
}

-(void) setRealSpeed:(double) realSpeed animate:(BOOL) animate{
    speedLabel.text = [NSString stringWithFormat:@"%.1f",realSpeed];
    [self rotateIt:[self calculateAngleFromSpeed:realSpeed] animate:animate];
}

-(NSString *) getDirectionString {
    return directionLabel.text ;
}

-(NSString *) getSpeedString {
    return speedLabel.text ;
}

-(void) dealloc {
    [carKMHScaleImageView release];
    [carMPHScaleImageView release];
    [bikeKMHScaleImageView release];
    [bikeMPHScaleImageView release];
    [mphButton release];
    [kmhButton release];
    [gpsLights release];
    [typeLabel release];
    [speedLabel release];
    [directionLabel release];
    [needleImageView release];
    [super dealloc];
}
@end

