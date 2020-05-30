//
//  BYMonthPayOffViewController.m
//  BYGPS
//
//  Created by ZPD on 2018/6/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMonthPayOffViewController.h"
#import "BYMonthPayoffModel.h"
#import "BYMonthPayOffCell.h"
#import "EasyNavigation.h"

#import "BYPickView.h"
#import "BYPostBackFooterView.h"
#import "BYPushNaviModel.h"
#import "BYSendPostBackParams.h"
#import "BYDeviceDetailHttpTool.h"

@interface BYMonthPayOffViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) BYMonthPayoffModel *payOffModel;
@property(nonatomic,strong) BYSendPostBackParams * httpParams;

@end

@implementation BYMonthPayOffViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initBase];
}

-(void)initBase{
    
    [self.navigationView setTitle:@"月还款模式"];
    
    self.tableView.backgroundColor = [UIColor colorWithHex:@"#efefef"];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    BYRegisterCell(BYMonthPayOffCell);
    
    BYPostBackFooterView * footer = [BYPostBackFooterView by_viewFromXib];
    footer.title = @"";
    footer.by_height = 300;
    BYWeakSelf;
    [footer setSureActionBlock:^{
        
        [self.view endEditing:YES];
        
        if ([self.payOffModel.day integerValue] <= 0) {
          return  BYShowError(@"请输入还款日为1～31日");
        }
        
        if (!self.payOffModel.time) {
           return  BYShowError(@"请选择上线时间");
        }
        
        
        BYLog(@"%@",self.payOffModel);
        self.httpParams.content = [NSString stringWithFormat:@"%@#%@#%@#%@",self.payOffModel.day,self.payOffModel.beforDay,self.payOffModel.afterDay,self.payOffModel.time];
        [BYDeviceDetailHttpTool POSTSendPostBackWithParams:self.httpParams success:^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController popToViewController:self animated:YES];
            });
        }];
    }];
    self.tableView.tableFooterView = footer;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 10)];
    headView.backgroundColor = [UIColor colorWithHex:@"#efefef"];
    
    self.tableView.tableHeaderView = headView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYMonthPayOffCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMonthPayOffCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    cell.payOffModel = self.payOffModel;
    
    [cell setDayTextFieldEndEditBlock:^(NSString *text) {
        
        
        self.payOffModel.day = text;
        
    }];
    
    [cell setBeforDayTextFieldEndEditBlock:^(NSString *text) {
        
        self.payOffModel.beforDay = text;
    }];
    
    [cell setAfterDayTextFieldEndEditBlock:^(NSString *text) {
        
        self.payOffModel.afterDay = text;
    }];
    
    [cell setChooseTimeBlock:^{
        [self.view endEditing:YES];
        BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:[NSDate date] center:@"请选择时间" datePickerMode:UIDatePickerModeTime pickViewType:BYPickViewTypeDate];
        
        BYWeakSelf;
        [datePicker setSureBlock:^(NSDate * date) {
            self.payOffModel.time = [self formatterSelectDate:date];
            [weakSelf.tableView reloadData];
        }];
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}
-(NSString *)formatterSelectDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --LAZY

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(BYMonthPayoffModel *)payOffModel{
    if (!_payOffModel) {
        _payOffModel = [[BYMonthPayoffModel alloc] init];
        _payOffModel.day = @"0";
        _payOffModel.afterDay = @"0";
        _payOffModel.beforDay = @"0";
    }
    return _payOffModel;
}

-(BYSendPostBackParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYSendPostBackParams alloc] init];
        _httpParams.deviceId = self.model.deviceId;
        _httpParams.model = self.model.model;
        _httpParams.type = 1;
        _httpParams.mold = 6;
    }
    return _httpParams;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
