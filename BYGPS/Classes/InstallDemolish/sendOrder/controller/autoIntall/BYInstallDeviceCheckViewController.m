//
//  BYInstallDeviceCheckViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/9/6.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYInstallDeviceCheckViewController.h"
#import "BYInstallDeviceCheckViewCell.h"
#import "EasyNavigation.h"
#import "BYInstallDeviceCheckBottomView.h"
#import "BYInstallHeaderView.h"
#import "BYInstallDeviceCheckModel.h"
#import "BYAutoInstallAddCarController.h"
#import "BYAutoScanViewController.h"
#import "BYCheckVinModel.h"
#import "BYInstallRecordViewController.h"

@interface BYInstallDeviceCheckViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,weak) BYInstallDeviceCheckBottomView *bottomView;
@property (nonatomic,assign) BOOL isCanNext;//下一步是否高亮
@property (nonatomic,strong) BYCheckVinModel *checkVinModel;
@property (nonatomic,strong) UIView *sureBtnView;
@end

@implementation BYInstallDeviceCheckViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     BYWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        [self.navigationView removeAllLeftButton];
        [self.navigationView removeAllRightButton];
        
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
        [weakSelf.navigationView addRightView:self.sureBtnView clickCallback:^(UIView *view) {
            [weakSelf installRecord];
        }];
        
    });
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
    }
}
- (void)installRecord{
    BYInstallRecordViewController *vc = [[BYInstallRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
     [self initBase];
  
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    BYRegisterCell(BYInstallDeviceCheckViewCell);
    [self.view addSubview:self.tableView];
    if (self.deviceSn.length) {
        [self deviceCheck:self.deviceSn];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_model.deviceSn.length) {
                [self.dataSource addObject:_model];
            }
            [self checkData];
            
        });
    }
    
    
}

#pragma mark -- 设备检测
- (void)deviceCheck:(NSString *)deviceStr{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceSn"] = deviceStr;
    
    [BYSendWorkHttpTool POSTDeviceCheckParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.model = [BYInstallDeviceCheckModel yy_modelWithDictionary:data];
            if (!weakSelf.model.groupId) {
                BYShowError(@"设备所在组为空");
                 weakSelf.bottomView.dataSource = weakSelf.dataSource;
                 [weakSelf.tableView reloadData];
                return ;
            }
            if (weakSelf.model.deviceStatus == 2) {
                BYShowError(weakSelf.model.exceptionMsg);
                weakSelf.bottomView.dataSource = weakSelf.dataSource;
                 [weakSelf.tableView reloadData];
                return;
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_model.deviceSn.length) {
                    [weakSelf.dataSource addObject:_model];
                }
                 [weakSelf.tableView reloadData];
                [weakSelf checkData];
                
            });
            
        });
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initBase{
    [self.navigationView setTitle:@"自助安装"];
    BYWeakSelf;
    self.view.backgroundColor = BYBackViewColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
   
    
    BYInstallHeaderView * tableHeader = [BYInstallHeaderView by_viewFromXib];
    tableHeader.workOrderInfoLabel.text = @"扫描设备";
    tableHeader.carInfoLabel.text = @"录入车辆";
    tableHeader.deviceInfoLabel.text = @"安装设备";
    tableHeader.showStepIndex = 0;
    tableHeader.frame = CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, 70);
    tableHeader.topNoticeView.hidden = YES;
    tableHeader.topH.constant = -30;
    [self.view addSubview:tableHeader];
    
    BYInstallDeviceCheckBottomView *bottomView = [BYInstallDeviceCheckBottomView by_viewFromXib];
    bottomView.nextBtn.enabled = NO;
    self.bottomView = bottomView;
    bottomView.addBlock = ^{
        BYAutoScanViewController *vc = [[BYAutoScanViewController alloc] init];
        vc.autoScanBlock = ^(BYInstallDeviceCheckModel *model) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.model = model;
                [weakSelf.dataSource addObject:model];
                [weakSelf checkData];
    
                
                
               
            });
           
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    bottomView.nextBlock = ^{
        [weakSelf checkCarUniquePropertyParams];
        
    };


    bottomView.frame = CGRectMake(0, MAXHEIGHT - 160, MAXWIDTH, 160);
    [self.view addSubview:bottomView];
    
    
    
}
#pragma mark -- 检查设备所属分组是否一致
- (void)checkData{
    
    self.bottomView.dataSource = self.dataSource;
    BYInstallDeviceCheckModel *firstModel = self.dataSource.firstObject;
    if (self.dataSource.count > 1) {
        if ([firstModel.deviceSn isEqualToString:_model.deviceSn]) {
            [self.dataSource removeLastObject];
            [self.tableView reloadData];
            self.model = self.dataSource.lastObject;
            return BYShowError(@"设备不能重复哦!");
        }
    }
   
    for (BYInstallDeviceCheckModel *model in self.dataSource) {
        if (firstModel.groupId == model.groupId) {
            model.isFit = YES;
        }else{
            model.isFit = NO;
        }
    }
     [self.tableView reloadData];
    for (BYInstallDeviceCheckModel *model in self.dataSource) {
        if (firstModel.groupId != model.groupId) {
            self.isCanNext = NO;
            if (self.dataSource.count)
                self.bottomView.isFit = NO;
            return;
        }
    }
    self.isCanNext = YES;
    if (self.isCanNext) {
        if (self.dataSource.count)
            self.bottomView.isFit = self.isCanNext;
    }else{
        if (self.dataSource.count)
            self.bottomView.isFit = NO;
    }
    if (self.dataSource.count == 0) {
        self.bottomView.nextBtn.enabled = NO;
        self.bottomView.isFit = NO;
        [self.bottomView.nextBtn setBackgroundColor:UIColorHexFromRGB(0x7d7d7d)];
    }
    
}

