//
//  BYDeviceSettingController.m
//  BYGPS
//
//  Created by miwer on 16/7/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceSettingController.h"
#import "BYCmdCell.h"
#import "BYDeviceTitleHeader.h"
#import "EasyNavigation.h"
#import "BYAlarmConfigSwitchCell.h"

#import "BYPostBackController.h"
#import "BYOTSPostBackController.h"
#import "BYPostBackDurationController.h"
#import "BYWiredPostBackDurationController.h"
#import "BYOTSPostBackDemolishController.h"
#import "BYDetailTabBarController.h"
#import "BYBreakOilController.h"
#import "BYDeviceDetailHttpTool.h"
#import "BYAlarmConfigModel.h"
#import "BYCmdRecordModel.h"
#import "BYPushNaviModel.h"
#import "BYBlankView.h"
#import "BYDeviceDetailHttpTool.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

#import "BYDeviceInfoModel.h"

static NSString * const labelCellID = @"labelCell";

static NSString * const switchCellID = @"switchCell";

static NSString * const switchHeader = @"switchHeader";

@interface BYDeviceSettingController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate>

@property(nonatomic,strong) BYBlankView * blankView;

@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) BOOL isWireless;//传过来的是否无线
@property(nonatomic,assign) NSInteger deviceId;//传过来的DeviceId
@property(nonatomic,assign) NSString * cmdType;//1回传间隔 3断油电 4 重启设备  12光感报警

@property(nonatomic,strong) NSMutableArray * alarmSource;
@property(nonatomic,strong) NSMutableArray * cmdSource;//指令数据
@property (nonatomic,strong) NSMutableArray *cmdNullDataSource;

@property(nonatomic,strong) BYPushNaviModel * model;
@property(nonatomic,assign) BOOL isFirstLoad;//是否是第一次加载,避免发指令的菊花与网络请求冲突

@property(nonatomic,strong) NSMutableArray * mergeSource;//报警配置和指令组合

@property (nonatomic,assign) CGFloat row_H;

@property (nonatomic,strong) NSMutableArray *cmdTypeArr;

@property(nonatomic ,strong) WKWebView *webView;


@end

@implementation BYDeviceSettingController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /*
    [self.tabBarController.navigationView setTitle:@"控制设备"];
    
    [self.tabBarController.navigationView removeAllRightButton];
    
    if ([BYSaveTool boolForKey:BYDeviceConfigIntervalKey] || [BYSaveTool boolForKey:BYBreakingOilElectricity] || [BYSaveTool boolForKey:BYDeviceConfigRestartKey]) {
        
        BYWeakSelf;
        [self.tabBarController.navigationView addRightButtonWithImage:[UIImage imageNamed:@"control_icon_refresh"] clickCallBack:^(UIView *view) {
            [weakSelf refreshAction];
        }];
        
        self.tableView.bounces = YES;

        if (self.blankView) {
            [self.blankView removeFromSuperview];
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabBarController.navigationView removeAllRightButton];
        });
    }
    */
    
//    [self initBase];//完成一些配置信息
//    if (!_isFirstLoad) {
//        [self loadData];
//    }else{
//        [self loadFirstData];
//    }
    

     self.tabBarController.navigationView.hidden = YES;
    BYDetailTabBarController * tabBarVC = (BYDetailTabBarController *)self.tabBarController;
    self.model = tabBarVC.model;
    //#pragma mark 手动改变model设备类型
    //    self.model.model = @"036";
   
    [self loadWebView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.navigationView.hidden = NO;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    //    self.disableSlidingBackGesture = NO;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    

    _row_H = BYS_W_H(50);
    _isFirstLoad = YES;//第一次进入这个页面时第一次加载设置为YEs
   
   
}

