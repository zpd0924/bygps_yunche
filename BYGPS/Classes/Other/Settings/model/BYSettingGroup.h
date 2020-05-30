//
//  BYSettingGroup.h
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYSettingGroup : NSObject

@property (nonatomic, strong) NSString *headTitle;

@property (nonatomic, strong) NSString *footTitle;

@property (nonatomic, strong) NSArray *items;// 描述当前组有多少行,items:cell对应的模型


@end
