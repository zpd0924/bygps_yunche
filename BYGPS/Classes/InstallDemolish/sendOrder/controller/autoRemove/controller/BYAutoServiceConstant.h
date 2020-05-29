//
//  BYAutoServiceConstant.h
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#ifndef BYAutoServiceConstant_h
#define BYAutoServiceConstant_h


//功能模块类型 拆机和检修
typedef NS_ENUM(NSUInteger, BYFunctionType) {
    BYFunctionTypeRemove,    /** 拆机页面*/
    BYFunctionTypeRepair,   /** 检修页面*/
    BYFunctionTypeInstall,  /** 安装页面*/
    
};

//检修页面cell类型
typedef NS_ENUM(NSUInteger, BYRepairCellType) {
    BYRepairCellSwitchType,    /** 检修类型切换*/
    BYRepairCellCheckInstallType,   /** 查看旧安装位置*/
    BYRepairCellNewSnType,          /** 新设备sn*/
    BYRepairCellInfoType,           /** 检修信息*/
    BYRepairCellReasonType,         /** 检修原因*/
    
};


#endif /* BYAutoServiceConstant_h */
