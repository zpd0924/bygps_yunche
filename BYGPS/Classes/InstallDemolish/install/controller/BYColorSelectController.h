//
//  BYColorSelectController.h
//  父子控制器
//
//  Created by miwer on 2016/12/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYColorSelectController : UIViewController

@property(nonatomic,copy) void (^colorItemSelectBlock) (NSInteger tag);

@end
