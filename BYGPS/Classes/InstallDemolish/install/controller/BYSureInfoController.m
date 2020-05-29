//
//  BYSureInfoController.m
//  父子控制器
//
//  Created by miwer on 2016/12/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSureInfoController.h"
#import "BYInstallHeaderView.h"
#import "BYInstallSectionHeaderView.h"
#import "BYSureLabelCell.h"
#import "BYInstallModel.h"
#import "BYSureMarkCell.h"
#import "BYSureImageCell.h"
#import "UIButton+BYFooterButton.h"
#import "BYInstallSuccessController.h"
#import "BYDeviceDetailHttpTool.h"
#import "BYDeviceInfoModel.h"
#import "BYInstallDemolishHttpTool.h"
#import "NSDate+BYDistanceDate.h"
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import "EasyNavigation.h"

@interface BYSureInfoController () <BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign)BOOL isWireless;
@property(nonatomic,strong) BMKGeoCodeSearch * searcher;
@property(nonatomic,strong) BYDeviceInfoModel * model;

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation BYSureInfoController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    BYStatusBarDefault;
    _searcher.delegate = nil;//视图消失时,检索代理置为nil代理
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshAction{
    //请求设备状态信息
    [self loadDeviceCurrentInfo];
}
-(void)initBase{
    [self.navigationView setTitle:@"录入资料"];
//    self.navigationView.titleLabel.textColor = [UIColor whiteColor];
//    [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
    _isWireless = self.isWirless;

    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView removeAllLeftButton];
        BYWeakSelf;
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
        
        [self.navigationView addRightButtonWithImage:[UIImage imageNamed:@"icon_refresh"] clickCallBack:^(UIView *view) {
            [weakSelf refreshAction];
        }];
    });
    
    [self.images removeLastObject];//将最后一张图片删除
    
    //添加headerView
    
    BYInstallHeaderView * tableHeader = [BYInstallHeaderView by_viewFromXib];
    tableHeader.frame = CGRectMake(0, 64, BYSCREEN_W, 100);
    tableHeader.stepIndex = 3;
    self.tableView.tableHeaderView = tableHeader;
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 150)];
    UIButton * submitFooter = [UIButton buttonWithMargin:20 backgroundColor:BYGlobalBlueColor title:@"确认提交" target:self action:@selector(sureAction)];
    [footerView addSubview:submitFooter];
    
    UIButton * backButton = [UIButton buttonWithMargin:75 backgroundColor:BYRGBColor(63, 186, 5) title:@"返回上一步" target:self action:@selector(backStep)];
    [footerView addSubview:backButton];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYSureLabelCell class]) bundle:nil] forCellReuseIdentifier:@"labelCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYSureMarkCell class]) bundle:nil] forCellReuseIdentifier:@"markCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYSureImageCell class]) bundle:nil] forCellReuseIdentifier:@"imageCell"];

    //请求设备状态信息
    [self loadDeviceCurrentInfo];

}

//通过DeviceId请求设备详情信息
-(void)loadDeviceCurrentInfo{
    
    [BYDeviceDetailHttpTool POSTDeviceDetailWithDeviceId:self.deviceId success:^(id data) {
        
        BYDeviceInfoModel * model = [[BYDeviceInfoModel alloc] initWithDictionary:data error:nil];
        
        //将请求下来的model存下来
        _model = model;
        [self setupGroupWith:model];
        [self geoDecodeWith:model.lat lon:model.lon];
        dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadData];
        });
    } showHUD:NO];
}

-(void)setupGroupWith:(BYDeviceInfoModel *)model{
    
    //如果数组长度为3,说明已经请求过设备信息,那就去掉中间数组
    if (self.sureSource.count == 3) {
        [self.sureSource removeObject:self.sureSource[1]];
    }
    
    NSMutableArray * secondArr = [NSMutableArray array];
    [secondArr addObject:[BYInstallModel createModelWith:@"*设备编号" subTitle:model.sn isNecessary:YES]];
    [secondArr addObject:[BYInstallModel createModelWith:@"*设备分组" subTitle:model.groupName isNecessary:YES]];
    if ([_model.model isEqualToString:@"013C"]) {
        [secondArr addObject:[BYInstallModel createModelWith:@"*定位时间" subTitle:@"" isNecessary:YES]];
        [secondArr addObject:[BYInstallModel createModelWith:@"*更新时间" subTitle:@"" isNecessary:YES]];
        [secondArr addObject:[BYInstallModel createModelWith:@"*设备状态" subTitle:@"" isNecessary:YES]];
        [secondArr addObject:[BYInstallModel createModelWith:@"*车辆状态" subTitle:@"" isNecessary:YES]];
        [secondArr addObject:[BYInstallModel createModelWith:@"*定位位置" subTitle:@"" isNecessary:YES]];
    }else{
        [secondArr addObject:[BYInstallModel createModelWith:@"*定位时间" subTitle:model.gpsTime isNecessary:YES]];
        [secondArr addObject:[BYInstallModel createModelWith:@"*更新时间" subTitle:model.updateTime isNecessary:YES]];
        [secondArr addObject:[BYInstallModel createModelWith:@"*设备状态" subTitle:model.online isNecessary:YES]];
        [secondArr addObject:[BYInstallModel createModelWith:@"*车辆状态" subTitle:model.carStatus isNecessary:YES]];
        [secondArr addObject:[BYInstallModel createModelWith:@"*定位位置" subTitle:@"正在定位..." isNecessary:YES]];
    }
    [self.sureSource insertObject:secondArr atIndex:1];
}

