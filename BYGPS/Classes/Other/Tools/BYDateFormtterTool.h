//
//  BYDateFormtterTool.h
//  BYGPS
//
//  Created by miwer on 16/9/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYDateFormtterTool : NSObject

typedef enum {
    
    BYDateFormatNormalType,
    BYDateFormatMorningType,
    BYDateFormatNightType,
    BYDateFormatSimpleType
    
}BYDateFormatType;

+ (NSString *)getResultDateStr:(NSInteger)days formatStr:(BYDateFormatType)dateFormatType;

+(NSDate *)formatterToDateWith:(NSString *)dateStr;

+(NSString *)formatterToString:(NSDate *)date;

+(NSDateComponents *)currentDateComponents:(NSDate *)date;
+(NSString *)getResultDateStrWithMS:(double)ms formatStr:(BYDateFormatType)dateFormatType;
+(double)getNowTimestamp;
/*
 *  计算当前日期 距离date相差几天
  date:传入日期
 */

+(NSInteger)getDiffDayWithDate:(NSString *)dateStr;
@end
