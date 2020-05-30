//
//  BYHandInputViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/9/6.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYInstallDeviceCheckModel.h"

typedef void(^BYHandInputBlock)(BYInstallDeviceCheckModel *model);

@interface BYHandInputViewController : UIViewController
@property (nonatomic,copy) BYHandInputBlock handInputBlock;
@end
