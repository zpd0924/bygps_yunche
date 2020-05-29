//
//  BYMyCertifyFootView.h
//  xsxc
//
//  Created by ZPD on 2018/5/28.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYMyCertifyFootView : UIView

@property (nonatomic,copy) void(^nextStepBlock)(void);
@property (nonatomic,strong) NSString *btnTitle;
@property(nonatomic, assign)bool isNoPass;
@end
