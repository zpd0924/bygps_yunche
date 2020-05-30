//
//  BYWorkMessageController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYWorkMessageController.h"
#import "EasyNavigation.h"
#import "BYInstallHeaderView.h"
#import "BYWorkMessageCell.h"
#import "BYWorkMessageBottomCell.h"
#import "BYWorkMessageFootView.h"
#import "BYChoiceEngineerViewController.h"
#import "BYCarMessageEntryViewController.h"
#import "UILabel+HNVerLab.h"
#import <Masonry.h>
#import "BYPickView.h"
#import "BYWorkMessageModel.h"
#import "BYArchiverManager.h"
#import "BYChoiceEngineerModel.h"
#import "BYOrderDetailModel.h"
#import "BYSendWorkParameterModel.h"
#import "BYChoiceServerAdressViewController.h"
#import "BYInstallSendOrderController.h"
#import "BYDetailAddressSearchViewController.h"

@interface BYWorkMessageController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,weak) BYWorkMessageFootView *workMessageFootView;
@property (nonatomic,strong) BYWorkMessageModel *workMessageModel;

@property (nonatomic,strong) BYOrderDetailModel *detailModel;
@property (nonatomic,strong) BYSendWorkParameterModel *parameterModel;//派单所需参数
@end

@implementation BYWorkMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
   
    if (_isEdit) {
        [self loadOrderDetail];
    }
    
}
- (void)backAction{
    if (self.navigationController.viewControllers.count > 3) {
       
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[BYInstallSendOrderController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!_isEdit) {
        [self readAchicer];
    }
     [BYProgressHUD by_dismiss];
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!_isEdit) {
        [self saveAchicer];
    }
    
}

- (void)saveAchicer{
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
     [[BYArchiverManager shareManagement] saveDataArchiver:self.workMessageModel andAPIKey:key];
}
- (void)readAchicer{
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
    if ([[BYArchiverManager shareManagement] archiverQueryAPIKey:key]) {
        self.workMessageModel = [[BYArchiverManager shareManagement] archiverQueryAPIKey:key];
    }else{
        self.workMessageModel = [[BYWorkMessageModel alloc] init];
    }
   self.workMessageModel.sendCompany = [BYSaveTool valueForKey:groupName];
    if (!self.workMessageModel.uninstallReson) {
        self.workMessageModel.uninstallReson = 1;
    }
    if (!self.workMessageModel.isSelctCheck) {
         self.workMessageModel.isCheck = 1;
    }
    self.workMessageFootView.workMessageModel = self.workMessageModel;
}

- (void)initBase{
    [self.navigationView setTitle:_titleLabelStr];
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
    tableHeader.showStepIndex = 0;
   
    self.tableView.tableHeaderView = tableHeader;
    BYWorkMessageFootView *workMessageFootView = [BYWorkMessageFootView by_viewFromXib];
    self.workMessageFootView = workMessageFootView;
    workMessageFootView.workMessageModel = self.workMessageModel;
    workMessageFootView.frame = CGRectMake(0, 0, MAXWIDTH, 210);
    workMessageFootView.workMessageFootViewNextClickBlock = ^{
        
        if(![weakSelf checkParam]) return;
        BYCarMessageEntryViewController *vc = [[BYCarMessageEntryViewController alloc] init];
        vc.sendOrderType = weakSelf.sendOrderType;
        vc.parameterModel = weakSelf.parameterModel;
        vc.isEdit = _isEdit;
        if (_isEdit) {
            vc.detailModel = weakSelf.detailModel;
        }
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    };
    workMessageFootView.editBlock = ^(NSString *str) {
        weakSelf.workMessageModel.comment = str;
    };
    self.tableView.tableFooterView = workMessageFootView;
    switch (_sendOrderType) {
        case BYWorkSendOrderType://装机
           
            break;
        case BYUnpackSendOrderType://拆机
          
            break;
        default://检修
           
            break;
    }
    
}

