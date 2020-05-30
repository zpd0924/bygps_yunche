//
//  BYDeviceListHeader.m
//  BYGPS
//
//  Created by miwer on 16/8/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceListHeader.h"

@interface BYDeviceListHeader ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *onlineViewBgViewContraint_H;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectViewFrame_xContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeAndGroupBgView_HContraint;
@property (weak, nonatomic) IBOutlet UIView *deviceGroupBgView;
@property (nonatomic,strong) UIButton *selectBtn;

@end

@implementation BYDeviceListHeader

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.onlineViewBgViewContraint_H.constant = BYS_W_H(45);
    self.typeAndGroupBgView_HContraint.constant = BYS_W_H(40);
    self.selectBtn = (UIButton *)[self viewWithTag:100];
    self.selectBtn.selected = YES;
}

-(void)setIsResetAll:(BOOL)isResetAll{
    if (isResetAll) {
        self.selectViewFrame_xContraint.constant = 0;
        self.selectBtn = (UIButton *)[self viewWithTag:100];
        self.selectBtn.selected = YES;
    }
}

- (IBAction)onlineTypeItemAction:(UIButton *)sender {
    
    if (self.selectBtn != sender) {
        self.selectBtn.selected = NO;
        self.selectBtn = sender;
        self.selectBtn.selected = true;
    }
    
    self.selectViewFrame_xContraint.constant = (BYSCREEN_W / 4) * (sender.tag - 100);
    if (self.onlineTypeBlock) {
        self.onlineTypeBlock(sender.tag - 100);
    }
}

- (IBAction)deviceTypeSelect:(id)sender {
    if (self.deviceTypeSelectBlock) {
        self.deviceTypeSelectBlock();
    }
}

- (IBAction)groupSelect:(UIButton *)sender {
    
    if (self.groupSelectBlock) {
        self.groupSelectBlock();
    }
}
@end

/*
 
 self.listHeader.deviceGroupBgView.clipsToBounds = NO;
 self.listHeader.deviceGroupBgView.layer.shadowColor = [UIColor redColor].CGColor;//shadowColor阴影颜色
 self.listHeader.deviceGroupBgView.layer.shadowOffset = CGSizeMake(10,10);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
 self.listHeader.deviceGroupBgView.layer.shadowOpacity = 0.6;//阴影透明度，默认0
 self.listHeader.deviceGroupBgView.layer.shadowRadius = 8;//阴影半径，默认3

*/
