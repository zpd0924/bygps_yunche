//
//  BYMyWorkOrderScreenTimeCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYMyWorkOrderScreenStatusModel.h"

@interface BYMyWorkOrderScreenTimeCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) BYMyWorkOrderScreenStatusModel *model;
@end
