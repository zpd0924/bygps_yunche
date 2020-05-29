//
//  BYAutoServiceDeviceRemoveController.m
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceDeviceRemoveController.h"
#import "BYAutoServiceDeviceRemoveCell.h"
#import "BYAutoServiceDeviceRemoveInfoCell.h"
#import "BYAutoServiceDeviceRemoveFooterView.h"
#import "EasyNavigation.h"
#import "BYAutoServiceDeviceModel.h"
#import "BYPhotoModel.h"
//#import "BYSendWorkHttpTool.h"
#import "BYAutoServiceHttpTool.h"

#import "SXPickPhoto.h"
#import "GDObjectUploadManager.h"
#import "SDPhotoBrowser.h"
#import "UIImage+FixOrientation.h"


@interface BYAutoServiceDeviceRemoveController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,SDPhotoBrowserDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BYAutoServiceDeviceRemoveFooterView *footerView;

@property (nonatomic,strong) SXPickPhoto *pickPhoto;

@property(nonatomic,assign) NSInteger selectImageIndex;

@end

@implementation BYAutoServiceDeviceRemoveController

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
    [self.footerView setConfirmBlock:^{
        
        if (self.deviceModel.isRemoved == 0) {
            return BYShowError(@"请选择拆机情况");
        }
        
        weakSelf.deviceModel.repaired = YES;
        NSString *deviceVinImg;
        for (BYPhotoModel *photoModel in weakSelf.deviceModel.photoArr) {
            if (deviceVinImg.length <=0) {
                deviceVinImg = photoModel.imageAddress;
            }else{
                deviceVinImg = [NSString stringWithFormat:@"%@,%@",deviceVinImg,photoModel.imageAddress];
            }
        }
        weakSelf.deviceModel.deviceVinImg = deviceVinImg;
        
        if (weakSelf.controllerPopBlock) {
            weakSelf.controllerPopBlock(weakSelf.deviceModel);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    
    
    [self.footerView setCancleBlock:^{
        
        weakSelf.deviceModel.deviceVinImg = @"";
        weakSelf.deviceModel.images = nil;
        weakSelf.deviceModel.isRemoved = 0;
        weakSelf.deviceModel.repaired = NO;
        if (weakSelf.controllerPopBlock) {
            weakSelf.controllerPopBlock(weakSelf.deviceModel);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
    
    [self.view addSubview:self.footerView];
    
    
}

-(void)initDataBase{
    if (self.deviceModel.images.count > 0) {

    }else{
        BYPhotoModel *photoModel = [BYPhotoModel createModelWith:[UIImage imageNamed:@"icon_autoService_addPhoto"] isP_HImage:YES imageAddress:@"" fullPath:@""];
        [self.deviceModel.images addObject:photoModel];
    }
    
//    self.deviceModel.isRemoved = self.deviceModel.isRemoved == 0 ? 1 : self.deviceModel.isRemoved;
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        BYAutoServiceDeviceRemoveCell *checkInstallCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceDeviceRemoveCell" forIndexPath:indexPath];
        
        checkInstallCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        
        return checkInstallCell;
    }
    else{
        BYAutoServiceDeviceRemoveInfoCell *removeInfoCell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceDeviceRemoveInfoCell" forIndexPath:indexPath];
        removeInfoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        removeInfoCell.deviceModel = self.deviceModel;
        
        
        [removeInfoCell setSelectRemoveTypeBlock:^() {
//            self.deviceModel.isRemoved = index;
            
            [self aletRemoveConclutionEithModel:self.deviceModel];
            
        }];
        
        [removeInfoCell setImageViewTapBlock:^(NSInteger tag) {
            [self operationForImageWith:tag];
        }];
        
        [removeInfoCell setDeleteImageBlock:^(NSInteger tag) {
            BYPhotoModel * model = self.deviceModel.images[tag];
            [self.deviceModel.photoArr removeObject:model];
            [self.deviceModel.images removeObject:model];
            [self.tableView reloadData];
            
        }];
        
        
        return removeInfoCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        BYAutoServiceDeviceRemoveCell *checkInstallCell = [tableView cellForRowAtIndexPath:indexPath];
        ///查看旧的安装位置
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
                        [checkInstallCell.contentView addSubview:imgView];
                    }
                    SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
                    photoBrowser.delegate = self;
                    photoBrowser.currentImageIndex = 0;
                    photoBrowser.imageCount = imgArr.count;
                    photoBrowser.sourceImagesContainerView = checkInstallCell.contentView;
                    //        self.selectImgIndex = tap.view.tag - 150;
                    //                self.installConfirm = NO;
                    [photoBrowser show];
                });
            }
        } failure:^(NSError *error) {
            
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 46;
    }else{
        NSInteger remindRow = self.deviceModel.images.count % 3 == 0 ? 0 : 1;
        NSInteger dividerRow = self.deviceModel.images.count / 3;
        
        CGFloat width = (BYSCREEN_W - 2 * 10 - 12 * 2) / 3;
        return 150 + (width + 30) * (remindRow + dividerRow);
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)aletRemoveConclutionEithModel:(BYAutoServiceDeviceModel *)model{
    
    UIAlertController *alertVc = [BYObjectTool alertRemoveConclutionWith:^{
        self.deviceModel.isRemoved = 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } wrongRelated:^{
        self.deviceModel.isRemoved = 2;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } regretLoan:^{
        self.deviceModel.isRemoved = 3;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [SVProgressHUD showInfoWithStatus:@"车辆和设备强制解除关联，设备会移到当前监控组的报废组。"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        });
    }];
    
    if ([BYObjectTool getIsIpad]){
        
        alertVc.popoverPresentationController.sourceView = self.view;
        alertVc.popoverPresentationController.sourceRect =  CGRectMake(100, 100, 1, 1);
    }
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)operationForImageWith:(NSInteger)tag{
    
    _selectImageIndex = tag;
    
//    BYAutoServiceDeviceModel *deviceModel = self.repairInfoModel.technicianDeviceList[self.pagNum];
    
    BYPhotoModel * model = self.deviceModel.images[tag];
    
    if (tag < 1 && model.isP_HImage) {//说明是第一并且是占位图
        
        [self aleShowViewWithDeviceModel:self.deviceModel footerViewImgTag:tag];//如果是上传图片按钮就点击跳转到选择图片
        //        return [BYProgressHUD by_showErrorWithStatus:@"点击+号上传图片"];
        
    }else if (tag >= 1 && tag <= 5 && model.isP_HImage){
        [self aleShowViewWithDeviceModel:self.deviceModel footerViewImgTag:tag];//如果是上传图片按钮就点击跳转到选择图片
    }else if (tag > 5 && model.isP_HImage){
        
        BYPhotoModel * model1 = self.deviceModel.images[0];
        //        BYPhotoModel * model2 = deviceModel.images[1];
        if (model1.isP_HImage) {
            //
            BYShowError(@"点击上传安装位置图片");
            //            [self chooseImage];//如果是上传图片按钮就点击跳转到选择图片
        }else{
            
            BYShowError(@"最多只能上传6张图片");
        }
    }else{
        //        //大图浏览
        //        SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
        //        photoBrowser.delegate = self;
        //        photoBrowser.currentImageIndex = tag;
        //        photoBrowser.imageCount = deviceModel.images.count - 1;
        //        photoBrowser.sourceImagesContainerView = self.imageBgView;
        //
        //        [photoBrowser show];
    }
}



