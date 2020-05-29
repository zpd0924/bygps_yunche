//
//  BYPostBackPositionController.m
//  BYGPS
//
//  Created by miwer on 16/9/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYPostBackPositionController.h"
#import "BYPostBackModel.h"
#import "BYPostBackPositionCell.h"
#import "BYPostBackFooterView.h"
#import "BYAddMoreHeaderView.h"
#import "BYPickView.h"
#import "BYPushNaviModel.h"
#import "EasyNavigation.h"
#import "BYSendPostBackParams.h"
#import "BYDeviceDetailHttpTool.h"
#import "NSDate+BYDistanceDate.h"
#import "BYDateFormtterTool.h"

static NSString * const ID = @"cell";

@interface BYPostBackPositionController ()

@property(nonatomic,strong) NSMutableArray * dataSorce;
@property(nonatomic,strong) BYSendPostBackParams * httpParams;
@property(nonatomic,assign) BOOL isDevice017;//是否是017设备
@property(nonatomic,strong) UILabel * headLabel;

@end

@implementation BYPostBackPositionController

-(NSMutableArray *)dataSorce{
    if (_dataSorce == nil) {
        _dataSorce = [[NSMutableArray alloc] init];
    }
    return _dataSorce;
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    
}
/**
 *  回传间隔   : 360#60## [360->持续时间(min),60->回传间隔时间(s)]
 *  固定回传点 : ###09441544 [09点44分]
 *  取消回传点 : ###-1
 *  心跳间隔   : ##001e# [16进制]
 *  回传间隔&心跳间隔   :   1440#3600#003c#
 */
-(void)getCmdContentDetail{//解析指令内容 -> ###09441544
    //判断前三个字母是否为###,并且后面的数字是否为4的倍数
    NSString * tempStr = [self.cmdContent substringFromIndex:3];
    if ([[self.cmdContent substringToIndex:3] isEqualToString:@"###"] && tempStr.length % 4 == 0) {
        
        NSDateComponents * coms = [BYDateFormtterTool currentDateComponents:[NSDate date]];
        
        NSString * tempCmdContentStr = tempStr;
        
        for (NSInteger i = 0; i < tempStr.length / 4; i ++) {
            
            NSString * currentStr = [tempCmdContentStr substringToIndex:4];
            tempCmdContentStr = [tempCmdContentStr substringFromIndex:4];
            NSString * detailStr = [NSString stringWithFormat:@"%@:%@",[currentStr substringToIndex:2],[currentStr substringFromIndex:2]];
            BYPostBackModel * model = [BYPostBackModel createModelWith:[NSString stringWithFormat:@"固定回传时间点%zd",i + 1] detail:detailStr placeholder:nil unit:nil];
            
            //拼接日期yyyy-MM-dd HH:mm:ss
            NSString * comsStr = [NSString stringWithFormat:@"%zd-%zd-%zd %@:00",coms.year,coms.month,coms.day,detailStr];
            
            model.date = [BYDateFormtterTool formatterToDateWith:comsStr];
            
            [self.dataSorce addObject:model];
        }
    }
}

-(void)clearAll{
    [self.dataSorce removeAllObjects];
    [self.tableView reloadData];
}

-(void)initBase{
    
    _isDevice017 = [self.model.model isEqualToString:@"017"];
    [self.navigationView setTitle:@"固定上线时间设置"];
    self.view.backgroundColor = BYGlobalBg;
    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight + 30)];
    [head addSubview:self.headLabel];
