//
//  BYEditShareCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/13.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYShareListModel.h"

typedef void(^BYEditShareBlock)(BYShareListModel *model);
typedef void(^BYRefreshShareBlock)(void);
@interface BYEditShareCell : UITableViewCell
@property (nonatomic,strong) BYShareListModel *model;
@property (nonatomic,copy) BYEditShareBlock editShareBlock;
@property (nonatomic,copy) BYRefreshShareBlock refreshShareBlock;

@end
