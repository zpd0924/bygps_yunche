//
//  BYSureInfoController.h
//  父子控制器
//
//  Created by miwer on 2016/12/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYSureInfoController : UIViewController

@property(nonatomic,strong) NSMutableArray * sureSource;
@property(nonatomic,strong) NSMutableArray * images;
@property (nonatomic,strong) NSMutableArray *photoArr;
@property(nonatomic,assign) NSInteger deviceId;
@property(nonatomic,assign) BOOL isWirless;

@end
