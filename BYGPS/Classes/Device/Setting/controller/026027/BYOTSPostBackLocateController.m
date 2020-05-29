//
//  BYOTSPostBackLocateController.m
//  BYGPS
//
//  Created by ZPD on 2017/6/28.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYOTSPostBackLocateController.h"
#import "BYPostBackModel.h"
#import "BYPostBackFooterView.h"
#import "BYAlertView.h"
#import "BYDuratrionTypeView.h"
#import "BYSendPostBackParams.h"
#import "BYDeviceDetailHttpTool.h"
#import "BYPushNaviModel.h"
#import "BYNormalDurationCell.h"
#import "EasyNavigation.h"


@interface BYOTSPostBackLocateController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) BYAlertView * alertView;
@property(nonatomic,strong) NSMutableArray * dataSorce;
@property(nonatomic,assign) NSInteger selectDurationType;
@property(nonatomic,strong) BYSendPostBackParams * httpParams;
@property (nonatomic,strong) UITableView *tableView;


@end

@implementation BYOTSPostBackLocateController

//- (instancetype)init
//{
//    return [self initWithStyle:UITableViewStyleGrouped];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.cmdContent = @"1440#3600#003c#";
    [self initBase];
}
/**
 *  常规模式        :   #3600## [3600->回传间隔时间(s)]
 *  抓车模式(追踪)    :  10#60## [5->持续时间(min),60(默认一分钟)->回传间隔时间(s)]
 *  固定回传点       :   ###09441544 [09点44分]
 *  心跳间隔        :   ##001e# [16进制]
 *  取消心跳        :   ##0000#
 *  定位模式。      ：#1#
 *
 */

//定位模式指令不明 暂时无法判断
-(void)getDetailWithCmdContent{
    
    NSString * fisrtStr = [self.cmdContent substringToIndex:1];//判断第一个字母是不是#判断最后一位是不是#
    NSString * lastStr = [self.cmdContent substringFromIndex:self.cmdContent.length - 1];
    
    //判断是不是常规模式下的定位模式
    if ([fisrtStr isEqualToString:@"#"] && [lastStr isEqualToString:@"#"] && self.cmdContent.length == 3) {
        
        NSArray * tempArr = [self.cmdContent componentsSeparatedByString:@"#"];
        
        //回传间隔
        NSInteger duration = [tempArr[1] integerValue];
        NSString * selectTypeStr = nil;
        //默认 基站+wifi 基站+GPS + Wi-Fi
        if (duration == 0) {//默认
            self.selectDurationType = 0;
            selectTypeStr = @"默认";
        }else if (duration == 1){//基站+wifi
            self.selectDurationType = 1;
            selectTypeStr = @"基站+wifi";
        }else{//间隔为其他时间
            self.selectDurationType = 2;
            selectTypeStr = @"基站+GPS+wifi";
        }
        
        BYPostBackModel * model = [BYPostBackModel createModelWith:@"请选择设置定位模式" detail:tempArr[1] placeholder:selectTypeStr unit:nil];
        [self.dataSorce addObject:model];
    }else{
    
        self.selectDurationType = 1;//设置默认为tag=1,一天一次
        BYPostBackModel * model = [BYPostBackModel createModelWith:@"请选择设置定位模式" detail:@"1" placeholder:@"基站+wifi" unit:nil];
        [self.dataSorce addObject:model];
    }
}

-(void)initBase{
    [self.navigationView setTitle:@"定位模式设置"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
//    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 74)];
//    self.tableView.tableHeaderView = head;
    
//    self.navigationItem.title = @"定位模式设置";
    self.view.backgroundColor = BYGlobalBg;
    self.tableView.contentInset = UIEdgeInsetsMake(SafeAreaTopHeight, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYNormalDurationCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
//    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    
    [self getDetailWithCmdContent];//将回传间隔记录显示到发送回传间隔指令上
    
    //  添加观察者，监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYNormalDurationCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BYPostBackModel * model = self.dataSorce[indexPath.row];
    cell.title = model.title;
    cell.subTitle = model.palceholder;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSorce.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    BYPostBackFooterView * footer = [BYPostBackFooterView by_viewFromXib];
    
    [footer setSureActionBlock:^{
        
        BYPostBackModel * model = self.dataSorce.firstObject;
        
//        self.httpParams.points = 8;
        self.httpParams.content = model.detail;
        
        [BYDeviceDetailHttpTool POSTSendPostBackWithParams:self.httpParams success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController popToViewController:self animated:YES];
            });
        }];
    }];
    
    return footer;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.alertView show];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BYS_W_H(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return BYS_W_H(40) + 80 + 50;
}

