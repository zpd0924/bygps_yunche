//
//  BYSearchHistoryDataBase.h
//  BYGPS
//
//  Created by ZPD on 2018/4/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@class BYHistoryModel;
@interface BYSearchHistoryDataBase : NSObject

{
    FMDatabase * _searchHistoryDataBase;
}

+(BYSearchHistoryDataBase *)shareInstance;

-(BOOL)existHistoryWithUser:(NSString *)user;
-(NSMutableArray *)queryHistoryWithUser:(NSString *)user;

-(void)updateHistoryWithUserName:(NSString *)userName controlHistory:(NSString *)history;
-(void)updateHistoryWithUserName:(NSString *)userName deviceListHistory:(NSString *)history;
-(void)updateHistoryWithUserName:(NSString *)userName alarmListHistory:(NSString *)history;
-(void)updateHistoryWithUserName:(NSString *)userName carListHistory:(NSString *)history;
-(BOOL)insertUserName:(NSString *)userName forHistoryModel:(BYHistoryModel *)history;

@end
