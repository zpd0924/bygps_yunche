//
//  BYRegisterViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    BYRegisType=1,//注册
    BYforgetPasswordType//忘记密码
} BYRegisterType;

typedef void(^BYRegisterBlock)(NSString *phone ,NSString *password);

@interface BYRegisterViewController : UIViewController
@property (nonatomic,assign) BYRegisterType registerType;
@property (nonatomic,copy) BYRegisterBlock registerBlock;
@end
