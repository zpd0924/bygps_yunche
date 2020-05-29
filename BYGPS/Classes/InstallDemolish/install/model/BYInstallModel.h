//
//  BYInstallModel.h
//  父子控制器
//
//  Created by miwer on 2016/12/21.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYInstallModel : NSObject

@property(nonatomic,strong) NSString * title;
@property(nonatomic,strong) NSString * subTitle;
@property(nonatomic,strong) NSString * placeholder;
@property(nonatomic,assign) BOOL isNecessary;
@property(nonatomic,strong) NSString * postKey;
@property (nonatomic,assign) BOOL isFilled;

+(BYInstallModel *)createModelWith:(NSString *)title placeholder:(NSString *)placeholder isNecessary:(BOOL)isNecessary postKey:(NSString *)key;

+(BYInstallModel *)createModelWith:(NSString *)title subTitle:(NSString *)subTitle isNecessary:(BOOL)isNecessary;

@end
