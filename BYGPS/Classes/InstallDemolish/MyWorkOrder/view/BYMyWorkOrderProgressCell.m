//
//  BYMyWorkOrderProgressCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/8/1.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderProgressCell.h"

@interface BYMyWorkOrderProgressCell()
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
@property (weak, nonatomic) IBOutlet UIButton *noFinshBtn;

@property (weak, nonatomic) IBOutlet UIButton *finishOverTimeBtn;

@property (weak, nonatomic) IBOutlet UIButton *finishNoOverTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *noFinshOverTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *noFinshBtnNoOverTimeBtn;


@end
@implementation BYMyWorkOrderProgressCell

- (void)setModel:(BYMyWorkOrderScreenStatusModel *)model{
    _model = model;
    _allBtn.selected = model.isAllBtnSelect;
    _finishBtn.selected = model.isFinshBtnSelect;
    _noFinshBtn.selected = model.isNoFinishSelect;
    _finishOverTimeBtn.selected = model.isFinshOverTimeBtnSelect;
    _finishNoOverTimeBtn.selected = model.isFinshNoOverTimeBtnSelect;
    _noFinshOverTimeBtn.selected = model.isNoFinishOverTimeSelect;
    _noFinshBtnNoOverTimeBtn.selected = model.isNoFinishNoOverTimeSelect;
    
    
    model.isFinshOverTimeBtnSelect?[_finishOverTimeBtn setBackgroundColor:BYGlobalBlueColor]:[_finishOverTimeBtn setBackgroundColor:UIColorFromToRGB(241, 241, 241)];
     model.isFinshNoOverTimeBtnSelect?[_finishNoOverTimeBtn setBackgroundColor:BYGlobalBlueColor]:[_finishNoOverTimeBtn setBackgroundColor:UIColorFromToRGB(241, 241, 241)];
    
     model.isNoFinishOverTimeSelect?[_noFinshOverTimeBtn setBackgroundColor:BYGlobalBlueColor]:[_noFinshOverTimeBtn setBackgroundColor:UIColorFromToRGB(241, 241, 241)];
     model.isNoFinishNoOverTimeSelect?[_noFinshBtnNoOverTimeBtn setBackgroundColor:BYGlobalBlueColor]:[_noFinshBtnNoOverTimeBtn setBackgroundColor:UIColorFromToRGB(241, 241, 241)];

}
//全部按钮
- (IBAction)allBtnClick:(UIButton *)sender {
    sender.selected = YES;
    _finishBtn.selected = NO;
    _noFinshBtn.selected = NO;
    
    _model.isAllBtnSelect = YES;
    _model.isFinshBtnSelect = NO;
    _model.isNoFinishSelect = NO;
    _model.isFinshOverTimeBtnSelect = NO;
    _model.isFinshNoOverTimeBtnSelect = NO;
    _model.isNoFinishOverTimeSelect = NO;
    _model.isNoFinishNoOverTimeSelect = NO;
    
    if (self.myWorkOrderProgressBlock) {
        self.myWorkOrderProgressBlock(_model);
    }
}
//已完成
- (IBAction)finishBtnClick:(UIButton *)sender {
    sender.selected = YES;
    _allBtn.selected = NO;
    _noFinshBtn.selected = NO;
    
    _model.isAllBtnSelect = NO;
    _model.isFinshBtnSelect = YES;
    _model.isNoFinishSelect = NO;

    _model.isNoFinishOverTimeSelect = NO;
    _model.isNoFinishNoOverTimeSelect = NO;
    if (self.myWorkOrderProgressBlock) {
        self.myWorkOrderProgressBlock(_model);
    }
}

//未完成
- (IBAction)noFinishBtnClick:(UIButton *)sender {
    sender.selected = YES;
    _allBtn.selected = NO;
    _finishBtn.selected = NO;
    _model.isAllBtnSelect = NO;
    _model.isFinshBtnSelect = NO;
    _model.isNoFinishSelect = YES;
    
    _model.isFinshOverTimeBtnSelect = NO;
    _model.isFinshNoOverTimeBtnSelect = NO;
    
    if (self.myWorkOrderProgressBlock) {
        self.myWorkOrderProgressBlock(_model);
    }
}
//已完成 超时
- (IBAction)finishOverTimeBtnClick:(UIButton *)sender {
    _model.isAllBtnSelect = NO;
    _model.isFinshBtnSelect = YES;
    _model.isNoFinishSelect = NO;
    
    _model.isFinshOverTimeBtnSelect = YES;
    _model.isFinshNoOverTimeBtnSelect = NO;
    _model.isNoFinishOverTimeSelect = NO;
    _model.isNoFinishNoOverTimeSelect = NO;
    if (self.myWorkOrderProgressBlock) {
        self.myWorkOrderProgressBlock(_model);
    }
}
//已完成未超时
- (IBAction)finishNoOverTimeBtnClick:(UIButton *)sender {
    _model.isAllBtnSelect = NO;
    _model.isFinshBtnSelect = YES;
    _model.isNoFinishSelect = NO;
    
    _model.isFinshOverTimeBtnSelect = NO;
    _model.isFinshNoOverTimeBtnSelect = YES;
    _model.isNoFinishOverTimeSelect = NO;
    _model.isNoFinishNoOverTimeSelect = NO;
    if (self.myWorkOrderProgressBlock) {
        self.myWorkOrderProgressBlock(_model);
    }
}
//未完成 超时
- (IBAction)noFinshOverTimeBtnClick:(UIButton *)sender {
    _model.isAllBtnSelect = NO;
    _model.isFinshBtnSelect = NO;
    _model.isNoFinishSelect = YES;
    
    _model.isFinshOverTimeBtnSelect = NO;
    _model.isFinshNoOverTimeBtnSelect = NO;
    _model.isNoFinishOverTimeSelect = YES;
    _model.isNoFinishNoOverTimeSelect = NO;
    if (self.myWorkOrderProgressBlock) {
        self.myWorkOrderProgressBlock(_model);
    }
}
//未完成未超时
- (IBAction)noFinshBtnNoOverTimeBtnClick:(UIButton *)sender {
    _model.isAllBtnSelect = NO;
    _model.isFinshBtnSelect = NO;
    _model.isNoFinishSelect = YES;
    
    _model.isFinshOverTimeBtnSelect = NO;
    _model.isFinshNoOverTimeBtnSelect = NO;
    _model.isNoFinishOverTimeSelect = NO;
    _model.isNoFinishNoOverTimeSelect = YES;
    if (self.myWorkOrderProgressBlock) {
        self.myWorkOrderProgressBlock(_model);
    }
}


@end
