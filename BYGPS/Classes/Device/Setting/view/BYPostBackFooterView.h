//
//  BYPostBackFooterView.h
//  BYGPS
//
//  Created by miwer on 16/9/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYPostBackFooterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,strong) void (^sureActionBlock)(void);


@property(nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * subTitle;

@end
