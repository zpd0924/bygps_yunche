//
//  BYMyWorkOrderDetailController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderDetailController.h"
#import "EasyNavigation.h"
#import "BYMyWorkOrderDetailSection1Cell.h"
#import "BYMyWorkOrderDetailSection2Cell.h"
#import "BYMyWorkOrderDetailSection3Cell.h"
#import "BYMyWorkOrderDetailSection4Cell.h"
#import "BYMyInstallWorkOrderDetailNoCommitSection4Cell.h"
#import "BYKeepDetailDeviceCell.h"
#import "BYKeepDetailFinshDeviceCell.h"
#import "BYMyWorkOrderDetailNoCommitSection4Cell.h"
#import "BYCarMessageEntryFootView.h"
#import "UILabel+HNVerLab.h"
#import <Masonry.h>
#import "BYKeepWorkOrderLookDetailViewController.h"
#import "BYUnderlineButtonView.h"
#import "SDPhotoBrowser.h"
#import "BYUnderCircleButtonView.h"
#import "BYOrderDetailModel.h"
#import "BYMyWorkOrderDetailSection1Model.h"
#import "BYDetailTabBarController.h"
#import "BYPushNaviModel.h"
#import "BYNullModel.h"
#import "BYCheckThreeAddressViewController.h"

@interface BYMyWorkOrderDetailController ()<UITableViewDelegate,UITableViewDataSource,SDPhotoBrowserDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,weak) SDPhotoBrowser * photoBrowser;
@property (nonatomic,weak)  BYUnderCircleButtonView *circleButtonView;
@property (nonatomic,weak) BYUnderlineButtonView *underLineButton;
@property (nonatomic,strong) BYOrderDetailModel *detailModel;
@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,strong) NSArray *photoArr;
@property (nonatomic,strong) BYNullModel *photoModel;
@end

@implementation BYMyWorkOrderDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BYBackViewColor;
    [self.navigationView setTitle:@"工单详情"];
//    self.navigationView.titleLabel.textColor = [UIColor whiteColor];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView removeAllLeftButton];
//        BYWeakSelf;
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//    });
    [self loadOrderDetail];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBase{
 
    [self.view addSubview:self.tableView];
   
}
#pragma mark -- 订单详情接口
- (void)loadOrderDetail{
    BYWeakSelf;
    if (_orderNo.length == 0) {
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"orderNo"] = _orderNo;
    [BYSendWorkHttpTool POSSendOrderDetailParams:dict sendOrderType:weakSelf.sendOrderType success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.detailModel = [BYOrderDetailModel yy_modelWithDictionary:data];
            weakSelf.orderStatus = weakSelf.detailModel.orderStatus;
             [weakSelf initBase];
            [weakSelf refreshData];
        });
       
    } failure:^(NSError *error) {
        
    }];
}

