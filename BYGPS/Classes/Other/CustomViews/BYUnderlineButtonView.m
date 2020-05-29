//
//  BYUnderlineButtonView.m
//  BYGPS
//
//  Created by ZPD on 2017/12/13.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYUnderlineButtonView.h"

@interface BYUnderlineButtonView ()

@property (nonatomic) NSArray *items;
@property (nonatomic) id target;
@property (nonatomic) SEL action;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *underLine;

@end

@implementation BYUnderlineButtonView

- (instancetype)initWithItems:(NSArray *)items;
{
    self = [super init];
    if (self) {
        _items = items;
        [self setButtons];
        [self setInitialValue];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setButtonsFrames];
}
- (void)setIsBigLookImages:(BOOL)isBigLookImages{
    _isBigLookImages = isBigLookImages;
    self.lineView.hidden = YES;
//    self.underLine.hidden = YES;
}

- (void)setButtons
{
    int i = 0;
    for (NSString *titleStr in _items) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = 1000+i;
        [button setTitle:titleStr forState:UIControlStateNormal];
        button.titleLabel.font = BYS_T_F(17);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        i++;
    }
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = BYGlobalBg;
    
    [self addSubview:self.lineView];
    
    UIView *underLine = [[UIView alloc] init];
    self.underLine = underLine;
    underLine.backgroundColor = BYGlobalBlueColor;
    underLine.tag = kLUHUnderLineButtonUnderLineTag;
    underLine.layer.cornerRadius = kLUHUnderLineButtonUnderLineHeight/2;
    [self addSubview:underLine];
    
}

- (void)setInitialValue
{
    self.selectedIndex = 0;
    [self selectButtonWithIndex:0];
}

- (void)setButtonsFrames
{
    CGFloat width = CGRectGetWidth(self.frame)/_items.count;
    CGFloat height = CGRectGetHeight(self.frame);
    for (int i = 0; i < _items.count; i++) {
        UIButton *button = (UIButton *)[self viewWithTag:1000+i];
        if (button != nil) button.frame = CGRectMake(i*width, 5, width, height - 10);
    }
    
    UIView *underLine = [self viewWithTag:kLUHUnderLineButtonUnderLineTag];
    CGFloat underLineW = width - 2*kLUHUnderLineButtonUnderLinePadding;
    if (underLine != nil) {
        underLine.frame = CGRectMake(self.selectedIndex*underLineW + kLUHUnderLineButtonUnderLinePadding, height-kLUHUnderLineButtonUnderLineHeight,
                                     underLineW, kLUHUnderLineButtonUnderLineHeight);
    }
    
    self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 2,CGRectGetWidth(self.frame), 1);
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)buttonAction:(UIButton *)button
{
    NSInteger index = button.tag-1000;
    if (index == self.selectedIndex) return;
    self.selectedIndex = index;
    if (self.action != nil) {
        [self.target performSelectorOnMainThread:self.action withObject:button waitUntilDone:NO];
    }
}

#pragma mark - private

- (void)selectButtonWithIndex:(NSInteger)index;
{
    CGFloat width = CGRectGetWidth(self.frame)/_items.count;
    CGFloat height = CGRectGetHeight(self.frame);
    CGFloat underLineW = width - 2*kLUHUnderLineButtonUnderLinePadding;
    __weak typeof(self) weakself = self;
    if (self.isBigLookImages) {
        if (index > 2)
            return;
    }
    
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        UIView *underLine = [weakself viewWithTag:kLUHUnderLineButtonUnderLineTag];
        if (underLine != nil) {
            underLine.frame = CGRectMake(index*width+kLUHUnderLineButtonUnderLinePadding, height-kLUHUnderLineButtonUnderLineHeight,
                                         underLineW, kLUHUnderLineButtonUnderLineHeight);
        }
    } completion:^(BOOL finished) {
      
        if (_isBigLookImages) {
            for (int i = 0; i<_items.count; i++) {
                UIButton *button = (UIButton *)[self viewWithTag:1000+i];
                if (i == index) {
                    [button setTitleColor:BYGlobalBlueColor forState:UIControlStateNormal];
                }else{
                    [button setTitleColor:WHITE forState:UIControlStateNormal];
                }
                
            }
        }
       
        
    }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
//    _selectedIndex = selectedIndex;
    if (_selectedIndex == selectedIndex) return;
    _selectedIndex = selectedIndex;
    [self selectButtonWithIndex:selectedIndex];
}


@end
