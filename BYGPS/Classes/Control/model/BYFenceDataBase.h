//
//  BYFenceDataBase.h
//  BYGPS
//
//  Created by ZPD on 2017/9/1.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB.h>

@interface BYFenceDataBase : NSObject
{
    FMDatabase * _fenceDataBase;
}

+(BYFenceDataBase *)shareInstance;
-(BOOL)insertFenceUser:(NSString *)linkName controlIsMonitor:(BOOL)IsMonitor trackIsMonitor:(BOOL)IsMonitor alarmIsMonitor:(BOOL)IsMonitor;
//-(BOOL)insertFenceUser:(NSString *)linkName trackIsMonitor:(BOOL)IsMonitor;
//-(BOOL)insertFenceUser:(NSString *)linkName alarmIsMonitor:(BOOL)IsMonitor;
-(NSArray *)queryMenWithUserName:(NSString *)user;
//-(NSArray *)queryMenWithUserName:(NSString *)user;
-(NSMutableArray *)queryAllLinkMen;
-(void)deleteMan:(NSString *)linkPhone;
-(void)updateUserWithControlIsMonitor:(BOOL)IsMonitor user:(NSString *)user;
-(void)updateUserWithTrackIsMonitor:(BOOL)IsMonitor user:(NSString *)user;
-(void)updateUserWithAlarmIsMonitor:(BOOL)IsMonitor user:(NSString *)user;
@end
