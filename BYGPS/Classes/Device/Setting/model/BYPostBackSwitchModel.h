//
//  BYPostBackSwitchModel.h
//  BYGPS
//
//  Created by miwer on 2017/2/6.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYPostBackSwitchModel : NSObject

@property(nonatomic,strong) NSString * title;
@property(nonatomic,assign) BOOL isSelect;

+(BYPostBackSwitchModel *)createModelWith:(NSString *)title isSelect:(BOOL)isSelect;

@end
