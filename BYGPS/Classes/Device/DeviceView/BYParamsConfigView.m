//
//  BYParamsConfigView.m
//  BYGPS
//
//  Created by miwer on 16/9/9.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYParamsConfigView.h"
#import "BYPickView.h"
#import "BYDateFormtterTool.h"

@interface BYParamsConfigView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *midBgViewContraint_W;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomBgViewContraint_H;

@property(nonatomic,strong) UIButton * currentItem;

@end

@implementation BYParamsConfigView

- (IBAction)dateItemsAction:(UIButton *)sender {
    
    if (![sender isEqual:self.currentItem]) {
        self.currentItem.selected = NO;
    }
    sender.selected = !sender.selected;
    self.currentItem = sender;
    
    if (self.dateItemsBlock) {
        self.dateItemsBlock(sender.tag - 10, sender.selected);
    }
}

- (IBAction)startTimeAction:(id)sender {
    
    BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:[NSDate date] center:@"请选择日期" datePickerMode:UIDatePickerModeDateAndTime pickViewType:BYPickViewTypeDate];
    
    BYWeakSelf;
    [datePicker setSureBlock:^(NSDate * date) {
        [weakSelf.startTimeButton setTitle:[weakSelf formatterSelectDate:date] forState:UIControlStateNormal];
    }];
    
}

- (IBAction)endTimeAction:(id)sender {
    
    BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:[NSDate date] center:@"请选择日期" datePickerMode:UIDatePickerModeDateAndTime pickViewType:BYPickViewTypeDate];
    
    BYWeakSelf;
    [datePicker setSureBlock:^(NSDate * date) {
        [weakSelf.endTimeButton setTitle:[weakSelf formatterSelectDate:date] forState:UIControlStateNormal];
    }];
}

-(void)setSelectType:(NSInteger)selectType{
    
    self.currentItem = (UIButton *)[self viewWithTag:10 + selectType];
    self.currentItem.selected = YES;
}

-(void)setStartTime:(NSString *)startTime
{
    NSDate *startDate = [BYDateFormtterTool formatterToDateWith:startTime];
    NSString *start = [self formatterSelectDate:startDate];
    [self.startTimeButton setTitle:start forState:UIControlStateNormal];
}
-(void)setEndTime:(NSString *)endTime
{
    NSDate *endDate = [BYDateFormtterTool formatterToDateWith:endTime];
    NSString *end = [self formatterSelectDate:endDate];
    [self.endTimeButton setTitle:end forState:UIControlStateNormal];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.midBgViewContraint_W.constant = BYS_W_H(45);
    self.midBgViewContraint_H.constant = 0;
    self.bottomBgViewContraint_H.constant = BYS_W_H(160);
    
    self.startTimeButton.layer.borderWidth = 1;
    self.startTimeButton.layer.borderColor = [UIColor grayColor].CGColor;
    self.endTimeButton.layer.borderWidth = 1;
    self.endTimeButton.layer.borderColor = [UIColor grayColor].CGColor;
    
//    [self.startTimeButton setTitle:[self formatterSelectDate:[NSDate date]] forState:UIControlStateNormal];
    [self.startTimeButton setTitle:self.startTime forState:UIControlStateNormal];
//    [self.endTimeButton setTitle:[self formatterSelectDate:[NSDate date]] forState:UIControlStateNormal];
    [self.endTimeButton setTitle:self.endTime forState:UIControlStateNormal];
}

-(NSString *)formatterSelectDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
}



@end
