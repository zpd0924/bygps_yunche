//
//  BYCountDownButton.m
//  BYGPS
//
//  Created by ZPD on 2017/11/27.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYCountDownButton.h"
#import "HWWeakTimer.h"

@interface BYCountDownButton ()

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation BYCountDownButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setup];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setup];
}

- (void)setup {
    
    //    [self setTitleColor:BYGrayColor(61) forState:UIControlStateDisabled];
    
    //    [self setTitle:@"重新发送" forState:UIControlStateNormal];
    //    [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    //    self.titleLabel.font = BYS_T_F(15);
    //    self.backgroundColor = [UIColor clearColor];
    
}


- (void)startWithTime:(NSInteger)timeLine zeroBlock:(void (^) ())zeroBlock{
    
    __weak typeof(self) weakSelf = self;
    //倒计时时间
    __block NSInteger timeOut = timeLine;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _timer = [HWWeakTimer scheduledTimerWithTimeInterval:1 block:^(id userInfo) {
           
            //倒计时结束，关闭
            if (timeOut <= 0) {
                [_timer invalidate];
                if (_timer) {
                    _timer = nil;
                }
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
                
                timeOut--;
            }
        } userInfo:@"Fire" repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    });

    [_timer fire];
    
}

-(void)cancelTimer{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_timer invalidate];
    if (_timer) {
        _timer = nil;
    }
    });
}




//-(void)dealloc {
//    [_timer invalidate];
//    if (_timer) {
//        _timer = nil;
//    }
//    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
//}


@end
