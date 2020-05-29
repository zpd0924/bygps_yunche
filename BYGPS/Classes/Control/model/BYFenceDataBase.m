//
//  BYFenceDataBase.m
//  BYGPS
//
//  Created by ZPD on 2017/9/1.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYFenceDataBase.h"
#import "BYFenceControl.h"

@implementation BYFenceDataBase

+(BYFenceDataBase *)shareInstance{
    static BYFenceDataBase * helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

-(NSArray *)queryMenWithUserName:(NSString *)user
{
    FMResultSet *result = [_fenceDataBase executeQuery:@"select * from fenceUser where linkName = ?",user];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    while ([result next]){
        
        BYFenceControl * control = [[BYFenceControl alloc] init];
        control.BYControlIsOpenMonitor = [[result stringForColumn:@"control"] boolValue];
        control.BYTrackIsOpenMonitor = [[result stringForColumn:@"track"] boolValue];
        control.BYAlarmIsOpenMonitor = [[result stringForColumn:@"alarm"] boolValue];
        [dataSource addObject:control];
    }
    
    return dataSource;
}
-(BOOL)insertFenceUser:(NSString *)linkName controlIsMonitor:(BOOL)IsControlMonitor trackIsMonitor:(BOOL)IsTrackMonitor alarmIsMonitor:(BOOL)IsAlarmMonitor{
    BOOL success = [_fenceDataBase executeUpdate:@"insert into fenceUser (linkName,control,track,alarm,linkTime) values(?, ?, ? , ? , ?)", linkName, @(IsControlMonitor),@(IsTrackMonitor),@(IsAlarmMonitor), [self getCurrentDate]];
    
    if (!success){
        BYLog(@"插入失败");
    }
    return success;

}
//-(BOOL)insertFenceUser:(NSString *)linkName trackIsMonitor:(BOOL)IsMonitor{
//    BOOL success = [_fenceDataBase executeUpdate:@"insert into fenceUser (linkName,track,linkTime) values(?, ?, ?)", linkName, @(IsMonitor), [self getCurrentDate]];
//    
//    if (!success){
//        BYLog(@"插入失败");
//    }
//    return success;
//
//}
//-(BOOL)insertFenceUser:(NSString *)linkName alarmIsMonitor:(BOOL)IsMonitor{
//    BOOL success = [_fenceDataBase executeUpdate:@"insert into fenceUser (linkName,alarm,linkTime) values(?, ?, ?)", linkName, @(IsMonitor), [self getCurrentDate]];
//    
//    if (!success){
//        BYLog(@"插入失败");
//    }
//    return success;
//}
//-(BOOL)queryMenWithLinkPhone:(NSString *)linkPhone;
-(NSMutableArray *)queryAllLinkMen{
    FMResultSet *result = [_fenceDataBase executeQuery:@"select * from fenceUser"];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    while ([result next]){
        
        BYFenceControl * control = [[BYFenceControl alloc] init];
        control.BYControlIsOpenMonitor = [result stringForColumn:@"control"];
        control.BYTrackIsOpenMonitor = [result stringForColumn:@"track"];
        control.BYAlarmIsOpenMonitor = [result stringForColumn:@"alarm"];
        [dataSource addObject:control];
    }
    
    return dataSource;
}
-(void)deleteMan:(NSString *)userName{
    if (![_fenceDataBase executeUpdate:@"delete from fenceUser where linkName = ?",userName]) {
        BYLog(@"删除失败");
    }
}
-(void)updateUserWithControlIsMonitor:(BOOL)IsMonitor user:(NSString *)user
{
    if (![_fenceDataBase executeUpdate:@"update fenceUser set control = ?, linkTime = ? where linkName = ?",@(IsMonitor),[self getCurrentDate], user]) {
        BYLog(@"更新失败");
    }
}
-(void)updateUserWithTrackIsMonitor:(BOOL)IsMonitor user:(NSString *)user{
    if (![_fenceDataBase executeUpdate:@"update fenceUser set track = ?, linkTime = ? where linkName = ?",@(IsMonitor),[self getCurrentDate],user]) {
        BYLog(@"更新失败");
    }
}
-(void)updateUserWithAlarmIsMonitor:(BOOL)IsMonitor user:(NSString *)user{
    if (![_fenceDataBase executeUpdate:@"update fenceUser set alarm = ?, linkTime = ? where linkName = ?",@(IsMonitor),[self getCurrentDate], user ]) {
        BYLog(@"更新失败");
    }
}

-(void)createTable{
    
    if (![_fenceDataBase executeUpdate:@"create table if not exists fenceUser(linkName text primary key, control text,track text,alarm text, linkTime text)"]) {
        BYLog(@"创建表失败");
    }
}


-(void)createDatabase{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"FenceUser.db"];
    _fenceDataBase = [FMDatabase databaseWithPath:path];
    if (![_fenceDataBase open]) {
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

-(NSString *)getCurrentDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate date]];
}


@end
