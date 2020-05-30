//
//  BYDateFormtterTool.m
//  BYGPS
//
//  Created by miwer on 16/9/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDateFormtterTool.h"

@implementation BYDateFormtterTool


+(NSString *)getResultDateStrWithMS:(double)ms formatStr:(BYDateFormatType)dateFormatType
{
    NSDate * nowDate = [NSDate date];
    
    //    NSTimeInterval oneDay = 24 * 60 * 60 * 1;  //1天的长度
    //    NSDate * lastDate = [nowDate initWithTimeIntervalSinceNow:- oneDay * days ];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:ms/1000];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    //    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    //    [formatter setTimeZone:timeZone];
    NSString * formatStr = nil;
    switch (dateFormatType) {
        case BYDateFormatNormalType:
            formatStr = @"yyyy-MM-dd HH:mm:ss";
            break;
        case BYDateFormatMorningType:
            formatStr = @"yyyy-MM-dd 00:00:00";
            break;
        case BYDateFormatNightType:
            formatStr = @"yyyy-MM-dd 23:59:59";
        case BYDateFormatSimpleType:
            formatStr = @"yyyy年MM月dd日";
        default:
            break;
    }
    
    [formatter setDateFormat:formatStr];
    NSString * resultDate = [formatter stringFromDate:lastDate];
    
    return resultDate;
}

+ (NSString *)getResultDateStr:(NSInteger)days formatStr:(BYDateFormatType)dateFormatType{//根据天数推断出前几天的日期
    
    NSDate * nowDate = [NSDate date];
    
    NSTimeInterval oneDay = 24 * 60 * 60 * 1;  //1天的长度
    NSDate * lastDate = [nowDate initWithTimeIntervalSinceNow:- oneDay * days ];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    NSString * formatStr = nil;
    switch (dateFormatType) {
        case BYDateFormatNormalType:
            formatStr = @"yyyy-MM-dd HH:mm:ss";
            break;
        case BYDateFormatMorningType:
            formatStr = @"yyyy-MM-dd 00:00:00";
            break;
        case BYDateFormatNightType:
            formatStr = @"yyyy-MM-dd 23:59:59";
        default:
            break;
    }
    
    [formatter setDateFormat:formatStr];
    NSString * resultDate = [formatter stringFromDate:lastDate];
    
    return resultDate;
}


-(NSString *)getNowDate:(NSDate *)date isToday:(BOOL)isToday{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    if (isToday) {
        [formatter setDateFormat:@"yyyy/MM/dd 00:00:00"];
    }else{
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    }
    NSString * resultDate = [formatter stringFromDate:date];
    
    return resultDate;
}

+(NSDate *)formatterToDateWith:(NSString *)dateStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * date = [formatter dateFromString:dateStr];
    return date;
}

+(NSString *)formatterToString:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
}

+(NSDateComponents *)currentDateComponents:(NSDate *)date
{
    // 日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 想比较哪些元素
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    // 比较
    return [calendar components:unit fromDate:date];
}
#pragma mark - 获取当前时间的 时间戳
+(double)getNowTimestamp{
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间
    
    
    
    NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    
    //时间转时间戳的方法:
    double timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] doubleValue];
    
    
    
    NSLog(@"设备当前的时间戳:%ld",(long)timeSp); //时间戳的值
    
    
    
    return timeSp;
    
}

/*
 *  计算当前日期 距离date相差几天
    date:传入日期
 */

+(NSInteger)getDiffDayWithDate:(NSString *)dateStr{
    if (!dateStr.length)
        return 0;
    dateStr = [NSString stringWithFormat:@"%@ 23:59:59",dateStr];
    double timeSp = [BYDateFormtterTool getNowTimestamp];
    NSDate *date = [BYDateFormtterTool formatterToDateWith:dateStr];
     double timeSp1 = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] doubleValue];
    if (timeSp1 >= timeSp) {
        return (int)((timeSp1 - timeSp)/60/60/24)+1;
    }else{
        return 0;
    }
    
}


@end
