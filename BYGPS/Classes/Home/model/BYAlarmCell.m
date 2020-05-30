//
//  BYAlarmCell.m
//  BYGPS
//
//  Created by miwer on 16/9/13.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAlarmCell.h"
#import "BYAlarmModel.h"
#import "NSString+BYAttributeString.h"

@interface BYAlarmCell ()

@property (weak, nonatomic) IBOutlet UILabel *carBrandLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleManLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleMarkLabel;

@end

@implementation BYAlarmCell

-(void)setModel:(BYAlarmModel *)model{
//    [BYSaveTool boolForKey:]
//    NSString *carNumStr = [NSString StringJudgeIsValid:model.CarNum isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
//    NSString *ownerNameStr = [NSString StringJudgeIsValid:model.OwnerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
//    self.carBrandLabel.text = [NSString stringWithFormat:@"车牌:%@  车主:%@",carNumStr,ownerNameStr];
    
    self.carBrandLabel.text = [NSString stringWithFormat:@"设备号:%@",model.sn];
    if (model.processingUserId.length) {
        self.handleManLabel.text = [NSString stringWithFormat:@"处理人:%@(%@)",model.nickName,model.processingTime];
    }else{
        self.handleManLabel.text = @"处理人:";
    }
    self.groupLabel.text = [NSString stringWithFormat:@"所在分组:%@",model.groupName];

    self.endTimeLabel.text = model.reviceTime.length ? [NSString stringWithFormat:@"恢复时间:%@",model.reviceTime] : @"恢复时间:未恢复";

    self.startTimeLabel.text = [NSString stringWithFormat:@"开始时间:%@",model.createTime];
    if (model.alarmRemark.length) {
        self.handleMarkLabel.text = [NSString stringWithFormat:@"处理备注:%@",model.alarmRemark];
    }else{
        self.handleMarkLabel.text = @"处理备注:";
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
