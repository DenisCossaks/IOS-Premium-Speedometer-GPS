//
//  MailBuilder.m
//  Speedometer GPS
//
//  Created by Chika Hiraoka on 05/10/13.
//  Copyright (c) 2013 Chika Hiraoka. All rights reserved.
//

#import "MailBuilder.h"
#import <QuartzCore/QuartzCore.h>


@implementation MailBuilder

+(void) openMailComposerForTarget:(UIViewController *) target delegate:(id<MFMailComposeViewControllerDelegate>) delegate mapView:(UIView *) mapView  elapsed:(NSString *) elapsedValue distance:(NSString*) distance maxSpeed:(NSString *) mapxSpeed{
    UIGraphicsBeginImageContext(mapView.frame.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [mapView.layer renderInContext:ctx];
    
    UIImage *mapImage = UIGraphicsGetImageFromCurrentImageContext();
    NSData *mapImageData = UIImageJPEGRepresentation(mapImage, 0.2);
    
    UIGraphicsEndImageContext();
    
    MFMailComposeViewController *mailView = [[[MFMailComposeViewController alloc] init] autorelease];
    
    mailView.mailComposeDelegate  = delegate;
    mailView.navigationController.title = @"Speedometer";
    
    [mailView setSubject:@"Speedometer"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    [formatter setDateFormat:@"dd.mm.yyyy_hh:mm:ss a"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSArray *components = [date componentsSeparatedByString:@"_"];
    
    NSString *mailBody = @"";
    if (components != nil && [components count] == 2) {
        mailBody = [mailBody stringByAppendingFormat:@"<span style='background:#e9e9e9'>Saved %@&nbsp;&nbsp;&nbsp;&nbsp;%@&nbsp;</span><br>",
                    [components objectAtIndex:0], [components objectAtIndex:1]];
    }
    components = [elapsedValue componentsSeparatedByString:@":"];
    
    mailBody = [mailBody stringByAppendingFormat:@"<span style='background:#dcdcdc'>Elapsed Time <span style='color:#00687'>%@h</span> <span style='color:#00687'>%@m</span> <span style='color:#00687'>%@s</span>&nbsp;&nbsp;&nbsp; Distance <span style='color:#00687'>%@</span>&nbsp;&nbsp;&nbsp;Max speed <span style='color:#00687'>%@</span></span><br>", [components objectAtIndex:0], [components objectAtIndex:1], [components objectAtIndex:2], distance, mapxSpeed];
    [mailView setMessageBody:mailBody isHTML:YES];
    
    if (mapImageData != nil && [mapImageData isKindOfClass:[NSData class]]) {
        [mailView addAttachmentData:mapImageData mimeType:@"image/jpeg" fileName:@"map.jpeg"];
    }
    
    if (mailView) {
        [target presentModalViewController:mailView animated:YES];
    }
}
@end