#pragma makr -- 查看装机图片接口
- (void)getData:(BYDeviceModel *)model{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"orderNo"] = self.orderNo;
    dict[@"sn"] = model.deviceSn;
    [BYSendWorkHttpTool POSTCheckInstallImgParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.photoModel = [BYNullModel yy_modelWithDictionary:data];
           
            if (weakSelf.photoModel.url.length == 0) {
                BYShowError(@"没有现场作业图片");
                return ;
            }
            //测试数据
//             weakSelf.photoArr = [@"201809131652228513888.jpg,201809131652228513888.jpg,201809131652228513888.jpg,201809131652228513888.jpg" componentsSeparatedByString:@","];
            
            weakSelf.photoArr = [weakSelf.photoModel.url componentsSeparatedByString:@","];
            if (weakSelf.photoArr.count == 0) {
                BYShowError(@"没有现场作业图片");
                return ;
            }
            
            
             [weakSelf lookImage];
        });
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 刷新页面
- (void)refreshData{
    
    [self creatSectionArray];
    [self.tableView reloadData];
}
#pragma mark -- 封装第一组数据源
- (void)creatSectionArray{
    ///订单状态 0待安装 1已接单 2安装完成 3审核不通过 4审核通过 5撤销
    BYMyWorkOrderDetailSection1Model *model1 = [[BYMyWorkOrderDetailSection1Model alloc] init];
    model1.imageStr = @"orderdetail_first_sel";
    model1.dateStr = self.detailModel.createTime;
    model1.isHiddenTopView = YES;
    model1.isHiddenBottomView = NO;
    model1.titleStr = @"下发工单";
    if (_sendOrderType == BYUnpackSendOrderType) {
        switch (_detailModel.orderStatus) {
            case 0:
            {
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_def";
                model2.dateStr = nil;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = YES;
                model2.titleStr = @"待接单";
                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
            }
                break;
            case 1:
            {
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_sel";
                model2.dateStr = self.detailModel.technicianTakeTime;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = NO;
                model2.titleStr = @"接受工单";
                BYMyWorkOrderDetailSection1Model *model3 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model3.imageStr = @"orderdetail_three_def";
                model3.dateStr = nil;
                model3.isHiddenTopView = NO;
                model3.isHiddenBottomView = YES;
                model3.titleStr = @"待提交";
                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
                [self.sectionArray addObject:model3];
            }
                break;
            case 4:
            {
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_sel";
                model2.dateStr = self.detailModel.technicianTakeTime;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = NO;
                model2.titleStr = @"接受工单";
                BYMyWorkOrderDetailSection1Model *model3 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model3.imageStr = @"orderdetail_three_sel";
                model3.dateStr = self.detailModel.technicianFinishTime;
                model3.isHiddenTopView = NO;
                model3.isHiddenBottomView = NO;
                model3.titleStr = @"提交工单";
                BYMyWorkOrderDetailSection1Model *model4 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model4.imageStr = @"orderdetail_four_sel";
                model4.dateStr = self.detailModel.approveTime;
                model4.isHiddenTopView = NO;
                model4.isHiddenBottomView = NO;
                model4.titleStr = @"审核通过";
                BYMyWorkOrderDetailSection1Model *model5 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model5.imageStr = @"orderdetail_finshed";
                model5.dateStr = self.detailModel.approveTime;;
                model5.isHiddenTopView = NO;
                model5.isHiddenBottomView = YES;
                model5.titleStr = @"工单完成";
                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
                [self.sectionArray addObject:model3];
                [self.sectionArray addObject:model4];
                [self.sectionArray addObject:model5];
            }
                break;
                
            case 5:
            {
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_sel";
                model2.dateStr = self.detailModel.technicianTakeTime;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = NO;
                model2.titleStr = @"撤销";
                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
            }
                break;
                
            case 6:{
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_sel";
                model2.dateStr = self.detailModel.technicianTakeTime;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = NO;
                model2.titleStr = @"接受工单";
                BYMyWorkOrderDetailSection1Model *model3 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model3.imageStr = @"orderdetail_three_sel";
                model3.dateStr = self.detailModel.technicianFinishTime;
                model3.isHiddenTopView = NO;
                model3.isHiddenBottomView = NO;
                model3.titleStr = @"提交工单";
                BYMyWorkOrderDetailSection1Model *model4 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model4.imageStr = @"orderdetail_four_sel";
                model4.dateStr = self.detailModel.approveTime;
                model4.isHiddenTopView = NO;
                model4.isHiddenBottomView = NO;
                model4.titleStr = @"异常";
                
                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
                [self.sectionArray addObject:model3];
                [self.sectionArray addObject:model4];
                
            }
                break;
            default:
                
                break;
        }
    }else{
        switch (_detailModel.orderStatus) {
            case 0:
            {
                
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_def";
                model2.dateStr = nil;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = YES;
                model2.titleStr = @"待接单";
                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
            }
                break;
            case 1:
            {
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_sel";
                model2.dateStr = self.detailModel.technicianTakeTime;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = NO;
                model2.titleStr = @"接受工单";
                BYMyWorkOrderDetailSection1Model *model3 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model3.imageStr = @"orderdetail_three_def";
                model3.dateStr = nil;
                model3.isHiddenTopView = NO;
                model3.isHiddenBottomView = YES;
                model3.titleStr = @"待提交";
                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
                [self.sectionArray addObject:model3];
            }
                break;
            case 2:
            {
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_sel";
                model2.dateStr = self.detailModel.technicianTakeTime;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = NO;
                model2.titleStr = @"接受工单";
                BYMyWorkOrderDetailSection1Model *model3 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model3.imageStr = @"orderdetail_three_sel";
                model3.dateStr = self.detailModel.technicianFinishTime;
                model3.isHiddenTopView = NO;
                model3.isHiddenBottomView = NO;
                model3.titleStr = @"提交工单";
                BYMyWorkOrderDetailSection1Model *model4 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model4.imageStr = @"orderdetail_four_def";
                model4.dateStr = nil;
                model4.isHiddenTopView = NO;
                model4.isHiddenBottomView = YES;
                model4.titleStr = @"待审核";
                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
                [self.sectionArray addObject:model3];
                [self.sectionArray addObject:model4];
            }
                break;
            case 3:
            {
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_sel";
                model2.dateStr = self.detailModel.technicianTakeTime;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = NO;
                model2.titleStr = @"接受工单";
                BYMyWorkOrderDetailSection1Model *model3 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model3.imageStr = @"orderdetail_three_sel";
                model3.dateStr = self.detailModel.technicianFinishTime;
                model3.isHiddenTopView = NO;
                model3.isHiddenBottomView = NO;
                model3.titleStr = @"提交工单";
                BYMyWorkOrderDetailSection1Model *model4 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model4.imageStr = @"orderdetail_four_sel";
                model4.dateStr = self.detailModel.approveTime;
                model4.isHiddenTopView = NO;
                model4.isHiddenBottomView = NO;
                model4.titleStr = @"审核不通过";
                BYMyWorkOrderDetailSection1Model *model5 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model5.imageStr = @"orderdetail_three_def";
                model5.dateStr = nil;
                model5.isHiddenTopView = NO;
                model5.isHiddenBottomView = YES;
                model5.titleStr = @"待重新提交";
                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
                [self.sectionArray addObject:model3];
                [self.sectionArray addObject:model4];
                [self.sectionArray addObject:model5];
            }
                break;
            case 4:
            {
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_sel";
                model2.dateStr = self.detailModel.technicianTakeTime;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = NO;
                model2.titleStr = @"接受工单";
                BYMyWorkOrderDetailSection1Model *model3 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model3.imageStr = @"orderdetail_three_sel";
                model3.dateStr = self.detailModel.technicianFinishTime;
                model3.isHiddenTopView = NO;
                model3.isHiddenBottomView = NO;
                model3.titleStr = @"提交工单";
                BYMyWorkOrderDetailSection1Model *model4 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model4.imageStr = @"orderdetail_four_sel";
                model4.dateStr = self.detailModel.approveTime;
                model4.isHiddenTopView = NO;
                model4.isHiddenBottomView = NO;
                model4.titleStr = @"审核通过";
                BYMyWorkOrderDetailSection1Model *model5 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model5.imageStr = @"orderdetail_finshed";
                model5.dateStr = self.detailModel.approveTime;;
                model5.isHiddenTopView = NO;
                model5.isHiddenBottomView = YES;
                model5.titleStr = @"工单完成";
                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
                [self.sectionArray addObject:model3];
                [self.sectionArray addObject:model4];
                [self.sectionArray addObject:model5];
            }
                break;
                
            case 5:
            {
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_sel";
                model2.dateStr = self.detailModel.technicianTakeTime;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = NO;
                model2.titleStr = @"撤销";
                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
            }
                break;
                
            case 6:{
                BYMyWorkOrderDetailSection1Model *model2 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model2.imageStr = @"orderdetail_second_sel";
                model2.dateStr = self.detailModel.technicianTakeTime;
                model2.isHiddenTopView = NO;
                model2.isHiddenBottomView = NO;
                model2.titleStr = @"接受工单";
                BYMyWorkOrderDetailSection1Model *model3 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model3.imageStr = @"orderdetail_three_sel";
                model3.dateStr = self.detailModel.technicianFinishTime;
                model3.isHiddenTopView = NO;
                model3.isHiddenBottomView = NO;
                model3.titleStr = @"提交工单";
                BYMyWorkOrderDetailSection1Model *model4 = [[BYMyWorkOrderDetailSection1Model alloc] init];
                model4.imageStr = @"orderdetail_four_sel";
                model4.dateStr = self.detailModel.approveTime;
                model4.isHiddenTopView = NO;
                model4.isHiddenBottomView = NO;
                model4.titleStr = @"异常";

                [self.sectionArray addObject:model1];
                [self.sectionArray addObject:model2];
                [self.sectionArray addObject:model3];
                [self.sectionArray addObject:model4];

            }
                break;
                
            default:
                break;
        }
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
             return self.sectionArray.count;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
             return self.detailModel.gps.count;
            break;
    }
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    switch (indexPath.section) {
        case 0:
        {
            BYMyWorkOrderDetailSection1Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMyWorkOrderDetailSection1Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.sectionArray[indexPath.row];
            return cell;
        }
            break;
        case 1:
        {
            BYMyWorkOrderDetailSection2Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMyWorkOrderDetailSection2Cell"];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.sendOrderType = _sendOrderType;
            cell.model = self.detailModel;
            return cell;
        }
            break;
        case 2:
        {
            BYMyWorkOrderDetailSection3Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMyWorkOrderDetailSection3Cell"];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = self.detailModel;
            return cell;
        }
            break;
        default:
        {
            switch (_sendOrderType) {
                case BYWorkSendOrderType://安装派单详情
                {
                    switch (self.detailModel.orderStatus) {
                        case 0://待接单/待安装
                        case 1://待提交/已接单
                        case 5://撤销工单
                        {
                            BYMyInstallWorkOrderDetailNoCommitSection4Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMyInstallWorkOrderDetailNoCommitSection4Cell"];
                             cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.deviceModel = self.detailModel.gps[indexPath.row];
                            return cell;
                        }
                            break;
                        case 2://待审核/安装完成
                        case 3://审核不通过
                        case 4://审核通过
                        {
                            BYMyWorkOrderDetailSection4Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMyWorkOrderDetailSection4Cell"];
                            cell.leftBtnBlock = ^{//查看定位
                                BYDetailTabBarController * detailTabBarVC = [[BYDetailTabBarController alloc] init];
                                BYPushNaviModel *model = [[BYPushNaviModel alloc] init];
                                BYDeviceModel *deviceModel = weakSelf.detailModel.gps[indexPath.row];
                                model.deviceId = deviceModel.deviceId;
                                detailTabBarVC.selectedIndex = 1;
                                detailTabBarVC.model = model;
                                [self.navigationController pushViewController:detailTabBarVC animated:YES];
                            };
                            cell.rightBtnBlock = ^{//安装图片
                               
                                [weakSelf getData:self.detailModel.gps[indexPath.row]];
                            };
                             cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.deviceModel = self.detailModel.gps[indexPath.row];
                            return cell;
                        }
                            break;
                        default:
                            break;
                    }
                }
                    break;
                case BYUnpackSendOrderType://拆机派单详情
                {
                    switch (self.detailModel.orderStatus) {
                        case 0:
                        case 1:
                        case 2:
                        case 3:
                        case 4:
                        case 5:
                        {
                            BYMyWorkOrderDetailNoCommitSection4Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMyWorkOrderDetailNoCommitSection4Cell"];
                             cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.deviceModel = self.detailModel.gps[indexPath.row];
//                            cell.isShowUnpairBtn =
                            cell.lookImageBlock = ^(BYDeviceModel *model) {
                                [weakSelf getData:weakSelf.detailModel.gps[indexPath.row]];
                            };
                            return cell;
                        }
                            break;
                        default:
                            break;
                    }

                }
                    break;
                case BYRepairSendOrderType://检修派单详情
                {
                    switch (self.detailModel.orderStatus) {
                        case 0:
                        case 1:
                        case 5:
                        {
                            BYKeepDetailDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYKeepDetailDeviceCell"];
                             cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.deviceModel = self.detailModel.gps[indexPath.row];
                            return cell;
                        }
                            break;
                        case 2:
                        case 3:
                        case 4:
                        {
                            BYDeviceModel *model = self.detailModel.gps[indexPath.row];
                            BYKeepDetailFinshDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYKeepDetailFinshDeviceCell"];
                            cell.detailFinshDeviceCellBlock = ^{//查看详情
                                BYKeepWorkOrderLookDetailViewController *vc = [[BYKeepWorkOrderLookDetailViewController alloc] init];
                                vc.deviceModel = model;
                                vc.orderNo = _orderNo;
                                vc.deviceSn = model.deviceSn;
                                vc.installConfirm = model.installConfirm;
                                [weakSelf.navigationController pushViewController:vc animated:YES];
                            };
                             cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            cell.deviceModel = self.detailModel.gps[indexPath.row];
                            return cell;
                        }
                            break;
                        default:
                            break;
                    }

                }
                    break;
                
                case 6:
                {
                    BYKeepDetailDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYKeepDetailDeviceCell"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.deviceModel = self.detailModel.gps[indexPath.row];
                    return cell;
                }
                    break;
                default:
                    break;
            }
            return nil;
            
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 3) {
//        是否是安装
        BYDeviceModel *deviceModel = self.detailModel.gps[indexPath.row];
        if (_sendOrderType == BYWorkSendOrderType && [BYSaveTool boolForKey:sameAdd]&&deviceModel.sameAdd != 0) {
            if (self.detailModel.orderStatus == 2 || self.detailModel.orderStatus == 3 || self.detailModel.orderStatus == 4) {
//                BYDeviceModel *deviceModel = self.detailModel.gps[indexPath.row];
                BYCheckThreeAddressViewController *checkVC = [[BYCheckThreeAddressViewController alloc] init];
                checkVC.deviceModel = deviceModel;
                checkVC.orderNo = self.orderNo;
                [self.navigationController pushViewController:checkVC animated:YES];
            }
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = WHITE;
    UIView *bigSpaceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH, 10)];
    bigSpaceView.backgroundColor = BYBigSpaceColor;
    UIView *spaceView = [[UIView alloc] init];
    spaceView.backgroundColor = BYBigSpaceColor;
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = BYGlobalBlueColor;
        UILabel *label = [UILabel verLab:15 textRgbColor:[UIColor blackColor] textAlighment:NSTextAlignmentLeft];
    
        [view addSubview:line];
        [view addSubview:label];
        [view addSubview:spaceView];
        [view addSubview:bigSpaceView];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(5, 15));
            make.top.equalTo(bigSpaceView.mas_bottom).offset(17.5);
            make.left.mas_equalTo(20);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(line);
            make.left.equalTo(line.mas_right).offset(8);
        }];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(MAXWIDTH - 20, 0.5));
        make.bottom.trailing.equalTo(view);
    }];
    switch (section) {
        case 0:
            label.text = @"工单状态";
            break;
        case 1:
            label.text = @"工单信息";
            break;
        case 2:
            label.text = @"车辆信息";
            break;
            
        default:
        {
            NSInteger count = 0;
            for (BYDeviceModel *deviceModel in self.detailModel.gps) {
                count = deviceModel.deviceCount + count;
            }
            label.text = [NSString stringWithFormat:@"设备信息(共安装%zd台设备)",count];
            label.attributedText = [BYObjectTool changeStrWittContext:label.text ChangeColorText:[NSString stringWithFormat:@"(共安装%zd台设备)",count] WithColor:BYLabelBlackColor WithFont:[UIFont systemFontOfSize:15]];
        }
            break;
    }   
    
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 60;
}

