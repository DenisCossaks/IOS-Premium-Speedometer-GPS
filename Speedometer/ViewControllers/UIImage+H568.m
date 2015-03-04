//
//  UIImage+H568.m
//
//  Created by Angel Garcia on 9/28/12.
//  Copyright (c) 2012 angelolloqui.com. All rights reserved.
//

#import "UIImage+H568.h"
#import <objc/runtime.h>

@implementation UIImage (H568)


+ (void)load {
    if  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) &&
        ([UIScreen mainScreen].bounds.size.height > 480.0f)) {
        method_exchangeImplementations(class_getClassMethod(self, @selector(imageNamed:)),
                                       class_getClassMethod(self, @selector(imageNamedH568:)));
    }
}

+ (UIImage *)imageNamedH568:(NSString *)imageName {

    NSMutableString *imageNameMutable = [imageName mutableCopy];

    //Delete png extension
    NSRange extension = [imageName rangeOfString:@".png" options:NSBackwardsSearch | NSAnchoredSearch];
    if (extension.location != NSNotFound) {
        [imageNameMutable deleteCharactersInRange:extension];
    }

    NSRange retinaAtSymbol = [imageName rangeOfString:@"@2x"];
    if (retinaAtSymbol.location != NSNotFound) {
        [imageNameMutable insertString:@"-568h" atIndex:retinaAtSymbol.location];
    } else {
        [imageNameMutable appendString:@"-568h@2x"];
    }
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageNameMutable ofType:@"png"];
    if (imagePath) {
        //Remove the @2x to load with the correct scale 2.0
        [imageNameMutable replaceOccurrencesOfString:@"@2x" withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [imageNameMutable length])];
        return [UIImage imageNamedH568:imageNameMutable];
    } else {
        return [UIImage imageNamedH568:imageName];
    }
}

@end
