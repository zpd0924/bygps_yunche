//
//  BYAppointmentCell.h
//  父子控制器
//
//  Created by miwer on 2016/12/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYInstallModel;

@interface BYAppointmentCell : UITableViewCell

@property(nonatomic,copy) void (^shouldEndInputBlock) (NSString * input);

@property(nonatomic,copy) void (^shouldChangeCharsBlock) (NSString * input);

@property(nonatomic,strong) BYInstallModel * model;

@property(nonatomic,assign) BOOL isUserInteraction;

@end
