//
//  BYHomeViewController.m
//  BYGPS
//
//  Created by miwer on 16/7/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYHomeViewController.h"
#import "BYAlarmListController.h"

#import "EasyNavigation.h"

#import "BYDetailTabBarController.h"
#import "BYDeviceListController.h"
#import "BYDemolishContainerController.h"

#import "BYParkEventController.h"

#import "BYLoginHttpTool.h"
#import "BYHomeHttpTool.h"

#import "JHChartHeader.h"
#import "BYAttributeLabel.h"
#import "NSString+BYAttributeString.h"
#import "BYHomeButton.h"
#import "BYInstallSendOrderController.h"
#import "BYVerUpdateModel.h"
#import "BYAlertTip.h"
#import "BYNetworkHelper.h"
#import "BYLoginHttpTool.h"
#import "BYAutoScanViewController.h"
#import "BYAutoServiceViewController.h"
#import "BYReceiveShareController.h"
#import "BYGiveShareController.h"
#import "BYRegularTool.h"
#import "BYShareNumberModel.h"
#import <UMMobClick/MobClick.h>
#import "BYRouteModel.h"
#import "BYRouteApisModel.h"
static CGFloat const BYHomeItemsBgView_H = 80;
static CGFloat const BYringBgView_H = 180;
static CGFloat const BYringCountBgView_H = 280;
static CGFloat const BYImgBgView_H = 90;

@interface BYHomeViewController ()<JHColumnChartDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bannerImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerImgViewTop;
@property (weak, nonatomic) IBOutlet UIView *middleInfoView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic,strong) JHColumnChart *deviceColumnChart;

@property (weak, nonatomic) IBOutlet UIView *ringBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headBgViewContraint_H;//统计背景视图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviceAlarmContraint_H;//设备列表和报警列表按钮背景View
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ringBgViewContraint_H;//圆环背景高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ringCountBgViewContraint_H;//圆环和统计label背景高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBgViewConstraint_H;//中间图片背景高度

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *netErrorBgViewTopContraint_H;

@property (weak, nonatomic) IBOutlet UIView *netStatusBgView;

@property(nonatomic,strong) NSDictionary * countDict;
@property(nonatomic,assign) BOOL isFirstLoad;

@property (weak, nonatomic) IBOutlet UIView *itemsBgView;
@property (nonatomic,strong) BYVerUpdateModel *updateModel;
@property (weak, nonatomic) IBOutlet UIView *receiveShareView;
@property (weak, nonatomic) IBOutlet UIView *sendShareView;
@property (weak, nonatomic) IBOutlet UILabel *alarmNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *offlineNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *receiveUnreadNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendUnreadNumberLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiveUnreadLabelW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sendUnreadLabelW;


@property (nonatomic,strong) BYRouteModel *routeModel;///寻址模型

@end

@implementation BYHomeViewController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (![BYSaveTool boolForKey:BYIsReadinessKey]) {

        //在视图已经显示完成时开始请求数据,以免loginVcPresent进来时出现菊花在没有请求到数据提前消失的情况
        [self loadStatusCountWith:_isFirstLoad];
    }
   
}

#pragma mark - viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BYLog(@"sanx = %@",[BYObjectTool getDataBaseFileDirectoryInSandBox]);
   
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"https://www.vbgps.com/apple-app-site-association";
    
//    [self loadBadgeRedSign];
//    BYStatusBarLight;
    
    if ([BYSaveTool boolForKey:BYIsReadinessKey]) {
        

    }else{
        [self loadAlarmCount];//加载报警角标
    }
   
    
    [self shareNumberData];
    if (![BYSaveTool objectForKey:BYBaseUrl]) {
        [self loadRoute];
    }
   
    
    NSString *token = [BYSaveTool valueForKey:BYDeviceToken];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"token" message:token preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancle];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    BYStatusBarDefault;
    [BYHomeHttpTool cancelOperation];//视图消失时取消网络请求
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
}

