//
//  BYAlarmListController.m
//  BYGPS
//
//  Created by miwer on 16/7/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAlarmListController.h"

#import "BYAlarmHttpParams.h"
#import "BYAlarmHttpTool.h"

#import "BYAlarmHeaderView.h"
#import "BYPopView.h"
#import "BYAlertView.h"
#import "BYRoundBorderButton.h"
#import "BYPickView.h"
#import "BYAlarmToolView.h"
#import "BYAlertView.h"
#import "BYHandleAlarmView.h"

#import "BYAlarmCell.h"
#import "BYAlarmHandleCell.h"
#import "BYRowHeaderView.h"
#import "BYAlarmModel.h"
//#import "BYNaviSearchBar.h"
#import "BYSearchBar.h"

#import "BYDeviceTypeSelectController.h"
#import "BYAlarmSettingController.h"
#import "EasyNavigation.h"
#import "BYDetailTabBarController.h"
#import "BYAlarmPositionController.h"
#import "BYGroupsSelectController.h"
#import "BYHomeHttpTool.h"

#import "BYControlSearchViewController.h"

#import <MJRefresh.h>
#import "BYDateFormtterTool.h"
#define headerView_H BYS_W_H(40)
#define toolView_H BYS_W_H(50)
static NSString * const cellID = @"alarmCell";
static NSString * const handleCellID = @"handleCellID";
static NSString * const headerID = @"alarmHeader";

@interface BYAlarmListController () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong) BYAlarmHeaderView * headerView;
@property (strong, nonatomic) UITableView * tableView;
@property(nonatomic,strong) BYPopView * popView;
@property(nonatomic,strong) BYAlertView * alertView;
@property(nonatomic,strong) BYAlarmToolView * toolView;
@property(nonatomic,strong) BYAlertView * handleAlertView;
@property(nonatomic,strong) BYSearchBar * naviSearchBar;
@property (nonatomic,strong) UIView *bottomView;
@property(nonatomic,strong) NSMutableArray * selectArray;
@property(nonatomic,strong) NSMutableArray * alarmSelectArr;
@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,strong) BYAlarmHttpParams * httpParams;
@property(nonatomic,assign) NSInteger selectMarkType;

@property(nonatomic,assign) BOOL isHeader;//是否为下拉刷新
@property(nonatomic,assign) BOOL isFirstLoad;//判断是否我第一次加载,用于桌面badge请0

@end

@implementation BYAlarmListController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBase];
    
    [self addRefresh];
    //123123123
    
    
}

-(void)addRefresh{

    BYWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        weakSelf.isHeader = YES;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];//让tableView进来默认加载数据
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isHeader = NO;
        weakSelf.httpParams.currentPage += 1;
        [weakSelf loadData];
    }];
    
    self.tableView.mj_footer.hidden = YES;//先让footer隐藏
}

-(void)handleAlarm:(NSMutableDictionary *)params{
    BYWeakSelf;
    [BYAlarmHttpTool POSTHandleAlarmWithParams:params success:^{

        weakSelf.isHeader = YES;
        
        [weakSelf loadData];
    }];
}

-(void)loadData{
    
    if (self.isHeader) {//每次发送网络请求时,都将toolBar关掉
        [self.alarmSelectArr removeAllObjects];
        self.httpParams.currentPage = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self toolViewAnimateWith:NO model:nil];
        });
    }
    
    if (self.deviceId) {//说明是从设备详情那里跳转
        self.httpParams.deviceId = self.deviceId;
    }
