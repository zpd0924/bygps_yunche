//
//  BYCheckThreeAddressViewController.h
//  BYGPS
//
//  Created by 主沛东 on 2019/4/29.
//  Copyright © 2019 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYDeviceModel;

NS_ASSUME_NONNULL_BEGIN

@interface BYCheckThreeAddressViewController : UIViewController


@property (nonatomic , strong) BYDeviceModel *deviceModel;

@property (nonatomic , strong) NSString *orderNo;



@end

NS_ASSUME_NONNULL_END
