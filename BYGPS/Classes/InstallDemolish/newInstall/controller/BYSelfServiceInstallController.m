//
//  BYSelfServiceInstallController.m
//  BYGPS
//
//  Created by ZPD on 2018/9/6.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYSelfServiceInstallController.h"
#import "BYInstallInfoCell.h"
#import "BYSelfServiceInstallNextView.h"
#import "BYSelfServiceInstallFooterView.h"
#import "BYSendWorkParameterModel.h"
#import "BYSelfServiceInstallDeviceModel.h"

#import "SXPickPhoto.h"
#import "GDObjectUploadManager.h"
#import "BYInstallHeaderView.h"
#import "EasyNavigation.h"
#import "BYSendWorkHttpTool.h"
#import "BYPhotoModel.h"

#import "BYSelfServiceInstallSuccessViewController.h"
#import "UIImage+FixOrientation.h"

@interface BYSelfServiceInstallController ()<UITableViewDelegate,UITableViewDataSource
,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;

@property (nonatomic,strong) BYSelfServiceInstallFooterView *footerView;

@property (nonatomic,strong) SXPickPhoto *pickPhoto;
@property (nonatomic,strong) BYPhotoModel *VinPhotoModel;

@property (nonatomic,strong) BYSelfServiceInstallDeviceModel *deviceInstallModel;  //
@property (nonatomic,assign) NSInteger selectImgIndex;  //<#检索高危按钮#>


@end

@implementation BYSelfServiceInstallController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BYWeakSelf;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        [self.navigationView removeAllLeftButton];
        [self.navigationView removeAllRightButton];
//
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//
//    });
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
    [self initDataBase];
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
    tableHeader.showStepIndex = 2;
    tableHeader.frame = CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, 70);
    tableHeader.topNoticeView.hidden = YES;
    tableHeader.topH.constant = -30;
    [self.view addSubview:tableHeader];
    
//    [tableHeader mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(SafeAreaTopHeight);
//        make.size.mas_equalTo(CGSizeMake(MAXWIDTH, 70));
//    }];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    BYRegisterCell(BYInstallInfoCell);
    [self.view addSubview:self.tableView];
    
    self.footerView = [BYSelfServiceInstallFooterView by_viewFromXib];
    self.footerView.by_height = 140.0;
    self.footerView.by_width = BYSCREEN_W;

    [self.footerView setTapVINImgBgViewCallBack:^{
        [weakSelf aleShowViewWithDeviceModel:nil footerViewImgTag:1];
    }];
    [self.footerView setDeleteVinImgBlock:^{
        weakSelf.VinPhotoModel.image = [UIImage imageNamed:@"icon_selfInstall_placeHold"];
        weakSelf.VinPhotoModel.isP_HImage = YES;
        weakSelf.footerView.photoModel = weakSelf.VinPhotoModel;
    }];
    
    self.tableView.tableFooterView = self.footerView;
    
    BYSelfServiceInstallNextView *bottomView = [BYSelfServiceInstallNextView by_viewFromXib];
 
    [bottomView setLastStepBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [bottomView setCommitBlock:^{
        [self uploadInstallInfo];
    }];

//    bottomView.frame = CGRectMake(0, MAXHEIGHT - 50 - kSafeBottomHeight, MAXWIDTH, 50);
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-kSafeBottomHeight);
        make.size.mas_equalTo(CGSizeMake(MAXWIDTH, 50));
        make.centerX.equalTo(self.view);
    }];
    
}

-(void)initDataBase{
    
    for (NSDictionary *dic in self.parameterModel.appointServiceItemVo) {
        BYSelfServiceInstallDeviceModel *deviceModel = [[BYSelfServiceInstallDeviceModel alloc] initWithDictionary:dic error:nil];
        deviceModel.positionIsP_HImage = YES;
        if ([deviceModel.deviceType integerValue] == 0) {
            deviceModel.positionPlaceHoldImgUrl = @"http://bykj-install-01.oss-cn-shenzhen.aliyuncs.com/wifi/confirmImg_100.png";
        }else{
            deviceModel.positionPlaceHoldImgUrl = @"http://bykj-install-01.oss-cn-shenzhen.aliyuncs.com/wifi/confirmImg_101.png";
        }
        deviceModel.positionUploadImg = [UIImage imageNamed:@"icon_selfInstall_placeHold"];
        
        [self.dataSourceArr addObject:deviceModel];
    }
    
    self.VinPhotoModel = [[BYPhotoModel alloc] init];
    self.VinPhotoModel.image = [UIImage imageNamed:@"icon_selfInstall_placeHold"];
    self.VinPhotoModel.isP_HImage = YES;

    [self.tableView reloadData];
    
    self.footerView.photoModel = self.VinPhotoModel;
    
}

