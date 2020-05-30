//
//  BYBaseSettingItem.m
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseSettingItem.h"

@implementation BYBaseSettingItem

+ (instancetype)itemWithImage:(NSString *)image title:(NSString *)title
{
    BYBaseSettingItem *item = [[self alloc] init];
    
    item.image = [UIImage imageNamed:image];
    item.title = title;
    
    return item;
}

@end
