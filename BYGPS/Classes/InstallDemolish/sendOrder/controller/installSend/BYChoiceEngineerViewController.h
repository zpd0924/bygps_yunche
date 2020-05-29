//
//  BYChoiceEngineerViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//
//!<选择技师
#import <UIKit/UIKit.h>
#import "BYChoiceEngineerModel.h"

typedef void(^BYChoiceEngineerViewBlock)(BYChoiceEngineerModel *engineerModel);

@interface BYChoiceEngineerViewController : UIViewController
@property (nonatomic,copy) BYChoiceEngineerViewBlock choiceServerBlock;
///区域id
@property (nonatomic,strong) NSString *areaId;
///服务地址
@property (nonatomic,strong) NSString *serviceAdress;
@end
