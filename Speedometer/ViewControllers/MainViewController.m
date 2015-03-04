//
//  MainViewController.m
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/14/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import "MainViewController.h"
#import "MapViewController.h"
#import "SpeedometerImageView.h"
#import "MailBuilder.h"
#import "LocationProvider.h"
#import "ProviderInfo.h"
#import "Converter.h"
#import "Annotation.h"
#import "UIImage+H568.h"

#define MIN_ZOOM_RECT_WIDTH 4000
#define MIN_ZOOM_RECT_HEIGHT 4000

@interface MainViewController ()


@end

@implementation MainViewController
@synthesize updateDataTimer;
@synthesize routeLine;
@synthesize routeRect;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
	// Do any additional setup after loading the view.
    
    bgroundImgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgroundImgView.userInteractionEnabled = YES;
    [self.view addSubview:bgroundImgView];
    
    btnMenuBgImageView = [[UIImageView alloc] init];
    [bgroundImgView addSubview:btnMenuBgImageView];
    
    speedometerImageView = [[SpeedometerImageView alloc] init];
    
    bgSpeedImageView = [[UIImageView alloc] init];
    [bgSpeedImageView setImage:[UIImage imageNamed:@"BGSpeed.png"]];
    [bgroundImgView addSubview:bgSpeedImageView];
    bgSpeedImageView.userInteractionEnabled = YES;
    [bgSpeedImageView addSubview:speedometerImageView];
    [bgroundImgView addSubview:bgSpeedImageView];
    [self createBattons];
    [self createLabls];
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

