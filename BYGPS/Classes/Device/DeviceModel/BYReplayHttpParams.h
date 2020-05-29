//
//  BYReplayHttpParams.h
//  BYGPS
//
//  Created by miwer on 16/9/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYReplayHttpParams : NSObject

@property(nonatomic,assign) NSInteger deviceid;
@property (nonatomic,strong) NSString *sn;
@property(nonatomic,strong) NSString * startTime;
@property(nonatomic,strong) NSString * endTime;
@property(nonatomic,assign) BOOL gps;
@property(nonatomic,assign) BOOL speed;
@property(nonatomic,assign) BOOL stopKM;
@property (nonatomic,assign) BOOL flameOut;

@end
