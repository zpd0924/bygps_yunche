//
//  BYMyEvaluationHeadView.h
//  xsxc
//
//  Created by ZPD on 2018/5/30.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYMyEvaluationCountOrScoreModel.h"

typedef void(^BYMyEvaluationHeadViewBlock)(NSInteger countStar);

@interface BYMyEvaluationHeadView : UIView

@property (nonatomic,strong) NSArray *starArr;
///是否是提交评论
@property (nonatomic,assign) BOOL isCommitEvaluation;
@property (nonatomic,copy) BYMyEvaluationHeadViewBlock serveMarkBlock;
@property (nonatomic,copy) BYMyEvaluationHeadViewBlock efficiencyBlock;
@property (nonatomic ,strong) BYMyEvaluationCountOrScoreModel *countOrScoreModel;
@end

