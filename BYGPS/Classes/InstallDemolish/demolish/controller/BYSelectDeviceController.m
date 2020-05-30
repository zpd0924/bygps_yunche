//
//  BYSelectDemolishController.m
//  父子控制器
//
//  Created by miwer on 2016/12/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSelectDeviceController.h"
#import "BYSelectDeviceDemolishHeader.h"
#import "BYSelectDeviceCell.h"
#import "BYSelectDeviceDemolishFooter.h"
#import "UIButton+BYFooterButton.h"
#import "BYAppointmentDeviceModel.h"
#import "BYDemolishDeviceModel.h"
#import "BYInstallDemolishHttpTool.h"
#import "BYInstallModel.h"
#import "BYPickView.h"
#import "BYSubmitAppontmentParams.h"
#import "BYDemolishSuccessController.h"
#import "EasyNavigation.h"


@interface BYSelectDeviceController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,strong) BYSelectDeviceDemolishHeader * header;
@property(nonatomic,strong) NSArray * demolishReasons;
@property(nonatomic,strong) BYSubmitAppontmentParams * httpParams;
@property(nonatomic,strong) NSString * selectReason;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation BYSelectDeviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    
    [self loadData];
}

-(void)loadData{
    
    if (self.isImages) {//如果是直接拆除
        [BYInstallDemolishHttpTool POSTDemolishLoadDevicesByCarNum:self.carId success:^(id data) {
            BYLog(@"data : %@",data);
            [self.dataSource addObjectsFromArray:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }else{//拆机预约
        
        BYInstallModel * model = self.fillInfoArr.firstObject;
        [BYInstallDemolishHttpTool POSTAppointmentLoadDevicesByCarNum:model.subTitle success:^(id data) {
            BYLog(@"%@",data);
            [self.dataSource addObjectsFromArray:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    }
}

-(void)initBase{
    
    [self.navigationView setTitle: @"选择拆除设备"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //添加headerView
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, BYS_W_H(50))];
    self.tableView.tableHeaderView = header;
    [header addSubview:self.header];//添加车牌的头部
    
    self.demolishReasons = @[@"清贷拆机",@"关联错误",@"悔贷拆机",@"售后更换设备"];
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 100)];
    UIButton * footerButton = [UIButton buttonWithMargin:25 backgroundColor:BYGlobalBlueColor title:self.isImages ? @"确认拆机" : @"提交预约" target:self action:@selector(submitAction)];
    [footerView addSubview:footerButton];
    self.tableView.tableFooterView = footerView;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYSelectDeviceCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableView];
}

-(void)submitAction{
    
    if (self.selectReason == nil) {
        return [BYProgressHUD by_showErrorWithStatus:@"请选择拆机原因"];
    }
    if (![self isHaveSelectedDevice]) {
        return [BYProgressHUD by_showErrorWithStatus:@"请选择要拆除的设备"];
    }
    
    if (self.isImages) {
        // 1清贷拆机 2关联错误 3悔贷拆机 4售后更换设备
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"deviceId"] = [self appendStringWithIsSn:NO];
        
        params[@"cause"] = @([self.demolishReasons indexOfObject:self.selectReason] + 1);
        
        [BYInstallDemolishHttpTool POSTDemolishSureWith:params success:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                BYDemolishSuccessController * successVc = [[BYDemolishSuccessController alloc] init];
                
                //用于拆机成功后返回到设备列表要求刷新
                [[NSNotificationCenter defaultCenter] postNotificationName:BYDemolishInstallSuccessNotifiKey object:nil];
                
                [self.navigationController pushViewController:successVc animated:YES];
            });
        }];
    }else{
        self.httpParams.reason = [self.demolishReasons indexOfObject:self.selectReason] + 1;
        self.httpParams.deviceModel = [self appendDeviceModel];
        
        [BYInstallDemolishHttpTool POSTSubmitAppointmentWith:self.httpParams success:^(id data) {
            
            BYLog(@"data : %@",data);
            
            //用于预约成功后返回到订单列表要求刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BYSubmitAppointmentNotiKey" object:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController popToViewController:self animated:YES];
            });
        }];
    }
}

-(BOOL)isHaveSelectedDevice{
    
    NSMutableArray * tempArr = [NSMutableArray array];
    
    if (self.isImages) {
        for (BYDemolishDeviceModel * model in self.dataSource) {
            if (model.isSelect) {
                [tempArr addObject:model];
            }
        }
    }else{
        for (BYAppointmentDeviceModel * model in self.dataSource) {
            if (model.isSelect) {
                [tempArr addObject:model];
            }
        }
    }
    return tempArr.count > 0 ? YES : NO;
}

-(NSString *)appendStringWithIsSn:(BOOL)isSn{
    
    NSMutableArray * tempArr = [NSMutableArray array];
    
    if (self.isImages) {
        for (BYDemolishDeviceModel * model in self.dataSource) {
            if (model.isSelect) {
                [tempArr addObject:model.deviceId];
            }
        }
    }else{
        for (BYAppointmentDeviceModel * model in self.dataSource) {
            if (model.isSelect) {
                isSn ? [tempArr addObject:model.sn] : [tempArr addObject:model.deviceID];
            }
        }
    }
    return [tempArr componentsJoinedByString:@","];
    //    return tempArr;
}

