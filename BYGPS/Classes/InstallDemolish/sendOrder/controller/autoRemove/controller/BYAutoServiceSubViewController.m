//
//  BYAutoServiceSubViewController.m
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceSubViewController.h"
#import "BYAutoServiceDeviceRemoveController.h"
#import "BYAutoServiceDeviceRepairController.h"
#import "BYAutoServiceSuccessViewController.h"

#import "EasyNavigation.h"

#import "BYAutoServiceCarInfoCell.h"
#import "BYAutoServiceDeviceInfoCell.h"
#import "BYAutoServiceRemoveConclusionCell.h"
#import "BYAutoServiceRepairRemarkCell.h"
#import "BYAutoServiceCommitFooterView.h"

#import "BYAutoServiceHttpTool.h"
#import "BYAutoServiceDeviceModel.h"
#import "BYAutoServiceCarModel.h"
#import "BYObjectTool.h"
#import "BYRemoveConclusionModel.h"
#import "BYAlertTip.h"

@interface BYAutoServiceSubViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) BYAutoServiceCommitFooterView *footerView;


@property (nonatomic,assign) NSInteger uninstallReson;
@property (nonatomic,strong) BYRemoveConclusionModel *removeConclusionModel;

@property (nonatomic,strong) NSString *repairRemarkStr;


@end

@implementation BYAutoServiceSubViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BYStatusBarDefault;
}
- (void)backAction{
//    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationView setTitle:self.functionType == BYFunctionTypeRemove ? @"自助拆" : @"自助检修"];
    
    [self initBase];
    [self initDataBase];
    
    
}

-(void)initBase{
    [self.view addSubview:self.tableView];
    
    self.footerView = [BYAutoServiceCommitFooterView by_viewFromXib];
    self.footerView.by_height = 76.f;
    
    BYWeakSelf;
    [self.footerView setRemoveOrRepairSubmitBlock:^{
        
        [BYAlertTip ShowAlertWith:@"" message:self.functionType == BYFunctionTypeRemove ? @"确定要拆除这些设备吗?" : @"确定要提交检修信息吗？" withCancelTitle:@"取消" withSureTitle:@"确定" viewControl:weakSelf andSureBack:^{
            [weakSelf submitRemoveOrRepair];
        } andCancelBack:^{
            
        }];
        
        
    }];
    
    self.tableView.tableFooterView = self.footerView;
    
    
}