#pragma mark --提交安装信息、
-(void)uploadInstallInfo{
    
    //判断必填信息
    for (BYSelfServiceInstallDeviceModel *model in self.dataSourceArr) {

        
        if (!model.devicePosition.length) {
            return BYShowError(@"请输入设备安装位置");
        }
        
        if (model.positionIsP_HImage) {
            return BYShowError(@"请上传安装位置图片");
        }
        
        if ([model.deviceType integerValue] == 0) {
            if ([model.devicePosition integerValue] >= 17 || [model.devicePosition integerValue] <= 0) {
                return BYShowError(@"有线设备请输入1-16的安装位置");
            }
        }else{
            if (([model.devicePosition integerValue] > 0 && [model.devicePosition integerValue] <= 16) || [model.devicePosition integerValue] > 31) {
                return BYShowError(@"无线或其他设备请输入17-31的安装位置");
            }
        }
    }
    if (self.VinPhotoModel.isP_HImage) {
        return BYShowError(@"请上传设备和VIN合照");
    }

    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    [paramDic setValue:@(self.parameterModel.groupId) forKey:@"groupId"];
    [paramDic setValue:self.parameterModel.groupCompany forKey:@"groupCompany"];
    [paramDic setValue:@"2" forKey:@"source"];
    [paramDic setValue:@(self.parameterModel.carId) forKey:@"carId"];
    [paramDic setValue:self.parameterModel.carBrand forKey:@"carBrand"];
    [paramDic setValue:self.parameterModel.carModel forKey:@"carModel"];
    [paramDic setValue:self.parameterModel.carType forKey:@"carType"];
    [paramDic setValue:self.parameterModel.carVin forKey:@"carVin"];
    [paramDic setValue:self.parameterModel.carNum forKey:@"carNum"];
    [paramDic setValue:self.parameterModel.carColor forKey:@"carColor"];
    [paramDic setValue:self.parameterModel.carOwnerName forKey:@"carOwnerName"];
    [paramDic setValue:self.parameterModel.carOwnerTel forKey:@"carOwnerTel"];
    [paramDic setValue:self.parameterModel.serviceAddress forKey:@"serviceAddress"];
    [paramDic setValue:self.parameterModel.contractNo forKey:@"contractNo"];
    
    NSMutableArray *deviceJsonArr = [NSMutableArray array];
    for (BYSelfServiceInstallDeviceModel *deviceModel in self.dataSourceArr) {
        NSMutableDictionary *deviceDic = [NSMutableDictionary dictionary];
        [deviceDic setValue:deviceModel.deviceSn forKey:@"deviceSn"];
        [deviceDic setValue:deviceModel.deviceSupplier forKey:@"deviceSupplier"];
        [deviceDic setValue:deviceModel.deviceType forKey:@"deviceType"];
        [deviceDic setValue:deviceModel.devicePosition forKey:@"devicePosition"];
        [deviceDic setValue:deviceModel.deviceModel forKey:@"deviceModel"];
        [deviceDic setValue:deviceModel.imgUrl forKey:@"imgUrl"];
       [deviceDic setValue:self.VinPhotoModel.imageAddress forKey:@"vinDeviceImg"];
        
        [deviceJsonArr addObject:deviceDic];
    }
    [paramDic setValue:deviceJsonArr forKey:@"deviceList"];
    
    
    [BYSendWorkHttpTool POSTAutoInstallParams:paramDic success:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BYSelfServiceInstallSuccessViewController *successVC = [BYSelfServiceInstallSuccessViewController new];
            [self.navigationController pushViewController:successVC animated:YES];
        });
       
    } failure:^(NSError *error) {
        
    }];
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSourceArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BYInstallInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYInstallInfoCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BYSelfServiceInstallDeviceModel *deviceModel = self.dataSourceArr[indexPath.row];
    cell.deviceModel = deviceModel;
    [cell setTapInstallPositionImgBgViewCallBack:^{
        [self aleShowViewWithDeviceModel:deviceModel footerViewImgTag:0];
    }];
    [cell setInstallInfoDeleteImgCallBack:^(NSInteger tag) {
        deviceModel.positionIsP_HImage = YES;
        deviceModel.imgUrl = @"";

    }];
    
    [cell setInputInstallNumBlock:^(NSString *num) {
        deviceModel.devicePosition = num;
    }];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 380.0f;
}

