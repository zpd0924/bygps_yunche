//
//  BYInfoController.m
//  BYGPS
//
//  Created by miwer on 16/7/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYInfoController.h"
#import "BYSettingGroup.h"
#import "BYSettingBlueArrowItem.h"
#import "BYSettingNoneItem.h"
#import "BYInfoHeaderView.h"
#import "BYAlarmListController.h"
#import "BYRelationCarController.h"
#import "BYDetailTabBarController.h"
#import "BYAutoScanViewController.h"
#import "BYAutoServiceSubViewController.h"
#import "EasyNavigation.h"
#import "BYDeviceDetailHttpTool.h"
#import "BYRegeoHttpTool.h"
#import "BYAutoServiceConstant.h"

#import "BYDeviceInfoModel.h"
#import "BYPushNaviModel.h"
#import "BYFirstFillInfoController.h"
#import "BYSelectDeviceController.h"
#import "BYDateFormtterTool.h"
#import "NSDate+BYDistanceDate.h"
#import "UILabel+BYCaculateHeight.h"
#import "NSString+BYAttributeString.h"
#import "BYDeviceInfoFooterView.h"

#import "BYAutoServiceHttpTool.h"
#import "BYAutoServiceCarModel.h"
#import "BYInstallDeviceCheckViewController.h"
#import "BYInstallSendOrderController.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

@interface BYInfoController () <BMKGeoCodeSearchDelegate>

@property(nonatomic,strong) BYInfoHeaderView * header;
@property(nonatomic,strong) BMKGeoCodeSearch * searcher;
@property(nonatomic,strong) BYDeviceInfoModel * model;

@property (nonatomic,strong) BYAutoServiceCarModel *autoServiceCarModel;

@property(nonatomic,assign) NSInteger deviceId;
@property (nonatomic,strong) NSString *deviceSn;
@property (nonatomic,strong) NSString *shareId;//分享id
@property (nonatomic,assign) BOOL testOK;

@end

@implementation BYInfoController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _searcher.delegate = nil;
    BYStatusBarDefault;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.tabBarController.navigationView removeAllRightButton];
    [self.tabBarController.navigationView setTitle:@"设备详情"];

}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BYDetailTabBarController * tabBarVC = (BYDetailTabBarController *)self.tabBarController;
    _deviceId = tabBarVC.model.deviceId;
    _deviceSn = tabBarVC.model.sn;
    self.shareId = tabBarVC.model.shareId;
    [self loadDataWith:tabBarVC.model.deviceId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
}

-(void)loadDataWith:(NSInteger)deviceId{
    
    BYWeakSelf;
    [BYDeviceDetailHttpTool POSTDeviceDetailWithDeviceId:deviceId success:^(id data) {
        
        BYDeviceInfoModel * model = [[BYDeviceInfoModel alloc] initWithDictionary:data error:nil];
        BYDetailTabBarController * tabBarVC = (BYDetailTabBarController *)self.tabBarController;
        tabBarVC.model.deviceId = model.deviceId;
        tabBarVC.model.model = model.model;
        tabBarVC.model.wifi = model.wifi;
        tabBarVC.model.sn = model.sn;
        tabBarVC.model.carId = model.carId;
        tabBarVC.model.carNum = model.carNum;
        tabBarVC.model.carVin = model.carVin;
        model.shareId = tabBarVC.model.shareId;
        self.model = model;
        
        BYAutoServiceCarModel *carModel = [[BYAutoServiceCarModel alloc] init];
        carModel.carId = [NSString stringWithFormat:@"%zd",model.carId];
        carModel.carModel = model.carModel;
        carModel.carNum = model.carNum;
        carModel.carVin = model.carVin;
        carModel.carType = model.carType;
        carModel.carBrand = model.brand;
        carModel.carColor = model.carColor;
        carModel.carOwner = model.ownerName;
        carModel.carOwnerTel = model.ownerTel;
        carModel.carGroupId = model.carGroupId;
        self.autoServiceCarModel = carModel;
        
      
        dispatch_async(dispatch_get_main_queue(), ^{
              [weakSelf setupGroupWith:model];
            [weakSelf.tableView reloadData];
        });
    } showHUD:YES];
}

