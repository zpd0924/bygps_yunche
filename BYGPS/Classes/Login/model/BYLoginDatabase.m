//
//  BYLoginDatabase.m
//  BYGPS
//
//  Created by miwer on 16/7/25.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYLoginDatabase.h"
#import "BYUserModel.h"

@implementation BYLoginDatabase

-(NSMutableArray *)queryUsersWithUsername:(NSString *)username{
    
    FMResultSet *result = [_userDatabase executeQuery:@"select * from users where username = ?",username];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    while ([result next])
    {
        BYUserModel *user = [[BYUserModel alloc] init];
        user.username = [result stringForColumn:@"username"];
        user.password = [result stringForColumn:@"password"];
        user.loginTime = [result stringForColumn:@"loginTime"];
        [dataSource addObject:user];
    }
    
    return dataSource;
}

-(void)updateUserForLoginTime:(NSString *)username{
    if (![_userDatabase executeUpdate:@"update users set loginTime = ? where username = ?",[self getCurrentDate], username]) {
        BYLog(@"更新失败");
    }
}

-(void)updateUserForUsername:(NSString *)username password:(NSString *)password{
    if (![_userDatabase executeUpdate:@"update users set password = ? where username = ?",password, username]) {
        BYLog(@"更新失败");
    }
}

-(void)deleteUser:(NSString *)username{
    if (![_userDatabase executeUpdate:@"delete from users where username = ?",username]) {
        BYLog(@"删除失败");
    }
}

-(NSMutableArray *)queryAllUser{
    
    FMResultSet *result = [_userDatabase executeQuery:@"select * from users order by loginTime desc"];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    while ([result next])
    {
        BYUserModel *user = [[BYUserModel alloc] init];
        user.username = [result stringForColumn:@"username"];
        user.password = [result stringForColumn:@"password"];
        user.loginTime = [result stringForColumn:@"loginTime"];
        [dataSource addObject:user];
    }
    
    return  dataSource;
}

-(BOOL)insertUser:(NSString *)username password:(NSString *)password{
    
    BOOL success = [_userDatabase executeUpdate:@"insert into users values(?, ?, ?)", username, password, [self getCurrentDate]];
    
    if (!success){
        BYLog(@"插入失败");
    }
    return success;
}

-(void)createDatabase{
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"User.db"];
    _userDatabase = [FMDatabase databaseWithPath:path];
    if (![_userDatabase open]) {
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
-(void)createTable{

    if (![_userDatabase executeUpdate:@"create table if not exists users(username text primary key, password text, loginTime text)"]) {
        BYLog(@"创建表失败");
    }
}

+(BYLoginDatabase *)shareInstance{
    
    static BYLoginDatabase * helper = nil;
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
