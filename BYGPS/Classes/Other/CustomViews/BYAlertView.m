//
//  AlertView.m
//  MyAlertView
//
//  Created by miwer on 16/8/1.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAlertView.h"
//#import "MyContentView.h"

@interface BYAlertView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelContraint_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonsBgViewContraint_H;

@end

@implementation BYAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    
     self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4];
    
    self.titleLabelContraint_H.constant = BYS_W_H(40);
    self.buttonsBgViewContraint_H.constant = BYS_W_H(40);
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.alert.frame,touchPoint)) {
        [self hideView];
    }
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (IBAction)cancel:(id)sender {
    [self hideView];
    
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    
}
- (IBAction)sure:(id)sender {
    if (self.sureBlock) {
        self.sureBlock();
    }
    
    [self hideView];
    
//    if (self.cancelBlock) {
//        self.cancelBlock();
//    }
}

+(BYAlertView *)viewFromNibWithTitle:(NSString *)title message:(NSString *)message{
    
    BYAlertView * alert = [BYAlertView by_viewFromXib];
    
    alert.titleLabel.text = title;
//    alert.messageLabel.text = message;
    
    return alert;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.frame = [UIScreen mainScreen].bounds;
    [self shakeToShow:self.alert];
    [self.layer removeAnimationForKey:@"transform"];
}

-(void)hideView{
    [UIView animateWithDuration:0.2 animations:^{
        self.alert.transform = CGAffineTransformMakeScale(0.1, 0.1);
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
