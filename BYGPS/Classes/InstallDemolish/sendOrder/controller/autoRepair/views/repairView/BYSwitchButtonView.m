//
//  BYSwitchButtonView.m
//  dscjs
//
//  Created by ZPD on 2018/4/27.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYSwitchButtonView.h"

@interface BYSwitchButtonView ()

@property (nonatomic) NSArray *items;
@property (nonatomic) id target;
@property (nonatomic) SEL action;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIButton *selectButton;


@end

@implementation BYSwitchButtonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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

- (void)setButtons
{
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.lineView];
    
    UIView *underLine = [[UIView alloc] init];
    underLine.backgroundColor = UIColorHexFromRGB(0x0FA9F5);
    underLine.tag = kLUHUnderLineButtonUnderLineTag;
//    underLine.layer.cornerRadius = 17.5;
    [self addSubview:underLine];
    
    int i = 0;
    for (NSString *titleStr in _items) {
        UIButton *button = [[UIButton alloc] init];
        button.tag = 3000+i;
        [button setTitle:titleStr forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:UIColorHexFromRGB(0x333333) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        i++;
    }
    
    
    
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
        UIButton *button = (UIButton *)[self viewWithTag:3000+i];
        if (button != nil) {
            button.frame = CGRectMake(i*width, 0, width, height);
            button.backgroundColor = [UIColor clearColor];
//            button.layer.cornerRadius = 17.5;
//            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1;
            button.layer.borderColor = UIColorHexFromRGB(0xececec).CGColor;
        };
    }
    
    UIView *underLine = [self viewWithTag:kLUHUnderLineButtonUnderLineTag];
    CGFloat underLineW = width;
    if (underLine != nil) {
        underLine.frame = CGRectMake(self.selectedIndex*underLineW, 0,
                                     underLineW, height);
    }
    self.lineView.frame = CGRectMake(0, 0,CGRectGetWidth(self.frame), height);
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)buttonAction:(UIButton *)button
{
    NSInteger index = button.tag-3000;
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
    CGFloat underLineW = width;
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        UIButton *button = [weakself viewWithTag:3000 + index];
        [self.selectButton setTitleColor:UIColorHexFromRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.selectButton = button;
        UIView *underLine = [weakself viewWithTag:kLUHUnderLineButtonUnderLineTag];
        if (underLine != nil) {
            underLine.frame = CGRectMake(index*width, 0,
                                         underLineW, height);
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) return;
    _selectedIndex = selectedIndex;
    [self selectButtonWithIndex:selectedIndex];
}
@end
