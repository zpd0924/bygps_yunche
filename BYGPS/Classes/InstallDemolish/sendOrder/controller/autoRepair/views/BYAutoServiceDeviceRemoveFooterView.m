//
//  BYAutoServiceDeviceRemoveFooterView.m
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceDeviceRemoveFooterView.h"

@interface BYAutoServiceDeviceRemoveFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *cancleButton;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@end

@implementation BYAutoServiceDeviceRemoveFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.cancleButton.layer.cornerRadius = 5.0;
    self.cancleButton.layer.masksToBounds = YES;
    
    self.commitButton.layer.cornerRadius = 5.0;
    self.commitButton.layer.masksToBounds = YES;
    
}

- (IBAction)confirmClick:(id)sender {
    
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (IBAction)cancleBlock:(id)sender {
    
    if (self.cancleBlock) {
        self.cancleBlock();
    }
    
}


@end