#pragma mark - === 提示框 ===
- (void)aleShowViewWithDeviceModel:(BYSelfServiceInstallDeviceModel *)deviceModel footerViewImgTag:(NSInteger)tag
{
    self.deviceInstallModel = deviceModel;
    _selectImgIndex = tag;
    UIAlertAction * act1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    //拍照：
    UIAlertAction * act2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsEditing = YES;
            imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
//        //打开相机
//        [self.pickPhoto ShowTakePhotoWithController:self andWithBlock:^(NSObject *Data) {
//
//            if ([Data isKindOfClass:[UIImage class]])
//            {
////                if (deviceModel) {
//
//                    BYWeakSelf;
//                    [BYSendWorkHttpTool POSTOssSignParams:nil success:^(id data) {
//                        BYLog(@"%@",data);
//                        [BYSaveTool setValue:data[@"accessId"] forKey:BYAccessId];
//                        [BYSaveTool setValue:data[@"bucket"] forKey:BYbucket];
//                        [BYSaveTool setValue:data[@"endpoint"] forKey:BYEndpoint];
//                        [BYSaveTool setValue:data[@"signature"] forKey:BYSignature];
//
//                        [GDObjectUploadManager uploadImageWithImgType:GDUploadObjectTypeUserStudent image:(UIImage *)Data compressionMode:GDUploadImageCompressionModeDefault uploadProgress:^(CGFloat progress, NSUInteger bytesSent, NSUInteger totalBytesSent, NSUInteger totalBytesExpectedToSend) {
//                            [BYProgressHUD by_showBgViewWithStatus:@"图片上传中..."];
//                        } completionHandler:^(NSError *error, NSString *fileName, NSUInteger totalBytesExpectedToSend) {
//                            [BYProgressHUD dismiss];
//                            BYLog(@"headImg fileName = %@", fileName);
//
//                            if (!error) {
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    if (1 == tag) {
//
//                                        self.VinPhotoModel.isP_HImage = NO;
//                                        self.VinPhotoModel.imageAddress = fileName;
//                                        self.footerView.photoModel = self.VinPhotoModel;
//                                    }
//                                    if (0 == tag) {
////                                        deviceModel.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",[BYSaveTool valueForKey:kEndPoint],fileName]];
//                                        deviceModel.positionIsP_HImage = NO;
//                                        deviceModel.imgUrl = fileName;
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            [self.tableView reloadData];
//                                        });
//                                    }
//                                });
//                            }else{
//                                BYShowError(@"上传图片失败");
//                            }
//                        }];
//
//                    } failure:^(NSError *error) {
//
//                    }];
////                }
//            }
//        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开相册
        
        if (@available(iOS 11.0, *)) {
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
        }
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        imagePicker.delegate = self;
        imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:imagePicker animated:YES completion:nil];
        
//        [self.pickPhoto SHowLocalPhotoWithController:[UIApplication sharedApplication].keyWindow.rootViewController andWithBlock:^(NSObject *Data) {
//            if ([Data isKindOfClass:[UIImage class]])
//            {
////                if (deviceModel) {
//                    BYWeakSelf;
//                    [BYSendWorkHttpTool POSTOssSignParams:nil success:^(id data) {
//                        BYLog(@"%@",data);
//                        [BYSaveTool setValue:data[@"accessId"] forKey:BYAccessId];
//                        [BYSaveTool setValue:data[@"bucket"] forKey:BYbucket];
//                        [BYSaveTool setValue:data[@"endpoint"] forKey:BYEndpoint];
//                        [BYSaveTool setValue:data[@"signature"] forKey:BYSignature];
//
//                        [GDObjectUploadManager uploadImageWithImgType:GDUploadObjectTypeUserStudent image:(UIImage *)Data compressionMode:GDUploadImageCompressionModeDefault uploadProgress:^(CGFloat progress, NSUInteger bytesSent, NSUInteger totalBytesSent, NSUInteger totalBytesExpectedToSend) {
//                            [BYProgressHUD by_showBgViewWithStatus:@"图片上传中..."];
//                        } completionHandler:^(NSError *error, NSString *fileName, NSUInteger totalBytesExpectedToSend) {
//                            [BYProgressHUD dismiss];
//                            BYLog(@"headImg fileName = %@", fileName);
//
//                            if (!error) {
//                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    if (1 == tag) {
//
//                                        self.VinPhotoModel.isP_HImage = NO;
//                                        self.VinPhotoModel.imageAddress = fileName;
//                                        self.footerView.photoModel = self.VinPhotoModel;
//                                    }
//                                    if (0 == tag) {
//                                        //                                        deviceModel.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",[BYSaveTool valueForKey:kEndPoint],fileName]];
//                                        deviceModel.positionIsP_HImage = NO;
//                                        deviceModel.imgUrl = fileName;
//                                        dispatch_async(dispatch_get_main_queue(), ^{
//                                            [self.tableView reloadData];
//                                        });
//                                    }
//                                });
//                            }else{
//                                BYShowError(@"上传图片失败");
//                            }
//                        }];
//
//                    } failure:^(NSError *error) {
//
//                    }];
////                }
//            }
//        }];
    }];
    
    UIAlertController * aleVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    if ([BYObjectTool getIsIpad]){
        
        aleVC.popoverPresentationController.sourceView = self.view;
        aleVC.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
    }
    [aleVC addAction:act1];
    [aleVC addAction:act2];
    [aleVC addAction:act3];
    
    [self presentViewController:aleVC animated:NO completion:nil];
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    if (info[UIImagePickerControllerOriginalImage] == nil) {
        return [BYProgressHUD by_showErrorWithStatus:@"选择照片错误"];
    }
    
    UIImage * selectImage = info[UIImagePickerControllerOriginalImage];
    selectImage = [selectImage fixOrientation];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    BYWeakSelf;
    [BYSendWorkHttpTool POSTOssSignParams:nil success:^(id data) {
        BYLog(@"%@",data);
        [BYSaveTool setValue:data[@"accessId"] forKey:BYAccessId];
        [BYSaveTool setValue:data[@"bucket"] forKey:BYbucket];
        [BYSaveTool setValue:data[@"endpoint"] forKey:BYEndpoint];
        [BYSaveTool setValue:data[@"signature"] forKey:BYSignature];
        
        [GDObjectUploadManager uploadImageWithImgType:GDUploadObjectTypeUserStudent image:(UIImage *)selectImage compressionMode:GDUploadImageCompressionModeDefault uploadProgress:^(CGFloat progress, NSUInteger bytesSent, NSUInteger totalBytesSent, NSUInteger totalBytesExpectedToSend) {
            [BYProgressHUD by_showBgViewWithStatus:@"图片上传中..."];
        } completionHandler:^(NSError *error, NSString *fileName, NSUInteger totalBytesExpectedToSend) {
            [BYProgressHUD dismiss];
            BYLog(@"headImg fileName = %@", fileName);
            
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (1 == _selectImgIndex) {
                        
                        self.VinPhotoModel.isP_HImage = NO;
                        self.VinPhotoModel.imageAddress = fileName;
                        self.footerView.photoModel = self.VinPhotoModel;
                    }
                    if (0 == _selectImgIndex) {
                        //                                        deviceModel.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@/%@",[BYSaveTool valueForKey:kEndPoint],fileName]];
                        self.deviceInstallModel.positionIsP_HImage = NO;
                        self.deviceInstallModel.imgUrl = fileName;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }
                });
            }else{
                BYShowError(@"上传图片失败");
            }
        }];
        
    } failure:^(NSError *error) {
        
    }];
}




#pragma mark --LAZY

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+70, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight - 50 - 70) style:UITableViewStylePlain];
        
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


-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

-(SXPickPhoto *)pickPhoto
{
    if (!_pickPhoto) {
        _pickPhoto = [[SXPickPhoto alloc] init];
    }
    return _pickPhoto;
}


@end
