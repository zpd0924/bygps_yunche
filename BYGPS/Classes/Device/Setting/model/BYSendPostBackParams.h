//
//  BYSendPostBackParams.h
//  BYGPS
//
//  Created by miwer on 16/9/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYSendPostBackParams : NSObject

@property(nonatomic,assign) NSInteger deviceId;
@property(nonatomic,assign) NSInteger type;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,assign) NSInteger mold;//type=1时必选  无线设备才要传此参数 有线传0
@property(nonatomic,strong) NSString * model;//设备类型

/*
 指令类型type说明
 1    回传间隔    （常规模式，追踪模式，心跳模式：时间单位为秒）（固定点模式：可最多设置4个，例子：一个时间点“08:23”则参数传入为0823，两个时间点“08:23”，“13:23”则参数传入为08231323，以此类推）（星期模式：星期和上传时间点以#号隔开，例如：12#0823 代表星期一和星期二的08:23点上传）（026定位模式:0 默认 1 基站+wifi 2 GPS+基站+wifi）
 3    断油电（有线设备才有此指令）    0：断油/断电 1：恢复油电
 4    设备重启（有线设备才有此指令）    指令内容：”reset”
 5    转IP    ip和端口以#号隔开 比如”192.168.1.1#8080”
 6    设置APN（上网接入点）（有线才有）    无
 8    远程升级    版本号
 9    读取CCID（sim卡）（026，027没有）    指令内容:”123”
 12    光感报警（027才有）    0：启用 1：禁用
 13    自定义指令（015，015+才有）    无
 
 
 指令mold说明（无线设备才要传此参数）
 
 1    027追踪模式及其他无线设备常规模式
 2    除027外的无线设备追踪模式
 3    固定点模式
 4    013心跳模式
 7    027星期模式
 8    026定位模式
 
 */


@end
