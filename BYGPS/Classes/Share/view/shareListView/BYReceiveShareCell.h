//
//  BYReceiveShareCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/11.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYShareListModel.h"
@interface BYReceiveShareCell : UITableViewCell
///是否已过期
@property (nonatomic,assign) BOOL isDated;
@property (nonatomic,strong) BYShareListModel *model;
@end
