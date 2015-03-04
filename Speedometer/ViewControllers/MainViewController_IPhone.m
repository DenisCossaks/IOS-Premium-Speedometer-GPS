//
//  MainViewController_IPhone.m
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/14/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import "MainViewController_IPhone.h"
#import "LocationProvider.h"
#import "SpeedometerImageView.h"
#import "Converter.h"

@interface MainViewController_IPhone ()

@end

@implementation MainViewController_IPhone

-(void) awakeFromNib {
    [super awakeFromNib];
    mapViewController = [[MapViewController alloc] init];
    mapViewController.delegate = self;
    mapViewController.mapView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [bicycle addTarget:self action:@selector(carBicycleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [car addTarget:self action:@selector(carBicycleButtonAction) forControlEvents:UIControlEventTouchUpInside];

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) mapButtonAction {
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (void)updatedCompassInfoReceived:(ProviderInfo)info
{
    [super updatedCompassInfoReceived:info];
    double degree = info.compassInfo_.trueHeading;
    mapViewController.directionLabel.text = [NSString stringWithFormat:@"%@", [Converter headingSymbol:degree]];
    mapViewController.directionValue.text = [NSString stringWithFormat:@"%.f", degree];
}

- (void)updatedLocationInfoReceived:(ProviderInfo)info
{   
    LocationInfo * lInfo_ = info.locationInfo_;
    if (lInfo_.speed < 0 || lInfo_.latitude == -1 || lInfo_.longitude == -1) {
        return;
    }
    [super updatedLocationInfoReceived:info];
    // Update latitude, longitude labels
    [mapViewController.latitudeLabel setText:[NSString stringWithFormat:@"LAT: %@", [LocationProvider convertLatitudeToDMS:lInfo_.latitude]]];
    [mapViewController.longitudeLabel setText:[NSString stringWithFormat:@"LON: %@", [LocationProvider convertLongitudeToDMS:lInfo_.longitude]]];
    [mapViewController.speedValue setText:[speedometerImageView getSpeedString]];
}

-(void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        UIImage * backgroundImage = [UIImage imageNamed:@"BGLandImage.png"];
        [bgroundImgView setImage:backgroundImage];
        bgroundImgView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        
        UIImage *rigthImage = [UIImage imageNamed:@"RigthImage.png"];
        UIImageView *rigthImageView = [[UIImageView alloc] initWithImage:rigthImage];
        
        [speedometerImageView createOrUpdateButtonsOnSuperview:speedometerImageView.frame];
        
        UIImage * bicycleButtonImage = [UIImage imageNamed:@"bycLand.png"];
        [bicycle setBackgroundImage:bicycleButtonImage forState:UIControlStateNormal];
        
        UIImage * carButtonImage = [UIImage imageNamed:@"carLand.png"];
        [car setBackgroundImage:carButtonImage forState:UIControlStateNormal];
        
        UIImage * goButtonImage = [UIImage imageNamed:@"goLand.png"];
        [goButton setBackgroundImage:goButtonImage forState:UIControlStateNormal];
        [goButton setBackgroundImage:[UIImage imageNamed:@"goLandPush.png"] forState:UIControlStateHighlighted];
        
        UIImage * pauseButtonImage = [UIImage imageNamed:@"pauseLand.png"];
        [pause setBackgroundImage:pauseButtonImage forState:UIControlStateNormal];
        [pause setBackgroundImage:[UIImage imageNamed:@"pauseLandPush.png"] forState:UIControlStateHighlighted];
        
        UIImage * mapButtonImage = [UIImage imageNamed:@"mapLand.png"];
        [map setBackgroundImage:mapButtonImage forState:UIControlStateNormal];
        [map setBackgroundImage:[UIImage imageNamed:@"mapLlandPush.png"] forState:UIControlStateHighlighted];
        
        bicycle.frame = CGRectMake(backgroundImage.size.width - bicycleButtonImage.size.width - 6, backgroundImage.size.height - bicycleButtonImage.size.height - 6 , bicycleButtonImage.size.width, bicycleButtonImage.size.height);
        car.frame =  CGRectMake(backgroundImage.size.width - carButtonImage.size.width - 6, backgroundImage.size.height - bicycleButtonImage.size.height - 6 , carButtonImage.size.width, carButtonImage.size.height);
        goButton.frame = CGRectMake(bgroundImgView.frame.size.width - goButtonImage.size.width - 6, car.frame.size.height -2, goButtonImage.size.width, goButtonImage.size.height);
        pause.frame = CGRectMake(bgroundImgView.frame.size.width - pauseButtonImage.size.width - 6, car.frame.size.height - 2, pauseButtonImage.size.width, pauseButtonImage.size.height);
        map.frame = CGRectMake(bgroundImgView.frame.size.width - mapButtonImage.size.width - 6,  6 , mapButtonImage.size.width, mapButtonImage.size.height);
        
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            btnMenuBgImageView.frame = CGRectMake(bgroundImgView.frame.size.width - 100,0, 100,320);
            bgSpeedImageView.frame = CGRectMake(151.5, 4.5, 320, 314);
            speedometerImageView.frame = CGRectMake(14,14, speedometerImageView.frame.size.width, speedometerImageView.frame.size.height);
            rigthImageView.frame = CGRectMake(471, 182.5, 27, 124);
            restart.frame = CGRectMake(270, 250, 44, 44);
            [self setFrameForLanscapeIphone5Labals];
        } else {
            btnMenuBgImageView.frame = CGRectMake(bgroundImgView.frame.size.width - 100,0, 100,320);
            bgSpeedImageView.frame = CGRectMake(63.5, 4.5, 320, 314);
            speedometerImageView.frame = CGRectMake(14,14, speedometerImageView.frame.size.width, speedometerImageView.frame.size.height);
            rigthImageView.frame = CGRectMake(383, 182.5, 27, 124);
            restart.frame = CGRectMake(270, 250, 44, 44);
            [self setFrameForLanscapeIphone4Labals];
        }
        [self.view addSubview:rigthImageView];
        [rigthImageView release];
    } else {
        UIImage * backgroundImage = [UIImage imageNamed:@"BGPortImage.png"];
        [bgroundImgView setImage:backgroundImage];
        bgroundImgView.frame = CGRectMake(0, 0, backgroundImage.size.width, backgroundImage.size.height);
        
        UIImage * bicycleButtonImage = [UIImage imageNamed:@"BycPort.png"];
        [bicycle setBackgroundImage:bicycleButtonImage forState:UIControlStateNormal];
        
        UIImage * carButtonImage = [UIImage imageNamed:@"carPort.png"];
        [car setBackgroundImage:carButtonImage forState:UIControlStateNormal];
        
        UIImage * goButtonImage = [UIImage imageNamed:@"goPort.png"];
        [goButton setBackgroundImage:goButtonImage forState:UIControlStateNormal];
        [goButton setBackgroundImage:[UIImage imageNamed:@"goPortPush.png"] forState:UIControlStateHighlighted];
        
        UIImage * pauseButtonImage = [UIImage imageNamed:@"PausePort.png"];
        [pause setBackgroundImage:pauseButtonImage forState:UIControlStateNormal];
        [pause setBackgroundImage:[UIImage imageNamed:@"PausePortPush.png"] forState:UIControlStateHighlighted];
        
        UIImage * mapButtonImage = [UIImage imageNamed:@"mapPort.png"];
        [map setBackgroundImage:mapButtonImage forState:UIControlStateNormal];
        [map setBackgroundImage:[UIImage imageNamed:@"mapPortPush.png"] forState:UIControlStateHighlighted];
        
        bicycle.frame = CGRectMake(6, backgroundImage.size.height -bicycleButtonImage.size.height - 6 , bicycleButtonImage.size.width, bicycleButtonImage.size.height);
        car.frame =  CGRectMake(6, backgroundImage.size.height -carButtonImage.size.height - 6, carButtonImage.size.width, carButtonImage.size.height);
        goButton.frame = CGRectMake(carButtonImage.size.width + 1.5, backgroundImage.size.height -goButtonImage.size.height - 6, goButtonImage.size.width, goButtonImage.size.height);
        pause.frame = CGRectMake(car.frame.size.width + 1.5,backgroundImage.size.height -pauseButtonImage.size.height - 6, pauseButtonImage.size.width, pauseButtonImage.size.height);
        
        map.frame = CGRectMake(backgroundImage.size.width - 6 - mapButtonImage.size.width, backgroundImage.size.height -mapButtonImage.size.height - 6, carButtonImage.size.width, carButtonImage.size.height);
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
        if ([UIScreen mainScreen].scale == 2.f && screenHeight == 568.0f) {
            bgSpeedImageView.frame = CGRectMake(0, 155, 320, 314);
            speedometerImageView.frame = CGRectMake(14.5,14, speedometerImageView.frame.size.width, speedometerImageView.frame.size.height);
            [speedometerImageView createOrUpdateButtonsOnSuperview:speedometerImageView.frame];
            [self setFrameForPortrtaitIphone5Labals];
            restart.frame = CGRectMake(270, 250, 44, 44);
            
        } else {
            bgSpeedImageView.frame = CGRectMake(0, 79.5, 320, 314);
            speedometerImageView.frame = CGRectMake(14.5,14, speedometerImageView.frame.size.width, speedometerImageView.frame.size.height);
            [speedometerImageView createOrUpdateButtonsOnSuperview:speedometerImageView.frame];
            [self setFrameForPortrtaitIphone4Labals];
            restart.frame = CGRectMake(270, 250, 44, 44);
        }
    }
}

-(void) setFrameForPortrtaitIphone5Labals {
    labelStartTime.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueStartTime.font = [UIFont fontWithName:@"Digital-7" size:32];
    labelTimeElapsed.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueTimeElapsed.font = [UIFont fontWithName:@"Digital-7" size:32];
    labelDistance.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueDistance.font = [UIFont fontWithName:@"Digital-7" size:32];
    labelAvgSpeed.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueAvgSpeed.font = [UIFont fontWithName:@"Digital-7" size:32];
    labelMaxSpeed.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueMaxSpeed.font = [UIFont fontWithName:@"Digital-7" size:32];
    labelAltitude.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueAltitude.font = [UIFont fontWithName:@"Digital-7" size:32];
    labelStartTime.frame = CGRectMake(0, 10 , 150, 20);
    valueStartTime.frame = CGRectMake(0, labelStartTime.frame.origin.y  + 20 , 150, 30);
    
    labelTimeElapsed.frame = CGRectMake(0, labelStartTime.frame.origin.y + spaceHeightLandscape , 150, 20);
    valueTimeElapsed.frame = CGRectMake(0, labelTimeElapsed.frame.origin.y  + 20 , 150, 30);
    labelDistance.frame = CGRectMake(0, labelTimeElapsed.frame.origin.y + spaceHeightLandscape , 150, 20);
    valueDistance.frame = CGRectMake(0, labelDistance.frame.origin.y  + 20 , 150, 30);
    labelAvgSpeed.frame = CGRectMake(180, 10 , 140, 20);
    valueAvgSpeed.frame = CGRectMake(180, labelAvgSpeed.frame.origin.y  + 20 , 140, 30);
    labelMaxSpeed.frame = CGRectMake(180, labelStartTime.frame.origin.y + spaceHeightLandscape , 140, 20);
    valueMaxSpeed.frame = CGRectMake(180, labelMaxSpeed.frame.origin.y  + 20 , 140, 30);
    labelAltitude.frame = CGRectMake(180, labelTimeElapsed.frame.origin.y + spaceHeightLandscape , 140, 20);
    valueAltitude.frame = CGRectMake(180, labelAltitude.frame.origin.y  + 20 , 140, 30);
}

-(void) setFrameForPortrtaitIphone4Labals {
    labelStartTime.frame = CGRectMake(0, 2 , 100, 20);
    valueStartTime.frame = CGRectMake(0, labelStartTime.frame.origin.y  + 12 , 100, 30);
    labelTimeElapsed.frame = CGRectMake(0, labelStartTime.frame.origin.y + spaceHeightLandscape , 100, 20);
    valueTimeElapsed.frame = CGRectMake(0, labelTimeElapsed.frame.origin.y  + 12 , 100, 30);
    labelAvgSpeed.frame = CGRectMake(95, 2 , 140, 20);
    valueAvgSpeed.frame = CGRectMake(95, labelAvgSpeed.frame.origin.y  + 12 , 140, 30);
    labelMaxSpeed.frame = CGRectMake(95, labelStartTime.frame.origin.y + spaceHeightLandscape , 140, 20);
    valueMaxSpeed.frame = CGRectMake(95, labelMaxSpeed.frame.origin.y  + 12 , 140, 30);
    labelDistance.frame = CGRectMake(220, 2 , 100, 20);
    valueDistance.frame = CGRectMake(220, labelDistance.frame.origin.y  + 12 , 100, 30);
    labelAltitude.frame = CGRectMake(220, labelDistance.frame.origin.y + spaceHeightLandscape , 100, 20);
    valueAltitude.frame = CGRectMake(220, labelAltitude.frame.origin.y  + 12 , 100, 30);
}

-(void) setFrameForLanscapeIphone5Labals {
    labelStartTime.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueStartTime.font = [UIFont fontWithName:@"Digital-7" size:32];
    labelTimeElapsed.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueTimeElapsed.font = [UIFont fontWithName:@"Digital-7" size:32];
    labelDistance.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueDistance.font = [UIFont fontWithName:@"Digital-7" size:32];
    labelAvgSpeed.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueAvgSpeed.font = [UIFont fontWithName:@"Digital-7" size:32];
    labelMaxSpeed.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueMaxSpeed.font = [UIFont fontWithName:@"Digital-7" size:32];
    labelAltitude.font = [UIFont fontWithName:@"Arial-BoldMT" size:12];
    valueAltitude.font = [UIFont fontWithName:@"Digital-7" size:32];
    
    labelStartTime.frame = CGRectMake(0, 10 , 150, 20);
    valueStartTime.frame = CGRectMake(0, labelStartTime.frame.origin.y  + 20 , 150, 30);
    labelTimeElapsed.frame = CGRectMake(0, labelStartTime.frame.origin.y + spaceHeightLandscape , 150, 20);
    valueTimeElapsed.frame = CGRectMake(0, labelTimeElapsed.frame.origin.y  + 20 , 150, 30);
    labelAvgSpeed.frame = CGRectMake(0, labelTimeElapsed.frame.origin.y + spaceHeightLandscape , 140, 20);
    valueAvgSpeed.frame = CGRectMake(0, labelAvgSpeed.frame.origin.y  + 20 , 140, 30);
    labelMaxSpeed.frame = CGRectMake(0, labelAvgSpeed.frame.origin.y + spaceHeightLandscape , 140, 20);
    valueMaxSpeed.frame = CGRectMake(0, labelMaxSpeed.frame.origin.y  + 20 , 140, 30);
    labelDistance.frame = CGRectMake(0, labelMaxSpeed.frame.origin.y + spaceHeightLandscape , 150, 20);
    valueDistance.frame = CGRectMake(0, labelDistance.frame.origin.y  + 20 , 150, 30);
    labelAltitude.frame = CGRectMake(0, labelDistance.frame.origin.y + spaceHeightLandscape , 140, 20);
    valueAltitude.frame = CGRectMake(0, labelAltitude.frame.origin.y  + 20 , 145, 30);
}

-(void) setFrameForLanscapeIphone4Labals {
    labelStartTime.frame = CGRectMake(0, 0 , 0, 0);
    valueStartTime.frame = CGRectMake(0, 0 , 0, 0);
    labelTimeElapsed.frame = CGRectMake(0, 0 , 0, 0);
    valueTimeElapsed.frame = CGRectMake(0, 0 , 0, 0);
    labelAvgSpeed.frame = CGRectMake(0, 0 , 0, 0);
    valueAvgSpeed.frame = CGRectMake(0, 0 , 0, 0);
    labelMaxSpeed.frame = CGRectMake(0, 0 , 0, 0);
    valueMaxSpeed.frame = CGRectMake(0, 0 , 0, 0);
    labelDistance.frame = CGRectMake(0, 0 , 0, 0);
    valueDistance.frame = CGRectMake(0, 0 , 0, 0);
    labelAltitude.frame = CGRectMake(0, 0 , 0, 0);
    valueAltitude.frame = CGRectMake(0, 0 , 0, 0);
}

- (void) creatCarAndbicycleButtons {
    bicycle = [[UIButton alloc] init];
    [bicycle addTarget:self action:@selector(carBicycleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgroundImgView addSubview:bicycle];
    
    car = [[UIButton alloc] init];
    car.selected = YES;
    [car addTarget:self action:@selector(carBicycleButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bgroundImgView addSubview:car];
}

-(MKMapView *) getMapView {
    return mapViewController.mapView;
}
-(BOOL) isTrackingEnabled {
    return [mapViewController isTrackingEnabled];
}

-(void) dealloc {
    [mapViewController release];
    [super dealloc];
}
@end
