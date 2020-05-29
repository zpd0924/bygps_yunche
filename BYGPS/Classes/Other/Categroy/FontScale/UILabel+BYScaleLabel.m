//
//  UILabel+BYScaleLabel.m
//  BYGPS
//
//  Created by miwer on 16/8/24.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "UILabel+BYScaleLabel.h"
#import <objc/runtime.h>

@implementation UILabel (BYScaleLabel)

+ (void)load{
    
    Method tmp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method by_tmp = class_getInstanceMethod([self class], @selector(by_initWithCoder:));
    method_exchangeImplementations(tmp, by_tmp);
    
}

- (id)by_initWithCoder:(NSCoder*)aDecode{
    [self by_initWithCoder:aDecode];
    if (self) {
        //部分不像改变字体的 把tag值设置成252跳过
        if(self.tag != 252){
            CGFloat fontSize = self.font.pointSize;
            self.font = [UIFont systemFontOfSize:fontSize * BYScale];
        }
    }
    return self;
}

@end
