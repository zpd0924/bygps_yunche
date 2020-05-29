//
//  BYAutoServiceModel.h
//  BYGPS
//
//  Created by ZPD on 2018/12/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYAutoServiceConstant.h"

@interface BYAutoServiceModel : NSObject

@property (nonatomic,assign) BYFunctionType functionType;

@property (nonatomic, strong) UIImage *image;//头像
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *subTitle;//副标题

@property (nonatomic,assign) BOOL isAble;//button是否有效

@property(nonatomic,strong) UIColor * textLabelColor;

@property (nonatomic, assign) Class descVc;

@property (nonatomic, strong) void(^operationBlock)();//处理事件

+ (instancetype)itemWithImage:(NSString *)image title:(NSString *)title;//设置标题和头像

@end
