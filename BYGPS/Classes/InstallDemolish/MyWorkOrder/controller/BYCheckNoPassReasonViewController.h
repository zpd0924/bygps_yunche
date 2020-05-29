//
//  BYCheckNoPassReasonViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYMyAllWorkOrderModel.h"

typedef void(^BYCheckNoPassReasonBlock)(void);

@interface BYCheckNoPassReasonViewController : UIViewController
@property (nonatomic,strong) BYMyAllWorkOrderModel *model;
@property (nonatomic,copy) BYCheckNoPassReasonBlock checkNoPassReasonBlock;
@end
