//
//  BYSendShareController.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYSendShareController.h"
#import "EasyNavigation.h"
#import "BYSendShareCell.h"
#import "BYSendShareHeadView.h"
#import "BYSendShareFootView.h"
#import "BYPickView.h"
#import "BYAddWithoutController.h"
#import "BYShareTypeView.h"
#import "WXApiRequestHandler.h"
#import "BYShareCommitDeviceModel.h"
#import "BYShareUserModel.h"
#import "BYShareSucessModel.h"
//QQ分享
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

@interface BYSendShareController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) BYShareTypeView *shareTypeView;
@property (nonatomic,strong) BYShareSucessModel *shareSucessModel;

@end

@implementation BYSendShareController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   [self.navigationView setTitle:@"分享"];
    [self initBase];
   [self getDeviceList];
   
}

- (void)initBase{
    [self.view addSubview:self.tableView];
    BYWeakSelf;
     NSDate *nextDay = [NSDate dateWithTimeInterval:6*24*60*60 sinceDate:[NSDate date]];
    _paramModel.shareTime = [self formatterSelectDate:nextDay];//默认选中日期为：当前日期+6
    
    BYSendShareHeadView *headView = [BYSendShareHeadView by_viewFromXib];
    headView.paramModel = _paramModel;
    self.tableView.tableHeaderView = headView;
    BYSendShareFootView *footView = [BYSendShareFootView by_viewFromXib];
   
    footView.goToShareBlock = ^(NSString *remark){
        weakSelf.paramModel.remark = remark;
        [weakSelf show];
    };
    self.tableView.tableFooterView = footView;
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareResult:) name:@"shareToWechatOrQQResponseNotification" object:nil];
}
- (void)shareResult:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    NSString *result = dict[@"result"];
    if ([result integerValue]) {
        BYShowSuccess(@"分享成功");
         [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        BYShowError(@"分享失败");
    }
}

