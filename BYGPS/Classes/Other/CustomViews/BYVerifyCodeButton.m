//
//  BYVerifyCodeButton.m
//  carLoanManagerment
//
//  Created by miwer on 2017/3/24.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BYVerifyCodeButton.h"

static NSInteger const timeCount = 60;

@interface BYVerifyCodeButton ()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@end

@implementation BYVerifyCodeButton

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

- (void)timeFailBegin {
    
    self.count = timeCount;
    
    [self setTitle:@"重新发送" forState:UIControlStateNormal];
    
    [self setTitle:[NSString stringWithFormat:@"重新发送(%zd)",timeCount] forState:UIControlStateDisabled];
    
    self.enabled = NO;
    // 加1个计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
}

- (void)timerFired {
        
    if (self.count != 1) {
        self.count -= 1;
        self.enabled = NO;
        [self setTitle:[NSString stringWithFormat:@"重新发送(%zd)", self.count] forState:UIControlStateDisabled];
    } else {
        
        self.enabled = YES;

        [self.timer invalidate];
    }
}

-(void)dealloc
{
    [self.timer invalidate];
}
//-(void)cancelTimer{
//    [self.timer invalidate];
//    self.timer = nil;
////    dispatch_source_cancel(self.timer);
//}

@end
