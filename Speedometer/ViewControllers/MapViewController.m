//
//  MapViewController.m
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/25/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import "MapViewController.h"
#import "MailBuilder.h"
#import "LocationProvider.h"
#import "Annotation.h"



#define LEFT_MARGIN 10
#define SPACE_WIDTH 36
#define TOP_MARGIN 8
#define BOTTOM_MARGIN 2

@interface MapViewController () {
    double  spaceWidthLandscape;
}
@end

@implementation MapViewController
@synthesize delegate;
@synthesize longitudeLabel;
@synthesize latitudeLabel;
@synthesize speedValue;
@synthesize directionLabel;
@synthesize directionValue;
@synthesize mapView;

-(id) init {
    self = [super init];
    if(self) {
        spaceWidthLandscape = 8;
        if  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
             ([UIScreen mainScreen].bounds.size.height > 480.0f)) {
            spaceWidthLandscape = 30;
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    
    bottomBar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mapButtomImage.png"]];
    bottomBar.userInteractionEnabled = YES;
    bottomBar.frame = CGRectMake(0, self.view.frame.size.height - bottomBar.frame.size.height, self.view.frame.size.width, bottomBar.frame.size.height);
    bottomBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:bottomBar];

	// Do any additional setup after loading the view.
    mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - bottomBar.frame.size.height)];
    
    mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [mapView setShowsUserLocation:YES];
    [self.view addSubview:mapView];
    
    NSString * strImageName = @"back.png";
    if (appDelegate->m_Lang == LNG_FR) {
        strImageName = [NSString stringWithFormat:@"fr_%@", strImageName];
    }
    UIImage * backButtonImage = [UIImage imageNamed:strImageName];
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, backButtonImage.size.width, backButtonImage.size.height)];
    [backButton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

    strImageName = @"share.png";
    if (appDelegate->m_Lang == LNG_FR) {
        strImageName = [NSString stringWithFormat:@"fr_%@", strImageName];
    }
    UIImage * shareButtonImage = [UIImage imageNamed:strImageName];
    shareButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, shareButtonImage.size.width, shareButtonImage.size.height)];
    [shareButton setBackgroundImage:shareButtonImage forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:shareButton];

    strImageName = @"standard.png";
    if (appDelegate->m_Lang == LNG_FR) {
        strImageName = [NSString stringWithFormat:@"fr_%@", strImageName];
    }
    UIImage * mapTypeButtonImage = [UIImage imageNamed:strImageName];
    mapTypeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, mapTypeButtonImage.size.width, mapTypeButtonImage.size.height)];
    [mapTypeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [mapTypeButton setBackgroundImage:mapTypeButtonImage forState:UIControlStateNormal];
    [mapTypeButton addTarget:self action:@selector(mapTypeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBar addSubview:mapTypeButton];

    
    strImageName = @"trackOff.png";
    if (appDelegate->m_Lang == LNG_FR) {
        strImageName = [NSString stringWithFormat:@"fr_%@", strImageName];
    }
    UIImage * trackButtonImage = [UIImage imageNamed:strImageName];
    trackButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, trackButtonImage.size.width, trackButtonImage.size.height)];
    [trackButton setBackgroundImage:trackButtonImage forState:UIControlStateNormal];
    strImageName = @"trackOn.png";
    if (appDelegate->m_Lang == LNG_FR) {
        strImageName = [NSString stringWithFormat:@"fr_%@", strImageName];
    }
    [trackButton setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateSelected];
    [trackButton addTarget:self action:@selector(trackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    trackButton.selected = YES;
    [bottomBar addSubview:trackButton];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnMap:)];
    tapGesture.numberOfTapsRequired = 2;
    tapGesture.delegate = self;
    [mapView addGestureRecognizer:tapGesture];
    [tapGesture release];
    
    [self willRotateToInterfaceOrientation:self.interfaceOrientation duration:0];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