-(void)initBase{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = BYRGBColor(240, 245, 245);
    
    self.navigationView = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , self.navigationOrginalHeight)];
    [self.view addSubview:self.navigationView];
    [self.navigationView setTitle:@"云车科技"];
    self.headBgViewContraint_H.constant = BYSCREEN_H * 95 / 667;
    self.bannerImgViewTop.constant = STATUSBAR_HEIGHT + kNavNormalHeight + 10;

    self.deviceAlarmContraint_H.constant = BYSCREEN_H * BYHomeItemsBgView_H / 667;
    self.ringBgViewContraint_H.constant = BYringBgView_H ;
    self.ringCountBgViewContraint_H.constant = BYSCREEN_H * BYringCountBgView_H / 667;
    self.imgBgViewConstraint_H.constant = BYSCREEN_H * BYImgBgView_H / 667;
    _isFirstLoad = YES;
    
    [self addItemsToItemsBgView];//添加诸多按钮
    
    self.netErrorBgViewTopContraint_H.constant = 0;
    self.netStatusBgView.hidden = YES;//默认都是隐藏的
    
//    self.middleInfoView.layer.shadowColor = [UIColor grayColor].CGColor;
//    self.middleInfoView.layer.shadowRadius = 5.0;
//    self.middleInfoView.layer.shadowOpacity = 0.5;
//    self.middleInfoView.layer.cornerRadius = 5;
//    self.middleInfoView.layer.masksToBounds = YES;
    
    self.deviceColumnChart = [[JHColumnChart alloc] initWithFrame:CGRectMake(30, 30, SCREEN_WIDTH - 40, BYringBgView_H)];
    [self.ringBgView addSubview:self.deviceColumnChart];
    self.deviceColumnChart.valueArr = @[@[@[@0,@0]],@[@[@0,@0]],@[@[@0,@0]],@[@[@0,@0]]];
    /*       This point represents the distance from the lower left corner of the origin.         */
    self.deviceColumnChart.originSize = CGPointMake(30, 30);
    /*    The first column of the distance from the starting point     */
    self.deviceColumnChart.drawFromOriginX = 0;
    self.deviceColumnChart.backgroundColor = [UIColor whiteColor];
    self.deviceColumnChart.typeSpace = 45;
    self.deviceColumnChart.isShowYLine = YES;
    self.deviceColumnChart.contentInsets = UIEdgeInsetsMake(5, 0, 0, 0);
    /*        Column width         */
    self.deviceColumnChart.columnWidth = 12;
    /*        Column backgroundColor         */
//    self.deviceColumnChart.bgVewBackgoundColor = [UIColor yellowColor];
    /*        X, Y axis font color         */
    self.deviceColumnChart.drawTextColorForX_Y = [UIColor blackColor];
    /*        X, Y axis line color         */
    self.deviceColumnChart.colorForXYLine = [UIColor darkGrayColor];
    /*    Each module of the color array, such as the A class of the language performance of the color is red, the color of the math achievement is green     */
    self.deviceColumnChart.columnBGcolorsArr = @[@[UIColorHexFromRGB(0x24A1FF),UIColorHexFromRGB(0xE9F0FC)],@[UIColorHexFromRGB(0x24A1FF),UIColorHexFromRGB(0xE9F0FC)],@[UIColorHexFromRGB(0x24A1FF),UIColorHexFromRGB(0xE9F0FC)]];//如果为复合型柱状图 即每个柱状图分段 需要传入如上颜色数组 达到同时指定复合型柱状图分段颜色的效果
    /*        Module prompt         */
    self.deviceColumnChart.xShowInfoText = @[@"0\n离线3天以上",@"0\n2天以上未行驶",@"0\n断电报警",@"0\n围栏报警"];
    self.deviceColumnChart.delegate = self;
    /*       Start animation        */
    [self.deviceColumnChart showAnimation];
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAlarmCount) name:BYNotificationKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadAlarmCount) name:BYBecomeActiveKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repeatLogin) name:BYRepeatLoginKey object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFrameWithNetStatus:) name:BYNetStatusNotificationKey object:nil];
    
    [self.receiveShareView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(receiveShareViewClick)]];
    [self.sendShareView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendShareViewClick)]];
}