-(void) createBattons {

    
    bicycle = [[UIButton alloc] init];
    [bgroundImgView addSubview:bicycle];

    car = [[UIButton alloc] init];
    car.selected = YES;
    [bgroundImgView addSubview:car];
    
    map = [[UIButton alloc] init];
    [map addTarget:self action:@selector(mapButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgroundImgView addSubview:map];
    
    
    goButton = [[UIButton alloc] init];
    goButton.hidden = YES;
    [goButton addTarget:self action:@selector(goButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgroundImgView addSubview:goButton];
    
    pause = [[UIButton alloc] init];
    [pause addTarget:self action:@selector(pauseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgroundImgView addSubview:pause];
    
    restart = [[UIButton alloc] init];
    UIImage * restartButtonImage = [UIImage imageNamed:@"restart.png"];
    [restart setBackgroundImage:restartButtonImage forState:UIControlStateNormal];
    [restart setBackgroundImage:[UIImage imageNamed:@"restartPush.png"] forState:UIControlStateHighlighted];
    [restart addTarget:self action:@selector(restartButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgSpeedImageView addSubview:restart];
}

-(void) createLabls {
    labelStartTime = [[UILabel alloc] init];
    labelStartTime.text = _(@"START TIME");
    labelStartTime.font = [UIFont fontWithName:@"Arial-BoldMT" size:11];
    labelStartTime.textColor = [UIColor lightGrayColor];
    labelStartTime.textAlignment = UITextAlignmentCenter;
    labelStartTime.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:labelStartTime];
    
    valueStartTime = [[UILabel alloc] init];
    valueStartTime.text = @"00:00:00";
    valueStartTime.font = [UIFont fontWithName:@"Digital-7" size:25];
    valueStartTime.textColor = [UIColor lightGrayColor];
    valueStartTime.textAlignment = UITextAlignmentCenter;
    valueStartTime.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:valueStartTime];
    
    labelTimeElapsed = [[UILabel alloc] init];
    labelTimeElapsed.text = _(@"TIME ELAPSED");
    labelTimeElapsed.font = [UIFont fontWithName:@"Arial-BoldMT" size:11];
    labelTimeElapsed.textColor = [UIColor lightGrayColor];
    labelTimeElapsed.textAlignment = UITextAlignmentCenter;
    labelTimeElapsed.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:labelTimeElapsed];
    
    valueTimeElapsed = [[UILabel alloc] init];
    valueTimeElapsed.text = @"00:00:00";
    valueTimeElapsed.font = [UIFont fontWithName:@"Digital-7" size:25];
    valueTimeElapsed.textColor = [UIColor lightGrayColor];
    valueTimeElapsed.textAlignment = UITextAlignmentCenter;
    valueTimeElapsed.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:valueTimeElapsed];
    
    labelDistance = [[UILabel alloc] init];
    labelDistance.text = _(@"DISTANCE");
    labelDistance.font = [UIFont fontWithName:@"Arial-BoldMT" size:11];
    labelDistance.textColor = [UIColor lightGrayColor];
    labelDistance.textAlignment = UITextAlignmentCenter;
    labelDistance.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:labelDistance];
    
    valueDistance = [[UILabel alloc] init];
    valueDistance.text = @"0.0 KM";
    valueDistance.font = [UIFont fontWithName:@"Digital-7" size:25];
    valueDistance.textColor = [UIColor lightGrayColor];
    valueDistance.textAlignment = UITextAlignmentCenter;
    valueDistance.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:valueDistance];
    
    labelAvgSpeed = [[UILabel alloc] init];
    labelAvgSpeed.text = _(@"AVG SPEED");
    labelAvgSpeed.font = [UIFont fontWithName:@"Arial-BoldMT" size:11];
    labelAvgSpeed.textColor = [UIColor lightGrayColor];
    labelAvgSpeed.textAlignment = UITextAlignmentCenter;
    labelAvgSpeed.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:labelAvgSpeed];
    
    valueAvgSpeed = [[UILabel alloc] init];
    valueAvgSpeed.text = @"0.0 KM/H";
    valueAvgSpeed.font = [UIFont fontWithName:@"Digital-7" size:25];
    valueAvgSpeed.textColor = [UIColor lightGrayColor];
    valueAvgSpeed.textAlignment = UITextAlignmentCenter;
    valueAvgSpeed.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:valueAvgSpeed];
    
    labelMaxSpeed = [[UILabel alloc] init];
    labelMaxSpeed.text = _(@"MAX SPEED");
    labelMaxSpeed.font = [UIFont fontWithName:@"Arial-BoldMT" size:11];
    labelMaxSpeed.textColor = [UIColor lightGrayColor];
    labelMaxSpeed.textAlignment = UITextAlignmentCenter;
    labelMaxSpeed.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:labelMaxSpeed];
    
    valueMaxSpeed = [[UILabel alloc] init];
    valueMaxSpeed.text = @"0.0 KM/H";
    valueMaxSpeed.font = [UIFont fontWithName:@"Digital-7" size:25];
    valueMaxSpeed.textColor = [UIColor lightGrayColor];
    valueMaxSpeed.textAlignment = UITextAlignmentCenter;
    valueMaxSpeed.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:valueMaxSpeed];
    
    labelAltitude = [[UILabel alloc] init];
    labelAltitude.text = _(@"ALTITUDE");
    labelAltitude.font = [UIFont fontWithName:@"Arial-BoldMT" size:11];
    labelAltitude.textColor = [UIColor lightGrayColor];
    labelAltitude.textAlignment = UITextAlignmentCenter;
    labelAltitude.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:labelAltitude];
    
    valueAltitude = [[UILabel alloc] init];
    valueAltitude.text = @"00:00:00";
    valueAltitude.font = [UIFont fontWithName:@"Digital-7" size:25];
    valueAltitude.textColor = [UIColor lightGrayColor];
    valueAltitude.textAlignment = UITextAlignmentCenter;
    valueAltitude.backgroundColor = [UIColor clearColor];
    [bgroundImgView addSubview:valueAltitude];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [bgroundImgView release];
    bgroundImgView = nil;
    [btnMenuBgImageView release];
    btnMenuBgImageView = nil;
    [bgSpeedImageView release];
    bgSpeedImageView = nil;
    [restart release];
    restart = nil;
    [bicycle release];
    bicycle = nil;
    [car release];
    car = nil;
    [map release];
    map = nil;
    [goButton release];
    goButton = nil;
    [labelStartTime release];
    labelStartTime = nil;
    [valueStartTime release];
    valueStartTime = nil;
    [labelTimeElapsed release];
    labelTimeElapsed = nil;
    [valueTimeElapsed release];
    valueTimeElapsed = nil;
    [labelDistance release];
    labelDistance = nil;
    [valueDistance release];
    valueDistance = nil;
    [labelAvgSpeed release];
    labelAvgSpeed = nil;
    [valueDistance release];
    valueDistance = nil;
    [labelAvgSpeed release];
    labelAvgSpeed = nil;
    [valueAvgSpeed release];
    valueAvgSpeed = nil;
    [labelMaxSpeed release];
    labelMaxSpeed = nil;
    [labelMaxSpeed release];
    labelMaxSpeed = nil;
    [valueMaxSpeed release];
    valueMaxSpeed = nil;
    [labelAltitude release];
    labelAltitude = nil;
    [valueAltitude release];
    valueAltitude = nil;
    [speedometerImageView release];
    speedometerImageView = nil;
}

