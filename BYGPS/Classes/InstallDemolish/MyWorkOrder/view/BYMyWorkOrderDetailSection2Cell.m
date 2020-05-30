//
//  BYMyWorkOrderDetailSection2Cell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderDetailSection2Cell.h"

@interface BYMyWorkOrderDetailSection2Cell()


@property (weak, nonatomic) IBOutlet UILabel *sendOrderUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverAdressLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendOrderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverTeacherLabel;
@property (weak, nonatomic) IBOutlet UILabel *isCheckLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *failedReasonLabel;

@property (weak, nonatomic) IBOutlet UILabel *isCheckTitleLabel;//是否需要审核标题
@property (weak, nonatomic) IBOutlet UILabel *remarkTitleLabel;//备注标题
@property (weak, nonatomic) IBOutlet UILabel *failedReasonTitleLabel;//退审原因标题
@property (weak, nonatomic) IBOutlet UILabel *jiShiRemarkLabtl;//技师备注

@end

@implementation BYMyWorkOrderDetailSection2Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BYOrderDetailModel *)model{
    _model = model;
    
    self.sendOrderUserLabel.text = model.createUserName;
    self.contactLabel.text = [NSString stringWithFormat:@"%@ %@",model.contactPerson.length?model.contactPerson:@" ",model.contactTel.length?model.contactTel:@" "];
    self.serverAdressLabel.text = model.installAddress.length?model.installAddress:@" ";
    self.sendOrderTypeLabel.text = model.publishType?@"抢单":@"指派";
    self.serverTeacherLabel.text = model.technicianName.length?model.technicianName:@" ";
    self.remarkLabel.text = model.orderRemark.length?model.orderRemark:@" ";
    self.jiShiRemarkLabtl.text = model.installRemark.length?model.installRemark:@" ";
    if (_sendOrderType == BYWorkSendOrderType || _sendOrderType == BYRepairSendOrderType) {//安装派单和检修派单
        if (model.orderStatus == 3) {
            self.failedReasonTitleLabel.text = @"退审原因";
        self.failedReasonLabel.text = model.approveReason.length?model.approveReason:@" ";
        }else{
            self.failedReasonTitleLabel.text = nil;
            self.failedReasonLabel.text = nil;
        }
        self.isCheckTitleLabel.text = @"是否需要审核:";
        self.isCheckLabel.text = model.needToAudit?@"需要":@"不需要";
        

    }else{
        
        self.isCheckTitleLabel.text = @"拆机原因:";
        self.failedReasonTitleLabel.text = @"";
        self.failedReasonLabel.text = @"";
        
        switch (model.uninstallReson) {
            case 1:
                self.isCheckLabel.text = @"清货拆机";
                break;
            case 2:
                self.isCheckLabel.text = @"关联错误";
                break;
            case 3:
                self.isCheckLabel.text = @"悔货拆机";
                break;
            default:

                break;
        }
        
        
        
    }
   
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
