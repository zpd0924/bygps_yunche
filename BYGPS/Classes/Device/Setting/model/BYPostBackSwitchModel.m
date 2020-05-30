//
//  BYPostBackSwitchModel.m
//  BYGPS
//
//  Created by miwer on 2017/2/6.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYPostBackSwitchModel.h"

@implementation BYPostBackSwitchModel

+(BYPostBackSwitchModel *)createModelWith:(NSString *)title isSelect:(BOOL)isSelect{
    BYPostBackSwitchModel * model = [[BYPostBackSwitchModel alloc] init];
    model.title = title;
    model.isSelect = isSelect;
    return model;
}

@end
