//
//  UIButton+countDown.m
//  LiquoriceDoctorProject
//
//  Created by HenryCheng on 15/12/4.
//  Copyright © 2015年 iMac. All rights reserved.
//

#import "UIButton+countDown.h"
#import "HWWeakTimer.h"

@implementation UIButton (countDown)

static dispatch_source_t _timer;


- (void)startWithTime:(NSInteger)timeLine zeroBlock:(void (^) ())zeroBlock{
    
    __weak typeof(self) weakSelf = self;
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //每秒执行一次
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        //倒计时结束，关闭
        if (timeOut <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:@"正在刷新..." forState:UIControlStateNormal];
            });
            
            if (zeroBlock) {
                zeroBlock();
            }
            
        }else {
            int allTime = (int)timeLine + 1;
            int seconds = timeOut % allTime;
            NSString *timeStr = [NSString stringWithFormat:@"%0.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:[NSString stringWithFormat:@"%@秒后刷新",timeStr] forState:UIControlStateNormal];
            });
            BYLog(@"%zd",timeOut);
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}

-(void)cancelTimer{
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
}

- (NSInteger)getTimerDuration{
    if ([self.titleLabel.text containsString:@"秒后刷新"]) {
        return [[self.titleLabel.text substringToIndex:2] integerValue]>[BYSaveTool getRefreshDurationIntegerWithKey:BYControlRefreshDuration]?[BYSaveTool getRefreshDurationIntegerWithKey:BYControlRefreshDuration]:[[self.titleLabel.text substringToIndex:2] integerValue];
    }else{
        return [BYSaveTool getRefreshDurationIntegerWithKey:BYControlRefreshDuration];
    }
}

//
- (void)suspend{
    if (_timer) {
        dispatch_suspend(_timer);
    }
}
@end
