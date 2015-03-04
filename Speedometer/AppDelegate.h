//
//  AppDelegate.h
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/10/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _LANGUAGE {
    LNG_EN = 0,
    LNG_FR
} LANGUAGE;



@class LocationProvider;


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    LocationProvider * locationProvider;
    
@public
    LANGUAGE m_Lang;
}

@property (strong, nonatomic) UIWindow *window;

@end
