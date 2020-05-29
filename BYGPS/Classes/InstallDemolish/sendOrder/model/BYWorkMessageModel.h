//
//  BYWorkMessageModel.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/19.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYWorkMessageModel : NSObject<NSCoding>
///派单公司
@property (nonatomic,strong) NSString *sendCompany;
///服务地址
@property (nonatomic,strong) NSString *serverAdress;
///详细地址
@property(nonatomic,copy)NSString *detailAdress;

///
@property (nonatomic , strong) NSString *serviceAddressLon;

@property (nonatomic , strong) NSString *serviceAddressLat;



///派单类型 0 指派 1抢单
@property(nonatomic,assign)NSInteger sendType;
///服务技师id
@property(nonatomic,strong)NSString *serverId;
///服务技师name
@property(nonatomic,strong)NSString *serverName;
///需要审核 0：不需要 1：需要
@property(nonatomic,assign)NSInteger isCheck;
///是否需要审核  0：不需要 1：只需要 2:全部
//@property (nonatomic,assign) NSInteger needToAudit;

///是否操作过是否要审核 1 操作过 0未操作过
@property(nonatomic,assign)NSInteger isSelctCheck;
///拆机原因1 清货拆机、2 关联错误、3 悔货拆机
@property (nonatomic,assign) NSInteger uninstallReson;


@property (nonatomic , assign) BOOL enableClick;


///联系人
@property(nonatomic,copy)NSString *contacts;
///备注
@property (nonatomic,copy) NSString *comment;

///省id
@property (nonatomic,strong) NSString *pid;
///市id
@property (nonatomic,strong) NSString *cityId;
///区id
@property (nonatomic,strong) NSString *areaId;
///省name
@property (nonatomic,strong) NSString *pName;
///市name
@property (nonatomic,strong) NSString *cityName;
///区name
@property (nonatomic,strong) NSString *areaName;
@end