-(NSArray *)appendDeviceModel{
    
    NSMutableArray * tempArr = [NSMutableArray array];
    
    if (self.isImages) {
        for (BYDemolishDeviceModel * model in self.dataSource) {
            if (model.isSelect) {
                [tempArr addObject:model];
            }
        }
    }else{
        for (BYAppointmentDeviceModel * model in self.dataSource) {
            self.httpParams.carVin = model.carVin;
            self.httpParams.carNum = model.carNum;
            self.httpParams.ownerName = model.ownerName;
            if (model.isSelect) {
                [tempArr addObject:model];
            }
        }
    }
    return tempArr;
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYSelectDeviceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.isHidenImageBgView = !self.isImages;//隐藏或显示图片区域
    
    if (self.isImages) {//确认拆机
        BYDemolishDeviceModel * model = self.dataSource[indexPath.row];
        NSMutableArray *imgArr = [NSMutableArray array];
        if ((model.deviceImgUrl.length > 0) && (model.connectionIntallImgUrl.length > 0)) {
            [imgArr addObject:model.deviceImgUrl];
            [imgArr addObject:model.connectionIntallImgUrl];
            if (model.obligateUrl.length > 0) {
                if ([model.obligateUrl containsString:@","]) {
                    if ([[model.obligateUrl substringFromIndex:model.obligateUrl.length - 1] isEqualToString:@","]) {
                        model.obligateUrl = [model.obligateUrl substringToIndex:model.obligateUrl.length - 1];
                        BYLog(@"%@",model.obligateUrl);
                    }
                    NSArray * tempImageArr = [model.obligateUrl componentsSeparatedByString:@","];
                    
                    [imgArr addObjectsFromArray:tempImageArr];
                }else{
                    [imgArr addObject:model.obligateUrl];
                }
            }
        }
        cell.demolishModel = model;
        cell.imgArr = imgArr;
        [cell setSelectDeviceBlock:^(BOOL isSelect) {
            model.isSelect = isSelect;
        }];
    }else{//预约拆机
        BYAppointmentDeviceModel * model = self.dataSource[indexPath.row];
        cell.appointmentModel = model;
        [cell setSelectDeviceBlock:^(BOOL isSelect) {
            model.isSelect = isSelect;
        }];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.isImages) {
        //根据照片张数来计算图片高度
        CGFloat width = (BYSCREEN_W - 6 * 10) / 3 + 10;
        BYDemolishDeviceModel * model = self.dataSource[indexPath.row];
        
        NSArray * tempImageArr = [model.obligateUrl componentsSeparatedByString:@","];
        NSInteger lineNum = tempImageArr.count > 1 ? 2 : 1;
        
        return 10 + 35 + width * lineNum + model.mark_H;
    }else{
        return 35;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, BYSCREEN_W, 30)];
    label.text = @"关联设备";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    [view addSubview:label];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    BYSelectDeviceDemolishFooter * footer = [BYSelectDeviceDemolishFooter by_viewFromXib];
    
    __weak typeof(footer) weakFooter = footer;
    [footer setReasonBlock:^{
        
        self.selectReason = @"清贷拆机";
        weakFooter.reason = @"清贷拆机";
        BYPickView * pickView = [[BYPickView alloc] initWithpickViewWith:@"请选择拆机原因" dataSource:self.demolishReasons currentTitle:self.selectReason];
        
        [pickView setSurePickBlock:^(NSString *currentStr) {
            
            weakFooter.reason = currentStr;
        }];
    }];
    
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return BYS_W_H(60);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BYS_W_H(40);
}

//-(instancetype)init{
//    return [self initWithStyle:UITableViewStyleGrouped];
//}

#pragma mark - lazy
-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(BYSelectDeviceDemolishHeader *)header{
    if (_header == nil) {
        _header = [BYSelectDeviceDemolishHeader by_viewFromXib];
        _header.frame = CGRectMake(0, 0, BYSCREEN_W, BYS_W_H(50));
        
        if (self.isImages) {
            _header.title = [NSString stringWithFormat:@"拆机车辆: %@ %@",[BYSaveTool boolForKey:BYCarNumberInfo] ? self.carNum: [NSString stringWithFormat:@"%@***",[self.carNum.length>1?self.carNum:@"  " substringToIndex:2]],[BYSaveTool boolForKey:BYCarOwnerInfo] ? self.ownerName : [NSString stringWithFormat:@"%@***",[self.ownerName.length>0?self.ownerName:@" " substringToIndex:1]]];
        }else{
            BYInstallModel * model1 = self.fillInfoArr.firstObject;
            BYInstallModel * model2 = self.fillInfoArr[1];
            _header.title = [NSString stringWithFormat:@"拆机车辆: %@ %@",model1.subTitle,model2.subTitle];
        }
    }
    return _header;
}

-(BYSubmitAppontmentParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYSubmitAppontmentParams alloc] init];
        
        for (BYInstallModel * model in self.fillInfoArr) {
            NSInteger index = [self.fillInfoArr indexOfObject:model];
            //先将三个页面传过来的数据赋值在httpParams上
            if (index == 2) {
                _httpParams.keyKeeper = model.subTitle;
            }
            if (index == 3) {
                _httpParams.keeperIphone = model.subTitle;
            }
            if (index == 4) {
                _httpParams.carPlace = model.subTitle;
            }
        }
    }
    return _httpParams;
}
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight)];
    }
    return _tableView;
}

-(void)dealloc{
    BYLog(@"确认拆机界面销毁");
}

@end

