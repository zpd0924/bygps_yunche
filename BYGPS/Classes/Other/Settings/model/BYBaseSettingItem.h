//
//  BYBaseSettingItem.h
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYBaseSettingItem : NSObject

@property (nonatomic, strong) UIImage *image;//头像
@property (nonatomic, strong) NSString *title;//标题
@property (nonatomic, strong) NSString *subTitle;//副标题

@property (nonatomic,assign) BOOL isAble;//button是否有效

@property(nonatomic,strong) UIColor * textLabelColor;

@property (nonatomic, strong) void(^operationBlock)();//处理事件

+ (instancetype)itemWithImage:(NSString *)image title:(NSString *)title;//设置标题和头像

@end
