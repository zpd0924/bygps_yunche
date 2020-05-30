//
//  BYParamsConfigView.h
//  BYGPS
//
//  Created by miwer on 16/9/9.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYParamsConfigView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midBgViewContraint_H;

@property (weak, nonatomic) IBOutlet UISwitch *GPSSwitchView;
@property (weak, nonatomic) IBOutlet UISwitch *fiveSwitchView;
@property (weak, nonatomic) IBOutlet UISwitch *flameOutSwitchView;

@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;

@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;

@property(nonatomic,assign) NSInteger selectType;

@property(nonatomic,copy)void (^dateItemsBlock) (NSInteger tag, BOOL isSelect);

@end