-(void) awakeFromNib {
    [super awakeFromNib];
    routePoints = [[NSMutableArray alloc] init];
    spaceWidthLandscape = 0.0;
    spaceHeightLandscape = 40;
    if  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
         ([UIScreen mainScreen].bounds.size.height > 480.0f)) {
        spaceWidthLandscape = 40;
        spaceHeightLandscape = 50;
    }
}

-(void) openMailComposer:(UIView *) mapView {
    [MailBuilder openMailComposerForTarget:self delegate:self mapView:mapView elapsed:valueTimeElapsed.text distance:valueDistance.text maxSpeed:valueMaxSpeed.text];
}

-(void) restartButtonAction {
    trackingDistance = 0;
    maxSpeed = 0;
    [Converter releaseDate];
    [speedometerImageView setSpeed:0 animate:NO];
    if (self.updateDataTimer != nil && [self.updateDataTimer isValid]) {
        [self.updateDataTimer invalidate];
    }
    self.updateDataTimer = nil;
    
    
    MKMapView * mapView = [self getMapView];
    if (annotation) {
        [mapView removeAnnotation:annotation];
        [annotation release];
        annotation = nil;
    }
    
    [Converter resetCutTime];
    pausedTime_ = 0;
    [self goButtonAction];
    
    if (self.routeLine) {
        [mapView removeOverlay:self.routeLine];
        self.routeLine = nil;
    }
    
    if (routePoints) {
        [routePoints removeAllObjects];
    }
}


-(void) mapViewControllerShareButtonDidPressed:(UIView *) mapView {
    [self openMailComposer:mapView];
}

-(void) mapViewControllerRestartDidPressed {
    [self restartButtonAction];
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissModalViewControllerAnimated:YES];
}

-(void) goButtonAction {
    pause.hidden = NO;
    goButton.hidden = YES;
    
    if (pausedTime_ > 0) {
        [Converter addCutTime:([[NSDate date] timeIntervalSince1970] - pausedTime_)];
    }
    pausedTime_ = 0;
    
}

-(void) pauseButtonAction {
    pause.hidden = YES;
    goButton.hidden = NO;
    
    pausedTime_ = [[NSDate date] timeIntervalSince1970];
}

-(void) carBicycleButtonAction {
    if (car.isSelected == YES) {
        car.selected = NO;
        bicycle.selected = YES;
        [speedometerImageView setCiferblatMode:CF_BIKE];
        [car setHidden:YES];
        [bicycle setHidden:NO];

    } else {
        car.selected = YES;
        bicycle.selected = NO;
        [speedometerImageView setCiferblatMode:CF_CAR];
        [car setHidden:NO];
        [bicycle setHidden:YES];
    }
}

-(void) bicycleButtonAction {
    car.selected = NO;
    bicycle.selected = YES;
    [speedometerImageView setCiferblatMode:CF_BIKE];
}