#pragma mark -- 查看图片
- (void)lookImage{
    BYUnderlineButtonView *underLineButton = nil;
    if (_sendOrderType == BYUnpackSendOrderType) {
        if (self.photoArr.count >2) {
            underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"设备合照",@"设备合照",@"设备合照"]];
        }else if(self.photoArr.count == 2){
            underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"设备合照",@"设备合照"]];
        }else{
            underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"设备合照"]];
        }
    }else{
        if (self.photoArr.count >2) {
            underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"安装位置图片",@"设备合照",@"设备合照"]];
        }else{
            underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"安装位置图片",@"设备合照"]];
        }
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
        make.bottom.mas_equalTo(-200*PXSCALEH);
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


#pragma mark -- lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 50;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        BYRegisterCell(BYMyWorkOrderDetailSection1Cell);
         BYRegisterCell(BYMyWorkOrderDetailSection2Cell);
         BYRegisterCell(BYMyWorkOrderDetailSection3Cell);
         BYRegisterCell(BYMyWorkOrderDetailSection4Cell);
        BYRegisterCell(BYMyWorkOrderDetailNoCommitSection4Cell);
        BYRegisterCell(BYKeepDetailDeviceCell);
        BYRegisterCell(BYKeepDetailFinshDeviceCell);
        BYRegisterCell(BYMyInstallWorkOrderDetailNoCommitSection4Cell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}
-(NSMutableArray *)sectionArray
{
    if (!_sectionArray) {
        _sectionArray = [NSMutableArray array];
        
    }
    return _sectionArray;
}
-(NSArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSArray array];
    }
    return _photoArr;
}
@end
