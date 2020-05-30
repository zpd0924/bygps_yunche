//
//  BYMyEvaluationCommitViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyEvaluationCommitViewController.h"
#import "BYMyEvaluationHeadView.h"
#import "BYMyCertifyFootView.h"
#import "BYInstallMarkCell.h"
#import "BYImageCommitViewCell.h"
#import "BYPhotoModel.h"
#import "SDPhotoBrowser.h"
#import "UIImage+FixOrientation.h"
#import "EasyNavigation.h"
#import "BYSendOrderResultViewController.h"
#import "BYMyEvaluationViewController.h"
#import "BYMyWorkOrderController.h"
#import "GDOSSServiceManager.h"
#import "GDObjectUploadManager.h"

//BYEvaluationPhotoModel
@interface BYMyEvaluationCommitViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDPhotoBrowserDelegate>

@property (nonatomic,strong) BYMyEvaluationHeadView *headView;
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray * images;
@property (nonatomic,strong) NSMutableArray *photoArr;
@property (strong, nonatomic) UIView *imageBgView;
@property(nonatomic,assign) NSInteger selectImageIndex;
///参数
@property (nonatomic,strong) NSString *commentContent;//评论内容
@property (nonatomic,strong) NSString *commentImg;//评论图片 逗号隔开
@property (nonatomic,assign) NSInteger isAnonymous;//是否匿名
@property (nonatomic,assign) NSInteger serviceScore;//服务评分
@property (nonatomic,assign) NSInteger efficiencyScore;//效率评分
@end

@implementation BYMyEvaluationCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)initBase{
    
    self.view.backgroundColor = BYBigSpaceColor;
    
    [self.navigationView setTitle:@"技师评价"];
    self.view.backgroundColor = BYBigSpaceColor;
//    self.navigationView.titleLabel.textColor = [UIColor whiteColor];
      BYWeakSelf;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView removeAllLeftButton];
//
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//    });
    
     [self.images addObject:[BYPhotoModel createModelWith:[UIImage imageNamed:@"btn_up_photo.png"] isP_HImage:YES imageAddress:@"" fullPath:@""]];
    [self.view addSubview:self.tableView];
    BYMyCertifyFootView *footView = [BYMyCertifyFootView by_viewFromXib];
    footView.nextStepBlock = ^{
       
        [weakSelf.view endEditing:YES];
        [weakSelf evaluateData];
        
      
    };
    footView.layer.cornerRadius = 5;
    footView.layer.masksToBounds = YES;
    footView.btnTitle = @"提交评价";
    footView.backgroundColor = BYBigSpaceColor;
    self.tableView.tableFooterView = footView;
    BYMyEvaluationHeadView *headView = [BYMyEvaluationHeadView by_viewFromXib];
    headView.serveMarkBlock = ^(NSInteger countStar) {
        weakSelf.serviceScore = countStar;
    };
    headView.efficiencyBlock = ^(NSInteger countStar) {
        weakSelf.efficiencyScore = countStar;
    };
    headView.isCommitEvaluation = YES;
    self.tableView.tableHeaderView = headView;
    weakSelf.serviceScore = 5;
    weakSelf.efficiencyScore = 5;
}

