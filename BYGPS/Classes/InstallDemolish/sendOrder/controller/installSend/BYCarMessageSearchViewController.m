//
//  BYCarMessageSearchViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCarMessageSearchViewController.h"
#import "BYCarMessageSearchResultCell.h"
#import "BYCarMessageSearchCardResultCell.h"
#import "EasyNavigation.h"
#import "MSSAutoresizeLabelFlow.h"
#import "MSSAutoresizeLabelFlowConfig.h"
#import "BYSearchHistoryDataBase.h"
#import "NSDictionary+Str.h"
#import "NSString+BYAttributeString.h"
#import "BYHistoryModel.h"
#import "UIButton+HNVerBut.h"
#import "BYSearchCarMessageCell.h"
#import "BYSearchCarNumberCell.h"
#import "UILabel+HNVerLab.h"
#import <Masonry.h>
#import "BYSendOrderResultViewController.h"
#import "BYLookMoreView.h"
#import "BYAddCarInfoViewController.h"
#import "BYSearchCarByNumOrVinModel.h"
#import "YBCustomCameraVC.h"
#import "WQCodeScanner.h"
#import "BYMyWorkOrderDetailController.h"
#import "VinManager.h"
#import "PlateCameraController.h"
#import <MobileCoreServices/MobileCoreServices.h>

#define WTKScale    [UIScreen mainScreen].bounds.size.width/375.0f

@interface BYCarMessageSearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,VinManagerDelegate,PlateCameraDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic,strong) MSSAutoresizeLabelFlow *flow;


@property (nonatomic,strong) NSMutableArray *historyData;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,assign) BOOL isSearch;
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,assign) BOOL isBlockSearch;//是否是录入车辆回调搜索

@property (nonatomic,strong) NSString *carNum;//输入的车牌号

@property (nonatomic,strong) NSMutableArray *thinkSearchArrar;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UIView *noDataView;
@property (nonatomic,weak) BYLookMoreView *footView;

@end

@implementation BYCarMessageSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BYStatusBarDefault;//黑
    BYWeakSelf;
    [self.navigationView removeAllLeftButton];
    [self.navigationView removeAllRightButton];
    [self.navigationView addRightButtonWithTitle:@"取消" clickCallBack:^(UIView *view) {
        [weakSelf backAction];
    }];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    BYStatusBarLight;//白
}

-(void)backAction{
   
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    BYWeakSelf;
    NSMutableArray *historyMutArr = [[BYSearchHistoryDataBase shareInstance] queryHistoryWithUser:[BYSaveTool valueForKey:BYusername]];
    if (historyMutArr.count) {
        
        BYHistoryModel *historyModel = historyMutArr[0];
        switch (self.type) {
            case 1:
                self.historyData = [NSMutableArray arrayWithArray:[NSString stringToArrayWithJSONStr:historyModel.controlHistory]];
                break;
            case 2:
                self.historyData = [NSMutableArray arrayWithArray:[NSString stringToArrayWithJSONStr:historyModel.deviceListHistory]];
                break;
            case 3:
                self.historyData = [NSMutableArray arrayWithArray:[NSString stringToArrayWithJSONStr:historyModel.alarmListHistory]];
                break;
            case 4:
                self.historyData = [NSMutableArray arrayWithArray:[NSString stringToArrayWithJSONStr:historyModel.carListHistory]];
                break;
            default:
                break;
        }
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH - 80, 30)];
    view.backgroundColor = WHITE;
    
    self.naviSearchBar = [[BYNaviSearchBar alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W - 80, 30)];
    self.naviSearchBar.searchBlock = ^{
        [weakSelf select];
    };
    self.naviSearchBar.isCarSearch = YES;
    self.naviSearchBar.isScan = YES;
    [view addSubview:self.naviSearchBar];
    [self.navigationView addTitleView:view];
    if (_sendOrderType == BYWorkSendOrderType) {
        self.naviSearchBar.searchField.placeholder = @"请输入车牌号/车架号";
    }else{
        self.naviSearchBar.searchField.placeholder = @"请输入车牌号/车架号/设备号";
    }
    self.naviSearchBar.searchField.delegate = self;
