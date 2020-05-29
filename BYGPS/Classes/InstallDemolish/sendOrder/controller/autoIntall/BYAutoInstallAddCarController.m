//
//  BYAutoInstallAddCarController.m
//  BYGPS
//
//  Created by 李志军 on 2018/9/7.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoInstallAddCarController.h"
#import "BYAddCarInfoPaiViewCell.h"
#import "BYAddCarInfoViewCell.h"
#import "EasyNavigation.h"
#import "UILabel+HNVerLab.h"
#import <Masonry.h>
#import "BYCarMessageEntryFootView.h"
#import "BYCarNumSelectController.h"
#import "BYColorSelectController.h"
#import "BYAddCarInfoModel.h"
#import "BYBelongCompanyViewController.h"
#import "BYCarTypeViewController.h"
#import "BYRegularTool.h"
#import "BYCheckVinModel.h"
#import "BYSendWorkParameterModel.h"
#import "BYSelfServiceInstallController.h"
#import "BYInstallDeviceCheckModel.h"
#import "VinManager.h"
#import "PlateCameraController.h"
#import <MobileCoreServices/MobileCoreServices.h>


@interface BYAutoInstallAddCarController ()<UITableViewDelegate,UITableViewDataSource,VinManagerDelegate,PlateCameraDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *colorSource;
@property (nonatomic,strong) BYAddCarInfoModel *model;
@property (nonatomic,strong) BYCheckVinModel *checkVinModel;
@property (nonatomic,strong) BYCheckVinModel *checkCarNumModel;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableDictionary *dict;
@property (nonatomic,assign) BOOL selectOtherColor;
@property (nonatomic,strong) NSArray *otherColorTitleArray;
///存储带出来的车牌号
@property (nonatomic,strong) NSString *carNum;
@end

@implementation BYAutoInstallAddCarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
    [self refrashCarInfo];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBase{
    [self.navigationView setTitle:@"自助装"];
//    self.model.brand = @"其他";
    self.view.backgroundColor = BYBigSpaceColor;
    BYWeakSelf;
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    BYCarMessageEntryFootView *carMessageEntryFootView = [BYCarMessageEntryFootView by_viewFromXib];
    [carMessageEntryFootView.nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    carMessageEntryFootView.frame = CGRectMake(0, 0, MAXWIDTH, 100);
    carMessageEntryFootView.backgroundColor = BYBigSpaceColor;
    
    carMessageEntryFootView.nextStepClickBlock = ^{
       
       
        if ([weakSelf checkParameter]) {
             [weakSelf checkCarNum];
        }

       
    };
    self.tableView.tableFooterView = carMessageEntryFootView;
    
}
#pragma mark -- 下一步
- (void)next{
    
    
    
    BYSendWorkParameterModel *parameterModel = [[BYSendWorkParameterModel alloc] init];
    BYInstallDeviceCheckModel *model = self.array.firstObject;
    parameterModel.groupId = model.groupId;
    parameterModel.groupCompany = model.group;
    parameterModel.serviceAddress = model.deviceLocation;
    parameterModel.carId = self.model.carId;
    parameterModel.carVin = self.model.carVin;
    parameterModel.carBrand = self.model.brand;
    parameterModel.carModel = [self.model.brand isEqualToString:@"其他"]  ? @"其他" : self.model.carModel ;
    parameterModel.carType = [self.model.brand isEqualToString:@"其他"] || [self.model.carType isEqualToString:@"其他"] ? @"其他" : self.model.carType;
    parameterModel.carNum = self.model.carNum;
    if (self.model.contractNo.length) {
        parameterModel.contractNo = self.model.contractNo;
    }else{
        parameterModel.contractNo = @"";
    }
    parameterModel.carColor = [self.model.color isEqualToString:@"其他"] ? self.model.otherColor : self.model.color;
    parameterModel.carOwnerName = self.model.ownerName;
    parameterModel.carOwnerTel = self.model.ownerTel;
    NSMutableArray *arr = [NSMutableArray array];
    for (BYInstallDeviceCheckModel *model1 in self.array) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"deviceSupplier"] = @"标越GPS设备";
        dict[@"deviceType"] = @(model1.deviceType);
        dict[@"deviceModel"] = model1.deviceModel;
        dict[@"deviceSn"] = model1.deviceSn;
        dict[@"alias"] = model1.alias;
        [arr addObject:dict];
    }
    parameterModel.appointServiceItemVo = arr;
    
    BYSelfServiceInstallController *vc = [[BYSelfServiceInstallController alloc] init];
    vc.parameterModel = parameterModel;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 参数检查
