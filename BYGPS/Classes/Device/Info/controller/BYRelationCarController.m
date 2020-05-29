//
//  BYRelationCarController.m
//  BYGPS
//
//  Created by miwer on 16/7/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYRelationCarController.h"
#import "BYSettingGroup.h"
#import "BYSettingNoneItem.h"
#import "BYSettingArrowItem.h"
#import "BYDeviceInfoModel.h"
#import "BYRelativeModel.h"
#import "EasyNavigation.h"
//#import "BYDeviceDetailHttpTool.h"
#import "BYInstallDemolishHttpTool.h"
#import "NSString+BYAttributeString.h"
#import "BYEditorCarInfoViewController.h"
#import "UILabel+BYCaculateHeight.h"
#import "BYDeviceDetailHttpTool.h"

@interface BYRelationCarController ()

@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,strong) BYSettingGroup * group;

@end

@implementation BYRelationCarController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self initBase];
    [self setupGroup];
    
}

-(void)loadData{
    BYLog(@"%@",self.model);
    BYWeakSelf;
    
    if ([self.model.shareId integerValue]) {
        [BYInstallDemolishHttpTool POSTLoadUsernameByCarNum1:self.model.carId success:^(id data) {
            for (NSDictionary * dict in data) {
                BYRelativeModel * model = [[BYRelativeModel alloc] initWithDictionary:dict error:nil];
                
                BYSettingNoneItem * item = [[BYSettingNoneItem alloc] init];
                NSString * wifiStr = model.wifi ? @"无线" : @"有线";
                item.title = [NSString stringWithFormat:@"关联设备: %@  %@(%@)",model.sn,model.alias,wifiStr];
                
                [weakSelf.dataSource addObject:item];
                
            }
            
            weakSelf.group.items = [weakSelf.dataSource copy];
            [weakSelf.groups removeAllObjects];
            [weakSelf.groups addObject:weakSelf.group];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        } showError:YES];
    }else{
        NSString *carNumStr;
        if (self.model.carNum.length > 0) {
            carNumStr = self.model.carNum;
            //        carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
        }else{
            carNumStr = self.model.carVin;
        }
        [BYInstallDemolishHttpTool POSTLoadUsernameByCarNum:carNumStr success:^(id data) {
            for (NSDictionary * dict in data) {
                BYRelativeModel * model = [[BYRelativeModel alloc] initWithDictionary:dict error:nil];
                
                BYSettingNoneItem * item = [[BYSettingNoneItem alloc] init];
                NSString * wifiStr = model.wifi ? @"无线" : @"有线";
                item.title = [NSString stringWithFormat:@"关联设备: %@  %@(%@)",model.sn,model.alias,wifiStr];
                
                [weakSelf.dataSource addObject:item];
                
            }
            
            weakSelf.group.items = [weakSelf.dataSource copy];
            [weakSelf.groups removeAllObjects];
            [weakSelf.groups addObject:weakSelf.group];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        } showError:YES];
    }
    
   
}

-(void)initBase{
    
    self.BYTableViewCellStyle = UITableViewCellSelectionStyleDefault;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    NSString *carNumStr;
    if (self.model.carId > 0) {
        if (self.model.carNum.length > 0) {
            carNumStr = self.model.carNum;
            carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
        }else{
            carNumStr = self.model.carVin;
        }
    }else{
        carNumStr = @"关联车辆:无关联车辆";
    }
    [self.navigationView setTitle:[NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2]];
    [self.navigationView removeAllRightButton];
    BYWeakSelf;
    if ([BYSaveTool boolForKey:BYEditCarKey]) {
        [self.navigationView addRightButtonWithTitle:@"编辑" clickCallBack:^(UIView *view) {
            BYEditorCarInfoViewController *editCarInfoVC = [[BYEditorCarInfoViewController alloc] init];
            editCarInfoVC.carModel = weakSelf.model;
            [editCarInfoVC setAddCarInfoViewBlock:^(BYDeviceInfoModel *model) {
                weakSelf.model = model;
                [weakSelf loadDataWith:model.deviceId];
                
                
            }];
            [weakSelf.navigationController pushViewController:editCarInfoVC animated:YES];
        }];
    }
    
    if (@available(iOS 11.0, *)) {
        
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        // Fallback on earlier versions
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight)];
    self.tableView.tableHeaderView = head;
}

-(void)loadDataWith:(NSInteger)deviceId{
    
    BYWeakSelf;
    [BYDeviceDetailHttpTool POSTDeviceDetailWithDeviceId:deviceId success:^(id data) {
        
        BYDeviceInfoModel * model = [[BYDeviceInfoModel alloc] initWithDictionary:data error:nil];
//        BYDetailTabBarController * tabBarVC = (BYDetailTabBarController *)self.tabBarController;
//        tabBarVC.model.deviceId = model.deviceId;
//        tabBarVC.model.model = model.model;
//        tabBarVC.model.wifi = model.wifi;
//        tabBarVC.model.sn = model.sn;
//        tabBarVC.model.carId = model.carId;
//        tabBarVC.model.carNum = model.carNum;
//        tabBarVC.model.carVin = model.carVin;
//        model.shareId = tabBarVC.model.shareId;
        self.model = model;
        
//        BYAutoServiceCarModel *carModel = [[BYAutoServiceCarModel alloc] init];
//        carModel.carId = [NSString stringWithFormat:@"%zd",model.carId];
//        carModel.carModel = model.carModel;
//        carModel.carNum = model.carNum;
//        carModel.carVin = model.carVin;
//        carModel.carType = model.carType;
//        carModel.carBrand = model.brand;
//        carModel.carColor = model.carColor;
//        carModel.carOwner = model.ownerName;
//        carModel.carOwnerTel = model.ownerTel;
//        carModel.carGroupId = model.carGroupId;
//        self.autoServiceCarModel = carModel;
        
        [weakSelf loadData];
        [weakSelf initBase];
        [weakSelf setupGroup];
//        dispatch_async(dispatch_get_main_queue(), ^{
////            [weakSelf setupGroupWith:model];
//            [weakSelf.tableView reloadData];
//        });
    } showHUD:YES];
}