//    [self.naviSearchBar.searchField addTarget:self action:@selector(searchFieldChange:) forControlEvents:UIControlEventEditingChanged];
    [self.naviSearchBar.searchField becomeFirstResponder];
    UIButton *scanBtn = [UIButton verBut:nil textFont:15 titleColor:nil bkgColor:nil];
    scanBtn.frame = CGRectMake(MAXWIDTH - 115, 0, 40, 30);
    [scanBtn setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:scanBtn];
    
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.frame = CGRectMake(10, SafeAreaTopHeight + 5, 100, 25);
    headLabel.text = @"最近搜索";
    headLabel.textColor = [UIColor colorWithHex:@"#323232"];
    headLabel.font = [UIFont systemFontOfSize:14];
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.by_x = BYSCREEN_W - 40;
    deleteBtn.by_y = SafeAreaTopHeight + 5;
    [deleteBtn setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];
    [deleteBtn sizeToFit];
    [deleteBtn addTarget:self action:@selector(deleteAllHistory:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:headLabel];
    [self.view addSubview:deleteBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    MSSAutoresizeLabelFlowConfig *config = [MSSAutoresizeLabelFlowConfig shareConfig];
    config.backgroundColor = [UIColor whiteColor];
    config.itemColor = [UIColor colorWithHex:@"#efefef"];
    config.textColor = [UIColor colorWithHex:@"#646464"];
    config.textFont = [UIFont fontWithName:@"Times New Roman" size:15];
    //    NSArray *array = @[@"Adele",@"Alicia Keys",@"Ariana Grande",@"Avril Lavigne",@"Beyoncé",@"Britney Spears",@"Celine Dion",@"Katy Perry",@"Rihanna"];
   
    self.flow = [[MSSAutoresizeLabelFlow alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(headLabel.frame)+5, BYSCREEN_W-20, BYSCREEN_H - 100) titles:self.historyData selectedHandler:^(NSUInteger index, NSString *title) {
       
        weakSelf.keyWord = [title uppercaseString];
        weakSelf.isSearch = YES;
        self.naviSearchBar.searchField.text = [title uppercaseString];
        [weakSelf tapSearch];
        NSLog(@"%lu %@",index,title);
    }];
    [self.view addSubview:self.flow];
    
    BYLookMoreView *footView = [BYLookMoreView by_viewFromXib];
    self.footView = footView;
    footView.lookMoreBtnBlock = ^{//查看更多
        
    };
    footView.frame = CGRectMake(0, 0, MAXWIDTH, 55);
  
    switch (_scanType) {
        case carNumScanType:
             [self.naviSearchBar.searImageBtn setTitle:@"车牌号" forState:UIControlStateNormal];
            break;
        case vinNumScanType:
             [self.naviSearchBar.searImageBtn setTitle:@"车架号" forState:UIControlStateNormal];
            break;
        default:
             [self.naviSearchBar.searImageBtn setTitle:@"设备号" forState:UIControlStateNormal];
            break;
    }
    if (self.keyWord.length) {
        self.naviSearchBar.searchField.text = _keyWord;
        [self loadCarList];
    }
    
}

#pragma mark -- 选择车牌 车架 或者设备
- (void)select{
    BYWeakSelf;
    if (_sendOrderType == BYWorkSendOrderType) {
        UIAlertController *alertVc = [BYObjectTool showChangeCarNumberOrVinAleartCarNumWith:^{
            [weakSelf.naviSearchBar.searImageBtn setTitle:@"车牌号" forState:UIControlStateNormal];
        } vinNum:^{
             [weakSelf.naviSearchBar.searImageBtn setTitle:@"车架号" forState:UIControlStateNormal];
        }];
        if ([BYObjectTool getIsIpad]){
            
            alertVc.popoverPresentationController.sourceView = self.view;
            alertVc.popoverPresentationController.sourceRect =  CGRectMake(100, 100, 1, 1);
        }
         [self presentViewController:alertVc animated:YES completion:nil];
    }else{
        UIAlertController *alertVc = [BYObjectTool showChangeCarNumberOrVinOrSnAleartCarNumWith:^{
             [weakSelf.naviSearchBar.searImageBtn setTitle:@"车牌号" forState:UIControlStateNormal];
        } vinNum:^{
             [weakSelf.naviSearchBar.searImageBtn setTitle:@"车架号" forState:UIControlStateNormal];
        } SnNum:^{
             [weakSelf.naviSearchBar.searImageBtn setTitle:@"设备号" forState:UIControlStateNormal];
        }];
        if ([BYObjectTool getIsIpad]){
            
            alertVc.popoverPresentationController.sourceView = self.view;
            alertVc.popoverPresentationController.sourceRect =  CGRectMake(100, 100, 1, 1);
        }
        [self presentViewController:alertVc animated:YES completion:nil];
    }
}

#pragma mark -- 扫一扫
- (void)scanBtnClick:(UIButton *)btn{
    BYWeakSelf;
    if (_sendOrderType == BYWorkSendOrderType){
        UIAlertController *alertVc = [BYObjectTool showScanAleartCarNumWith:^{
            [weakSelf carNumScan];
        } vinNum:^{
          [weakSelf carVinScan];
        }];
        if ([BYObjectTool getIsIpad]){
            
            alertVc.popoverPresentationController.sourceView = self.view;
            alertVc.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
        }
        [self presentViewController:alertVc animated:YES completion:nil];
    }else{
        UIAlertController *alertVc = [BYObjectTool showChangeCarNumberOrVinOrSnAleartCarNumWith:^{
            [weakSelf carNumScan];
        } vinNum:^{
            [weakSelf carVinScan];
        } SnNum:^{
            [weakSelf scanDevice];
        }];
        if ([BYObjectTool getIsIpad]) {
            alertVc.popoverPresentationController.sourceView = self.view;
            alertVc.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
        }
       
         [self presentViewController:alertVc animated:YES completion:nil];
    }
   
}
#pragma mark -- 扫描设备号
- (void)scanDevice{
    BYWeakSelf;
    WQCodeScanner *scanner = [[WQCodeScanner alloc] init];
    scanner.scanType = WQCodeScannerTypeBarcode;
    scanner.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanner animated:YES completion:nil];
    [scanner setResultBlock:^(NSString *value) {
        [weakSelf.naviSearchBar.searImageBtn setTitle:@"设备号" forState:UIControlStateNormal];
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
    [self.naviSearchBar.searImageBtn setTitle:@"车架号" forState:UIControlStateNormal];
    self.keyWord = vinCode;
    [self loadCarList];

}
#pragma mark - 识别结果回调
- (void)cameraController:(UIViewController *)cameraController recognizePlateSuccessWithResult:(NSString *)plateStr plateColor:(NSString *)plateColor andPlateImage:(UIImage *)plateImage {
    [cameraController dismissViewControllerAnimated:YES completion:nil];
    BYLog(@"%@ %@",plateStr,plateColor);
    BYLog(@"carNumber = %@",plateStr);
    self.keyWord = plateStr;
    [self.naviSearchBar.searImageBtn setTitle:@"车牌号" forState:UIControlStateNormal];
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
        [self.naviSearchBar.searImageBtn setTitle:@"车架号" forState:UIControlStateNormal];
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
    
    if(_isSearch){
        if (_keyWord.length >= 3) {
            [self loadCarList];
        }
    }
}
#pragma mark -- 车辆搜索
- (void)loadCarList{
    
    [self saveHistroy:_keyWord];
    self.naviSearchBar.searchField.text = _keyWord;
    [self.dataSource removeAllObjects];
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    dict[@"carQ"] = self.keyWord;
    if (self.isBlockSearch) {
        if (_keyWord.length > 8) {
            dict[@"type"] = @(2);
        }else{
            dict[@"type"] = @(1);
        }
    }else{
        if ([self.naviSearchBar.searImageBtn.titleLabel.text isEqualToString:@"车牌号"]) {
            dict[@"type"] = @(1);
        }else if ([self.naviSearchBar.searImageBtn.titleLabel.text isEqualToString:@"车架号"]){
            dict[@"type"] = @(2);
        }else{
            dict[@"type"] = @(3);
        }
    }
    NSInteger serviceType = 0;
    if (self.sendOrderType == BYWorkSendOrderType) {
        serviceType = 1;
    }else if (self.sendOrderType == BYUnpackSendOrderType){
        serviceType = 3;
    }else{
        serviceType = 2;
    }
    dict[@"serviceType"] = @(serviceType);
 
//    dict[@"start"] = @(1);
//    dict[@"showCount"] = @(10);
    [BYSendWorkHttpTool POSTqueryCarListParams:dict sendOrderType:_sendOrderType success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dataSource = [[NSArray yy_modelArrayWithClass:[BYSearchCarByNumOrVinModel class] json:data] mutableCopy];
            if (weakSelf.dataSource.count) {
                weakSelf.tableView.hidden = NO;
                weakSelf.isSearch = YES;
                weakSelf.isEditing = NO;
                weakSelf.tableView.tableFooterView = self.footView;
                [weakSelf.tableView reloadData];
                if (weakSelf.noDataView) {
                    [weakSelf.noDataView removeFromSuperview];
                }
            }else{
                BYWeakSelf;
                if (weakSelf.noDataView) {
                    [weakSelf.noDataView removeFromSuperview];
                }
                //拆机 检修不需要新增车辆
                if (_sendOrderType != BYWorkSendOrderType) {
                    BYShowError(@"没有该车辆");
                     [weakSelf.tableView reloadData];
                    return ;
                }
                BYSendOrderResultViewController *vc = [[BYSendOrderResultViewController alloc] init];
                vc.resultType = BYSearchNoDataType;
                vc.leftBtnBlock = ^{
                    BYAddCarInfoViewController *addVc = [[BYAddCarInfoViewController alloc] init];
                    addVc.addCarInfoViewBlock = ^(NSString *carNum) {
                        BYLog(@"carNum = %@",carNum);
                        
                        weakSelf.keyWord = carNum;
                        self.isSearch = YES;
                        self.isBlockSearch = YES;
                        if (carNum.length > 8) {
                             [weakSelf.naviSearchBar.searImageBtn setTitle:@"车架号" forState:UIControlStateNormal];
                        }else{
                             [weakSelf.naviSearchBar.searImageBtn setTitle:@"车牌号" forState:UIControlStateNormal];
                        }
                        [weakSelf tapSearch];
                    };
                    [weakSelf.navigationController pushViewController:addVc animated:YES];
                };
                vc.rightBtnBlock = ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                };
                [weakSelf addChildViewController:vc];
                vc.view.frame = CGRectMake(0, SafeAreaTopHeight, MAXWIDTH, MAXHEIGHT - SafeAreaTopHeight);
                weakSelf.noDataView = vc.view;
                [weakSelf.view addSubview:vc.view];
                
                
            }
            [weakSelf.tableView reloadData];
            
        });
        
        
        
    } failure:^(NSError *error) {
        
    }];
    
    
}
#pragma mark -- 联系搜索
- (void)thinkSearch{
    BYWeakSelf;
    [self.thinkSearchArrar removeAllObjects];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"carQ"] = self.carNum;
    dict[@"start"] = @(1);
    dict[@"showCount"] = @(10);
