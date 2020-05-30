//
//  BYAutoServiceDeviceRepairController.m
//  BYGPS
//
//  Created by ZPD on 2018/12/13.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceDeviceRepairController.h"
#import "BYAutoServiceDeviceRepairSwitchCell.h"
#import "BYAutoServiceDeviceRepairCheckCell.h"
#import "BYAutoServiceDeviceRepairInfoCell.h"
#import "BYAutoServiceDeviceRepairReasonCell.h"
#import "BYAutoServiceDeviceRemoveFooterView.h"
#import "BYAutoRepairDeviceSearchViewController.h"

#import "BYAutoServiceConstant.h"
#import "EasyNavigation.h"

#import "BYAutoDeviceRepairDeviceModel.h"
#import "BYAutoServiceDeviceModel.h"
#import "BYAutoServiceCarModel.h"
#import "SXPickPhoto.h"
#import "GDObjectUploadManager.h"
#import "BYAutoServiceHttpTool.h"
#import "SDPhotoBrowser.h"
#import "UIImage+FixOrientation.h"

@interface BYAutoServiceDeviceRepairController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SDPhotoBrowserDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) BYAutoServiceDeviceRemoveFooterView *footerView;
@property (nonatomic,strong) BYAutoDeviceRepairDeviceModel *deviceSnnModel;
@property (nonatomic,strong) BYAutoDeviceRepairDeviceModel *deviceRepairModel;  //


@property (nonatomic,strong) SXPickPhoto *pickPhoto;
@property (nonatomic,assign) NSInteger selectImageIndex;
@property (nonatomic,assign) BOOL installConfirm;

@property (nonatomic,assign) BOOL installImg;  //是否是安装图片

@end

