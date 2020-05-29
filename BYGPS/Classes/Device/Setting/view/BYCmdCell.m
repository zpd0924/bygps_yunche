//
//  BYCmdCell.m
//  BYGPS
//
//  Created by miwer on 2017/2/17.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYCmdCell.h"
#import "BYCmdRecordModel.h"
#import "UILabel+BYCaculateHeight.h"

@interface BYCmdCell ()

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendManLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet UIView *footView;



@end

@implementation BYCmdCell

-(void)drawRect:(CGRect)rect
{
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeadView)];
    [self.headView addGestureRecognizer:tap];
    self.footView.hidden = YES;
    self.arrowImgView.image = [UIImage imageNamed:@"icon_arr_drop_right"];
}

-(void)tapHeadView
{
    self.arrowImgView.image = [UIImage imageNamed:_isTapHead?@"icon_arr_drop_down":@"icon_arr_drop_right"];
    self.footView.hidden = _isTapHead;
    if (self.tapHeadBlock) {
        self.tapHeadBlock(_isTapHead);
    }
    self.arrowImgView.image = [UIImage imageNamed:_isTapHead?@"icon_arr_drop_right":@"icon_arr_drop_down"];
    self.footView.hidden = _isTapHead;
    _isTapHead = !_isTapHead;
    
}

-(void)setCmdType:(NSInteger)cmdType{
    self.titleLabel.text = cmdType == 1 ? @"回传间隔" : @"断油电";
}

- (IBAction)setPostBackAction:(id)sender {
    if (self.settingActionBlock) {
        self.settingActionBlock();
    }
}


-(void)setModel:(BYCmdRecordModel *)model{
    
    if (model.type == 1) {//如果是回传间隔
//        NSString * contentTypeStr = nil;
//        switch (model.contentType) {
//            case 1 : contentTypeStr = @"常规模式"; break;
//            case 2 : contentTypeStr = @"抓车模式"; break;
//            case 3 : contentTypeStr = @"固定回传点模式"; break;
//            case 4 : contentTypeStr = @"心跳模式"; break;
//            case 7 : contentTypeStr = @""; break;
//            case 8 : contentTypeStr = @"定位模式"; break;
//        }
//        if (model.contentType == 3) {
//            self.contentLabel.text = model.msg.length ? [NSString stringWithFormat:@"指令内容: %@(%@)",model.msg,contentTypeStr] : @"指令内容: 无记录";
//        }else if(model.contentType == 7){
//            self.contentLabel.text = model.msg.length ? [NSString stringWithFormat:@"指令内容: %@",model.msg] : @"指令内容: 无记录";
//        }else{
//            self.contentLabel.text = model.msg.length ? [NSString stringWithFormat:@"指令内容: %@(%@)",model.msg,contentTypeStr] : @"指令内容: 无记录";
//        }
        self.contentLabel.text = [NSString stringWithFormat:@"%@(%@)",model.content,model.mode.length > 0 ? model.mode : @""];
    }else{
        self.contentLabel.text = [NSString stringWithFormat:@"%@",model.content];
//        self.contentLabel.text = model.msg.length ? [NSString stringWithFormat:@"指令内容: %@",model.msg] : @"指令内容: 无记录";
    }
//    switch (model.status) {
//        case -1: self.statusLabel.text = @"指令状态: 无记录"; break;
//        case 2 : self.statusLabel.text = @"指令状态: 发送成功"; break;
//        case 3 : self.statusLabel.text = @"指令状态: 发送失败"; break;
//        case 4 : self.statusLabel.text = @"指令状态: 取消发送"; break;
//        default: self.statusLabel.text = @"指令状态: 发送中"; break;
//    }
    self.statusLabel.text = [NSString stringWithFormat:@"指令状态: %@",model.status];
    switch (model.type) {
        case 1:self.titleLabel.text = self.isWireless ? @"回传间隔" : @"车辆启动时上报间隔";break;
        case 4:self.titleLabel.text = @"设备重启";break;
        case 3:self.titleLabel.text = @"断油电";break;
        case 5:self.titleLabel.text = @"拆机报警";break;
        case 12:self.titleLabel.text = @"光感报警";break;
            
        default:
            break;
    }
    
    self.sendTimeLabel.text = [NSString stringWithFormat:@"发送时间: %@",model.sendTime];
//    self.receiveLabel.text = model.status == 2 ? [NSString stringWithFormat:@"应答时间: %@",model.updateTime] : @"应答时间: ";
    self.receiveLabel.text = [NSString stringWithFormat:@"应答时间: %@",model.updateTime];
    self.sendManLabel.text = [NSString stringWithFormat:@"发送人: %@",model.nickName];
    
    CGFloat rowH = [UILabel caculateLabel_HWith:BYS_W_H(170) Title:self.contentLabel.text font:BYS_W_H(14)];
    model.row_H = _isTapHead ?  BYS_W_H(120) + BYS_W_H(50) + rowH : BYS_W_H(50);
}

@end
