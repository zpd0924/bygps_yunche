//
//  BYHomeButton.m
//  BYGPS
//
//  Created by miwer on 2017/2/8.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYHomeButton.h"

#define badgeLabel_W BYS_W_H(20)
#define badgeView_W BYS_W_H(13)

@interface BYHomeButton ()

@property (nonatomic,assign) BYBadgeShowType badgeShowType;

@property (nonatomic,strong) UILabel * badgeLabel;

@property (nonatomic,strong) UIView * badgeView;

@end

@implementation BYHomeButton

+ (BYHomeButton *)createButtonWith:(NSString *)image title:(NSString *)title badgeShowType:(BYBadgeShowType)badgeShowType{
    
    BYHomeButton * button = [BYHomeButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor whiteColor];
    
    button.badgeShowType = badgeShowType;
    
    [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:BYGrayColor(50) forState:UIControlStateNormal];
    button.titleLabel.font = BYS_T_F(15);
    
    return button;
}

-(void)setBadgeNum:(NSInteger)badgeNum{
    
    if (badgeNum == 0) {//如果报警数字为0,则隐藏
        self.badgeLabel.hidden = YES;
        self.badgeView.hidden = YES;
        return ;
    }
    self.badgeView.hidden = NO;
    NSString * badgeStr = [NSString stringWithFormat:@"%zd",badgeNum];
    
    CGSize size = [badgeStr sizeWithAttributes: @{NSFontAttributeName: self.titleLabel.font}];
    
    self.badgeLabel.by_width = size.width > badgeLabel_W ? size.width + BYS_W_H(8) : badgeLabel_W;
    self.badgeLabel.by_centerX = CGRectGetMaxX(self.imageView.frame);
    
    self.badgeLabel.text = badgeStr;
    
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.imageView.by_y = 10;
    self.imageView.by_centerX = self.by_width * 0.5;
    
    self.titleLabel.by_width = self.by_width;
    self.titleLabel.by_y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.by_x = 0;
    self.titleLabel.by_height = self.by_height - self.titleLabel.by_y;
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    switch (self.badgeShowType) {
        case BYBadgeNumber: [self addSubview:self.badgeLabel]; break;
        case BYBadgePoint: [self addSubview:self.badgeView]; break;
        default:  break;
    }
}

-(UILabel *)badgeLabel{
    if (_badgeLabel == nil) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.font = BYS_T_F(14);
        _badgeLabel.textColor = [UIColor whiteColor];
        _badgeLabel.backgroundColor = [UIColor redColor];
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
        
        _badgeLabel.by_height = badgeLabel_W;
        _badgeLabel.by_width = badgeLabel_W;
        _badgeLabel.by_centerX = CGRectGetMaxX(self.imageView.frame);
        _badgeLabel.by_centerY = CGRectGetMinY(self.imageView.frame) + 3;
        
        _badgeLabel.layer.cornerRadius = badgeLabel_W / 2;
        _badgeLabel.clipsToBounds = YES;
    }
    return _badgeLabel;
}

-(UIView *)badgeView{
    if (_badgeView == nil) {
        _badgeView = [[UIView alloc] init];
        _badgeView.backgroundColor = [UIColor redColor];
        _badgeView.by_height = badgeView_W;
        _badgeView.by_width = badgeView_W;
        _badgeView.by_centerX = CGRectGetMaxX(self.imageView.frame);
        _badgeView.by_centerY = CGRectGetMinY(self.imageView.frame) + 1;
        
        _badgeView.layer.cornerRadius = badgeView_W / 2;
        _badgeView.clipsToBounds = YES;
    }
    return _badgeView;
}

@end