- (BOOL)checkParameter{
    if (_isCheckVin) {
        if (!self.model.carVin.length) {
            BYShowError(@"车架号不能为空");
            return NO;
        }
        if ([BYRegularTool checkCheJiaNumber:self.model.carVin]) {
            [BYProgressHUD by_showErrorWithStatus:@"请输入正确的车架号"];
            return NO;
        }
    }else{
        if (!self.model.carNum.length) {
            BYShowError(@"车牌号不能为空");
            return NO;
        }
    }
    if (!self.model.companyId.length) {
        BYShowError(@"请选择所属公司");
        return NO;
    }
    
//    if (!self.model.brand.length) {
//        BYShowError(@"请选择车辆品牌");
//        return NO;
//    }
    if (self.model.ownerTel.length > 0 && self.model.ownerTel.length != 11) {
        BYShowError(@"请输入正确的手机号码");
        return NO;
    }
    
    if (!self.model.color.length) {
        BYShowError(@"请选择车辆颜色");
        return NO;
    }
    return YES;
}

#pragma mark -- 检查车辆是否在派单
- (void)autoCheckIsSendOrder{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"groupId"] = @(_groupId);
    if (_isCheckVin) {
        if (_model.carVin.length == 0) return;
        dict[@"carVin"] = _model.carVin;
    }else{
        if (_model.carNum.length == 0) return;
        if (_model.carNum.length < 7) return;
        dict[@"carNum"] = _model.carNum;
    }
    
    BYWeakSelf;
    [BYSendWorkHttpTool POSTAutoCheckIsSendOrderParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
//        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.checkVinModel = [BYCheckVinModel yy_modelWithDictionary:data];
            [weakSelf refrashData];
//        });
    } failure:^(NSError *error) {
        
    }];
}
- (void)refrashData{
    if (self.checkVinModel.status) {//0未派单,=1在派单
        return BYShowError(@"该车已在安装中，不能同时安装！");
    }else{
        [self autoQuickGetCarParams];
    }
}
#pragma mark -- 查询车辆信息
- (void)autoQuickGetCarParams{
    BYWeakSelf;
   
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    self.dict = dict;
    dict[@"groupId"] = @(_groupId);
    if (_isCheckVin) {
        if (_model.carVin.length == 0) return;
         dict[@"carVin"] = _model.carVin;
    }else{
        if (_model.carNum.length == 0) return;
        dict[@"carNum"] = _model.carNum;
    }
    [self.dataSource removeAllObjects];
    self.model = nil;
   
    
    [BYSendWorkHttpTool POSTAutoQuickGetCarParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYLog(@"%@",data);
            weakSelf.dataSource = [[NSArray yy_modelArrayWithClass:[BYAddCarInfoModel class] json:data] mutableCopy];
            
            [weakSelf refrashCarInfo];
        });
    } failure:^(NSError *error) {
        
    }];
}

