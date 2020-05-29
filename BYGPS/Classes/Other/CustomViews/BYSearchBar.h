//
//  BYSearchBar.h
//  BYGPS
//
//  Created by miwer on 16/8/25.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYSearchBar : UIView

//@property(nonatomic,strong) UITextField * searchField;

@property (nonatomic,strong) UILabel *searchLabel;

@property (nonatomic,copy) void(^searchBlock)(void);

@end
