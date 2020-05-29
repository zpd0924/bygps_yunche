//
//  BYDeviceInfoFooterView.m
//  BYGPS
//
//  Created by ZPD on 2018/12/27.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYDeviceInfoFooterView.h"

@implementation BYDeviceInfoFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.installButton.layer.cornerRadius = 5.0;
    self.installButton.layer.masksToBounds = YES;
    
    self.repairButton.layer.cornerRadius = 5.0;
    self.repairButton.layer.masksToBounds = YES;
//    self.repairButton.layer.borderWidth = 1.0;
//    self.repairButton.layer.borderColor = UIColorHexFromRGB(0x5b5b5b).CGColor;
    
    self.removeButton.layer.cornerRadius = 5.0;
    self.removeButton.layer.masksToBounds = YES;
//    self.removeButton.layer.borderWidth = 1.0;
//    self.removeButton.layer.borderColor = UIColorHexFromRGB(0x5b5b5b).CGColor;
    
}
- (IBAction)remove:(id)sender {
    
    if (self.removeBlock) {
        self.removeBlock();
    }
    
}
- (IBAction)repair:(id)sender {
    
    if (self.repairBlock) {
        self.repairBlock();
    }
    
}
- (IBAction)install:(id)sender {
    
    if (self.installBlock) {
        self.installBlock();
    }
    
}

@end
