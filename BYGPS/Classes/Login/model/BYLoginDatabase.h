//
//  BYLoginDatabase.h
//  BYGPS
//
//  Created by miwer on 16/7/25.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@class BYUserModel;

@interface BYLoginDatabase : NSObject

{
    FMDatabase * _userDatabase;
}

+(BYLoginDatabase *)shareInstance;
-(BOOL)insertUser:(NSString *)username password:(NSString *)password;
- (NSMutableArray *)queryAllUser;
-(NSMutableArray *)queryUsersWithUsername:(NSString *)username;//根据用户名查找存不存在该用户
-(void)deleteUser:(NSString *)username;
-(void)updateUserForLoginTime:(NSString *)username;
-(void)updateUserForUsername:(NSString *)username password:(NSString *)password;

@end
