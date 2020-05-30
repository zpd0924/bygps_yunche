//
//  BYCheckWorkOrderFootView.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/16.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CheckWorkOrderFootViewBlock)(void);
@interface BYCheckWorkOrderFootView : UIView
@property (nonatomic,copy) CheckWorkOrderFootViewBlock passBlock;
@property (nonatomic,copy) CheckWorkOrderFootViewBlock noPassBlock;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@end