-(void)geoDecodeWith:(double)lat lon:(double)lon{
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lon);
    
    //初始化检索对象
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    
    //发起反向地理编码检索
    BMKReverseGeoCodeSearchOption * searchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    searchOption.location = coordinate;
    [_searcher reverseGeoCode:searchOption];
}
//接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        NSMutableArray * secondArr = self.sureSource[1];
        BYInstallModel * model = secondArr.lastObject;
        model.subTitle = result.address;
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:6 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(void)sureAction{
    
    [self loadDeviceCurrentInfo];
    
    NSMutableArray * tempArr = [[NSMutableArray alloc] init];
    //将self.sureSource添加到tempArr中,除去设备状态信息,遍历
    [tempArr addObjectsFromArray:self.sureSource.firstObject];
    [tempArr addObjectsFromArray:self.sureSource.lastObject];
    //移除图片模型
    [tempArr removeObject:tempArr.lastObject];
    
    //弹出alert提示是否确认上传
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"确认提交安装信息吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
    if ([BYObjectTool getIsIpad]){
        
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
    }
    UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //判断设备状体是否符合安装要求
        [self sureDeviceInfo];
        
        //上传安装信息
        [BYInstallDemolishHttpTool POSTUploadInstallInfoWith:self.deviceId infoArr:tempArr images:self.photoArr success:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BYInstallSuccessController * successVc = [[BYInstallSuccessController alloc] init];
                [self.navigationController pushViewController:successVc animated:YES];
            });
        }];
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:sure];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)sureDeviceInfo{
    
    //判断是否符合要求安装(无线->短信可发送数量>365,定位时间再两小时以内;有线->在线)
    if (_model.wifi && (_model.totalSend - _model.receiveCount) < 365) {
        
        return [BYProgressHUD by_showErrorWithStatus:@"设备电量不足,不可录入资料"];
    }
    
    if (!_model.wifi && [_model.online rangeOfString:@"在线"].location == NSNotFound) {
        return [BYProgressHUD by_showErrorWithStatus:@"设备不在线,不可录入资料"];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sureSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray * tempArr = self.sureSource[section];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray * tempArr = self.sureSource[indexPath.section];
    BYInstallModel * model = tempArr[indexPath.row];

    if (_isWireless && indexPath.section == 2 && indexPath.row == 1) {
        BYSureMarkCell * markCell = [tableView dequeueReusableCellWithIdentifier:@"markCell"];
        markCell.subtitle = model.subTitle;
        return markCell;
    }else if (_isWireless && indexPath.section == 2 && indexPath.row == 2){
        BYSureImageCell * imageCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        imageCell.images = self.images;
        return imageCell;
    }else if (!_isWireless && indexPath.section == 2 && indexPath.row == 9){
        BYSureMarkCell * markCell = [tableView dequeueReusableCellWithIdentifier:@"markCell"];
        markCell.subtitle = model.subTitle;
        return markCell;
    }else if (!_isWireless && indexPath.section == 2 && indexPath.row == 10){
        BYSureImageCell * imageCell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        imageCell.images = self.images;
        return imageCell;
    }else{
        
        BYSureLabelCell * labelCell = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
        labelCell.model = model;
        if ([model.title isEqualToString:@"*安装位置"] || [model.title isEqualToString:@"*定位位置"]) {
            labelCell.titleLabel_W = BYS_W_H(95);
        }else{
            labelCell.titleLabel_W = BYS_W_H(120);
        }
        return labelCell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isWireless && indexPath.section == 2 && indexPath.row == 1) {
        return BYS_W_H(110);
    }else if (_isWireless && indexPath.section == 2 && indexPath.row == 2){
        CGFloat width = (BYSCREEN_W - 6 * 10) / 3;
        return self.images.count <= 3 ? width + 20 : width * 2 + 20;
    }else if (!_isWireless && indexPath.section == 2 && indexPath.row == 9){
        return BYS_W_H(110);
    }else if (!_isWireless && indexPath.section == 2 && indexPath.row == 10){
        CGFloat width = (BYSCREEN_W - 6 * 10) / 3;
        return self.images.count <= 3 ? width + 20 : width * 2 + 20;
    }else{
        return BYS_W_H(44);
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray * titles = @[@"确认车辆信息",@"确认设备信息",@"确认安装信息"];
    BYInstallSectionHeaderView * header = [BYInstallSectionHeaderView by_viewFromXib];
    header.title = titles[section];
//    header.isShowButton = NO;
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BYS_W_H(50);
}

-(void)backStep{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSMutableArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
