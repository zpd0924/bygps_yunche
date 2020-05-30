//
//  BYPostBackCell.h
//  BYGPS
//
//  Created by bean on 16/7/30.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYPostBackModel.h"

@interface BYPostBackCell : UITableViewCell

@property(nonatomic,strong)BYPostBackModel * model;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property(nonatomic,copy) void (^shouldEndInputBlock) (NSString * input);
@property (nonatomic,copy) void(^saveLightBlock)(void);

@property (weak, nonatomic) IBOutlet UIButton *saveLightButton;

@end
