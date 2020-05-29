//
//  BYCarNumTextFieldCell.h
//  父子控制器
//
//  Created by miwer on 2016/12/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYInstallModel;

@interface BYCarNumTextFieldCell : UITableViewCell

@property(nonatomic,strong) BYInstallModel * model;
@property(nonatomic,strong) NSString * carNum;
@property(nonatomic,copy) void (^shouldEndInputBlock) (NSString * input);
@property(nonatomic,copy) void (^carNumSelectBlock) (NSString *carNum);

@end
