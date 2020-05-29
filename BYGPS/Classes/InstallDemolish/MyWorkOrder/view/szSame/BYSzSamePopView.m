//
//  BYSzSamePopView.m
//  BYGPS
//
//  Created by 主沛东 on 2019/5/3.
//  Copyright © 2019 miwer. All rights reserved.
//

#import "BYSzSamePopView.h"
#import "BYSameAddDeviceModel.h"
#import "BYSameAddInstallModel.h"
#import "BYSameAddOrderModel.h"
#import "UILabel+BYCaculateHeight.h"

@interface BYSzSamePopView ()
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *locateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *locateAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *locateTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *popView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *locationTypeConstraintH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;
@property (weak, nonatomic) IBOutlet UILabel *locateTitle;

@end

@implementation BYSzSamePopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)closePop:(id)sender {
    
    if (self.closePopBlock) {
        self.closePopBlock();
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.popView.layer.cornerRadius = 5.0;
    self.popView.layer.masksToBounds = YES;
    
}

-(void)setSameOrderModel:(BYSameAddOrderModel *)sameOrderModel{
    _sameOrderModel = sameOrderModel;
    
    self.locateTimeLabel.text = [NSString stringWithFormat:@"派单时间：%@",sameOrderModel.orderTime];
    self.locationTypeConstraintH.constant = 0;
//    self.locateTypeLabel.hidden = YES;
    self.locateTitle.text = @"服务地址：";
    self.locateAddressLabel.text = sameOrderModel.orderAdd;
    self.locateTypeLabel.hidden = YES;
    self.constraintTop.constant = 0;
    
    CGFloat carSta_H = [UILabel caculateLabel_HWith:(BYSCREEN_W *2 / 3 - 20) Title:self.locateAddressLabel.text font:13];

    sameOrderModel.pop_H = 56 + carSta_H;
    
}


-(void)setSameDeviceModel:(BYSameAddDeviceModel *)sameDeviceModel{
    _sameDeviceModel = sameDeviceModel;
    self.locateTimeLabel.text = [NSString stringWithFormat:@"定位时间：%@",sameDeviceModel.locationTime];
    self.locateTypeLabel.text = [NSString stringWithFormat:@"定位方式：%@",sameDeviceModel.locationType];
    self.locationTypeConstraintH.constant = 16;
    self.locateTypeLabel.hidden = NO;
    self.locateAddressLabel.text = sameDeviceModel.deviceAdd;
    self.constraintTop.constant = 6;
    CGFloat carSta_H = [UILabel caculateLabel_HWith:(BYSCREEN_W *2 / 3 - 20) Title:self.locateAddressLabel.text font:13];
    sameDeviceModel.pop_H = 56 + 6 + 16 + carSta_H;
}

-(void)setSameInstallModel:(BYSameAddInstallModel *)sameInstallModel
{
    _sameInstallModel = sameInstallModel;
    self.locateTimeLabel.text = [NSString stringWithFormat:@"定位时间：%@",sameInstallModel.installTime];
    self.locationTypeConstraintH.constant = 0;
    self.locateAddressLabel.text = sameInstallModel.installAdd;
    self.locateTypeLabel.hidden = YES;
    self.constraintTop.constant = 0;
    CGFloat carSta_H = [UILabel caculateLabel_HWith:(BYSCREEN_W *2 / 3 - 20) Title:self.locateAddressLabel.text font:13];
    sameInstallModel.pop_H = 56 + carSta_H;
}

@end