-(void)initBase{
    self.tableView.frame = CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight - SafeAreaBottomHeight );
    if (@available(iOS 11.0, *)) {
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        }
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationView setNavigationBackgroundColor:[UIColor whiteColor]];
    self.BYTableViewCellStyle = UITableViewCellStyleValue1;
    self.tableView.sectionFooterHeight = 0.01;
}

-(void)geoDecodeWith:(double)lat lon:(double)lon{
    
    [BYRegeoHttpTool POSTRegeoAddressWithLat:lat lng:lon success:^(id data) {
        BYSettingGroup * group = self.groups[1];
        BYSettingNoneItem * item = [group.items firstObject];
        if ([self.model.model isEqualToString:@"013C"]) {
            item.title = [NSString stringWithFormat:@"最后位置: 无法获取当前位置"];
            item.row_H = BYS_W_H(20);
        }else{
            if ([data[@"address"] isEqualToString:@""]) {
                item.title = [NSString stringWithFormat:@"最后位置: 无法获取当前位置"];
                item.row_H = BYS_W_H(20);
            }else{
                item.subTitle = [NSString stringWithFormat:@"%@",data[@"address"]];
                item.row_H = [UILabel caculateLabel_HWith:BYSCREEN_W *3/4 Title:item.subTitle font:BYS_W_H(17)];
            }
        }
        item.textFont = BYS_W_H(17);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSError *error) {
        BYSettingGroup * group = self.groups[1];
        BYSettingNoneItem * item = [group.items firstObject];
        item.title = [NSString stringWithFormat:@"最后位置: 无法获取当前位置"];
        item.textFont = BYS_W_H(17);
    }];

}

//接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        
//        BYSettingGroup * group = self.groups[1];
//        BYSettingNoneItem * item = [group.items firstObject];
//        item.title = [NSString stringWithFormat:@"最后位置: %@",result.address];
//        CGFloat fontScale = result.address.length > 16 ? 16 / (CGFloat)result.address.length : 1;
//        item.textFont = BYS_W_H(fontScale * 17);
//
//        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }else {
        BYLog(@"抱歉，未找到结果");
    }
}

