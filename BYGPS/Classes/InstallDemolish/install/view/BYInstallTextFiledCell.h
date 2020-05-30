//
//  BYInstallTextFiledCell.h
//  父子控制器
//
//  Created by miwer on 2016/12/21.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYInstallModel;

@interface BYInstallTextFiledCell : UITableViewCell

@property(nonatomic,strong) BYInstallModel * model;
@property(nonatomic,assign) CGFloat titleLabel_W;
@property(nonatomic,copy) void (^shouldEndInputBlock) (NSString * input);
@property(nonatomic,assign) BOOL isHiddenTopLine;

@end
