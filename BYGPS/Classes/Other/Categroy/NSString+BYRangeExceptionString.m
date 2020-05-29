//
//  NSString+BYRangeExceptionString.m
//  BYGPS
//
//  Created by 李志军 on 2019/3/26.
//  Copyright © 2019 miwer. All rights reserved.
//

#import "NSString+BYRangeExceptionString.h"
#import <objc/message.h>
@implementation NSString (BYRangeExceptionString)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"__NSCFString");
        Method oldMethod1 = class_getInstanceMethod(class, @selector(substringFromIndex:));
        Method newMethod1 = class_getInstanceMethod(class, @selector(li_substringFromIndex:));
        if (oldMethod1 && newMethod1) {
            method_exchangeImplementations(oldMethod1, newMethod1);
        }
        
        Method oldMethod2 = class_getInstanceMethod(class, @selector(substringToIndex:));
        Method newMethod2 = class_getInstanceMethod(class, @selector(li_substringToIndex:));
        if (oldMethod2 && newMethod2) {
            method_exchangeImplementations(oldMethod2, newMethod2);
        }
        
    });
}

- (NSString *)li_substringFromIndex:(NSUInteger)from{
    if (self.length<from) {
        BYLog(@"字符串substringFromIndex方法越界");
        return self;
    }else{
        return [self li_substringFromIndex:from];
    }
}

- (NSString *)li_substringToIndex:(NSUInteger)to{
    if (self.length <to) {
        BYLog(@"字符串substringToIndex方法越界");
        return self;
    }else{
        return [self li_substringToIndex:to];
    }
}

@end
