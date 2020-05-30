//
//  BYRegularTool.h
//  BYGPS
//
//  Created by miwer on 2017/2/21.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYRegularTool : NSObject

//验证车牌
+(BOOL)validateCarNum:(NSString *)carNum letterNum:(NSInteger)letterNum;
//验证车架号
+(BOOL)validateVIN:(NSString *)VIN;

+ (BOOL)isAllNumWith:(NSString *)text;

+ (BOOL)validatePhone:(NSString *)phone;
#pragma mark -- 正则匹配17位车架号
+ (BOOL) checkCheJiaNumber:(NSString *) CheJiaNumber;
///验证手机号是否合法
+ (BOOL)isValidPhone:(NSString *)phone;

///验证输入的车牌号是否合法
+ (BOOL)isValidCarNum:(NSString *)carQ;
///是否是纯数字
+ (BOOL) deptNumInputShouldNumber:(NSString *)str;
@end
