//
//  UIColor+BYHexColor.m
//  BYGPS
//
//  Created by miwer on 16/7/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "UIColor+BYHexColor.h"

@implementation UIColor (BYHexColor)

+ (UIColor *)colorWithHex:(NSString *)hex
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hex];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                           green:((rgbValue & 0xFF00) >> 8) / 255.0
                            blue:(rgbValue & 0xFF) / 255.0
                           alpha:1.0];
}

@end
