//
//  BY036DurationTypeView.h
//  BYGPS
//
//  Created by ZPD on 2017/12/14.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BY036DurationTypeView : UIView

@property (nonatomic,strong) NSMutableArray *dataSource;

@property(nonatomic,copy) void (^durationTypeSelectedBlock)(NSInteger tag, BOOL isSelect);

@end
