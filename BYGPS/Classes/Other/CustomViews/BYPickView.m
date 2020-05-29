//
//  BYPickView.m
//  MyPickerView
//
//  Created by bean on 16/8/2.
//  Copyright © 2016年 bean. All rights reserved.
//

#import "BYPickView.h"

#define BYSCREEN_W [UIScreen mainScreen].bounds.size.width
#define BYSCREEN_H [UIScreen mainScreen].bounds.size.height

@interface BYPickView () <UIPickerViewDelegate,UIPickerViewDataSource>


@property (nonatomic,strong)NSString * centerTitle;
@property(nonatomic,strong)NSArray * dataSource;

@property(nonatomic,strong)UIPickerView * myPickView;
@property(nonatomic,strong)UIView * containerView;
@property(nonatomic,strong)UIToolbar * toolBar;

@property(nonatomic,assign)NSInteger currentRow;


@property(nonatomic,strong)NSDate * defaulDate;
@property(nonatomic,assign)UIDatePickerMode datePickerMode;

@property(nonatomic,assign)BYPickViewType pickViewType;

@end

@implementation BYPickView

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _currentRow = row;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return self.dataSource[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count;
}

- (UIToolbar *) toolBar{
    
    if (_toolBar == nil) {
        
        _toolBar = [self setToolbarStyle:self.centerTitle];
    }
    
    return _toolBar;
}

- (UIView *)containerView {
    
    if (_containerView == nil) {
        
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, BYSCREEN_H, BYSCREEN_W, BYS_W_H(216) + 40)];
        
        [_containerView addSubview:self.toolBar];
        
        if (self.pickViewType == BYPickViewTypeDate) {
            [_containerView addSubview:self.datePicker];
        }else if(self.pickViewType == BYPickViewTypePicker){
            [_containerView addSubview:self.myPickView];
        }
    }
    return _containerView;
}

-(UIPickerView *)myPickView{
    if (_myPickView == nil) {
        _myPickView = [[UIPickerView alloc] init];
        _myPickView.backgroundColor=[UIColor whiteColor];
        _myPickView.delegate = self;
        _myPickView.dataSource = self;
        _myPickView.frame = CGRectMake(0, 40, BYSCREEN_W, BYS_W_H(216));
    }
    return _myPickView;
}

-(UIDatePicker *)datePicker{
    if (_datePicker == nil) {
        _datePicker=[[UIDatePicker alloc] init];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.datePickerMode = self.datePickerMode;
        _datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _datePicker.backgroundColor=[UIColor whiteColor];
        if (self.defaulDate) {
            [_datePicker setDate:self.defaulDate];
        }
        _datePicker.frame = CGRectMake(0, 40, BYSCREEN_W, BYS_W_H(216));
    }
    return _datePicker;
}

-  (UIToolbar *)setToolbarStyle:(NSString *)titleString{
    
    UIToolbar *toolbar=[[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, 0, BYSCREEN_W, 40);
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 40)];
    lable.backgroundColor = [UIColor colorWithRed:42/255.0 green:115/255.0 blue:241/255.0 alpha:1.0];
    
    lable.text = titleString;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    lable.font = [UIFont systemFontOfSize:18];
    [toolbar addSubview:lable];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, 0, 60, 40);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    cancelBtn.layer.cornerRadius = 2;
    cancelBtn.layer.masksToBounds = YES;
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dissMissView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseBtn.backgroundColor = [UIColor clearColor];
    chooseBtn.frame = CGRectMake(0, 0, 60, 40);
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    chooseBtn.layer.cornerRadius = 2;
    chooseBtn.layer.masksToBounds = YES;
    [chooseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chooseBtn setTitle:@"确定" forState:UIControlStateNormal];
    [chooseBtn addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    centerSpace.width = 70;
    
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:chooseBtn];
    
    toolbar.items=@[leftItem,centerSpace,rightItem];
    toolbar.backgroundColor = [UIColor greenColor];
    
    return toolbar;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    self.frame = [UIScreen mainScreen].bounds;
    [self.myPickView selectRow:self.currentRow inComponent:0 animated:YES];
}

-(UIView *)createContainerWithAnimation{
    CGRect frame = self.containerView.frame;
    frame.origin.y = BYSCREEN_H - BYS_W_H(216) - 40;
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.frame = frame;
    }];
    return self.containerView;
}

- (void)dissMissView{
    
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        self.containerView.frame = CGRectMake(0, BYSCREEN_H, BYSCREEN_W, 256);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    if (!CGRectContainsPoint(self.containerView.frame,touchPoint)) {
        [self dissMissView];
    }
}

- (instancetype)initWithpickViewWith:(NSString *)center dataSource:(NSArray *)dataSource currentTitle:(NSString *)currentTitle{
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.currentRow = [dataSource indexOfObject:currentTitle];
        self.centerTitle = center;
        self.dataSource = dataSource;
        self.pickViewType = BYPickViewTypePicker;
        [self showContainer];
    }
    return self;
}

-(void)showContainer{
    [self addSubview:[self createContainerWithAnimation]];
    UIWindow *currentWindows = [UIApplication sharedApplication].keyWindow;
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    [currentWindows addSubview:self];
}
#pragma mark - datePicker

-(instancetype)initWithDatePickWith:(NSDate *)defaulDate center:(NSString *)center datePickerMode:(UIDatePickerMode)datePickerMode pickViewType:(BYPickViewType)pickViewType{
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.centerTitle = center;
        self.defaulDate = defaulDate;
        self.pickViewType = BYPickViewTypeDate;
        self.datePickerMode = datePickerMode;
        [self showContainer];
    }
    return self;
}

-(void)sureClick{
    [self dissMissView];
    
    if (self.pickViewType == BYPickViewTypePicker) {
        if (self.surePickBlock) {
            self.surePickBlock(self.dataSource[self.currentRow]);
        }
    }else if(self.pickViewType == BYPickViewTypeDate){
        
//        NSString * selectDate = [self formatterSelectDate:self.datePicker.date];
        
        if (self.sureBlock) {
            self.sureBlock(self.datePicker.date);
        }
    }
}

-(NSString *)formatterSelectDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
}

@end









