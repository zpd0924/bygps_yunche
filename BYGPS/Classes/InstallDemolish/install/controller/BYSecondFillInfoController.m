//
//  BYSecondFillInfoController.m
//  父子控制器
//
//  Created by miwer on 2016/12/23.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSecondFillInfoController.h"
#import "BYInstallHeaderView.h"
#import "BYInstallModel.h"
#import "BYInstallTextFiledCell.h"
#import "BYInstallButtonCell.h"
#import "BYColorSelectController.h"
#import "BYInstallSectionHeaderView.h"
#import "BYInstallMarkCell.h"
#import "BYImageViewCell.h"
#import "UIButton+BYFooterButton.h"
#import "BYSureInfoController.h"
#import "SDPhotoBrowser.h"
#import "BYPhotoModel.h"
#import "UIImage+BYSquareImage.h"
#import "EasyNavigation.h"
#import "BYLivePhotoHttpTool.h"

@interface BYSecondFillInfoController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,SDPhotoBrowserDelegate>

@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,strong) NSArray * colorSource;
@property(nonatomic,assign) BOOL isWireless;
@property(nonatomic,strong) NSMutableArray * images;
@property(nonatomic,assign) NSInteger selectImageIndex;
@property (nonatomic,strong) NSMutableArray *photoArr;

//图片cell的图片背景View,用于浏览大图时的动画
@property (strong, nonatomic) UIView *imageBgView;

@end

@implementation BYSecondFillInfoController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    BYStatusBarLight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
}

-(instancetype)init{

    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return [self initWithStyle:UITableViewStyleGrouped];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initBase{
    
    [self.navigationView setTitle:@"录入资料"];
//    self.navigationView.titleLabel.textColor = [UIColor whiteColor];
//    [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
    _isWireless = self.isWirless;

    self.automaticallyAdjustsScrollViewInsets = NO;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView removeAllLeftButton];
//        BYWeakSelf;
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//    });
    
    //添加headerView
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 164)];
    self.tableView.tableHeaderView = header;
    
    BYInstallHeaderView * tableHeader = [BYInstallHeaderView by_viewFromXib];
    tableHeader.frame = CGRectMake(0, 64, BYSCREEN_W, 100);
    tableHeader.stepIndex = 2;
    [header addSubview:tableHeader];
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    UIButton * footerButton = [UIButton buttonWithMargin:20 backgroundColor:BYGlobalBlueColor title:@"确认,下一步" target:self action:@selector(nextAction)];
    [footerView addSubview:footerButton];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.colorSource = @[@"黑色",@"红色",@"深灰色",@"粉红色",@"银灰色",@"紫色",@"白色",@"蓝色",@"香槟色",@"绿色",@"黄色",@"咖啡色",@"橙色",@"多彩色",@"其他"];

    if(!_isWireless){
        NSMutableArray * sectionOneArr = [NSMutableArray array];
        BYInstallModel * model1 = [BYInstallModel createModelWith:@"*ACC颜色" placeholder:@"其他" isNecessary:YES postKey:@"accColor"];
        model1.subTitle = @"其他";
        BYInstallModel * model2 = [BYInstallModel createModelWith:@"*ACC线位置" placeholder:@"无" isNecessary:YES postKey:@"accPlace"];
        model2.subTitle = @"无";
        BYInstallModel * model3 = [BYInstallModel createModelWith:@"油泵线颜色" placeholder:@"其他" isNecessary:NO postKey:@"slurryColor"];
        model3.subTitle = @"其他";
        BYInstallModel * model4 = [BYInstallModel createModelWith:@"油泵线位置" placeholder:@"无" isNecessary:NO postKey:@"slurryPlace"];
        model4.subTitle = @"无";
        BYInstallModel * model5 = [BYInstallModel createModelWith:@"*电源正极颜色" placeholder:@"其他" isNecessary:YES postKey:@"anodeColor"];
        model5.subTitle = @"其他";
        BYInstallModel * model6 = [BYInstallModel createModelWith:@"*电源正极位置" placeholder:@"无" isNecessary:YES postKey:@"anodePlace"];
        model6.subTitle = @"无";
        BYInstallModel * model7 = [BYInstallModel createModelWith:@"*电源负极颜色" placeholder:@"其他" isNecessary:YES postKey:@"cathodeColor"];
        model7.subTitle = @"其他";
        BYInstallModel * model8 = [BYInstallModel createModelWith:@"*电源负极位置" placeholder:@"无" isNecessary:YES postKey:@"cathodePlace"];
        model8.subTitle = @"无";
        
        [sectionOneArr addObject:model1];
        [sectionOneArr addObject:model2];
        [sectionOneArr addObject:model3];
        [sectionOneArr addObject:model4];
        [sectionOneArr addObject:model5];
        [sectionOneArr addObject:model6];
        [sectionOneArr addObject:model7];
        [sectionOneArr addObject:model8];
        
        [self.dataSource addObject:sectionOneArr];
    }
    
    NSMutableArray * sectionTwoArr = [NSMutableArray array];
    BYInstallModel * model11 = [BYInstallModel createModelWith:@"*安装位置" placeholder:@"请输入具体安装位置" isNecessary:YES postKey:@"placelocalIds"];
    BYInstallModel * model12 = [BYInstallModel createModelWith:@"安装备注" placeholder:@"请输入安装备注" isNecessary:NO postKey:@"remark"];
    BYInstallModel * model13 = [BYInstallModel createModelWith:@"*安装图片" placeholder:@"请添加安装图片" isNecessary:YES postKey:@"deviceCarNumImg"];

    [sectionTwoArr addObject:model11];
    [sectionTwoArr addObject:model12];
    [sectionTwoArr addObject:model13];
    [self.dataSource addObject:sectionTwoArr];
    
    //添加安装图片数组
    [self.images addObject:[BYPhotoModel createModelWith:[UIImage imageNamed:@"pic_sample1"] isP_HImage:YES imageAddress:@""]];
    [self.images addObject:[BYPhotoModel createModelWith:[UIImage imageNamed:@"pic_sample2"] isP_HImage:YES imageAddress:@""]];
    [self.images addObject:[BYPhotoModel createModelWith:[UIImage imageNamed:@"btn_upload_photos"] isP_HImage:YES imageAddress:@""]];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYInstallTextFiledCell class]) bundle:nil] forCellReuseIdentifier:@"textFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYInstallButtonCell class]) bundle:nil] forCellReuseIdentifier:@"buttonCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYInstallMarkCell class]) bundle:nil] forCellReuseIdentifier:@"markCell"];
}

