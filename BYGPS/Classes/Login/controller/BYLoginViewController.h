//
//  BYLoginViewController.h
//  BYGPS
//
//  Created by miwer on 16/7/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYLoginViewController : UIViewController

@property (nonatomic,assign) BOOL isAutoLogin;

@property(nonatomic,assign) BOOL isLogout;

@property(nonatomic,copy)void (^dismissBlock) ();

@end
