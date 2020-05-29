//
//  BYKeepWorkOrderLookDetailViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYKeepWorkOrderLookDetailViewController.h"
#import "BYKeepDetailDeviceCell.h"
#import "BYKeepDetailWayCell.h"
#import "EasyNavigation.h"
#import "BYCheckWorkOrderFootView.h"
#import "BYDeviceModel.h"
#import "SDPhotoBrowser.h"
#import "BYPushNaviModel.h"
#import "BYNullModel.h"
#import "BYUnderCircleButtonView.h"
#import "BYUnderlineButtonView.h"
#import "BYDetailTabBarController.h"


@interface BYKeepWorkOrderLookDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SDPhotoBrowserDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) BYDeviceModel *model;
@property (nonatomic,strong) BYNullModel *photoModel;
@property (nonatomic,strong) NSMutableArray *photoArr;//安装图片
@property (nonatomic,strong) BYNullModel *photoConfirmModel;
@property (nonatomic,strong) NSArray *photoConfirmArr;//安装确认图片
@property (nonatomic,assign) BOOL isLookConfirm;
@property (nonatomic,weak) SDPhotoBrowser * photoBrowser;
@property (nonatomic,weak)  BYUnderCircleButtonView *circleButtonView;
@property (nonatomic,weak) BYUnderlineButtonView *underLineButton;
@end

@implementation BYKeepWorkOrderLookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
    [self loadRepairSnDetail];
//    [self getInstallConfirm];
//    [self getInstallImg];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBase{
    [self.navigationView setTitle:@"检修工单详情"];
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
    self.view.backgroundColor = BYBigSpaceColor;
    [self.view addSubview:self.tableView];
    BYCheckWorkOrderFootView *footView = [BYCheckWorkOrderFootView by_viewFromXib];
    [footView.leftBtn setBackgroundColor:WHITE];
    [footView.leftBtn setTitle:@"安装确认单" forState:UIControlStateNormal];
    [footView.leftBtn setTitleColor:BYGlobalBlueColor forState:UIControlStateNormal];
    footView.leftBtn.layer.cornerRadius = 3;
    footView.leftBtn.layer.masksToBounds = YES;
    footView.leftBtn.layer.borderColor = BYGlobalBlueColor.CGColor;
    footView.leftBtn.layer.borderWidth = 1;
    [footView.rightBtn setTitle:@"安装图片" forState:UIControlStateNormal];
     [footView.rightBtn setTitleColor:BYGlobalBlueColor forState:UIControlStateNormal];
    [footView.rightBtn setBackgroundColor:WHITE];
    footView.rightBtn.layer.cornerRadius = 3;
    footView.rightBtn.layer.masksToBounds = YES;
    footView.rightBtn.layer.borderColor = BYGlobalBlueColor.CGColor;
    footView.rightBtn.layer.borderWidth = 1;
    footView.passBlock = ^{//查看安装图片
        weakSelf.isLookConfirm = NO;
        [weakSelf lookImage];
    };
    footView.noPassBlock = ^{//查看安装确认单
      
        weakSelf.isLookConfirm = YES;
        [weakSelf lookInstallConfirm];
    };
    self.tableView.tableFooterView = footView;
  
}

