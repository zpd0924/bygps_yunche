//
//  BYShareListGroupPersonCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/29.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYShareListGroupPersonCell.h"
#import "BYGroupShareNode.h"
#import "BYShareCommitParamModel.h"
#import "BYShareUserModel.h"

static CGFloat const indentPointsMargin = 15;
@interface BYShareListGroupPersonCell()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *personLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectLeadingW;

@end

@implementation BYShareListGroupPersonCell


- (void)awakeFromNib {
    [super awakeFromNib];
   
}
- (void)setParamModel:(BYShareCommitParamModel *)paramModel{
    _paramModel = paramModel;
    
}
- (IBAction)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _groupNode.isSelect = sender.selected;
    if (sender.selected) {//选中 增加  这里的groupId为用户id
        if (_paramModel.shareLine.count >= 50) {
            BYShowError(@"最多只能添加50人");
            sender.selected = NO;
            return;
        }
        BYShareUserModel *userModel = [[BYShareUserModel alloc] init];
        userModel.receiveShareUserId = _groupNode.userId;
        userModel.receiveShareUserName = _groupNode.username;
        userModel.userName = _groupNode.loginName;
        [_paramModel.shareLine addObject:userModel];
        
    }else{//未选中 减少
        int flag = 0;
        for (int i = 0; i<_paramModel.shareLine.count; i++) {
            BYShareUserModel *userModel = _paramModel.shareLine[i];
            if ([userModel.receiveShareUserId integerValue] == [_groupNode.userId integerValue]) {
                flag = i;
            }
        }
        [_paramModel.shareLine removeObjectAtIndex:flag];
    }
    if (self.personBlock) {
        self.personBlock(_paramModel);
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   
}

-(void)setGroupNode:(BYGroupShareNode *)groupNode{
    
    _groupNode = groupNode;
    self.personLabel.text = [NSString stringWithFormat:@"%@(%@)",groupNode.loginName,groupNode.username];
    self.selectBtn.selected = groupNode.isSelect;
    CGFloat indentPoints = _groupNode.level * indentPointsMargin;
    self.selectLeadingW.constant = indentPoints;
    if (groupNode.username.length) {//用户cell
        for (BYShareUserModel *userModel in _paramModel.shareLine) {
            if ([userModel.receiveShareUserId integerValue] == [groupNode.userId integerValue] ) {
                self.selectBtn.selected = YES;
            }
        }
        
    }
}
@end
