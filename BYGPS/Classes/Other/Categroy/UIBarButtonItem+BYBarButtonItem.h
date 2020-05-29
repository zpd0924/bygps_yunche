//
//  UIBarButtonItem+BYBarButtonItem.h
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (BYBarButtonItem)

+(UIBarButtonItem *)itemWithImage:(NSString *)image target:(id)target action:(SEL)action;

+(UIBarButtonItem *)itemSureWithTarget:(id)target action:(SEL)action;//确定按钮

+(UIBarButtonItem *)itemSetWithTarget:(id)target action:(SEL)action;//设置按钮

+(UIBarButtonItem *)itemResetWithTarget:(id)target action:(SEL)action;//重置按钮

+(UIBarButtonItem *)itemhandleWithTarget:(id)target action:(SEL)action;//处理按钮
+(UIBarButtonItem *)itemClearAllWithTarget:(id)target action:(SEL)action;//清空

+(UIBarButtonItem *)itemWith:(NSString *)title target:(id)target action:(SEL)action;

@end