@implementation BYAutoServiceDeviceRepairController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    [self initDataBase];
}
-(void)initBase{
    
    NSString *deviceModel = self.deviceModel.deviceId.length > 0 ? self.deviceModel.alias : @"";
    [self.navigationView setTitle:[NSString stringWithFormat:@"%@（%@%@）",self.deviceModel.deviceSn,deviceModel,self.deviceModel.deviceType == 0 ? @"有线" : self.deviceModel.deviceType == 1 ? @"无线" : @"其他"]];
    
    [self.view addSubview:self.tableView];
    
    self.footerView = [BYAutoServiceDeviceRemoveFooterView by_viewFromXib];
    self.footerView.by_y = IPHONE_X ?  kScreenHeight - 120 - 34: kScreenHeight - 120;
    self.footerView.by_width = kScreenWidth;
    self.footerView.by_height = 120;
    BYWeakSelf;
    [self.footerView setCancleBlock:^{
        
        
        
        weakSelf.deviceModel.repaired = NO;
        NSString *deviceVinImg;
        for (BYPhotoModel *photoModel in weakSelf.deviceModel.photoArr) {
            if (deviceVinImg.length <=0) {
                deviceVinImg = photoModel.imageAddress;
            }else{
                deviceVinImg = [NSString stringWithFormat:@"%@,%@",deviceVinImg,photoModel.imageAddress];
            }
        }
        weakSelf.deviceModel.vinDeviceImg = @"";
        weakSelf.deviceModel.recentlyDeviceSn = @"";
//        weakSelf.deviceModel.recentlyDeviceType = @"";
        weakSelf.deviceModel.recentlyDevicePosition = 0;
        weakSelf.deviceModel.repairScheme = 1;
        weakSelf.deviceModel.imgUrl = @"";
        if (weakSelf.controllerPopBlock) {
            weakSelf.controllerPopBlock(weakSelf.deviceModel);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self.footerView setConfirmBlock:^{
        
        [weakSelf.view endEditing:YES];
        if (self.deviceModel.repairScheme != 1) {
            if (self.deviceModel.recentlyDevicePosition.length <=0 ) {
                return BYShowError(@"请输入安装位置序列号");
            }
        }else{
            if (self.deviceModel.recentlyDevicePosition.length <= 0) {
                return BYShowError(@"请输入安装位置序列号");
            }
        }
        
        if (self.deviceModel.repairScheme == 1) {
//            weakSelf.deviceModel.recentlyDeviceSn = weakSelf.deviceModel.deviceSn;
            if (weakSelf.deviceModel.deviceType == 0) {
                if ([weakSelf.deviceModel.recentlyDevicePosition integerValue] >= 17) {
                    return BYShowError(@"有线设备安装范围1～16");
                }
            }else if(weakSelf.deviceModel.deviceType == 1){
                if ([weakSelf.deviceModel.recentlyDevicePosition integerValue] < 17 || [weakSelf.deviceModel.recentlyDevicePosition integerValue] > 31) {
                    return BYShowError(@"无线设备安装范围17～31");
                }
            }else{
                if ([weakSelf.deviceModel.recentlyDevicePosition integerValue] < 17 || [weakSelf.deviceModel.recentlyDevicePosition integerValue] > 31) {
                    return BYShowError(@"其他设备安装范围17～31");
                }
            }
        }else{
            
            if (weakSelf.deviceModel.recentlyDeviceSn.length <= 0) {
                return BYShowError(@"请输入新设备设备号");
            }
            
            if (weakSelf.deviceModel.recentlyDeviceType == 0) {
                if ([weakSelf.deviceModel.recentlyDevicePosition integerValue] >= 17) {
                    return BYShowError(@"有线设备安装范围1～16");
                }
            }else if (weakSelf.deviceModel.recentlyDeviceType == 1){
                if ([weakSelf.deviceModel.recentlyDevicePosition integerValue] < 17 || [weakSelf.deviceModel.recentlyDevicePosition integerValue] > 31) {
                    return BYShowError(@"无线设备安装范围17～31");
                }
            }else{
                if ([weakSelf.deviceModel.recentlyDevicePosition integerValue] < 17 || [weakSelf.deviceModel.recentlyDevicePosition integerValue] > 31) {
                    return BYShowError(@"其他设备安装范围17～31");
                }
            }
        }
        
        if (self.deviceModel.imgUrl.length <= 0) {
            return BYShowError(@"请上传安装位置图片");
        }
        
        if (self.deviceModel.repairScheme != 1) {
            if (weakSelf.deviceModel.photoArr.count <= 0) {
                return BYShowError(@"请至少上传一张检修图片");
            }
        }
        
        if (self.deviceModel.serviceReson == 0) {
            return BYShowError(@"请选择检修原因");
        }
        
        weakSelf.deviceModel.repaired = YES;
        NSString *deviceVinImg = @"";
        for (BYPhotoModel *photoModel in weakSelf.deviceModel.photoArr) {
            if (deviceVinImg.length <=0) {
                deviceVinImg = photoModel.imageAddress;
            }else{
                deviceVinImg = [NSString stringWithFormat:@"%@,%@",deviceVinImg,photoModel.imageAddress];
            }
        }
        weakSelf.deviceModel.vinDeviceImg = deviceVinImg;
        
        if (weakSelf.controllerPopBlock) {
            weakSelf.controllerPopBlock(self.deviceModel);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.view addSubview:self.footerView];
}

-(void)initDataBase{

    BYAutoDeviceRepairDeviceModel *switchModel =  [BYAutoDeviceRepairDeviceModel modelWithRepairType:BYRepairCellSwitchType reparType:self.deviceModel.repairScheme oldInstallPosition:@"" deviceSn:@"" installPosition:@"" installImgUrl:@"" repairOtherImgUrl:@"" serviceReson:0];
    switchModel.control = self.deviceModel.control;
    
    BYAutoDeviceRepairDeviceModel *checkModel =  [BYAutoDeviceRepairDeviceModel modelWithRepairType:BYRepairCellCheckInstallType reparType:0 oldInstallPosition:@"" deviceSn:@"" installPosition:@"" installImgUrl:@"" repairOtherImgUrl:@"" serviceReson:0];
    
    self.deviceSnnModel =  [BYAutoDeviceRepairDeviceModel modelWithRepairType:BYRepairCellNewSnType reparType:0 oldInstallPosition:@"" deviceSn:@"" installPosition:@"" installImgUrl:@"" repairOtherImgUrl:@"" serviceReson:0];
    self.deviceSnnModel.deviceSn = self.deviceModel.recentlyDeviceSn;
    self.deviceSnnModel.deviceModel = self.deviceModel.recentlyDeviceModel;
    self.deviceSnnModel.deviceType = self.deviceModel.recentlyDeviceType;
    
    BYAutoDeviceRepairDeviceModel *repairInfoModel =  [BYAutoDeviceRepairDeviceModel modelWithRepairType:BYRepairCellInfoType reparType:self.deviceModel.repairScheme oldInstallPosition:self.deviceModel.devicePosition deviceSn:@"" installPosition:self.deviceModel.recentlyDevicePosition installImgUrl:self.deviceModel.imgUrl repairOtherImgUrl:self.deviceModel.vinDeviceImg serviceReson:0];
    if (self.deviceModel.imgUrl.length > 0) {
        repairInfoModel.installImgModel = [BYPhotoModel createModelWith:[UIImage imageNamed:@"icon_autoService_addPhoto"] isP_HImage:NO imageAddress:self.deviceModel.imgUrl fullPath:[NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYEndpoint],self.deviceModel.imgUrl]];
    }else{
        repairInfoModel.installImgModel = [BYPhotoModel createModelWith:[UIImage imageNamed:@"icon_autoService_addPhoto"] isP_HImage:YES imageAddress:@"" fullPath:@""];
    }
    
    if (self.deviceModel.vinDeviceImg.length > 0) {
        
        
        NSArray *imgAddressArr = [self.deviceModel.vinDeviceImg componentsSeparatedByString:@","];
        
        for (NSString *imgAddress in imgAddressArr) {
            BYPhotoModel *photoModel = [BYPhotoModel createModelWith:[UIImage imageNamed:@"icon_autoService_addPhoto"] isP_HImage:NO imageAddress:imgAddress fullPath:[NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYEndpoint],imgAddress]];
            [repairInfoModel.images addObject:photoModel];
            [repairInfoModel.photoArr addObject:photoModel];
        }
        BYPhotoModel *phModel = [BYPhotoModel createModelWith:[UIImage imageNamed:@"icon_autoService_addPhoto"] isP_HImage:YES imageAddress:@"" fullPath:@""];
        [repairInfoModel.images addObject:phModel];
        
    }else{
        BYPhotoModel *phModel = [BYPhotoModel createModelWith:[UIImage imageNamed:@"icon_autoService_addPhoto"] isP_HImage:YES imageAddress:@"" fullPath:@""];
        [repairInfoModel.images addObject:phModel];
    }
    
    
    BYAutoDeviceRepairDeviceModel *repairReasonModel =  [BYAutoDeviceRepairDeviceModel modelWithRepairType:BYRepairCellReasonType reparType:0 oldInstallPosition:@"" deviceSn:@"" installPosition:@"" installImgUrl:@"" repairOtherImgUrl:@"" serviceReson:self.deviceModel.serviceReson];
    
    [self.dataSource addObject:switchModel];
    [self.dataSource addObject:checkModel];
    if (self.deviceModel.repairScheme != 1) {
        [self.dataSource addObject:self.deviceSnnModel];
    }
    //    [self.dataSource addObject:self.deviceSnnModel];
    [self.dataSource addObject:repairInfoModel];
    [self.dataSource addObject:repairReasonModel];

}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYAutoDeviceRepairDeviceModel *model = self.dataSource[indexPath.row];
    
    if (model.repairCellType == BYRepairCellSwitchType) {
        BYAutoServiceDeviceRepairSwitchCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceDeviceRepairSwitchCell" forIndexPath:indexPath];
        switchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        switchCell.model = model;
        
        [switchCell setRepairDeviceClickBlock:^(NSInteger tag) {
            if (model.control == 1) {
                BYShowError(@"不可修改检修方式");
                [self.tableView reloadData];
            }else{
                model.repairType = tag;
                self.deviceModel.repairScheme = tag;
                //tag 1仅检修 2更换设备 3重新安装
                if (tag == 1) {
                    if ([self.dataSource containsObject:self.deviceSnnModel]) {
                        [self.dataSource removeObject:self.deviceSnnModel];
                        [self.tableView reloadData];
                    }
                    
                }else{
                    if (![self.dataSource containsObject:self.deviceSnnModel]) {
                        [self.dataSource insertObject:self.deviceSnnModel atIndex:2];
                        [self.tableView reloadData];
                    }
                }
            }
            
        }];
        
        return switchCell;
    }
    else if (model.repairCellType == BYRepairCellCheckInstallType || model.repairCellType == BYRepairCellNewSnType){
        BYAutoServiceDeviceRepairCheckCell *checkCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceDeviceRepairCheckCell" forIndexPath:indexPath];
        checkCell.selectionStyle = UITableViewCellSelectionStyleNone;
        checkCell.model = model;
        
        return checkCell;
    }
    else if(model.repairCellType == BYRepairCellInfoType){
        BYAutoServiceDeviceRepairInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceDeviceRepairInfoCell" forIndexPath:indexPath];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        model.repairType = self.deviceModel.repairScheme;
        infoCell.model = model;
        infoCell.repairScheme = self.deviceModel.repairScheme;
        BYWeakSelf;
        __weak typeof(infoCell) weakCell = infoCell;
        //查看示意图
        [infoCell setCheckInstallConfirmBlock:^{
            
            NSMutableDictionary *paraDic = [NSMutableDictionary dictionary];
            
            if (self.deviceModel.repairScheme == 1) {
                [paraDic setValue:@(self.deviceModel.deviceType == 0 ? 100 : 101) forKey:@"code"];
            }else{
                if (self.deviceModel.recentlyDeviceSn.length <= 0 ) {
                    return BYShowError(@"请先添加新设备");
                }else{
                    [paraDic setValue:@(self.deviceModel.recentlyDeviceType == 0 ? 100 : 101) forKey:@"code"];
                }
            }
            
            
            
            
            [BYAutoServiceHttpTool POSTQuickInstallConfirmWithParams:paraDic success:^(id data) {
                
                self.deviceModel.installConfirm = data;
                //大图浏览
                dispatch_async(dispatch_get_main_queue(), ^{
                    SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
                    photoBrowser.delegate = self;
                    photoBrowser.currentImageIndex = 0;
                    photoBrowser.imageCount = 1;
                    photoBrowser.sourceImagesContainerView = weakCell.checkInstallButton;
                    //        self.selectImgIndex = tap.view.tag - 150;
                    self.installConfirm = YES;
                    [photoBrowser show];
                });
            } failure:^(NSError *error) {
                
            }];
        }];
        
        [infoCell setImageViewTapBlock:^(NSInteger tag) {
            [weakSelf operationForImageWith:tag DeviceModel:model installImg:NO];
        }];
        
        [infoCell setDeleteImageBlock:^(NSInteger tag) {
            
            BYPhotoModel * photoModel = model.images[tag];
            [model.photoArr removeObject:photoModel];
            [self.deviceModel.photoArr removeObject:photoModel];
            [model.images removeObject:photoModel];
            [self.tableView reloadData];
            
        }];
        
        [infoCell setInstallImgViewTapBlock:^{
            [weakSelf operationForImageWith:0 DeviceModel:model installImg:YES];
        }];
        
        [infoCell setInstallImgViewDeleteBlock:^{
            BYPhotoModel *photoModel = model.installImgModel;
            photoModel.isP_HImage = YES;
            photoModel.imageAddress = @"";
            photoModel.fullPath = @"";
            self.deviceModel.imgUrl = @"";
            [self.tableView reloadData];
        }];
        
        [infoCell setRecentDevicePositionInputBlock:^(NSString *recentDevicePosition) {
            self.deviceModel.recentlyDevicePosition = recentDevicePosition;
            model.installPosition = recentDevicePosition;
        }];
        
        return infoCell;
    }
    else{
        BYAutoServiceDeviceRepairReasonCell *reasonCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceDeviceRepairReasonCell" forIndexPath:indexPath];
        
        reasonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        reasonCell.model = model;
        [reasonCell setRepairReasonTypeBlock:^{
           [self alertRepairReason:model];
        }];
        
        return reasonCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BYAutoDeviceRepairDeviceModel *model = self.dataSource[indexPath.row];
    if (model.repairCellType == BYRepairCellCheckInstallType) {
        
        BYAutoServiceDeviceRepairCheckCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.deviceModel.deviceSn forKey:@"deviceSn"];
        [BYAutoServiceHttpTool POSTQuickShowInstallImgWithParams:params success:^(id data) {
            self.deviceModel.installPosition = data;
            if (self.deviceModel.installPosition.length == 0) {
                BYShowError(@"没有旧的安装位置");
            }else{
                NSArray *imgArr = [self.deviceModel.installPosition componentsSeparatedByString:@","];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    for (NSString *imgStr in imgArr) {
                        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
                        [cell.contentView addSubview:imgView];
                    }
                    SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
                    photoBrowser.delegate = self;
                    photoBrowser.currentImageIndex = 0;
                    photoBrowser.imageCount = imgArr.count;
                    photoBrowser.sourceImagesContainerView = cell.contentView;
                    //        self.selectImgIndex = tap.view.tag - 150;
                    self.installConfirm = NO;
                    [photoBrowser show];
                });
            }
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    else if ( model.repairCellType == BYRepairCellNewSnType){
        
        BYAutoRepairDeviceSearchViewController *deviceSearchVC = [BYAutoRepairDeviceSearchViewController new];
        deviceSearchVC.carModel = self.carModel;
        __block BYAutoServiceDeviceModel *blockModel = self.deviceModel;
        __block BYAutoDeviceRepairDeviceModel *blockDevModel = model;
        [deviceSearchVC setDeviceSnSearchBlock:^(BYAutoServiceDeviceModel *deviceModel) {
            blockModel.recentlyDeviceSn = deviceModel.deviceSn;
            blockModel.recentlyDeviceType = deviceModel.deviceType;
            blockModel.recentlyDeviceModel = deviceModel.deviceModel;
            blockModel.recentlyAlias = deviceModel.alias;
            blockModel.alias = deviceModel.alias;
            blockDevModel.deviceSn = deviceModel.deviceSn;
            blockDevModel.deviceModel = deviceModel.deviceModel;
            blockDevModel.deviceType = deviceModel.deviceType;
            blockDevModel.alias = deviceModel.alias;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
        
        [self.navigationController pushViewController:deviceSearchVC animated:YES];
        
    }
    else if (model.repairCellType == BYRepairCellReasonType){
        
    }
    else{
        
        
    }
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYAutoDeviceRepairDeviceModel *model = self.dataSource[indexPath.row];
    
    if (model.repairCellType == BYRepairCellSwitchType) {
        
        return 55.0f;
    }
    else if (model.repairCellType == BYRepairCellCheckInstallType || model.repairCellType == BYRepairCellNewSnType){
        
        return 50.0f;
    }else if (model.repairCellType == BYRepairCellReasonType){
        return 50.0f;
    }
    else{

        NSInteger remindRow = model.images.count % 3 == 0 ? 0 : 1;
        NSInteger dividerRow = model.images.count / 3;
        
        CGFloat width = (BYSCREEN_W - 2 * 10 - 12 * 2) / 3;
        
        return 160 + width + (width + 30) * (remindRow + dividerRow);
    }
}

-(void)alertRepairReason:(BYAutoDeviceRepairDeviceModel *)model{
    
    UIAlertController *alertVC = [BYObjectTool alertRepairReasonWith:^{
        model.serviceReson = 1;
        self.deviceModel.serviceReson = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } noLocate:^{
        model.serviceReson = 2;
        self.deviceModel.serviceReson = 2;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } noElectricity:^{
        model.serviceReson = 3;
        self.deviceModel.serviceReson = 3;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } other:^{
        model.serviceReson = 4;
        self.deviceModel.serviceReson = 4;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
    if ([BYObjectTool getIsIpad]){
        
        alertVC.popoverPresentationController.sourceView = self.view;
        alertVC.popoverPresentationController.sourceRect =  CGRectMake(100, 100, 1, 1);
    }
    [self presentViewController:alertVC animated:YES completion:nil];
    
}

-(void)operationForImageWith:(NSInteger)tag DeviceModel:(BYAutoDeviceRepairDeviceModel *)deviceModel installImg:(BOOL)installImg{
    
    _selectImageIndex = tag;
    
    if (installImg) {
//        BYPhotoModel * model = deviceModel.installImgModel;
        [self aleShowViewWithDeviceModel:deviceModel footerViewImgTag:tag installImg:YES];
    }else{
        BYPhotoModel * model = deviceModel.images[tag];
        if (tag < 1 && model.isP_HImage) {//说明是第一并且是占位图
            
            [self aleShowViewWithDeviceModel:deviceModel footerViewImgTag:tag installImg:NO];//如果是上传图片按钮就点击跳转到选择图片
            //        return [BYProgressHUD by_showErrorWithStatus:@"点击+号上传图片"];
            
        }
        else if (tag >= 1 && tag <= 5 && model.isP_HImage){
            [self aleShowViewWithDeviceModel:deviceModel footerViewImgTag:tag installImg:NO];//如果是上传图片按钮就点击跳转到选择图片
        }
        else{
            BYShowError(@"最多只能上传6张图片");
        }
    }
}



#pragma mark - === 提示框 ===
- (void)aleShowViewWithDeviceModel:(BYAutoDeviceRepairDeviceModel *)deviceModel footerViewImgTag:(NSInteger)tag installImg:(BOOL)installImg
{
    _installImg = installImg;
    self.deviceRepairModel = deviceModel;
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
        
        
        //打开相机
//        [self.pickPhoto ShowTakePhotoWithController:[UIApplication sharedApplication].keyWindow.rootViewController andWithBlock:^(NSObject *Data) {
//
//            if ([Data isKindOfClass:[UIImage class]])
//            {
//                //                if (deviceModel) {
//
//                BYWeakSelf;
//                [BYSendWorkHttpTool POSTOssSignParams:nil success:^(id data) {
//                    BYLog(@"%@",data);
//                    [BYSaveTool setValue:data[@"accessId"] forKey:BYAccessId];
//                    [BYSaveTool setValue:data[@"bucket"] forKey:BYbucket];
//                    [BYSaveTool setValue:data[@"endpoint"] forKey:BYEndpoint];
//                    [BYSaveTool setValue:data[@"signature"] forKey:BYSignature];
//
//                    [GDObjectUploadManager uploadImageWithImgType:GDUploadObjectTypeUserStudent image:(UIImage *)Data compressionMode:GDUploadImageCompressionModeDefault uploadProgress:^(CGFloat progress, NSUInteger bytesSent, NSUInteger totalBytesSent, NSUInteger totalBytesExpectedToSend) {
//                        [BYProgressHUD by_showBgViewWithStatus:@"图片上传中..."];
//                    } completionHandler:^(NSError *error, NSString *fileName, NSUInteger totalBytesExpectedToSend) {
//                        [BYProgressHUD dismiss];
//                        BYLog(@"headImg fileName = %@", fileName);
//
//                        if (!error) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//
//                                UIImage *seletImg = (UIImage *)Data;
//                                if (installImg) {
//                                    BYPhotoModel * model = deviceModel.installImgModel;
//                                    model.isP_HImage = NO;
//                                    model.imageAddress = fileName;
//                                    model.fullPath = [NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYEndpoint],fileName];
//                                    weakSelf.deviceModel.imgUrl = fileName;
//                                }else{
//                                    BYPhotoModel * model = [BYPhotoModel createModelWith:seletImg isP_HImage:NO imageAddress:fileName fullPath:[NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYEndpoint],fileName]];
//                                    [deviceModel.images insertObject:model atIndex:_selectImageIndex];
//                                    [deviceModel.photoArr addObject:model];
//                                    [weakSelf.deviceModel.photoArr addObject:model];
//                                }
//
//                                //                                dispatch_async(dispatch_get_main_queue(), ^{
//                                [self.tableView reloadData];
//                                //                                });
//                            });
//                        }else{
//                            BYShowError(@"上传图片失败");
//                        }
//                    }];
//
//                } failure:^(NSError *error) {
//
//                }];
//                //                }
//            }
//        }];
    }];
    //相册
    UIAlertAction * act3 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
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
        //打开相册
//        [self.pickPhoto SHowLocalPhotoWithController:[UIApplication sharedApplication].keyWindow.rootViewController andWithBlock:^(NSObject *Data) {
//            if ([Data isKindOfClass:[UIImage class]])
//            {
//                //                if (deviceModel) {
//                BYWeakSelf;
//                [BYSendWorkHttpTool POSTOssSignParams:nil success:^(id data) {
//                    BYLog(@"%@",data);
//                    [BYSaveTool setValue:data[@"accessId"] forKey:BYAccessId];
//                    [BYSaveTool setValue:data[@"bucket"] forKey:BYbucket];
//                    [BYSaveTool setValue:data[@"endpoint"] forKey:BYEndpoint];
//                    [BYSaveTool setValue:data[@"signature"] forKey:BYSignature];
//
//                    [GDObjectUploadManager uploadImageWithImgType:GDUploadObjectTypeUserStudent image:(UIImage *)Data compressionMode:GDUploadImageCompressionModeDefault uploadProgress:^(CGFloat progress, NSUInteger bytesSent, NSUInteger totalBytesSent, NSUInteger totalBytesExpectedToSend) {
//                        [BYProgressHUD by_showBgViewWithStatus:@"图片上传中..."];
//                    } completionHandler:^(NSError *error, NSString *fileName, NSUInteger totalBytesExpectedToSend) {
//                        [BYProgressHUD dismiss];
//                        BYLog(@"headImg fileName = %@", fileName);
//
//                        if (!error) {
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                UIImage *seletImg = (UIImage *)Data;
//
//                                if (installImg) {
//                                    BYPhotoModel * model = deviceModel.installImgModel;
//                                    model.isP_HImage = NO;
//                                    model.imageAddress = fileName;
//                                    model.fullPath = [NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYEndpoint],fileName];
//                                    weakSelf.deviceModel.imgUrl = fileName;
//                                }else{
//                                    BYPhotoModel * model = [BYPhotoModel createModelWith:seletImg isP_HImage:NO imageAddress:fileName fullPath:[NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYEndpoint],fileName]];
//                                    [deviceModel.images insertObject:model atIndex:_selectImageIndex];
//                                    [deviceModel.photoArr addObject:model];
//                                    [weakSelf.deviceModel.photoArr addObject:model];
//                                }
//                                //                                dispatch_async(dispatch_get_main_queue(), ^{
//                                [weakSelf.tableView reloadData];
//                                //                                });
//                            });
//                        }else{
//                            BYShowError(@"上传图片失败");
//                        }
//                    }];
//
//                } failure:^(NSError *error) {
//
//                }];
//                //                }
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
                    
                    UIImage *seletImg = (UIImage *)selectImage;
                    if (_installImg) {
                        BYPhotoModel * model = self.deviceRepairModel.installImgModel;
                        model.isP_HImage = NO;
                        model.imageAddress = fileName;
                        model.fullPath = [NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYEndpoint],fileName];
                        weakSelf.deviceModel.imgUrl = fileName;
                    }else{
                        BYPhotoModel * model = [BYPhotoModel createModelWith:seletImg isP_HImage:NO imageAddress:fileName fullPath:[NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYEndpoint],fileName]];
                        [self.deviceRepairModel.images insertObject:model atIndex:_selectImageIndex];
                        [self.deviceRepairModel.photoArr addObject:model];
                        [weakSelf.deviceModel.photoArr addObject:model];
                    }
                    
                    //                                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    //                                });
                });
            }else{
                BYShowError(@"上传图片失败");
            }
        }];
        
    } failure:^(NSError *error) {
        
    }];

    
    
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    
    if (self.installConfirm) {

        return [NSURL URLWithString:self.deviceModel.installConfirm];
    }else{
        NSArray *imgArr = [self.deviceModel.installPosition componentsSeparatedByString:@","];
        
        return [NSURL URLWithString:imgArr[index]];
    }
    
}


#pragma mark --LAZY

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight - 120) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorHexFromRGB(0xececec);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        BYRegisterCell(BYAutoServiceDeviceRepairSwitchCell);
        BYRegisterCell(BYAutoServiceDeviceRepairInfoCell);
        BYRegisterCell(BYAutoServiceDeviceRepairCheckCell);
        BYRegisterCell(BYAutoServiceDeviceRepairReasonCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(SXPickPhoto *)pickPhoto
{
    if (!_pickPhoto) {
        _pickPhoto = [[SXPickPhoto alloc] init];
    }
    return _pickPhoto;
}



@end
