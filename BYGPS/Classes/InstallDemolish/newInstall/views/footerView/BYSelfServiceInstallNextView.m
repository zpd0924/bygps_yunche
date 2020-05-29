//
//  BYSelfServiceInstallNextView.m
//  BYGPS
//
//  Created by ZPD on 2018/9/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYSelfServiceInstallNextView.h"

@implementation BYSelfServiceInstallNextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.lastButton.layer.cornerRadius = 5.0f;
    self.lastButton.layer.masksToBounds = YES;
    
    self.commitButton.layer.cornerRadius = 5.0f;
    self.commitButton.layer.masksToBounds = YES;
    
}
- (IBAction)lastButtonClick:(id)sender {
    if (self.lastStepBlock) {
        self.lastStepBlock();
    }
}
- (IBAction)commitButtonClick:(id)sender {
    if (self.commitBlock) {
        self.commitBlock();
    }
}


@end