-(void)setupGroupWith:(BYDeviceInfoModel *)model{
    
    NSString * wirelssStr = model.wifi ? @"无线" : @"有线";
    self.header.deviceNumLabel.text = [NSString stringWithFormat:@"%@",model.sn];
    self.header.deviceModel.text = [NSString stringWithFormat:@"设备类型: %@ %@",model.alias,wirelssStr];
    self.header.deviceStatusLabel.text = [NSString stringWithFormat:@"设备状态: %@",model.online];
    self.header.deviceGroupLabel.text = [NSString stringWithFormat:@"所属分组: %@",model.groupName];
    
    BYSettingGroup * group1 = [[BYSettingGroup alloc] init];
    BYSettingBlueArrowItem * item1 = [[BYSettingBlueArrowItem alloc] init];
    item1.title = @"当前设备报警信息";
    
    BYWeakSelf;
    [item1 setOperationBlock:^{
       
        if (![BYSaveTool boolForKey:BYAlarmInfoKey]) {
            return BYShowError(@"没有查看报警权限");
        }
        
        BYAlarmListController * alarmListVC = [[BYAlarmListController alloc] init];
        alarmListVC.deviceId = _deviceId;
//        alarmListVC.deviceSn = _deviceSn;
        [weakSelf.navigationController pushViewController:alarmListVC animated:YES];
    }];
    group1.items = @[item1];
    
    BYSettingGroup * group2 = [[BYSettingGroup alloc] init];

    BYSettingNoneItem * item2 = [[BYSettingNoneItem alloc] init];
    item2.textFont = BYS_W_H(17);
    if (model.lat > 0 && model.lon > 0) {
        [self geoDecodeWith:model.lat lon:model.lon];
    }
    item2.title = [NSString stringWithFormat:@"最后位置:"];
    
    BYSettingNoneItem * item3 = [[BYSettingNoneItem alloc] init];
    item3.textFont = BYS_W_H(17);
    item3.title = model.gpsTime.length > 0 ? [NSString stringWithFormat:@"定位时间:  %@",model.gpsTime] : @"定位时间:";
    
    BYSettingNoneItem * item4 = [[BYSettingNoneItem alloc] init];
    item4.textFont = BYS_W_H(17);
    item4.title = model.updateTime.length > 0 ? [NSString stringWithFormat:@"更新时间:  %@",model.updateTime] : @"更新时间:";
    
    BYSettingNoneItem * item5 = [[BYSettingNoneItem alloc] init];
    item5.textFont = BYS_W_H(17);
    item5.title = model.beginDate ? [NSString stringWithFormat:@"服务期起:  %@",model.beginDate] : @"服务期起:  ---";
    
    BYSettingNoneItem * item6 = [[BYSettingNoneItem alloc] init];
    item6.textFont = BYS_W_H(17);
    item6.title = model.endDate ? [NSString stringWithFormat:@"服务期止:  %@",model.endDate] : @"服务期止:  ---";
    
    group2.items = @[item2,item3,item4,item5,item6];
    
    BYSettingGroup * group3 = [[BYSettingGroup alloc] init];
    
    BYSettingBlueArrowItem * item7 = [[BYSettingBlueArrowItem alloc] init];
    
    NSString *carNumStr;
    if (model.carId > 0) {
        if (model.carNum.length > 0) {
            carNumStr = model.carNum;
            carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
        }else{
            carNumStr =[NSString stringWithFormat:@"%@",model.carVin];
        }
    }else{
        carNumStr = @"该设备未装车";
    }
    
    item7.title = [NSString stringWithFormat:@"关联车辆：%@",carNumStr];
    
    if (model.carId > 0) {
        
        BYWeakSelf;
        [item7 setOperationBlock:^{
            
            BYRelationCarController * relationVC = [[BYRelationCarController alloc] init];
            relationVC.model = model;
            
            [relationVC setRelativeIdBlock:^(NSInteger deviceId) {
                [weakSelf loadDataWith:deviceId];
            }];
            [weakSelf.navigationController pushViewController:relationVC animated:YES];
        }];
    }
    
    if (model.carId > 0) {
        
        BYSettingNoneItem * item8 = [[BYSettingNoneItem alloc] init];
        item8.textFont = BYS_W_H(17);
        item8.title = [NSString stringWithFormat:@"车辆状态:  %@",[model.online rangeOfString:@"离线"].location == NSNotFound ?model.carStatus : @""];
        
        BYSettingNoneItem * item9 = [[BYSettingNoneItem alloc] init];
        item9.textFont = BYS_W_H(17);
        item9.title = [NSString stringWithFormat:@"车主姓名:  %@",[[BYSaveTool valueForKey:BYCarOwnerInfo] boolValue] ? model.ownerName : [NSString stringWithFormat:@"%@***",[model.ownerName.length>0?model.ownerName:@" " substringToIndex:1]]];
        
        BYSettingNoneItem * item10 = [[BYSettingNoneItem alloc] init];
        item10.textFont = BYS_W_H(17);
        item10.title = [NSString stringWithFormat:@"车型品牌:  %@",model.brand.length > 0 ? model.brand : @"-"];
        
        BYSettingNoneItem * item11 = [[BYSettingNoneItem alloc] init];
        item11.textFont = BYS_W_H(17);
        item11.title = [NSString stringWithFormat:@"业务员:  %@",model.salesman.length > 0 ? model.salesman : @""];
        if (!model.wifi) {
            group3.items = @[item7,item8,item9,item10,item11];
        }else{
            group3.items = @[item7,item9,item10,item11];
        }
    }else{
        group3.items = @[item7];
    }
    
    [self.groups removeAllObjects];//移除所有分组
    [self.groups addObject:group1];
    [self.groups addObject:group2];
    [self.groups addObject:group3];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return section == 0 ? BYS_W_H(128) : 5;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return section == 0 ? self.header : nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == 2) {
        
        if (![BYSaveTool boolForKey:BYAutoInstallOrder]) {
//            return BYShowError(@"你没有该模块的权限");
            return nil;
        }else{
            
            BYDeviceInfoFooterView *footerView = [BYDeviceInfoFooterView by_viewFromXib];
            
            footerView.by_height = 125;
            footerView.by_width = BYSCREEN_W;
            if ((_model.carId == 0) || !_model.carId) {
                footerView.installButton.hidden = NO;
                footerView.repairButton.hidden = YES;
                footerView.removeButton.hidden = YES;
            }else{
                footerView.installButton.hidden = YES;
                footerView.repairButton.hidden = NO;
                footerView.removeButton.hidden = NO;
            }
            
            [footerView setInstallBlock:^{
//                BYAutoScanViewController *vc = [[BYAutoScanViewController alloc] init];
//                vc.scanType = WQCodeScannerTypeBarcode;
//                vc.carSn = self.model.sn;
//                [self.navigationController pushViewController:vc animated:YES];
                BYInstallDeviceCheckViewController *vc = [[BYInstallDeviceCheckViewController alloc] init];
                vc.deviceSn = self.model.sn;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            [footerView setRepairBlock:^{
                
                [self checkOrderWith:BYFunctionTypeRepair];
                
//                BYAutoServiceSubViewController *vc =   [[BYAutoServiceSubViewController alloc] init];
//                vc.functionType = BYFunctionTypeRepair;
//                vc.carModel = self.autoServiceCarModel;
//
//                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            [footerView setRemoveBlock:^{
                [self checkOrderWith:BYFunctionTypeRemove];
//                BYAutoServiceSubViewController *vc =   [[BYAutoServiceSubViewController alloc] init];
//                vc.functionType = BYFunctionTypeRemove;
//                vc.carModel = self.autoServiceCarModel;
//                [self.navigationController pushViewController:vc animated:YES];
            }];
            
            return footerView;
        }
        
//        if ([BYSaveTool boolForKey:installAuthorityKey] && ((_model.carId == 0) | !_model.carId)) {
//
//            UIView * view = [[UIView alloc] init];
//            UIButton * button = [UIButton buttonWithMargin:15 backgroundColor:[UIColor redColor] title:@"安装设备" target:self action:@selector(install:)];
//            [view addSubview:button];
//            return view;
//
//        }else if ([BYSaveTool boolForKey:demolitionAuthorityKey] && _model.carId > 0){
//            UIView * view = [[UIView alloc] init];
//            UIButton * button = [UIButton buttonWithMargin:15 backgroundColor:[UIColor redColor] title:@"设备拆除" target:self action:@selector(install:)];
//            [view addSubview:button];
//            return view;
//        }else{
//            return nil;
//        }
    }else{
        return nil;
    }
}

-(void)checkOrderWith:(BYFunctionType)functionType{
    
    NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
//    [paraDic setValue:carModel.groupIds forKey:@"groupId"];
    [paraDic setValue:self.autoServiceCarModel.carId forKey:@"carId"];
    
    [BYAutoServiceHttpTool POSTQuickCheckIsSendOrderWithParams:paraDic success:^(id data) {
        
        if ([data[@"status"] integerValue] == 0) {
            
            if (functionType == BYFunctionTypeRemove) {
                NSMutableDictionary *removePara = [NSMutableDictionary dictionary];
                [removePara setValue:self.autoServiceCarModel.carId forKey:@"carId"];
                
                [BYAutoServiceHttpTool POSTQuickCheckIsRemoveWithParams:removePara success:^(id data) {
                    if ([data[@"status"] integerValue] == 0) {
                        
                        BYAutoServiceSubViewController *serviceSubVC = [BYAutoServiceSubViewController new];
                        
                        serviceSubVC.functionType = functionType;
                        //    serviceSubVC.carId = carModel.carId;
                        serviceSubVC.carModel = self.autoServiceCarModel;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.navigationController pushViewController:serviceSubVC animated:YES];
                        });
                        
                    }else{
                        BYShowError(@"该车辆不能进行拆机操作！！！");
                    }
                    
                } failure:^(NSError *error) {
                    
                }];
            }else{
                BYAutoServiceSubViewController *serviceSubVC = [BYAutoServiceSubViewController new];
                
                serviceSubVC.functionType = functionType;
                //    serviceSubVC.carId = carModel.carId;
                serviceSubVC.carModel = self.autoServiceCarModel;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:serviceSubVC animated:YES];
                });
            }
        }else{
            BYShowError(@"车辆派单中不能操作！！！");
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BYSettingGroup *group = self.groups[indexPath.section];
    BYSettingNoneItem *item = group.items[indexPath.row];
    if (indexPath.section == 1 && indexPath.row == 0 ) {
        return BYS_W_H(item.row_H + 27);
    }
    return BYS_W_H(47);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 2 ? BYS_W_H(125) : 0.01;
}

