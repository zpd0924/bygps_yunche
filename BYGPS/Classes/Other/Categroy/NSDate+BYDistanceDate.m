//
//  NSDate+BYDistanceDate.m
//  BYGPS
//
//  Created by miwer on 16/9/14.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "NSDate+BYDistanceDate.h"

@implementation NSDate (BYDistanceDate)

//返回的是当前日期和传过来的日期时间差
- (NSInteger)secondIntervalFromLastDate{
    
    NSDateComponents * com = [self intervalToNow];
    return com.second + com.minute * 60 + com.hour * 60 * 60 + com.day * 24 * 60 * 60 + com.month * 30 * 24 * 60 * 60 + com.year * 365 * 24 * 60 * 60;
}

- (NSInteger)minIntervalFromLastDate:(NSDate *)lastDate{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 想比较哪些元素
    NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute;
    
    NSDateComponents * com = [calendar components:unit fromDate:lastDate toDate:self options:0];
    
    return com.hour * 60 + com.minute;
}

- (NSDateComponents *)intervalToDate:(NSDate *)date
{
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 想比较哪些元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 比较
    return [calendar components:unit fromDate:self toDate:date options:0];
}

- (NSDateComponents *)intervalToNow
{
    return [self intervalToDate:[NSDate date]];
}

/**
 * 是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 获得年
    NSInteger nowYear = [calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear = [calendar component:NSCalendarUnitYear fromDate:self];
    
    return nowYear == selfYear;
}

- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year
    && nowCmps.month == selfCmps.month
    && nowCmps.day == selfCmps.day;
}

/**
 * 是否为当前月
 */
- (BOOL)isYesterday
{
    // now : 2015-02-01 00:01:05 -->  2015-02-01
    // self : 2015-01-31 23:59:10 --> 2015-01-31
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 获得只有年月日的时间
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSString *selfString = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selfString];
    
    // 比较
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

- (BOOL)isThisMonth{//是否为当前月
    
    // now : 2015-02-01 00:01:05 -->  2015-02-01
    // self : 2015-01-31 23:59:10 --> 2015-01-31
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 获得只有年月日的时间
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSDate *nowDate = [fmt dateFromString:nowString];
    
    NSString *selfString = [fmt stringFromDate:self];
    NSDate *selfDate = [fmt dateFromString:selfString];
    
    // 比较
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0 && cmps.month == 0;
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
    return ([self compare:aDate] == NSOrderedDescending);
}

@end
