//
//  YBCustomCameraVC.h
//  YBCustomCamera
//
//  Created by wyb on 2017/5/8.
//  Copyright © 2017年 中天易观. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YBCustomCameraBlock)(NSString *num);

@interface YBCustomCameraVC : UIViewController
@property (nonatomic,copy) YBCustomCameraBlock vinBlock;
@property (nonatomic,copy) YBCustomCameraBlock carNumberBlock;
@property (nonatomic,assign) NSInteger index; /// 1车牌 2车架
@end
