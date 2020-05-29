//
//  BYSendBreakingOilParams.h
//  BYGPS
//
//  Created by ZPD on 2017/11/16.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYSendBreakingOilParams : NSObject

@property (nonatomic,assign) NSInteger deviceId;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *model;
//@property (nonatomic,strong) NSString *levelPassWord;

@end
