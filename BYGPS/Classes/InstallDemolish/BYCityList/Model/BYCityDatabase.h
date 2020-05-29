//
//  BYLoginDatabase.h
//  BYGPS
//
//  Created by miwer on 16/7/25.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@class BYCityModel;

@interface BYCityDatabase : NSObject

{
    FMDatabase * _cityDatabase;
}

+(BYCityDatabase *)shareInstance;

-(BOOL)insertCity:(BYCityModel *)model;

-(NSMutableArray *)queryCitysWith:(NSString *)initial;

-(BYCityModel *)queryCitysWithCityName:(NSString *)cityName;

@end
