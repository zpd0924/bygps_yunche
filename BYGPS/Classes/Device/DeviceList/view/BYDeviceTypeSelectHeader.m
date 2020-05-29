//
//  BYDeviceTypeSelectHeader.m
//  BYGPS
//
//  Created by miwer on 2016/12/12.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceTypeSelectHeader.h"

@interface BYDeviceTypeSelectHeader()

@property (weak, nonatomic) IBOutlet UIButton *wirelessButton;
@property (weak, nonatomic) IBOutlet UIButton *wiredButton;

@end

@implementation BYDeviceTypeSelectHeader

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.wirelessButton.layer.cornerRadius = 5;
    self.wirelessButton.clipsToBounds = YES;
    self.wirelessButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.wirelessButton.layer.borderWidth = 1;
    
    self.wiredButton.layer.cornerRadius = 5;
    self.wiredButton.clipsToBounds = YES;
    self.wiredButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.wiredButton.layer.borderWidth = 1;
    
}

- (IBAction)wiredAction:(id)sender {
    if (self.wiredActionBlock) {
        self.wiredActionBlock();
    }
}

- (IBAction)wirelessAction:(id)sender {
    if (self.wirelessActionBlock) {
        self.wirelessActionBlock();
    }
}

- (IBAction)selelctAll:(id)sender {
    if (self.selectAllBlock) {
        self.selectAllBlock();
    }
}

@end