#pragma mark -- 安装确认单
- (void)getInstallConfirm{
    BYWeakSelf;
 
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"orderNo"] = self.orderNo;
    
    [BYSendWorkHttpTool POSTInstallConfirmOrderParams:params success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.photoConfirmModel = [BYNullModel yy_modelWithDictionary:data];
            weakSelf.photoConfirmArr = [weakSelf.photoModel.url componentsSeparatedByString:@","];
        });
     
    } failure:^(NSError *error) {
        
    }];
   
}
#pragma mark -- 安装图片
- (void)getInstallImg{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"orderNo"] = self.orderNo;
    dict[@"sn"] = _model.deviceSn;
    [BYSendWorkHttpTool POSTCheckInstallImgParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.photoModel = [BYNullModel yy_modelWithDictionary:data];
            
            if (weakSelf.photoModel.url.length == 0) {
                BYShowError(@"没有安装图片");
                return ;
            }
            weakSelf.photoArr = [[weakSelf.photoModel.url componentsSeparatedByString:@","] mutableCopy];
            if (weakSelf.photoArr.count == 0) {
                BYShowError(@"没有安装图片");
                return ;
            }
           
        });
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 检修设备详情查询
- (void)loadRepairSnDetail{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"orderNo"] = _orderNo;
    dict[@"sn"] = _deviceSn;
    [BYSendWorkHttpTool POSTRepairSnDetailParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.model = [BYDeviceModel yy_modelWithDictionary:data];
            weakSelf.photoConfirmArr = [weakSelf.installConfirm componentsSeparatedByString:@","];
            if (weakSelf.model.repairScheme == 1) {
                if (weakSelf.model.deviceVinImg.length) {
                    [weakSelf.photoArr addObject:weakSelf.model.deviceImg];
                    for (NSString *str in [weakSelf.model.NewDeviceVinImg componentsSeparatedByString:@","]) {
                       [weakSelf.photoArr addObject:str];
                    }
                    
                }else{
                    [weakSelf.photoArr addObject:weakSelf.model.deviceImg];
                }
               
            }else{
                [weakSelf.photoArr addObject:weakSelf.model.deviceImg];
                for (NSString *str in [weakSelf.model.NewDeviceVinImg componentsSeparatedByString:@","]) {
                    [weakSelf.photoArr addObject:str];
                }
               
            }
            
            [weakSelf.dataSource addObject:weakSelf.model];
            [weakSelf.tableView reloadData];
        });
      
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark -- 查看定位
- (void)lookLocation{
    BYDetailTabBarController * detailTabBarVC = [[BYDetailTabBarController alloc] init];
    BYPushNaviModel *model = [[BYPushNaviModel alloc] init];
    model.deviceId = _model.deviceId;
    detailTabBarVC.selectedIndex = 1;
    detailTabBarVC.model = model;
    [self.navigationController pushViewController:detailTabBarVC animated:YES];
}

#pragma mark -- 查看安装确认图片
- (void)lookInstallConfirm{
    if (!self.photoConfirmArr.count) {
        BYShowError(@"查看安装确认单图片失败");
        return;
    }
    //大图浏览
    SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
    self.photoBrowser = photoBrowser;
    photoBrowser.isLookInstallImages = YES;
    photoBrowser.delegate = self;
    photoBrowser.imageCount = self.photoConfirmArr.count;
    
    [photoBrowser show];
}

