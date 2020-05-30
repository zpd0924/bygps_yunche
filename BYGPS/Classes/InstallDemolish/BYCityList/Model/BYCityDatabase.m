//
//  BYLoginDatabase.m
//  BYGPS
//
//  Created by miwer on 16/7/25.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYCityDatabase.h"
#import "BYCityModel.h"

@implementation BYCityDatabase

/*
 "city_id": "225",
 "city_name": "阿克苏",
 "admin_code": "652900",
 "initial": "A",
 "prov_id": "32",
 "prov_name": "新疆"
 */
-(BYCityModel *)queryCitysWithCityName:(NSString *)cityName{
    
    FMResultSet *result = [_cityDatabase executeQuery:@"select * from citys where city_name = ?",cityName];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    while ([result next])
    {
        BYCityModel * city = [[BYCityModel alloc] init];
        
        city.cityId = [result stringForColumn:@"city_id"];
        city.name = [result stringForColumn:@"city_name"];
        city.pinyin = [result stringForColumn:@"pinyin"];
        city.shortName = [result stringForColumn:@"short_name"];
        city.lat = [result stringForColumn:@"lat"];
        city.lng = [result stringForColumn:@"lng"];
        city.initial = [result stringForColumn:@"initial"];
        
        [dataSource addObject:city];
    }
    
    return  dataSource.firstObject;
}

-(NSMutableArray *)queryCitysWith:(NSString *)initial{

    FMResultSet *result = [_cityDatabase executeQuery:@"select * from citys where initial = ?",initial];
    NSMutableArray *dataSource = [[NSMutableArray alloc] init];
    while ([result next])
    {
        BYCityModel * city = [[BYCityModel alloc] init];
        
        city.cityId = [result stringForColumn:@"city_id"];
        city.name = [result stringForColumn:@"city_name"];
        city.pinyin = [result stringForColumn:@"pinyin"];
        city.shortName = [result stringForColumn:@"short_name"];
        city.lat = [result stringForColumn:@"lat"];
        city.lng = [result stringForColumn:@"lng"];
        city.initial = [result stringForColumn:@"initial"];
        
        [dataSource addObject:city];
    }

    return  dataSource;
}

-(BOOL)insertCity:(BYCityModel *)model{
    
    BOOL success = [_cityDatabase executeUpdate:@"insert into citys (city_id,city_name,pinyin,short_name,lat,lng,initial) values(?, ?, ?, ?, ?, ?,?)", model.cityId, model.name, model.pinyin,model.shortName,model.lat,model.lng,model.initial];
    
    if (!success){
        BYLog(@"插入失败");
    }
    return success;
}

-(void)createTable{
    
    if (![_cityDatabase executeUpdate:@"create table if not exists citys(id integer primary key autoincrement,city_id text, city_name text, pinyin text, short_name text, lat text, lng text,initial text)"]) {
        BYLog(@"创建表失败");
    }
}

-(void)createDatabase{
    
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"carCity.db"];
 
    _cityDatabase = [FMDatabase databaseWithPath:path];
    
    BYLog(@"path : %@",path);
    if (![_cityDatabase open]) {
        BYLog(@"打开数据库失败");
    }
}

-(instancetype)init{
    if (self = [super init]) {
        
        [self createDatabase];
        [self createTable];
        
    }
    return self;
}

+(BYCityDatabase *)shareInstance{
    
    static BYCityDatabase * helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[self alloc] init];
    });
    return helper;
}

@end
