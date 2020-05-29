//
//  BYMyWorkOrderScreenViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderScreenViewController.h"
#import "BYMyWorkOrderScreenStatusCell.h"
#import "BYMyWorkOrderScreenTimeCell.h"
#import "BYMyWorkOrderProgressCell.h"
#import "UIButton+HNVerBut.h"
#import "UILabel+HNVerLab.h"
#import <Masonry.h>
#import "BYMyWorkOrderScreenStatusModel.h"
#import "BYScreenParameterModel.h"

@interface BYMyWorkOrderScreenViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *footView;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) NSMutableArray *dataSource;

///参数
@property (nonatomic,assign) NSInteger serviceType;//工单类型
@property (nonatomic,strong) NSString *startTime;//开始时间
@property (nonatomic,strong) NSString *endTime;//结束时间
@property (nonatomic,assign) NSInteger isOvertimes;//工单进度

@property (nonatomic,strong) BYScreenParameterModel *screenParameterModel;
@end

@implementation BYMyWorkOrderScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self initBase];
}

- (void)tap:(UITapGestureRecognizer *)tap{
    NSLog(@"tap = %@",tap);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initBase{
    
    UIView *mengView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH, MAXHEIGHT)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [mengView addGestureRecognizer:tap];
    mengView.backgroundColor = UIColorHexRGB(0x000000, 0.6);
    [self.view addSubview:mengView];
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = self.footView;
    self.tableView.tableHeaderView = self.headView;
    
}

#pragma maek -- 取消
- (void)canceBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 确定
- (void)sureBtnClick{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSMutableArray *arr = self.dataSource[0];
    for (int i = 0; i<arr.count; i++) {
        BYMyWorkOrderScreenStatusModel *model1 = arr[i];
        if (model1.isSelect) {
            self.screenParameterModel.serviceType = i;
            self.screenParameterModel.isOperation = YES;
            break;
        }
    }
    BYMyWorkOrderScreenStatusModel *model2 = self.dataSource[1];
    if (model2.starTime.length) {
        self.screenParameterModel.startTime = model2.starTime;
         self.screenParameterModel.isOperation = YES;
    }
  
    if (model2.endTime.length) {
         self.screenParameterModel.endTime = model2.endTime;
         self.screenParameterModel.isOperation = YES;
    }
     BYMyWorkOrderScreenStatusModel *model3 = self.dataSource[2];
    if (model3.isAllBtnSelect) {
         self.screenParameterModel.isOperation = YES;
    }
    if (model3.isFinshBtnSelect) {
        self.screenParameterModel.status = 4;
         self.screenParameterModel.isOperation = YES;
    }
    if (model3.isNoFinishSelect) {
        self.screenParameterModel.status = 1;
         self.screenParameterModel.isOperation = YES;
    }
    if (model3.isFinshOverTimeBtnSelect || model3.isNoFinishOverTimeSelect) {
        self.screenParameterModel.isOvertimes = 1;
    }
    if (model3.isFinshNoOverTimeBtnSelect || model3.isNoFinishNoOverTimeSelect) {
        self.screenParameterModel.isOvertimes = 2;
    }
    
    self.screenParameterModel.type = 1;
    if (self.myWorkOrderScreenBlock) {
        self.myWorkOrderScreenBlock(self.screenParameterModel);
    }
     [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- 重置
- (void)resetBtnClick{
    [self.dataSource removeAllObjects];
    self.dataSource = nil;
    self.screenParameterModel.isOperation = NO;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    switch (indexPath.row) {
        case 0:
        {
            BYMyWorkOrderScreenStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMyWorkOrderScreenStatusCell"];
             [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.indexPath = indexPath;
            cell.titleArray = self.dataSource[indexPath.row];
            return cell;
        }
            break;
        case 1:
        {
            BYMyWorkOrderScreenTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMyWorkOrderScreenTimeCell"];

             [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
             cell.indexPath = indexPath;
            cell.model = self.dataSource[indexPath.row];
            return cell;
        }
            break;
        default:
        {
            BYMyWorkOrderProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMyWorkOrderProgressCell"];
            cell.myWorkOrderProgressBlock = ^(BYMyWorkOrderScreenStatusModel *model) {
                [weakSelf.dataSource replaceObjectAtIndex:2 withObject:model];
                [weakSelf.tableView reloadData];
            };
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.indexPath = indexPath;
            cell.model = self.dataSource[indexPath.row];
            return cell;
        }
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 141;
            break;
        case 1:
            return 90;
            break;
        default:
            return 300;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"row = %zd",indexPath.row);
}

#pragma mark -- lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(80, SafeAreaTopHeight - 44, BYSCREEN_W - 80, BYSCREEN_H - SafeAreaTopHeight + 44) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        [_tableView registerClass:[BYMyWorkOrderScreenStatusCell class] forCellReuseIdentifier:@"BYMyWorkOrderScreenStatusCell"];
        BYRegisterCell(BYMyWorkOrderScreenTimeCell);
        BYRegisterCell(BYMyWorkOrderProgressCell);
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

-(UIView *)footView
{
    if (!_footView) {
        _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W - 80, 80)];
        UIButton *resetBtn = [UIButton verBut:@"重置" textFont:15 titleColor:WHITE bkgColor:BYGlobalGreenColor];
        [resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:UIControlEventTouchUpInside];
        resetBtn.layer.cornerRadius = 3;
        resetBtn.layer.masksToBounds = YES;

        UIButton *sureBtn = [UIButton verBut:@"确定" textFont:15 titleColor:WHITE bkgColor:BYGlobalBlueColor];
        [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.layer.cornerRadius = 3;
        sureBtn.layer.masksToBounds = YES;
       
        [_footView addSubview:sureBtn];
        [_footView addSubview:resetBtn];
        [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
             make.size.mas_equalTo(CGSizeMake((BYSCREEN_W - 80 - 42)*0.5, 44));
            make.left.mas_equalTo(15);
            make.centerY.equalTo(_footView);
        }];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake((BYSCREEN_W - 80 - 42)*0.5, 44));
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(_footView);
        }];
    }
    return _footView;
}

