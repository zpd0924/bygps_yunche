//
//  BYInstallRecordViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/9/6.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYInstallRecordViewController.h"
#import "EasyNavigation.h"
#import "BYNaviSearchBar.h"
#import "UIButton+HNVerBut.h"
#import "BYInstallRecordViewCell.h"
#import "BYMyAllWorkOrderModel.h"
#import "BYAlertView.h"
#import "BYRoundBorderButton.h"
#import "BYPickView.h"

@interface BYInstallRecordViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign) BOOL isHeader;
@property(nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSString *keyWord;
@property (nonatomic,strong) NSString *startTime;
@property (nonatomic,strong) NSString *endTime;
@property(nonatomic,strong) BYAlertView * alertView;
@end

@implementation BYInstallRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
    [self setSearchView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    BYRegisterCell(BYInstallRecordViewCell);
    [self.view addSubview:self.tableView];
    
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)screenBtnClick{
    [self.alertView show];
}
-(void)initBase{
    [self.navigationView setTitle:@"安装记录"];
    BYWeakSelf;
    self.view.backgroundColor = BYBackViewColor;
     self.automaticallyAdjustsScrollViewInsets = NO;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        [self.navigationView removeAllLeftButton];
        [self.navigationView removeAllRightButton];
//
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//
//    });
    
    [self addRefresh];
  
}
-(void)addRefresh{
    
    BYWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.isHeader = YES;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];//让tableView进来默认加载数据
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isHeader = NO;
        weakSelf.currentPage += 1;
        [weakSelf loadData];
        
    }];
    
    self.tableView.mj_footer.hidden = YES;//先让footer隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

-(void)loadData{
    if (self.isHeader) {//每次发送网络请求时,都将toolBar关掉
        self.currentPage = 1;
        [self.dataSource removeAllObjects];
    }
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     dict[@"pageNum"] = @(self.currentPage);
    dict[@"showCount"] = @(10);
    if (_keyWord.length) {
        dict[@"content"] = _keyWord;
    }
    if (_startTime.length) {
         dict[@"startTime"] = _startTime;
    }
    if (_endTime.length) {
        dict[@"endTime"] = _endTime;
    }
    [BYSendWorkHttpTool POSTAutoQuickOrderListParams:dict success:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.isHeader) {//数据请求成功时才将数据清空
                [weakSelf.dataSource removeAllObjects];
            }
            NSArray *array = data[@"list"];
            for (NSDictionary *dict in array) {
                BYMyAllWorkOrderModel *model = [[BYMyAllWorkOrderModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.dataSource addObject:model];
            }
            weakSelf.tableView.mj_footer.hidden = array.count < 10 ? YES : NO;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        });
        
        
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}
- (void)setSearchView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, MAXWIDTH, 50)];
    view.backgroundColor = WHITE;
    BYNaviSearchBar *search = [[BYNaviSearchBar alloc] initWithFrame:CGRectMake(10, 10, MAXWIDTH - 65, 30)];
    search.searchField.delegate = self;
    search.searchField.placeholder = @"请输入工单编号";
    UIButton *screenBtn = [UIButton verBut:nil textFont:15 titleColor:[UIColor blackColor] bkgColor:nil];
    [screenBtn setImage:[UIImage imageNamed:@"时间"] forState:UIControlStateNormal];
    [screenBtn addTarget:self action:@selector(screenBtnClick) forControlEvents:UIControlEventTouchUpInside];
    screenBtn.frame = CGRectMake(MAXWIDTH - 50, 0, 50, 50);
    [view addSubview:search];
    [view addSubview:screenBtn];
    [self.view addSubview:view];
}

#pragma mark -- 搜索
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    _keyWord = textField.text;
    [self loadData];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length == 0) {
        _keyWord = string;
        [self loadData];
    }
    return YES;
}
-(void)startTimeAction:(UIButton *)button{
    
    BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:[NSDate date] center:@"请选择日期" datePickerMode:UIDatePickerModeDateAndTime pickViewType:BYPickViewTypeDate];
    
    BYWeakSelf;
    [datePicker setSureBlock:^(NSDate * date) {
        [button setTitle:[weakSelf formatterSelectDate:date] forState:UIControlStateNormal];
    }];
}
-(void)endTimeAction:(UIButton *)button{
    BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:[NSDate date] center:@"请选择日期" datePickerMode:UIDatePickerModeDateAndTime pickViewType:BYPickViewTypeDate];
    
    BYWeakSelf;
    [datePicker setSureBlock:^(NSDate * date) {
        [button setTitle:[weakSelf formatterSelectDate:date] forState:UIControlStateNormal];
    }];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYInstallRecordViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYInstallRecordViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 123;
}


