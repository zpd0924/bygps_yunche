//
//  BYOrderPushCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/20.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYOrderPushCell.h"

@interface BYOrderPushCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLable;


@property (nonatomic,strong) NSArray *titleArray;

@end

@implementation BYOrderPushCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.titleLable.text = self.titleArray[indexPath.row];
    if (indexPath.row == 0) {
//        self.switchBtn.on = [BYSaveTool boolForKey:@"overTimeOrder"];
        if (_model.type30 == 1) {
            self.switchBtn.on = NO;
        }else{
            self.switchBtn.on = YES;
        }
    }else if(indexPath.row == 1){
//        self.switchBtn.on = [BYSaveTool boolForKey:@"waitOrder"];
        if (_model.type31 == 1) {
            self.switchBtn.on = NO;
        }else{
            self.switchBtn.on = YES;
        }
    }else{
        if (_model.type36 == 1) {
            self.switchBtn.on = NO;
        }else{
            self.switchBtn.on = YES;
        }
    }
}
- (IBAction)switchBtnClick:(UISwitch *)sender {
   
    if (_indexPath.row == 0) {
        if (self.overTimeOrderBlock) {
            self.overTimeOrderBlock(sender.on);
        }
        
    }else if(_indexPath.row == 1){
        if (self.waitOrderBlock) {
            self.waitOrderBlock(sender.on);
        }
       
    }else{
        if (self.takeInOrderBlock) {
            self.takeInOrderBlock(sender.on);
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"超时工单提醒",@"待审核工单提醒",@"技师接单提醒"];
    }
    return _titleArray;
}


@end
