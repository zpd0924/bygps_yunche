//
//  BYShareTypeView.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/11.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYShareTypeView.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "WXApiRequestHandler.h"

@interface BYShareTypeView()
@property (weak, nonatomic) IBOutlet UIView *wechatView;
@property (weak, nonatomic) IBOutlet UIView *qqView;
@property (weak, nonatomic) IBOutlet UIView *copysLinkView;


@end

@implementation BYShareTypeView

- (void)awakeFromNib{
    [super awakeFromNib];
    UITapGestureRecognizer *wechatTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(wechatViewTap)];
    UITapGestureRecognizer *qqViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qqViewTapTap)];
    UITapGestureRecognizer *copysLinkViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(copysLinkViewTap)];
    [self.wechatView addGestureRecognizer:wechatTap];
    [self.qqView addGestureRecognizer:qqViewTap];
    [self.copysLinkView addGestureRecognizer:copysLinkViewTap];
    
    if (![WXApiRequestHandler isWXAppInstalled]) {
        self.wechatView.hidden = YES;
    }
    if (![TencentOAuth iphoneQQInstalled]) {
       self.qqView.hidden = YES;
    }
    
}
#pragma mark -- 微信
- (void)wechatViewTap{
    if (self.shareTypeBlock) {
        self.shareTypeBlock(BYWechatType);
    }
}
#pragma mark -- QQ
- (void)qqViewTapTap{
    if (self.shareTypeBlock) {
        self.shareTypeBlock(BYQQType);
    }
}
- (void)copysLinkViewTap{
    if (self.shareTypeBlock) {
        self.shareTypeBlock(BYLinkType);
    }
}
#pragma mark -- 复制链接

- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self hideView];
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = [UIScreen mainScreen].bounds;
    [self shakeToShow:self];
    [self.layer removeAnimationForKey:@"transform"];
}

-(void)hideView{
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void) shakeToShow:(UIView *)aView{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
    
}


@end
