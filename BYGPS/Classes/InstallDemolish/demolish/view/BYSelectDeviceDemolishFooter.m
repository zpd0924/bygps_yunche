//
//  BYSelectDeviceDemolishFooter.m
//  父子控制器
//
//  Created by miwer on 2016/12/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSelectDeviceDemolishFooter.h"

@interface BYSelectDeviceDemolishFooter ()

@property (weak, nonatomic) IBOutlet UIButton *reasonButton;

@end

@implementation BYSelectDeviceDemolishFooter

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.reasonButton.layer.cornerRadius = 2;
    self.clipsToBounds = YES;
    self.reasonButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.reasonButton.layer.borderWidth = 1;
}

- (IBAction)selectSeasonAction:(id)sender {
    
    if (self.reasonBlock) {
        self.reasonBlock();
    }
}

-(void)setReason:(NSString *)reason{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.reasonButton setTitle:reason forState:UIControlStateNormal];
    });
}

@end