#pragma mark - lazy

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, BYSCREEN_H) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(BYAlertView *)alertView{
    if (_alertView == nil) {
        _alertView = [BYAlertView viewFromNibWithTitle:@"定位模式" message:nil];
        _alertView.alertHeightContraint.constant = BYS_W_H(80 + 40) + 81 + 10;
        _alertView.alertWidthContraint.constant = BYS_W_H(220);
        
        BYDuratrionTypeView * typeView = [BYDuratrionTypeView by_viewFromXib];
        typeView.frame = _alertView.contentView.bounds;
        typeView.selectType = self.selectDurationType;
 //默认 基站+wifi 基站+GPS + Wi-Fi
        [typeView.firstBtn setTitle:@"默认" forState:UIControlStateNormal];
        [typeView.secondBtn setTitle:@"基站+wifi" forState:UIControlStateNormal];
        [typeView.otherBtn setTitle:@"基站+GPS+wifi" forState:UIControlStateNormal];

        BYWeakSelf;
        [typeView setDurationTypeBlock:^(NSInteger tag, BOOL isSelect) {
            weakSelf.selectDurationType = tag;
        }];
        
        [_alertView setSureBlock:^{
            
            BYPostBackModel * model = [weakSelf.dataSorce firstObject];
            switch (weakSelf.selectDurationType) {
                case 0: {
                    model.palceholder = @"默认";
                    model.detail = @"0";
                } break;
                case 1: {
                    model.palceholder = @"基站+wifi";
                    model.detail = @"1";
                } break;
                case 2: {
                    model.palceholder = @"基站+GPS+wifi";
                    model.detail = @"2";
                } break;
            }
            
            [weakSelf.tableView reloadData];
            
        }];
        
        [_alertView setCancelBlock:^{
            _alertView = nil;
        }];
        
        [_alertView.contentView addSubview:typeView];
    }
    return _alertView;
}

-(NSString *)handleDurationWith:(NSInteger)duration{
    NSString * result = nil;
    if (duration < 60){//一小时之内
        result = [NSString stringWithFormat:@"每%zd分钟一次",duration];
    }else if(duration < 1440){//一天之内
        result = duration % 60 == 0 ? [NSString stringWithFormat:@"每%zd小时一次",duration / 60] : [NSString stringWithFormat:@"每%zd小时%zd分一次",duration / 60, duration % 60];
    }else{//一天以上
        NSInteger days = duration / 1440;
        NSInteger mins = duration % 1440;
        if (mins == 0) {//如果是整天
            result = [NSString stringWithFormat:@"每%zd天一次",days];
        }else{//如果不是整天
            if (mins < 60) {
                result = [NSString stringWithFormat:@"每%zd天%zd分钟一次",days,mins];
            }else{
                result = duration % 60 == 0 ? [NSString stringWithFormat:@"每%zd天%zd小时一次",days,mins / 60] : [NSString stringWithFormat:@"每%zd天%zd小时%zd分一次",days, mins / 60, mins % 60];
            }
        }
    }
    return result;
}

-(NSMutableArray *)dataSorce{
    if (_dataSorce == nil) {
        _dataSorce = [[NSMutableArray alloc] init];
    }
    return _dataSorce;
}

-(BYSendPostBackParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYSendPostBackParams alloc] init];
        _httpParams.deviceId = self.model.deviceId;
        _httpParams.model = self.model.model;
        _httpParams.type = 1;
        _httpParams.mold = 8;

    }
    return _httpParams;
}

- (void)keyBoardDidShow:(NSNotification*)notifiction {
    
    if (self.alertView && self.alertView.alert.by_centerY == BYSCREEN_H / 2) {
        
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notifiction.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        CGRect frame = self.alertView.alert.frame;
        frame.origin.y -= BYTextFieldPullUpHeight;
        [UIView animateWithDuration:duration animations:^{
            
            self.alertView.alert.frame = frame;
        }];
    }
}

- (void)keyBoardDidHide:(NSNotification*)notification {
    if (self.alertView) {
        
        CGRect frame = self.alertView.alert.frame;
        frame.origin.y += BYTextFieldPullUpHeight;
        [UIView animateWithDuration:0.1 animations:^{
            
            self.alertView.alert.frame = frame;
        }];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
