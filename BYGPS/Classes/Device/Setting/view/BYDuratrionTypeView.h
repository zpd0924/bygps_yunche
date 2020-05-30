//
//  BYDuratrionTypeView.h
//  BYGPS
//
//  Created by miwer on 16/9/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYDuratrionTypeView : UIView

@property(nonatomic,assign) NSInteger selectType;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldBgViewContraint_H;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property(nonatomic,copy) void (^durationTypeBlock)(NSInteger tag, BOOL isSelect);

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;

@end
