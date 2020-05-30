//
//  BYEditorCarInfoViewController.h
//  BYGPS
//
//  Created by 主沛东 on 2019/5/22.
//  Copyright © 2019 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYDeviceInfoModel;
typedef void(^BYAddCarInfoViewBlock)(BYDeviceInfoModel * model);


NS_ASSUME_NONNULL_BEGIN

@interface BYEditorCarInfoViewController : UIViewController

@property(nonatomic,strong) BYDeviceInfoModel * carModel;

@property (nonatomic,copy) BYAddCarInfoViewBlock addCarInfoViewBlock;

@end

NS_ASSUME_NONNULL_END
