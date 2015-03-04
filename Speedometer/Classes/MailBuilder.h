//
//  MailBuilder.h
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 05/10/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface MailBuilder : NSObject {
    
}

+(void) openMailComposerForTarget:(UIViewController *) target delegate:(id<MFMailComposeViewControllerDelegate>) delegate mapView:(UIView *) mapView  elapsed:(NSString *) elapsedValue distance:(NSString*) distance maxSpeed:(NSString *) maxSpeed;
@end
