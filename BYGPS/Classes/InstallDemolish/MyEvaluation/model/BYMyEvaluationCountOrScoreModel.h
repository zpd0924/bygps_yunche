//
//  BYMyEvaluationCountOrScoreModel.h
//  xsxc
//
//  Created by 李志军 on 2018/6/25.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "JSONModel.h"

@interface BYMyEvaluationCountOrScoreModel : JSONModel
///全部
@property (nonatomic,assign) NSInteger all;
///好评
@property (nonatomic,assign) NSInteger praise;
///差评
@property (nonatomic,assign) NSInteger bad;
///中评
@property (nonatomic,assign) NSInteger middle;
///服务评分
@property (nonatomic,assign) NSInteger serviceScore;
///效率评分
@property (nonatomic,assign) NSInteger efficiencyScore;


@end
