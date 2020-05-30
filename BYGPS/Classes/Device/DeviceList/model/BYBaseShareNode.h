//
//  BYBaseShareNode.h
//  BYGPS
//
//  Created by 李志军 on 2019/1/3.
//  Copyright © 2019 miwer. All rights reserved.
//

#import "JSONModel.h"

@interface BYBaseShareNode : JSONModel
@property(nonatomic,assign)BOOL isExpand;//是否展开
@property(nonatomic,assign)BOOL isGroup;//是否是组
@property(nonatomic,assign)BOOL isSelect;//是否选中
@property(nonatomic,assign)NSInteger level;//缩进等级

@property(nonatomic,assign)NSInteger groupId;//当前组ID
@property(nonatomic,assign)NSInteger parentId;//父节点ID

@property (nonatomic,strong) NSString *loginName;//登录名
@property (nonatomic,strong) NSString *username;//姓名
@property (nonatomic,strong) NSString *userId;//用户id
@end
