//
//  Annotation.h
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/25/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinates_;
}

@property (nonatomic) CLLocationCoordinate2D coordinates;

-(id)initWithCoordinates:(CLLocationCoordinate2D)coords;



@end
