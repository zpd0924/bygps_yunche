//
//  BYUploadCurrentVersion.m
//  BYGPS
//
//  Created by miwer on 2017/1/20.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYUploadCurrentVersion.h"

@implementation BYUploadCurrentVersion

+(NSString *)versionResult{
    
    NSMutableArray * tempArr = [NSMutableArray arrayWithArray:[BYLocalVersion componentsSeparatedByString:@"."]];
    [tempArr removeObject:[tempArr lastObject]];
    [tempArr addObject:@"0"];
    NSString * versionStr = [tempArr componentsJoinedByString:@"."];
    
    NSString * pointTimeStr = @"2017-01-22 09:00:00";
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * pointDate = [formatter dateFromString:pointTimeStr];
    
    return [[NSDate date] compare:pointDate] == NSOrderedAscending ? @"2.5" : versionStr;
}


@end
