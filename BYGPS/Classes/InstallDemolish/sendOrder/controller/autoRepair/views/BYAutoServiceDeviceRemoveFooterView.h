//
//  BYAutoServiceDeviceRemoveFooterView.h
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYAutoServiceDeviceRemoveFooterView : UIView

@property (nonatomic,copy) void(^confirmBlock)(void);

@property (nonatomic,copy) void(^cancleBlock)(void);

@end
