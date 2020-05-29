//
//  BYBaseNode.h
//  BYGPS
//
//  Created by miwer on 16/9/2.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <JSONModel.h>

@interface BYBaseNode : JSONModel

@property(nonatomic,assign)BOOL isExpand;//是否展开
@property(nonatomic,assign)BOOL isGroup;//是否是组
@property(nonatomic,assign)BOOL isSelect;//是否选中
@property(nonatomic,assign)NSInteger level;//缩进等级

@property(nonatomic,assign)NSInteger groupId;//当前组ID
@property(nonatomic,assign)NSInteger parentId;//父节点ID

@property (nonatomic,strong) NSString *loginName;//登录名
@property (nonatomic,strong) NSString *username;//姓名
@end