- (void)loadWebView{
    if (self.model.model.length == 0) {
        [self loadDataWith:self.model.deviceId];
    }else{
        NSString *encodeModel = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)self.model.model,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        
        
        NSString *url = nil;
        if (self.model.shareId.length) {
            url = [NSString stringWithFormat:@"%@?token=%@&deviceId=%zd&model=%@&shareId=%@&isMark=%@",[BYSaveTool objectForKey:BYH5Url],[BYSaveTool objectForKey:BYToken],self.model.deviceId,encodeModel,self.model.shareId,[self.model.isMark integerValue]?@"1":@"0"];
        }else{
            url = [NSString stringWithFormat:@"%@?token=%@&deviceId=%zd&model=%@&isMark=%@",[BYSaveTool objectForKey:BYH5Url],[BYSaveTool objectForKey:BYToken],self.model.deviceId,encodeModel,[self.model.isMark integerValue]?@"1":@"0"];
        }
        
        BYLog(@"url = %@",url);
        
        NSString *decodeString = [BYObjectTool encodeParameter:url];
        BYLog(@"decodeString = %@",decodeString);
        [self.webView  loadRequest:[ NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
        [self.view addSubview:self.webView];
    }
}

-(void)loadDataWith:(NSInteger)deviceId{
    
    BYWeakSelf;
    [BYDeviceDetailHttpTool POSTDeviceDetailWithDeviceId:deviceId success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYDeviceInfoModel * model = [[BYDeviceInfoModel alloc] initWithDictionary:data error:nil];
            
            BYDetailTabBarController * tabBarVC = (BYDetailTabBarController *)self.tabBarController;
            tabBarVC.model.deviceId = model.deviceId;
            tabBarVC.model.model = model.model;
            tabBarVC.model.wifi = model.wifi;
            tabBarVC.model.sn = model.sn;
            tabBarVC.model.carId = model.carId;
            tabBarVC.model.carNum = model.carNum;
            tabBarVC.model.carVin = model.carVin;
            self.model = tabBarVC.model;
            
            [weakSelf loadWebView];
           
            
        });
    } showHUD:YES];
}

-(void)refreshAction{

    [self loadData];

}

-(void)loadFirstData{
    [BYDeviceDetailHttpTool POSTDeviceConfigWithDeviceId:_deviceId success:^(id data) {
        BYLog(@"%@",data);
        _isFirstLoad = NO;
        for (NSString * key in data) {//先遍历字典
            NSString * value = data[key];//遍历数组,通过key找到数组中对应的报警
            for (BYAlarmConfigModel * model in self.alarmSource) {
                if ([key isEqualToString:model.alarmConfigKey]) {
                    if (![value isKindOfClass:[NSNull class]]) {
                        model.alarmConfigValue = [value boolValue];
                    }else{
                        model.alarmConfigValue = 0;
                    }
                }
            }
        }
        [self.mergeSource removeAllObjects];
        [self.mergeSource addObject:self.alarmSource];
        if (self.cmdTypeArr.count > 0) {
            for (NSString *type in self.cmdTypeArr) {
                BYCmdRecordModel * model = [[BYCmdRecordModel alloc] init];
                model.status = @"无记录";
                model.content = @"无记录";
                model.sendTime = @"无记录";
                model.updateTime = @"无记录";
                model.nickName = @"无记录";
                model.type = [type integerValue];
                model.mode = @"无记录";
                
                [self.cmdSource addObject:model];
            }
            [self.mergeSource addObject:self.cmdSource];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^{
        
    } isShowFlower:YES];
}                                                                                                                                                                  

-(void)loadCmdDataWithType:(NSInteger)type{
    
    [BYDeviceDetailHttpTool POSTDeviceConfigWithDeviceId:_deviceId cmdType:type success:^(id data) {
        //如果请求过来的指令内容为空, 并且cmdType为1或者3、4, 自己创建一条数据
        if (![data isKindOfClass:[NSNull class]]) {
            BYCmdRecordModel * model = [[BYCmdRecordModel alloc] initWithDictionary:data error:nil];
            model.type = type;
            
        }else{
            BYCmdRecordModel * model = [[BYCmdRecordModel alloc] init];
            model.status = @"无记录";
            model.content = @"无记录";
            model.sendTime = @"无记录";
            model.updateTime = @"无记录";
            model.nickName = @"无记录";
            model.type = type;
            model.mode = @"无记录";
        }

    } failure:^{
        BYCmdRecordModel * model = [[BYCmdRecordModel alloc] init];
        model.status = @"无记录";
        model.content = @"无记录";
        model.sendTime = @"无记录";
        model.updateTime = @"无记录";
        model.nickName = @"无记录";
        model.type = type;
        model.mode = @"无记录";
    } isShowFlower:YES];
}

-(void)loadData{
    BYWeakSelf;
    BYLog(@"请求数据");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BYDeviceDetailHttpTool POSTDeviceConfigWithDeviceId:_deviceId success:^(id data) {
            BYLog(@"alarmSource。  %@",data);
            for (NSString * key in data) {//先遍历字典
                NSString * value = data[key];//遍历数组,通过key找到数组中对应的报警
                for (BYAlarmConfigModel * model in weakSelf.alarmSource) {
                    if ([key isEqualToString:model.alarmConfigKey]) {
                        if (![value isKindOfClass:[NSNull class]]) {
                            model.alarmConfigValue = [value boolValue];
                        }else{
                            model.alarmConfigValue = 0;
                        }
                    }
                }
            }
            
                BYLog(@"alarmSource请求数据完成");
                [weakSelf.mergeSource removeAllObjects];
                [weakSelf.mergeSource addObject:weakSelf.alarmSource];
//                if (weakSelf.cmdSource.count > 0) {
                [weakSelf.mergeSource addObject:weakSelf.cmdSource];
//                }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        } failure:^{

        } isShowFlower:YES];
    });
    
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BYDeviceDetailHttpTool POSTDeviceConfigWithDeviceId:_deviceId cmdTypeArr:self.cmdTypeArr success:^(NSMutableArray *cmdArr) {
//            _isFirstLoad = NO;
            BYLog(@"cmdArr ----------------- %@",cmdArr);
            [weakSelf.cmdSource removeAllObjects];
            [weakSelf.cmdSource addObjectsFromArray:cmdArr];
            
                BYLog(@"cmdSource请求数据完成");
            [weakSelf.mergeSource removeAllObjects];
            [weakSelf.mergeSource addObject:weakSelf.alarmSource];
//                if (weakSelf.cmdSource.count > 0) {
            [weakSelf.mergeSource addObject:weakSelf.cmdSource];
//                }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });

        }failure:^() {

        } isShowFlower:YES];
