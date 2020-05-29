//
//  BYChoiceEngineerCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYChoiceEngineerCell.h"
#import "BYEvaluationStarView.h"

@interface BYChoiceEngineerCell()
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *starCountView;
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *commonLabel;
@property (nonatomic,strong) BYEvaluationStarView *evaluationStarView;


@end
@implementation BYChoiceEngineerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.commonLabel.layer.cornerRadius = 2;
    self.commonLabel.layer.masksToBounds = YES;
    self.commonLabel.backgroundColor = BYBackViewColor;
    self.commonLabel.textColor = BYGlobalGreenColor;
    [self.starCountView addSubview:self.evaluationStarView];
}

- (void)setModel:(BYChoiceEngineerModel *)model{
    _model = model;
    self.nameLabel.text = model.nickName;
    self.evaluationStarView.lightCount = (int)model.compositeScore;
    self.starCountLabel.text = [NSString stringWithFormat:@"%zd星",model.compositeScore];
    self.commonLabel.hidden = !model.isUse;
    if (model.isSelect) {
        self.selectImageView.image = [UIImage imageNamed:@"choiceEngineer_sel"];
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"choiceEngineer_def"];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(BYEvaluationStarView*)evaluationStarView
{
    if (!_evaluationStarView) {
        _evaluationStarView = [[BYEvaluationStarView alloc] initWithFrame:self.starCountView.bounds];
        _evaluationStarView.isSmallStar = YES;
        _evaluationStarView.lightCount = 3;
        _evaluationStarView.allCount = 5;
        
        
    }
    return _evaluationStarView;
}

@end
