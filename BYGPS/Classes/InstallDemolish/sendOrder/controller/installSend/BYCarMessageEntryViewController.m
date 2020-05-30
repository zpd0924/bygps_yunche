//
//  BYCarMessageEntryViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCarMessageEntryViewController.h"
#import "EasyNavigation.h"
#import "BYCarMessageSearchResultCell.h"
#import "BYInstallHeaderView.h"
#import "BYNaviSearchBar.h"
#import "BYCarMessageEntryFootView.h"
#import "BYDeviceInfoViewController.h"
#import "UIButton+HNVerBut.h"
#import "WQCodeScanner.h"
#import "BYCarMessageSearchResultNoDataCell.h"
#import "BYCarMessageSearchViewController.h"
#import "BYKeepDeviceInfoViewController.h"
#import "YBCustomCameraVC.h"
#import "BYSearchCarByNumOrVinModel.h"
#import "YBCustomCameraVC.h"

@interface BYCarMessageEntryViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BYNaviSearchBar *naviSearchBar;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation BYCarMessageEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    if (_isEdit) {
        [self loadOrderDetail];
    }
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBase{
    [self.navigationView setTitle:@"车辆信息"];
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
    [self.view addSubview:self.tableView];
    BYInstallHeaderView * tableHeader = [BYInstallHeaderView by_viewFromXib];
    tableHeader.workOrderInfoLabel.text = @"工单信息";
    tableHeader.carInfoLabel.text = @"车辆信息";
    tableHeader.deviceInfoLabel.text = @"设备信息";
    tableHeader.showStepIndex = 1;
    tableHeader.frame = CGRectMake(0, 0, BYSCREEN_W, 70);
    tableHeader.topNoticeView.hidden = YES;
    tableHeader.topH.constant = -30;
    self.tableView.tableHeaderView = tableHeader;
    BYCarMessageEntryFootView *carMessageEntryFootView = [BYCarMessageEntryFootView by_viewFromXib];
    carMessageEntryFootView.frame = CGRectMake(0, 0, MAXWIDTH, 100);
    carMessageEntryFootView.backgroundColor = BYBigSpaceColor;

    
    carMessageEntryFootView.nextStepClickBlock = ^{
        if (![weakSelf checkParam]) return;
        switch (_sendOrderType) {
            case 0://安装
            {
                BYDeviceInfoViewController *vc = [[BYDeviceInfoViewController alloc] init];
                vc.sendOrderType = weakSelf.sendOrderType;
                vc.parameterModel = weakSelf.parameterModel;
                vc.isEdit = _isEdit;
                vc.detailModel = self.detailModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 1://拆机
            {
                BYDeviceInfoViewController *vc = [[BYDeviceInfoViewController alloc] init];
                vc.sendOrderType = weakSelf.sendOrderType;
                vc.parameterModel = weakSelf.parameterModel;
                vc.isEdit = _isEdit;
                vc.detailModel = self.detailModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
            default://检修
            {
                BYKeepDeviceInfoViewController *vc = [[BYKeepDeviceInfoViewController alloc] init];
                vc.sendOrderType = weakSelf.sendOrderType;
                vc.parameterModel = weakSelf.parameterModel;
                vc.isEdit = _isEdit;
                vc.detailModel = self.detailModel;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
       
    };
    self.tableView.tableFooterView = carMessageEntryFootView;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
   
  
    
}

#pragma mark --- 检查参数
- (BOOL)checkParam{
    if (!self.dataSource.count) {
        BYShowError(@"请选择车辆信息");
        return NO;
    }
    BYSearchCarByNumOrVinModel *model = self.dataSource.firstObject;
    self.parameterModel.carId = model.carId;
    self.parameterModel.carVin = model.carVin;
    self.parameterModel.carBrand = model.brand;
    self.parameterModel.carModel = model.carModel;
    self.parameterModel.carNum = model.carNum;
    self.parameterModel.carColor = model.color;
    self.parameterModel.carOwnerName = model.ownerName;
    return YES;
}

#pragma mark -- 订单详情数据
- (void)loadOrderDetail{
 
    BYSearchCarByNumOrVinModel *model = [[BYSearchCarByNumOrVinModel alloc] init];
    model.carId = self.detailModel.carId;
    model.carVin = self.detailModel.carVin;
    model.brand = self.detailModel.carBrand;
    model.carModel = self.detailModel.carModel;
    model.carNum = self.detailModel.carNum;
    model.color = self.detailModel.carColor;
    model.ownerName = self.detailModel.carOwnerName;
    [self.dataSource removeAllObjects];
    [self.dataSource addObject:model];
    [self.tableView reloadData];
}


#pragma mark -- 扫描车牌和车架号
- (void)scanBtnClick{
    /*
    BYWeakSelf;
    if (_sendOrderType == BYWorkSendOrderType) {
        UIAlertController *alertVc = [BYObjectTool showScanAleartCarNumWith:^{
            YBCustomCameraVC *camera = [[YBCustomCameraVC alloc] init];
            camera.index = 1;
            camera.carNumberBlock = ^(NSString *carNumber) {
                BYLog(@"carNumber = %@",carNumber);
                BYCarMessageSearchViewController *vc = [[BYCarMessageSearchViewController alloc] init];
                vc.searchCallBack = ^(BYSearchCarByNumOrVinModel *model) {
                    [weakSelf.dataSource removeAllObjects];
                    [weakSelf.dataSource addObject:model];
                    [weakSelf.tableView reloadData];
                };
                vc.keyWord = carNumber;
                vc.type = 4;
                vc.sendOrderType = weakSelf.sendOrderType;
                vc.carId = weakSelf.detailModel.carId;
                [vc.naviSearchBar.searImageBtn setTitle:@"车牌号" forState:UIControlStateNormal];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            
            
            [self presentViewController:camera animated:YES completion:nil];
        } vinNum:^{
            YBCustomCameraVC *camera = [[YBCustomCameraVC alloc] init];
            camera.index = 2;
            camera.vinBlock = ^(NSString *vin) {
                BYLog(@"vin = %@",vin);
                BYCarMessageSearchViewController *vc = [[BYCarMessageSearchViewController alloc] init];
                vc.searchCallBack = ^(BYSearchCarByNumOrVinModel *model) {
                    [weakSelf.dataSource removeAllObjects];
                    [weakSelf.dataSource addObject:model];
                    [weakSelf.tableView reloadData];
                };
                vc.keyWord = vin;
                vc.type = 4;
                vc.sendOrderType = weakSelf.sendOrderType;
                vc.carId = weakSelf.detailModel.carId;
                [vc.naviSearchBar.searImageBtn setTitle:@"车架号" forState:UIControlStateNormal];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            [self presentViewController:camera animated:YES completion:nil];
        }];
        [self presentViewController:alertVc animated:YES completion:nil];
    }else{
        UIAlertController *alertVc1 = [BYObjectTool showChangeCarNumberOrVinOrSnAleartCarNumWith:^{
            YBCustomCameraVC *camera = [[YBCustomCameraVC alloc] init];
            camera.index = 1;
            camera.carNumberBlock = ^(NSString *carNumber) {
                BYLog(@"carNumber = %@",carNumber);
                BYCarMessageSearchViewController *vc = [[BYCarMessageSearchViewController alloc] init];
                vc.searchCallBack = ^(BYSearchCarByNumOrVinModel *model) {
                    [weakSelf.dataSource removeAllObjects];
                    [weakSelf.dataSource addObject:model];
                    [weakSelf.tableView reloadData];
                };
                vc.keyWord = carNumber;
                vc.type = 4;
                vc.sendOrderType = weakSelf.sendOrderType;
                vc.carId = weakSelf.detailModel.carId;
                vc.scanType = carNumScanType;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            
            
            [self presentViewController:camera animated:YES completion:nil];
        } vinNum:^{
            YBCustomCameraVC *camera = [[YBCustomCameraVC alloc] init];
            camera.index = 2;
            camera.vinBlock = ^(NSString *vin) {
                BYLog(@"vin = %@",vin);
                BYCarMessageSearchViewController *vc = [[BYCarMessageSearchViewController alloc] init];
                vc.searchCallBack = ^(BYSearchCarByNumOrVinModel *model) {
                    [weakSelf.dataSource removeAllObjects];
                    [weakSelf.dataSource addObject:model];
                    [weakSelf.tableView reloadData];
                };
                vc.keyWord = vin;
                vc.type = 4;
                vc.sendOrderType = weakSelf.sendOrderType;
                vc.carId = weakSelf.detailModel.carId;
                vc.scanType = vinNumScanType;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            [self presentViewController:camera animated:YES completion:nil];
        } SnNum:^{
                WQCodeScanner *scanner = [[WQCodeScanner alloc] init];
                scanner.scanType = WQCodeScannerTypeBarcode;
                [self presentViewController:scanner animated:YES completion:nil];
                [scanner setResultBlock:^(NSString *value) {
                    BYCarMessageSearchViewController *vc = [[BYCarMessageSearchViewController alloc] init];
                    vc.searchCallBack = ^(BYSearchCarByNumOrVinModel *model) {
                        [weakSelf.dataSource removeAllObjects];
                        [weakSelf.dataSource addObject:model];
                        [weakSelf.tableView reloadData];
                    };
                    vc.keyWord = value;
                    vc.type = 4;
                    vc.sendOrderType = weakSelf.sendOrderType;
                    vc.carId = weakSelf.detailModel.carId;
                    vc.scanType = deviceScanType;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                }];
            
        }];
        [self presentViewController:alertVc1 animated:YES completion:nil];
    }
    
    */
    BYWeakSelf;
    BYCarMessageSearchViewController *vc = [[BYCarMessageSearchViewController alloc] init];
    vc.searchCallBack = ^(BYSearchCarByNumOrVinModel *model) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObject:model];
        [weakSelf.tableView reloadData];
    };
    vc.type = 4;
    vc.sendOrderType = _sendOrderType;
    vc.carId = _detailModel.carId;
    [self.navigationController pushViewController:vc animated:YES];
   
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
  
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    if (self.dataSource.count) {
        BYCarMessageSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYCarMessageSearchResultCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellStyleDefault;
        cell.delectBlock = ^{
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.tableView reloadData];
        };
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }else{
        BYCarMessageSearchResultNoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYCarMessageSearchResultNoDataCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellStyleDefault;
        return cell;
    }
   
   
 
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 194;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH, 40)];
        view.backgroundColor = WHITE;
        self.naviSearchBar = [[BYNaviSearchBar alloc] initWithFrame:CGRectMake(20, 12.5, MAXWIDTH - 70, 30)];
        self.naviSearchBar.searchField.delegate = self;
    if (_sendOrderType == BYWorkSendOrderType) {
        self.naviSearchBar.searchField.placeholder = @"请输入车牌号/车架号";
    }else{
        self.naviSearchBar.searchField.placeholder = @"请输入车牌号/车架号/设备号";
    }
    