#pragma mark -- 订单详情接口
- (void)loadOrderDetail{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"orderNo"] = _orderNo;
    [BYSendWorkHttpTool POSSendOrderDetailParams:dict sendOrderType:weakSelf.sendOrderType success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.detailModel = [BYOrderDetailModel yy_modelWithDictionary:data];
            weakSelf.detailModel.orderNo = self.orderNo;
            [weakSelf refreshData];
        });
       
    } failure:^(NSError *error) {
        
    }];
}
- (void)refreshData{
    self.workMessageModel = [[BYWorkMessageModel alloc] init];
     self.workMessageModel.sendCompany = [BYSaveTool valueForKey:groupName];
    self.workMessageModel.serverAdress = [NSString stringWithFormat:@"%@%@",_detailModel.province,_detailModel.city];
    self.workMessageModel.detailAdress = _detailModel.installAddress;
    self.workMessageModel.pid = [NSString stringWithFormat:@"%zd",_detailModel.provinceId];
    self.workMessageModel.cityId = [NSString stringWithFormat:@"%zd",_detailModel.cityId];
    self.workMessageModel.areaId = [NSString stringWithFormat:@"%zd",_detailModel.areaId];
    self.workMessageModel.pName = _detailModel.province;
    self.workMessageModel.cityName = _detailModel.city;
    self.workMessageModel.areaName = _detailModel.area;
    self.workMessageModel.sendType = _detailModel.publishType;
    self.workMessageModel.serverName = _detailModel.technicianName;
    self.workMessageModel.serverId = _detailModel.technicianId;
    self.workMessageModel.isCheck = _detailModel.needToAudit;
    if (_detailModel.contactTel.length || _detailModel.contactPerson.length) {
         self.workMessageModel.contacts = [NSString stringWithFormat:@"%@,%@",_detailModel.contactPerson,_detailModel.contactTel];
    }
    self.workMessageModel.comment = _detailModel.orderRemark;
    self.workMessageModel.uninstallReson = _detailModel.uninstallReson;
    self.workMessageFootView.workMessageModel = self.workMessageModel;
    [self.tableView reloadData];
}


#pragma mark --- 检查参数
- (BOOL)checkParam{
    if (self.workMessageModel.serverAdress.length == 0) {
        BYShowError(@"服务地址不能为空");
        return NO;
    }
    if (self.workMessageModel.detailAdress.length == 0) {
        BYShowError(@"详细地址不能为空");
        return NO;
    }
    if (!self.workMessageModel.sendType) {
        if (self.workMessageModel.serverId.length == 0) {
            BYShowError(@"服务技师不能为空");
            return NO;
        }
    }
    if (self.workMessageModel.contacts.length) {
        if (![BYObjectTool isContactsFormat:self.workMessageModel.contacts]) {
            BYShowError(@"联系人格式不对");
            return NO;
        }
    }
    if (_sendOrderType == BYUnpackSendOrderType) {
        
        if (!self.workMessageModel.uninstallReson) {
            BYShowError(@"拆机原因不能为空");
            return NO;
        }
    }
  
    self.parameterModel.provinceId = [_workMessageModel.pid integerValue];
    self.parameterModel.province = _workMessageModel.pName;
    self.parameterModel.cityId = [_workMessageModel.cityId integerValue];
    self.parameterModel.city = _workMessageModel.cityName;
    self.parameterModel.areaId = [_workMessageModel.areaId integerValue];
    self.parameterModel.area = _workMessageModel.areaName;
    self.parameterModel.serviceAddress = _workMessageModel.detailAdress;
    self.parameterModel.serviceAddressLat = _workMessageModel.serviceAddressLat;
    self.parameterModel.serviceAddressLon = _workMessageModel.serviceAddressLon;
    self.parameterModel.publishType = _workMessageModel.sendType;
    self.parameterModel.technicianName = _workMessageModel.serverName;
    self.parameterModel.technicianId = [_workMessageModel.serverId integerValue];
    self.parameterModel.uninstallReson = _workMessageModel.uninstallReson;
    if (self.sendOrderType == BYRepairSendOrderType) {
        self.parameterModel.serviceType = 2;
    }else if(self.sendOrderType == BYUnpackSendOrderType ){
        self.parameterModel.serviceType = 3;
    }
    self.parameterModel.needToAudit = [[BYSaveTool valueForKey:BYNeedToAudit] integerValue] == 2 ? _workMessageModel.isCheck : [[BYSaveTool valueForKey:BYNeedToAudit] integerValue];
    
    NSArray *arr = [NSArray array];
    //判断中文逗号
    if ([self.workMessageModel.contacts containsString:@"，"]) {
        arr = [self.workMessageModel.contacts componentsSeparatedByString:@"，"];
    }else{
      arr = [self.workMessageModel.contacts componentsSeparatedByString:@","];
    }
    
    
    self.parameterModel.contactPerson = arr.firstObject;
    self.parameterModel.contactTel = arr.lastObject;
    self.parameterModel.orderRemark = _workMessageModel.comment;
    return YES;
}

