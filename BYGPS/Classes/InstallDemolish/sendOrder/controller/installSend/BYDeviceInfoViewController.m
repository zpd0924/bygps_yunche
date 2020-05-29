//
//  BYDeviceInfoViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYDeviceInfoViewController.h"
#import <Masonry.h>
#import "UILabel+HNVerLab.h"
#import "BYDeviceInfoCell.h"
#import "EasyNavigation.h"
#import "BYInstallHeaderView.h"
#import "BYCarMessageEntryFootView.h"
#import "BYSendOrderResultViewController.h"
#import "BYDeviceModel.h"
#import "BYArchiverManager.h"
#import "BYInstallSendOrderController.h"
#import "BYRepairDeviceInfoCell.h"
#import "BYWorkMessageController.h"
#import "BYMyWorkOrderController.h"

@interface BYDeviceInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,weak) UILabel *countLabel;//安装设备的数量
@end

@implementation BYDeviceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
    if (_isEdit) {
        [self loadOrderDetail];
    }else{
        [self loadData];
    }
    
    
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
        BYLog(@"%@",weakSelf.dataSource);
        if (![weakSelf checkParam]) return;
        [weakSelf sendWork];
      
    };
    self.tableView.tableHeaderView = tableHeader;
    self.tableView.tableFooterView = footView;
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
    if (_sendOrderType == BYUnpackSendOrderType) {
        dict[@"appointServiceItemVo"] = _parameterModel.appointServiceItemVo;
        dict[@"uninstallReson"] = @(_parameterModel.uninstallReson);
    }else{
        dict[@"wirelessDeviceProvider"] = _parameterModel.wirelessDeviceProvider;
        dict[@"wirelineDeviceProvider"] = _parameterModel.wirelineDeviceProvider;
        dict[@"otherDeviceProvider"] = _parameterModel.otherDeviceProvider;
        dict[@"wirelessDeviceCount"] = @(_parameterModel.wirelessDeviceCount);
        dict[@"wirelineDeviceCount"] = @(_parameterModel.wirelineDeviceCount);
        dict[@"otherDeviceCount"] = @(_parameterModel.otherDeviceCount);
        dict[@"needToAudit"] = @(_parameterModel.needToAudit);
    }
   
    switch (self.sendOrderType) {
        case BYWorkSendOrderType:
            dict[@"serviceType"] = @(1);
            break;
        case BYUnpackSendOrderType://拆机
            dict[@"serviceType"] = @(3);
            break;
        default:
            dict[@"serviceType"] = @(2);
            break;
    }
    dict[@"province"] = _parameterModel.province;
    dict[@"provinceId"] = @(_parameterModel.provinceId);
    dict[@"city"] = _parameterModel.city;
    dict[@"cityId"] = @(_parameterModel.cityId);
    dict[@"area"] = _parameterModel.area;
    dict[@"areaId"] = @(_parameterModel.areaId);
    dict[@"serviceAddress"] = _parameterModel.serviceAddress;
    dict[@"serviceAddressLat"] = _parameterModel.serviceAddressLat;
    dict[@"serviceAddressLon"] = _parameterModel.serviceAddressLon;
    dict[@"contactPerson"] = _parameterModel.contactPerson;
    dict[@"contactTel"] = _parameterModel.contactTel;
    dict[@"publishType"] = @(_parameterModel.publishType);
    if (!_parameterModel.publishType) {//派单类型 0：指派 1：抢单
       
        dict[@"technicianId"] = @(_parameterModel.technicianId);
        dict[@"technicianName"] = _parameterModel.technicianName;
    }
    
    dict[@"carId"] = @(_parameterModel.carId);
    dict[@"carVin"] = _parameterModel.carVin;
    dict[@"carBrand"] = _parameterModel.carBrand;
    dict[@"carModel"] = _parameterModel.carModel;
    dict[@"carNum"] = _parameterModel.carNum;
    dict[@"carColor"] = _parameterModel.carColor;
    dict[@"carOwnerName"] = _parameterModel.carOwnerName;
    dict[@"orderRemark"] = _parameterModel.orderRemark;
    if (_isEdit) {
        dict[@"orderNo"] = _detailModel.orderNo;
    }
    return dict;
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
    [weakSelf clearArchiver];
    BYSendOrderResultViewController *vc = [[BYSendOrderResultViewController alloc] init];
    vc.resultType = BYSendWorkSucessType;
    vc.sendOrderType = _sendOrderType;
    vc.titleStr = @"派单结果";
    
    [weakSelf.navigationController pushViewController:vc animated:YES];
}



///派单 成功清楚缓存
- (void)clearArchiver{
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
}

