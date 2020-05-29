//
//  BYDeviceTypeSelectController.h
//  BYGPS
//
//  Created by miwer on 16/8/31.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYDeviceTypeSelectController : UIViewController

@property(nonatomic,copy) void (^typesBlock) (NSMutableArray * types);

@end