//    if (self.deviceSn.length) {
//        self.httpParams.queryStr = self.deviceSn;
//    }
    BYWeakSelf;
    [BYAlarmHttpTool POSTAlarmListWith:self.httpParams success:^(NSMutableArray *array) {
        
        if (_isFirstLoad) {//在第一次加载数据时显示蒙版
            if (![BYSaveTool isContainsKey:BYSelfClassName]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BYGuideImageView showGuideViewWith:BYSelfClassName touchOriginYScale:0.4];
                });
            }
        }
        
        if (weakSelf.isHeader) {//如果下拉刷新
            [weakSelf.dataSource removeAllObjects];
        }

        [weakSelf.dataSource addObjectsFromArray:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果当前加载的数量小于20则隐藏footer,就不会重复出现上拉加载
            weakSelf.tableView.mj_footer.hidden = array.count < 20 ? YES : NO;
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
-(void)initBase{
    
    self.view.backgroundColor = BYGlobalBg;
    _isFirstLoad = YES;
    
    self.naviSearchBar = [[BYSearchBar alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W * 0.65, 30)];
    self.naviSearchBar.backgroundColor = BYRGBColor(226, 231, 232);
    self.naviSearchBar.searchLabel.font = BYS_T_F(12);
    BYWeakSelf;
    [self.naviSearchBar setSearchBlock:^{
        MobClickEvent(@"alarm_search", @"");
        BYControlSearchViewController *searchVC = [[BYControlSearchViewController alloc] init];
        searchVC.type = 3;
        [searchVC setSearchCallBack:^(NSString *searchStr) {
            if (searchStr.length > 0) {
                weakSelf.naviSearchBar.searchLabel.text = searchStr;
                weakSelf.naviSearchBar.searchLabel.textColor = [UIColor colorWithHex:@"#323232"];
            }else{
                weakSelf.naviSearchBar.searchLabel.text = @"搜索设备号、车牌号、车主姓名";
                weakSelf.naviSearchBar.searchLabel.textColor = [UIColor colorWithHex:@"#909090"];
            }
            
            if (searchStr.length > 0) {
                weakSelf.httpParams = nil;//先将查询条件置为空
                weakSelf.httpParams.queryStr = searchStr;
                weakSelf.isHeader = YES;
                [weakSelf loadData];
            }else{
                weakSelf.naviSearchBar.searchLabel.text = @"搜索设备号、车牌号、车主姓名";
                //    [self.naviSearchBar.searchField resignFirstResponder];
                weakSelf.isHeader = YES;
                weakSelf.httpParams = nil;
                [weakSelf loadData];
            }
        }];
        [weakSelf.navigationController pushViewController:searchVC animated:YES];
    }];
    [self.navigationView addTitleView:self.naviSearchBar];
//    self.naviSearchBar.searchField.delegate = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    [self.navigationView addRightButtonWithTitle:@"重置" clickCallBack:^(UIView *view) {
        MobClickEvent(@"alarm_rest", @"");
        [weakSelf resetAction];
    }];
    
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYAlarmCell class]) bundle:nil] forCellReuseIdentifier:cellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYAlarmHandleCell class]) bundle:nil] forCellReuseIdentifier:handleCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYRowHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:headerID];
    
    //  添加观察者，监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //  添加观察者，监听键盘收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];


}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        [BYProgressHUD by_showErrorWithStatus:@"搜索内容不能为空"];
        return YES;
    }
    [textField resignFirstResponder];
    self.httpParams = nil;//先将查询条件置为空
    self.httpParams.queryStr = textField.text;
    self.isHeader = YES;
    [self loadData];
    
    return YES;
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.naviSearchBar.searchField resignFirstResponder];
//}
#pragma mark - tableView代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    BYAlarmModel * model = self.dataSource[section];
    return model.isExpand ? 1 : 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYAlarmModel * model = self.dataSource[indexPath.section];
    if (model.processingUserId.length || model.reviceTime.length) {//
        BYAlarmCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.model = model;
        return cell;
    }else{
        BYAlarmHandleCell * cell = [tableView dequeueReusableCellWithIdentifier:handleCellID];
        cell.model = model;
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYAlarmModel * model = self.dataSource[indexPath.section];
    return model.processingUserId.length || model.reviceTime.length ? BYS_W_H(120) : BYS_W_H(70);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BYS_W_H(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    BYRowHeaderView * header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    BYAlarmModel * model = self.dataSource[section];
        
    header.model = model;
    
    BYWeakSelf;
    
    [header setSelectRowBlock:^{//选中header
        
        BYAlarmModel * rowModel = self.dataSource[section];
        rowModel.isExpand = !rowModel.isExpand;
        [weakSelf.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    [header setSelectHeadBlock:^{//选中header的选中按钮
        
        BYAlarmModel * headModel = self.dataSource[section];
        
        if (headModel.processingUserId.length) {
            return [BYProgressHUD by_showErrorWithStatus:@"所选报警已处理"];
        }
        
        if (headModel.reviceTime.length) {
            return [BYProgressHUD by_showErrorWithStatus:@"所选报警已恢复"];
        }
        
        if (!headModel.processingUserId.length) {//报警已经处理时,不能选中
            
            headModel.isSelect = !headModel.isSelect;
            
            [weakSelf toolViewAnimateWith:headModel.isSelect model:headModel];
            
            [weakSelf.tableView reloadData];
        }
    }];

    return header;
}

- (void)toolViewAnimateWith:(BOOL)isSelect model:(BYAlarmModel *)model{
    
    if (isSelect) {
        [self.alarmSelectArr addObject:model];
    }else{
        [self.alarmSelectArr removeObject:model];
    }
    
    self.toolView.title = self.alarmSelectArr.count > 1 ? [NSString stringWithFormat:@"批量处理(%zd)",self.alarmSelectArr.count] : @"处理该报警";
    
    CGRect frame = self.toolView.frame;
    CGFloat originY = BYSCREEN_H - toolView_H;
    frame.origin.y = self.alarmSelectArr.count >= 1 ? originY : BYSCREEN_H;
    BYWeakSelf;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.toolView.frame = frame;
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYAlarmModel * model = self.dataSource[indexPath.section];
    BYAlarmPositionController * alarmPositionVC = [[BYAlarmPositionController alloc] init];
    BYWeakSelf;
    [alarmPositionVC setHandleAlarmRefreshBlock:^{
        weakSelf.isHeader = YES;
        [weakSelf loadData];
    }];
    alarmPositionVC.alarmId = model.alarmId;
    [self.navigationController pushViewController:alarmPositionVC animated:YES];
}

#pragma mark - lazy
-(BYAlarmHeaderView *)headerView{
    if (_headerView == nil) {
        _headerView = [BYAlarmHeaderView by_viewFromXib];
        _headerView.frame = CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, headerView_H);
        BYWeakSelf;
        [_headerView setItemsActionBlock:^(NSInteger tag) {
            switch (tag) {
                case 0:{[weakSelf.popView showMenuWithAnimation:YES];MobClickEvent(@"alarm_status", @"");}//选择处理类型
                    break;
                case 1:{//选择组Ids
                    MobClickEvent(@"alarm_group", @"");
                    BYGroupsSelectController * groupsVC = [[BYGroupsSelectController alloc] init];
                    [groupsVC setGroupIdsStrBlock:^(NSString *groupIdsStr) {
                        weakSelf.httpParams.groupId = groupIdsStr;
                        weakSelf.isHeader = YES;
                        [weakSelf loadData];
                    }];
                    
                    [weakSelf.navigationController pushViewController:groupsVC animated:YES];
                }
                    break;
                case 2:{//选择报警类型
                    MobClickEvent(@"alarm_type", @"");
                    BYAlarmSettingController * alarmSetVC = [[BYAlarmSettingController alloc] init];
                    alarmSetVC.isAlarmSetting = NO;
                    
                    [alarmSetVC setTypesResultBlock:^(NSString * resultStr) {
                       
                        weakSelf.httpParams.alarmType = resultStr;
                        weakSelf.isHeader = YES;
                        [weakSelf loadData];
                    }];
                    
                    [weakSelf.navigationController pushViewController:alarmSetVC animated:YES];
                }
                    break;
                case 3:{[weakSelf.alertView show];MobClickEvent(@"alarm_time", @"");}//选择时间查询
                    break;
                default:
                    break;
            }
        }];
    }
    return _headerView;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight + headerView_H, BYSCREEN_W, BYSCREEN_H - headerView_H - 64 - 60) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            
            weakSelf.httpParams.startTime = startButton.titleLabel.text;
            weakSelf.httpParams.endTime = endButton.titleLabel.text;
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

- (BYPopView *)popView{
    if (!_popView) {
        NSArray *onlineTypeSource = @[@"全部",@"未处理",@"已处理",@"已恢复"];
        
        CGFloat x = 10;
        CGFloat y = 64 + BYS_W_H(45);
        CGFloat width = 110;
        CGFloat height = onlineTypeSource.count * 35 + 10;
        
        BYWeakSelf;
        _popView = [BYPopView createMenuWithFrame:CGRectMake(x, y, width, height) dataSource:onlineTypeSource selectArray:self.selectArray itemsClickBlock:^(NSInteger tag) {
            
            weakSelf.selectArray[tag] = @(NO);
            weakSelf.httpParams.status = tag;
            weakSelf.isHeader = YES;
            [weakSelf loadData];
            
        } backViewTap:^{
            _popView = nil;
            
        }];
        
    }
    return _popView;
}

-(BYAlarmToolView *)toolView{
    if (_toolView == nil) {
        _toolView = [BYAlarmToolView by_viewFromXib];
        _toolView.frame = CGRectMake(0, BYSCREEN_H, BYSCREEN_W, toolView_H);
        _toolView.handleButtonContraint_W.constant = BYSCREEN_W / 3;

        BYWeakSelf;
        [_toolView setHandleBlock:^{//点击弹窗
            
            [weakSelf.handleAlertView show];
        }];
        
        [self.view addSubview:_toolView];
    }
    return _toolView;
}

-(BYAlertView *)handleAlertView{//处理弹窗
    if (_handleAlertView == nil) {
        _handleAlertView = [BYAlertView viewFromNibWithTitle:@"报警处理" message:nil];

        _handleAlertView.alertHeightContraint.constant = BYS_W_H(80 + 100 + 45) + 108;
        _handleAlertView.alertWidthContraint.constant = BYS_W_H(230);
        
        BYHandleAlarmView * alarmView = [BYHandleAlarmView by_viewFromXib];
        alarmView.frame = _handleAlertView.contentView.bounds;
        
        self.selectMarkType = 0;//设置初始选中的类型
        BYWeakSelf;
        [alarmView setItemBlock:^(NSInteger tag) {//实现contentViewBlock
            weakSelf.selectMarkType = tag;
            
        }];
        
        [_handleAlertView.contentView addSubview:alarmView];
        
        __weak typeof(alarmView) weakAlarmView = alarmView;
        [_handleAlertView setSureBlock:^{
            _handleAlertView = nil;
            NSMutableArray * deviceids = [NSMutableArray array];
            NSMutableArray  * alarmids = [NSMutableArray array];
            for (BYAlarmModel * model in weakSelf.alarmSelectArr) {
                if (!model.processingUserId.length) {
                    
                    [deviceids addObject:model.deviceId];
                    [alarmids addObject:model.alarmId];
                }
            }
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"deviceIds"] = [deviceids componentsJoinedByString:@","];
            params[@"alarmIds"] = [alarmids componentsJoinedByString:@","];
            
            params[@"alarmRemark"] = [weakAlarmView.textView.text isEqualToString:@"请输入处理备注..."] ? @"无备注" : weakAlarmView.textView.text;
            
            params[@"processingResult"] = @(weakSelf.selectMarkType + 1);
            
            [weakSelf handleAlarm:params];
            
        }];
        
        [_handleAlertView setCancelBlock:^{
            _handleAlertView = nil;
        }];
        
    }
    return _handleAlertView;
}

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(NSMutableArray *)alarmSelectArr{
    if (_alarmSelectArr == nil) {
        _alarmSelectArr = [[NSMutableArray alloc] init];
    }
    return _alarmSelectArr;
}

-(BYAlarmHttpParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYAlarmHttpParams alloc] init];
        _httpParams.status = 1;//默认报警是未处理
        self.selectArray = [NSMutableArray arrayWithObjects:@(NO),@(YES),@(NO),@(NO), nil];//重置时的状态改为未处理状态
        _isHeader = YES;
    }
    return _httpParams;
}
-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MAXHEIGHT - 60, MAXWIDTH, 60)];
        _bottomView.backgroundColor = WHITE;
        UILabel *label = [UILabel verLab:13 textRgbColor:BYLabelBlackColor textAlighment:NSTextAlignmentLeft];
        label.text = @"APP只显示所有未处理/已处理，和最近90天已恢复的报警数据，更多报警请前往PC端报警统计列表查看";
        label.numberOfLines = 0;
        [_bottomView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_bottomView);
            make.centerY.equalTo(_bottomView);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
    }
    return _bottomView;
}
-(void)startTimeAction:(UIButton *)button{
    
    BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:[NSDate date] center:@"请选择日期" datePickerMode:UIDatePickerModeDateAndTime pickViewType:BYPickViewTypeDate];
