//
//  BYWorkMessageFootView.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYWorkMessageModel.h"

typedef void(^BYWorkMessageFootViewNextClickBlock)(void);
typedef void(^BYWorkMessageFootViewEditBlock)(NSString *str);
@interface BYWorkMessageFootView : UIView
@property (nonatomic,copy) BYWorkMessageFootViewNextClickBlock workMessageFootViewNextClickBlock;
@property (nonatomic,copy) BYWorkMessageFootViewEditBlock editBlock;
@property (nonatomic,strong) BYWorkMessageModel *workMessageModel;
@end
