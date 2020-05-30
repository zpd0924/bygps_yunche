//
//  BYAlarmHandleCell.m
//  BYGPS
//
//  Created by miwer on 16/9/18.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAlarmHandleCell.h"
#import "BYAlarmModel.h"
#import "BYSaveTool.h"
#import "NSString+BYAttributeString.h"

@interface BYAlarmHandleCell ()

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
@property (weak, nonatomic) IBOutlet UILabel *carBrandLabel;

@end

@implementation BYAlarmHandleCell

-(void)setModel:(BYAlarmModel *)model{
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"开始时间:%@",model.createTime];

//    NSString *carNumStr = [NSString StringJudgeIsValid:model.CarNum isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
//    NSString *ownerNameStr = [NSString StringJudgeIsValid:model.OwnerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
//    self.carBrandLabel.text = [NSString stringWithFormat:@"车牌:%@  车主:%@",carNumStr,ownerNameStr];
    self.carBrandLabel.text = [NSString stringWithFormat:@"设备号:%@",model.sn];

    self.groupLabel.text = [NSString stringWithFormat:@"所在分组:%@",model.groupName];

}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
