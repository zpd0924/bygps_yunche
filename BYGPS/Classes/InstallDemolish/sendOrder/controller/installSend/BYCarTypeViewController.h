//
//  BYCarTypeViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/26.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BYCarTypeViewBlock)(NSString *brand,NSString *carType,NSString *carInfoType);
@interface BYCarTypeViewController : UIViewController
@property (nonatomic,copy) BYCarTypeViewBlock carTypeViewBlock;
@end