//    BYWorkSendOrderType = 0,//装机派单
//    BYUnpackSendOrderType,//拆机派单
//    BYRepairSendOrderType//检修派单
    NSInteger serviceType = 0;
    if (self.sendOrderType == BYWorkSendOrderType) {
        serviceType = 1;
    }else if (self.sendOrderType == BYUnpackSendOrderType){
        serviceType = 3;
    }else{
        serviceType = 2;
    }
    dict[@"serviceType"] = @(serviceType);
    [BYSendWorkHttpTool POSTSearchCarByNumOrVinParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.thinkSearchArrar = [[NSArray yy_modelArrayWithClass:[BYSearchCarByNumOrVinModel class] json:data[@"carList"]] mutableCopy];
            [weakSelf.tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mrak -- 判断车辆是否在派单中
- (void)IsSendWorking:(BYSearchCarByNumOrVinModel *)model{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"carId"] = @(model.carId);
    dict[@"groupId"] = [BYSaveTool objectForKey:groupId];
    switch (_sendOrderType) {
        case BYWorkSendOrderType:
            dict[@"serviceType"] = @(1);
            break;
        case BYRepairSendOrderType:
            dict[@"serviceType"] = @(2);
            break;
        default:
            dict[@"serviceType"] = @(3);
            break;
    }
    
    [BYSendWorkHttpTool POSTIsSendWorkParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *status = data[@"status"];
            if ([status integerValue]) {//1:在派单 0：未派单
                if (self.noDataView) {
                    [self.noDataView removeFromSuperview];
                }
                BYSendOrderResultViewController *vc = [[BYSendOrderResultViewController alloc] init];
                vc.resultType = BYCarSendWorkingType;
                vc.leftBtnBlock = ^{
                    BYMyWorkOrderDetailController *vc = [[BYMyWorkOrderDetailController alloc] init];
                    vc.orderNo = data[@"orderNo"];
                    ///服务类别 1:安装,2:检修,3:拆机
                    NSString *type = data[@"serviceType"];
                    switch ([type integerValue]) {
                        case 1:
                            
                            vc.sendOrderType = BYWorkSendOrderType;
                            break;
                        case 2:
                            vc.sendOrderType = BYRepairSendOrderType;
                            break;
                        default:
                            vc.sendOrderType = BYUnpackSendOrderType;
                            
                            break;
                    }
                    
                    
                    [self.navigationController pushViewController:vc animated:YES];
                };
                vc.rightBtnBlock = ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                };
                [weakSelf addChildViewController:vc];
                vc.view.frame = CGRectMake(0, SafeAreaTopHeight, MAXWIDTH, MAXHEIGHT - SafeAreaTopHeight);
                weakSelf.noDataView = vc.view;
                [weakSelf.view addSubview:vc.view];
            }else{
                if (weakSelf.searchCallBack) {
                    weakSelf.searchCallBack(model);
                }
                
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        });
        
    } failure:^(NSError *error) {
        
    }];
}


