//
//  BYPostBackModel.h
//  BYGPS
//
//  Created by bean on 16/7/30.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYPostBackModel : NSObject

@property(nonatomic,strong)NSString * title;
@property(nonatomic,strong)NSString * detail;
@property (nonatomic,strong) NSString * unit;
@property(nonatomic,strong)NSString * palceholder;
@property(nonatomic,strong)NSDate * date;
@property (nonatomic,assign) BOOL isSelect;

@property (nonatomic,assign) BOOL saveLightSelected;

+(BYPostBackModel *)createModelWith:(NSString *)title detail:(NSString *)detail placeholder:(NSString *)placeholder unit:(NSString *)unit;

@end
