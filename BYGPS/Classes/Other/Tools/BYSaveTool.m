//
//  BYSaveTool.m
//  BYGPS
//
//  Created by miwer on 16/7/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSaveTool.h"

@implementation BYSaveTool

+(void)setValue:(NSString *)value forKey:(NSString *)defaultName{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)setInteger:(NSInteger)value forKey:(NSString *)defaultName{
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(id)valueForKey:(NSString *)defaultName{
    return [[NSUserDefaults standardUserDefaults] valueForKey:defaultName];
}

+(NSInteger)integerForKey:(NSString *)defaultName{
    return [[NSUserDefaults standardUserDefaults] integerForKey:defaultName];
}

+(void)setBool:(BOOL)value forKey:(NSString *)defaultName{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)boolForKey:(NSString *)defaultName{
    return [[NSUserDefaults standardUserDefaults] boolForKey:defaultName];
}

+(void)removeObjectForKey:(NSString *)defaultKey{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:defaultKey];
}
+(id)objectForKey:(NSString *)defaultName{
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}
+(void)setObject:(id)object forKey:(NSString *)defaultName{
    [[NSUserDefaults standardUserDefaults] setObject:object forKey:defaultName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/** 是否打开了 */
+ (BOOL)isTurnOnSwitchByTitle:(NSString *)key{
    BOOL voice = NO;
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defs dictionaryRepresentation];
    if ([dic.allKeys containsObject:key]) {
        voice = [defs boolForKey:key];
    } else {
        voice = NO;
    }
    return voice;
}

/** 是否设置过 */
+ (BOOL)isContainsKey:(NSString *)key{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [defs dictionaryRepresentation];
    if ([dic.allKeys containsObject:key]) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)getRefreshDurationStrWithKey:(NSString *)defaultKey{
    
    NSString * durationStr = nil;
    if ([BYSaveTool isContainsKey:defaultKey]) {//判断是否存储过监控刷新时间
        
        NSInteger duration = [BYSaveTool integerForKey:defaultKey];//取出监控刷新时间
        if (duration < 60) {
            durationStr = [NSString stringWithFormat:@"%zd秒",duration];
        }else{
            durationStr = [NSString stringWithFormat:@"%zd分钟",duration / 60];
        }
    }else{
        durationStr = [defaultKey isEqualToString:BYTrackRefreshDuration] ? @"10秒" : @"30秒";//默认刷新时间
    }
    return durationStr;
}

+ (NSInteger)getRefreshDurationIntegerWithKey:(NSString *)defaultKey{
    
    NSInteger duration;
    if ([BYSaveTool isContainsKey:defaultKey]) {//判断是否存储过监控刷新时间
        
        duration = [BYSaveTool integerForKey:defaultKey];//取出监控刷新时间
    }else{
        duration = [defaultKey isEqualToString:BYTrackRefreshDuration] ? 10 : 30;//默认刷新时间
    }
    return duration;
}

@end
