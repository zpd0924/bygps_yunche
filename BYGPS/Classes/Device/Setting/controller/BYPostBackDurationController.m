//
//  BYPostBackDurationController.m
//  BYGPS
//
//  Created by miwer on 16/7/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYPostBackDurationController.h"
#import "BYPostBackModel.h"
#import "BYPostBackFooterView.h"
#import "BYAlertView.h"
#import "BYDuratrionTypeView.h"
#import "BYSendPostBackParams.h"
#import "BYDeviceDetailHttpTool.h"
#import "BYPushNaviModel.h"
#import "BYNormalDurationCell.h"
#import "EasyNavigation.h"
#import "BY036DurationTypeView.h"
#import "BY036DurationModel.h"

@interface BYPostBackDurationController ()

@property(nonatomic,strong) BYAlertView * alertView;
@property(nonatomic,strong) NSMutableArray * dataSorce;
@property(nonatomic,assign) NSInteger selectDurationType;
@property(nonatomic,strong) BYSendPostBackParams * httpParams;
@property (nonatomic,assign) BOOL is036;
@property (nonatomic,assign) BOOL is029;
@property (nonatomic,strong) NSMutableArray *durationArr;

@end

@implementation BYPostBackDurationController


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
 *  抓车模式(追踪)    :  10#60## [5->持续时间(min),60(默认一分钟)->回传间隔时间(s)]
 *  固定回传点       :   ###09441544 [09点44分]
 *  心跳间隔        :   ##001e# [16进制]
 *  取消心跳        :   ##0000#
 */
-(void)getDetailWithCmdContent{
    
    NSString * lastTwoStr = [self.cmdContent substringFromIndex:self.cmdContent.length - 2];//指令最后两个字母,判断是不是##
    NSString * fisrtStr = [self.cmdContent.length>0?self.cmdContent:@" " substringToIndex:1];//判断第一个字母是不是#
    
    //判断是不是常规模式下的回传间隔
    if ([fisrtStr isEqualToString:@"#"] && [lastTwoStr isEqualToString:@"##"] && self.cmdContent.length > 4) {
        if (_is026) {
            NSArray * tempArr = [self.cmdContent componentsSeparatedByString:@"#"];
            
            //回传间隔
            NSInteger duration = [tempArr[1] integerValue];
            NSString * selectTypeStr = nil;
            
            if (duration == 1 * 24 * 60 * 60) {//一天
                self.selectDurationType = 0;
                selectTypeStr = @"一天一次";
            }else if (duration ==7 * 24 * 60 * 60){//一小时一次
                self.selectDurationType = 1;
                selectTypeStr = @"一周一次";
            }else{//间隔为其他时间
                self.selectDurationType = 2;
                
                selectTypeStr = [self handleDurationWith:duration / 60];
            }
            
            BYPostBackModel * model = [BYPostBackModel createModelWith:@"回传间隔时间" detail:tempArr[1] placeholder:selectTypeStr unit:@"分钟"];
            [self.dataSorce addObject:model];
        }else{
            NSArray * tempArr = [self.cmdContent componentsSeparatedByString:@"#"];
            
            //回传间隔
            NSInteger duration = [tempArr[1] integerValue];
            NSString * selectTypeStr = nil;
            
            if (duration == 1 * 24 * 60 * 60) {//一天
                self.selectDurationType = 1;
                selectTypeStr = @"一天一次";
            }else if (duration == 60 * 60){//一小时一次
                self.selectDurationType = 0;
                selectTypeStr = @"一小时一次";
            }else{//间隔为其他时间
                self.selectDurationType = 2;
                
                selectTypeStr = [self handleDurationWith:duration / 60];
            }
            
            BYPostBackModel * model = [BYPostBackModel createModelWith:@"回传间隔时间" detail:tempArr[1] placeholder:selectTypeStr unit:nil];
            [self.dataSorce addObject:model];
        }
    }else{
        if (_is036) {
            self.selectDurationType = 0;//设置默认为tag=1,一天一次
            BYPostBackModel * model = [BYPostBackModel createModelWith:@"回传间隔时间" detail:@"3600" placeholder:@"1小时" unit:nil];
            [self.dataSorce addObject:model];
        }else{
            self.selectDurationType = _is026 ? 0 : 1;//设置默认为tag=1,一天一次
            BYPostBackModel * model = [BYPostBackModel createModelWith:@"回传间隔时间" detail:@"86400" placeholder:@"一天一次" unit:nil];
            [self.dataSorce addObject:model];
        }
    }
}

