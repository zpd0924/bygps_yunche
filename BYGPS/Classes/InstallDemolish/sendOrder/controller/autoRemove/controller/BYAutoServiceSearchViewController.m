//
//  BYAutoServiceSearchViewController.m
//  BYGPS
//
//  Created by ZPD on 2018/12/11.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceSearchViewController.h"
#import "BYAutoServiceSubViewController.h"
#import "EasyNavigation.h"

#import "UIButton+HNVerBut.h"
#import "UILabel+HNVerLab.h"

#import "YBCustomCameraVC.h"
#import "WQCodeScanner.h"
#import "VinManager.h"
#import "PlateCameraController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#import "BYLeftNavView.h"
#import "BYBlankView.h"
#import "BYAutoServiceSearchCarCell.h"
#import "BYAutoServiceSearchDeviceCell.h"
#import "BYAutoServiceHttpTool.h"
#import "BYRegularTool.h"
#import "BYAutoServiceCarModel.h"

#define WTKScale    [UIScreen mainScreen].bounds.size.width/375.0f

@interface BYAutoServiceSearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,VinManagerDelegate,PlateCameraDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,assign) BOOL isEditing;

@property (nonatomic,strong) NSString *carNum;//输入的车牌号

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIView *noDataView;

@property (nonatomic,strong) BYLeftNavView *leftView;
@property (nonatomic, assign) NSInteger pageInt;

@property(nonatomic , strong) BYBlankView *blankView;

@end

@implementation BYAutoServiceSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;// 控制是否显示键盘上的工具条
    
    BYWeakSelf;
    [self.navigationView removeAllLeftButton];
    [self.navigationView removeAllRightButton];
    
    [self.navigationView addLeftView:self.leftView clickCallback:^(UIView *view) {
        [weakSelf select];
    }];
    
    [self.navigationView addRightButtonWithTitle:@"取消" clickCallBack:^(UIView *view) {
        [weakSelf backAction];
    }];
}

-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;// 控制是否显示键盘上的工具条
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
}

-(void)initBase{
    self.view.backgroundColor = UIColorHexFromRGB(0xececec);
    BYWeakSelf;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH - 148, 30)];
    view.backgroundColor = WHITE;
    
    self.naviSearchBar = [[BYNaviSearchBar alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W - 148, 30)];
    self.naviSearchBar.searchBlock = ^{
        [weakSelf select];
    };
    //    self.naviSearchBar.isCarSearch = YES;
    self.naviSearchBar.isScan = YES;
    [view addSubview:self.naviSearchBar];
    [self.navigationView addTitleView:view];
    //    if (_sendOrderType == BYWorkSendOrderType) {
    //        self.naviSearchBar.searchField.placeholder = @"请输入车牌号/车架号";
    //    }else{
    self.naviSearchBar.searchField.placeholder = @"请输入车牌号";
    self.scanType = carNumScanType;
//    self.currentPage = 1;
    //    }
    self.naviSearchBar.searchField.delegate = self;
    //    [self.naviSearchBar.searchField addTarget:self action:@selector(searchFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self.naviSearchBar.searchField becomeFirstResponder];
    UIButton *scanBtn = [UIButton verBut:nil textFont:15 titleColor:nil bkgColor:nil];
    scanBtn.frame = CGRectMake(MAXWIDTH - 183, 0, 40, 30);
    [scanBtn setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:scanBtn];
    
    [self.view addSubview:self.tableView];
}



#pragma mark -- 选择车牌 车架 或者设备
- (void)select{
    BYWeakSelf;
    UIAlertController *alertVc = [BYObjectTool showChangeCarNumberOrVinOrSnAleartCarNumWith:^{
        self.leftView.titleLabel.text = @"车牌号";
        self.naviSearchBar.searchField.placeholder = @"请输入车牌号";
        self.naviSearchBar.searchField.text = @"";
        self.scanType = carNumScanType;
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    } vinNum:^{
        self.leftView.titleLabel.text = @"车架号";
        self.naviSearchBar.searchField.placeholder = @"请输入车架号";
        self.naviSearchBar.searchField.text = @"";
        self.scanType = vinNumScanType;
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    } SnNum:^{
        self.leftView.titleLabel.text = @"设备号";
        self.naviSearchBar.searchField.placeholder = @"请输入设备号";
        self.naviSearchBar.searchField.text = @"";
        self.scanType = deviceScanType;
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    }];
    if ([BYObjectTool getIsIpad]){
        
        alertVc.popoverPresentationController.sourceView = self.view;
        alertVc.popoverPresentationController.sourceRect =  CGRectMake(100, 100, 1, 1);
    }
    [self presentViewController:alertVc animated:YES completion:nil];

}

