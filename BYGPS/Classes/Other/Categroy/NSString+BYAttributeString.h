//
//  NSString+BYAttributeString.h
//  BYGPS
//
//  Created by miwer on 2016/11/2.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BYAttributeString)

+(NSAttributedString *)attributeStringWith:(NSString *)str;

+(NSString *)stringConvertToJsonData:(NSDictionary *)dict;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

+ (NSArray *)stringToArrayWithJSONStr:(NSString *)jsonStr;


+(NSString *)toLower:(NSString *)str;//A-a

+(NSString *)toUpper:(NSString *)str;//a-A


+(NSString *)StringJudgeIsValid:(NSString *)car isValid:(BOOL)isvalid subIndex:(NSInteger)index;



@end
