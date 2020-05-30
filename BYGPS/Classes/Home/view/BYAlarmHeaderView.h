//
//  BYAlarmHeaderView.h
//  BYGPS
//
//  Created by miwer on 16/9/12.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYAlarmHeaderView : UIView

@property(nonatomic,copy) void (^itemsActionBlock) (NSInteger tag);

@end