- (void)refrashCarInfo{
    if (self.dataSource.count) {
         self.model = self.dataSource.firstObject;
        NSString *carVin = self.dict[@"carVin"];
        NSString *carNum = self.dict[@"carNum"];
        if (carVin.length) {
            self.model.carVin = carVin;
        }
        if (carNum.length) {
            self.model.carNum = carNum;
        }
        if (!self.model.groupId.length) self.model.groupId = [NSString stringWithFormat:@"%zd",_groupId];
        if (self.model.carNum.length > 2) {
            self.model.carFirstNum = [self.model.carNum substringToIndex:2];
            self.model.carLastNum = [self.model.carNum substringFromIndex:2];
        }
        self.model.company = _groupName;
        self.model.companyId = self.model.groupId;
        //保存带出来的车辆信息车牌号
        self.carNum = self.model.carNum;
       
    }else{
//        self.model = [[BYAddCarInfoModel alloc] init];
        self.model.company = _groupName;
        self.model.companyId = [NSString stringWithFormat:@"%zd",_groupId];
        if (_isCheckVin) {
            self.model.carVin = self.dict[@"carVin"];
        }else{
            self.model.carNum = self.dict[@"carNum"];
            if (self.model.carNum.length > 2) {
                self.model.carFirstNum = [self.model.carNum substringToIndex:2];
                self.model.carLastNum = [self.model.carNum substringFromIndex:2];
            }
        }
    }
    if (self.model.carFirstNum.length)
        [BYSaveTool setValue:self.model.carFirstNum forKey:@"carFirstNum"];
    NSString *carFirstNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"carFirstNum"];
    if (carFirstNum.length == 0) {
        self.model.carFirstNum = @"粤B";
    }else{
        self.model.carFirstNum = carFirstNum;
    }
//    self.model.brand = self.model.brand > 0 ? self.model.brand : @"其他";
    
   [self.tableView reloadData];
}

#pragma mark -- 车牌号校验
- (void)checkCarNum{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"groupId"] = @(_groupId);
    
    if (_isCheckVin) {//需要车架号
        if (_model.carNum.length == 0){
             [self next];
            return;
        }
        dict[@"carNum"] = _model.carNum;
        if (_model.carId) {
//            if ([_model.carNum isEqualToString:self.carNum]) {
                dict[@"carId"] = @(_model.carId);
//            }
        }
    }else{//不需要车架号
        if (_model.carNum.length == 0) return;
        dict[@"carNum"] = _model.carNum;
        if (_model.carId) {
            dict[@"carId"] = @(_model.carId);
        }
    }
    
   
    BYWeakSelf;
    [BYSendWorkHttpTool POSTAutoCheckCarNumParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.checkCarNumModel = [BYCheckVinModel yy_modelWithDictionary:data];
            [weakSelf refreshDataCheckCarNum];
        });
      
    } failure:^(NSError *error) {
        
    }];
}
- (void)refreshDataCheckCarNum{
    if (self.checkCarNumModel.checkCarNum) {//不通过
        return BYShowError(@"车牌号已使用");
    }else{//通过
         [self next];
    }
}
#pragma mark -- tableview 数据源 代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.selectOtherColor ? self.otherColorTitleArray.count : self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.selectOtherColor ? self.otherColorTitleArray[section] :  self.titleArray[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    if(indexPath.section == 0 && indexPath.row == 1){
        BYAddCarInfoPaiViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYAddCarInfoPaiViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isAutoInstall = YES;
        cell.isInputVin = _isCheckVin;
        cell.model = self.model;
        cell.scanBtnClickBlock = ^{//扫一扫
            [weakSelf carNumScan];
        };
        cell.carInfoPaiBlock = ^{
            BYCarNumSelectController * carNumVc = [[BYCarNumSelectController alloc] init];
            carNumVc.citySelectBlock = ^(NSString *provinceAndCity) {
                BYLog(@"carNum = %@",provinceAndCity);
                weakSelf.model.carFirstNum = provinceAndCity;
                [[NSUserDefaults standardUserDefaults] setObject:provinceAndCity forKey:@"carFirstNum"];
                
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:carNumVc animated:YES];
        };
        __weak typeof(cell) weakCell = cell;
        cell.carNumBlock = ^(NSString *carNumber) {
            BYLog(@"carNumber = %@",carNumber);
            if (carNumber.length == 0){
//            weakSelf.model.carLastNum = carNumber;
                weakSelf.model.carNum = @"";
                return ;
            } ;
            if (carNumber.length >= 7) {
               weakSelf.model.carFirstNum = [carNumber substringToIndex:2];
                weakSelf.model.carLastNum = [carNumber substringFromIndex:2];
                 weakSelf.model.carNum = [NSString stringWithFormat:@"%@%@",weakSelf.model.carFirstNum,weakSelf.model.carLastNum];
                 [[NSUserDefaults standardUserDefaults] setObject:weakSelf.model.carFirstNum forKey:@"carFirstNum"];
            }else{
              weakSelf.model.carLastNum = carNumber;
                weakCell.textField.text = weakSelf.model.carLastNum;
                NSString *carFirstNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"carFirstNum"];
                if (carFirstNum.length == 0) {
                    self.model.carFirstNum = @"粤B";
                }else{
                    self.model.carFirstNum = carFirstNum;
                }
                 weakSelf.model.carNum = [NSString stringWithFormat:@"%@%@",weakSelf.model.carFirstNum,weakSelf.model.carLastNum];
            }
            
            
            