#pragma mark -- 选择拆机原因
- (void)choiceUnpackReason{
    BYPickView * pickView = [[BYPickView alloc] initWithpickViewWith:@"选择拆机原因" dataSource:@[@"清贷拆机",@"关联错误",@"悔贷拆机"] currentTitle:@"关联错误"];
    BYWeakSelf;
    [pickView setSurePickBlock:^(NSString *currentStr) {
        
        if ([currentStr isEqualToString:@"清贷拆机"]) {
            weakSelf.workMessageModel.uninstallReson = 1;
        }else if ([currentStr isEqualToString:@"关联错误"]){
             weakSelf.workMessageModel.uninstallReson = 2;
        }else if([currentStr isEqualToString:@"悔贷拆机"]){
             weakSelf.workMessageModel.uninstallReson = 3;
        }
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.titleArray[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    BYWeakSelf;
    BYWorkMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYWorkMessageCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.sendOrderType = _sendOrderType;
    cell.indexPath = indexPath;
    cell.workMessageModel = self.workMessageModel;
    cell.messageCellBlock = ^(MessageType type, NSString *str) {
        switch (type) {
            case serveAdressType:
                break;
            case detailAdressType:
                weakSelf.workMessageModel.detailAdress = str;
                weakSelf.parameterModel.serviceAddress = str;
                break;
            case sendType:
            {
                 weakSelf.workMessageModel.sendType = [str integerValue];
                weakSelf.parameterModel.publishType = [str integerValue];
                [weakSelf.tableView reloadData];
                
            }
                break;
            case serveType:
                 weakSelf.workMessageModel.serverName = str;
                weakSelf.parameterModel.technicianName = str;
                break;
            case checkType:
                weakSelf.workMessageModel.isCheck = ![str integerValue];
                weakSelf.parameterModel.needToAudit = ![str integerValue];
                if (self.sendOrderType == BYWorkSendOrderType) {
                    if ([str integerValue] == 0) {
                        MobClickEvent(@"install_check_yes", @"");
                    }else{
                        MobClickEvent(@"install_check_no", @"");
                    }
                }else if(self.sendOrderType == BYRepairSendOrderType){
                    if ([str integerValue] == 0) {
                        MobClickEvent(@"Overhaul_check_yes", @"");
                    }else{
                        MobClickEvent(@"Overhaul_check_no", @"");
                    }
                }
                weakSelf.workMessageModel.isSelctCheck = 1;
                break;
            case contactsType:
                weakSelf.workMessageModel.contacts = str;
                [weakSelf saveAchicer];
                [weakSelf.tableView reloadData];
                break;
                
            default:
                break;
        }
    };
    return cell;
    
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(_sendOrderType == BYUnpackSendOrderType){
        return 46;
    }else{
        if (indexPath.section == 1 && indexPath.row == 2) {
            return 55;
        }else{
            return 46;
        }
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BYWeakSelf;
    if ([self.titleArray[indexPath.section][indexPath.row] isEqualToString:@"*服务技师"]) {
        if (!self.workMessageModel.sendType) {
            if (self.workMessageModel.areaName.length == 0) {
                return BYShowError(@"请选择服务地区");
            }
            BYChoiceEngineerViewController *vc = [[BYChoiceEngineerViewController alloc] init];
            vc.areaId = self.workMessageModel.areaId;
            vc.serviceAdress = self.workMessageModel.serverAdress;
            vc.choiceServerBlock = ^(BYChoiceEngineerModel *engineerModel) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!engineerModel) return;
                    weakSelf.workMessageModel.serverId = [NSString stringWithFormat:@"%zd",engineerModel.ID];
                    weakSelf.workMessageModel.serverName = engineerModel.nickName;
                    [weakSelf saveAchicer];
                    [weakSelf.tableView reloadData];
                });
               
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if ([self.titleArray[indexPath.section][indexPath.row] isEqualToString:@"*拆机原因"]){
        [self choiceUnpackReason];
    }else if ([self.titleArray[indexPath.section][indexPath.row] isEqualToString:@"*服务地区"]){
        BYChoiceServerAdressViewController *vc = [[BYChoiceServerAdressViewController alloc] init];
        vc.choiceServerAdressBlock = ^(NSDictionary *dict) {
            BYLog(@"dict = %@",dict);
            weakSelf.workMessageModel.serverAdress = [NSString stringWithFormat:@"%@%@%@",dict[@"pName"],dict[@"cityName"],dict[@"areaName"]];
            weakSelf.workMessageModel.pid = dict[@"pid"];
             weakSelf.workMessageModel.pName = dict[@"pName"];
             weakSelf.workMessageModel.cityId = dict[@"cityId"];
             weakSelf.workMessageModel.cityName = dict[@"cityName"];
             weakSelf.workMessageModel.areaId = dict[@"areaId"];
             weakSelf.workMessageModel.areaName = dict[@"areaName"];
            [weakSelf saveAchicer];
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if ([BYSaveTool boolForKey:sameAdd]) {
         if ([self.titleArray[indexPath.section][indexPath.row] isEqualToString:@"*详细地址"]){
             BYDetailAddressSearchViewController *addressSearchVC = [[BYDetailAddressSearchViewController alloc] init];
             [addressSearchVC setDetailAddressBlock:^(NSDictionary * _Nonnull info) {
                 //                 weakSelf.workMessageModel.detailAdress =
                 self.workMessageModel.detailAdress = [info valueForKey:@"detailAddress"];
                 self.workMessageModel.serviceAddressLat = [info valueForKey:@"latitude"];
                 self.workMessageModel.serviceAddressLon = [info valueForKey:@"longitude"];
                 [weakSelf saveAchicer];
                 [self.tableView reloadData];
             }];
             [self.navigationController pushViewController:addressSearchVC animated:YES];
         }
    }
   
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = WHITE;
    if (section == 0) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = BYGlobalBlueColor;
        UILabel *label = [UILabel verLab:15 textRgbColor:BYLabelBlackColor textAlighment:NSTextAlignmentLeft];
        label.text = @"派单信息填写";
        [view addSubview:line];
        [view addSubview:label];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(5, 15));
            make.centerY.equalTo(view);
            make.left.mas_equalTo(20);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.equalTo(line.mas_right).offset(8);
        }];
    }else{
        view.frame = CGRectMake(0, 0, MAXWIDTH, 5);
        view.backgroundColor = BYBigSpaceColor;
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 44;
    }else{
        return 5;
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
//}

#pragma mark -- lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        [_tableView registerClass:[BYWorkMessageCell class] forCellReuseIdentifier:@"BYWorkMessageCell"];
        BYRegisterCell(BYWorkMessageBottomCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

-(NSArray *)titleArray
{
    if (!_titleArray) {
        if (_sendOrderType == BYUnpackSendOrderType) {
            _titleArray = @[@[@"*派单公司",@"*服务地区",@"*详细地址"],@[@"*派单类型",@"*服务技师",@"*拆机原因",@"联系人"]];
        }else{
            _titleArray = @[@[@"*派单公司",@"*服务地区",@"*详细地址"],@[@"*派单类型",@"*服务技师",@"*是否需要审核",@"联系人"]];
        }
        
    }
    return _titleArray;
}
-(BYSendWorkParameterModel *)parameterModel
{
    if (!_parameterModel) {
        _parameterModel = [[BYSendWorkParameterModel alloc] init];
    }
    return _parameterModel;
}

@end
