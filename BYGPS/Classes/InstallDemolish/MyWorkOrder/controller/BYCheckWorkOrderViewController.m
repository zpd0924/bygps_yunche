//
//  BYCheckWorkOrderViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/16.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCheckWorkOrderViewController.h"
#import "EasyNavigation.h"
#import "BYCheckWorkOrderCell.h"
#import "BYCheckWorkOrderFootView.h"
#import "BYCheckNoPassReasonViewController.h"
#import "BYDeviceModel.h"
#import "BYPushNaviModel.h"
#import "SDPhotoBrowser.h"
#import "BYNullModel.h"
#import "BYUnderCircleButtonView.h"
#import "BYUnderlineButtonView.h"
#import "BYDetailTabBarController.h"

@interface BYCheckWorkOrderViewController ()<UITableViewDelegate,UITableViewDataSource,SDPhotoBrowserDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) BYNullModel *photoModel;
@property (nonatomic,strong) NSArray *photoArr;

@property (nonatomic,weak) SDPhotoBrowser * photoBrowser;
@property (nonatomic,weak)  BYUnderCircleButtonView *circleButtonView;
@property (nonatomic,weak) BYUnderlineButtonView *underLineButton;
@end

@implementation BYCheckWorkOrderViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
    [self getData];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initBase{
    [self.navigationView setTitle:@"工单审核"];
    self.view.backgroundColor = BYBigSpaceColor;
//    self.navigationView.titleLabel.textColor = [UIColor whiteColor];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView removeAllLeftButton];
//        BYWeakSelf;
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//    });
    [self.view addSubview:self.tableView];
    BYCheckWorkOrderFootView *footView = [BYCheckWorkOrderFootView by_viewFromXib];
    BYWeakSelf;
    footView.noPassBlock = ^{
        MobClickEvent(@"audit_noPass", @"");
        BYCheckNoPassReasonViewController *vc = [[BYCheckNoPassReasonViewController alloc] init];
        vc.model = _model;
        vc.checkNoPassReasonBlock = ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                BYShowSuccess(@"操作成功");
                if (weakSelf.checkWorkOrderBlock) {
                    weakSelf.model.status = 3;
                    weakSelf.checkWorkOrderBlock(weakSelf.model);
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            });
        };
        vc.modalPresentationStyle=
        UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
        [vc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakSelf presentViewController:vc animated:YES completion:^{
//            vc.view.backgroundColor = [UIColor clearColor];
            
        }];
    };
    footView.passBlock = ^{
        MobClickEvent(@"audit_pass", @"");
        [weakSelf auditing];
    };
    footView.backgroundColor = BYBigSpaceColor;
    self.tableView.tableFooterView = footView;
  
}
#pragma mark -- 审核接口
- (void)auditing{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"orderNo"] = _model.orderNo;
    dict[@"status"] = @(1);//状态 1：通过 0：不通过
    [BYSendWorkHttpTool POSSauditingParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            BYShowSuccess(@"操作成功");
            if (weakSelf.checkWorkOrderBlock) {
                 weakSelf.model.status = 4;
                weakSelf.checkWorkOrderBlock(weakSelf.model);
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        });
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 获取数据
- (void)getData{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"orderNo"] = _model.orderNo;
    [BYSendWorkHttpTool POSTQueryListLocationParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dataSource = [[NSArray yy_modelArrayWithClass:[BYDeviceModel class] json:data] mutableCopy];
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma makr -- 查看装机图片接口
- (void)getData:(BYDeviceModel *)model{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"orderNo"] = _model.orderNo;
    dict[@"sn"] = model.deviceSn;
    [BYSendWorkHttpTool POSTCheckInstallImgParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.photoModel = [BYNullModel yy_modelWithDictionary:data];

            if (weakSelf.photoModel.url.length == 0) {
                BYShowError(@"没有安装图片");
                return ;
            }
            weakSelf.photoArr = [weakSelf.photoModel.url componentsSeparatedByString:@","];
            if (weakSelf.photoArr.count == 0) {
                BYShowError(@"没有安装图片");
                return ;
            }
            [weakSelf lookImage];
        });
    } failure:^(NSError *error) {

    }];
}

#pragma mark -- 查看定位
- (void)lookLocation:(BYDeviceModel *)model{
    BYDetailTabBarController * detailTabBarVC = [[BYDetailTabBarController alloc] init];
    detailTabBarVC.selectedIndex = 1;
    BYPushNaviModel *model1 = [[BYPushNaviModel alloc] init];
    model1.deviceId = model.deviceId;
    detailTabBarVC.model = model1;
    [self.navigationController pushViewController:detailTabBarVC animated:YES];
}
#pragma mark -- 查看图片
- (void)lookImage{
    BYUnderlineButtonView *underLineButton = nil;
    if (self.photoArr.count >2) {
        underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"安装位置图片",@"设备合照",@"设备合照"]];
    }else if(self.photoArr.count == 2){
        underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"安装位置图片",@"设备合照"]];
    }else{
        underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"安装位置图片"]];
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
    [photoBrowser addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(2, 20));
        make.center.equalTo(underLineButton);
    }];
    
    BYUnderCircleButtonView *circleButtonView = [[BYUnderCircleButtonView alloc]initWithItems:@[@"",@""]];
     circleButtonView.hidden = YES;
    self.circleButtonView = circleButtonView;
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
    NSArray *arr = self.photoArr;
    
    return [NSURL URLWithString:[BYObjectTool imageStr:arr[index]]];
}
- (void)photoBrowser:(SDPhotoBrowser *)browser showImageIndex:(NSInteger)index{
    self.underLineButton.selectedIndex = index;
    self.circleButtonView.selectedIndex = index;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    BYDeviceModel *model = self.dataSource[indexPath.row];
    BYCheckWorkOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYCheckWorkOrderCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lookLocationBlock = ^{
        [weakSelf lookLocation:model];
    };
    cell.lookImagesBlock = ^{
        [weakSelf getData:model];
    };
    cell.model = self.dataSource[indexPath.row];
    return cell;
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
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
        BYRegisterCell(BYCheckWorkOrderCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.contentInset = UIEdgeInsetsMake(5, 0, 0, 0);
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
-(NSArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSArray array];
    }
    return _photoArr;
}
@end