-(void)addItemsToItemsBgView{
    NSArray * imageArr = @[@"home_icon_device_list",@"home_icon_alarm_list",@"home_icon_share_list",@"home_icon_auto_install",@"home_icon_order_send"];
//    home_icon_more.png 自助安装
    NSArray * titleArr = @[@"设备列表",@"报警列表",@"分享列表",@"自助装",@"装机派"];
    //自助装
    
    CGFloat item_W = (BYSCREEN_W - 6) / 5;
    CGFloat item_H = (BYSCREEN_H * BYHomeItemsBgView_H / 667);
    
    BYBadgeShowType showType;
    for (NSInteger i = 0; i < 5; i ++) {
        showType = BYBadgeNone;
        BYHomeButton * button = [BYHomeButton createButtonWith:imageArr[i] title:titleArr[i] badgeShowType:showType];
        button.titleLabel.font = BYS_T_F(11);
        button.by_x = i % 5 * (item_W + 1);
        button.by_y = 0;
        button.by_size = CGSizeMake(item_W, item_H);
        
        button.tag = 500 + i;
        
        [button addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.itemsBgView addSubview:button];
    }
}

- (void)itemClick:(UIButton *)button{
    switch (button.tag - 500) {
        case 0: {[self goToDeviceList]; MobClickEvent(@"home_device", @"");} break;
        case 1: {[self goToAlarmList]; MobClickEvent(@"home_install", @"");} break;
        case 2: {[self receiveShareViewClick];MobClickEvent(@"home_alarm", @"");} break;
            //自助装
        case 3: {[self goToMore];MobClickEvent(@"home_photograph", @"");} break;
            //装机派
        case 4: {[self goToAppointmentDemolish];MobClickEvent(@"home_MyJob", @"");} break;
        default:{[self goToAppointmentDemolish];MobClickEvent(@"home_self", @"");} break;
    }
    
}

-(void)updateFrameWithNetStatus:(NSNotification *)notification{
    
    BOOL isNet = [notification.userInfo[@"isNet"] boolValue];
    
    self.netErrorBgViewTopContraint_H.constant = isNet ? 0 : BYS_W_H(40);
    self.netStatusBgView.hidden = isNet;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (IBAction)gotoSetting:(id)sender {
    
    if (UIApplicationOpenSettingsURLString != NULL) {
        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:appSettings];
    }
}

//每当用户登录时都发送一个通知到首页,将第一次加载置为YES,让菊花转起来
-(void)loadAlarmCount{
    [BYHomeHttpTool POSTHomeAlarmCountSuccess:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYHomeButton * button = [self.itemsBgView viewWithTag:502];
            //报警角标的显示是根据报警信息权限决定
            if (![BYSaveTool boolForKey:BYAlarmInfoKey]) {
                button.badgeNum = 0;
            }else{
                button.badgeNum = [data[@"alarmNum"] integerValue];
            }
        });
    }];
}


- (void)shareNumberData{
    BYWeakSelf;
    
    [BYRequestHttpTool POSTMySendShareCountParams:nil success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYShareNumberModel *model = [BYShareNumberModel yy_modelWithDictionary:data];
            [weakSelf refresfShareNumberData:model];
        });
        
    } failure:^(NSError *error) {
        
    }];
    [BYRequestHttpTool POSTMyReceiveShareCountParams:nil success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYShareNumberModel *model = [BYShareNumberModel yy_modelWithDictionary:data];
            [weakSelf refresfShareNumberData1:model];
        });
       
    } failure:^(NSError *error) {
        
    }];
}
//发出的
- (void)refresfShareNumberData:(BYShareNumberModel *)model{
    if ([model.isNotReadCount integerValue] > 999) {
         model.isNotReadCount = @"999+";
         self.sendUnreadLabelW.constant = (4 + 1) * 9;
       
    }else{
         self.sendUnreadLabelW.constant = (model.isNotReadCount.length + 1) * 9;
    }
   
    self.sendNumberLabel.text = model.count;
  
    self.sendUnreadNumberLabel.text = model.isNotReadCount;
    if ([model.isNotReadCount integerValue]) {
        self.sendUnreadNumberLabel.hidden = NO;
    }else{
        self.sendUnreadNumberLabel.hidden = YES;
    }

    
}
//收到的
- (void)refresfShareNumberData1:(BYShareNumberModel *)model{
    if ([model.isNotReadCount integerValue] > 999) {
         model.isNotReadCount = @"999+";
        self.receiveUnreadLabelW.constant = (4 + 1) * 9;
    }else{
       self.receiveUnreadLabelW.constant = (model.isNotReadCount.length + 1) * 9;
    }
    
    self.receiveNumberLabel.text = model.count;
    self.receiveUnreadNumberLabel.text = model.isNotReadCount;
    if ([model.isNotReadCount integerValue]) {
        self.receiveUnreadNumberLabel.hidden = NO;
    }else{
        self.receiveUnreadNumberLabel.hidden = YES;
    }
}