#pragma mark -- 检查设备所属分组是否需要车架号
- (void)checkCarUniquePropertyParams{
    //判断是否有离线设备
//    for (BYInstallDeviceCheckModel *mode in self.dataSource) {
//        if (mode.deviceStatus == 2) {
//            return BYShowError(@"有设备处于离线状态，请上线后在进行下一步");
//        }
//    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    BYInstallDeviceCheckModel *model = self.dataSource.firstObject;
    dict[@"groupId"] = @(model.groupId);
    BYWeakSelf;
    [BYSendWorkHttpTool POSTCheckCarUniquePropertyParams:dict success:^(id data) {
        BYLog(@"%@",data);
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.checkVinModel = [BYCheckVinModel yy_modelWithDictionary:data];
            BYAutoInstallAddCarController *vc = [[BYAutoInstallAddCarController alloc] init];
            if (weakSelf.checkVinModel.uniqueProperty == 1) {
                vc.isCheckVin = YES;
            }else{
                vc.isCheckVin = NO;
            }
            vc.groupId = model.groupId;
            vc.groupName = model.group;
            vc.array = weakSelf.dataSource;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        });
       
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return self.dataSource.count;

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    BYInstallDeviceCheckViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYInstallDeviceCheckViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delectBlock = ^(BYInstallDeviceCheckModel *model){
        [weakSelf.dataSource removeObject:model];
        [weakSelf checkData];
    };
    cell.model = self.dataSource[indexPath.row];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}




#pragma mrak -- nodata
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"auto_noData"];
}

- (NSString *)xy_noDataViewMessage {
    return @"暂无设备，快去检测设备";
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+70, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight - 160 - 70) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
-(UIView *)sureBtnView
{
    if (!_sureBtnView) {
        _sureBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        UILabel *label = [UILabel verLab:15 textRgbColor:WHITE textAlighment:NSTextAlignmentCenter];
        label.text = @"安装记录";
        [_sureBtnView addSubview:label];
        label.frame = _sureBtnView.bounds;
    }
    return _sureBtnView;
}
@end
