//
//  BYCmdRecordModel.h
//  BYGPS
//
//  Created by miwer on 16/9/21.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BYCmdRecordModel : JSONModel

@property(nonatomic,strong) NSString * status;//"发送中",
//@property(nonatomic,assign) NSInteger deviceID;
//@property(nonatomic,assign) BOOL flag;
//@property(nonatomic,strong) NSString * finishTime;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) NSString * nickName;//"吴系挂",
@property(nonatomic,strong) NSString * sendTime;//"150364042600",
//@property(nonatomic,assign) NSInteger commandID;
//@property(nonatomic,strong) NSString * response;
@property(nonatomic,strong) NSString * updateTime;//"150364042600",
@property(nonatomic,strong) NSString * content;//"持续时间1560分钟",
//@property(nonatomic,assign) NSInteger contentType;
//@property(nonatomic,strong) NSString * msg;
@property (nonatomic,strong) NSString * mode;//"追踪模式",

@property (nonatomic,assign) CGFloat row_H;

@end

/*
 {
     "Status": 2, 指令状态
     "DeviceID": 235771,
     "Flag": true, 标志位，false未完成（代表：FinishTime是预计完成时间），true完成（FinishTime代表完成时间）
     "FinishTime": "2016-07-21 19:19:24.0",完成时间（接收时间）
     "Type": 3,
     "NickName": "雷佳平",创建人姓名
     "DBServer": 1,
     "SendTime": "2016-07-21 19:15:17.0",发送时间
     "CommandID": 1266,
     "UpdateTime": "2016-07-21 19:16:22.0",
     "Content": "#60##"指令内容
 }
 */
