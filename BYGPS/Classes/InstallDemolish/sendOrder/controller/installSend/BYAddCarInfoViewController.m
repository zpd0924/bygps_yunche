//
//  BYAddCarInfoViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAddCarInfoViewController.h"
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
#import "VinManager.h"
#import "PlateCameraController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface BYAddCarInfoViewController ()<UITableViewDelegate,UITableViewDataSource,VinManagerDelegate,PlateCameraDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *otherColorTitleArray;
@property (nonatomic,strong) NSArray *colorSource;
@property (nonatomic,strong) BYAddCarInfoModel *model;
@property (nonatomic,assign) BOOL selectOtherColor;

@end

@implementation BYAddCarInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBase{
    [self.navigationView setTitle:@"新增车辆"];
//    self.model.brand = @"其他";
    self.view.backgroundColor = BYBigSpaceColor;
    BYWeakSelf;
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
    [carMessageEntryFootView.nextStepBtn setTitle:@"保存" forState:UIControlStateNormal];
    carMessageEntryFootView.frame = CGRectMake(0, 0, MAXWIDTH, 100);
    carMessageEntryFootView.backgroundColor = BYBigSpaceColor;
    
    carMessageEntryFootView.nextStepClickBlock = ^{
        [weakSelf addCar];
    };
    self.tableView.tableFooterView = carMessageEntryFootView;
    
    
}

#pragma mark -- 新增车辆
- (void)addCar{
    BYWeakSelf;
    [self.view endEditing:YES];
    if (!self.model.carFirstNum.length) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"carFirstNum"]) {
            self.model.carFirstNum = [[NSUserDefaults standardUserDefaults] objectForKey:@"carFirstNum"];
        }else{
            self.model.carFirstNum = @"粤B";
            [[NSUserDefaults standardUserDefaults] setObject:@"粤B" forKey:@"carFirstNum"];
        }
        
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.model.carLastNum.length) {
        self.model.carNum = [NSString stringWithFormat:@"%@%@",self.model.carFirstNum,self.model.carLastNum];
        dict[@"carNum"] = [BYObjectTool lowUpdateBig:self.model.carNum];
    }
  
    
    if (!self.model.carVin.length) {
        BYShowError(@"车架号不能为空");
        return;
    }
    if ([BYRegularTool checkCheJiaNumber:self.model.carVin]) {
        return [BYProgressHUD by_showErrorWithStatus:@"请输入正确的车架号"];
    }
    dict[@"carVin"] = [BYObjectTool lowUpdateBig:self.model.carVin];
    
    if (!self.model.companyId.length) {
        BYShowError(@"请选择所属公司");
        return;
    }
    dict[@"groupId"] = self.model.companyId;
    
//    if (!self.model.brand.length) {
//        BYShowError(@"请选择车辆品牌");
//        return;
//    }
    dict[@"brand"] = self.model.brand;
    dict[@"carType"] = [self.model.brand isEqualToString:@"其他"] ? @"其他": self.model.carType;
    dict[@"carModel"] =[self.model.brand isEqualToString:@"其他"] || [self.model.carType isEqualToString:@"其他"] ? @"其他": self.model.carModel;
    if (!self.model.color.length) {
        BYShowError(@"请选择车辆颜色");
        return;
    }else{
        if ([self.model.color isEqualToString:@"其他"]) {
            if (!self.model.otherColor.length) {
                dict[@"color"] = @"其他";
            }else{
                dict[@"color"] = self.model.otherColor;
            }
        }else{
            dict[@"color"] = self.model.color;
        }
    }
    if (self.model.ownerTel.length > 0 && self.model.ownerTel.length != 11) {
        BYShowError(@"请输入正确的手机号码");
        return;
    }
    if (self.model.ownerName.length) {
       dict[@"ownerName"] = self.model.ownerName;
    }
    
    if (self.model.ownerTel.length) {
       dict[@"ownerTel"] = self.model.ownerTel;
    }
    if (self.model.contractNo.length) {
        dict[@"contractNo"] = self.model.contractNo;
    }
   
    [BYSendWorkHttpTool POSTAddCarParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYShowSuccess(@"增加成功");
            if (weakSelf.model.carNum.length <= 0) {
                if (weakSelf.addCarInfoViewBlock) {
                    weakSelf.addCarInfoViewBlock(weakSelf.model.carVin);
                }
            }else{
                if (weakSelf.addCarInfoViewBlock) {
                    weakSelf.addCarInfoViewBlock(weakSelf.model.carNum);
                }
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- tableview 数据源 代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.selectOtherColor ? self.otherColorTitleArray[section] : self.titleArray[section];
    return arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    if(indexPath.section == 0 && indexPath.row == 0){
        BYAddCarInfoPaiViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYAddCarInfoPaiViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
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
        cell.carNumBlock = ^(NSString *carNumber) {
            BYLog(@"carNumber = %@",carNumber);
            weakSelf.model.carLastNum = carNumber;
            [weakSelf.tableView reloadData];
        };
        
        return cell;
    }else{
        BYAddCarInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYAddCarInfoViewCell" forIndexPath:indexPath];
        cell.addCarInfoBlock = ^(NSString *str, NSIndexPath *indexPath) {
            switch (indexPath.section) {
                case 0:
                {
                    if (indexPath.row == 1) {
                        weakSelf.model.carVin = str;
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
                    }else if (indexPath.row == 1){
                        weakSelf.model.ownerTel = str;
                    }else{
                        weakSelf.model.contractNo = str;
                    }
                }
                    break;
            }
        };
        cell.scanBtnClickBlock = ^{
             [weakSelf carVinScan];
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.model;
        cell.selectOtherColor = self.selectOtherColor;
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
            BYAddCarInfoViewCell *cell = (BYAddCarInfoViewCell *)[tableView cellForRowAtIndexPath:indexPath];
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
                weakSelf.model.brand = brand;
                weakSelf.model.carType = carType;
                weakSelf.model.carModel = carInfoType;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 2){
            BYBelongCompanyViewController *vc = [[BYBelongCompanyViewController alloc] init];
            vc.groupIdsStrBlock = ^(NSString *groupIdsStr) {
                NSArray *arr = [groupIdsStr componentsSeparatedByString:@"-"];
                weakSelf.model.companyId = arr.firstObject;
                weakSelf.model.company = arr.lastObject;
                [weakSelf.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
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
        label.text = @"车辆信息和车主信息";
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
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.view endEditing:YES];
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
        _tableView.dataSource = self;
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
        _titleArray = @[@[@"车牌号",@"*车架号",@"*所属公司",@"车辆品牌",@"*车辆颜色"],@[@"*车主姓名",@"*车主电话",@"合同编号"]];
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

@end
