//
//  BYWorkMessageModel.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/19.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYWorkMessageModel.h"
// 当将一个自定义对象保存到文件的时候就会调用该方法
// 在该方法中说明如何存储自定义对象的属性
// 也就说在该方法中说清楚存储自定义对象的哪些属性
@implementation BYWorkMessageModel

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    NSLog(@"调用了encodeWithCoder:方法");
    [aCoder encodeObject:self.detailAdress forKey:@"detailAdress"];
    [aCoder encodeObject:self.serverAdress forKey:@"serverAdress"];

    [aCoder encodeInteger:self.sendType forKey:@"sendType"];
    [aCoder encodeObject:self.serverId forKey:@"serverId"];
    [aCoder encodeObject:self.serverName forKey:@"serverName"];
    [aCoder encodeInteger:self.isCheck forKey:@"isCheck"];
    [aCoder encodeInteger:self.isSelctCheck forKey:@"isSelctCheck"];
    [aCoder encodeInteger:self.uninstallReson forKey:@"uninstallReson"];

    [aCoder encodeObject:self.contacts forKey:@"contacts"];
    [aCoder encodeObject:self.comment forKey:@"comment"];

     [aCoder encodeObject:self.pid forKey:@"pid"];
     [aCoder encodeObject:self.cityId forKey:@"cityId"];
     [aCoder encodeObject:self.areaId forKey:@"areaId"];
     [aCoder encodeObject:self.pName forKey:@"pName"];
     [aCoder encodeObject:self.cityName forKey:@"cityName"];
     [aCoder encodeObject:self.areaName forKey:@"areaName"];
     [aCoder encodeObject:self.serviceAddressLat forKey:@"serviceAddressLat"];
     [aCoder encodeObject:self.serviceAddressLon forKey:@"serviceAddressLon"];
}

// 当从文件中读取一个对象的时候就会调用该方法
// 在该方法中说明如何读取保存在文件中的对象
// 也就是说在该方法中说清楚怎么读取文件中的对象
- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"调用了initWithCoder:方法");
    //注意：在构造方法中需要先初始化父类的方法
    if (self=[super init]) {
        self.detailAdress = [aDecoder decodeObjectForKey:@"detailAdress"];
        self.serverAdress = [aDecoder decodeObjectForKey:@"serverAdress"];
        
        self.sendType = [aDecoder decodeIntegerForKey:@"sendType"];
        self.serverId = [aDecoder decodeObjectForKey:@"serverId"];
        self.serverName = [aDecoder decodeObjectForKey:@"serverName"];
        self.isCheck = [aDecoder decodeIntegerForKey:@"isCheck"];
        self.isSelctCheck = [aDecoder decodeIntegerForKey:@"isSelctCheck"];
        self.uninstallReson = [aDecoder decodeIntegerForKey:@"uninstallReson"];
        
        self.contacts = [aDecoder decodeObjectForKey:@"contacts"];
        self.comment = [aDecoder decodeObjectForKey:@"comment"];
        
        self.pid = [aDecoder decodeObjectForKey:@"pid"];
        self.cityId = [aDecoder decodeObjectForKey:@"cityId"];
        self.areaId = [aDecoder decodeObjectForKey:@"areaId"];
        self.pName = [aDecoder decodeObjectForKey:@"pName"];
        self.cityName = [aDecoder decodeObjectForKey:@"cityName"];
        self.areaName = [aDecoder decodeObjectForKey:@"areaName"];
        self.serviceAddressLat = [aDecoder decodeObjectForKey:@"serviceAddressLat"];
        self.serviceAddressLon = [aDecoder decodeObjectForKey:@"serviceAddressLon"];
     
    }
    return self;
}

@end
