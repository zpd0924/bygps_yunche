//
//  BYRegularTool.m
//  BYGPS
//
//  Created by miwer on 2017/2/21.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYRegularTool.h"

@implementation BYRegularTool

+ (BOOL)isAllNumWith:(NSString *)text{
    
    NSString * numRegular = @"[0-9]*";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numRegular];
    return [predicate evaluateWithObject:text];
}

//验证车牌和位数(车架号)
+(BOOL)validateCarNum:(NSString *)carNum letterNum:(NSInteger)letterNum{
    
    NSString * carRegular = [NSString stringWithFormat:@"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{%zd}[a-zA-Z_0-9_\u4e00-\u9fa5]$",letterNum];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegular];
    return [predicate evaluateWithObject:carNum];
}

//验证车牌和位数(车架号)
+(BOOL)validateVIN:(NSString *)VIN{
    
    NSString * VINRegular = @"^[a-zA-Z_0-9]{17}$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",VINRegular];
    return [predicate evaluateWithObject:VIN];
    
}
#pragma mark -- 正则匹配17位车架号
+ (BOOL) checkCheJiaNumber:(NSString *) CheJiaNumber{
    NSString *bankNum=@"^(\\d{17})$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",bankNum];
    BOOL isMatch = [pred evaluateWithObject:CheJiaNumber];
    return isMatch;
}


//六位车牌验证 @"^[\u4e00-\u9fa5]{1}[a-zA-Z]{1}[a-zA-Z_0-9]{4}[a-zA-Z_0-9_\u4e00-\u9fa5]$"

//判断是否为手机号
+ (BOOL)validatePhone:(NSString *)phone{
//    if (phone.length < 11)
//    {
//        return NO;
//    }else{
//
//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//
//        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[5-6])|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//
//        NSString *CT_NUM = @"^((133)|(153)|(177)|(173)|(18[0,1,9]))\\d{8}$";
//        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//        BOOL isMatch1 = [pred1 evaluateWithObject:phone];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//        BOOL isMatch2 = [pred2 evaluateWithObject:phone];
//        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//        BOOL isMatch3 = [pred3 evaluateWithObject:phone];
//
//        if (isMatch1 || isMatch2 || isMatch3) {
//            return YES;
//        }else{
//            return NO;
//        }
//    }
    if (phone.length == 11) {
        return YES;
    }else{
        return NO;
    }
}
///验证手机号是否合法
+ (BOOL)isValidPhone:(NSString *)phone{

//    NSString *regex = @"^1[3456789]\\d{9}$";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    return [emailTest evaluateWithObject:phone];

    if (phone.length == 11) {
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)test:(NSString *)phone{
    NSString *regex = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4,5}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:phone];
    
}

///验证输入的车牌号是否合法
+ (BOOL)isValidCarNum:(NSString *)carQ{
    NSString *regex = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领]{1}[A-Za-z]{1}[A-Za-z0-9]{1}[A-Za-z0-9]{0,5}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTest evaluateWithObject:carQ];
}
///是否是纯数字
+ (BOOL) deptNumInputShouldNumber:(NSString *)str
{
    if (str.length == 0) {
        return NO;
    }
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if ([pred evaluateWithObject:str]) {
        return YES;
    }
    return NO;
}


@end
