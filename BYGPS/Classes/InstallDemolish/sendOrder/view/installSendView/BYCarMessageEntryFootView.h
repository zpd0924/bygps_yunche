//
//  BYCarMessageEntryFootView.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BYCarMessageEntryFootViewBlock)(void);

@interface BYCarMessageEntryFootView : UIView

@property (nonatomic,copy) BYCarMessageEntryFootViewBlock nextStepClickBlock;

@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@end