#pragma mark -- 获取设备列表
- (void)getDeviceList{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"carId"] = _paramModel.carId;
    [BYRequestHttpTool POSTShareCarDeviceParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *arr = data;
            BYShareCommitDeviceModel *model = weakSelf.paramModel.deviceShare.firstObject;
            for (NSDictionary *dict in arr) {
                
                if (![dict[@"deviceSn"] isEqualToString:model.deviceSn]) {
                 BYShareCommitDeviceModel *deviceModel = [BYShareCommitDeviceModel yy_modelWithDictionary:dict];
                    [weakSelf.paramModel.deviceShare addObject:deviceModel];
                }
               
            }

            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 分享接口
- (void)shareData:(BYSharePlatformType)platformType{
    
    switch (platformType) {
        case BYWechatType:
            
        {
            if (![WXApiRequestHandler isWXAppInstalled]) {
//                BYShowError(@"请先安装微信哦!");
                return;
            }
        }
            break;
        case BYQQType:
        {
            if (![TencentOAuth iphoneQQInstalled]) {
//                BYShowError(@"请先安装qq哦!");
                return;
            }
        }
            break;
        default:
        {
            
        }
            break;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"carId"] = _paramModel.carId;
    dict[@"carVin"] = _paramModel.carVin;
    dict[@"carOwnerName"] = _paramModel.carOwnerName;
    dict[@"carNum"] = _paramModel.carNum;
    dict[@"carColor"] = _paramModel.carColor;
    dict[@"shareTime"] = _paramModel.shareTime;
    dict[@"sendCommand"] = _paramModel.sendCommand;
    dict[@"checkAlarm"] = _paramModel.checkAlarm;
    dict[@"address"] = _paramModel.address;
    dict[@"remark"] = _paramModel.remark;
    
    if (_paramModel.shareLine.count) {
        NSMutableArray *arr = [NSMutableArray array];
        for (BYShareUserModel *userModel in _paramModel.shareLine) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"receiveShareUserId"] = userModel.receiveShareUserId;
            dict[@"receiveShareUserName"] = userModel.receiveShareUserName;
            [arr addObject:dict];
        }
        NSData *data=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];

        NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        dict[@"shareLine"] = jsonStr;
    }
    if (_paramModel.shareMobile.count) {
        NSMutableArray *arr = [NSMutableArray array];
        for (BYShareUserModel *userModel in _paramModel.shareMobile) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"mobile"] = userModel.mobile;
            [arr addObject:dict];
        }
        NSData *data=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];

        NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        dict[@"shareMobile"] = jsonStr;
    }
   
    if(_paramModel.deviceShare.count){
        NSMutableArray *arr = [NSMutableArray array];
        for (BYShareCommitDeviceModel *deviceModel in _paramModel.deviceShare) {
            if (deviceModel.isSelect) {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                dict[@"deviceId"] = deviceModel.deviceId;
                dict[@"deviceSn"] = deviceModel.deviceSn;
                dict[@"wifi"] = @(deviceModel.wifi);
                dict[@"model"] = deviceModel.alias;
                [arr addObject:dict];
            }
           
        }
        NSData *data=[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];

        NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        dict[@"deviceShare"] = jsonStr;
    }
    BYWeakSelf;
    [BYRequestHttpTool POSTSaveShareParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
              weakSelf.shareSucessModel = [BYShareSucessModel yy_modelWithDictionary:data];
            weakSelf.shareSucessModel.Description = [NSString stringWithFormat:@"车辆%@目前位于%@,点击查看详情",[BYObjectTool carNumPassword:weakSelf.shareSucessModel.carNum],[BYObjectTool carAdressSub:_paramModel.address]];
            switch (platformType) {
                case BYWechatType:
                    
                {
                     [weakSelf wechat];
                }
                    break;
                case BYQQType:
                {
                     [weakSelf qq];
                }
                    break;
                default:
                {
                    [weakSelf copysLink];
                }
                    break;
            }
            BYLog(@"%@",data);
            [weakSelf.shareTypeView hideView];
           
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 去分享
- (void)show{
    //判断是够有选分享人
    if (!_paramModel.shareMobile.count && !_paramModel.shareLine.count) {
        BYShowError(@"至少添加一位接收人");
        return;
    }
    if (!_paramModel.shareTime.length) {
        BYShowError(@"请选择有效截止日期");
        return;
    }
    
    BYWeakSelf;
    BYShareTypeView *shareTypeView = [BYShareTypeView by_viewFromXib];
    self.shareTypeView = shareTypeView;
    shareTypeView.shareTypeBlock = ^(BYSharePlatformType platformType) {
        switch (platformType) {
            case BYWechatType:
            {
                [weakSelf shareData:platformType];
            }
                break;
            case BYQQType:
            {
                 [weakSelf shareData:platformType];
            }
                break;
            default:
            {
                 [weakSelf shareData:platformType];
            }
                break;
        }
    };
    [shareTypeView show];
    
}

#pragma mark -- 微信分享
- (void)wechat{
    if (![WXApiRequestHandler isWXAppInstalled]) {
//        BYShowError(@"请先安装微信哦!");
        return;
    }
    [WXApiRequestHandler sendLinkURL:_shareSucessModel.shareUrl
                             TagName:@"标越科技" Title:[NSString stringWithFormat:@"%@邀请你查看车辆监控",[BYSaveTool objectForKey:groupName]] Description:self.shareSucessModel.Description ThumbImage:[UIImage imageNamed:@"share"] InScene:WXSceneSession];
    
}
- (void)qq{
    if (![TencentOAuth iphoneQQInstalled]) {
//        BYShowError(@"请先安装qq哦!");
        return;
    }
    NSString *utf8String = _shareSucessModel.shareUrl;
    NSString *title = [NSString stringWithFormat:@"%@邀请你查看车辆监控",[BYSaveTool objectForKey:groupName]];
    NSString *description = self.shareSucessModel.Description;
    NSString *previewImageUrl = @"http://oss.chedaia.com/map.png";
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:utf8String]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    
}
- (void)copysLink{
    BYShowSuccess(@"复制成功!");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _shareSucessModel.shareUrl;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- 日期选择
- (void)selectDate{
    NSDate *nextDay = [NSDate dateWithTimeInterval:6*24*60*60 sinceDate:[NSDate date]];//后一天
    BYPickView * datePicker = [[BYPickView alloc] initWithDatePickWith:nextDay center:@"请选择日期" datePickerMode:UIDatePickerModeDate pickViewType:BYPickViewTypeDate];
    datePicker.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0]; // 设置最小时间
    datePicker.datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:30 * 365 * 24 * 60 * 60]; // 设置最大时间
    BYWeakSelf;
    [datePicker setSureBlock:^(NSDate * date) {
        weakSelf.paramModel.shareTime = [weakSelf formatterSelectDate:date];
        [weakSelf.tableView reloadData];
    }];
}