-(void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [mapView release];
    mapView = nil;
    [bottomBar release];
    bottomBar = nil;
    [backButton release];
    backButton = nil;
    [shareButton release];
    shareButton = nil;
    [mapTypeButton release];
    mapTypeButton = nil;
    [mapTypeButton release];
    mapTypeButton = nil;
    [trackButton release];
    trackButton = nil;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void) shareButtonAction {
    [delegate mapViewControllerShareButtonDidPressed:mapView];
}


-(void) mapTypeButtonAction:(UIButton *) button {

    if(mapView.mapType == MKMapTypeStandard) {
        NSString * strImageName = @"satellite.png";
        if (appDelegate->m_Lang == LNG_FR) {
            strImageName = [NSString stringWithFormat:@"fr_%@", strImageName];
        }
        [button setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
        mapView.mapType = MKMapTypeHybrid;
    } else if(mapView.mapType == MKMapTypeHybrid) {
        NSString * strImageName = @"standard.png";
        if (appDelegate->m_Lang == LNG_FR) {
            strImageName = [NSString stringWithFormat:@"fr_%@", strImageName];
        }
        [button setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
        mapView.mapType = MKMapTypeSatellite;
    } else {
        NSString * strImageName = @"hybrid.png";
        if (appDelegate->m_Lang == LNG_FR) {
            strImageName = [NSString stringWithFormat:@"fr_%@", strImageName];
        }
        [button setBackgroundImage:[UIImage imageNamed:strImageName] forState:UIControlStateNormal];
        mapView.mapType = MKMapTypeStandard;
    }
}

-(void) trackButtonAction {
    trackButton.selected = !trackButton.selected;
}

-(void) viewWillLayoutSubviews {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        mapView.frame = CGRectMake(0, 0, mapView.frame.size.width, self.view.frame.size.height - bottomBar.frame.size.height);
        [bottomBar setImage:[UIImage imageNamed:@"mapButtomImageLand.png"]];
        backButton.frame = CGRectMake(5, 5, backButton.frame.size.width, backButton.frame.size.height);
        shareButton.frame = CGRectMake(LEFT_MARGIN + 45 , TOP_MARGIN, shareButton.frame.size.width, shareButton.frame.size.height);
        mapTypeButton.frame = CGRectMake(shareButton.frame.size.width + shareButton.frame.origin.x + 2*SPACE_WIDTH,TOP_MARGIN, mapTypeButton.frame.size.width, mapTypeButton.frame.size.height);
        trackButton.frame = CGRectMake(2*SPACE_WIDTH + mapTypeButton.frame.origin.x + mapTypeButton.frame.size.width, TOP_MARGIN, trackButton.frame.size.width, trackButton.frame.size.height);
    } else {
        mapView.frame = CGRectMake(0, 0, mapView.frame.size.width, self.view.frame.size.height - bottomBar.frame.size.height);        
        [bottomBar setImage:[UIImage imageNamed:@"mapButtomImage.png"]];

        backButton.frame = CGRectMake(5, 5, backButton.frame.size.width, backButton.frame.size.height);
        shareButton.frame = CGRectMake(LEFT_MARGIN, TOP_MARGIN, shareButton.frame.size.width, shareButton.frame.size.height);
        mapTypeButton.frame = CGRectMake(shareButton.frame.size.width + shareButton.frame.origin.x + SPACE_WIDTH, TOP_MARGIN, mapTypeButton.frame.size.width, mapTypeButton.frame.size.height);
        trackButton.frame = CGRectMake(SPACE_WIDTH + mapTypeButton.frame.origin.x + mapTypeButton.frame.size.width, TOP_MARGIN, trackButton.frame.size.width, trackButton.frame.size.height);
    }
}

-(void) restartButtonAction {
    [delegate mapViewControllerRestartDidPressed];
}

-(void) backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL) isTrackingEnabled {
    return trackButton.selected;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void) dealloc {
    
    [directionLabel release];
    [directionValue release];
    [speedLabel release];
    [speedValue release];
    [longitudeLabel release];
    [latitudeLabel release];
    [mapView release];
    [super dealloc];
}

@end
