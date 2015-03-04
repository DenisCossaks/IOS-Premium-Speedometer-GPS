//
//  MapViewController.h
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/14/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

#import "AppDelegate.h"


@protocol MapViewControllerDelegate <NSObject>

-(void) mapViewControllerShareButtonDidPressed:(UIView *) mapView;
-(void) mapViewControllerRestartDidPressed;

@end

@interface MapViewController : UIViewController <UIGestureRecognizerDelegate> {
    
    id<MapViewControllerDelegate> delegate;
    MKMapView * mapView ;
    UIImageView * bottomBar;

    UIButton * backButton;
    UIButton * shareButton;
    UIButton * mapTypeButton;
    UIButton * trackButton;
    
    UILabel * speedLabel;
    UILabel * speedValue;
    UILabel * directionValue;
    UILabel * directionLabel;
    
    AppDelegate * appDelegate;
}

@property (nonatomic,assign) id<MapViewControllerDelegate> delegate;
@property (nonatomic,retain) UILabel * longitudeLabel;
@property (nonatomic,retain) UILabel * latitudeLabel;
@property (nonatomic,retain) UILabel * directionLabel;
@property (nonatomic,retain) UILabel * directionValue;
@property (nonatomic,retain) UILabel * speedValue;
@property (nonatomic,retain) MKMapView * mapView;



-(BOOL) isTrackingEnabled;

@end