#pragma mark - === 提示框 ===
- (void)aleShowViewWithDeviceModel:(BYAutoServiceDeviceModel *)deviceModel footerViewImgTag:(NSInteger)tag
{
    
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
//
//                                BYPhotoModel * model = [BYPhotoModel createModelWith:seletImg isP_HImage:NO imageAddress:fileName fullPath:[NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYEndpoint],fileName]];
//                                [self.deviceModel.images insertObject:model atIndex:_selectImageIndex];
//                                [self.deviceModel.photoArr addObject:model];
////                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    [self.tableView reloadData];
////                                });
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
//        //打开相册
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
//                                BYPhotoModel * model = [BYPhotoModel createModelWith:seletImg isP_HImage:NO imageAddress:fileName fullPath:[NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYEndpoint],fileName]];
//                                [self.deviceModel.images insertObject:model atIndex:_selectImageIndex];
//                                [self.deviceModel.photoArr addObject:model];
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
                    
                    BYPhotoModel * model = [BYPhotoModel createModelWith:seletImg isP_HImage:NO imageAddress:fileName fullPath:[NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYEndpoint],fileName]];
                    [self.deviceModel.images insertObject:model atIndex:_selectImageIndex];
                    [self.deviceModel.photoArr addObject:model];
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

    NSArray *imgArr = [self.deviceModel.installPosition componentsSeparatedByString:@","];
    
    return [NSURL URLWithString:imgArr[index]];

}



#pragma mark --LAZY

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight - 120 ) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorHexFromRGB(0xececec);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        BYRegisterCell(BYAutoServiceDeviceRemoveCell);
        BYRegisterCell(BYAutoServiceDeviceRemoveInfoCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(SXPickPhoto *)pickPhoto
{
    if (!_pickPhoto) {
        _pickPhoto = [[SXPickPhoto alloc] init];
    }
    return _pickPhoto;
}



@end
