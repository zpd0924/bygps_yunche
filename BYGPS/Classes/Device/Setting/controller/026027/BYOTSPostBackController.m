//
//  BYOTSPostBackController.m
//  BYGPS
//
//  Created by ZPD on 2017/6/28.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYOTSPostBackController.h"
#import "BYSettingArrowItem.h"
#import "BYSettingGroup.h"
#import "BYPostBackDurationController.h"
#import "BYPostBackPositionController.h"
#import "BYOTSPostBackPositionController.h"
#import "BYPostBackContinueController.h"
#import "BYOTSPostBackContinueController.h"
#import "BYOTSPostBackWeekendController.h"
#import "BYPostBackHeartbeatController.h"
#import "BYPushNaviModel.h"
#import "EasyNavigation.h"

#import "BYOTSPostBackLocateController.h"


@interface BYOTSPostBackController ()

@property (assign,nonatomic) BOOL is010;
@property (nonatomic,assign) BOOL is026;
@property (nonatomic,assign) BOOL is027;

@end

@implementation BYOTSPostBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    
    [self setupGroup];
}
-(void)initBase{
    [self.navigationView setTitle:@"设置"];
    self.BYTableViewCellStyle = UITableViewCellStyleSubtitle;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.tableView.contentInset = UIEdgeInsetsMake(SafeAreaTopHeight, 0, 0, 0);
//    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 74)];
//    self.tableView.tableHeaderView = head;
    
    //如果是010设备的话,为真, 其他的话就是013和019
    _is010 = [self.model.model isEqualToString:@"010"] ? YES : NO;
    _is026 = [self.model.model containsString:@"026"] ? YES : NO;
    _is027 = [self.model.model containsString:@"027"] ? YES : NO;
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
        postBackDurationVC.is026 = weakSelf.is026;
        postBackDurationVC.cmdContent = weakSelf.cmdContent;
        [weakSelf.navigationController pushViewController:postBackDurationVC animated:YES];
    }];
    
    BYSettingArrowItem * item2 = [[BYSettingArrowItem alloc] init];
    item2.title = @"抓车模式";
    [item2 setOperationBlock:^{
        if (_is026) {
            BYOTSPostBackContinueController * postBackContinueVC = [[BYOTSPostBackContinueController alloc] init];
            postBackContinueVC.cmdContent = weakSelf.cmdContent;
            postBackContinueVC.model = weakSelf.model;
            [weakSelf.navigationController pushViewController:postBackContinueVC animated:YES];
        }
        if(_is027){
            BYPostBackContinueController * postBackContinueVC = [[BYPostBackContinueController alloc] init];
            postBackContinueVC.cmdContent = weakSelf.cmdContent;
            postBackContinueVC.is027 = _is027;
            postBackContinueVC.model = weakSelf.model;
            [weakSelf.navigationController pushViewController:postBackContinueVC animated:YES];
        }
        
    }];
    
    //如果是010,只有常规模式和抓车模式
//013,013i,019四个模式都有  026 4个模式 常规、抓车、固定上线时间、定位和027 抓车，固定上线时间、星期模式
    
    BYSettingArrowItem * item3 = [[BYSettingArrowItem alloc] init];
    item3.title = @"固定上线时间设置";
    [item3 setOperationBlock:^{
        
        BYOTSPostBackPositionController * otsPostBackPositionVC = [[BYOTSPostBackPositionController alloc] init];
        otsPostBackPositionVC.model = weakSelf.model;
        otsPostBackPositionVC.cmdContent = weakSelf.cmdContent;
        otsPostBackPositionVC.contentType = weakSelf.contentType;
        [weakSelf.navigationController pushViewController:otsPostBackPositionVC animated:YES];
    }];
    
    BYSettingArrowItem * item4 = [[BYSettingArrowItem alloc] init];
    item4.title = @"定位模式";
    [item4 setOperationBlock:^{
        BYOTSPostBackLocateController *otsPostBackLocateVC = [[BYOTSPostBackLocateController alloc] init];
        otsPostBackLocateVC.model = weakSelf.model;
        otsPostBackLocateVC.cmdContent = weakSelf.cmdContent;
        [weakSelf.navigationController pushViewController:otsPostBackLocateVC animated:YES];
    }];
    
    BYSettingArrowItem * item5 = [[BYSettingArrowItem alloc] init];
    item5.title = @"星期模式";
    [item5 setOperationBlock:^{
        BYOTSPostBackWeekendController *otsPostBackWeekendVC = [[BYOTSPostBackWeekendController alloc] init];
        otsPostBackWeekendVC.model = weakSelf.model;
        otsPostBackWeekendVC.cmdContent = weakSelf.cmdContent;
        [weakSelf.navigationController pushViewController:otsPostBackWeekendVC animated:YES];
    }];
    
    if (_is026) {
        group.items = @[item1,item2,item3,item4];
    }
    if(_is027){
        group.items = @[item2,item3,item5];
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
    
    return @"*回传间隔只可选择一个进行设置\n*设置成功后会覆盖其他回传模式";
}
@end
