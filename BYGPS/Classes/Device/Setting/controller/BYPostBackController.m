//
//  BYPostBackController.m
//  BYGPS
//
//  Created by miwer on 16/9/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYPostBackController.h"
#import "BYSettingArrowItem.h"
#import "BYSettingGroup.h"
#import "BYPostBackDurationController.h"
#import "BYPostBackPositionController.h"
#import "BYPostBackContinueController.h"
#import "BYPostBackHeartbeatController.h"
#import "BYOTSPostBackWeekendController.h"
#import "BYMonthPayOffViewController.h"
#import "BYPushNaviModel.h"
#import "BYAlertView.h"
#import "BYDeviceDetailHttpTool.h"
#import "BYSendPostBackParams.h"
#import "EasyNavigation.h"

@interface BYPostBackController ()

@property (assign,nonatomic) BOOL is010;
@property (nonatomic,assign) BOOL is035;
@property (nonatomic,assign) BOOL is029;
@property (nonatomic,strong) BYAlertView *alertView;
@property (nonatomic,strong) BYSendPostBackParams *httpParams;

@end

@implementation BYPostBackController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBase];

    [self setupGroup];
}
-(void)initBase{
    
    [self.navigationView setTitle:@"设置"];
    self.BYTableViewCellStyle = UITableViewCellStyleSubtitle;
    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight + 10)];
    self.tableView.tableHeaderView = head;
    //如果是010设备的话,为真, 其他的话就是013和019
    _is010 = [self.model.model isEqualToString:@"010"] ? YES : NO;
    _is035 = [self.model.model containsString:@"035"] ? YES : NO;
    _is029 = [self.model.model isEqualToString:@"029"] ? YES : NO;
}

-(void)setupGroup{
    
    BYSettingGroup * group = [[BYSettingGroup alloc] init];

    BYSettingArrowItem * item1 = [[BYSettingArrowItem alloc] init];
    item1.title = @"常规模式";
    BYWeakSelf;
    [item1 setOperationBlock:^{
        
        BYPostBackDurationController * postBackDurationVC = [[BYPostBackDurationController alloc] init];
        postBackDurationVC.isWireless = weakSelf.isWireless;
        postBackDurationVC.model = weakSelf.model;
        postBackDurationVC.cmdContent = weakSelf.cmdContent;
        [weakSelf.navigationController pushViewController:postBackDurationVC animated:YES];
    }];

    BYSettingArrowItem * item2 = [[BYSettingArrowItem alloc] init];
    item2.title = @"抓车模式";
    [item2 setOperationBlock:^{
        
        if (_is010) {
            //010抓车模式间隔不能修改，点击弹窗直接发送
            [self.alertView show];

        }else{
            BYPostBackContinueController * postBackContinueVC = [[BYPostBackContinueController alloc] init];
            postBackContinueVC.cmdContent = weakSelf.cmdContent;
            postBackContinueVC.model = weakSelf.model;
            [weakSelf.navigationController pushViewController:postBackContinueVC animated:YES];
        }
    }];

    //如果是010,只有常规模式和抓车模式
    if (_is010) {
        group.items = @[item1,item2];
    }else{//013,013i,019四个模式都有
        
        BYSettingArrowItem * item3 = [[BYSettingArrowItem alloc] init];
        item3.title = @"固定上线时间设置";
        [item3 setOperationBlock:^{
            
            BYPostBackPositionController * postBackPositionVC = [[BYPostBackPositionController alloc] init];
            postBackPositionVC.model = weakSelf.model;
            postBackPositionVC.cmdContent = weakSelf.cmdContent;
            [weakSelf.navigationController pushViewController:postBackPositionVC animated:YES];
        }];
        
        BYSettingArrowItem * item5 = [[BYSettingArrowItem alloc] init];
        item5.title = @"星期模式";
        [item5 setOperationBlock:^{
            BYOTSPostBackWeekendController *otsPostBackWeekendVC = [[BYOTSPostBackWeekendController alloc] init];
            otsPostBackWeekendVC.model = weakSelf.model;
            otsPostBackWeekendVC.cmdContent = weakSelf.cmdContent;
            [weakSelf.navigationController pushViewController:otsPostBackWeekendVC animated:YES];
        }];
        
        BYSettingArrowItem * item6 = [[BYSettingArrowItem alloc] init];
        item6.title = @"月还款模式";
        [item6 setOperationBlock:^{
            BYMonthPayOffViewController *monthPayOffVC = [BYMonthPayOffViewController new];
            monthPayOffVC.model = weakSelf.model;
            monthPayOffVC.cmdContent = weakSelf.cmdContent;
            [weakSelf.navigationController pushViewController:monthPayOffVC animated:YES];
        }];
        
        if ([BYSaveTool boolForKey:heartbeatKey]) {
        
            BYSettingArrowItem * item4 = [[BYSettingArrowItem alloc] init];
            item4.title = @"开启心跳";
            [item4 setOperationBlock:^{
                
                BYPostBackHeartbeatController * postBackHeartbeatVC = [[BYPostBackHeartbeatController alloc] init];
                postBackHeartbeatVC.model = weakSelf.model;
                postBackHeartbeatVC.cmdContent = weakSelf.cmdContent;
                [weakSelf.navigationController pushViewController:postBackHeartbeatVC animated:YES];
            }];
            if (_is035) {
                group.items = @[item1,item2,item3,item5,item4];
            }else if(_is029){
                group.items = @[item1,item2,item3,item4,item6];
            }else{
                group.items = @[item1,item2,item3,item4];
            }
        }else{
            if (_is035) {
                group.items = @[item1,item2,item3,item5];
            }else if(_is029){
                group.items = @[item1,item2,item3,item6];
            }else{
                group.items = @[item1,item2,item3];
            }
        }
    }
    [self.groups addObject:group];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return BYS_W_H(60);
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    
    return @"* 回传间隔只可选择一个进行设置，心跳间隔除外\n* 设置成功以后会覆盖其他回传模式";
}

#pragma mark - lazy
-(BYAlertView *)alertView{
    if (_alertView == nil) {
        _alertView = [BYAlertView viewFromNibWithTitle:@"抓车模式" message:nil];
        _alertView.alertHeightContraint.constant = BYS_W_H(80 + 40) + 81 + 10;
        _alertView.alertWidthContraint.constant = BYS_W_H(220);
        _alertView.contentView.by_width = BYS_W_H(220);
        
        BYWeakSelf;
        [_alertView setSureBlock:^{
            weakSelf.httpParams.content = @"60";
            [BYDeviceDetailHttpTool POSTSendPostBackWithParams:weakSelf.httpParams success:^{
                
            }];
        }];
        
        [_alertView setCancelBlock:^{
            _alertView = nil;
        }];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.frame = _alertView.contentView.bounds;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 0;
        titleLabel.tintColor = BYGlobalTextGrayColor;
        titleLabel.font = BYS_T_F(13);
        titleLabel.text = @"*设置抓车模式后，设备将一直持续1分钟上报一次定位";
        [_alertView.contentView addSubview:titleLabel];
    }
    return _alertView;
}

-(BYSendPostBackParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYSendPostBackParams alloc] init];
        _httpParams.deviceId = self.model.deviceId;
        _httpParams.model = self.model.model;
        _httpParams.type = 1;
        _httpParams.mold = 2;
    }
    return _httpParams;
}




@end