-(void)setupGroup{
    [self.dataSource removeAllObjects];
    [self.groups removeAllObjects];
    
    NSString *statusStr;
    
    if (!self.model.wifi) {//有线且启动
       
        statusStr = [self.model.carStatus rangeOfString:@"启动行驶"].location != NSNotFound ? [NSString stringWithFormat:@"  %@ 速度:%.fkm/h",self.model.carStatus,self.model.speed] : [NSString stringWithFormat:@" %@",self.model.carStatus];
        if ([self.model.online rangeOfString:@"离线"].location == NSNotFound) {//在线
            //            self.carStatusLabel.text = [model.carStatus rangeOfString:@"停车"].location != NSNotFound ? model.carStatus : [NSString stringWithFormat:@"  %@ 速度:%.fkm/h",model.carStatus,model.speed];
        }else{
            statusStr = @"";
        }
        
    }else{
        
        if ([self.model.online rangeOfString:@"离线"].location == NSNotFound) {//在线
            
            statusStr = self.model.speed > 0 ? [NSString stringWithFormat:@" 启动行驶 速度:%.fkm/h",self.model.speed] : [NSString stringWithFormat:@"速度: %.fkm/h",self.model.speed];
        }else{
            statusStr= @"";
        }
    }
    
    BYSettingNoneItem * item1 = [[BYSettingNoneItem alloc] init];
    item1.title = [NSString stringWithFormat:@"车辆状态: %@",statusStr];
    
    BYSettingNoneItem * item4 = [[BYSettingNoneItem alloc] init];
    item4.title = [NSString stringWithFormat:@"车架号: %@",self.model.carVin];
    
    BYSettingNoneItem * item5 = [[BYSettingNoneItem alloc] init];
    item5.title = [NSString stringWithFormat:@"所属分组: %@",self.model.groupName];
    
    BYSettingNoneItem * item6 = [[BYSettingNoneItem alloc] init];
    item6.title = [NSString stringWithFormat:@"颜色: %@",self.model.carColor];
    
    
    
    BYSettingNoneItem * item2 = [[BYSettingNoneItem alloc] init];
    
    item2.title = [NSString stringWithFormat:@"车主姓名: %@",[[BYSaveTool valueForKey:BYCarOwnerInfo] boolValue] ? self.model.ownerName : [NSString stringWithFormat:@"%@***",[self.model.ownerName.length>0?self.model.ownerName:@" " substringToIndex:1]]];
    
    BYSettingNoneItem * item3 = [[BYSettingNoneItem alloc] init];
    item3.title = [NSString stringWithFormat:@"车型品牌: %@",self.model.brand.length > 0 ? self.model.brand : @"-"];
    
    BYSettingNoneItem * item7 = [[BYSettingNoneItem alloc] init];
    item7.title = @"合同编号: ";
    item7.subTitle = [NSString stringWithFormat:@"%@",self.model.contractNo.length > 0 ? self.model.contractNo : @""];
    item7.row_H = self.model.contractNo.length > 0 ?  [UILabel caculateLabel_HWith:BYSCREEN_W *3/4 Title:item7.subTitle font:BYS_W_H(17)] : BYS_W_H(20);
//    item7.row_H = [UILabel caculateLabel_HWith:BYSCREEN_W *3/4 Title:item7.subTitle font:BYS_W_H(17)];
    if (self.model.wifi) {
        self.group.items = @[item4,item5,item6,item2,item3,item7];
    }else{
        self.group.items = @[item1,item4,item5,item6,item2,item3,item7];
    }
    
    
    [self.dataSource addObjectsFromArray:self.group.items];
    
    [self.groups addObject:self.group];

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BYSettingGroup *group = self.groups[indexPath.section];
    BYSettingNoneItem *item = group.items[indexPath.row];
    if (self.model.wifi) {
        if (indexPath.section == 0 && indexPath.row == 5 ) {
            //        CGFloat titleH = [UILabel caculateLabel_HWith:SCREEN_WIDTH - 30 Title:item.subTitle font:BYS_T_F(17)];
            return BYS_W_H(item.row_H + 47);
        }
    }else{
        if (indexPath.section == 0 && indexPath.row == 6 ) {
            //        CGFloat titleH = [UILabel caculateLabel_HWith:SCREEN_WIDTH - 30 Title:item.subTitle font:BYS_T_F(17)];
            return BYS_W_H(item.row_H + 47);
        }
    }
    
    return BYS_W_H(47);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - lazy
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(BYSettingGroup *)group{
    if (_group == nil) {
        _group = [[BYSettingGroup alloc] init];
    }
    return _group;
}

@end