-(void)deleteAllHistory:(UIButton *)button{
    
    if (self.historyData.count > 0) {
        [self.historyData removeAllObjects];
        if ([[BYSearchHistoryDataBase shareInstance] existHistoryWithUser:[BYSaveTool valueForKey:BYusername]]) {
            switch (self.type) {
                case 1:
                    [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] controlHistory:nil];
                    break;
                case 2:
                    [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] deviceListHistory:nil];
                    break;
                case 3:
                    [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] alarmListHistory:nil];
                    break;
                case 4:
                    [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] carListHistory:nil];
                    break;
                default:
                    break;
            }
        }
        [self.flow reloadAllWithTitles:self.historyData];
    }
}

#pragma mark -- tableview 代理 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isEditing) {
      return self.thinkSearchArrar.count;
    }else{
        return self.dataSource.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYWeakSelf;
    if (self.isEditing) {
        BYSearchCarNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYSearchCarNumberCell"];
        cell.model = self.thinkSearchArrar[indexPath.row];
        return cell;
    }else{
        BYSearchCarMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYSearchCarMessageCell"];
        cell.carMessageBlock = ^(BYSearchCarByNumOrVinModel *model) {
            
            if (weakSelf.searchCallBack) {
                weakSelf.searchCallBack(model);
            }
        };
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
   
}
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.isEditing) {
//
//        return 52;
//    }else{
//
//        return 122;
//    }
//}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isEditing){
        BYSearchCarByNumOrVinModel *model = self.thinkSearchArrar[indexPath.row];
        self.isSearch = YES;
        if (model.carNum.length) {
            self.keyWord = model.carNum;
        }else{
            self.keyWord = model.carVin;
        }
        [self tapSearch];
    }else{
        
        BYSearchCarByNumOrVinModel *model = self.dataSource[indexPath.row];
//        没有车牌号可以派单
//        if (model.carNum.length == 0) {
//            BYShowError(@"该车没有车牌号,不能使用");
//            return;
//        }
        if (_sendOrderType == BYWorkSendOrderType) {
            if (model.carVin.length == 0) {
                BYShowError(@"该车没有车架号,不能使用");
                return;
            }
        }
       
        if (model.carId == _carId) {//选中的车辆与编辑之前车辆一样
            if (self.searchCallBack) {
                self.searchCallBack(model);
            }
        }
        [self IsSendWorking:model];
       
    }
   
    
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isSearch) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH, 55)];
        view.backgroundColor = WHITE;
        UILabel *label = [UILabel verLab:15 textRgbColor:BYLabelBlackColor textAlighment:NSTextAlignmentLeft];
        label.text = [NSString stringWithFormat:@"共搜索到%zd条记录",self.dataSource.count];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.mas_equalTo(15);
        }];
        return view;
    }else{
        return nil;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_isSearch) {
        return 55;
    }else{
        return 0;
    }
}


