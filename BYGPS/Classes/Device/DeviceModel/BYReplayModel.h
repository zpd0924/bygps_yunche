//
//  BYReplayModel.h
//  BYGPS
//
//  Created by miwer on 16/9/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BYReplayModel : JSONModel

@property(nonatomic,strong) NSString * gpsTime;
@property(nonatomic,strong) NSString * updateTime;
@property(nonatomic,strong) NSString * speed;
@property(nonatomic,strong) NSString * status;
@property(nonatomic,assign) CGFloat direction;
@property(nonatomic,assign) BOOL driving;
@property(nonatomic,assign) float lng;
@property(nonatomic,assign) float lat;
@property(nonatomic,assign) NSInteger deviceId;
@property(nonatomic,assign) BOOL online;
@property(nonatomic,strong) NSString * stopTime;
@property(nonatomic,strong) NSString * carNum;
@property (nonatomic,strong) NSString * carVin;
@property (nonatomic,assign) NSInteger carId;
@property(nonatomic,strong) NSString * sn;
@property(nonatomic,strong) NSString * locate;
@property (nonatomic,assign) CGFloat pop_H;
@property (nonatomic,strong) NSString * ownerName;

@end


/*
 {
     "alarm": "[0,0,0,0]",
     "gpsTime": "Wed Sep 21 08:57:08 CST 2016",
     "updateTime": "Wed Sep 21 08:57:11 CST 2016",
     "speed": 0,
     "status": "[0,0,3,65]",
     "direction": 0,
     "driving": false,
     "lng": 113.94211,
     "lat": 22.497768,
     "deviceId": 118703,
     "online": true,
     "stopTime": "0"
 }
 */
