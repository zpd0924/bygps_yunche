//
//  BYPostBackHeartbeatController.m
//  BYGPS
//
//  Created by miwer on 2017/1/16.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYPostBackHeartbeatController.h"
#import "BYPostBackModel.h"
#import "BYPostBackCell.h"
#import "BYDeviceSwitchHeader.h"
#import "BYPostBackFooterView.h"
#import "BYDeviceDetailHttpTool.h"
#import "BYSendPostBackParams.h"
#import "BYPushNaviModel.h"
#import "EasyNavigation.h"

@interface BYPostBackHeartbeatController ()

@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,assign) BOOL isSelect;
@property(nonatomic,strong) UITextField * textField;
@property(nonatomic,strong) BYSendPostBackParams * httpParams;

@end

@implementation BYPostBackHeartbeatController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
}
-(void)initBase{
    [self.navigationView setTitle:@"开启心跳"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.tableView.estimatedRowHeight = 0;
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.tableView.estimatedSectionFooterHeight = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight + 10)];
    self.tableView.tableHeaderView = head;
    [self getDetailWithCmdContent];//通过之前的指令内容判断是否为设置心跳间隔
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYPostBackCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];

    BYPostBackFooterView * footer = [BYPostBackFooterView by_viewFromXib];
    footer.title = @"心跳回传：设置心跳后，设备将按照设置时间接收平台下发的指令。如：1天上线一次，心跳间隔设置为30分钟。那么设备每30分钟会自动激活接收指令。";
    
    [footer setSureActionBlock:^{
        //如果选中了心跳,说明上传心跳间隔.关闭心跳就是取消心跳
        if (!_isSelect) {
//            self.httpParams.content3 = 0;
        }else{
            if (self.textField.text.length == 0) {
                return [BYProgressHUD by_showErrorWithStatus:@"请输入心跳间隔时间"];
            }
            
            NSInteger durationInt = self.textField.text.integerValue;
            if (durationInt < 30) {
                return [BYProgressHUD by_showErrorWithStatus:@"心跳间隔须大于30分钟"];
            }
            
            if (durationInt > 480) {
                return [BYProgressHUD by_showErrorWithStatus:@"心跳间隔须小于480分钟"];
            }
            
//            self.httpParams.content3 = durationInt;
        }
        
        [BYDeviceDetailHttpTool POSTSendPostBackWithParams:self.httpParams success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController popToViewController:self animated:YES];
            });
        }];
    }];
    
    self.tableView.tableFooterView = footer;
}

-(void)getDetailWithCmdContent{
    
    NSString * beforeTwoStr = [self.cmdContent.length>1?self.cmdContent:@"  " substringToIndex:2];//判断前两个字母是不是##
    NSString * lastOneStr = [self.cmdContent substringFromIndex:self.cmdContent.length - 1];//指令最后一个字母,判断是不是#
    //判断指令是否只含有心跳间隔
    if ([beforeTwoStr isEqualToString:@"##"] && [lastOneStr isEqualToString:@"#"]) {//##001e#
        
        NSString * content = [self.cmdContent substringToIndex:self.cmdContent.length - 1];//先去掉最后两个##
        content = [content substringFromIndex:2];//再去掉前面一个#,最后得到心跳间隔
        _isSelect = YES;
        
        NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([content UTF8String],0,16)];//16进制字符串转化成10进制字符串
        
        if ([temp10 integerValue] == 0) {
            _isSelect = NO;
            BYPostBackModel * model2 = [BYPostBackModel createModelWith:@"心跳间隔时间" detail:nil placeholder:@"请输入心跳间隔(min)" unit:@"分钟"];
            [self.dataSource addObject:model2];
        }else{
            BYPostBackModel * model2 = [BYPostBackModel createModelWith:@"心跳间隔时间" detail:nil placeholder:[NSString stringWithFormat:@"已设置心跳间隔%@(min)",temp10] unit:@"分钟"];
            [self.dataSource addObject:model2];
        }
 
    }else{
        
        _isSelect = NO;
        BYPostBackModel * model2 = [BYPostBackModel createModelWith:@"心跳间隔时间" detail:nil placeholder:@"请输入心跳间隔(min)" unit:@"分钟"];
        [self.dataSource addObject:model2];
    }
}

#pragma mark - Table view data source

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYPostBackCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    self.textField = cell.textField;
    BYPostBackModel * model = self.dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BYDeviceSwitchHeader * switchHeader = [BYDeviceSwitchHeader by_viewFromXib];
    switchHeader.titleLabel.text = @"开启心跳间隔";
    switchHeader.switchView.on = _isSelect;
    
    [switchHeader setSwitchOperation:^(BOOL isOn) {
        _isSelect = isOn;
        [self.tableView reloadData];
    }];
    
    return switchHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return BYS_W_H(50);
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _isSelect ? 1 : 0;
}

-(instancetype)init{
    return [self initWithStyle:UITableViewStyleGrouped];
}

#pragma mark - lazy
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(BYSendPostBackParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYSendPostBackParams alloc] init];
        _httpParams.deviceId = self.model.deviceId;
//        _httpParams.deivceModel = self.model.model;
//        _httpParams.wifi = self.model.wifi;
//        _httpParams.points = 4;
        _httpParams.type = 1;
    }
    return _httpParams;
}

@end
