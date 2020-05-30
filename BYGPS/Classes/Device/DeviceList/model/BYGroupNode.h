//
//  BYDeviceListGroupModel.h
//  BYGPS
//
//  Created by miwer on 16/9/1.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseNode.h"

@interface BYGroupNode : BYBaseNode

@property(nonatomic,strong)NSString * nodeName;
@property(nonatomic,assign)BOOL flag;//1->包含设备 0->不包含设备
@property(nonatomic,strong)NSMutableArray * childs;//子节点数组
@property(nonatomic,assign)NSInteger number;//子节点所含设备

@end


/*
 "parentId": 0,
 "groupId": 995,
 "groupName": "未找到分组的设备",
 "flag": 1,
 "list": [],
 "number": 11
 */