//        [self.naviSearchBar.searchField becomeFirstResponder];
        UIButton *scanBtn = [UIButton verBut:nil textFont:15 titleColor:nil bkgColor:nil];
        scanBtn.frame = CGRectMake(MAXWIDTH - 50, 12.5, 40, 30);
        [scanBtn setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
        [scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:self.naviSearchBar];
        [view addSubview:scanBtn];
        
        return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 55;
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    BYWeakSelf;
    BYCarMessageSearchViewController *vc = [[BYCarMessageSearchViewController alloc] init];
    vc.searchCallBack = ^(BYSearchCarByNumOrVinModel *model) {
        [weakSelf.dataSource removeAllObjects];
        [weakSelf.dataSource addObject:model];
        [weakSelf.tableView reloadData];
    };
    vc.type = 4;
    vc.sendOrderType = _sendOrderType;
    vc.carId = _detailModel.carId;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mrak -- nodata
//- (UIImage *)xy_noDataViewImage {
//    return [UIImage imageNamed:@"note_list_no_data"];
//}
//
//- (NSString *)xy_noDataViewMessage {
//    return @"未选择车辆,请输入车牌号搜索车辆!";
//}
//
//- (UIColor *)xy_noDataViewMessageColor {
//    return BYLabelBlackColor;
//}
//- (NSNumber *)xy_noDataViewCenterYOffset{
//
//    return [NSNumber numberWithInteger:0];
//}


#pragma mark -- lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = BYBigSpaceColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        BYRegisterCell(BYCarMessageSearchResultCell);
        BYRegisterCell(BYCarMessageSearchResultNoDataCell);
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