#pragma mark -- 扫一扫
- (void)scanBtnClick:(UIButton *)btn{
    BYWeakSelf;
    switch (self.scanType) {
        case vinNumScanType:
            [weakSelf carVinScan];
            break;
        case carNumScanType:
            [weakSelf carNumScan];
            break;
        case deviceScanType:
            [weakSelf scanDevice];
            break;
            
        default:
            break;
    }
    
    
//    UIAlertController *alertVc = [BYObjectTool showChangeCarNumberOrVinOrSnAleartCarNumWith:^{
//
//    } vinNum:^{
//
//    } SnNum:^{
//
//    }];
//    if ([BYObjectTool getIsIpad]) {
//        alertVc.popoverPresentationController.sourceView = self.view;
//        alertVc.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
//    }
//
//    [self presentViewController:alertVc animated:YES completion:nil];
//
}
#pragma mark -- 扫描设备号
- (void)scanDevice{
    BYWeakSelf;
    WQCodeScanner *scanner = [[WQCodeScanner alloc] init];
    scanner.scanType = WQCodeScannerTypeBarcode;
    scanner.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanner animated:YES completion:nil];
    [scanner setResultBlock:^(NSString *value) {
        self.leftView.titleLabel.text = @"设备号";
        self.naviSearchBar.searchField.placeholder = @"请输入设备号";
        self.naviSearchBar.searchField.text = @"";
        self.scanType = deviceScanType;
//        [weakSelf.naviSearchBar.searImageBtn setTitle:@"设备号" forState:UIControlStateNormal];
        weakSelf.keyWord = value;
        [weakSelf loadCarList];
    }];
}


#pragma mark -- 车牌号扫一扫
- (void)carNumScan{
    BYWeakSelf;
    PlateCameraController * cameraController = [[PlateCameraController alloc] initWithAuthorizationCode:AUTHCODE];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
    }
    cameraController.delegate = self;
    cameraController.deviceDirection = self.preferredInterfaceOrientationForPresentation;
    cameraController.isOneDirection = NO;
    cameraController.modalPresentationStyle = UIModalPresentationFullScreen;
    [weakSelf presentViewController:cameraController animated:YES completion:nil];
}
#pragma mark -- 车架号扫一扫
- (void)carVinScan{
    
    BYWeakSelf;
    [VinManager sharedVinManager].delegate = self;
    [VinManager sharedVinManager].photoInBlcok = ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf openAlbum];
        });
        
    };
    [[VinManager sharedVinManager] recognizeVinCodeByAudioWithController:self isOneDirectionRecognize:NO isUsePush:NO andAuthCode:AUTHCODE];
}
- (void)cameraController:(UIViewController *)cameraController audioRecognizeFinishWithResult:(NSString *)vinCode andVinImage:(UIImage *)vinImage {
    [cameraController dismissViewControllerAnimated:YES completion:nil];
    BYLog(@"vin = %@",vinCode);
    self.leftView.titleLabel.text = @"车架号";
    self.naviSearchBar.searchField.placeholder = @"请输入车架号";
    self.naviSearchBar.searchField.text = @"";
    self.scanType = vinNumScanType;
//    [self.naviSearchBar.searImageBtn setTitle:@"" forState:UIControlStateNormal];
    self.keyWord = vinCode;
    [self loadCarList];
    
}
#pragma mark - 识别结果回调
- (void)cameraController:(UIViewController *)cameraController recognizePlateSuccessWithResult:(NSString *)plateStr plateColor:(NSString *)plateColor andPlateImage:(UIImage *)plateImage {
    [cameraController dismissViewControllerAnimated:YES completion:nil];
    BYLog(@"%@ %@",plateStr,plateColor);
    BYLog(@"carNumber = %@",plateStr);
    self.keyWord = plateStr;
    self.leftView.titleLabel.text = @"车牌号";
    self.naviSearchBar.searchField.placeholder = @"请输入车牌号";
    self.naviSearchBar.searchField.text = @"";
    self.scanType = carNumScanType;
//    [self.naviSearchBar.searImageBtn setTitle:@"车牌号" forState:UIControlStateNormal];
    [self loadCarList];
}

//打开相册
- (void)openAlbum{
    //判断相册资源是否可打开
    bool isPhotoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if (isPhotoLibraryAvailable) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.allowsEditing = YES;
        controller.delegate = self;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:controller animated:YES completion:nil];
    }
}