//    datePicker.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-90 * 24 * 60 * 60]; // 设置最小时间
//    datePicker.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0]; // 设置最大时间
    BYWeakSelf;
    [datePicker setSureBlock:^(NSDate * date) {
        [button setTitle:[weakSelf formatterSelectDate:date] forState:UIControlStateNormal];
    }];
}
-(void)endTimeAction:(UIButton *)button{
    BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:[NSDate date] center:@"请选择日期" datePickerMode:UIDatePickerModeDateAndTime pickViewType:BYPickViewTypeDate];
//    datePicker.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-90 * 24 * 60 * 60]; // 设置最小时间
//    datePicker.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:0]; // 设置最大时间
    
    BYWeakSelf;
    [datePicker setSureBlock:^(NSDate * date) {
        [button setTitle:[weakSelf formatterSelectDate:date] forState:UIControlStateNormal];
    }];
}

-(NSString *)formatterSelectDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
}

-(void)resetAction{
    self.naviSearchBar.searchLabel.text = @"搜索设备号、车牌号、车主姓名";
    self.naviSearchBar.searchLabel.textColor = [UIColor colorWithHex:@"#909090"];
//    [self.naviSearchBar.searchField resignFirstResponder];
    self.isHeader = YES;
    self.httpParams = nil;
    [self loadData];
}

- (void)keyBoardDidShow:(NSNotification*)notifiction {
    
    if (self.handleAlertView && self.handleAlertView.alert.by_centerY == BYSCREEN_H / 2) {
        
        // 取得键盘的动画时间,这样可以在视图上移的时候更连贯
        double duration = [[notifiction.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        CGRect frame = self.handleAlertView.alert.frame;
        frame.origin.y -= 120;
        [UIView animateWithDuration:duration animations:^{
            
            self.handleAlertView.alert.frame = frame;
        }];
    }
}

- (void)keyBoardDidHide:(NSNotification*)notification {
    if (self.handleAlertView) {
        
        CGRect frame = self.handleAlertView.alert.frame;
        frame.origin.y += 120;
        [UIView animateWithDuration:0.1 animations:^{
            
            self.handleAlertView.alert.frame = frame;
        }];
    }
}


-(NSComparisonResult)compareOneDay:(NSString *)startDate withAnotherDay:(NSString *)endDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateA = [dateFormatter dateFromString:startDate];
    NSDate *dateB = [dateFormatter dateFromString:endDate];
    return [dateA compare:dateB];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end