//    self.tableView.tableHeaderView = self.headLabel;
    self.tableView.tableHeaderView = head;
    BYWeakSelf;
    [self.navigationView addRightButtonWithTitle:@"清空" clickCallBack:^(UIView *view) {
        [weakSelf clearAll];
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYPostBackPositionCell class]) bundle:nil] forCellReuseIdentifier:ID];

    [self getCmdContentDetail];//解析传过来的指令内容
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYPostBackPositionCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    BYPostBackModel * model = self.dataSorce[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataSorce.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    BYAddMoreHeaderView * addHeader = [BYAddMoreHeaderView by_viewFromXib];
    addHeader.mostCount = _isDevice017 ? @"最多1个" : @"最多4个";
    addHeader.addMoreButton.enabled = _isDevice017 ? self.dataSorce.count >= 1 ? NO : YES : self.dataSorce.count >= 4 ? NO : YES;
    
    BYWeakSelf;
    [addHeader setAddMoreBlock:^{
        
        for (BYPostBackModel * model in weakSelf.dataSorce) {
            
            if ([model.detail isEqualToString:@"请输入固定回传时间"]) {
                return [BYProgressHUD by_showErrorWithStatus:@"请设置固定回传时间"];
            }
        }
        
        NSString * position = [NSString stringWithFormat:@"固定回传时间点%zd",weakSelf.dataSorce.count + 1];
        BYPostBackModel * model = [BYPostBackModel createModelWith:position detail:@"请输入固定回传时间" placeholder:nil unit:nil];
        [weakSelf.dataSorce addObject:model];
        [weakSelf.tableView reloadData];
    }];
    
    return addHeader;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:[NSDate date] center:@"请选择时间" datePickerMode:UIDatePickerModeTime pickViewType:BYPickViewTypeDate];
    
    BYWeakSelf;
    [datePicker setSureBlock:^(NSDate * date) {

        //如果数组长度减一还大于行数,说明选中行有下一行
        if (weakSelf.dataSorce.count - indexPath.row > 1) {
            BYPostBackModel * nextModel = weakSelf.dataSorce[indexPath.row + 1];
            if (nextModel.date && [nextModel.date minIntervalFromLastDate:date] < 30) {
                
                return [BYProgressHUD by_showErrorWithStatus:@"每个回传点相隔必须大于30分钟"];
            }
        }
        
        if (indexPath.row > 0) {
            
            BYPostBackModel * lastModel = weakSelf.dataSorce[indexPath.row - 1];
            if ([date minIntervalFromLastDate:lastModel.date] < 30) {
                
                return [BYProgressHUD by_showErrorWithStatus:@"每个回传点相隔必须大于30分钟"];
            }
        }
        
        BYPostBackModel * model = weakSelf.dataSorce[indexPath.row];
        model.detail = [weakSelf formatterSelectDate:date];
        model.date = date;
        
        [weakSelf.tableView reloadData];
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    BYPostBackFooterView * footer = [BYPostBackFooterView by_viewFromXib];
    footer.title = @"*固定上线时间设置将会覆盖常规模式设置";
    footer.subTitle = [self.model.model containsString:@"013"] ? @"* 至少设置两个回传点" : @"";
    
    BYWeakSelf;
    [footer setSureActionBlock:^{
        
        if (weakSelf.dataSorce.count == 0) {
            return [BYProgressHUD by_showErrorWithStatus:@"请设置固定回传点"];
        }
        
        if ([self.model.model containsString:@"013"]) {
            if (weakSelf.dataSorce.count < 2) {
                return [BYProgressHUD by_showErrorWithStatus:@"请至少设置两个固定回传点"];
            }
        }
        
        NSString * contentStr = @"";
        for (BYPostBackModel * model in weakSelf.dataSorce) {
 
            if ([model.detail isEqualToString:@"请输入固定回传时间"]) {
               return [BYProgressHUD by_showErrorWithStatus:@"请设置固定回传时间"];
            }
            
            NSString * tempStr = [model.detail stringByReplacingOccurrencesOfString:@":" withString:@""];
            contentStr = [contentStr stringByAppendingString:tempStr];
        }

        weakSelf.httpParams.content = contentStr;
        
        [BYDeviceDetailHttpTool POSTSendPostBackWithParams:weakSelf.httpParams success:^{
        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popToViewController:self animated:YES];
            });
        }];
    }];
    return footer;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return BYS_W_H(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return BYS_W_H(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return BYS_W_H(40) + 80 + 50;
}

-(NSString *)formatterSelectDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
}

#pragma mark - lazy
-(BYSendPostBackParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYSendPostBackParams alloc] init];
        _httpParams.deviceId = self.model.deviceId;
        _httpParams.model = self.model.model;
        _httpParams.type = 1;

        _httpParams.mold = 3;
    }
    return _httpParams;
}

-(UILabel *)headLabel{
    if (_headLabel == nil) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, 30)];
        _headLabel.textAlignment = NSTextAlignmentCenter;
        _headLabel.backgroundColor = [UIColor colorWithHex:@"#FFEEC8"];
        _headLabel.textColor = [UIColor colorWithHex:@"#E74B1A"];
        _headLabel.font = BYS_T_F(13);
        _headLabel.text = @"*每个回传点之间必须相隔30分钟以上";
    }
    return _headLabel;
}


@end
