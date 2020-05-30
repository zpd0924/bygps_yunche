//
//  BYSettingCell.h
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BYBaseSettingItem.h"

@interface BYSettingCell : UITableViewCell

@property (nonatomic, strong) BYBaseSettingItem *item;

@property(nonatomic,strong) UITextField * textField;



+ (instancetype)cellWithTableView:(UITableView *)tableView tableViewCellStyle:(UITableViewCellStyle)tableViewCellStyle;

@end
