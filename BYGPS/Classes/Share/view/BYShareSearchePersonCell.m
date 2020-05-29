//
//  BYShareSearchePersonCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/28.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYShareSearchePersonCell.h"
#import "BYShareUserModel.h"
@interface BYShareSearchePersonCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *groupNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end
@implementation BYShareSearchePersonCell
- (IBAction)addBtnClick:(UIButton *)sender {
    if (sender.selected) {
        BYShowSuccess(@"已经添加过了哦");
        return;
    }
    if (self.addPersonBlock) {
        self.addPersonBlock(_model);
    }
}
- (void)setParamModel:(BYShareCommitParamModel *)paramModel{
    _paramModel = paramModel;
    
}

- (void)setModel:(BYCompanyModel *)model{
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@(%@)",model.loginName,model.userName];
    self.groupNameLabel.text = model.groupName;
    for (BYShareUserModel *userModel in _paramModel.shareLine) {//判断是否添加过
        if ([userModel.receiveShareUserId integerValue] == [model.userId integerValue]) {
            self.addBtn.selected = YES;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
