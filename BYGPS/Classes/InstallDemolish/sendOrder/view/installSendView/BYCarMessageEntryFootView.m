//
//  BYCarMessageEntryFootView.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCarMessageEntryFootView.h"

@implementation BYCarMessageEntryFootView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.nextStepBtn.layer.cornerRadius = 6;
    self.nextStepBtn.layer.masksToBounds = YES;
}


//下一步
- (IBAction)nextStep:(UIButton *)sender {
    if (self.nextStepClickBlock)
        self.nextStepClickBlock();
}


@end
