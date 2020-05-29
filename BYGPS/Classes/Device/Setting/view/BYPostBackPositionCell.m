//
//  BYPostBackPositionCell.m
//  BYGPS
//
//  Created by miwer on 16/9/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYPostBackPositionCell.h"
#import "BYPostBackModel.h"

@interface BYPostBackPositionCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;


@end

@implementation BYPostBackPositionCell

-(void)setModel:(BYPostBackModel *)model{
    
    self.titleLabel.text = model.title;
    
    self.subTitleLabel.text = [model.detail isEqualToString:@"请输入固定回传时间"] || [model.detail isEqualToString:@"请输入固定上线时间"] ? model.detail : [NSString stringWithFormat:@"%@:00",model.detail];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
