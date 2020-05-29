//
//  BYMyEvaluationSectionHeadView.h
//  xsxc
//
//  Created by ZPD on 2018/5/30.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYMyEvaluationCountOrScoreModel.h"
@interface BYMyEvaluationSectionHeadView : UIView
@property (nonatomic,assign) NSInteger selectBtnTag;
@property (nonatomic ,strong) BYMyEvaluationCountOrScoreModel *countOrScoreModel;
@property (nonatomic,copy) void(^changeCommentTypeBlock)(NSInteger type);

@end
