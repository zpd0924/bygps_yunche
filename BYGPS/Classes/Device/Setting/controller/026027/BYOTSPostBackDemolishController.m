//
//  BYOTSPostBackDemolishController.m
//  BYGPS
//
//  Created by ZPD on 2017/6/29.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYOTSPostBackDemolishController.h"
#import "BYAlarmConfigModel.h"
#import "BYAlarmConfigSwitchCell.h"
#import "BYPostBackFooterView.h"
#import "BYSendPostBackParams.h"
#import "BYPushNaviModel.h"
#import "BYDeviceDetailHttpTool.h"
#import "EasyNavigation.h"

@interface BYOTSPostBackDemolishController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,strong) BYSendPostBackParams * httpParams;
@property(nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) UITableView *tableView;

@end

@implementation BYOTSPostBackDemolishController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
}

//  拆机报警
-(void)initBase{
    
    self.tableView.backgroundColor = [UIColor colorWithHex:@"#f0f0f0"];
    [self.navigationView setTitle:@"光感报警设置"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    BYAlarmConfigModel * model = [BYAlarmConfigModel createModelWith:@"isOpen" value:YES title:@"是否启用光感报警"];
    [self.dataSource addObject:model];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYAlarmConfigSwitchCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYAlarmConfigSwitchCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BYAlarmConfigModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    [cell setSwitchOperation:^{

        model.alarmConfigValue = !model.alarmConfigValue;
        self.httpParams.content = [NSString stringWithFormat:@"%zd",!model.alarmConfigValue];
 
    }];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    BYPostBackFooterView * footer = [BYPostBackFooterView by_viewFromXib];
    
    [footer setSureActionBlock:^{

        [BYDeviceDetailHttpTool POSTOpenLightAlarmWithParams:self.httpParams success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController popToViewController:self animated:YES];
            });
        }];

    }];
    footer.title = @"";
    
    return footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return BYS_W_H(40) + 80 + 50;
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

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
        _httpParams.type = 12;
//        _httpParams.points = 2;
        _httpParams.content = @"0";//默0
//        _httpParams.content3 = -1;
    }
    return _httpParams;
}

@end
