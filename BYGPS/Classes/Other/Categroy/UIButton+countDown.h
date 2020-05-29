//
//  UIButton+countDown.h
//  LiquoriceDoctorProject
//
//  Created by HenryCheng on 15/12/4.
//  Copyright © 2015年 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (countDown)

/**
 *  倒计时按钮
 *
 *  @param timeLine 倒计时总时间
 *  @param zeroBlock 倒计时为0的回调
 */
- (void)startWithTime:(NSInteger)timeLine zeroBlock:(void (^) ())zeroBlock;

-(void)cancelTimer;//关闭定时器
- (NSInteger)getTimerDuration;//获取定时器暂停时间
- (void)suspend;
@end
