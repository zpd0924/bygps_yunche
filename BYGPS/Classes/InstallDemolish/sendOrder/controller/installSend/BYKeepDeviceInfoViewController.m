//
//  BYKeepDeviceInfoViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYKeepDeviceInfoViewController.h"
#import <Masonry.h>
#import "UILabel+HNVerLab.h"
#import "BYKeepDeviceInfoCell.h"
#import "EasyNavigation.h"
#import "BYInstallHeaderView.h"
#import "BYCarMessageEntryFootView.h"
#import "BYSendOrderResultViewController.h"
#import "BYDeviceModel.h"
#import "BYArchiverManager.h"
#import "BYInstallSendOrderController.h"

@interface BYKeepDeviceInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation BYKeepDeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
        
    [self loadData];
    
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBase{
    [self.navigationView setTitle:@"选择设备"];
    BYWeakSelf;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        [self.navigationView removeAllLeftButton];
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//        
//    });
    self.view.backgroundColor = BYBigSpaceColor;
    [self.view addSubview:self.tableView];
    BYInstallHeaderView * tableHeader = [BYInstallHeaderView by_viewFromXib];
    tableHeader.workOrderInfoLabel.text = @"工单信息";
    tableHeader.carInfoLabel.text = @"车辆信息";
    tableHeader.deviceInfoLabel.text = @"设备信息";
    tableHeader.showStepIndex = 2;
    tableHeader.topNoticeView.hidden = YES;
    tableHeader.topH.constant = -30;
    tableHeader.frame = CGRectMake(0, 0, BYSCREEN_W, 100);
    BYCarMessageEntryFootView *footView = [BYCarMessageEntryFootView by_viewFromXib];
    footView.frame = CGRectMake(0, 0, MAXWIDTH, 94);
    footView.backgroundColor = BYBigSpaceColor;
    [footView.nextStepBtn setTitle:@"立即派单" forState:UIControlStateNormal];
    //    footView.previousStepClickBlock = ^{
    //        [weakSelf.navigationController popViewControllerAnimated:YES];
    //    };
    footView.nextStepClickBlock = ^{
        [weakSelf.view endEditing:YES];
        if (![weakSelf checkParam]) return;
        [weakSelf sendWork];
       
    };
    self.tableView.tableHeaderView = tableHeader;
    self.tableView.tableFooterView = footView;
}

#pragma mark -- 获取设备数据
- (void)loadData{
    BYWeakSelf;

    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     dict[@"carId"] = @(self.parameterModel.carId);

    [BYSendWorkHttpTool POSTDeviceByCarParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dataSource = [[NSArray yy_modelArrayWithClass:[BYDeviceModel class] json:data] mutableCopy];
            NSArray *arr = weakSelf.detailModel.gps;
            for (int i = 0; i<weakSelf.dataSource.count; i++) {
                BYDeviceModel *model = weakSelf.dataSource[i];
                
                 model.isSelect = YES;
                if (weakSelf.isEdit) {
                    for (BYDeviceModel *model1 in arr) {
                        if ([model1.deviceSn isEqualToString:model.deviceSn]) {
                            model.serviceReson = model1.serviceReson;
                            model.resonDetail = model1.resonDetail;
                        }
                        
                    }
                   
                }
            }
          
            [weakSelf.tableView reloadData];
        });
       
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark -- 订单详情接口
- (void)loadOrderDetail{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     dict[@"carId"] = @(self.parameterModel.carId);
    [BYSendWorkHttpTool POSSendOrderDetailParams:dict sendOrderType:weakSelf.sendOrderType success:^(id data) {
        weakSelf.detailModel = [BYOrderDetailModel yy_modelWithDictionary:data];
        [weakSelf refreshData];
    } failure:^(NSError *error) {
        
    }];
}
- (void)refreshData{
    NSMutableArray *arr = self.detailModel.gps;
    for (BYDeviceModel *model in arr) {
        model.isSelect = YES;
    }
    [self.dataSource removeAllObjects];
    self.dataSource = arr;
}
#pragma mark -- 派单接口
- (void)sendWork{
    BYWeakSelf;
    BYLog(@"%@",self.parameterModel);
    if (_isEdit) {
        [BYSendWorkHttpTool POSTEditInstallWorkParams:[self creatDict] sendOrderType:_sendOrderType success:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf sendSucessOrFailed];
            });
            
        } failure:^(NSError *error) {
            
        }];
    }else{
        [BYSendWorkHttpTool POSTAddInstallWorkParams:[self creatDict] sendOrderType:_sendOrderType success:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf sendSucessOrFailed];
            });
            
        } failure:^(NSError *error) {
            
        }];
    }
   
}
//配置参数
- (NSMutableDictionary *)creatDict{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"groupId"] = [BYSaveTool objectForKey:groupId];
    dict[@"groupCompany"] = [BYSaveTool objectForKey:groupName];
    dict[@"createUserName"] = [BYSaveTool objectForKey:nickName];
    dict[@"appointServiceItemVo"] = _parameterModel.appointServiceItemVo;
    dict[@"serviceType"] = @(2);
    dict[@"province"] = _parameterModel.province;
    dict[@"provinceId"] = @(_parameterModel.provinceId);
    dict[@"city"] = _parameterModel.city;
    dict[@"cityId"] = @(_parameterModel.cityId);
    dict[@"area"] = _parameterModel.area;
    dict[@"areaId"] = @(_parameterModel.areaId);
    dict[@"serviceAddress"] = _parameterModel.serviceAddress;
    dict[@"contactPerson"] = _parameterModel.contactPerson;
    dict[@"contactTel"] = _parameterModel.contactTel;
    dict[@"publishType"] = @(_parameterModel.publishType);
    if (!_parameterModel.publishType) {//派单类型 0：指派 1：抢单
        dict[@"technicianId"] = @(_parameterModel.technicianId);
        dict[@"technicianName"] = _parameterModel.technicianName;
    }
    if (_isEdit) {
        dict[@"orderNo"] =  _detailModel.orderNo;
    }
    dict[@"carId"] = @(_parameterModel.carId);
    dict[@"carVin"] = _parameterModel.carVin;
    dict[@"carBrand"] = _parameterModel.carBrand;
    dict[@"carModel"] = _parameterModel.carModel;
    dict[@"carNum"] = _parameterModel.carNum;
    dict[@"carColor"] = _parameterModel.carColor;
    dict[@"carOwnerName"] = _parameterModel.carOwnerName;
    dict[@"orderRemark"] = _parameterModel.orderRemark;
    dict[@"needToAudit"] = @(_parameterModel.needToAudit);
    return dict;
}
#pragma mark -- 检查参数
- (BOOL)checkParam{
    if (self.dataSource.count == 0) {
        BYShowError(@"请选择有设备的车辆");
        return NO;
    }
        NSMutableArray *arr = [NSMutableArray array];
        for (BYDeviceModel *model in self.dataSource){
           
            if (model.isSelect) {
                if (!model.serviceReson){
                    BYShowError(@"请选择设备故障描述标签");
                    return NO;
                }
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"deviceProvider"] = model.deviceProvider;
                dict[@"deviceSn"] = model.deviceSn;
                dict[@"deviceType"] = @(model.deviceType);
                dict[@"serviceReson"] = @(model.serviceReson);
                dict[@"resonDetail"] = model.resonDetail.length?model.resonDetail:@" ";
                dict[@"devicePosition"] = model.devicePosition.length?model.devicePosition:@"0";
                [arr addObject:dict];
            }
          
        }
    if (arr.count == 0) {
        BYShowError(@"请选择检修设备");
        return NO;
    }
    self.parameterModel.appointServiceItemVo = arr;

    return YES;
}

