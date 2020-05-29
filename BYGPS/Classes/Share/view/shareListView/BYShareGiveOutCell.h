//
//  BYShareGiveOutCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/12.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYShareListModel.h"
typedef void(^BYShareGiveOutBlock)(void);

@interface BYShareGiveOutCell : UITableViewCell
///是否已过期
@property (nonatomic,assign) BOOL isDated;
@property (nonatomic,copy) BYShareGiveOutBlock editBlock;
@property (nonatomic,copy) BYShareGiveOutBlock endBlock;
@property (nonatomic,strong) BYShareListModel *model;
@end
