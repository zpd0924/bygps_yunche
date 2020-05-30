//
//  BYAutoServiceRepairRemarkCell.h
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYAutoServiceRepairRemarkCell : UITableViewCell

@property (nonatomic,strong) NSString *remarkStr;

@property (nonatomic,copy) void(^remarkInputBlock)(NSString *remarkStr);

@end