-(void)loadStatusCountWith:(BOOL)isShowFlower{
    
    BYWeakSelf;
    [BYHomeHttpTool POSTHomeStatusCountSuccess:^(id data) {
        if (![BYSaveTool isContainsKey:@"CheckPhoto"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [BYGuideImageView showGuideViewWith:@"CheckPhoto" touchOriginYScale:0.5];
            });
            
        }//加载完数据后加载蒙版
        _isFirstLoad = NO;
        BYLog(@"%@",data);
        //头部统计label
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary * upwardData = data[@"upward"];
            weakSelf.countDict = upwardData;
            weakSelf.alarmNumLabel.text = [upwardData[@"alarm"] stringValue];
            weakSelf.offlineNumLabel.text = [upwardData[@"offline"] stringValue];
            //尾部圆环
            NSDictionary * graphicsData = data[@"graphics"];
            NSInteger powerAlarm = [graphicsData[@"powerAlarm"] integerValue];//断电报警
            NSInteger fenceAlarm = [graphicsData[@"fenceAlarm"] integerValue];//电子围栏报警
            NSInteger threeOffline = [graphicsData[@"offline"] integerValue];//离线三天以上（有线）
            NSInteger twoMoreDaysNoDrving = [graphicsData[@"driving"] integerValue]; //两天以上未行驶
            
            NSInteger allDevice = [graphicsData[@"allDevice"] integerValue];
//            allDevice = allDevice == 0 ? 1 : allDevice;
            NSInteger other = allDevice-powerAlarm-fenceAlarm-threeOffline;//其他数量
            other = other <= 0 ? 0 : other;//避免让其他数值小于0

            weakSelf.deviceColumnChart.valueArr = @[@[@[@(threeOffline),@(allDevice - threeOffline)]],@[@[@(twoMoreDaysNoDrving),@(allDevice - twoMoreDaysNoDrving)]],@[@[@(powerAlarm),@(allDevice - powerAlarm)]],@[@[@(fenceAlarm),@(allDevice - fenceAlarm)]]];
            self.deviceColumnChart.xShowInfoText = @[[NSString stringWithFormat:@"%ld辆\n离线3天以上",threeOffline] ,[NSString stringWithFormat:@"%ld辆\n2天以上未行驶",twoMoreDaysNoDrving],[NSString stringWithFormat:@"%ld辆\n断电报警",powerAlarm],[NSString stringWithFormat:@"%ld辆\n围栏报警",fenceAlarm]];
            self.deviceColumnChart.delegate = self;
            /*       Start animation        */
            [self.deviceColumnChart showAnimation];
        
        });
        
        
    } isShowFlower:isShowFlower];
}

