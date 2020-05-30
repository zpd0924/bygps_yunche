//
//  BYDeviceInfoFooterView.h
//  BYGPS
//
//  Created by ZPD on 2018/12/27.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYDeviceInfoFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *repairButton;
@property (weak, nonatomic) IBOutlet UIButton *installButton;

@property (nonatomic,copy) void(^installBlock)(void);
@property (nonatomic,copy) void(^repairBlock)(void);
@property (nonatomic,copy) void(^removeBlock)(void);

@end
