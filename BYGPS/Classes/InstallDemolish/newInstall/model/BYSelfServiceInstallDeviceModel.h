//
//  BYSelfServiceInstallDeviceModel.h
//  BYGPS
//
//  Created by ZPD on 2018/9/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "JSONModel.h"

@interface BYSelfServiceInstallDeviceModel : JSONModel

@property (nonatomic,strong) NSString *deviceSn;
@property (nonatomic,strong) NSString *deviceSupplier;
@property (nonatomic,strong) NSString *deviceType;
@property (nonatomic,strong) NSString *devicePosition;
@property (nonatomic,strong) NSString *deviceModel;
///设备型号别名
@property (nonatomic , strong) NSString *alias;

@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *vinDeviceImg;

@property (nonatomic,assign) BOOL positionIsP_HImage;
@property (nonatomic,strong) UIImage *positionUploadImg;

///安装位置示意图url
@property (nonatomic,strong) NSString *positionPlaceHoldImgUrl;



@end
