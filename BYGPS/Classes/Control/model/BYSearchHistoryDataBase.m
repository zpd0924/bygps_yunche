//
//  BYSearchHistoryDataBase.m
//  BYGPS
//
//  Created by ZPD on 2018/4/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYSearchHistoryDataBase.h"
#import "BYHistoryModel.h"

@implementation BYSearchHistoryDataBase


-(BOOL)existHistoryWithUser:(NSString *)user{
    
    FMResultSet *result = [_searchHistoryDataBase executeQuery:@"select * from historyTable where userName = ?",user];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    while ([result next]){
        BYHistoryModel *history = [[BYHistoryModel alloc] init];
        history.userName = [result stringForColumn:@"userName"];
        history.controlHistory = [result stringForColumn:@"controlHistory"];
        history.deviceListHistory = [result stringForColumn:@"deviceListHistory"];
        history.alarmListHistory = [result stringForColumn:@"alarmListHistory"];
        history.carListHistory = [result stringForColumn:@"carListHistory"];
        [dataSource addObject:history];
    }

    return dataSource.count == 0 ? NO : YES;
}

-(NSMutableArray *)queryHistoryWithUser:(NSString *)user
{
    FMResultSet *result = [_searchHistoryDataBase executeQuery:@"select * from historyTable where userName = ?",user];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    while ([result next]){

        BYHistoryModel *history = [[BYHistoryModel alloc] init];
        history.userName = [result stringForColumn:@"userName"];
        history.controlHistory = [result stringForColumn:@"controlHistory"];
        history.deviceListHistory = [result stringForColumn:@"deviceListHistory"];
        history.alarmListHistory = [result stringForColumn:@"alarmListHistory"];
        history.carListHistory = [result stringForColumn:@"carListHistory"];
        [dataSource addObject:history];
    }
    
    return dataSource;
}

-(void)updateHistoryWithUserName:(NSString *)userName controlHistory:(NSString *)history{
    
    if (![_searchHistoryDataBase executeUpdate:@"update historyTable set controlHistory = ? where userName = ?",history,userName]) {
        BYLog(@"更新失败");
    }
}

-(void)updateHistoryWithUserName:(NSString *)userName deviceListHistory:(NSString *)history
{
    if (![_searchHistoryDataBase executeUpdate:@"update historyTable set deviceListHistory = ? where userName = ?",history,userName]) {
        BYLog(@"更新失败");
    }
}

-(void)updateHistoryWithUserName:(NSString *)userName alarmListHistory:(NSString *)history
{
    if (![_searchHistoryDataBase executeUpdate:@"update historyTable set alarmListHistory = ? where userName = ?",history,userName]) {
        BYLog(@"更新失败");
    }
}
-(void)updateHistoryWithUserName:(NSString *)userName carListHistory:(NSString *)history
{
    if (![_searchHistoryDataBase executeUpdate:@"update historyTable set carListHistory = ? where userName = ?",history,userName]) {
        BYLog(@"更新失败");
    }
}
//-(void)deleteHistoryForUserName:(NSString *)userName{
//    if (![_searchHistoryDataBase executeUpdate:@"delete from historyTable where userName = ?",userName]) {
//        BYLog(@"删除失败");
//    }
//}

-(BOOL)insertUserName:(NSString *)userName forHistoryModel:(BYHistoryModel *)history{
    
    BOOL success = [_searchHistoryDataBase executeUpdate:@"insert into historyTable values(?,?,?,?,?)", userName, history.controlHistory,history.deviceListHistory,history.alarmListHistory,history.carListHistory];
    
    if (!success){
        BYLog(@"插入失败");
    }
    return success;
}

-(void)createTable{
    
    if (![_searchHistoryDataBase executeUpdate:@"create table if not exists historyTable(userName text primary key, controlHistory text , deviceListHistory text , alarmListHistory text , carListHistory text)"]) {
//        创建表。字段：userName , controlHistory , deviceListHistory , alarmListHistory,
        BYLog(@"创建表失败");
    }
}

-(void)createDatabase{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"SearchHistory.db"];
    _searchHistoryDataBase = [FMDatabase databaseWithPath:path];
    if (![_searchHistoryDataBase open]) {
        BYLog(@"创建数据库失败");
    }
}

-(instancetype)init{
    if (self = [super init]) {
        
        [self createDatabase];
        [self createTable];
        
    }
    return self;
}

+(BYSearchHistoryDataBase *)shareInstance{
    
    static BYSearchHistoryDataBase * helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

-(NSString *)getCurrentDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}



@end