-(NSComparisonResult)compareOneDay:(NSString *)startDate withAnotherDay:(NSString *)endDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateA = [dateFormatter dateFromString:startDate];
    NSDate *dateB = [dateFormatter dateFromString:endDate];
    return [dateA compare:dateB];
}
-(NSString *)formatterSelectDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
}

#pragma mrak -- nodata
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"no_order"];
}

- (NSString *)xy_noDataViewMessage {
    return @"暂无工单!";
}

- (UIColor *)xy_noDataViewMessageColor {
    return BYLabelBlackColor;
}
- (NSNumber *)xy_noDataViewCenterYOffset{
    
    return [NSNumber numberWithInteger:0];
}

#pragma mark -- lazy
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight + 50, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight - 50) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
       
    }
    return _tableView;
}

-(BYAlertView *)alertView{
    if (_alertView == nil) {
        _alertView = [BYAlertView viewFromNibWithTitle:@"时间查询" message:nil];
        _alertView.alertHeightContraint.constant = BYS_W_H(170);
        _alertView.alertWidthContraint.constant = BYS_W_H(250);
        
        CGFloat margin = 10;
        CGFloat button_H = 30;
        
        UILabel * startLabel = [[UILabel alloc] init];
        startLabel.by_x = margin;
        startLabel.by_y = margin;
        startLabel.by_width = BYS_W_H(40);
        startLabel.by_height = BYS_W_H(button_H);
        startLabel.text = @"开始:";
        startLabel.font = BYS_T_F(14);
        startLabel.textColor = [UIColor grayColor];
        
        BYRoundBorderButton * startButton = [BYRoundBorderButton buttonWithType:UIButtonTypeCustom];
        startButton.by_x = CGRectGetMaxX(startLabel.frame) + 5;
        startButton.by_y = margin;
        startButton.by_width = BYS_W_H(250) - 2 * margin - CGRectGetMaxX(startLabel.frame) + 5;
        startButton.by_height = BYS_W_H(button_H);
        [startButton setTitle:[self formatterSelectDate:[NSDate date]] forState:UIControlStateNormal];
        [startButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        startButton.titleLabel.font = BYS_T_F(16);
        [startButton addTarget:self action:@selector(startTimeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel * endLabel = [[UILabel alloc] init];
        endLabel.by_x = margin;
        endLabel.by_y = BYS_W_H(90) - margin - BYS_W_H(button_H);
        endLabel.by_width = BYS_W_H(40);
        endLabel.by_height = BYS_W_H(button_H);
        endLabel.text = @"结束:";
        endLabel.font = BYS_T_F(14);
        endLabel.textColor = [UIColor grayColor];
        
        
        BYRoundBorderButton * endButton = [BYRoundBorderButton buttonWithType:UIButtonTypeCustom];
        endButton.by_x = CGRectGetMaxX(endLabel.frame) + 5;
        endButton.by_y = CGRectGetMinY(endLabel.frame);
        endButton.by_width = BYS_W_H(250) - 2 * margin - CGRectGetMaxX(startLabel.frame) + 5;
        endButton.by_height = BYS_W_H(button_H);
        [endButton setTitle:[self formatterSelectDate:[NSDate date]] forState:UIControlStateNormal];
        [endButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        endButton.titleLabel.font = BYS_T_F(16);
        [endButton addTarget:self action:@selector(endTimeAction:) forControlEvents:UIControlEventTouchUpInside];
        
        BYWeakSelf;
        [_alertView setSureBlock:^{
            _alertView = nil;
            if ([weakSelf compareOneDay:startButton.titleLabel.text withAnotherDay:endButton.titleLabel.text] != NSOrderedAscending) {
                return [BYProgressHUD by_showErrorWithStatus:@"结束时间须大于开始时间"];
            }
            
            weakSelf.startTime = startButton.titleLabel.text;
            weakSelf.endTime = endButton.titleLabel.text;
            weakSelf.isHeader = YES;
            [weakSelf loadData];
        }];
        
        [_alertView setCancelBlock:^{
            _alertView = nil;
        }];
        
        [_alertView.contentView addSubview:startLabel];
        [_alertView.contentView addSubview:startButton];
        [_alertView.contentView addSubview:endLabel];
        [_alertView.contentView addSubview:endButton];
    }
    return _alertView;
}
@end