-(void)initDataBase{
    if (self.functionType == BYFunctionTypeRemove) {
        _uninstallReson = 0;
        self.removeConclusionModel = [[BYRemoveConclusionModel alloc] init];
        self.removeConclusionModel.uninstallReson = 0;
        self.removeConclusionModel.remarkStr = @"";
        
    }
    
    [BYAutoServiceHttpTool POSTQuickOrderGetCarDeviceWithCarId:self.carModel.carId success:^(id data) {
        
        for (NSDictionary *dic in data) {
            BYAutoServiceDeviceModel *model = [[BYAutoServiceDeviceModel alloc] initWithDictionary:dic error:nil];
            model.repairScheme = model.repairScheme == 0 ? 1 : model.repairScheme;
            model.isRemoved = 0;
//            model.serviceReson = model.serviceReson == 0 ? 1 : model.serviceReson;
            [self.dataSource addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (self.dataSource.count == 0) {
                UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"" message:@"没有该车设备监控权限或该车没有绑定设备" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [alertvc addAction:okAction];
                [self presentViewController:alertvc animated:YES completion:nil];
            }
        });
        
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count + 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BYWeakSelf;
    //车辆信息cell
    if (indexPath.row == 0) {
        BYAutoServiceCarInfoCell *carInfoCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceCarInfoCell" forIndexPath:indexPath];
        carInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        carInfoCell.carModel = self.carModel;
        
        return carInfoCell;
    }
    //拆机 拆机结论cell。检修 检修备注cell
    else if (indexPath.row == self.dataSource.count + 1){
        if (self.functionType == BYFunctionTypeRemove) {
            BYAutoServiceRemoveConclusionCell *removeConclusionCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceRemoveConclusionCell" forIndexPath:indexPath];
            removeConclusionCell.selectionStyle = UITableViewCellSelectionStyleNone;
            removeConclusionCell.conclusionModel = self.removeConclusionModel;
            [removeConclusionCell setRemoveReasonBlock:^{
                [weakSelf alertRemoveReasonWithConclusionModel:self.removeConclusionModel];
            }];
            
            return removeConclusionCell;
        }else{
            BYAutoServiceRepairRemarkCell *repairRemarkCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceRepairRemarkCell" forIndexPath:indexPath];
            repairRemarkCell.selectionStyle = UITableViewCellSelectionStyleNone;
            repairRemarkCell.remarkStr = self.repairRemarkStr;
            [repairRemarkCell setRemarkInputBlock:^(NSString *remarkStr) {
                self.repairRemarkStr = remarkStr;
            }];
            return repairRemarkCell;
        }
    }
    //设备信息cell
    else{
        BYAutoServiceDeviceInfoCell *deviceInfoCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceDeviceInfoCell" forIndexPath:indexPath];
        deviceInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        deviceInfoCell.functionType = self.functionType;
        BYAutoServiceDeviceModel *model = self.dataSource[indexPath.row - 1];
        deviceInfoCell.model = model;
        deviceInfoCell.titleLabel.text = [NSString stringWithFormat:@"设备%zd",indexPath.row];
        
        //拆机或检修
        kWeakSelf(self);
        __block BYAutoServiceDeviceModel *deviceBlockModel = model;
        [deviceInfoCell setRemoveOrRepairBlock:^{
            [weakself dropToRemoveOrRepairWithDeviceModel:deviceBlockModel index:indexPath.row - 1];
        }];
        
        return deviceInfoCell;
    }
}


#pragma mark --跳转到拆机或检修

-(void)dropToRemoveOrRepairWithDeviceModel:(BYAutoServiceDeviceModel *)deviceModel index:(NSInteger)index{
    
    if (self.functionType == BYFunctionTypeRemove) {
        BYAutoServiceDeviceRemoveController *removeVC = [BYAutoServiceDeviceRemoveController new];
        
//        __weak typeof(deviceModel) weakdeviceModel = deviceModel;
//        __block BYAutoServiceDeviceModel *deviceBlockModel = deviceModel;
        [removeVC setControllerPopBlock:^(BYAutoServiceDeviceModel *devModel) {
            
            
            
//            deviceBlockModel = devModel;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataSource replaceObjectAtIndex:index withObject:devModel];
                [self.tableView reloadData];
            });
        }];
        removeVC.deviceModel = [deviceModel copy];
//        deviceModel = deviceBlockModel;
        
        [self.navigationController pushViewController:removeVC animated:YES];
    }
    else{
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.carModel.carGroupId forKey:@"groupId"];
//        __block BYAutoServiceDeviceModel *deviceHpModel = deviceModel;
        [BYAutoServiceHttpTool POSTQuickGroupControlWithParams:params success:^(id data) {
            deviceModel.control = [data[@"control"] integerValue];
            BYAutoServiceDeviceRepairController *repairDeviceVC = [BYAutoServiceDeviceRepairController new];
//            __block BYAutoServiceDeviceModel *deviceBlockModel = deviceModel;
            [repairDeviceVC setControllerPopBlock:^(BYAutoServiceDeviceModel *devModel) {
                [self.dataSource replaceObjectAtIndex:index withObject:devModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            }];
//            deviceHpModel = deviceBlockModel;
            repairDeviceVC.carModel = self.carModel;
            repairDeviceVC.deviceModel = [deviceModel copy];
            dispatch_async(dispatch_get_main_queue(), ^{
               [self.navigationController pushViewController:repairDeviceVC animated:YES];
            });
            
            
        } failure:^(NSError *error) {
            
        }];
            
        
        
        
    }

}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //车辆信息cell
    if (indexPath.row == 0) {
        
        return 108.0f;
    }
    //拆机 拆机结论cell。检修 检修备注cell
    else if (indexPath.row == 4){
        if (self.functionType == BYFunctionTypeRemove) {
            
            return 250.0f;
        }else{
            
            return 180.0f;
        }
    }
    //设备信息cell
    else{
        
        return 266.0f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    NSInteger removeCount = 0;
    
    for (BYAutoServiceDeviceModel *deviceModel in self.dataSource) {
        if (deviceModel.repaired) {
            removeCount ++;
        }
    }
    [self.footerView.submitButton setTitle:self.functionType == BYFunctionTypeRemove ?  [NSString stringWithFormat:@"提交（共拆除%zd台设备）",removeCount] : [NSString stringWithFormat:@"提交（共检修%zd台设备）",removeCount] forState:UIControlStateNormal];
    return 10.0f;
}

