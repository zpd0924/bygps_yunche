//
//  BYInstallButtonCell.h
//  父子控制器
//
//  Created by miwer on 2016/12/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYInstallModel;

@interface BYInstallButtonCell : UITableViewCell

@property(nonatomic,strong) BYInstallModel * model;
@property(nonatomic,assign) CGFloat titleLabel_W;

@end
