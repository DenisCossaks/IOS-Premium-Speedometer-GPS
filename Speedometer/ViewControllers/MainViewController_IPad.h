//
//  MainViewController_IPad.h
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 04/20/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MainViewController.h"

@interface MainViewController_IPad : MainViewController<UIGestureRecognizerDelegate> {

    MKMapView * mapView;
    UIButton * shareButton;
    UIButton * mapTypeButton;
    UIButton * refreshButton;
    UIButton * trackButton;
}

@end
