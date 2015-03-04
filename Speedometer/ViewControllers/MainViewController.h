//
//  MainViewController.h
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/14/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import <MessageUI/MessageUI.h>
#import "ProviderInfo.h"

@class SpeedometerImageView;
@class Annotation;
@interface MainViewController : UIViewController<MapViewControllerDelegate,MFMailComposeViewControllerDelegate,MKMapViewDelegate> {
//BG Image Views
    UIImageView * bgroundImgView;
    UIImageView * btnMenuBgImageView;
    UIImageView *bgSpeedImageView;
//Buttons
    UIButton * restart;
    UIButton * bicycle;
    UIButton * car;
    UIButton * map;
    UIButton * goButton;
    UIButton * pause;
//Lables and Values.
    UILabel * labelStartTime;
    UILabel * valueStartTime;
    UILabel * labelTimeElapsed;
    UILabel * valueTimeElapsed;
    UILabel * labelDistance;
    UILabel * valueDistance;
    UILabel * labelAvgSpeed;
    UILabel * valueAvgSpeed;
    UILabel * labelMaxSpeed;
    UILabel * valueMaxSpeed;
    UILabel * labelAltitude;
    UILabel * valueAltitude;
//All mambers
    double trackingDistance;
    double maxSpeed;
    NSTimer * updateDataTimer;
    NSTimeInterval pausedTime_;
    NSMutableArray * routePoints;
    MKPolyline * routeLine;
    MKMapRect routeRect;
    Annotation * annotation;
    SpeedometerImageView * speedometerImageView;
    double spaceHeightLandscape;
    double spaceWidthLandscape;
}

@property (nonatomic,retain) NSTimer * updateDataTimer;
@property (nonatomic,retain) MKPolyline * routeLine;
@property (nonatomic,assign) MKMapRect routeRect;


-(void) openMailComposer:(UIView *) mapView;
-(BOOL) isPlaying;
- (void)updatedLocationInfoReceived:(ProviderInfo) info;
- (void)updatedCompassInfoReceived:(ProviderInfo)info;


@end
