//
//  BYDeviceTypeModel.h
//  BYGPS
//
//  Created by miwer on 16/9/18.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface BYDeviceTypeModel : JSONModel

@property(nonatomic,strong) NSString * model;
@property(nonatomic,assign) NSInteger devicetypeid;
@property(nonatomic,assign) BOOL wifi;
@property(nonatomic,assign) BOOL isSelect;

@property (nonatomic , strong) NSString *alias;



@end

/*
    model = 007,
	devicetypeid = 10,
	wifi = 0
 */
