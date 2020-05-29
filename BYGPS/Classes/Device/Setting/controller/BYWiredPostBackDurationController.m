//
//  BYWiredPostBackDurationController.m
//  BYGPS
//
//  Created by ZPD on 2017/6/23.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYWiredPostBackDurationController.h"
#import "BYPostBackModel.h"
#import "BYPostBackFooterView.h"
#import "BYAlertView.h"
#import "BYDuratrionTypeView.h"
#import "BYSendPostBackParams.h"
#import "BYDeviceDetailHttpTool.h"
#import "BYPushNaviModel.h"
#import "BYNormalDurationCell.h"
#import "EasyNavigation.h"


@interface BYWiredPostBackDurationController ()
@property(nonatomic,strong) BYAlertView * alertView;
@property(nonatomic,strong) NSMutableArray * dataSorce;
@property(nonatomic,assign) NSInteger selectDurationType;
@property(nonatomic,strong) BYSendPostBackParams * httpParams;

@end

@implementation BYWiredPostBackDurationController

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.cmdContent = @"1440#3600#003c#";

    [self initBase];
}
/**
 *  常规模式        :   #3600## [3600->回传间隔时间(s)]
 *  抓车模式(追踪)    :  10#60## [5->持续时间(min),60(默认一分钟)->回传间隔时间(s)]（有线的车辆启动时上报间隔）5s -15s - 14400s 默认15秒
 *  固定回传点       :   ###09441544 [09点44分]
 *  心跳间隔        :   ##001e# [16进制]
 *  取消心跳        :   ##0000#
 */
-(void)getDetailWithCmdContent{
    
    NSString * lastTwoStr = [self.cmdContent substringFromIndex:self.cmdContent.length - 2];//指令最后两个字母,判断是不是##
    NSString * fisrtStr = [self.cmdContent substringToIndex:1];//判断第一个字母是不是#
    
//    判断是不是常规模式下的回传间隔
    if ((![fisrtStr isEqualToString:@"#"]) && [lastTwoStr isEqualToString:@"##"]) {
    
        NSArray * tempArr = [self.cmdContent componentsSeparatedByString:@"#"];
        
        //回传间隔
        NSInteger duration = [tempArr[0] integerValue];
        NSString * selectTypeStr = nil;
        
        if (duration == 5) {//5秒
            self.selectDurationType = 0;
            selectTypeStr = @"5秒一次";
        }else if (duration ==15 ){//15秒一次
            self.selectDurationType = 1;
            selectTypeStr = @"15秒一次";
        }else{//间隔为其他时间
            self.selectDurationType = 2;
            selectTypeStr = [NSString stringWithFormat:@"每%zd秒一次",duration];
        }
        
        BYPostBackModel * model = [BYPostBackModel createModelWith:@"回传间隔时间" detail:tempArr[1] placeholder:selectTypeStr unit:nil];
        [self.dataSorce addObject:model];
    }else{
        
        self.selectDurationType = 1;//设置默认为tag=1,15秒一次
        BYPostBackModel * model = [BYPostBackModel createModelWith:@"回传间隔时间" detail:@"15" placeholder:@"15秒一次" unit:nil];
        [self.dataSorce addObject:model];
    }
}

-(void)initBase{
    
    [self.navigationView setTitle:@"车辆启动时上报间隔"];
    self.view.backgroundColor = BYGlobalBg;
//    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);

    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight + 10)];
    self.tableView.tableHeaderView = head;
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
        
        self.httpParams.content = model.detail;
        
        [BYDeviceDetailHttpTool POSTSendPostBackWithParams:self.httpParams success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
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
-(BYAlertView *)alertView{
    if (_alertView == nil) {
        _alertView = [BYAlertView viewFromNibWithTitle:@"回传间隔" message:nil];
        _alertView.alertHeightContraint.constant = BYS_W_H(80 + 40) + 81 + 10;
        _alertView.alertWidthContraint.constant = BYS_W_H(220);
        
        BYDuratrionTypeView * typeView = [BYDuratrionTypeView by_viewFromXib];
        [typeView.firstBtn setTitle:@"5秒一次" forState:UIControlStateNormal];
        [typeView.secondBtn setTitle:@"15秒一次" forState:UIControlStateNormal];
        typeView.textField.placeholder = @"车辆启动时上报间隔(秒)";
        typeView.frame = _alertView.contentView.bounds;
        typeView.selectType = self.selectDurationType;
        
        if (self.selectDurationType == 2) {
            
            BYPostBackModel * model = [self.dataSorce firstObject];
            
            typeView.textField.placeholder = [NSString stringWithFormat:@"已设置为%zd秒",model.detail.integerValue];
            typeView.textFieldBgViewContraint_H.constant = BYS_W_H(40);
            _alertView.alertHeightContraint.constant = BYS_W_H(80 + 40 + 40) + 81 + 10;
        }
        
        __weak typeof(typeView) weakTypeView = typeView;
        __weak typeof(_alertView) weakAlertView = _alertView;
        BYWeakSelf;
        [typeView setDurationTypeBlock:^(NSInteger tag, BOOL isSelect) {
            weakSelf.selectDurationType = tag;
            
            if (tag == 2 && isSelect == YES) {
                
                weakTypeView.textFieldBgViewContraint_H.constant = BYS_W_H(40);
                weakAlertView.alertHeightContraint.constant = BYS_W_H(80 + 40 + 40) + 81 + 10;
            }else{
                weakTypeView.textFieldBgViewContraint_H.constant = 0;
                weakAlertView.alertHeightContraint.constant = BYS_W_H(80 + 40) + 81 + 10;
                [weakTypeView.textField resignFirstResponder];
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                [weakTypeView layoutIfNeeded];
                [weakAlertView layoutIfNeeded];
            }];
        }];
        
        [_alertView setSureBlock:^{
            
            BYPostBackModel * model = [weakSelf.dataSorce firstObject];
            switch (weakSelf.selectDurationType) {
                case 0: {
                    model.palceholder = @"5秒一次";
                    model.detail = @"5";
                } break;
                case 1: {
                    model.palceholder = @"15秒一次";
                    model.detail = @"15";
                } break;
                case 2: {
                    
                    NSInteger duration = [typeView.textField.text integerValue];
                    
                    //010设备最多设置1天回传间隔,其他30天
                    BOOL is010 = [weakSelf.model.model isEqualToString:@"010"];
                    NSInteger topLimit = is010 ? 14400 : 14400;
                    if (duration <= 0 || duration > topLimit) {
                        return [BYProgressHUD by_showErrorWithStatus:[NSString stringWithFormat:@"回传间隔须大于0秒和小于等于%zd秒",is010 ? 14400 : 14400]];
                    }
                    
                    model.palceholder = [NSString stringWithFormat:@"每%zd秒一次",duration];
                    model.detail = [NSString stringWithFormat:@"%zd",duration];//将分钟转化为秒
                    
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
        _httpParams.mold = self.model.wifi ? 1: 0;
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
