//
//  MainViewController_IPad.m
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 04/20/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import "MainViewController_IPad.h"
#import "SpeedometerImageView.h"
#import "MailBuilder.h"
#import "LocationProvider.h"
#import "Annotation.h"

@interface MainViewController_IPad ()

@end

@implementation MainViewController_IPad


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    map.selected = YES;
    map.enabled = NO;
    mapView = [[MKMapView alloc] init];
    mapView.delegate = self;
    [mapView setShowsUserLocation:YES];
    [self.view addSubview:mapView];
    [self creatLables];
    [self createButtons];
    [self crateGestureRecognizers];
    
    UIImage * backgroundImage = [UIImage imageNamed:@"BGPortImage.png"];
    [bgroundImgView setImage:backgroundImage];
    bgroundImgView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
    
    mapView.frame = CGRectMake(bgroundImgView.frame.origin.x + bgroundImgView.frame.size.width, 0, self.view.frame.size.width - bgroundImgView.frame.size.width, self.view.frame.size.height);
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    bgroundImgView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);

    bgSpeedImageView.frame = CGRectMake(3, 310, 320, 314);
    speedometerImageView.frame = CGRectMake(14,14, speedometerImageView.frame.size.width, speedometerImageView.frame.size.height);
    
    [speedometerImageView createOrUpdateButtonsOnSuperview:speedometerImageView.frame];
    
    [self createSpeedButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [mapView release];
    mapView = nil;
    [shareButton release];
    shareButton = nil;
    [mapTypeButton release];
    mapTypeButton = nil;
    [refreshButton release];
    refreshButton = nil;
    [trackButton release];
    trackButton = nil;
}

-(void) creatLables {
    
    labelStartTime.frame = CGRectMake(0, 130 , 140, 20);
    labelStartTime.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    
    valueStartTime.font = [UIFont fontWithName:@"Digital-7" size:36];
    valueStartTime.frame = CGRectMake(0, labelStartTime.frame.origin.y  + 20 , 130, 30);
    
    labelTimeElapsed.frame = CGRectMake(0, labelStartTime.frame.origin.y + 60 , 140, 20);
    labelTimeElapsed.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    
    valueTimeElapsed.font = [UIFont fontWithName:@"Digital-7" size:36];
    valueTimeElapsed.frame = CGRectMake(0, labelTimeElapsed.frame.origin.y  + 20 , 130, 30);
    
    labelDistance.frame = CGRectMake(0, labelTimeElapsed.frame.origin.y + 60 , 140, 20);
    labelDistance.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    
    valueDistance.font = [UIFont fontWithName:@"Digital-7" size:36];
    valueDistance.frame = CGRectMake(0, labelDistance.frame.origin.y  + 20 , 140, 30);
    
    labelAvgSpeed.frame = CGRectMake(180, 130 , 140, 20);
    labelAvgSpeed.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    
    valueAvgSpeed.font = [UIFont fontWithName:@"Digital-7" size:36];
    valueAvgSpeed.frame = CGRectMake(180, labelAvgSpeed.frame.origin.y  + 20 , 140, 30);
    
    labelMaxSpeed.frame = CGRectMake(180, labelStartTime.frame.origin.y + 60 , 140, 20);
    labelMaxSpeed.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    
    valueMaxSpeed.font = [UIFont fontWithName:@"Digital-7" size:36];
    valueMaxSpeed.frame = CGRectMake(180, labelMaxSpeed.frame.origin.y  + 20 , 140, 30);
    
    labelAltitude.frame = CGRectMake(180, labelTimeElapsed.frame.origin.y + 60 , 140, 20);
    labelAltitude.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    
    valueAltitude.font = [UIFont fontWithName:@"Digital-7" size:36];
    valueAltitude.frame = CGRectMake(180, labelAltitude.frame.origin.y  + 20 , 140, 30);
}