- (void)goToDeviceList{
    if (![BYSaveTool boolForKey:BYDevicesKey]) {
        return BYShowError(@"没有查看设备列表权限");
    }
    BYDeviceListController * deviceVC = [[BYDeviceListController alloc] init];
    deviceVC.countDict = self.countDict;
    
    BYLog(@"homeNavi : %@",self.navigationController);
    
    [self.navigationController pushViewController:deviceVC animated:YES];

}
//装机派
- (void)goToAppointmentDemolish{
    
    if (![BYSaveTool boolForKey:BYMySendOrderKey]) {
        return BYShowError(@"你没有该模块的权限");
    }
    
    BYInstallSendOrderController *vc = [[BYInstallSendOrderController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)goToAlarmList{
//    查看报警列表无权限
    if (![BYSaveTool boolForKey:BYAlarmInfoKey]) {
        return BYShowError(@"没有查看报警权限");
    }
    
    BYAlarmListController * vc = [[BYAlarmListController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}


#pragma mark 自助装拆修

- (void)goToMore{
    
    if (![BYSaveTool boolForKey:BYAutoInstallOrder]) {
        return BYShowError(@"你没有该模块的权限");
    }
    
    BYAutoServiceViewController *autoServiceVC = [BYAutoServiceViewController new];
    [self.navigationController pushViewController:autoServiceVC animated:YES];

//    BYAutoScanViewController *vc = [[BYAutoScanViewController alloc] init];
//    vc.scanType = WQCodeScannerTypeBarcode;
//    [self.navigationController pushViewController:vc animated:YES];
    
    
}
#pragma mark -- 收到的分享
- (void)receiveShareViewClick{
    MobClickEvent(@"home_share_receive", @"");
    BYReceiveShareController *vc = [[BYReceiveShareController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 发出的分享
- (void)sendShareViewClick{
     MobClickEvent(@"home_share_give", @"");
    BYGiveShareController *vc = [[BYGiveShareController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        [BYProgressHUD by_showErrorWithStatus:@"搜索内容不能为空"];
        return YES;
    }
    [textField resignFirstResponder];
    BYDeviceListController * deviceVC = [[BYDeviceListController alloc] init];
    deviceVC.queryStr = textField.text;
    deviceVC.countDict = self.countDict;
    [self.navigationController pushViewController:deviceVC animated:YES];
    
    return YES;
}

-(void)logout{
    
    BYDetailTabBarController * detailTabBarVC = [[BYDetailTabBarController alloc] init];
    detailTabBarVC.selectedIndex = 1;
    [self.navigationController pushViewController:detailTabBarVC animated:YES];
}



///寻址
- (void)loadRoute{
    BYWeakSelf;
    [[BYNetworkHelper sharedInstance] POSTRouteUrlWithSuccess:^(id data) {
        BYLog(@"%@",data);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.routeModel = [BYRouteModel yy_modelWithDictionary:data];
            
            
            NSString *portStr = weakSelf.routeModel.defaults.port;
            if (portStr.length) {
                NSString *baseUrl = [NSString stringWithFormat:@"http://%@:%@/by-app-web/",weakSelf.routeModel.defaults.host,weakSelf.routeModel.defaults.port];
                [BYSaveTool setValue:baseUrl forKey:BYBaseUrl];
            }else{
                NSString *baseUrl = [NSString stringWithFormat:@"http://%@/by-app-web/",weakSelf.routeModel.defaults.host];
                [BYSaveTool setValue:baseUrl forKey:BYBaseUrl];
            }
            for (BYRouteApisModel *model in weakSelf.routeModel.apis) {
                if ([model.apiName isEqualToString:@"command-h5"]) {
                    NSString *baseH5Url = [NSString stringWithFormat:@"http://%@:%@%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],model.apiPath];
                    NSString *basePravacyH5Url = [NSString stringWithFormat:@"http://%@:%@/%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],@"dist-html"];
                    [BYSaveTool setValue:baseH5Url forKey:BYH5Url];
                    
                }
                if ([model.apiName isEqualToString:@"privacy-h5"]) {
                    
                    NSString *basePravacyH5Url = [NSString stringWithFormat:@"http://%@:%@%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],model.apiPath];
                    
                    [BYSaveTool setValue:basePravacyH5Url forKey:BYPrivacyH5Url];
                }
                if ([model.apiName isEqualToString:@"umscollector"]){
                    NSString *umscollectorUrl = [NSString stringWithFormat:@"http://%@:%@%@",model.servers.firstObject[@"host"],model.servers.firstObject[@"port"],model.apiPath];
                    
                    [BYSaveTool setValue:umscollectorUrl forKey:BYUmscollectorUrl];
                    
                }
            }
        
        });
        
        
        
    } failure:^(NSError *error) {
        
    } showError:NO];
}


-(void)gitTestIgnore{
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BYNotificationKey object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BYBecomeActiveKey object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BYRepeatLoginKey object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BYNetStatusNotificationKey object:nil];
}

@end
