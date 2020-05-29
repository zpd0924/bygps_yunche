//
//  BYMyWorkOrderScreenViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

//!<筛选
#import <UIKit/UIKit.h>
#import "BYScreenParameterModel.h"
typedef void(^BYMyWorkOrderScreenBlock)(BYScreenParameterModel *model);

@interface BYMyWorkOrderScreenViewController : UIViewController
@property (nonatomic,copy) BYMyWorkOrderScreenBlock myWorkOrderScreenBlock;
@end
