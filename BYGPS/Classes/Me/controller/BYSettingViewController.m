//
//  BYSettingViewController.m
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSettingViewController.h"
#import "BYSettingGroup.h"
#import "BYSettingArrowItem.h"
#import "BYSettingSwitchItem.h"
#import "BYPasswordViewController.h"
#import "BYAlarmSettingController.h"
#import "BYOrderPushViewController.h"
#import "BYPickView.h"
#import "BYCaculateFileSizeTool.h"
#import "EasyNavigation.h"

@interface BYSettingViewController ()

@property(nonatomic,strong)NSArray * durationArr;

@end

@implementation BYSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];

    [self setupGroup];
}
-(void)initBase{
    
    [self.navigationView setTitle:@"设置"];
    self.BYTableViewCellStyle = UITableViewCellStyleSubtitle;
    self.tableView.scrollEnabled = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight)];
    self.tableView.tableHeaderView = head;
    self.durationArr = @[@"10秒",@"30秒",@"1分钟",@"3分钟",@"5分钟"];
}

-(void)setupGroup{
    BYWeakSelf;
    BYSettingGroup * group = [[BYSettingGroup alloc] init];
    
#pragma mark - 监控刷新时间
    BYSettingArrowItem * item1 = [[BYSettingArrowItem alloc] init];
    item1.title = @"监控刷新时间";
    
    NSString * controlDurationStr = [BYSaveTool getRefreshDurationStrWithKey:BYControlRefreshDuration];
    
    item1.subTitle = controlDurationStr;
    
    __weak typeof(item1) weakItem1 = item1;
    [item1 setOperationBlock:^{
        MobClickEvent(@"set_monitoring_time", @"");
        BYPickView * pickView = [[BYPickView alloc] initWithpickViewWith:@"请选择监控刷新间隔" dataSource:weakSelf.durationArr currentTitle:[BYSaveTool getRefreshDurationStrWithKey:BYControlRefreshDuration]];
        
        [pickView setSurePickBlock:^(NSString *currentStr) {
            
            NSInteger index = [weakSelf.durationArr indexOfObject:currentStr];
            NSInteger duration = 0;
            switch (index) {
                case 0: duration = 10; break;
                case 1: duration = 30; break;
                case 2: duration = 60; break;
                case 3: duration = 180; break;
                case 4: duration = 300; break;
                default: break;
            }
            [BYSaveTool setInteger:duration forKey:BYControlRefreshDuration];
            weakItem1.subTitle = currentStr;
            [weakSelf.tableView reloadData];
        }];
    }];
    
#pragma mark - 追踪刷新时间
    BYSettingArrowItem * item2 = [[BYSettingArrowItem alloc] init];
    item2.title = @"追踪刷新时间";
    NSString * trackDurationStr = [BYSaveTool getRefreshDurationStrWithKey:BYTrackRefreshDuration];
    
    item2.subTitle = trackDurationStr;//设置跟踪刷新时间
    
    __weak typeof(item2) weakItem2 = item2;
    [item2 setOperationBlock:^{
        MobClickEvent(@"set_track_time", @"");
        BYPickView * pickView = [[BYPickView alloc] initWithpickViewWith:@"请选择追踪刷新间隔" dataSource:weakSelf.durationArr currentTitle:[BYSaveTool getRefreshDurationStrWithKey:BYTrackRefreshDuration]];
        
        [pickView setSurePickBlock:^(NSString *currentStr) {
            
            NSInteger index = [weakSelf.durationArr indexOfObject:currentStr];
            NSInteger duration = 0;
            switch (index) {
                case 0: duration = 10; break;
                case 1: duration = 30; break;
                case 2: duration = 60; break;
                case 3: duration = 180; break;
                case 4: duration = 300; break;
                default: break;
            }
            [BYSaveTool setInteger:duration forKey:BYTrackRefreshDuration];
            weakItem2.subTitle = currentStr;
            [weakSelf.tableView reloadData];
        }];
    }];
    
//    /*
//    ** Switch
//    */
//    BYSettingSwitchItem * item3 = [[BYSettingSwitchItem alloc] init];
//    item3.title = @"追踪/回放全屏显示";
//    item3.saveKey = mapFullScreen;
//    item3.defaultOn = YES;
//    item3.opration_switch = ^(BOOL isON){
//        BYLog(@"UISwitch状态改变 %d",isON);
//    };
//    BOOL isON = [BYSettingSwitchItem isONSwitchByTitle:item3.saveKey];
//    BYLog(@"是否打开了开关 %d",isON);
    
    
    BYSettingArrowItem * item4 = [[BYSettingArrowItem alloc] init];
    item4.title = @"报警信息设置";
    [item4 setOperationBlock:^{
        MobClickEvent(@"set_alarm", @"");
        if ([BYSaveTool boolForKey:BYIsReadinessKey]) {
            return BYShowError(@"没有报警推送设置权限");
        }
        
        BYAlarmSettingController * alarmSetVC = [[BYAlarmSettingController alloc] init];
        alarmSetVC.isAlarmSetting = YES;
        [weakSelf.navigationController pushViewController:alarmSetVC animated:YES];
    }];
    
    BYSettingArrowItem * item7 = [[BYSettingArrowItem alloc] init];
    item7.title = @"工单推送设置";
    item7.descVc = [BYOrderPushViewController class];
    
    BYSettingArrowItem * item5 = [[BYSettingArrowItem alloc] init];
    item5.title = @"修改密码";
    item5.descVc = [BYPasswordViewController class];
    
    BYSettingArrowItem * item6 = [[BYSettingArrowItem alloc] init];
    item6.title = @"清除缓存";
    item6.subTitle = @"计算中...";
    
    __weak typeof(item6) weakItem6 = item6;
    [item6 setOperationBlock:^{
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"清除缓存" message:@"确定要清除缓存的内容吗" preferredStyle:UIAlertControllerStyleAlert];
        if ([BYObjectTool getIsIpad]){
            
            alert.popoverPresentationController.sourceView = self.view;
            alert.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
        }
        UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction * sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [BYProgressHUD by_showBgViewWithStatus:@"清理中..."];
            //确定删除缓存内容
            [BYCaculateFileSizeTool removeDirectoryPath:nil];
            
            [BYProgressHUD by_showSuccessWithStatus:@"清理完成"];
            
            weakItem6.subTitle = @"0.0KB";
            [self.tableView reloadData];
        }];
        
        [alert addAction:cancel];
        [alert addAction:sure];
        
        [self presentViewController:alert animated:YES completion:nil];
    }];

    //计算检查缓存大小
    [BYCaculateFileSizeTool caculateFileSize:nil completion:^(NSInteger fileSize) {
        BYLog(@"fileSize : %zd",fileSize);
        CGFloat float_size = (CGFloat)fileSize / 1024 / 1024;
        NSString * string_size = float_size >= 1 ? [NSString stringWithFormat:@"%.2fMB",float_size] : [NSString stringWithFormat:@"%.1fKB",float_size * 1024];

        item6.subTitle = string_size;
        
        [self.tableView reloadData];
    }];
    
    group.items = @[item1,item2,item4,item7,item5,item6];
    [self.groups addObject:group];

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UILabel * label = [[UILabel alloc] init];
    label.text = @"    基本设置";
    label.textColor = [UIColor colorWithHex:@"#999999"];
    label.font = BYS_T_F(14);
    
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45;
}

-(void)createPickView{//创建pickView
    
//    _pickView = [[BYPickView alloc] initWithpickViewWith:@"请选择时间间隔" dataSource:@[@"10秒",@"30秒",@"1分钟",@"3分钟",@"5分钟"] currentTitle:nil];
//    
//    [_pickView setSurePickBlock:^(NSString *currentStr) {
//        
//        BYLog(@"%@",currentStr);
//    }];
}

@end