-(void) createButtons {
    UIImage * shareButtonImage = [UIImage imageNamed:@"share.png"];
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake(1, 30, shareButtonImage.size.width, shareButtonImage.size.height)];
    [shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
    UIImage * mapTypeButtonImage = [UIImage imageNamed:@"standard.png"];
    mapTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(shareButton.frame.size.width + 7, 30, shareButtonImage.size.width, shareButtonImage.size.height)];
    [mapTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mapTypeButton setBackgroundImage:mapTypeButtonImage forState:UIControlStateNormal];
    [mapTypeButton addTarget:self action:@selector(mapTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    mapTypeButton.selected = YES;
    [self.view addSubview:mapTypeButton];
    
    UIImage * trackButtonImage = [UIImage imageNamed:@"trackOff.png"];
    trackButton = [[UIButton alloc] initWithFrame:CGRectMake(mapTypeButton.frame.origin.x + mapTypeButton.frame.size.width + 7, 30, trackButtonImage.size.width, trackButtonImage.size.height)];
    [trackButton setBackgroundImage:trackButtonImage forState:UIControlStateNormal];
    [trackButton setBackgroundImage:[UIImage imageNamed:@"trackOn.png"] forState:UIControlStateSelected];
    [trackButton addTarget:self action:@selector(trackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    trackButton.selected = YES;
    [self.view addSubview:trackButton];
}

-(void) createSpeedButtons {
    UIImage * bicycleButtonImage = [UIImage imageNamed:@"BycPort.png"];
    [bicycle setBackgroundImage:bicycleButtonImage forState:UIControlStateNormal];
    bicycle.frame = CGRectMake(6, bgroundImgView.frame.size.height -bicycleButtonImage.size.height - 6 , bicycleButtonImage.size.width, bicycleButtonImage.size.height);
    [bicycle addTarget:self action:@selector(bicycleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bicycle setBackgroundImage:[UIImage imageNamed:@"BycPortPush.png"] forState:UIControlStateSelected];

    
    UIImage * carButtonImage = [UIImage imageNamed:@"carIpad.png"];
    [car setBackgroundImage:carButtonImage forState:UIControlStateNormal];
    car.frame = CGRectMake(bgroundImgView.frame.size.width - 6 - carButtonImage.size.width, bgroundImgView.frame.size.height -carButtonImage.size.height - 6,  carButtonImage.size.width, carButtonImage.size.height);
    [car addTarget:self action:@selector(carButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [car setBackgroundImage:[UIImage imageNamed:@"carIpadPush.png"] forState:UIControlStateSelected];

    
    UIImage * goButtonImage = [UIImage imageNamed:@"goPort.png"];
    [goButton setBackgroundImage:goButtonImage forState:UIControlStateNormal];
    [goButton setBackgroundImage:[UIImage imageNamed:@"goPortPush.png"] forState:UIControlStateHighlighted];
    goButton.frame = CGRectMake(carButtonImage.size.width + 1.5, bgroundImgView.frame.size.height -goButtonImage.size.height - 6, goButtonImage.size.width, goButtonImage.size.height);
    
    UIImage * pauseButtonImage = [UIImage imageNamed:@"PausePort.png"];
    [pause setBackgroundImage:pauseButtonImage forState:UIControlStateNormal];
    [pause setBackgroundImage:[UIImage imageNamed:@"PausePortPush.png"] forState:UIControlStateHighlighted];
    pause.frame = CGRectMake(car.frame.size.width + 1.5,bgroundImgView.frame.size.height -pauseButtonImage.size.height - 6, pauseButtonImage.size.width, pauseButtonImage.size.height);

    restart.frame = CGRectMake(270, 250, 44, 44);
}


-(void) mapTypeButtonAction:(UIButton *) button {
    if(mapView.mapType == MKMapTypeStandard) {
        [button setBackgroundImage:[UIImage imageNamed:@"satellite.png"] forState:UIControlStateNormal];
        mapView.mapType = MKMapTypeHybrid;
    } else if(mapView.mapType == MKMapTypeHybrid) {
        [button setBackgroundImage:[UIImage imageNamed:@"standard.png"] forState:UIControlStateNormal];
        mapView.mapType = MKMapTypeSatellite;
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"hybrid.png"] forState:UIControlStateNormal];
        mapView.mapType = MKMapTypeStandard;
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

-(void) shareButtonAction {
    [self openMailComposer:mapView];
}

-(void) trackButtonAction {
    trackButton.selected = !trackButton.selected;
}

-(void) crateGestureRecognizers {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMap:)];
    tapGesture.numberOfTapsRequired = 2;
    tapGesture.delegate = self;
    [mapView addGestureRecognizer:tapGesture];
    [tapGesture release];
}

-(MKMapView *) getMapView {
    return mapView;
}

-(BOOL) isTrackingEnabled {
    return trackButton.selected;
}

- (void)updatedLocationInfoReceived:(ProviderInfo)info
{
    [super updatedLocationInfoReceived:info];
}

-(void) dealloc {
    [mapView release];
    [shareButton release];
    [mapTypeButton release];
    [refreshButton release];
    [trackButton release];
    [super dealloc];
}


@end
