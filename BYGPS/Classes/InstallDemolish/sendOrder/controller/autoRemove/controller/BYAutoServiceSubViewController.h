//
//  BYAutoServiceSubViewController.h
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYAutoServiceConstant.h"

@class BYAutoServiceCarModel;
@interface BYAutoServiceSubViewController : UIViewController


@property (nonatomic,strong) BYAutoServiceCarModel *carModel;
@property (nonatomic,assign) BYFunctionType functionType;
//@property (nonatomic,strong) NSString *carId;

@end
