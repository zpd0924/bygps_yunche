//
//  BYAutoServiceCommitFooterView.h
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYAutoServiceCommitFooterView : UIView

@property (weak, nonatomic) IBOutlet UIButton *submitButton;


@property (nonatomic,copy) void(^removeOrRepairSubmitBlock)(void);


@end
