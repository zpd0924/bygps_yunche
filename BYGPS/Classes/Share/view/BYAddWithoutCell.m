//
//  BYAddWithoutCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYAddWithoutCell.h"
#import "BYRegularTool.h"
@interface BYAddWithoutCell()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *errorTipBtn;
@property (weak, nonatomic) IBOutlet UIView *errorLine;

@end
@implementation BYAddWithoutCell

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.numberLabel.text = [NSString stringWithFormat:@"账号%zd:" ,indexPath.row+1];
}

//内部人员
- (void)setInsideModel:(BYShareUserModel *)insideModel{
    _insideModel = insideModel;
    _textField.enabled = NO;
    self.errorLine.hidden = YES;
    self.errorTipBtn.hidden = YES;
    self.textField.text = [NSString stringWithFormat:@"%@(%@)",insideModel.userName,insideModel.receiveShareUserName];
    
}
//外部人员
- (void)setWithoutModel:(BYShareUserModel *)withoutModel{
    _withoutModel = withoutModel;
     _textField.enabled = YES;
    if (withoutModel.mobile.length && !withoutModel.isValid) {
        self.errorLine.hidden = NO;
        self.errorTipBtn.hidden = NO;
    }else{
        self.errorLine.hidden = YES;
        self.errorTipBtn.hidden = YES;
    }
    _textField.text = withoutModel.mobile;
}
- (IBAction)editingEnd:(UITextField *)sender {
    if (self.cellEditEndBlock) {

        _withoutModel.isValid = [BYRegularTool isValidPhone:sender.text];
        _withoutModel.mobile = sender.text;
       
        self.cellEditEndBlock(_withoutModel);
    }
}
- (IBAction)delectBtnClick:(UIButton *)sender {
    if (self.cellDelectBlcok) {
        if (_shareAddType == BYInsideType) {
            self.cellDelectBlcok(_insideModel);
        }else{
            self.cellDelectBlcok(_withoutModel);
        }
        
    }
}

@end
