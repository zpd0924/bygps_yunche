//
//  BYAutoScanViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/9/5.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYInstallDeviceCheckModel.h"

typedef NS_ENUM(NSInteger, WQCodeScannerType) {
    WQCodeScannerTypeAll = 0,   //default, scan QRCode and barcode
    WQCodeScannerTypeQRCode,    //scan QRCode only
    WQCodeScannerTypeBarcode,   //scan barcode only
};
typedef void(^BYAutoScanBlock)(BYInstallDeviceCheckModel *model);
@interface BYAutoScanViewController : UIViewController
@property (nonatomic, assign) WQCodeScannerType scanType;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *tipStr;

@property (nonatomic, copy) void(^resultBlock)(NSString *value);
@property (nonatomic,copy) BYAutoScanBlock autoScanBlock;

@property (nonatomic,strong) NSString *carSn;//设备sn
@end
