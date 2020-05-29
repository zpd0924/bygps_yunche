//
//  UIButton+BYScaleButton.m
//  BYGPS
//
//  Created by miwer on 16/8/24.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "UIButton+BYScaleButton.h"
#import <objc/runtime.h>

@implementation UIButton (BYScaleButton)

+ (void)load{
    Method tmp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method by_tmp = class_getInstanceMethod([self class], @selector(by_initWithCoder:));
    method_exchangeImplementations(tmp, by_tmp);
}

- (id)by_initWithCoder:(NSCoder*)aDecode{
    [self by_initWithCoder:aDecode];
    if (self) {
        if(self.tag != 250 && self.tag != 251){
            CGFloat fontSize = self.titleLabel.font.pointSize;
            self.titleLabel.font = [UIFont systemFontOfSize:fontSize * BYScale];
        }
    }
    return self;
}

@end
