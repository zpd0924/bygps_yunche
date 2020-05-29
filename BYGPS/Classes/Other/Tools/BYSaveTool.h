//
//  BYSaveTool.h
//  BYGPS
//
//  Created by miwer on 16/7/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYSaveTool : NSObject

/** 设置字符串 */
+ (void)setValue:(NSString *)value forKey:(NSString *)defaultName;

/** 设置数字 */
+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;

/** 取出设置结果 */
+ (id)valueForKey:(NSString *)defaultName;

+(NSInteger)integerForKey:(NSString *)defaultName;


+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

+ (BOOL)boolForKey:(NSString *)defaultName;

+ (void)removeObjectForKey:(NSString *)defaultKey;

+ (BOOL)isTurnOnSwitchByTitle:(NSString *)key;

+ (BOOL)isContainsKey:(NSString *)key;

+ (NSString *)getRefreshDurationStrWithKey:(NSString *)defaultKey;//取出刷新时间间隔str

+ (NSInteger)getRefreshDurationIntegerWithKey:(NSString *)defaultKey;//取出刷新时间间隔integer

+(id)objectForKey:(NSString *)defaultName;
+(void)setObject:(id)object forKey:(NSString *)defaultName;
@end
