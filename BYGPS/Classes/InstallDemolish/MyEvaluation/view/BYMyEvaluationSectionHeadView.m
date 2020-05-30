//
//  BYMyEvaluationSectionHeadView.m
//  xsxc
//
//  Created by ZPD on 2018/5/30.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYMyEvaluationSectionHeadView.h"

@interface BYMyEvaluationSectionHeadView ()

@property (nonatomic,strong) UIButton *seletButton;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodBtn;

@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *badBtn;

@end

@implementation BYMyEvaluationSectionHeadView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setCountOrScoreModel:(BYMyEvaluationCountOrScoreModel *)countOrScoreModel{
    _countOrScoreModel = countOrScoreModel;
    [_allBtn setTitle:[NSString stringWithFormat:@"全部%zd",countOrScoreModel.all?countOrScoreModel.all:0] forState:UIControlStateNormal];
    [_goodBtn setTitle:[NSString stringWithFormat:@"好评%zd",countOrScoreModel.praise?countOrScoreModel.praise:0] forState:UIControlStateNormal];
    [_middleBtn setTitle:[NSString stringWithFormat:@"中评%zd",countOrScoreModel.middle?countOrScoreModel.middle:0] forState:UIControlStateNormal];
    [_badBtn setTitle:[NSString stringWithFormat:@"差评%zd",countOrScoreModel.bad?countOrScoreModel.bad:0] forState:UIControlStateNormal];
}

-(void)setSelectBtnTag:(NSInteger)selectBtnTag
{
    //    501 502 503 504
    _selectBtnTag = selectBtnTag;
    self.seletButton = (UIButton *)[self viewWithTag:selectBtnTag];
    self.seletButton.selected = YES;
    self.seletButton.backgroundColor = [UIColor colorWithHex:@"#0097FE"];
    [self.seletButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)evaluationType:(UIButton *)sender {
    if (self.seletButton == nil) {
        sender.selected = YES;
        self.seletButton = sender;
    }else if (self.seletButton != nil&&self.seletButton == sender){
        sender.selected = YES;
    }else if (self.seletButton != sender&&self.seletButton != nil){
        self.seletButton.selected = NO;
        self.seletButton.backgroundColor = [UIColor whiteColor];
        [self.seletButton setTitleColor:[UIColor colorWithHex:@"#909090"] forState:UIControlStateNormal];
        sender.selected = YES;
        self.seletButton = sender;
    }
    self.seletButton.backgroundColor = [UIColor colorWithHex:@"#0097FE"];
    [self.seletButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (self.changeCommentTypeBlock) {
        self.changeCommentTypeBlock(sender.tag - 501);
    }
    
}

@end
