//
//  NSDate+BYDistanceDate.h
//  BYGPS
//
//  Created by miwer on 16/9/14.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BYDistanceDate)

- (NSDateComponents *)intervalToDate:(NSDate *)date;
- (NSDateComponents *)intervalToNow;

- (NSInteger)minIntervalFromLastDate:(NSDate *)lastDate;

- (NSInteger)secondIntervalFromLastDate;

/**
 * 是否为今年
 */
- (BOOL)isThisYear;

/**
 * 是否为今天
 */
- (BOOL)isToday;

/**
 * 是否为昨天
 */
- (BOOL)isYesterday;

- (BOOL)isThisMonth;

- (BOOL) isLaterThanDate: (NSDate *) aDate;

@end
