//
//  BYEditPersonCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/13.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYEditPersonCell.h"

@interface BYEditPersonCell()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *personLabel;

@end
@implementation BYEditPersonCell

- (void)setModel:(BYShareUserModel *)model{
    _model = model;
    if (model.mobile.length) {//外部人员
        self.personLabel.text = model.mobile;
    }else{//内部人员
        self.personLabel.text = model.receiveShareUserName;
    }
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.numberLabel.text = [NSString stringWithFormat:@"账号%zd",indexPath.row + 1];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deletBtnClick:(UIButton *)sender {
  
    if (self.deletPersonBlock) {
        self.deletPersonBlock(_model);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
