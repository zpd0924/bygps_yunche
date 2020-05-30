//
//  BYSelfServiceInstallNextView.h
//  BYGPS
//
//  Created by ZPD on 2018/9/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYSelfServiceInstallNextView : UIView
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;

@property (nonatomic,copy) void(^lastStepBlock)(void);
@property (nonatomic,copy) void(^commitBlock)(void);

@end
