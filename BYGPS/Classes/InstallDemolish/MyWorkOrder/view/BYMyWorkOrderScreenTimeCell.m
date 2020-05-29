//
//  BYMyWorkOrderScreenTimeCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderScreenTimeCell.h"
#import "BYPickView.h"

@interface BYMyWorkOrderScreenTimeCell()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *starTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;

@property (weak, nonatomic) IBOutlet UIButton *endBtn;

@end
@implementation BYMyWorkOrderScreenTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.starTextField.delegate = self;
    self.endTextField.delegate = self;
    self.starTextField.enabled = NO;
    self.endTextField.enabled = NO;
   
    
}
- (void)setModel:(BYMyWorkOrderScreenStatusModel *)model{
    _model = model;
    if (model.starTime) {
        self.starTextField.text = nil;
    }
    if (model.endTime) {
        self.endTextField.text = nil;
    }
}
- (IBAction)endBtnClick:(UIButton *)sender {
    BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:[NSDate date] center:@"请选择结束日期" datePickerMode:UIDatePickerModeDateAndTime pickViewType:BYPickViewTypeDate];
    
    BYWeakSelf;
    [datePicker setSureBlock:^(NSDate * date) {
        if (![weakSelf.starTextField.text isEqualToString:[weakSelf formatterSelectDate:date]]) {
            if ([weakSelf compareOneDay:weakSelf.starTextField.text withAnotherDay:[weakSelf formatterSelectDate:date]] != NSOrderedAscending) {
                return [BYProgressHUD by_showErrorWithStatus:@"结束时间须大于开始时间"];
            }
        }
        weakSelf.endTextField.text = [weakSelf formatterSelectDate:date];
        weakSelf.model.endTime = weakSelf.endTextField.text;
    }];
}
- (IBAction)starBtnClick:(UIButton *)sender {
    BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:[NSDate date] center:@"请选择开始日期" datePickerMode:UIDatePickerModeDateAndTime pickViewType:BYPickViewTypeDate];
    
    
    BYWeakSelf;
    [datePicker setSureBlock:^(NSDate * date) {
        weakSelf.starTextField.text = [weakSelf formatterSelectDate:date];
        weakSelf.model.starTime = weakSelf.starTextField.text;
    }];
}


-(NSString *)formatterSelectDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
}





-(NSComparisonResult)compareOneDay:(NSString *)startDate withAnotherDay:(NSString *)endDate{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateA = [dateFormatter dateFromString:startDate];
    NSDate *dateB = [dateFormatter dateFromString:endDate];
    return [dateA compare:dateB];
}
@end