#pragma mark -- 订单详情接口
- (void)loadOrderDetail{
 [self.dataSource removeAllObjects];
    NSMutableArray *arr = self.detailModel.gps;
    for (int i = 0; i<arr.count; i++) {
        BYDeviceModel *model = arr[i];
        BYDeviceModel *model1 = [[BYDeviceModel alloc] init];
        model1.deviceSn = model.deviceSn;
        model1.deviceProvider = model.deviceProvider;
        model1.deviceType = model.deviceType;
        model1.devicePosition = model.devicePosition;
        model1.deviceCount = model.deviceCount;
        model1.isSelect = YES;
        if (i == 0) {
            model1.isAdd = YES;
        }else{
            model1.isAdd = NO;
        }
        [self.dataSource addObject:model1];
    }
    
}

#pragma mark -- 检查参数
- (BOOL)checkParam{
  
    if (_sendOrderType == BYWorkSendOrderType) {
        [self clear];
        for (BYDeviceModel *model in self.dataSource) {
            if (model.deviceType == 1) {
                if (self.parameterModel.wirelessDeviceProvider.length == 0) {
                    self.parameterModel.wirelessDeviceProvider = [NSString stringWithFormat:@"%@/%zd",model.deviceProvider,model.deviceCount];
                    self.parameterModel.wirelessDeviceCount = model.deviceCount;
                }else{
                    self.parameterModel.wirelessDeviceProvider = [NSString stringWithFormat:@"%@,%@/%zd",self.parameterModel.wirelessDeviceProvider,model.deviceProvider,model.deviceCount];
                    self.parameterModel.wirelessDeviceCount = self.parameterModel.wirelessDeviceCount + model.deviceCount;
                }
                
            }else if (model.deviceType == 0){
                if (self.parameterModel.wirelineDeviceProvider.length == 0) {
                    self.parameterModel.wirelineDeviceProvider = [NSString stringWithFormat:@"%@/%zd",model.deviceProvider,model.deviceCount];
                    self.parameterModel.wirelineDeviceCount = model.deviceCount;
                }else{
                    self.parameterModel.wirelineDeviceProvider = [NSString stringWithFormat:@"%@,%@/%zd",self.parameterModel.wirelineDeviceProvider,model.deviceProvider,model.deviceCount];
                    self.parameterModel.wirelineDeviceCount = self.parameterModel.wirelineDeviceCount + model.deviceCount;
                }
            }else{
                if (self.parameterModel.otherDeviceProvider.length == 0) {
                    self.parameterModel.otherDeviceProvider = [NSString stringWithFormat:@"%@/%zd",model.deviceProvider,model.deviceCount];
                    self.parameterModel.otherDeviceCount = model.deviceCount;
                }else{
                    self.parameterModel.otherDeviceProvider = [NSString stringWithFormat:@"%@,%@/%zd",self.parameterModel.otherDeviceProvider,model.deviceProvider,model.deviceCount];
                    self.parameterModel.otherDeviceCount = self.parameterModel.otherDeviceCount + model.deviceCount;
                }
            }
        }
        if (self.dataSource.count == 0) {
            BYShowError(@"请选择装有设备的车辆");
            return NO;
        }
    }else if (_sendOrderType == BYRepairSendOrderType){//检修

    }else{//拆机
        NSMutableArray *arr = [NSMutableArray array];
        for (BYDeviceModel *model in self.dataSource){
            if (model.isSelect) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"deviceProvider"] = model.deviceProvider.length?model.deviceProvider:@"";
                dict[@"deviceSn"] = model.deviceSn;
                dict[@"deviceType"] = @(model.deviceType);
                dict[@"devicePosition"] = model.devicePosition.length?model.devicePosition:@"0";

                [arr addObject:dict];
            }
           
        }
        
        self.parameterModel.appointServiceItemVo = arr;
        if (arr.count == 0) {
            BYShowError(@"请选择拆机设备");
            return NO;
        }
    }
   
    return YES;
}
- (void)clear{
    self.parameterModel.wirelessDeviceProvider = @"";
    self.parameterModel.wirelineDeviceProvider = @"";
    self.parameterModel.otherDeviceProvider = @"";
    self.parameterModel.wirelessDeviceCount = 0;
    self.parameterModel.wirelineDeviceCount = 0;
    self.parameterModel.otherDeviceCount = 0;
}

#pragma mark -- 装机派单
//- (void)