-(void)install:(UIButton *)btn{
    if ([btn.titleLabel.text isEqualToString:@"安装设备"]) {
        MobClickEvent(@"details_install", @"");
    }else{
        MobClickEvent(@"details_down", @"");
    }
    BYInstallSendOrderController *vc = [[BYInstallSendOrderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
//    if (_model.carId > 0) {//拆机
//        BYSelectDeviceController * selectVc = [[BYSelectDeviceController alloc] init];
//        selectVc.isImages = YES;
//        selectVc.carNum = _model.carNum.length > 0 ? _model.carNum : (_model.carVin.length > 6 ? ([NSString stringWithFormat:@"...%@",[_model.carVin substringWithRange:NSMakeRange(_model.carVin.length - 6, 6)]]) : _model.carVin );
//        selectVc.ownerName = _model.ownerName;
//        selectVc.carId = _model.carId;
//        [self.navigationController pushViewController:selectVc animated:YES];
//    }else{//安装
//        
//        if (!self.model.isCcid) {
//            return BYShowError(@"该设备没有关联CCID，无法安装，请更换设备");
//        }
//
//        if ([_model.model isEqualToString:@"013C"]) {
//            BYFirstFillInfoController * fillVc = [[BYFirstFillInfoController alloc] init];
//            fillVc.deviceId = _model.deviceId;
//            fillVc.isWirless = _model.wifi;
//            [self.navigationController pushViewController:fillVc animated:YES];
//        }else{
//            if (_model.wifi) {//无线电量不足或者定位超过两个小时
//                
//                NSArray *batterArr = [_model.batteryNotifier componentsSeparatedByString:@"%"];
//
//                if ([batterArr[0] floatValue] < 30) {
//                    return [BYProgressHUD by_showErrorWithStatus:@"设备电量不足,不可录入资料"];
//                }
//                //定位超过两个小时改为只要有定位时间就可安装
//                if (_model.gpsTime == nil) {
//                    return BYShowError(@"设备未曾定位，不可录入资料");
//                }
//            }
//            
//            if (!_model.wifi && [_model.online rangeOfString:@"在线"].location == NSNotFound) {
//                return [BYProgressHUD by_showErrorWithStatus:@"设备不在线,不可录入资料"];
//            }
//            if([_model.model isEqualToString:@"021D"]){
//
//                [BYDeviceDetailHttpTool POSTJudgeTest021DWith:_deviceId success:^(id data) {
//                    self.testOK = [data[@"isTest"] boolValue];
//                    if (self.testOK) {
//                        BYFirstFillInfoController * fillVc = [[BYFirstFillInfoController alloc] init];
//                        fillVc.deviceId = _model.deviceId;
//                        fillVc.isWirless = _model.wifi;
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self.navigationController pushViewController:fillVc animated:YES];
//                        });
//                    }else{
//                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"注意" message:@"此021D设备未进行断油实测，是否继续安装?" preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                            
//                            BYFirstFillInfoController * fillVc = [[BYFirstFillInfoController alloc] init];
//                            fillVc.deviceId = _model.deviceId;
//                            fillVc.isWirless = _model.wifi;
//                            [self.navigationController pushViewController:fillVc animated:YES];
//                            
//                        }];
//                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//                        
//                        [alertVC addAction:okAction];
//                        [alertVC addAction:cancelAction];
//                        [self presentViewController:alertVC animated:YES completion:nil];
//                    }
//                }];
//            }else{
//                BYFirstFillInfoController * fillVc = [[BYFirstFillInfoController alloc] init];
//                fillVc.deviceId = _model.deviceId;
//                fillVc.isWirless = _model.wifi;
//                [self.navigationController pushViewController:fillVc animated:YES];
//            }
//        }
//    }
}

#pragma mark - lazy
-(BYInfoHeaderView *)header{
    if (_header == nil) {
        _header = [BYInfoHeaderView by_viewFromXib];
    }
    return _header;
}


@end
