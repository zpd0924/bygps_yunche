//
//  BYAlarmHeaderView.m
//  BYGPS
//
//  Created by miwer on 16/9/12.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAlarmHeaderView.h"

@interface BYAlarmHeaderView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemsBgContraint_H;
@property (weak, nonatomic) IBOutlet UIView *itemsBgView;

@end

@implementation BYAlarmHeaderView

- (IBAction)itemsAction:(UIButton *)sender {
    
    if (self.itemsActionBlock) {
        self.itemsActionBlock(sender.tag - 20);
    }
    
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.itemsBgContraint_H.constant = BYS_W_H(40);
    
}

@end
