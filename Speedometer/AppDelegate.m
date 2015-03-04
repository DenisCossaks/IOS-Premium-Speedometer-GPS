//
//  AppDelegate.m
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 03/10/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationProvider.h"

#import <RevMobAds/RevMobAds.h>


@implementation UINavigationController (iOS6OrientationFix)

-(NSUInteger) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [RevMobAds startSessionWithAppID:@"528ea284a017fd718f000020"];
//    [RevMobAds session].testingMode = RevMobAdsTestingModeWithAds;
    
    // Override point for customization after application launch.
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    locationProvider = [[LocationProvider alloc] init];
    UINavigationController * navigationController = (UINavigationController *)self.window.rootViewController;
    [locationProvider registerForLocationUpdate:[navigationController.viewControllers objectAtIndex:0] ];
    [locationProvider start];
    
    // Get Language of device
    m_Lang = LNG_EN;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray *preferredLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString *preferredLanguageCode = [preferredLanguages objectAtIndex:0]; //preferred device language code
//    NSLocale *enLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en"]; //language name will be in English (or whatever)
//    NSString *languageName = [enLocale displayNameForKey:NSLocaleIdentifier value:preferredLanguageCode]; //name of language, eg. "French"
    
    NSLog(@"Language = %@", preferredLanguageCode);
    
    if ([preferredLanguageCode isEqualToString:@"fr"]) {
        m_Lang = LNG_FR;
    }
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[RevMobAds session] showFullscreen];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