#pragma mark - <UITextFieldDelegate>

/*
- (void)searchFieldChange:(UITextField *)textField{
    self.carNum = textField.text;
    self.keyWord = textField.text;
   
    
    self.isEditing = YES;
    self.isSearch = NO;
    [self.noDataView removeFromSuperview];
    self.tableView.tableFooterView = nil;
    if (textField.text.length <= 3) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
        [self thinkSearch];
    }
    [self.tableView reloadData];
    
}
*/
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeySearch;
    if (textField.text.length == 0) {
        [BYProgressHUD by_showErrorWithStatus:@"搜索内容不能为空"];
        return YES;
    }
    if (textField.text.length <= 3) {
        [BYProgressHUD by_showErrorWithStatus:@"至少需要输入4个字符搜索"];
        return YES;
    }
    [textField resignFirstResponder];
    self.isSearch = YES;
    textField.text = [textField.text uppercaseString];
    self.keyWord = textField.text;
    [self tapSearch];
    return YES;
}
- (void)saveHistroy:(NSString *)keyWord{
    if (![self.historyData containsObject:keyWord]) {
        [self.historyData insertObject:keyWord atIndex:0];
    }
    if (self.historyData.count > 10) {
        [self.historyData removeLastObject];
    }
    NSData *historyData = [NSJSONSerialization dataWithJSONObject:self.historyData   options:NSJSONWritingPrettyPrinted error:nil];
    NSString *historyArrStr = [[NSString alloc] initWithData:historyData encoding:NSUTF8StringEncoding];
    
    
    switch (self.type) {
        case 1:
            if ([[BYSearchHistoryDataBase shareInstance] existHistoryWithUser:[BYSaveTool valueForKey:BYusername]]) {
                [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] controlHistory:historyArrStr];
            }else{
                BYHistoryModel *model = [[BYHistoryModel alloc] init];
                
                model.controlHistory = historyArrStr;
                [[BYSearchHistoryDataBase shareInstance] insertUserName:[BYSaveTool valueForKey:BYusername] forHistoryModel:model];
            }
            break;
        case 2:
            if ([[BYSearchHistoryDataBase shareInstance] existHistoryWithUser:[BYSaveTool valueForKey:BYusername]]) {
                [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] deviceListHistory:historyArrStr];
            }else{
                BYHistoryModel *model = [[BYHistoryModel alloc] init];
                
                model.deviceListHistory = historyArrStr;
                [[BYSearchHistoryDataBase shareInstance] insertUserName:[BYSaveTool valueForKey:BYusername] forHistoryModel:model];
            }
            break;
        case 3:
            if ([[BYSearchHistoryDataBase shareInstance] existHistoryWithUser:[BYSaveTool valueForKey:BYusername]]) {
                [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] alarmListHistory:historyArrStr];
            }else{
                BYHistoryModel *model = [[BYHistoryModel alloc] init];
                model.alarmListHistory = historyArrStr;
                [[BYSearchHistoryDataBase shareInstance] insertUserName:[BYSaveTool valueForKey:BYusername] forHistoryModel:model];
            }
            break;
        case 4:
            if ([[BYSearchHistoryDataBase shareInstance] existHistoryWithUser:[BYSaveTool valueForKey:BYusername]]) {
                [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] carListHistory:historyArrStr];
            }else{
                BYHistoryModel *model = [[BYHistoryModel alloc] init];
                model.carListHistory = historyArrStr;
                [[BYSearchHistoryDataBase shareInstance] insertUserName:[BYSaveTool valueForKey:BYusername] forHistoryModel:model];
            }
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)historyData{
    if (!_historyData) {
        _historyData = [NSMutableArray array];
    }
    return _historyData;
}

#pragma mark -- lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.hidden = YES;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        BYRegisterCell(BYSearchCarMessageCell);
         BYRegisterCell(BYSearchCarNumberCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(NSMutableArray *)thinkSearchArrar
{
    if (!_thinkSearchArrar) {
        _thinkSearchArrar = [NSMutableArray array];
    }
    return _thinkSearchArrar;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end
