//
//  BYSearchCarMessageCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/14.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYSearchCarByNumOrVinModel.h"

typedef void(^BYSearchCarMessageBlock)(BYSearchCarByNumOrVinModel *model);
@interface BYSearchCarMessageCell : UITableViewCell
@property (nonatomic,strong) BYSearchCarByNumOrVinModel *model;
@property (nonatomic,copy) BYSearchCarMessageBlock carMessageBlock;
@end
