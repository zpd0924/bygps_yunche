//
//  BYMyWorkOrderProgressCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/8/1.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYMyWorkOrderScreenStatusModel.h"

typedef void(^BYMyWorkOrderProgressBlock)(BYMyWorkOrderScreenStatusModel *model);

@interface BYMyWorkOrderProgressCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) BYMyWorkOrderScreenStatusModel *model;
@property (nonatomic,copy) BYMyWorkOrderProgressBlock myWorkOrderProgressBlock;
@end