-(NSString *)formatterSelectDate:(NSDate *)date{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString * selectDate = [formatter stringFromDate:date];
    
    return selectDate;
}


#pragma mark -- tableview 数据源 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _paramModel.deviceShare.count - 1;
    }else{
        NSArray *arr = self.titleArr[section];
        return arr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYSendShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYSendShareCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.paramModel = _paramModel;
    cell.indexPath = indexPath;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BYWeakSelf;
    if (indexPath.section == 0) {//设备选择
            BYShareCommitDeviceModel *deviceModel = _paramModel.deviceShare[indexPath.row+1];
            if (deviceModel.isSelect) {
                deviceModel.isSelect = NO;
            }else{
                deviceModel.isSelect = YES;
            }
            [self.tableView reloadData];
        
    }else{
        if ([self.titleArr[indexPath.section][indexPath.row] isEqualToString:@"内部员工"]) {
            BYAddWithoutController *vc = [[BYAddWithoutController alloc] init];
            vc.addPersonBlock = ^(BYShareCommitParamModel *paramModel) {
                weakSelf.paramModel = paramModel;
                [weakSelf.tableView reloadData];
            };
            vc.shareAddType = BYInsideType;
            vc.paramModel = [self.paramModel copy];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([self.titleArr[indexPath.section][indexPath.row] isEqualToString:@"外部人员"]){
            BYAddWithoutController *vc = [[BYAddWithoutController alloc] init];
            vc.addPersonBlock = ^(BYShareCommitParamModel *paramModel) {
                weakSelf.paramModel = paramModel;
                [weakSelf.tableView reloadData];
            };
            vc.shareAddType = BYWithoutType;
            vc.paramModel = [self.paramModel copy];;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([self.titleArr[indexPath.section][indexPath.row] isEqualToString:@"有效截止日期"]){
            [self selectDate];
        }
    }
   
    
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        if (self.paramModel.deviceShare.count <= 1) {
             return 0.01f;
        }else{
            return 45.f;
        }
       
    }else if (section == 1){
         return 45.f;
    }else{
        return 7.f;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    if (section == 0) {
         UIView *view = nil;
        if (self.paramModel.deviceShare.count <= 1) {
           view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH, 45)];
        }else{
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH, 0)];
        }
        view.backgroundColor = UIColorHexFromRGB(0xF4F4F4);
        UILabel *label = [UILabel verLab:14 textRgbColor:UIColorHexFromRGB(0x333333) textAlighment:NSTextAlignmentLeft];
        label.text = @"同时分享该车其他设备";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.0f);
            make.centerY.equalTo(view);
        }];
        if (self.paramModel.deviceShare.count <= 1) {
            label.hidden = YES;
        }else{
            label.hidden = NO;
        }
        return view;
    }else if (section == 1){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH, 45)];
        view.backgroundColor = UIColorHexFromRGB(0xF4F4F4);
        UILabel *label = [UILabel verLab:14 textRgbColor:UIColorHexFromRGB(0x333333) textAlighment:NSTextAlignmentLeft];
        label.text = @"接收人";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(12.0f);
            make.centerY.equalTo(view);
        }];
        return view;
    }else{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH, 7)];
        view.backgroundColor = UIColorHexFromRGB(0xF4F4F4);
        return view;
    }
}

#pragma mark --LAZY

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = BYBigSpaceColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        BYRegisterCell(BYSendShareCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

-(NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = @[@[@"",@""],@[@"内部员工",@"外部人员"],@[@"允许发指令",@"允许报警配置",@"有效截止日期"]];
    }
    return _titleArr;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"shareToWechatOrQQResponseNotification" object:nil];
}
@end
