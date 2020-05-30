//
//  BYAlertTip.h
//  xsxc
//
//  Created by 李志军 on 2018/7/3.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYAlertTip : NSObject
/**
 *  提示框确定的回调
 */
typedef void  (^BackSure)();
typedef void  (^BackCancel)();



@property (nonatomic, copy) BackSure block; //!< 确定的回调
@property (nonatomic, copy) BackCancel blockCancel; //!< 取消的回调
/**
 *  标题 提示 取消 确认自定义
 
 *
 *  @param title       提示框标题
 *  @param message     提示详情
 *  @param cancelTitle 取消按钮text
 *  @param sureTitle   确认按钮text
 *  @param control     当前控制器
 *  @param block       确定回调
 *  @param block       取消回调
 */
+(void)ShowAlertWith:(NSString*)title message:(NSString*)message withCancelTitle:(NSString *)cancelTitle withSureTitle:(NSString *)sureTitle viewControl:(UIViewController*)control andSureBack:(BackSure)BackSure andCancelBack:(BackCancel)BackCancel;
///只有确定
+(void)ShowOnlyAlertWith:(NSString*)title message:(NSString*)message viewControl:(UIViewController*)control andSureBack:(BackSure)block;
+ (UIAlertController *)ShowOnlySureAlertWith:(NSString *)title message:(NSString *)message sureTitle:(NSString *)sureTitle viewControl:(UIViewController *)control andSureBack:(BackSure)block;
@end