-(void)chooseImage{
    
    [self.view endEditing:YES];
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"选择图片上传方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    if ([BYObjectTool getIsIpad]){
        
        alert.popoverPresentationController.sourceView = self.view;
        alert.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
    }
    UIAlertAction * photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
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
    
    UIAlertAction * cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
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
    [BYLivePhotoHttpTool POSTSingleImageWithImage:selectImage Success:^(id data) {
        BYLog(@"%@",data);
        BYPhotoModel * model = [BYPhotoModel createModelWith:selectImage isP_HImage:NO imageAddress:data[@"path"]];
        
        BYPhotoModel * firstModel = self.images[0];
        BYPhotoModel * secondModel = self.images[1];
        
        if (firstModel.isP_HImage) {//选中图片注意先将占位图片替换
            [self.images removeObjectAtIndex:0];
            [self.images insertObject:model atIndex:0];
        }else if (secondModel.isP_HImage){
            [self.images removeObjectAtIndex:1];
            [self.images insertObject:model atIndex:1];
        }else{
            [self.images insertObject:model atIndex:_selectImageIndex];
        }

        [self.photoArr addObject:model];
        [self.tableView reloadData];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }  
}

#pragma mark - <dataSource,delegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSMutableArray * tempArr = self.dataSource[section];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray * tempArr = self.dataSource[indexPath.section];
    BYInstallModel * model = tempArr[indexPath.row];
    if (!_isWireless && indexPath.section == 0 && indexPath.row % 2 == 0) {
        BYInstallButtonCell * buttonCell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell"];
        buttonCell.model = model;
        buttonCell.titleLabel_W = BYS_W_H(120);
        return buttonCell;
    }else if (!_isWireless && indexPath.section == 1 && indexPath.row == 1){
        BYInstallMarkCell * markCell = [tableView dequeueReusableCellWithIdentifier:@"markCell"];
        [markCell setDidEndInputBlock:^(NSString *input) {
            model.subTitle = input;
        }];
        return markCell;
    }else if (_isWireless && indexPath.section == 0 && indexPath.row == 1){
        BYInstallMarkCell * markCell = [tableView dequeueReusableCellWithIdentifier:@"markCell"];
        [markCell setDidEndInputBlock:^(NSString *input) {
            model.subTitle = input;
        }];
        return markCell;
    }else if (!_isWireless && indexPath.section == 1 && indexPath.row == 2){
        BYImageViewCell * imageViewCell = [BYImageViewCell by_viewFromXib];
        imageViewCell.images = self.images;
        self.imageBgView = imageViewCell.imageBgView;
        [imageViewCell setImageViewTapBlock:^(NSInteger tag) {

            [self operationForImageWith:tag];
        }];
        
        [imageViewCell setDeleteImageBlock:^(NSInteger tag) {
            BYPhotoModel * model = self.images[tag];
            if (tag == 0 || tag == 1) {
                model.image = tag == 0 ? [UIImage imageNamed:@"pic_sample1"] : [UIImage imageNamed:@"pic_sample2"];
                model.isP_HImage = YES;
            }else{
                [self.images removeObject:model];
            }
            [self.photoArr removeObject:model];
            
            [self.tableView reloadData];
        }];
        
        return imageViewCell;
    }else if (_isWireless && indexPath.section == 0 && indexPath.row == 2){
        BYImageViewCell * imageViewCell = [BYImageViewCell by_viewFromXib];
        imageViewCell.images = self.images;
        self.imageBgView = imageViewCell.imageBgView;

        [imageViewCell setImageViewTapBlock:^(NSInteger tag) {
            
            [self operationForImageWith:tag];
        }];
        
        [imageViewCell setDeleteImageBlock:^(NSInteger tag) {
            BYPhotoModel * model = self.images[tag];
            if (tag == 0 || tag == 1) {
                model.image = tag == 0 ? [UIImage imageNamed:@"pic_sample1"] : [UIImage imageNamed:@"pic_sample2"];
                model.isP_HImage = YES;
            }else{
                [self.images removeObject:model];
            }
            [self.photoArr removeObject:model];
            
            [self.tableView reloadData];
        }];
        return imageViewCell;
    }else{
    
        BYInstallTextFiledCell * textFieldCell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
        textFieldCell.titleLabel_W = BYS_W_H(120);
        if ([model.title isEqualToString:@"*安装位置"]) {
            textFieldCell.isHiddenTopLine = YES;
            textFieldCell.titleLabel_W = BYS_W_H(90);
        }
        textFieldCell.model = model;
        [textFieldCell setShouldEndInputBlock:^(NSString *input) {
            model.subTitle = input;
        }];
        return textFieldCell;
    }
}

