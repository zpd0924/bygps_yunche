//
//  BYMyEvaluationModel.h
//  xsxc
//
//  Created by ZPD on 2018/5/30.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "JSONModel.h"

@interface BYMyEvaluationModel : JSONModel

@property (nonatomic,strong) NSString *headImgName;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *creatTime;
@property (nonatomic,strong) NSString *carModel;
@property (nonatomic,strong) NSString *evaluation;
@property (nonatomic,assign) double syntheticalScore;
@property (nonatomic,strong) NSMutableArray *images;
@property (nonatomic,assign) CGFloat cell_H;


/****** 评价 *******/
///id评论id
@property (nonatomic,assign) NSInteger ID;
///评论头像
@property (nonatomic,strong) NSString *portrait;
///综合评分
@property (nonatomic,assign) NSInteger compositeScore;
///评论内容
@property (nonatomic,strong) NSString *commentContent;
///是否匿名
@property (nonatomic,assign) NSInteger isAnonymous;
///评论图片，以,隔开
@property (nonatomic,strong) NSString *commentImg;
///评论人名称
@property (nonatomic,strong) NSString *commentUserName;
///评论时间
@property (nonatomic,strong) NSString *commentTime;



+(BYMyEvaluationModel *)creatModelWith:(NSString *)headImgName name:(NSString *)name creatTime:(NSString *)creatTime carmodel:(NSString *)carModel evaluation:(NSString *)evaluation images:(NSMutableArray *)images;




@end
