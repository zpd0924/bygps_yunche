//
//  BYGroupShareNode.h
//  BYGPS
//
//  Created by 李志军 on 2019/1/3.
//  Copyright © 2019 miwer. All rights reserved.
//

#import "BYBaseShareNode.h"

@interface BYGroupShareNode : BYBaseShareNode
@property(nonatomic,strong)NSString * nodeName;
@property(nonatomic,assign)BOOL flag;//1->包含设备 0->不包含设备
@property(nonatomic,strong)NSMutableArray * childs;//子节点数组
@property(nonatomic,assign)NSInteger number;//子节点所含设备
@end