//            weakSelf.model.carLastNum = carNumber;
//            if (!weakSelf.model.carFirstNum.length) {
//                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"carFirstNum"]) {
//                    weakSelf.model.carFirstNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"carFirstNum"];
//                }else{
//                    weakSelf.model.carFirstNum = @"粤B";
            
//                }
//
//            }
            
           
            if (!_isCheckVin) {//校验该车是否在派单
                
                [self autoCheckIsSendOrder];
            }
            [weakSelf.tableView reloadData];
        };
        
        return cell;
    }else{
        BYAddCarInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYAddCarInfoViewCell" forIndexPath:indexPath];
        cell.selectOtherColor  = self.selectOtherColor;
        cell.addCarInfoBlock = ^(NSString *str, NSIndexPath *indexPath) {
            switch (indexPath.section) {
                case 0:
                {
                    
                    if (indexPath.row == 0) {
                        weakSelf.model.carVin = str;
                        [self autoCheckIsSendOrder];
                    }
                    
                    if (indexPath.row == 5) {
                        weakSelf.model.otherColor = str;
                    }
                    
                }
                    break;
                    
                default:
                {
                    if (indexPath.row == 0) {
                        weakSelf.model.ownerName = str;
                    }else if(indexPath.row == 1){
                        weakSelf.model.ownerTel = str;
                    }else{
                        weakSelf.model.contractNo = str;
                    }
                }
                    break;
            }
        };
        cell.scanBtnClickBlock = ^{//扫一扫
             [weakSelf carVinScan];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isAutoInstall = YES;
        cell.isInputVin = _isCheckVin;
        cell.model = self.model;
        cell.indexPath = indexPath;
        
        return cell;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BYWeakSelf;
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
            BYColorSelectController * colorVc = [[BYColorSelectController alloc] init];
            
            [colorVc setColorItemSelectBlock:^(NSInteger tag) {
                
                weakSelf.model.color = self.colorSource[tag];
                if ([weakSelf.model.color isEqualToString:@"其他"]) {
                    self.selectOtherColor = YES;
                    //                    cell.selectOtherColor = YES;
                }else{
                    self.selectOtherColor = NO;
                    //                    cell.selectOtherColor = NO;
                }
                [weakSelf.tableView reloadData];
            }];
            
            [self.navigationController pushViewController:colorVc animated:YES];
        }else if (indexPath.row == 3){
            BYCarTypeViewController *vc = [[BYCarTypeViewController alloc] init];
            vc.carTypeViewBlock = ^(NSString *brand,NSString *carType,NSString *carInfoType) {
                //            if ([brand isEqualToString:@"其他"] && [carType isEqualToString:@"其他"] && [carInfoType isEqualToString:@"其他"]) {
                //                weakSelf.model.brand = @"其他";
                //                weakSelf.model.carType = @"";
                //                weakSelf.model.carModel = @"";
                //                [weakSelf.tableView reloadData];
                //            }else{
                weakSelf.model.brand = brand;
                weakSelf.model.carType = carType;
                weakSelf.model.carModel = carInfoType;
                [weakSelf.tableView reloadData];
                //            }
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 2){
            /*
             BYBelongCompanyViewController *vc = [[BYBelongCompanyViewController alloc] init];
             vc.groupIdsStrBlock = ^(NSString *groupIdsStr) {
             NSArray *arr = [groupIdsStr componentsSeparatedByString:@"-"];
             weakSelf.model.companyId = arr.firstObject;
             weakSelf.model.company = arr.lastObject;
             [weakSelf.tableView reloadData];
             };
             [self.navigationController pushViewController:vc animated:YES];
             */
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
        label.text = @"新增车辆";
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
        return 50;
    }else{
        return 5;
    }
}

#pragma mark -- 车牌号扫一扫
- (void)carNumScan{
    BYWeakSelf;
    PlateCameraController * cameraController = [[PlateCameraController alloc] initWithAuthorizationCode:AUTHCODE];
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
    }
    cameraController.delegate = weakSelf;
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
    self.model.carVin = vinCode;
    [self autoCheckIsSendOrder];
    [self.tableView reloadData];
}
#pragma mark - 识别结果回调
- (void)cameraController:(UIViewController *)cameraController recognizePlateSuccessWithResult:(NSString *)plateStr plateColor:(NSString *)plateColor andPlateImage:(UIImage *)plateImage {
    [cameraController dismissViewControllerAnimated:YES completion:nil];
    BYLog(@"%@ %@",plateStr,plateColor);
    if (plateStr.length >= 7) {
        self.model.carFirstNum = [plateStr substringToIndex:2];
        self.model.carLastNum = [plateStr substringFromIndex:2];
        self.model.carNum = [NSString stringWithFormat:@"%@%@",self.model.carFirstNum,self.model.carLastNum];
        [[NSUserDefaults standardUserDefaults] setObject:self.model.carFirstNum forKey:@"carFirstNum"];
        if (!_isCheckVin) {//校验该车是否在派单
            
            [self autoCheckIsSendOrder];
        }
    }
    [self.tableView reloadData];
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
        BYLog(@"vin = %@",vinCode);
        self.model.carVin = vinCode;
        [self autoCheckIsSendOrder];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    }else{//识别失败
        
        [SVProgressHUD dismiss];
        BYShowError(@"识别失败");
    }
}