//    });
}

-(void)saveAlarmSetWith:(NSInteger)row{//通过点击的行数来改变对应的报警配置
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"deviceId"] = @(_deviceId);
    
    BYAlarmConfigModel * model = self.alarmSource[row];
    model.alarmConfigValue = !model.alarmConfigValue;
    
    for (BYAlarmConfigModel * model in self.alarmSource) {
        
        params[model.alarmConfigKey] = @(model.alarmConfigValue);
    }
    
    [BYDeviceDetailHttpTool POSTSaveAlarmSetWithParams:params success:^{
        //        [self.tableView reloadData];
        
    }];
}

-(void)initBase{
    [self.cmdTypeArr removeAllObjects];
//    [self.cmdSource removeAllObjects];
//    [self.mergeSource removeAllObjects];
    self.view.backgroundColor = BYGlobalBg;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.tableView.frame = CGRectMake(0, 64, BYSCREEN_W, BYSCREEN_H - 64 - 44);
    //    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 64, 0);
    if (@available(iOS 11.0, *)) {
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.contentInset = UIEdgeInsetsMake(SafeAreaTopHeight, 0, 44, 0);
        }
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 44, 0);
        // Fallback on earlier versions
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    //添加默认的上线报警,行驶报警,停车报警
    [self.alarmSource removeAllObjects];
    [self.alarmSource addObject:[BYAlarmConfigModel createModelWith:@"online" value:NO title:@"上线报警"]];
    [self.alarmSource addObject:[BYAlarmConfigModel createModelWith:@"driving" value:NO title:@"行驶报警"]];
    [self.alarmSource addObject:[BYAlarmConfigModel createModelWith:@"stoping" value:NO title:@"停车报警"]];
    
    if ([self.model.model isEqualToString:@"038A"]) {
        [self.alarmSource addObject:[BYAlarmConfigModel createModelWith:@"stoping" value:NO title:@"点火报警"]];
    }
    
    BYDetailTabBarController * tabBarVC = (BYDetailTabBarController *)self.tabBarController;
    self.model = tabBarVC.model;
    //#pragma mark 手动改变model设备类型
    //    self.model.model = @"036";
    _deviceId = self.model.deviceId;
    _isWireless = self.model.wifi;//tabBarVC.wifi
    
    _cmdType = @"-1";//初始化为-1 表示不请求
    [self.cmdTypeArr addObject:_cmdType];
    if (_isWireless) {//无线设备除013c外都有回传间隔，
        [self.cmdTypeArr removeAllObjects];
        if ([BYSaveTool boolForKey:BYDeviceConfigIntervalKey]) {
            
            if (![self.model.model isEqualToString:@"013C"]) {
                _cmdType = @"1";
                [self.cmdTypeArr addObject:_cmdType];
            }
            if ([self.model.model isEqualToString:@"027"] || [self.model.model isEqualToString:@"027W"] || [self.model.model isEqualToString:@"027WL"] || [self.model.model isEqualToString:@"013G"] || [self.model.model isEqualToString:@"013M"] || [self.model.model isEqualToString:@"033"] || [self.model.model isEqualToString:@"029"]) {
                [self.cmdTypeArr addObject:@"12"];
            }
        }
    }else{//传过来的型号,判断是不是断油电有线015D,018D才有断油电 有线设备回传间隔取消
        [self.cmdTypeArr removeAllObjects];
        if ([BYSaveTool boolForKey:BYDeviceConfigIntervalKey]) {
            if (![self.model.model containsString:@"038"]) {
                [self.cmdTypeArr addObject:@"1"];
            }
        }
        
        if ([BYSaveTool boolForKey:BYBreakingOilElectricity]) {
            if ([self.model.model isEqualToString:@"015D"] || [self.model.model isEqualToString:@"018D"] || [self.model.model isEqualToString:@"021D"]) {
                _cmdType = @"3";
                [self.cmdTypeArr addObject:_cmdType];
            }
        }
        if ([BYSaveTool boolForKey:BYDeviceConfigRestartKey]) {
            if (![self.model.model containsString:@"038"]) {
                [self.cmdTypeArr addObject:@"4"];
            }
        }
    }
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYCmdCell class]) bundle:nil] forCellReuseIdentifier:labelCellID];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYAlarmConfigSwitchCell class]) bundle:nil] forCellReuseIdentifier:switchCellID];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mergeSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return _isWireless ? 1 : 3;
    }else{
        return self.cmdSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {//第一组是报警配置
        BYAlarmConfigSwitchCell * switchCell = [tableView dequeueReusableCellWithIdentifier:switchCellID];
        
        if (_isWireless) {
            switchCell.model = self.alarmSource.firstObject;
            [switchCell setSwitchOperation:^{
                [self saveAlarmSetWith:indexPath.row];
            }];
        }else{
            switchCell.model = self.alarmSource[indexPath.row];
            [switchCell setSwitchOperation:^{
                [self saveAlarmSetWith:indexPath.row];
            }];
        }
        
        return switchCell;
    }else{//第二组是指令内容(只有回传间隔(010,013,019)和断油电(015D,018D)) zpd 新增有线设备重启
        
        // zpd新增有线设备重启
        
        BYCmdCell * cmdCell = [tableView dequeueReusableCellWithIdentifier:labelCellID];
        cmdCell.isWireless = _isWireless;
        __weak BYCmdCell *weakCell = cmdCell;
        BYWeakSelf;
        [cmdCell setTapHeadBlock:^(BOOL istapHead){
            weakCell.isTapHead = istapHead;
//            BYCmdRecordModel *model = self.cmdSource[indexPath.row];
            if (!istapHead) {
                [weakSelf loadData];
            }
            //            _row_H = istapHead ? BYS_W_H(50) : BYS_W_H(120) + BYS_W_H(50);
            [self.tableView reloadData];
        }];
        if (_cmdType > 0) {
            BYCmdRecordModel *model = self.cmdSource[indexPath.row];
            cmdCell.model = model;
            [cmdCell setSettingActionBlock:^{
                //回传间隔指令跳转
                switch (model.type) {
                    case 1://回传间隔
                    {
                        //判断无线还是有线
                        if (_isWireless) {
                            if ([self.model.model containsString:@"026"] || [self.model.model containsString:@"027"]) {
                                BYOTSPostBackController *OTSPostBackVC = [[BYOTSPostBackController alloc] init];
                                OTSPostBackVC.isWireless = self.isWireless;
                                OTSPostBackVC.model = self.model;
                                BYCmdRecordModel * model = self.cmdSource.firstObject;
                                OTSPostBackVC.cmdContent = [self analysisCmdContentWith:model];
                                //                                OTSPostBackVC.contentType = model.contentType;
                                BYLog(@"beginCmd : %@",[self analysisCmdContentWith:model]);
                                [self.navigationController pushViewController:OTSPostBackVC animated:YES];
                            }else{
                                BYPostBackController * postBackVC = [[BYPostBackController alloc] init];
                                postBackVC.isWireless = self.isWireless;
                                postBackVC.model = self.model;
                                
                                BYCmdRecordModel * model = self.cmdSource.firstObject;
                                //处理一开始的指令内容
                                postBackVC.cmdContent = [self analysisCmdContentWith:model];
                                BYLog(@"beginCmd : %@",[self analysisCmdContentWith:model]);
                                //                                postBackVC.contentType = model.contentType;
                                
                                [self.navigationController pushViewController:postBackVC animated:YES];
                            }
                        }else{
                            BYWiredPostBackDurationController *wiredPostBackDurationVC = [[BYWiredPostBackDurationController alloc] init];
                            wiredPostBackDurationVC.isWireless = self.isWireless;
                            wiredPostBackDurationVC.model = self.model;
                            BYCmdRecordModel * model = self.cmdSource.firstObject;
                            //处理一开始的指令内容
                            wiredPostBackDurationVC.cmdContent = [self analysisCmdContentWith:model];
                            BYLog(@"beginCmd : %@",[self analysisCmdContentWith:model]);
                            //                            wiredPostBackDurationVC.contentType = model.contentType;
                            
                            [self.navigationController pushViewController:wiredPostBackDurationVC animated:YES];
                            
                        }
                    }
                        break;
                    case 3://断油电
                    {
                        BYBreakOilController * breakOilVC = [[BYBreakOilController alloc] init];
                        breakOilVC.model = self.model;
                        [self.navigationController pushViewController:breakOilVC animated:YES];
                    }
                        break;
                    case 4://设备重启
                    {
                        
                        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"设备重启" message:@"你确认要重启设备吗？" preferredStyle:UIAlertControllerStyleAlert];
                        if ([BYObjectTool getIsIpad]){
                            
                            alertVC.popoverPresentationController.sourceView = self.view;
                            alertVC.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
                        }
                        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
#pragma mark 设备重启指令
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            params[@"deviceId"] = @(self.model.deviceId);
                            params[@"type"] = @(4);
                            params[@"content"] = @"reset";
                            params[@"model"] = self.model.model;
                            [BYDeviceDetailHttpTool POSTSendRestartSetWithParams:params success:nil];
                            //                                [BYDeviceDetailHttpTool POSTSendPostBackWithParams:self.httpParams success:nil];
                        }];
                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                        
                        [alertVC addAction:okAction];
                        [alertVC addAction:cancelAction];
                        [self presentViewController:alertVC animated:YES completion:nil];
                        BYLog(@"设备重启");
                    }
                        break;
                    case 5:
                    {
                        //拆机报警
                        BYOTSPostBackDemolishController *otsPostDemolishVC = [[BYOTSPostBackDemolishController alloc] init];
                        otsPostDemolishVC.model = self.model;
                        otsPostDemolishVC.cmdContent = [self analysisCmdContentWith:model];
                        [self.navigationController pushViewController:otsPostDemolishVC animated:YES];
                    }
                        break;
                        
                    case 12:
                    {
                        //光感报警 ？ 拆机报警
                        BYOTSPostBackDemolishController *otsPostDemolishVC = [[BYOTSPostBackDemolishController alloc] init];
                        otsPostDemolishVC.model = self.model;
                        otsPostDemolishVC.cmdContent = [self analysisCmdContentWith:model];
                        [self.navigationController pushViewController:otsPostDemolishVC animated:YES];
                    }
                        break;
                    default:
                        break;
                }
                //                if ([_cmdType integerValue] == 1) {
                //                    BYPostBackController * postBackVC = [[BYPostBackController alloc] init];
                //
                //                    postBackVC.model = self.model;
                //
                //                    BYCmdRecordModel * model = self.cmdSource.firstObject;
                //                    //处理一开始的指令内容
                //                    postBackVC.cmdContent = [self analysisCmdContentWith:model];
                //                    BYLog(@"beginCmd : %@",[self analysisCmdContentWith:model]);
                //
                //                    [self.navigationController pushViewController:postBackVC animated:YES];
                //                }else{
                //                    BYBreakOilController * breakOilVC = [[BYBreakOilController alloc] init];
                //                    breakOilVC.model = self.model;
                //                    [self.navigationController pushViewController:breakOilVC animated:YES];
                //                }
            }];
        }
        return cmdCell;
    }
}
/*
 contentType 1为常规模式 2追踪模式 3固定时间点 4心跳 -1 不是回传间隔
 2.0 -> 常规模式下:010 : 1#3600##
 其他 : 10#3600##
 2.5 -> 常规模式下:      #3600##
 2.0 -> 抓车模式下:010 : 30#60
 其他 : 30#60##
 2.0 -> 抓车模式下:      30#60##
 */