#pragma mark - Delegate
//MARK:从相册选择了一张照片调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!image) {
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    
    [SVProgressHUD showWithStatus:@"识别中 请稍后"];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [VinManager sharedVinManager].delegate = self;
        [[VinManager sharedVinManager] recognizeVinCodeWithPhoto:image andAuthCode:AUTHCODE];
    }];
}

- (void)photoRecognizeFinishWithResult:(NSString *)vinCode andErrorCode:(int)errorCode {
    if (errorCode == 0) {//识别成功
        self.leftView.titleLabel.text = @"车架号";
        self.naviSearchBar.searchField.placeholder = @"请输入车架号";
        self.naviSearchBar.searchField.text = @"";
        self.scanType = vinNumScanType;
//        [self.naviSearchBar.searImageBtn setTitle:@"车架号" forState:UIControlStateNormal];
        self.keyWord = vinCode;
        [self loadCarList];
        [SVProgressHUD dismiss];
    }else{//识别失败
        
        [SVProgressHUD dismiss];
        BYShowError(@"识别失败");
    }
}

#pragma mark -- 点击搜索
- (void)tapSearch{
    
//    if(_isSearch){
//        if (_keyWord.length >= 3) {
            [self loadCarList];
//        }
//    }
}
#pragma mark -- 车辆搜索
- (void)loadCarList{
    
    self.pageInt = 1;
//    [self.dataSource removeAllObjects];
    [self loadMoreDeviceList];
}

-(void)loadMoreDeviceList{
    self.tableView.mj_footer.hidden = NO;
    self.naviSearchBar.searchField.text = _keyWord;

    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    dict[@"carQ"] = self.keyWord;
    
    if (self.scanType == carNumScanType) {
        dict[@"type"] = @(1);
    }else if (self.scanType == vinNumScanType){
        dict[@"type"] = @(2);
    }else{
        dict[@"type"] = @(3);
    }
    if (self.functionType == BYFunctionTypeInstall) {
        dict[@"serviceType"] = @(1);
    }else if(self.functionType == BYFunctionTypeRepair){
        dict[@"serviceType"] = @(2);
    }else{
        dict[@"serviceType"] = @(3);
    }
    
//    if ([self..titleLabel.text isEqualToString:@"车牌号"]) {
//
//    }else if ([self.naviSearchBar.searImageBtn.titleLabel.text isEqualToString:@"车架号"]){
//
//    }else{
//
//    }
    dict[@"pageNo"] = @(self.pageInt);
    dict[@"pageSize"] = @(10);
    
    [BYAutoServiceHttpTool POSTQuickCarByCarQParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
        
        if (self.pageInt <= 1) {
            [self.dataSource removeAllObjects];
        }
        self.pageInt ++;
        
        for (NSDictionary *dic in data[@"list"]) {
            BYAutoServiceCarModel *carModel = [[BYAutoServiceCarModel alloc] initWithDictionary:dic error:nil];
            [self.dataSource addObject:carModel];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSArray *tempArray = data[@"list"];
            
            if (tempArray.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (self.dataSource.count) {
                if (self.blankView) {
                    [self.blankView removeFromSuperview];
                }
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }else{
                self.tableView.mj_footer.hidden = YES;
                [self.view addSubview:self.blankView];
                [self.tableView reloadData];
            }
        });
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
    }];
    
}


#pragma mrak -- 判断车辆是否在派单中
//- (void)IsSendWorking:(BYSearchCarByNumOrVinModel *)model{
//    BYWeakSelf;
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"carId"] = @(model.carId);
//    dict[@"groupId"] = [BYSaveTool objectForKey:groupId];
//    [BYSendWorkHttpTool POSTIsSendWorkParams:dict success:^(id data) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSString *status = data[@"status"];
//            if ([status integerValue]) {//1:在派单 0：未派单
//                if (self.noDataView) {
//                    [self.noDataView removeFromSuperview];
//                }
//                BYSendOrderResultViewController *vc = [[BYSendOrderResultViewController alloc] init];
//                vc.resultType = BYCarSendWorkingType;
//                vc.leftBtnBlock = ^{
//                    BYMyWorkOrderDetailController *vc = [[BYMyWorkOrderDetailController alloc] init];
//                    vc.orderNo = data[@"orderNo"];
//                    ///服务类别 1:安装,2:检修,3:拆机
//                    NSString *type = data[@"serviceType"];
//                    switch ([type integerValue]) {
//                        case 1:
//
//                            vc.sendOrderType = BYWorkSendOrderType;
//                            break;
//                        case 2:
//                            vc.sendOrderType = BYRepairSendOrderType;
//                            break;
//                        default:
//                            vc.sendOrderType = BYUnpackSendOrderType;
//
//                            break;
//                    }
//
//
//                    [self.navigationController pushViewController:vc animated:YES];
//                };
//                vc.rightBtnBlock = ^{
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                };
//                [weakSelf addChildViewController:vc];
//                vc.view.frame = CGRectMake(0, SafeAreaTopHeight, MAXWIDTH, MAXHEIGHT - SafeAreaTopHeight);
//                weakSelf.noDataView = vc.view;
//                [weakSelf.view addSubview:vc.view];
//            }else{
//                if (weakSelf.searchCallBack) {
//                    weakSelf.searchCallBack(model);
//                }
//
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }
//        });
//
//    } failure:^(NSError *error) {
//
//    }];
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

