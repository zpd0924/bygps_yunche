//
//  BYCityListViewController.h
//  carLoanManagerment
//
//  Created by ZPD on 2017/3/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYCityListViewController : UIViewController

@property (nonatomic,copy) void (^cityCallBack) (NSString *city);

@end
