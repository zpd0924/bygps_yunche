//
//  BYUnderCircleButtonView.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYUnderCircleButtonView.h"
@interface BYUnderCircleButtonView ()

@property (nonatomic) NSArray *items;
@property (nonatomic) id target;
@property (nonatomic) SEL action;

@end

@implementation BYUnderCircleButtonView
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
- (void)setInitialValue
{
    self.selectedIndex = 0;
   
}

- (void)setSelectedIndex:(NSInteger)selectedIndex{
    for (int i = 0; i<_items.count; i++) {
         UIButton *btn = [self viewWithTag:1000+i];
        btn.selected = NO;
    }
    UIButton *btn = [self viewWithTag:1000+selectedIndex];
    btn.selected = YES;
    
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
        [button setImage:[UIImage imageNamed:@"circle_def"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"circle_sel"] forState:UIControlStateSelected];
        [self addSubview:button];
        if(i == 0)
            button.selected = YES;
        i++;
    }
    
   
    
}

- (void)setButtonsFrames{
    
    for (int i = 0; i<_items.count; i++) {
        UIButton *button = [self viewWithTag:1000+i];
        button.frame = CGRectMake(circleWH*i, 0, circleWH, circleWH);
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}
- (void)buttonAction:(UIButton *)button
{
    for (int i = 0; i<_items.count; i++) {
        UIButton *btn = [self viewWithTag:1000+i];
        if (button.tag == btn.tag) {
            btn.selected = YES;
        }else{
            btn.selected = NO;
        }
    }
    if (self.action != nil) {
        [self.target performSelectorOnMainThread:self.action withObject:button waitUntilDone:NO];
    }
}

@end