#pragma mark -- 获取设备数据
- (void)loadData{
    if (_sendOrderType == BYWorkSendOrderType) {
        //编辑通过接口返回数量  派单直接本地拼接数据
        BYDeviceModel *model = [[BYDeviceModel alloc] init];
        model.deviceProvider = @"标越设备";
        model.deviceType = 0;
        model.deviceCount = 1;
        model.isAdd = YES;
        model.isSelect = YES;
        BYDeviceModel *model1 = [[BYDeviceModel alloc] init];
        model1.deviceProvider = @"标越设备";
        model1.deviceType = 1;
        model1.deviceCount = 1;
        model1.isAdd = NO;
        model1.isSelect = YES;
        [self.dataSource addObject:model];
        [self.dataSource addObject:model1];
        [self.tableView reloadData];
    }else{
        BYWeakSelf;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"carId"] = @(self.parameterModel.carId);

        
        [BYSendWorkHttpTool POSTDeviceByCarParams:dict success:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.dataSource = [[NSArray yy_modelArrayWithClass:[BYDeviceModel class] json:data] mutableCopy];
                for (BYDeviceModel *model in weakSelf.dataSource) {
                    model.isSelect = YES;
                }
                [weakSelf.tableView reloadData];
            });
        } failure:^(NSError *error) {
            
        }];
    }
    
    
   
    
}

#pragma mark -- tableview 数据源 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BYWeakSelf;
    if (_sendOrderType == BYWorkSendOrderType) {
        BYDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYDeviceInfoCell" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.model = self.dataSource[indexPath.row];
        cell.addBlock = ^(BYDeviceModel *model) {
            BYDeviceModel *model1 = [[BYDeviceModel alloc] init];
            model1.deviceProvider = @"标越设备";
            model1.deviceType = 0;
            model1.deviceCount = 1;
            model1.isAdd = NO;
            [weakSelf.dataSource addObject:model1];
            [weakSelf.tableView reloadData];
        };
        cell.minusBlock = ^(BYDeviceModel *model) {
            
            [weakSelf.dataSource removeObject:model];
            [weakSelf.tableView reloadData];
        };
        cell.deviceCountAddOrMinusBlock = ^{
            [weakSelf.tableView reloadData];
        };
        return cell;
    }else{//拆机cell
        BYRepairDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYRepairDeviceInfoCell"];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.repairDeviceInfoBlock = ^(BYDeviceModel *model) {
            [weakSelf.dataSource replaceObjectAtIndex:indexPath.row withObject:model];
            [weakSelf.tableView reloadData];
        };
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = WHITE;
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = BYGlobalBlueColor;
        UILabel *label = [UILabel verLab:15 textRgbColor:BYLabelBlackColor textAlighment:NSTextAlignmentLeft];
        label.text = @"请选择设备数量";
    UILabel *countLabel = [UILabel verLab:13 textRgbColor:BYLabelBlackColor textAlighment:NSTextAlignmentRight];
    self.countLabel = countLabel;
    NSInteger count = 0;
    //拆机
    if (self.sendOrderType == BYUnpackSendOrderType) {
        for (BYDeviceModel *deviceModel in self.dataSource) {
            
            count =  deviceModel.isSelect ? count  + 1 : count;
        }
        countLabel.text = [NSString stringWithFormat:@"共拆除%zd台设备",count];
        countLabel.attributedText = [BYObjectTool changeStrWittContext:[NSString stringWithFormat:@"共拆除%zd台设备",count] ChangeColorText:[NSString stringWithFormat:@"%zd",count] WithColor:BYGlobalBlueColor WithFont:[UIFont systemFontOfSize:20]];
    }else{
        for (BYDeviceModel *deviceModel in self.dataSource) {
            count = deviceModel.deviceCount + count;
        }
        countLabel.text = [NSString stringWithFormat:@"共安装%zd台设备",count];
        countLabel.attributedText = [BYObjectTool changeStrWittContext:[NSString stringWithFormat:@"共安装%zd台设备",count] ChangeColorText:[NSString stringWithFormat:@"%zd",count] WithColor:BYGlobalBlueColor WithFont:[UIFont systemFontOfSize:20]];
    }
//    for (BYDeviceModel *deviceModel in self.dataSource) {
//        count = deviceModel.deviceCount + count;
//    }
//    countLabel.text = [NSString stringWithFormat:@"共安装%zd台设备",count];
//    countLabel.attributedText = [BYObjectTool changeStrWittContext:[NSString stringWithFormat:@"共安装%zd台设备",count] ChangeColorText:[NSString stringWithFormat:@"%zd",count] WithColor:BYGlobalBlueColor WithFont:[UIFont systemFontOfSize:20]];
    UIView *spaceView = [[UIView alloc] init];
    spaceView.backgroundColor = BYBigSpaceColor;
        [view addSubview:line];
        [view addSubview:label];
        [view addSubview:countLabel];
        [view addSubview:spaceView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(5, 15));
            make.centerY.equalTo(view);
            make.left.mas_equalTo(20);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(line.mas_right).offset(8);
        }];
    [countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.right.mas_equalTo(-20);
    }];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MAXWIDTH - 12, 0.5));
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
        BYRegisterCell(BYDeviceInfoCell);
        BYRegisterCell(BYRepairDeviceInfoCell);
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
