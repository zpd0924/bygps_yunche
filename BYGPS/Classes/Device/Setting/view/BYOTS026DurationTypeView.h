//
//  BYOTS026DurationTypeView.h
//  BYGPS
//
//  Created by ZPD on 2017/6/29.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYOTS026DurationTypeView : UIView

@property(nonatomic,assign) NSInteger selectType;

@property(nonatomic,copy) void (^durationTypeBlock)(NSInteger tag, BOOL isSelect);

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *forthBtn;
@property (weak, nonatomic) IBOutlet UIButton *fifthBtn;

@end