#pragma mark -- 派单成功或者失败页面
- (void)sendSucessOrFailed{
    NSString *key = nil;
    switch (_sendOrderType) {
        case BYWorkSendOrderType:
            key = @"BYWorkSendOrder";
            break;
        case BYUnpackSendOrderType:
            key = @"BYUnpackSendOrder";
            break;
        case BYRepairSendOrderType:
            key = @"BYRepairSendOrder";
            break;
        default:
            break;
    }
    [[BYArchiverManager shareManagement] clearArchiverDataApiKey:key];
    BYWeakSelf;
    BYSendOrderResultViewController *vc = [[BYSendOrderResultViewController alloc] init];
    vc.resultType = BYSendWorkSucessType;
     vc.sendOrderType = _sendOrderType;
    vc.titleStr = @"派单结果";
    [weakSelf.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- tableview 数据源 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    BYKeepDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYKeepDeviceInfoCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    cell.keepDeviceInfoBlock = ^(BYDeviceModel *model) {
        [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
        [weakSelf.tableView reloadData];
    };
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = WHITE;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xiuDevice_section"]];
    UILabel *titleLabel = [UILabel verLab:15 textRgbColor:UIColorHexFromRGB(0x333333) textAlighment:NSTextAlignmentLeft];
    
    NSInteger count = 0;
    for (BYDeviceModel *deviceModel in self.dataSource) {
        
        count =  deviceModel.isSelect ? count  + 1 : count;
    }
    
    titleLabel.text = [NSString stringWithFormat:@"选择检修设备(共检修%ld台设备)",(long)count];
    titleLabel.attributedText = [BYObjectTool changeStrWittContext:[NSString stringWithFormat:@"选择检修设备(共检修%ld台设备)",(long)count] ChangeColorText:[NSString stringWithFormat:@"%ld",count] WithColor:BYGlobalBlueColor WithFont:[UIFont systemFontOfSize:20]];
    UIView *spaceView = [[UIView alloc] init];
    spaceView.backgroundColor = BYBigSpaceColor;
    [view addSubview:spaceView];
    [view addSubview:imageView];
    [view addSubview:titleLabel];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.centerY.equalTo(view);
    }];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView);
        make.left.equalTo(imageView.mas_right).offset(12);
    }];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MAXWIDTH - 30, 0.5));
        make.bottom.trailing.equalTo(view);
    }];
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 52;
    
}

#pragma mark -- lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = BYBigSpaceColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        BYRegisterCell(BYKeepDeviceInfoCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
