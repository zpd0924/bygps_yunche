//
//  BYSelectDeviceDemolishFooter.h
//  父子控制器
//
//  Created by miwer on 2016/12/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYSelectDeviceDemolishFooter : UIView

@property(nonatomic,copy) void (^reasonBlock)();

@property(nonatomic,strong) NSString * reason;

@end