-(NSString *)analysisCmdContentWith:(BYCmdRecordModel *)model{
    //    NSArray * tempArr = [model.content componentsSeparatedByString:@"#"];
    //    if (model.contentType == 1) {//如果是常规模式
    //        //如果是第一个字母为#(正常是#3600##)
    //        return [NSString stringWithFormat:@"#%@##",tempArr[1]];
    //    }else if (model.contentType == 2){
    //        return [NSString stringWithFormat:@"%@#%@##",tempArr[0],tempArr[1]];
    //    }else{
    //        return model.content.length > 0 ?  model.content:@"无记录";
    //    }
    return @"无记录";
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    BYDeviceTitleHeader * titleHeader = [BYDeviceTitleHeader by_viewFromXib];
    titleHeader.title = section == 0 ? @"报警配置" : [self.model.model containsString:@"038"] ? @"" : @"指令下发";
    return titleHeader;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return BYS_W_H(50);
    }else{
        BYCmdRecordModel *model = self.cmdSource[indexPath.row];
        BYLog(@"%f",model.row_H);
        return model.row_H;
    }
    //    return indexPath.section == 0 ? BYS_W_H(50) : BYS_W_H(120) + BYS_W_H(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BYS_W_H(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

#pragma mark -- WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [BYProgressHUD show];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [BYProgressHUD dismiss];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [BYProgressHUD dismiss];
    BYShowError(@"加载失败");
}


- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    BYLog(@"message = %@",message);
    if ([message.name isEqualToString:@"methodName"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([message.name isEqualToString:@"umeng"]){
        MobClickEvent(message.body, @"");
    }
    
   
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{return nil;}


#pragma mark - lazy

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, BYSCREEN_H) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

//-(BYSendPostBackParams *)httpParams{
//    if (_httpParams == nil) {
//        _httpParams = [[BYSendPostBackParams alloc] init];
//        _httpParams.deviceId = self.model.deviceId;
////        _httpParams.deivceModel = self.model.model;
//        _httpParams.type = 4;
////        _httpParams.levelPassWord = @"";
////        _httpParams.wifi = self.isWireless;
//    }
//    return _httpParams;
//}


-(NSMutableArray *)alarmSource{
    if (_alarmSource == nil) {
        _alarmSource = [[NSMutableArray alloc] init];
    }
    return _alarmSource;
}
-(NSMutableArray *)cmdSource{
    if (_cmdSource == nil) {
        _cmdSource = [[NSMutableArray alloc] init];
    }
    return _cmdSource;
}

-(NSMutableArray *)mergeSource{
    if (_mergeSource == nil) {
        _mergeSource = [[NSMutableArray alloc] init];
    }
    return _mergeSource;
}

-(BYBlankView *)blankView{
    if (_blankView == nil) {
        _blankView = [BYBlankView by_viewFromXib];
        _blankView.title = @"您没有该权限";
        _blankView.frame = self.view.frame;
    }
    return _blankView;
}

-(NSMutableArray *)cmdTypeArr
{
    if (!_cmdTypeArr) {
        _cmdTypeArr = [NSMutableArray array];
    }
    return _cmdTypeArr;
}

-(NSMutableArray *)cmdNullDataSource
{
    if (!_cmdNullDataSource) {
        _cmdNullDataSource = [NSMutableArray array];
    }
    return _cmdNullDataSource;
}

- (WKWebView *)webView {
    if (!_webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        config.preferences = [[WKPreferences alloc] init];
        
        config.preferences.minimumFontSize = 10;
        
        config.preferences.javaScriptEnabled = YES;
        
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        config.userContentController = [[WKUserContentController alloc] init];
        
        config.processPool = [[WKProcessPool alloc] init];
         [config.userContentController addScriptMessageHandler:self name:@"methodName"];
         [config.userContentController addScriptMessageHandler:self name:@"umeng"];
        
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                        
                                          configuration:config];
        
        //记得实现对应协议,不然方法不会实现.
        
        _webView.UIDelegate = self;
        
        _webView.navigationDelegate =self;
        
        
       
    }
    return _webView;
}

@end

