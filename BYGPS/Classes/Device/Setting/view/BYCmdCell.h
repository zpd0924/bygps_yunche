//
//  BYCmdCell.h
//  BYGPS
//
//  Created by miwer on 2017/2/17.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYCmdRecordModel;

@interface BYCmdCell : UITableViewCell

@property(nonatomic,assign) NSInteger cmdType;

@property(nonatomic,strong) BYCmdRecordModel * model;

@property(copy, nonatomic)void (^ settingActionBlock) ();

@property (nonatomic,copy)void(^ tapHeadBlock)(BOOL isTapHead);
@property (nonatomic,assign) BOOL isTapHead;

@property (nonatomic,assign) BOOL isWireless;

@end
