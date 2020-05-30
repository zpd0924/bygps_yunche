//
//  BYCarMessageSearchResultCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYSearchCarByNumOrVinModel.h"

typedef void(^DelectBlock)(void);
@interface BYCarMessageSearchResultCell : UITableViewCell
@property (nonatomic,strong) BYSearchCarByNumOrVinModel *model;
@property (nonatomic,copy) DelectBlock delectBlock;
@end
