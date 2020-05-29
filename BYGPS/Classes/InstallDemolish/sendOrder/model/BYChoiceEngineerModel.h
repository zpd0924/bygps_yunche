//
//  BYChoiceEngineerModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/19.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYChoiceEngineerModel : NSObject
///姓名
@property (nonatomic,strong) NSString *nickName;
///用户ID
@property (nonatomic,assign) NSInteger ID;
///评级
@property (nonatomic,assign) NSInteger compositeScore;
///是否常用 1：是 0：否
@property (nonatomic,assign) NSInteger isUse;
///是否被选中
@property (nonatomic,assign) BOOL isSelect;
@end
