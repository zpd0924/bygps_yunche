//
//  NSDictionary+Str.h
//  BYGPS
//
//  Created by ZPD on 2017/8/7.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Str)
//json字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

// 字典转json字符串方法

-(NSString *)convertToJsonData:(NSDictionary *)dict;

@end
