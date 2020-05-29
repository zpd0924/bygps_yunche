//
//  BYShareDeviceTypeCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/12.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYShareCommitDeviceModel.h"
@interface BYShareDeviceTypeCell : UITableViewCell
///是否已过期
@property (nonatomic,assign) BOOL isDated;
@property (nonatomic,strong) BYShareCommitDeviceModel *model;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