-(void)operationForImageWith:(NSInteger)tag{
    
    _selectImageIndex = tag;
    BYPhotoModel * model = self.images[tag];
    
    if (tag < 2 && model.isP_HImage) {//说明是第一和第二张图片并且是占位图
        
        return [BYProgressHUD by_showErrorWithStatus:@"点击+号上传图片"];
    
    }else if (tag >= 2 && tag < 12 && model.isP_HImage){
        [self chooseImage];//如果是上传图片按钮就点击跳转到选择图片
    }else if (tag == 12 && model.isP_HImage){
        
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (_isWirless) {
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row % 2 == 0) {

        BYColorSelectController * colorVc = [[BYColorSelectController alloc] init];
        
        [colorVc setColorItemSelectBlock:^(NSInteger tag) {
            NSMutableArray * tempArr = self.dataSource[indexPath.section];
            BYInstallModel * model = tempArr[indexPath.row];
            model.subTitle = self.colorSource[tag];
            [self.tableView reloadData];
        }];
        
        [self.navigationController pushViewController:colorVc animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        
        BYInstallSectionHeaderView * header = [[[NSBundle mainBundle] loadNibNamed:@"BYInstallSectionHeaderView" owner:self options:nil] lastObject];
        header.title = @"安装信息填写";
//        header.isShowButton = NO;
        return header;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isWireless) {
        if (indexPath.row == 1) {
            return BYS_W_H(110);
        }else if (indexPath.row == 2){
            
            NSInteger remindRow = self.images.count % 3 == 0 ? 0 : 1;
            NSInteger dividerRow = self.images.count / 3;
            
            CGFloat width = (BYSCREEN_W - 4 * 10) / 3;
            
            return 15 + BYS_W_H(15) + (width + 30) * (remindRow + dividerRow);
        }else{
            return BYS_W_H(44);
        }
    }else{
        if (indexPath.section == 1 && indexPath.row == 1) {
            return BYS_W_H(110);
        }else if (indexPath.section == 1 && indexPath.row == 2){
            
            NSInteger remindRow = self.images.count % 3 == 0 ? 0 : 1;
            NSInteger dividerRow = self.images.count / 3;
            
            CGFloat width = (BYSCREEN_W - 4 * 10) / 3;
            
            return 15 + BYS_W_H(15) + (width + 30) * (remindRow + dividerRow);
        }else{
            return BYS_W_H(44);
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return BYS_W_H(50);
    }else{
        return 0.01;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)nextAction{
    
    [self.view endEditing:YES];

    NSMutableArray * tempArr = [NSMutableArray array];
    [tempArr addObjectsFromArray:self.dataSource.firstObject];
    if (!_isWireless) {
        [tempArr addObjectsFromArray:self.dataSource.lastObject];
    }
    
    //判断必填信息有没有填
    for (BYInstallModel * model in tempArr) {
        BYLog(@"title : %@ - subtitle : %@",model.title,model.subTitle);
        
        //先把安装图片行去掉,
        if (model.isNecessary && !model.subTitle.length && ![model.title isEqualToString:@"*安装图片"]) {
            if ([model.title rangeOfString:@"颜色"].location != NSNotFound) {
                return [BYProgressHUD by_showErrorWithStatus:[NSString stringWithFormat:@"请选择%@",[model.title substringFromIndex:1]]];
                
            }else{
                return [BYProgressHUD by_showErrorWithStatus:[NSString stringWithFormat:@"请输入%@",[model.title substringFromIndex:1]]];
            }
        }
    
        if ([model.title isEqualToString:@"安装备注"]) {
            if (model.subTitle.length > 100) {
                return [BYProgressHUD by_showErrorWithStatus:@"安装备注长度不能大于100"];
            }
        }else{
            //如果输入内容长度大于20
            if (model.subTitle.length > 20) {
                NSString * resultTitle = model.isNecessary ? [model.title substringFromIndex:1] : model.title;
                
                return [BYProgressHUD by_showErrorWithStatus:[NSString stringWithFormat:@"%@长度不能大于20",resultTitle]];
            }
        }
    }
    
    //判断图片有没有上传
    BYPhotoModel * firstModel = self.images[0];
    BYPhotoModel * secondModel = self.images[1];
    
    if (firstModel.isP_HImage || secondModel.isP_HImage) {
        return [BYProgressHUD by_showErrorWithStatus:@"请上传必传图片"];
    }
    
    BYSureInfoController * sureVc = [[BYSureInfoController alloc] init];
    sureVc.sureSource = [NSMutableArray array];
    [sureVc.sureSource addObject:self.carInfoData];
    [sureVc.sureSource addObject:tempArr];
    
    NSMutableArray * mImages = [NSMutableArray array];
    for (BYPhotoModel * model in self.images) {
        [mImages addObject:model.image];
    }
    sureVc.images = [NSMutableArray array];
    [sureVc.images addObjectsFromArray:mImages];
    sureVc.photoArr = self.photoArr;
    sureVc.deviceId = self.deviceId;
    sureVc.isWirless = self.isWirless;
    [self.navigationController pushViewController:sureVc animated:YES];
}


#pragma mark - lazy
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