-(void) carButtonAction {
    car.selected = YES;
    bicycle.selected = NO;
    [speedometerImageView setCiferblatMode:CF_CAR];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
-(void) mapButtonAction {

}

- (void)updatedLocationInfoFailed
{
    [speedometerImageView setSpeed:0.0 animate:YES];
}

-(BOOL) isPlaying {
    return (goButton.hidden == YES);
}

- (void) updateDatas {
    
    if([self isPlaying]) {
        [valueStartTime setText:[Converter time24:[Converter startDate]]];
        [valueTimeElapsed setText:[Converter elapsedTime]];
    }
}


- (void)updateMapTracking:(LocationInfo *) lInfo
{
    // create our coordinate and add it to the correct spot in the array
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lInfo.latitude, lInfo.longitude);
    MKMapPoint point = MKMapPointForCoordinate(coordinate);
    NSValue * pointValue = [NSValue value:&point withObjCType:@encode(MKMapPoint)];
    if([routePoints count] > 0) {
        if(![pointValue isEqualToValue:[routePoints lastObject]]) {
            [routePoints addObject:pointValue];
        }
    } else {
        [routePoints addObject:pointValue];
    }
    
	MKMapPoint * pointArr = malloc(sizeof(CLLocationCoordinate2D) * routePoints.count);
    MKMapPoint northEastPoint = MKMapPointMake(0.0, 0.0);
    MKMapPoint southWestPoint = MKMapPointMake(0.0, 0.0);
    
    for (int i = 0; i < routePoints.count; ++i) {
        MKMapPoint p;
        [[routePoints objectAtIndex:i] getValue:&p];
        pointArr[i] = p;
        // if it is the first point, just use them, since we have nothing to compare to yet.
        if (i == 0) {
            northEastPoint = p;
            southWestPoint = p;
        }
        else
        {
            if (p.x > northEastPoint.x)
                northEastPoint.x = p.x;
            if (p.y > northEastPoint.y)
                northEastPoint.y = p.y;
            if (p.x < southWestPoint.x)
                southWestPoint.x = p.x;
            if (p.y < southWestPoint.y)
                southWestPoint.y = p.y;
        }
    }
    double width = northEastPoint.x - southWestPoint.x ;
    double height = northEastPoint.y - southWestPoint.y ;
    double originX = southWestPoint.x;
    double originY = southWestPoint.y;
    
    if(width < MIN_ZOOM_RECT_WIDTH) {
        width = MIN_ZOOM_RECT_WIDTH;
        originX -= MIN_ZOOM_RECT_WIDTH / 2.0;
    }
    
    if(height < MIN_ZOOM_RECT_HEIGHT) {
        height = MIN_ZOOM_RECT_HEIGHT;
        originY -= MIN_ZOOM_RECT_HEIGHT / 2.0;
    }
    
    routeRect = MKMapRectMake(originX, originY, width, height);
    

    // add the overlay to the map
    // create the polyline based on the array of points.
    MKPolyline * oldRouteLine = [self.routeLine retain];
	self.routeLine = [MKPolyline polylineWithPoints:pointArr count:routePoints.count];
    
    MKMapView * mapView = [self getMapView];
    [mapView addOverlay:self.routeLine];
    if (oldRouteLine != nil) {
        [mapView removeOverlay:oldRouteLine];
    }

    // Zoom to rect if tracking enabled
    if ([self isTrackingEnabled]) {
        if(!MKMapRectIsEmpty(routeRect)) {
            [mapView setVisibleMapRect:routeRect edgePadding:UIEdgeInsetsMake(50.0, 50.0, 50.0, 50.0) animated:YES];
        }
    }

    free(pointArr);

    if(annotation == nil) {
        annotation = [[Annotation alloc] initWithCoordinates:CLLocationCoordinate2DMake(lInfo.latitude, lInfo.longitude)];
    }
    
    if (mapView != nil && [mapView.annotations count] == 1) { //the first is user location
        [mapView addAnnotation:annotation];
    }
    
}

-(BOOL) isTrackingEnabled {
    return YES;
}

-(MKMapView *) getMapView {
    return nil;
}

- (void)updatedLocationInfoReceived:(ProviderInfo)info
{
     LocationInfo * lInfo_ = info.locationInfo_;
    
    if (lInfo_.speed < 0 || lInfo_.latitude == -1 || lInfo_.longitude == -1) {
        return;
    }
    
    if (!self.updateDataTimer) {
        self.updateDataTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateDatas) userInfo:nil repeats:YES];
    }
    [self updateLabels:lInfo_];
    [self updateMapTracking:lInfo_];
}



