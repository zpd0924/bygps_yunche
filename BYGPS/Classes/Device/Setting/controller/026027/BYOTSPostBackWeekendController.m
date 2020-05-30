//
//  BYOTSPostBackWeekendController.m
//  BYGPS
//
//  Created by ZPD on 2017/6/29.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYOTSPostBackWeekendController.h"
#import "BYPostBackModel.h"
#import "BYPostBackFooterView.h"
#import "BYSendPostBackParams.h"
#import "BYDeviceDetailHttpTool.h"
#import "BYPostBackPositionCell.h"
#import "BYPushNaviModel.h"
#import "BYOTSWeakCell.h"
#import "BYPickView.h"
#import "BYSettingGroup.h"
#import "EasyNavigation.h"

@interface BYOTSPostBackWeekendController ()
@property(nonatomic,strong) NSMutableArray * dataSorce;
@property(nonatomic,assign) NSInteger selectDurationType;
@property(nonatomic,strong) BYSendPostBackParams * httpParams;
@property (nonatomic,strong) BYSettingGroup *group;

@end

@implementation BYOTSPostBackWeekendController

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
//新增027星期模式：（指令未知）##1，3，7#24:00
//判断指令是不是抓车
-(void)getDetailWithCmdContent{
    
    BYSettingGroup *group1 = [[BYSettingGroup alloc] init];
    
    BYPostBackModel * model1 = [BYPostBackModel createModelWith:@"星期一" detail:nil placeholder:nil unit:nil];
    BYPostBackModel * model2 = [BYPostBackModel createModelWith:@"星期二" detail:nil placeholder:nil unit:nil];
    BYPostBackModel * model3 = [BYPostBackModel createModelWith:@"星期三" detail:nil placeholder:nil unit:nil];
    BYPostBackModel * model4 = [BYPostBackModel createModelWith:@"星期四" detail:nil placeholder:nil unit:nil];
    BYPostBackModel * model5 = [BYPostBackModel createModelWith:@"星期五" detail:nil placeholder:nil unit:nil];
    BYPostBackModel * model6 = [BYPostBackModel createModelWith:@"星期六" detail:nil placeholder:nil unit:nil];
    BYPostBackModel * model7 = [BYPostBackModel createModelWith:@"星期日" detail:nil placeholder:nil unit:nil];
    
    group1.items = @[model1,model2,model3,model4,model5,model6,model7];
    
    BYPostBackModel * model8 = [BYPostBackModel createModelWith:@"固定上线时间点" detail:nil placeholder:@"12:00" unit:nil];
    
    NSString * lastThreeStr = [self.cmdContent substringFromIndex:self.cmdContent.length - 3];
    NSString * dotStr = [lastThreeStr.length>0?lastThreeStr:@" " substringToIndex:1];
    NSString * fisrtTwoStr = [self.cmdContent.length>1?self.cmdContent:@"  " substringToIndex:2];//判断前2个字母是不是##
    
    if ([dotStr isEqualToString:@":"] && [fisrtTwoStr isEqualToString:@"##"]) {
        NSArray *tmpArr = [self.cmdContent componentsSeparatedByString:@"#"];
        for (int i = 0; i<[tmpArr[2] length]; i++) {
            //截取字符串中的每一个字符
            NSString *s = [tmpArr[2] substringWithRange:NSMakeRange(i, 1)];
            BYPostBackModel * model = group1.items[s.integerValue - 1];
            model.isSelect = YES;
        }
        
        NSString *timeStr = tmpArr.lastObject;
        model8.detail = timeStr;
    }else{
        model1.isSelect = YES;
        model2.isSelect = YES;
        model3.isSelect = YES;
        model4.isSelect = YES;
        model5.isSelect = YES;
        model6.isSelect = YES;
        model7.isSelect = YES;

        model8.detail = @"12:00";
    }
    
    BYSettingGroup *group2 = [[BYSettingGroup alloc] init];
    group2.items = @[model8];

    [self.dataSorce addObject:group1];
    [self.dataSorce addObject:group2];
}

-(void)initBase{
    
    [self.navigationView setTitle:@"星期模式"];
    self.view.backgroundColor = BYGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.scrollEnabled = NO;
    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight + 10)];
    self.tableView.tableHeaderView = head;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYOTSWeakCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYPostBackPositionCell class]) bundle:nil] forCellReuseIdentifier:@"positioncell"];
    
    [self getDetailWithCmdContent];//将回传间隔记录显示到发送回传间隔指令上
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSorce.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0) {
        BYSettingGroup *group = self.dataSorce[indexPath.section];
        BYPostBackModel *model = group.items[indexPath.row];
        BYOTSWeakCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.separateView.hidden = indexPath.row == group.items.count-1 ? YES : NO;
        
        cell.title = model.title;
        cell.isSelect = model.isSelect;
        return cell;
    }else
    {
        BYSettingGroup *group = self.dataSorce[indexPath.section];
        BYPostBackModel *model = group.items[indexPath.row];
        BYPostBackPositionCell *positioncell = [tableView dequeueReusableCellWithIdentifier:@"positioncell"];
        positioncell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        positioncell.model = model;
        return positioncell;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    BYSettingGroup *group = self.dataSorce[section];
    return group.items.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        BYPostBackFooterView * footer = [BYPostBackFooterView by_viewFromXib];
        footer.title = @"";
        [footer setSureActionBlock:^{
            BYSettingGroup *group1 = self.dataSorce[0];
            NSString *dayStr = nil;
            for (NSInteger i = 0; i < group1.items.count; i++) {
                BYPostBackModel *model = group1.items[i];
                if (model.isSelect) {
                    if (dayStr == nil) {
                        NSString *tmpStr = [NSString stringWithFormat:@"%zd",i + 1];
                        dayStr = tmpStr;
                    }else{
                        NSString *tmpStr = [NSString stringWithFormat:@"%zd",i + 1];
                        dayStr = [NSString stringWithFormat:@"%@%@",dayStr,tmpStr];
                    }
                }
            }
            BYSettingGroup *group2 = self.dataSorce[section];
            BYPostBackModel * model = group2.items[0];
            NSString * tempStr = [model.detail stringByReplacingOccurrencesOfString:@":" withString:@""];
            self.httpParams.content =[NSString stringWithFormat:@"%@#%@",dayStr,tempStr];
            
            [BYDeviceDetailHttpTool POSTSendPostBackWithParams:self.httpParams success:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popToViewController:self animated:YES];
                });
            }];
        }];
        return footer;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:[NSDate date] center:@"请选择时间" datePickerMode:UIDatePickerModeTime pickViewType:BYPickViewTypeDate];
        
        BYWeakSelf;
        [datePicker setSureBlock:^(NSDate * date) {
            BYSettingGroup *group = self.dataSorce[indexPath.section];
            BYPostBackModel * model = group.items[indexPath.row];
            model.detail = [weakSelf formatterSelectDate:date];
            model.date = date;
            
            [weakSelf.tableView reloadData];
        }];
    }else{
        BYSettingGroup *group = self.dataSorce[indexPath.section];
        BYPostBackModel *model = group.items[indexPath.row];
        model.isSelect = !model.isSelect;
        [self.tableView reloadData];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BYS_W_H(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return section == 1 ? BYS_W_H(40) + 80 + 50 : BYS_W_H(10);
}
-(NSString *)formatterSelectDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
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
        _httpParams.mold = 7;
    }
    return _httpParams;
}

@end
