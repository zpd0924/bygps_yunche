//
//  BYSzSamePopView.h
//  BYGPS
//
//  Created by 主沛东 on 2019/5/3.
//  Copyright © 2019 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYSameAddDeviceModel;
@class BYSameAddInstallModel;
@class BYSameAddOrderModel;

NS_ASSUME_NONNULL_BEGIN

@interface BYSzSamePopView : UIView


@property (nonatomic , strong) BYSameAddOrderModel *sameOrderModel;

@property (nonatomic , strong) BYSameAddInstallModel *sameInstallModel;

@property (nonatomic , strong) BYSameAddDeviceModel *sameDeviceModel;

@property (nonatomic,copy) void(^closePopBlock)(void);




@end

NS_ASSUME_NONNULL_END
