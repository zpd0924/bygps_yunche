//
//  BYAlarmToolView.m
//  BYGPS
//
//  Created by miwer on 16/9/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAlarmToolView.h"

#define handleButton_H BYS_W_H(50) * 2 / 3

@interface BYAlarmToolView ()

@property (weak, nonatomic) IBOutlet UIButton *handleButton;

@end

@implementation BYAlarmToolView

-(void)setTitle:(NSString *)title{
    [self.handleButton setTitle:title forState:UIControlStateNormal];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.handleButton.layer.cornerRadius = handleButton_H / 2;
    self.handleButton.clipsToBounds = YES;
//    self.handleButton.backgroundColor = [UIColor blueColor];
}

- (IBAction)handleAction:(id)sender {
    
//    self.handleButton.layer.cornerRadius =
    if (self.handleBlock) {
        self.handleBlock();
    }
}

@end
