//
//  BYInstallHeaderView.h
//  父子控制器
//
//  Created by miwer on 2016/12/21.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYInstallHeaderView : UIView

@property(nonatomic,assign) NSInteger stepIndex;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *workOrderInfoLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *carInfoLabel;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *deviceInfoLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *topNoticeView;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *topH;

///显示第几步
@property (nonatomic,assign) NSInteger showStepIndex;
@end