- (void)updateLabels:(LocationInfo*) linfo
{
    if ([self isPlaying]) {
        [speedometerImageView setSpeed:linfo.speed animate:YES];
        
        // Update max speed and distance
        trackingDistance += linfo.distance;
        if (maxSpeed < linfo.speed) {
            maxSpeed = linfo.speed;
        }
        
        float h = [Converter elapsedTimeHours];
        if ([speedometerImageView isKmhUnit])
        {
            double km = [Converter meterToKm:trackingDistance];
            double s = h == 0 ? 0 : km / h;
            
            [valueAvgSpeed setText:[NSString stringWithFormat:@"%.1f KM/H", s]];
            [valueDistance setText:[NSString stringWithFormat:@"%.2f KM", km]];
            [valueMaxSpeed setText:[NSString stringWithFormat:@"%.1f KM/H", [Converter mpsToKmh:maxSpeed]]];
            [valueAltitude setText:[NSString stringWithFormat:@"%.0f METER", linfo.altitude]];
        }
        else
        {
            double mil = [Converter meterToMiles:trackingDistance];
            double s = h == 0 ? 0 : mil / h;
            
            [valueAvgSpeed setText:[NSString stringWithFormat:@"%.1f MPH", s]];
            [valueDistance setText:[NSString stringWithFormat:@"%.2f MIL", [Converter meterToMiles:trackingDistance]]];
            [valueMaxSpeed setText:[NSString stringWithFormat:@"%.1f MPH", [Converter mpsToMph:maxSpeed]]];
            [valueAltitude setText:[NSString stringWithFormat:@"%.0f FEET", [Converter meterToFeet:linfo.altitude]]];
        }
    }

    NSUInteger signal = [Converter accuracyLevel:linfo.horizontalAccuracy];
    signal = (signal > MAX_GPS_STRENGTH ) ? MAX_GPS_STRENGTH : signal;
    [speedometerImageView setGpsStrength:signal];
    
}

- (void)updatedCompassInfoReceived:(ProviderInfo)info
{
    double degree = info.compassInfo_.trueHeading;
    [speedometerImageView setDirectionDegree:degree];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
	MKOverlayView* overlayView = nil;
	
	if([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineView * routeLineView = [[[MKPolylineView alloc] initWithPolyline:self.routeLine] autorelease];
        routeLineView.fillColor = [UIColor colorWithRed:0.0078f green:0.4039f blue:0.9686f alpha:1.0f];
        routeLineView.strokeColor = [UIColor colorWithRed:0.0078f green:0.4039f blue:0.9686f alpha:1.0f];
        routeLineView.lineWidth = 2;
		
		overlayView = routeLineView;
	}
    
	return overlayView;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView_ viewForAnnotation:(id <MKAnnotation>)newAnnotation
{
    if ([newAnnotation isKindOfClass:[Annotation class]])
    {
        static NSString* AnnotationIdentifier = @"AnnotationIdentifier";
        
        MKPinAnnotationView *annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:newAnnotation
                                                                               reuseIdentifier:AnnotationIdentifier] autorelease];
        annotationView.canShowCallout = YES;
        annotationView.animatesDrop = YES;
        
        return annotationView;
    }
    return nil;
}

-(void) dealloc {
    [bgroundImgView release];
    [btnMenuBgImageView release];
    [bgSpeedImageView release];
    [restart release];
    [bicycle release];
    [car release];
    [map release];
    [goButton release];
    [labelStartTime release];
    [valueStartTime release];
    [labelTimeElapsed release];
    [valueTimeElapsed release];
    [labelDistance release];
    [valueDistance release];
    [labelAvgSpeed release];
    [valueDistance release];
    [labelAvgSpeed release];
    [valueAvgSpeed release];
    [labelMaxSpeed release];
    [labelMaxSpeed release];
    [valueMaxSpeed release];
    [labelAltitude release];
    [valueAltitude release];
    [updateDataTimer release];
    [routeLine release];
    [annotation release];
    [routePoints release];
    [speedometerImageView release];
    [super dealloc];
}

@end
