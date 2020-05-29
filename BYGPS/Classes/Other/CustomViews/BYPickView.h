//
//  BYPickView.h
//  MyPickerView
//
//  Created by bean on 16/8/2.
//  Copyright © 2016年 bean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYPickView : UIView

typedef enum {

    BYPickViewTypePicker,
    BYPickViewTypeDate,
    BYPickViewTypeCity
    
}BYPickViewType;

@property(nonatomic,copy)void (^sureBlock) (NSDate *date);

@property(nonatomic,copy)void (^surePickBlock) (NSString *currentStr);

- (instancetype)initWithpickViewWith:(NSString *)center dataSource:(NSArray *)dataSource currentTitle:(NSString *)currentTitle;

-(instancetype)initWithDatePickWith:(NSDate *)defaulDate center:(NSString *)center datePickerMode:(UIDatePickerMode)datePickerMode pickViewType:(BYPickViewType)pickViewType;
@property(nonatomic,strong)UIDatePicker * datePicker;
@end
