//
//  BYObjectTool.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/13.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYObjectTool.h"
#import "BYShareListModel.h"
#import "BYShareCommitParamModel.h"
#define AllLeters  @"ABCDEFGHIJKLMNOPQRSTUVWXYZ"
@implementation BYObjectTool
///改变字符串某个区域的字符的颜色和大小
+(NSMutableAttributedString *)setTextColor:(NSString *)labelStr FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:labelStr];
    if (![labelStr containsString:@"*"])
        return str;
    //设置字号
    [str addAttribute:NSFontAttributeName value:font range:range];
    //设置文字颜色
    [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
    
    return str;
}

///根据NSDate 获取时间年月日 时分秒字符创
+(NSString *)formatterSelectDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
}
///扫描选择车牌或vin
+(UIAlertController *)showScanAleartCarNumWith:(void(^)(void))CarNum vinNum:(void(^)(void))vinNum{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        

    }];
    
    
    
    UIAlertAction *carNumAciton = [UIAlertAction actionWithTitle:@"车牌号扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CarNum();
    }];
    
    
    
    UIAlertAction *vinNumAciton = [UIAlertAction actionWithTitle:@"车架号扫描" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        vinNum();
    }];
    if ([[[UIDevice currentDevice] systemVersion]integerValue] >=8.3) {
        [carNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [vinNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        
        
    }
    
    [alertVc addAction:cancle];
    
    [alertVc addAction:carNumAciton];
    
    [alertVc addAction:vinNumAciton];
    
    return alertVc;
}
///选择车牌号 车架号
+(UIAlertController *)showChangeCarNumberOrVinAleartCarNumWith:(void(^)(void))CarNumSelect vinNum:(void(^)(void))vinNumSelect{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
        
    }];
    
    
    
    UIAlertAction *carNumAciton = [UIAlertAction actionWithTitle:@"车牌号" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CarNumSelect();
    }];
    
    
    
    UIAlertAction *vinNumAciton = [UIAlertAction actionWithTitle:@"车架号" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        vinNumSelect();
    }];
    if ([[[UIDevice currentDevice] systemVersion]integerValue] >=8.3) {
        [carNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [vinNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        
        
    }
    
    [alertVc addAction:cancle];
    
    [alertVc addAction:carNumAciton];
    
    [alertVc addAction:vinNumAciton];
    
    return alertVc;
}
///选择车牌号 车架号 设备号
+(UIAlertController *)showChangeCarNumberOrVinOrSnAleartCarNumWith:(void(^)(void))CarNumSelect vinNum:(void(^)(void))vinNumSelect SnNum:(void(^)(void))snNumSelect{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
        
    }];
    
    
    
    UIAlertAction *carNumAciton = [UIAlertAction actionWithTitle:@"车牌号" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        CarNumSelect();
    }];
    
    
    
    UIAlertAction *vinNumAciton = [UIAlertAction actionWithTitle:@"车架号" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        vinNumSelect();
    }];
    UIAlertAction *snNumAciton = [UIAlertAction actionWithTitle:@"设备号" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        snNumSelect();
    }];
    if ([[[UIDevice currentDevice] systemVersion]integerValue] >=8.3) {
        [carNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [vinNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
         [snNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        
    }
    
    [alertVc addAction:cancle];
    
    [alertVc addAction:carNumAciton];
    
    [alertVc addAction:vinNumAciton];
    [alertVc addAction:snNumAciton];
    
    return alertVc;
}

///选择拆机原因 清贷拆机。关联错误。悔贷拆机
+(UIAlertController *)alertRemoveReasonWith:(void(^)(void))clearLoan wrongRelated:(void(^)(void))wrongRelated regretLoan:(void(^)(void))regretLoan{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
        
    }];
    
    
    
    UIAlertAction *carNumAciton = [UIAlertAction actionWithTitle:@"清贷拆机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        clearLoan();
    }];
    
    
    
    UIAlertAction *vinNumAciton = [UIAlertAction actionWithTitle:@"关联错误" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        wrongRelated();
    }];
    UIAlertAction *snNumAciton = [UIAlertAction actionWithTitle:@"悔贷拆机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        regretLoan();
    }];
    if ([[[UIDevice currentDevice] systemVersion]integerValue] >=8.3) {
        [carNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [vinNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [snNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        
    }
    
    [alertVc addAction:cancle];
    
    [alertVc addAction:carNumAciton];
    
    [alertVc addAction:vinNumAciton];
    [alertVc addAction:snNumAciton];
    
    return alertVc;
}

///选择检修原因 设备不上线 设备不定位 设备没电 其他
+(UIAlertController *)alertRepairReasonWith:(void(^)(void))noLine noLocate:(void(^)(void))noLocate noElectricity:(void(^)(void))noElectricity other:(void(^)(void))other{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
        
    }];
    
    
    
    UIAlertAction *carNumAciton = [UIAlertAction actionWithTitle:@"设备不上线" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        noLine();
    }];
    
    
    
    UIAlertAction *vinNumAciton = [UIAlertAction actionWithTitle:@"设备不定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        noLocate();
    }];
    UIAlertAction *snNumAciton = [UIAlertAction actionWithTitle:@"设备没电" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        noElectricity();
    }];
    
    UIAlertAction *otherAciton = [UIAlertAction actionWithTitle:@"其他" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        other();
    }];
    
    if ([[[UIDevice currentDevice] systemVersion]integerValue] >=8.3) {
        [carNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [vinNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [snNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [otherAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [cancle setValue:UIColorHexFromRGB(0x0fa9f5) forKey:@"titleTextColor"];
    }
    
    [alertVc addAction:cancle];
    
    [alertVc addAction:carNumAciton];
    
    [alertVc addAction:vinNumAciton];
    [alertVc addAction:snNumAciton];
    [alertVc addAction:otherAciton];
    
    return alertVc;
}


//1=设备已拆除，解除关联。2=设备未拆除，未解除关联。3=设备未拆除，强制解除关联。
+(UIAlertController *)alertRemoveConclutionWith:(void(^)(void))beenRemoved wrongRelated:(void(^)(void))noRemove regretLoan:(void(^)(void))noRemoveRelease{
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
        
    }];
    
    
    
    UIAlertAction *carNumAciton = [UIAlertAction actionWithTitle:@"设备已拆除，解除关联" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        beenRemoved();
    }];
    
    
    
    UIAlertAction *vinNumAciton = [UIAlertAction actionWithTitle:@"设备未拆除，未解除关联" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        noRemove();
    }];
    UIAlertAction *snNumAciton = [UIAlertAction actionWithTitle:@"设备未拆除，强制解除关联" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        noRemoveRelease();
    }];
    if ([[[UIDevice currentDevice] systemVersion]integerValue] >=8.3) {
        [carNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [vinNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [snNumAciton setValue:UIColorHexFromRGB(0x333333) forKey:@"titleTextColor"];
        [cancle setValue:UIColorHexFromRGB(0x0fa9f5) forKey:@"titleTextColor"];
        
    }
    
    [alertVc addAction:cancle];
    
    [alertVc addAction:carNumAciton];
    
    [alertVc addAction:vinNumAciton];
    [alertVc addAction:snNumAciton];
    
    return alertVc;
}


///判断联系人格式是否正确
+(BOOL)isContactsFormat:(NSString *)contacts{
    if (!contacts.length) {
        return NO;
    }
    NSArray *arr = [NSArray array];
    if ([contacts containsString:@"，"]) {
        arr = [contacts componentsSeparatedByString:@"，"];
    }else if([contacts containsString:@","]){
        arr = [contacts componentsSeparatedByString:@","];
    }else{
        return NO;
    }
    
    if (arr.count != 2) {
        return NO;
    }
    NSString *firstStr = arr.firstObject;
    if (firstStr.length > 30) {
        return NO;
    }
    NSString *secondStr = arr.lastObject;
    if (secondStr.length != 11) {
        return NO;
    }
    if (![BYObjectTool deptNumInputShouldNumber:secondStr]) {
        return NO;
    }
    return YES;
}

Boolean jh_pinyin_from_chinese(NSMutableString *string){
    return CFStringTransform((__bridge CFMutableStringRef)string, 0, kCFStringTransformMandarinLatin, NO);
}
Boolean jh_english_from_pinyin(NSMutableString *string){
    return CFStringTransform((__bridge CFMutableStringRef)string, 0, kCFStringTransformStripDiacritics, NO);
}
    ///汉子转拼音
+ (NSMutableString *)changeToPinYin:(NSMutableString*)str {
        
        jh_pinyin_from_chinese(str);
        jh_english_from_pinyin(str);
        return str;
}
///是否在26个字母内
+ (BOOL) isInLetter:(NSString*) firstLetter {
    if ([AllLeters containsString:firstLetter]) {
        return YES;
    }else {
        return NO;
    }
    
}
///富文本
+ (NSMutableAttributedString *)changeStrWittContext:(NSString *)context ChangeColorText:(NSString *)ColorStr WithColor:(id)ColorValue WithFont:(id)FontValue {
    if (context == nil || ColorStr == nil) {
        return nil;
    }
    NSMutableAttributedString* inputStr = [[NSMutableAttributedString alloc]initWithString:context];
    NSRange ColorRange = NSMakeRange([[inputStr string]rangeOfString:ColorStr options:NSBackwardsSearch].location, [[inputStr string]rangeOfString:ColorStr].length);
    
    [inputStr addAttributes:@{NSForegroundColorAttributeName:ColorValue,NSFontAttributeName:FontValue} range:ColorRange];

    return inputStr;
    
}

///富文本
+ (NSMutableAttributedString *)changeStrWittContext:(NSString *)context ChangeColorText:(NSString *)ColorStr ChangeColorText:(NSString *)ColorStr1 WithColor:(id)ColorValue WithFont:(id)FontValue {
    if (context == nil || ColorStr == nil || ColorStr1 == nil) {
        return nil;
    }
    NSMutableAttributedString* inputStr = [[NSMutableAttributedString alloc]initWithString:context];
    NSRange ColorRange = NSMakeRange([[inputStr string]rangeOfString:ColorStr options:NSBackwardsSearch].location, [[inputStr string]rangeOfString:ColorStr].length);
    
    NSRange ColorRange1 = NSMakeRange([[inputStr string]rangeOfString:ColorStr1 options:NSBackwardsSearch].location, [[inputStr string]rangeOfString:ColorStr1].length);
    
    [inputStr addAttributes:@{NSForegroundColorAttributeName:ColorValue,NSFontAttributeName:FontValue} range:ColorRange];
     [inputStr addAttributes:@{NSForegroundColorAttributeName:ColorValue,NSFontAttributeName:FontValue} range:ColorRange1];
    
    return inputStr;
    
}
///返回图片地址
+ (NSString *)imageStr:(NSString *)imageStr{
    if (imageStr.length == 0) {
        return @"nodata";
    }
    if ([imageStr containsString:@"http"]) {
        return imageStr;
    }
    return [NSString stringWithFormat:@"%@%@",[BYSaveTool objectForKey:BYOssDomainUrl],imageStr];
}
///url特殊字符转码
+ (NSString *)encodeParameter:(NSString *)originalPara {
    
    return [originalPara stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

///判断是否是数字
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

///小写转大写
+ (NSString *)lowUpdateBig:(NSString *)str
{
   
    
    // 大写
    NSString *upper = [str uppercaseString];
    return upper;
}
///是否是第一次进入app
+ (BOOL)isFirstGoInApp{
    
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        return YES;
    }else{
        return NO;
    }
    
}

///如果想要判断设备是ipad，要用如下方法
+ (BOOL)getIsIpad

{
     NSString *deviceType = [UIDevice currentDevice].model;
    if([deviceType isEqualToString:@"iPad"]) {
    return YES;
    
    }
     return NO;
    
}
///车牌后四位打*
+(NSString *)carNumPassword:(NSString *)carNum{
    if (carNum.length >= 7) {
        NSRange range;
        range.location = carNum.length - 4;
        range.length = 4;
       return [carNum stringByReplacingOccurrencesOfString:[carNum substringWithRange:range]withString:@"****"];
        
        
   

    }else{
       
         return carNum;
    }
}
/////地址截取
+(NSString *)carAdressSub:(NSString *)adress{
    if ([adress containsString:@"省"]) {
        NSArray *arr = [adress componentsSeparatedByString:@"省"];
        return [NSString stringWithFormat:@"%@省",arr.firstObject];
    }else if(adress.length == 0){
        return @"****";
    }else{
        return adress;
    }
}
///分享车牌 车型 车系 车颜色 车主各种值没有的判断
+(NSString *)carOrUserInfo:(BYShareCommitParamModel *)paramModel{
   
    NSString *str1 = [NSString stringWithFormat:@"%@",paramModel.carNum.length?paramModel.carNum:@""];
    NSString *str2 = [NSString stringWithFormat:@"%@%@%@",paramModel.carBrand.length?paramModel.carBrand:@"",paramModel.carSet.length?paramModel.carSet:@"",paramModel.carColor.length?paramModel.carColor:@""];
    NSString *str3 = [NSString stringWithFormat:@"%@",paramModel.carOwnerName.length?paramModel.carOwnerName:@""];
    if (!str1.length && !str2.length && !str3.length) {
        return @"";
    }
    if (!str1.length && !str2.length) {
        return str3;
    }
    if (!str1.length && !str3.length) {
        return str2;
    }
    if (!str2.length && !str3.length) {
        return str1;
    }
    if (!str1.length) {
        return [NSString stringWithFormat:@"%@ | %@",str2,str3];
    }
    if (!str2.length) {
        return [NSString stringWithFormat:@"%@ | %@",str1,str3];
    }
    if (!str3.length) {
        return [NSString stringWithFormat:@"%@ | %@",str1,str2];
    }
    return [NSString stringWithFormat:@"%@ | %@ | %@",str1,str2,str3];

}

///分享车牌 车型 车系 车颜色 车主各种值没有的判断
+(NSString *)carOrUserCellInfo:(BYShareListModel *)paramModel{
    
    NSString *str1 = [NSString stringWithFormat:@"%@",paramModel.carNum.length?paramModel.carNum:@""];
    NSString *str2 = [NSString stringWithFormat:@"%@%@%@",paramModel.carBrand.length?paramModel.carBrand:@"",paramModel.carType.length?paramModel.carType:@"",paramModel.carColor.length?paramModel.carColor:@""];
    NSString *str3 = [NSString stringWithFormat:@"%@",paramModel.carOwnerName.length?paramModel.carOwnerName:@""];
    if (!str1.length && !str2.length && !str3.length) {
        return @"";
    }
    if (!str1.length && !str2.length) {
        return str3;
    }
    if (!str1.length && !str3.length) {
        return str2;
    }
    if (!str2.length && !str3.length) {
        return str1;
    }
    if (!str1.length) {
        return [NSString stringWithFormat:@"%@ | %@",str2,str3];
    }
    if (!str2.length) {
        return [NSString stringWithFormat:@"%@ | %@",str1,str3];
    }
    if (!str3.length) {
        return [NSString stringWithFormat:@"%@ | %@",str1,str2];
    }
    return [NSString stringWithFormat:@"%@ | %@ | %@",str1,str2,str3];
    
}

+ (NSString *)getDataBaseFileDirectoryInSandBox
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentFolderPath = [searchPaths objectAtIndex:0];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isExist = [fileManager fileExistsAtPath:documentFolderPath];
    
    if (!isExist) {
        //创建路径.
        [fileManager createDirectoryAtPath:documentFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return documentFolderPath;
}

@end