-(void)initBase{

    [self.navigationView setTitle:self.isWireless ? @"常规模式" : @"车辆启动时上报间隔"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.view.backgroundColor = BYGlobalBg;
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight +10)];
    self.tableView.tableHeaderView = head;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYNormalDurationCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    
    _is036 = [self.model.model isEqualToString:@"036"] || [self.model.model isEqualToString:@"033"];
    _is029 = [self.model.model isEqualToString:@"029"];
    [self getDetailWithCmdContent];//将回传间隔记录显示到发送回传间隔指令上

    NSArray *titleArr = @[@"1小时",@"2小时",@"3小时",@"4小时",@"6小时",@"8小时",@"12小时",@"1天",@"2天",@"3天",@"4天",@"5天",@"6天",@"7天",@"8天",@"9天",@"10天",@"11天",@"12天",@"13天",@"14天",@"15天"];
    
    NSArray *durationData = @[@"3600",@"7200",@"10800",@"14400",@"21600",@"28800",@"43200",@"86400",@"172800",@"259200",@"345600",@"432000",@"518400",@"604800",@"691200",@"777600",@"864000",@"950400",@"1036800",@"1123200",@"1209600",@"1296000"];
    for (NSInteger i = 0 ; i < titleArr.count; i ++) {
        BY036DurationModel *model = [[BY036DurationModel alloc] init];
        model.title = titleArr[i];
        model.duration = durationData[i];
        if (i == 0) {
            model.seleted = YES;
        }
        [self.durationArr addObject:model];
    }
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
                BYLog(@"%@",self.navigationController);
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
-(BYAlertView *)alertView{
    if (_alertView == nil) {
        _alertView = [BYAlertView viewFromNibWithTitle:@"回传间隔" message:nil];
        _alertView.alertHeightContraint.constant = BYS_W_H(80 + 40) + 81 + 10;
        _alertView.alertWidthContraint.constant = BYS_W_H(220);
        BYWeakSelf;
        if (_is036) {
            _alertView.alertHeightContraint.constant = BYS_W_H(300);
            BY036DurationTypeView * typeView036 = [[BY036DurationTypeView alloc] initWithFrame:CGRectMake(0, 0, BYS_W_H(220), BYS_W_H(220))];
            typeView036.dataSource = self.durationArr;
            
            [typeView036 setDurationTypeSelectedBlock:^(NSInteger tag, BOOL isSelect) {
                self.selectDurationType = tag;
            }];
            
            [_alertView setSureBlock:^{
                _alertView = nil;
                
                for (BY036DurationModel *model in weakSelf.durationArr) {
                    model.seleted = NO;
                }
                
                
                BYPostBackModel * model = [weakSelf.dataSorce firstObject];
                BY036DurationModel *durationModel = weakSelf.durationArr[weakSelf.selectDurationType];
                model.palceholder = durationModel.title;
                model.detail = durationModel.duration;
                durationModel.seleted = YES;
                [weakSelf.tableView reloadData];
            }];
            
            [_alertView setCancelBlock:^{
                _alertView = nil;
            }];
            
            [_alertView.contentView addSubview:typeView036];
            return _alertView;
        }
        
        
        BYDuratrionTypeView * typeView = [BYDuratrionTypeView by_viewFromXib];
        typeView.frame = _alertView.contentView.bounds;
        typeView.selectType = self.selectDurationType;
        typeView.textField.placeholder = _is026 ? @"回传间隔时间(天)" : @"回传间隔时间(分钟)";
        if (_is026) {
            [typeView.firstBtn setTitle:@"一天一次" forState:UIControlStateNormal];
            [typeView.secondBtn setTitle:@"一周一次" forState:UIControlStateNormal];
        }
        
        if (self.selectDurationType == 2) {
            
            BYPostBackModel * model = [self.dataSorce firstObject];

            typeView.textField.placeholder =_is026 ? [NSString stringWithFormat: @"已设置为%zd天",model.detail.integerValue / (60*60*24)] : [NSString stringWithFormat: @"已设置为%zd分钟",model.detail.integerValue / 60];
            typeView.textFieldBgViewContraint_H.constant = BYS_W_H(40);
            _alertView.alertHeightContraint.constant = BYS_W_H(80 + 40 + 40) + 81 + 10;
        }
        
        __weak typeof(typeView) weakTypeView = typeView;
        __weak typeof(_alertView) weakAlertView = _alertView;
//        BYWeakSelf;
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
            _alertView = nil;
            BYPostBackModel * model = [weakSelf.dataSorce firstObject];
            switch (weakSelf.selectDurationType) {
                case 0: {
                    model.palceholder = weakSelf.is026 ? @"一天一次" : @"一小时一次";
                    model.detail = weakSelf.is026 ? @"86400": @"3600";
                } break;
                case 1: {
                    model.palceholder = weakSelf.is026 ? @"一周一次" : @"一天一次";
                    model.detail = weakSelf.is026 ? @"604800" : @"86400";
                } break;
                case 2: {
                    
                    NSInteger duration = [typeView.textField.text integerValue];
                    
                    //010设备最多设置1天回传间隔,其他30天 026 最小1天最大90天 029 最小60分 最大30天
                    
                    BOOL is010 = [weakSelf.model.model isEqualToString:@"010"];
                    if (weakSelf.is026) {
                        NSInteger topLimit = 90;
                        if (duration < 1 || duration > topLimit) {
                            return [BYProgressHUD by_showErrorWithStatus:@"常规模式回传间隔范围为1天～90天"];
                        }

                        model.detail = [NSString stringWithFormat:@"%zd",duration * 24 * 60 * 60];//将天转化为秒
                        model.palceholder = [weakSelf handleDurationWith:duration * 24 * 60];
                    }else if(weakSelf.is029){
                        NSInteger topLimit = 30 * 24 * 60;
                        if (duration < 60 || duration > topLimit) {
                            return [BYProgressHUD by_showErrorWithStatus:@"回传间隔须大于60分钟和小于30天"];
                        }
                        
                        model.palceholder = [weakSelf handleDurationWith:duration];
                        
                        model.detail = [NSString stringWithFormat:@"%zd",duration * 60];//将分钟转化为秒
                    }else{
                        NSInteger topLimit = is010 ? 1440 : 30 * 24 * 60;
                        if (duration < 30 || duration > topLimit) {
                            return [BYProgressHUD by_showErrorWithStatus:[NSString stringWithFormat:@"回传间隔须大于30分钟和小于%zd天",is010 ? 1 : 30]];
                        }
                        
                        model.palceholder = [weakSelf handleDurationWith:duration];
                        
                        model.detail = [NSString stringWithFormat:@"%zd",duration * 60];//将分钟转化为秒
                    }
                    
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

-(NSMutableArray *)durationArr
{
    if (!_durationArr) {
        _durationArr = [NSMutableArray array];
    }
    return _durationArr;
}

-(BYSendPostBackParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYSendPostBackParams alloc] init];
        _httpParams.deviceId = self.model.deviceId;
        _httpParams.model = self.model.model;
        _httpParams.type = 1;
        _httpParams.mold = 1;
        
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