-(UIView *)headView
{
    if (!_headView) {
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH - 80, 45)];;
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = BYGlobalBlueColor;
        UILabel *label = [UILabel verLab:15 textRgbColor:BYLabelBlackColor textAlighment:NSTextAlignmentLeft];
        label.text = @"全部工单";
        UIButton *canceBtn = [UIButton verBut:@"取消" textFont:15 titleColor:BYLabelGrayColor bkgColor:nil];
        [canceBtn addTarget:self action:@selector(canceBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIView *spaceView = [[UIView alloc] init];
        spaceView.backgroundColor = BYBigSpaceColor;
        [_headView addSubview:line];
        [_headView addSubview:label];
        [_headView addSubview:canceBtn];
        [_headView addSubview:spaceView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(5, 15));
            make.centerY.equalTo(_headView);
            make.left.mas_equalTo(20);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_headView);
            make.left.equalTo(line.mas_right).offset(8);
        }];
        [canceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(label);
            make.right.mas_equalTo(-20);
        }];
        [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(MAXWIDTH - 80 - 10, 0.5));
            make.bottom.trailing.equalTo(_headView);
        }];
    }
    return _headView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        NSArray *arr = @[@[@"全部",@"安装单",@"检修单",@"拆机单"],@[],@[@"全部",@"超时完成",@"超时未完成",@"正常"]];
        NSMutableArray *model1Array = [NSMutableArray array];
        for (NSString *str in arr[0]) {
            BYMyWorkOrderScreenStatusModel *model1 = [[BYMyWorkOrderScreenStatusModel alloc] init];
            model1.screenName = str;
            model1.isSelect = NO;
            [model1Array addObject:model1];
        }
        [_dataSource addObject:model1Array];
        BYMyWorkOrderScreenStatusModel *model2 = [[BYMyWorkOrderScreenStatusModel alloc] init];
        model2.starTime = @"";
        model2.endTime = @"";
        [_dataSource addObject:model2];
        
            BYMyWorkOrderScreenStatusModel *model3 = [[BYMyWorkOrderScreenStatusModel alloc] init];
            model3.isAllBtnSelect = NO;
             model3.isFinshBtnSelect = NO;
            model3.isFinshOverTimeBtnSelect = NO;
            model3.isFinshNoOverTimeBtnSelect = NO;
             model3.isNoFinishSelect = NO;
            model3.isNoFinishOverTimeSelect = NO;
            model3.isNoFinishNoOverTimeSelect = NO;
        
        
        [_dataSource addObject:model3];
        
    }
    return _dataSource;
}

-(BYScreenParameterModel *)screenParameterModel
{
    if (!_screenParameterModel) {
        _screenParameterModel = [[BYScreenParameterModel alloc] init];
    }
    return _screenParameterModel;
}
@end