-(void)alertRemoveReasonWithConclusionModel:(BYRemoveConclusionModel *)conclusionModel{
    UIAlertController *alertVc = [BYObjectTool alertRemoveReasonWith:^{
        _uninstallReson = 1;
        conclusionModel.uninstallReson = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } wrongRelated:^{
        _uninstallReson = 2;
        conclusionModel.uninstallReson = 2;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } regretLoan:^{
        _uninstallReson = 3;
        conclusionModel.uninstallReson = 3;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    if ([BYObjectTool getIsIpad]){
        
        alertVc.popoverPresentationController.sourceView = self.view;
        alertVc.popoverPresentationController.sourceRect =  CGRectMake(100, 100, 1, 1);
    }
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark 拆机或检修提交数据

-(void)submitRemoveOrRepair{
    [self.view endEditing:YES];
    
#pragma mark 拆机提交
    if (self.functionType == BYFunctionTypeRemove) {
        NSInteger removeCount = 0;
        
        for (BYAutoServiceDeviceModel *deviceModel in self.dataSource) {
            if (deviceModel.repaired) {
                removeCount ++;
            }
        }
        
        if (self.removeConclusionModel.uninstallReson == 0) {
            return BYShowError(@"请选择拆机原因");
        }
        
        if (removeCount == 0) {
            return BYShowError(@"至少要完成一个设备拆机");
        }else{
            
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            [paramDic setValue:self.carModel.carBrand forKey:@"carBrand"];
            [paramDic setValue:self.carModel.carColor forKey:@"carColor"];
            [paramDic setValue:self.carModel.carId forKey:@"carId"];
            [paramDic setValue:self.carModel.carModel forKey:@"carModel"];
            [paramDic setValue:self.carModel.carNum forKey:@"carNum"];
            [paramDic setValue:self.carModel.carOwner forKey:@"carOwnerName"];
            [paramDic setValue:self.carModel.carOwnerTel forKey:@"carOwnerTel"];
            [paramDic setValue:self.carModel.carType forKey:@"carType"];
            [paramDic setValue:self.carModel.carVin forKey:@"carVin"];
            [paramDic setValue:self.carModel.carGroupId forKey:@"groupId"];
            [paramDic setValue:self.removeConclusionModel.remarkStr forKey:@"orderRemark"];
            [paramDic setValue:@(2) forKey:@"source"];
            [paramDic setValue:[BYSaveTool valueForKey:BYUid] forKey:@"technicianId"];
            [paramDic setValue:[BYSaveTool valueForKey:nickName] forKey:@"technicianName"];
            [paramDic setValue:@(self.removeConclusionModel.uninstallReson) forKey:@"uninstallReson"];
            
            NSMutableArray *deviceJsonArr = [NSMutableArray array];
            for (BYAutoServiceDeviceModel *deviceModel in self.dataSource) {
                if (!deviceModel.repaired) {
                    continue;
                }
                //埋点
                //1设备已拆除，解除关联 2设备未拆除，未解除关联 3设备未拆除，强制解除关联
                switch (deviceModel.isRemoved) {
                    case 1:
                        MobClickEvent(@"dismantle_unbind", @"");
                        break;
                    case 2:
                        MobClickEvent(@"Nodismantle_bind", @"");
                        break;
                        MobClickEvent(@"Nodismantle_unbind", @"");
                    default:
                        break;
                }
                NSMutableDictionary *deviceDic = [NSMutableDictionary dictionary];
                [deviceDic setValue:self.carModel.carId forKey:@"carId"];
                [deviceDic setValue:self.carModel.carVin forKey:@"carVin"];
                [deviceDic setValue:deviceModel.deviceGroup forKey:@"deviceGroup"];
                [deviceDic setValue:deviceModel.deviceId forKey:@"deviceId"];
                [deviceDic setValue:deviceModel.deviceModel forKey:@"deviceModel"];
                [deviceDic setValue:deviceModel.devicePosition forKey:@"devicePosition"];
                
                [deviceDic setValue:deviceModel.deviceSn forKey:@"deviceSn"];
                [deviceDic setValue:@"标越GPS设备" forKey:@"deviceSupplier"];
                [deviceDic setValue:@(deviceModel.deviceType) forKey:@"deviceType"];
                
                [deviceDic setValue:deviceModel.deviceVinImg forKey:@"deviceVinImg"];
                
                [deviceDic setValue:self.carModel.carGroupId forKey:@"groupId"];
                [deviceDic setValue:@(deviceModel.isRemoved) forKey:@"isRemoved"];
                [deviceJsonArr addObject:deviceDic];
            }
            [paramDic setValue:deviceJsonArr forKey:@"deviceList"];
            
            BYLog(@"%@",paramDic);
            BYWeakSelf;
            [BYAutoServiceHttpTool POSTQuickRemoveCommitWithParams:paramDic success:^(id data) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    BYAutoServiceSuccessViewController *successVC = [BYAutoServiceSuccessViewController new];
                    successVC.functionType = self.functionType;
                    [weakSelf.navigationController pushViewController:successVC animated:YES];
                });
                
            } failure:^(NSError *error) {
                
            }];
        }
    }
#pragma mark 检修提交
    else {
        NSInteger removeCount = 0;
        
        for (BYAutoServiceDeviceModel *deviceModel in self.dataSource) {
            if (deviceModel.repaired) {
                removeCount ++;
            }
        }
        
        if (removeCount == 0) {
            return BYShowError(@"至少要完成一个设备检修");
        }
        else{
            
            NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
            [paramDic setValue:self.carModel.carBrand forKey:@"carBrand"];
            [paramDic setValue:self.carModel.carColor forKey:@"carColor"];
            [paramDic setValue:self.carModel.carId forKey:@"carId"];
            [paramDic setValue:self.carModel.carModel forKey:@"carModel"];
            [paramDic setValue:self.carModel.carNum forKey:@"carNum"];
            [paramDic setValue:self.carModel.carOwner forKey:@"carOwnerName"];
            [paramDic setValue:self.carModel.carOwnerTel forKey:@"carOwnerTel"];
            [paramDic setValue:self.carModel.carType forKey:@"carType"];
            [paramDic setValue:self.carModel.carVin forKey:@"carVin"];
            [paramDic setValue:self.carModel.carGroupId forKey:@"groupId"];
            [paramDic setValue:self.removeConclusionModel.remarkStr forKey:@"orderRemark"];
            [paramDic setValue:@(2) forKey:@"source"];
            [paramDic setValue:[BYSaveTool valueForKey:BYUid] forKey:@"technicianId"];
            [paramDic setValue:[BYSaveTool valueForKey:nickName] forKey:@"technicianName"];
            
            NSMutableArray *deviceJsonArr = [NSMutableArray array];
            for (BYAutoServiceDeviceModel *deviceModel in self.dataSource) {
                if (!deviceModel.repaired) {
                    continue;
                }
                NSMutableDictionary *deviceDic = [NSMutableDictionary dictionary];
                
                [deviceDic setValue:deviceModel.deviceGroup forKey:@"deviceGroup"];
                [deviceDic setValue:deviceModel.recentlyDeviceModel forKey:@"deviceModel"];
                [deviceDic setValue:deviceModel.deviceModel forKey:@"oldDeviceModel"];
                
                [deviceDic setValue:deviceModel.recentlyDevicePosition forKey:@"devicePosition"];
                [deviceDic setValue:deviceModel.devicePosition forKey:@"oldDevicePosition"];
                
                
                [deviceDic setValue:deviceModel.repairScheme == 1 ? deviceModel.deviceSn : deviceModel.recentlyDeviceSn forKey:@"deviceSn"];
                [deviceDic setValue:deviceModel.deviceSn forKey:@"oldDeviceSn"];
                
                [deviceDic setValue:@"标越GPS设备" forKey:@"deviceSupplier"];
                [deviceDic setValue:@"标越GPS设备" forKey:@"oldDeviceSupplier"];
                
                [deviceDic setValue:@(deviceModel.recentlyDeviceType) forKey:@"deviceType"];
                [deviceDic setValue:@(deviceModel.deviceType) forKey:@"oldDeviceType"];
                
                [deviceDic setValue:deviceModel.imgUrl forKey:@"imgUrl"];
                
                [deviceDic setValue:deviceModel.vinDeviceImg forKey:@"vinDeviceImg"];
                
                [deviceDic setValue:@(deviceModel.repairScheme) forKey:@"repairScheme"];
                [deviceDic setValue:@(deviceModel.serviceReson) forKey:@"serviceReson"];
                [deviceJsonArr addObject:deviceDic];
            }
            [paramDic setValue:deviceJsonArr forKey:@"deviceList"];
            BYWeakSelf;
            [BYAutoServiceHttpTool POSTQuickRepairCommitWithParams:paramDic success:^(id data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BYAutoServiceSuccessViewController *successVC = [BYAutoServiceSuccessViewController new];
                    successVC.functionType = self.functionType;
                    [weakSelf.navigationController pushViewController:successVC animated:YES];
                });
            } failure:^(NSError *error) {
                
            }];
        }
    }
    
}


#pragma mark --LAZY

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight - SafeAreaBottomHeight + 49) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorHexFromRGB(0xececec);
//        _tableView.hidden = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        BYRegisterCell(BYAutoServiceCarInfoCell);
        BYRegisterCell(BYAutoServiceDeviceInfoCell);
        BYRegisterCell(BYAutoServiceRemoveConclusionCell);
        BYRegisterCell(BYAutoServiceRepairRemarkCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_tableView];
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