#pragma mark -- 评价
- (void)evaluateData{
    
    BYWeakSelf;
    self.commentImg = nil;
    for (BYPhotoModel *model in self.images) {
        if (model.imageAddress.length == 0)
            break;
        if(self.commentImg.length == 0){
            self.commentImg = model.imageAddress;
        }else{
            self.commentImg = [NSString stringWithFormat:@"%@,%@",self.commentImg,model.imageAddress];
        }
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"technicianId"] = @(_technicianId);
    dict[@"serviceScore"] = @(self.serviceScore);
    dict[@"efficiencyScore"] = @(self.efficiencyScore);
    if (self.commentContent.length != 0)
        dict[@"commentContent"] = self.commentContent;
   
    dict[@"isAnonymous"] = @(self.isAnonymous);
    if (self.commentImg.length)
    dict[@"commentImg"] = self.commentImg;
    dict[@"commentUserName"] = [BYSaveTool objectForKey:nickName];
    dict[@"orderNo"] = _orderNo;
    [BYSendWorkHttpTool POSTevaluateParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYSendOrderResultViewController *vc = [[BYSendOrderResultViewController alloc] init];
            vc.titleStr = @"技师评价";
            vc.resultType = BYEvaluationSucessType;
            vc.leftBtnBlock = ^{
                BYMyEvaluationViewController *vc = [[BYMyEvaluationViewController alloc] init];
                vc.technicianId = weakSelf.technicianId;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            vc.rightBtnBlock = ^{
                for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
                    
                    if ([controller isKindOfClass:[BYMyWorkOrderController class]]) {
                        
                        BYMyWorkOrderController *vc = (BYMyWorkOrderController *)controller;
                        
                        [weakSelf.navigationController popToViewController:vc animated:YES];
                        
                    }
                    
                }
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        });
       
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -- tableview 数据源 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    if (indexPath.row == 0) {
        BYInstallMarkCell *markCell = [tableView dequeueReusableCellWithIdentifier:@"BYInstallMarkCell" forIndexPath:indexPath];
        markCell.textView.backgroundColor = WHITE;
        markCell.titleLabel.text = @"";
        markCell.topHCons.constant = -10;
        
        [markCell setDidEndInputBlock:^(NSString *input) {
            weakSelf.commentContent = input;
        }];
        return markCell;
    }else{
        
        BYImageCommitViewCell *imgCell = [tableView dequeueReusableCellWithIdentifier:@"BYImageCommitViewCell" forIndexPath:indexPath];
        imgCell.titleLabel.text = @"(最多可上传6张)";
        imgCell.titleLabel.hidden = NO;
        imgCell.selectionStyle = UITableViewCellSelectionStyleNone;;
        imgCell.images = self.images;
        self.imageBgView = imgCell.imageBgView;
        [imgCell setImageViewTapBlock:^(NSInteger tag) {
            
            [self operationForImageWith:tag];
        }];
        
        [imgCell setDeleteImageBlock:^(NSInteger tag) {
            BYPhotoModel * model = self.images[tag];
            //            if (tag == 0) {
            //                model.image = [UIImage imageNamed:@"btn_upload_photos"] ;
            //                model.isP_HImage = YES;
            //            }else{
            [self.images removeObject:model];
            //            }
            [self.photoArr removeObject:model];
            
            [self.tableView reloadData];
        }];
        imgCell.isNoNameBlock = ^(NSInteger index) {
            weakSelf.isAnonymous = index;
        };
        return imgCell;
    }
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 150.f;
    }else{
        NSInteger remindRow = self.images.count % 3 == 0 ? 0 : 1;
        NSInteger dividerRow = self.images.count / 3;
        
        CGFloat width = (BYSCREEN_W - 4 * 10) / 3;
        
        return 15 + BYS_W_H(40) + (width + 30) * (remindRow + dividerRow);
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
}

-(void)operationForImageWith:(NSInteger)tag{
    
    _selectImageIndex = tag;
    BYPhotoModel * model = self.images[tag];
    
    if (tag >= 0 && tag < 6 && model.isP_HImage){
        [self chooseImage];//如果是上传图片按钮就点击跳转到选择图片
    }else if (tag == 6 && model.isP_HImage){
        
        BYPhotoModel * model1 = self.images[0];
        BYPhotoModel * model2 = self.images[1];
        if (model1.isP_HImage || model2.isP_HImage) {
            
            [self chooseImage];//如果是上传图片按钮就点击跳转到选择图片
        }else{
            
            [BYProgressHUD by_showErrorWithStatus:@"最多只能上传6张图片"];
        }
    }else{
        //大图浏览
        SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = tag;
        photoBrowser.imageCount = self.images.count - 1;
        photoBrowser.sourceImagesContainerView = self.imageBgView;
        
        [photoBrowser show];
    }
}

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    
    BYPhotoModel * model = self.images[index];
    return model.image;
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    BYPhotoModel * model = self.images[index];
    return [NSURL URLWithString:[BYObjectTool imageStr:model.imageAddress]];
}

