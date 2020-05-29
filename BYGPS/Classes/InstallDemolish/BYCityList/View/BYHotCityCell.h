//
//  BYHotCityCell.h
//  carLoanManagerment
//
//  Created by miwer on 2017/3/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYHotCityCell : UITableViewCell

@property (nonatomic,strong) NSArray * cityArr;

@property (nonatomic,copy) void (^ cityCallBack) (NSString * city);

@end