#pragma mark -- lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = BYBigSpaceColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
        BYRegisterCell(BYAddCarInfoViewCell);
        BYRegisterCell(BYAddCarInfoPaiViewCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@[@"*车架号",@"车牌号",@"*所属公司",@"*车辆品牌",@"*车辆颜色"],@[@"*车主姓名",@"*车主电话",@"合同编号"]];
    }
    return _titleArray;
}
-(NSArray *)otherColorTitleArray{
    if (!_otherColorTitleArray) {
        _otherColorTitleArray = @[@[@"车牌号",@"*车架号",@"*所属公司",@"车辆品牌",@"*车辆颜色",@""],@[@"*车主姓名",@"*车主电话",@"合同编号"]];
    }
    return _otherColorTitleArray;
}
-(NSArray *)colorSource
{
    if (!_colorSource) {
        _colorSource = @[@"黑色",@"红色",@"深灰色",@"粉红色",@"银灰色",@"紫色",@"白色",@"蓝色",@"香槟色",@"绿色",@"黄色",@"咖啡色",@"橙色",@"多彩色",@"其他"];
    }
    return _colorSource;
}
-(BYAddCarInfoModel *)model
{
    if (!_model) {
        _model = [[BYAddCarInfoModel alloc] init];
    }
    return _model;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource
        ) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