-(void)chooseImage{
    
    [self.view endEditing:YES];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    if ([BYObjectTool getIsIpad]){
        
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
    }
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
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
        
    }];
    
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
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
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [alert addAction:cameraAction];
    [alert addAction:photoAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}
#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    if (info[UIImagePickerControllerOriginalImage] == nil) {
        return [BYProgressHUD by_showErrorWithStatus:@"选择照片错误"];
    }
    
    UIImage * selectImage = info[UIImagePickerControllerOriginalImage];
    selectImage = [selectImage fixOrientation];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [[BYNetworkHelper sharedInstance] POSTUploadsingleImageUrl:uploadImageUrl params:nil image:selectImage success:^(id data) {
//        BYLog(@"%@",data);
//        BYPhotoModel * model = [BYPhotoModel createModelWith:selectImage isP_HImage:NO imageAddress:data[@"path"] fullPath:data[@"fullpath"]];
//
//        BYPhotoModel * firstModel = self.images[0];
//        //        BYPhotoModel * secondModel = self.images[1];
//
//        if (firstModel.isP_HImage) {//选中图片注意先将占位图片替换
//            //            [self.images removeObjectAtIndex:0];
//            [self.images insertObject:model atIndex:_selectImageIndex];
//        }else {
//            [self.images insertObject:model atIndex:_selectImageIndex];
//        }
//
//        [self.photoArr addObject:model];
//        [self.tableView reloadData];
//    }];
    
    BYWeakSelf;
    [BYSendWorkHttpTool POSTOssSignParams:nil success:^(id data) {
        BYLog(@"%@",data);
        [BYSaveTool setValue:data[@"accessId"] forKey:BYAccessId];
        [BYSaveTool setValue:data[@"bucket"] forKey:BYbucket];
        [BYSaveTool setValue:data[@"endpoint"] forKey:BYEndpoint];
        [BYSaveTool setValue:data[@"signature"] forKey:BYSignature];
        
        [weakSelf loadUpImage:selectImage];
    } failure:^(NSError *error) {
        
    }];
   
}
#pragma mark -- 上传图片
- (void)loadUpImage:(UIImage *)image{
     [BYProgressHUD by_show];
    BYWeakSelf;
    [GDObjectUploadManager uploadImageWithImgType:GDUploadObjectTypeUserStudent image:image compressionMode:GDUploadImageCompressionModeDefault uploadProgress:^(CGFloat progress, NSUInteger bytesSent, NSUInteger totalBytesSent, NSUInteger totalBytesExpectedToSend) {
        
    } completionHandler:^(NSError *error, NSString *fileName, NSUInteger totalBytesExpectedToSend) {
        BYLog(@"fileName = %@",fileName);
         [BYProgressHUD dismiss];
        BYPhotoModel * model = [BYPhotoModel createModelWith:image isP_HImage:NO imageAddress: fileName fullPath:@"123"];
        
        BYPhotoModel * firstModel = self.images[0];
       
        
        if (firstModel.isP_HImage) {//选中图片注意先将占位图片替换
            [weakSelf.images insertObject:model atIndex:_selectImageIndex];
        }else {
            [weakSelf.images insertObject:model atIndex:_selectImageIndex];
        }
        
        [weakSelf.photoArr addObject:model];
        [weakSelf.tableView reloadData];
    }];
}


#pragma mark --LAZY

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = BYBigSpaceColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        BYRegisterCell(BYInstallMarkCell);
        BYRegisterCell(BYImageCommitViewCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

-(NSMutableArray *)images{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}
-(UIView *)imageBgView{
    if (_imageBgView == nil) {
        _imageBgView = [[UIView alloc] init];
    }
    return _imageBgView;
}


-(NSMutableArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}
@end
