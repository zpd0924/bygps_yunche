//
//  BYAutoServiceModel.m
//  BYGPS
//
//  Created by ZPD on 2018/12/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceModel.h"

@implementation BYAutoServiceModel

+ (instancetype)itemWithImage:(NSString *)image title:(NSString *)title
{
    BYAutoServiceModel *item = [[self alloc] init];
    
    item.image = [UIImage imageNamed:image];
    item.title = title;
    
    return item;
}

@end
