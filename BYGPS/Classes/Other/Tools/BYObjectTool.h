//
//  BYObjectTool.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/13.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BYShareListModel,BYShareCommitParamModel;
@interface BYObjectTool : NSObject

///改变字符串某个区域的字符的颜色和大小
+(NSMutableAttributedString *)setTextColor:(NSString *)labelStr FontNumber:(id)font AndRange:(NSRange)range AndColor:(UIColor *)vaColor;
///根据NSDate 获取时间年月日 时分秒字符创
+(NSString *)formatterSelectDate:(NSDate *)date;
///扫描选择车牌或vin
+(UIAlertController *)showScanAleartCarNumWith:(void(^)(void))CarNum vinNum:(void(^)(void))vinNum;
///选择车牌号 车架号
+(UIAlertController *)showChangeCarNumberOrVinAleartCarNumWith:(void(^)(void))CarNumSelect vinNum:(void(^)(void))vinNumSelect;
///选择车牌号 车架号 设备号
+(UIAlertController *)showChangeCarNumberOrVinOrSnAleartCarNumWith:(void(^)(void))CarNumSelect vinNum:(void(^)(void))vinNumSelect SnNum:(void(^)(void))snNumSelect;

///选择拆机原因 清贷拆机。关联错误。悔贷拆机
+(UIAlertController *)alertRemoveReasonWith:(void(^)(void))clearLoan wrongRelated:(void(^)(void))wrongRelated regretLoan:(void(^)(void))regretLoan;

///选择检修原因 设备不上线 设备不定位 设备没电 其他
+(UIAlertController *)alertRepairReasonWith:(void(^)(void))noLine noLocate:(void(^)(void))noLocate noElectricity:(void(^)(void))noElectricity other:(void(^)(void))other;

//1=设备已拆除，解除关联。2=设备未拆除，未解除关联。3=设备未拆除，强制解除关联。
+(UIAlertController *)alertRemoveConclutionWith:(void(^)(void))beenRemoved wrongRelated:(void(^)(void))noRemove regretLoan:(void(^)(void))noRemoveRelease;

///判断联系人格式是否正确
+(BOOL)isContactsFormat:(NSString *)contacts;
///汉子转拼音
+ (NSMutableString *)changeToPinYin:(NSMutableString*)str;
///是否在26个字母内
+ (BOOL) isInLetter:(NSString*) firstLetter;
///富文本
+ (NSMutableAttributedString *)changeStrWittContext:(NSString *)context ChangeColorText:(NSString *)ColorStr WithColor:(id)ColorValue WithFont:(id)FontValue;
///改变两段字符颜色和大小 富文本
+ (NSMutableAttributedString *)changeStrWittContext:(NSString *)context ChangeColorText:(NSString *)ColorStr ChangeColorText:(NSString *)ColorStr WithColor:(id)ColorValue WithFont:(id)FontValue ;
///返回图片地址
+ (NSString *)imageStr:(NSString *)imageStr;
///url特殊字符转码
+ (NSString *)encodeParameter:(NSString *)originalPara;
///判断是否是数字
+ (BOOL) deptNumInputShouldNumber:(NSString *)str;
///小写转大写
+ (NSString *)lowUpdateBig:(NSString *)str;
///是否是第一次进入app
+ (BOOL)isFirstGoInApp;
///如果想要判断设备是ipad，要用如下方法
+ (BOOL)getIsIpad;
///车牌后四位打*
+(NSString *)carNumPassword:(NSString *)carNum;
///地址截取
+(NSString *)carAdressSub:(NSString *)adress;
///分享车牌 车型 车系 车颜色 车主各种值没有的判断
+(NSString *)carOrUserInfo:(BYShareCommitParamModel *)paramModel;
///分享车牌 车型 车系 车颜色 车主各种值没有的判断
+(NSString *)carOrUserCellInfo:(BYShareListModel *)paramModel;
+ (NSString *)getDataBaseFileDirectoryInSandBox;
@end

