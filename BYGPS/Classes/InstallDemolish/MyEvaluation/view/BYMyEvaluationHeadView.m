//
//  BYMyEvaluationHeadView.m
//  xsxc
//
//  Created by ZPD on 2018/5/30.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYMyEvaluationHeadView.h"
#import "BYEvaluationStarView.h"
#import "TggStarEvaluationView.h"

@interface BYMyEvaluationHeadView ()

@property (weak, nonatomic) IBOutlet UIView *serveMarkView;
@property (weak, nonatomic) IBOutlet UIView *efficiencyMarkView;



@property (weak, nonatomic) IBOutlet UILabel *serveMarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *efficiencyLabel;

@property (nonatomic,strong) TggStarEvaluationView *tggStarEvaView;//服务评分
@property (nonatomic,strong) TggStarEvaluationView *tggStarEvaView1;//效率评分

@end

@implementation BYMyEvaluationHeadView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    
}
- (void)setCountOrScoreModel:(BYMyEvaluationCountOrScoreModel *)countOrScoreModel{
    _countOrScoreModel = countOrScoreModel;
    if (countOrScoreModel.serviceScore >= 4.5) {
        self.serveMarkLabel.text = [NSString stringWithFormat:@"%zd.0高",countOrScoreModel.serviceScore];
    }else if (countOrScoreModel.serviceScore >= 3 && countOrScoreModel.serviceScore < 4.5){
        self.serveMarkLabel.text = [NSString stringWithFormat:@"%zd.0中",countOrScoreModel.serviceScore];
    }else{
        self.serveMarkLabel.text = [NSString stringWithFormat:@"%zd.0低",countOrScoreModel.serviceScore];
    }
    
    if (countOrScoreModel.efficiencyScore >= 4.5) {
        self.efficiencyLabel.text = [NSString stringWithFormat:@"%zd.0高",countOrScoreModel.efficiencyScore];
    }else if (countOrScoreModel.efficiencyScore >= 3 && countOrScoreModel.efficiencyScore < 4.5){
        self.efficiencyLabel.text = [NSString stringWithFormat:@"%zd.0中",countOrScoreModel.efficiencyScore];
    }else{
        self.efficiencyLabel.text = [NSString stringWithFormat:@"%zd.0低",countOrScoreModel.efficiencyScore];
    }
    self.tggStarEvaView.starCount = countOrScoreModel.serviceScore;
    self.tggStarEvaView1.starCount = countOrScoreModel.efficiencyScore;
}
- (void)setIsCommitEvaluation:(BOOL)isCommitEvaluation{
    _isCommitEvaluation = isCommitEvaluation;
    
        BYWeakSelf;

        self.tggStarEvaView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
            NSLog(@"\n\n给了谁：%ld星好评！！!\n\n",count);
            if (count >= 4.5) {
                weakSelf.serveMarkLabel.text = [NSString stringWithFormat:@"%zd.0高",count];
            }else if (count >= 3 && count < 4.5){
                 weakSelf.serveMarkLabel.text = [NSString stringWithFormat:@"%zd.0中",count];
            }else{
                 weakSelf.serveMarkLabel.text = [NSString stringWithFormat:@"%zd.0低",count];
            }
            if (weakSelf.serveMarkBlock) {
                weakSelf.serveMarkBlock(count);
            }
        }];
        self.tggStarEvaView.starCount = 5;
        self.tggStarEvaView.frame = self.serveMarkView.bounds;
        [self.serveMarkView addSubview:self.tggStarEvaView];
        self.tggStarEvaView.tapEnabled = isCommitEvaluation;
        self.tggStarEvaView1 = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
            if (count >= 4.5) {
                weakSelf.efficiencyLabel.text = [NSString stringWithFormat:@"%zd.0高",count];
            }else if (count >= 3 && count < 4.5){
                weakSelf.efficiencyLabel.text = [NSString stringWithFormat:@"%zd.0中",count];
            }else{
                weakSelf.efficiencyLabel.text = [NSString stringWithFormat:@"%zd.0低",count];
            }
            if (weakSelf.efficiencyBlock) {
                weakSelf.efficiencyBlock(count);
            }
            
        }];
        self.tggStarEvaView1.starCount = 5;
        self.tggStarEvaView1.frame = self.efficiencyMarkView.bounds;
        [self.efficiencyMarkView addSubview:self.tggStarEvaView1];
         self.tggStarEvaView1.tapEnabled = isCommitEvaluation;
    
}


-(void)setStarArr:(NSArray *)starArr{
    _starArr = starArr;
   
}


@end