#pragma mark -- 查看图片
- (void)lookImage{
//    if (self.photoArr.count != 2) {
//        BYShowError(@"查看安装图片失败");
//        return;
//    }
    
    BYUnderlineButtonView *underLineButton = nil;
    if (self.photoArr.count >2) {
        underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"安装位置图片",@"设备合照",@"设备合照"]];
    }else if(self.photoArr.count == 1){
        underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"安装位置图片"]];
    }else{
        underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"安装位置图片",@"设备合照"]];
    }
    self.underLineButton = underLineButton;
    [underLineButton addTarget:self action:@selector(changeTheVision:)];
    underLineButton.isBigLookImages = YES;
    
    //大图浏览
    SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
    self.photoBrowser = photoBrowser;
    photoBrowser.isLookInstallImages = YES;
    photoBrowser.delegate = self;
    photoBrowser.imageCount = self.photoArr.count;
    
    [photoBrowser show];
    
    [photoBrowser addSubview:underLineButton];
    [underLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MAXWIDTH, 30));
        make.centerX.equalTo(photoBrowser);
        make.top.mas_equalTo(100);
    }];
    UIView *line = [[UIView alloc] init];
    line.hidden = YES;
    line.backgroundColor = WHITE;
    if (self.model.repairScheme != 1) {
        [photoBrowser addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(2, 20));
            make.center.equalTo(underLineButton);
        }];
    }
    
    BYUnderCircleButtonView *circleButtonView = [[BYUnderCircleButtonView alloc]initWithItems:self.model.repairScheme == 1 ? @[@""] : @[@"",@""]];
    self.circleButtonView = circleButtonView;
     circleButtonView.hidden = YES;
    [circleButtonView addTarget:self action:@selector(circleButtonViewClick:)];
    [photoBrowser addSubview:circleButtonView];
    [circleButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 30));
        make.centerX.equalTo(photoBrowser);
        make.bottom.mas_equalTo(-200);
    }];
    
}
-(void)changeTheVision:(UIButton *)sender{
    
    [self.photoBrowser showImageIndex:sender.tag - 1000];
    self.underLineButton.selectedIndex = sender.tag - 1000;
    self.circleButtonView.selectedIndex = sender.tag - 1000;
    
}
- (void)circleButtonViewClick:(UIButton *)sender{
    [self.photoBrowser showImageIndex:sender.tag - 1000];
    self.underLineButton.selectedIndex = sender.tag - 1000;
    self.circleButtonView.selectedIndex = sender.tag - 1000;
}

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    
    UIImage *image = [UIImage imageNamed:@""];
    return image;
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    NSArray *arr = [NSArray array];
    if (_isLookConfirm) {
        arr = self.photoConfirmArr;
    }else{
        arr = self.photoArr;
    }
    return [NSURL URLWithString:[BYObjectTool imageStr:arr[index]]];
}
- (void)photoBrowser:(SDPhotoBrowser *)browser showImageIndex:(NSInteger)index{
    self.underLineButton.selectedIndex = index;
    self.circleButtonView.selectedIndex = index;
}

#pragma mark -- tableview 数据源 代理

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
       return self.dataSource.count;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BYKeepDetailDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYKeepDetailDeviceCell" forIndexPath:indexPath];
        cell.deviceModel = self.deviceModel;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else{
        BYKeepDetailWayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYKeepDetailWayCell" forIndexPath:indexPath];
        cell.model = self.deviceModel;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
  
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = WHITE;
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = BYGlobalBlueColor;
    UILabel *label = [UILabel verLab:15 textRgbColor:BYLabelBlackColor textAlighment:NSTextAlignmentLeft];
    
    UIView *spaceView = [[UIView alloc] init];
    spaceView.backgroundColor = BYBigSpaceColor;
    [view addSubview:line];
    [view addSubview:label];
    [view addSubview:spaceView];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(5, 15));
        make.centerY.equalTo(view);
        make.left.mas_equalTo(20);
    }];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.equalTo(line.mas_right).offset(8);
    }];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MAXWIDTH - 12, 0.5));
        make.bottom.trailing.equalTo(view);
    }];
    switch (section) {
        case 0:
           label.text = @"检修设备";
             label.attributedText = [BYObjectTool changeStrWittContext:@"检修设备" ChangeColorText:[NSString stringWithFormat:@"%zd",self.dataSource.count] WithColor:BYGlobalBlueColor WithFont:[UIFont systemFontOfSize:20]];
            break;
            
        default:
             label.text = @"检修方式";
             label.attributedText = [BYObjectTool changeStrWittContext:@"检修方式" ChangeColorText:[NSString stringWithFormat:@"%zd",self.dataSource.count] WithColor:BYGlobalBlueColor WithFont:[UIFont systemFontOfSize:20]];
            break;
    }
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 52;
    
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
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        BYRegisterCell(BYKeepDetailDeviceCell);
        BYRegisterCell(BYKeepDetailWayCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
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
-(NSMutableArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSMutableArray array];
    }
    return _photoArr;
}
-(NSArray *)photoConfirmArr
{
    if (!_photoConfirmArr) {
        _photoConfirmArr = [NSArray array];
    }
    return _photoConfirmArr;
}
@end
