//
//  BYCodeItem.h
//  BYGPS
//
//  Created by miwer on 2017/4/25.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYBaseSettingItem.h"

@interface BYCodeItem : BYBaseSettingItem

@property (nonatomic,copy) void (^codeCallBack) ();

@property (nonatomic,strong) void (^endEditCallBack) (NSString *str);

@end
