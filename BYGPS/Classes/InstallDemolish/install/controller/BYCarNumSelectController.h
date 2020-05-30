//
//  BYCarNumSelectController.h
//  父子控制器
//
//  Created by miwer on 2016/12/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYCarNumSelectController : UIViewController

@property(nonatomic,strong) NSString * carNum;

@property(nonatomic,copy)void (^citySelectBlock) (NSString * provinceAndCity);

@end