#pragma mark -- tableview 代理 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.scanType == deviceScanType) {
        BYAutoServiceSearchDeviceCell *deviceCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceSearchDeviceCell" forIndexPath:indexPath];
        deviceCell.carModel = self.dataSource[indexPath.section];
        deviceCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return deviceCell;
    }else{
        BYAutoServiceSearchCarCell *carCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceSearchCarCell" forIndexPath:indexPath];
        carCell.carModel = self.dataSource[indexPath.section];
        carCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return carCell;
    }
}
    
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.scanType == deviceScanType) {
        return 90;
    }else{
        return 95;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BYAutoServiceCarModel *carModel = self.dataSource[indexPath.section];
    
    
        NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
        [paraDic setValue:carModel.groupIds forKey:@"groupId"];
        [paraDic setValue:carModel.carId forKey:@"carId"];
        
        [BYAutoServiceHttpTool POSTQuickCheckIsSendOrderWithParams:paraDic success:^(id data) {
            
            if ([data[@"status"] integerValue] == 0) {
                
                if (self.functionType == BYFunctionTypeRemove) {
                    NSMutableDictionary *removePara = [NSMutableDictionary dictionary];
                    [removePara setValue:carModel.carId forKey:@"carId"];
                    
                    [BYAutoServiceHttpTool POSTQuickCheckIsRemoveWithParams:removePara success:^(id data) {
                        if ([data[@"status"] integerValue] == 0) {
                            
                            BYAutoServiceSubViewController *serviceSubVC = [BYAutoServiceSubViewController new];
                            
                            serviceSubVC.functionType = self.functionType;
                            //    serviceSubVC.carId = carModel.carId;
                            serviceSubVC.carModel = carModel;
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
                    
                    serviceSubVC.functionType = self.functionType;
                    //    serviceSubVC.carId = carModel.carId;
                    serviceSubVC.carModel = carModel;
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_isSearch) {
        return 10;
    }else{
        return 0;
    }
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeySearch;
    if (textField.text.length == 0) {
        [BYProgressHUD by_showErrorWithStatus:@"搜索内容不能为空"];
        return YES;
    }
    if (self.scanType == carNumScanType) {
        if (![BYRegularTool isValidCarNum:textField.text]) {
            [BYProgressHUD by_showErrorWithStatus:@"输入的车牌号错误"];
            return YES;
        }
        
    }
    else if (self.scanType == vinNumScanType){
        if (textField.text.length <= 5) {
            [BYProgressHUD by_showErrorWithStatus:@"至少需要输入6个字符搜索"];
            return YES;
        }
    }else{
        if (textField.text.length <= 5) {
            [BYProgressHUD by_showErrorWithStatus:@"至少需要输入6个字符搜索"];
            return YES;
        }
    }
    
    [textField resignFirstResponder];
    self.isSearch = YES;
    textField.text = [textField.text uppercaseString];
    self.keyWord = textField.text;
    [self tapSearch];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
//    if (self.isQueryType == YES) {
//        [self cleanSearch];
//    }
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    self.tableView.mj_footer.hidden = YES;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location <= 0) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        self.tableView.mj_footer.hidden = YES;
    }
    return YES;
}



#pragma mark -- lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorHexFromRGB(0xececec);
        _tableView.hidden = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        BYRegisterCell(BYAutoServiceSearchDeviceCell);
        BYRegisterCell(BYAutoServiceSearchCarCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreDeviceList];
        }];
        
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

-(BYLeftNavView *)leftView{
    if (!_leftView) {
        _leftView = [BYLeftNavView by_viewFromXib];
        _leftView.by_width = 68;
        _leftView.by_height = 44;
    }
    return _leftView;
}

-(BYBlankView *)blankView{
    if (_blankView == nil) {
        _blankView = [BYBlankView by_viewFromXib];
        _blankView.title = @"未匹配到结果";
        _blankView.imgName = @"auto_noData";
        _blankView.frame = self.tableView.frame;
    }
    return _blankView;
}

@end
