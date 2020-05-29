//
//  BYControlViewController.m
//  BYGPS
//
//  Created by miwer on 16/7/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYControlViewController.h"
#import "BYDetailTabBarController.h"
#import "BYLoginViewController.h"
#import "BYReplayController.h"
#import "EasyNavigation.h"

#import "BYRegeoHttpTool.h"
#import "BYQueryZoneHttpTool.h"
#import "BYMonitorHttpTool.h"

#import "BYSearchBar.h"
#import "BYAnnotationView.h"
#import "BYFenceAnnotationView.h"
#import "BYControlPopView.h"
#import "UIButton+countDown.h"

#import "BYFenceControl.h"
#import "BYFenceDataBase.h"

#import "BYControlModel.h"
#import "BYPushNaviModel.h"
#import "BYControlHttpParams.h"
#import "BYDeviceDetailHttpTool.h"

#import "NSString+BYAttributeString.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import "BYTabBarController.h"

#import "BYControlSearchViewController.h"

#import "GuideCoverView.h"
#import "BYSendShareController.h"
#import "BYShareCommitParamModel.h"
#import "BYShareCommitDeviceModel.h"
#import "BYInstallDeviceCheckViewController.h"

static CGFloat const margin = 8;//22.509903, 113.950091

@interface BYControlViewController () <BMKMapViewDelegate,BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,BMKLocationAuthDelegate>

@property (nonatomic,strong) BYControlHttpParams *httpParams;
@property(nonatomic,strong) BMKMapView * mapView;//地图
@property(nonatomic,strong) BMKLocationManager * locationManager;
@property(nonatomic,strong) BMKGeoCodeSearch * searcher;
@property (nonatomic,strong) BMKCircle* circle;
@property (nonatomic,strong) BMKPolygon* polygon;

@property(nonatomic,strong) UIButton * rightCarButton;//切换到上一车
@property(nonatomic,strong) UIButton * leftCarButton;//切换到下一车
@property(nonatomic,strong) BYSearchBar * searchBar;
@property(nonatomic,strong) UIView * funcItemsBgView;//右上角功能按钮背景View
@property(nonatomic,strong) UIImageView * zoomLevelImageView;
@property(nonatomic,strong) UIButton * countButton;//倒计时按钮

@property (nonatomic,strong) UIButton * highRiskItem;//高危按钮
@property (nonatomic,strong) UIButton * searchHighRiskButton;  //检索高危按钮

@property(nonatomic,strong) NSMutableArray * annotations;   //车辆标注
@property (nonatomic,strong) NSMutableArray *fenceAnnotations;//电子围栏标注
@property (nonatomic,strong) NSMutableArray *carAnnotations;//所有标注
@property (nonatomic,strong) NSMutableArray *totalDatasource;//所有数据
@property (nonatomic,strong) NSMutableArray *fenceDatasource;//电子围栏数据
@property(nonatomic,strong) NSMutableArray * annotationViews;
@property (nonatomic,strong) NSMutableArray * fenceAnnotationViews;

@property(nonatomic,assign) BOOL isTabBarNaviHiden;
@property(nonatomic,assign) NSInteger selectIndex;
@property(nonatomic,strong) BMKAnnotationView * selectAnnoView;
@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,assign) BOOL FirstLoad;//用于判断是否要添加标注,0则直接复制
@property(nonatomic,assign) NSInteger controlRefreshDuration;
@property(nonatomic,assign) BOOL isQueryType;//是否为搜索框来请求数据
@property(nonatomic,strong) NSString * queryStr;

@property (nonatomic,assign) BOOL highRiskSelected;//高危按钮是否按下

@property(nonatomic,assign) BOOL isRepeatLogin;//是否重新登录了
@property (nonatomic,assign) BOOL isFirstLoadFence;
@property (nonatomic,assign) BOOL isSearch;

@property(nonatomic ,weak) UIView *noticeView;
@property(nonatomic,weak) UILabel *noticeLabel;
@property(nonatomic,strong) NSTimer *timer;

@property(nonatomic,strong) id deviceData;//设备的数据
@property (nonatomic,strong) id fenceData;//二押点高危数据

@property (nonatomic,assign) BOOL FirstLocate;

@property (nonatomic,strong) NSString *currentName;
@property (nonatomic,assign) BOOL beenLoadHighRisk;

@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象

@property (nonatomic , strong) BMKLocationViewDisplayParam *displayParam;

@end

@implementation BYControlViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];
    BYWeakSelf;
   
    [self.countButton startWithTime:[self.countButton getTimerDuration] zeroBlock:^{//开始倒计时
        [weakSelf loadDeviceData];
    }];
    if ([BYSaveTool boolForKey:BYMonitorKey]) {
        if (![self.currentName isEqualToString:[BYSaveTool objectForKey:BYusername]]) {
            [self loadDeviceData];
        }
    }
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.disableSlidingBackGesture = YES;
    if (![BYSaveTool isContainsKey:BYSelfClassName]) {
        if ([BYSaveTool boolForKey:BYMonitorInfo]) {
            [BYSaveTool setBool:YES forKey:BYSelfClassName];
            LoaderItemModel *itemImage = [LoaderItemModel initWithLink:nil Title:nil Region:nil];
            itemImage.loaderImage = BYSelfClassName;
            itemImage.loaderRect = self.view.frame;
            
            LoaderItemModel *itemImageGaoWei = [LoaderItemModel initWithLink:nil Title:nil Region:nil];
            itemImageGaoWei.loaderImage = @"gaowei";
            itemImageGaoWei.loaderRect = CGRectMake(self.funcItemsBgView.frame.origin.x  - [UIImage imageNamed:@"gaowei"].size.width, self.funcItemsBgView.frame.origin.y + self.funcItemsBgView.frame.size.height + 10 - 33, [UIImage imageNamed:@"gaowei"].size.width, [UIImage imageNamed:@"gaowei"].size.height);
            
            GuideCoverView *guideV = [[GuideCoverView alloc]initWithItems:@[itemImage,itemImageGaoWei]];
//            [guideV showInView:[UIApplication sharedApplication].keyWindow];
        }else{
            [BYSaveTool setBool:YES forKey:BYSelfClassName];
            LoaderItemModel *itemImage = [LoaderItemModel initWithLink:nil Title:nil Region:nil];
            itemImage.loaderImage = BYSelfClassName;
            itemImage.loaderRect = CGRectMake(0, BYSCREEN_H / 2 - [UIImage imageNamed:BYSelfClassName].size.height / 2 , [UIImage imageNamed:BYSelfClassName].size.width, [UIImage imageNamed:BYSelfClassName].size.height);;
            GuideCoverView *guideV = [[GuideCoverView alloc]initWithItems:@[itemImage]];
//            [guideV showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.disableSlidingBackGesture = NO;
//    self.mapView.delegate = nil; // 不用时，置nil,释放内存
//    _searcher.delegate = nil;
//    _locService.delegate = nil;
    if (self.isTabBarNaviHiden && !self.isNaviPush) {//如果当前是隐藏状态,则都让它显示出来
        [self tapMapViewBlank];
    }
    [self.countButton cancelTimer];//视图消失时关闭倒计时
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([BYSaveTool boolForKey:BYMonitorKey]) {
        [self initMapView];//初始化mapView
        [self initBaseUI]; //初始化UI
        //    [self initLocationService];//初始化定位服务
        //    if (BYSIMULATOR) [self connectSocket];//如果是模拟器的话,socket连接,解决模拟器无法定位的问题
        [self loadInfos];
        self.currentName = [BYSaveTool objectForKey:BYusername];
    }else{
        [self initEmptyView];
    }
    
    
}

-(void)initEmptyView{
    UILabel *emptyLabel = [[UILabel alloc] init];
    emptyLabel.font = Font(17);
    emptyLabel.textColor = UIColorHexFromRGB(0x313131);
    emptyLabel.text = @"没有该模块权限，\n如有需要请联系管理员开启！";
    emptyLabel.numberOfLines = 0;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:emptyLabel];
    [emptyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(BYS_W_H(300), BYS_W_H(50)));
    }];
}


- (void)loadInfos{
    self.mapView.delegate = self;
    self.searcher.delegate = self;
    self.locationManager.delegate = self;
    self.FirstLocate = YES;
    self.FirstLoad = YES;
    [self initLocationService];//初始化定位服务
    
    [self.mapView addSubview:self.searchBar];
    if (self.shareId.length) {
        self.searchBar.hidden = YES;
    }else{
        self.searchBar.hidden = NO;
    }

#warning 跳转到搜索页面
    BYWeakSelf;
    [self.searchBar setSearchBlock:^{
        
        BYControlSearchViewController *searchVC = [[BYControlSearchViewController alloc] init];
        searchVC.type = 1;
        [searchVC setSearchCallBack:^(NSString *searchStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (searchStr.length > 0) {
                    weakSelf.searchBar.searchLabel.text = searchStr;
                    weakSelf.searchBar.searchLabel.textColor = [UIColor colorWithHex:@"#323232"];
                }else{
                    weakSelf.searchBar.searchLabel.text = @"搜索设备号、车牌号、车主姓名";
                    weakSelf.searchBar.searchLabel.textColor = [UIColor colorWithHex:@"#909090"];
                }
                
                weakSelf.selectIndex = 0;
                if (searchStr.length > 0) {
                    weakSelf.queryStr = searchStr;
                    weakSelf.isQueryType = YES;
                    weakSelf.FirstLoad = YES;
                    weakSelf.isSearch = YES;
                    weakSelf.isRepeatLogin = NO;
                    
                    weakSelf.leftCarButton.hidden = YES;
                    weakSelf.rightCarButton.hidden = YES;
                    
                    [weakSelf.totalDatasource removeObjectsInArray:weakSelf.dataSource];
                    [weakSelf.dataSource removeAllObjects];
                    [weakSelf.mapView removeAnnotations:weakSelf.carAnnotations];//地图清空车辆标注
                    [weakSelf.annotations removeObjectsInArray:weakSelf.carAnnotations];//清空所有车辆标注
                    [weakSelf.carAnnotations removeAllObjects];
                    [weakSelf.annotationViews removeAllObjects];//清空所有气泡
                    [weakSelf.fenceAnnotationViews removeAllObjects];
                    [weakSelf.countButton cancelTimer];
                    [weakSelf.countButton setTitle:@"正在刷新..." forState:UIControlStateNormal];
                    [weakSelf loadDeviceData];
                    //                    [weakSelf loadDeviceData];//发送搜索请求
                }else{
                    [weakSelf cleanSearch];
                }
            });
        }];
        [weakSelf.navigationController pushViewController:searchVC animated:YES];
        
    }];
    
    //添加右上角功能按钮
    [self.mapView addSubview:self.funcItemsBgView];
    if (![BYSaveTool boolForKey:BYMonitorInfo]) {
        self.highRiskItem.hidden = YES;
    }else{
        self.highRiskItem.hidden = NO;
    }
    
    [self.totalDatasource removeObjectsInArray:self.dataSource];
    [self.dataSource removeAllObjects];//清空所有车数据
    [self.mapView removeAnnotations:self.carAnnotations];//地图清空所有标注
    [self.carAnnotations removeAllObjects];//清空所有车标注
    //    if (self.polygon) {
    //        [self.mapView removeOverlay:self.polygon];
    //    }
    //    if (self.circle) {
    //        [self.mapView removeOverlay:self.circle];
    //    }
    [self.annotations removeObjectsInArray:self.carAnnotations];//清空所有标注数据
    [self.annotationViews removeAllObjects];//清空所有气泡
    [self.fenceAnnotationViews removeAllObjects];
    //    [self.fenceAnnotations removeAllObjects];
    if (self.isRepeatLogin) {
        self.searchBar.searchLabel.text = @"搜索设备号、车牌号、车主姓名";
        self.searchBar.searchLabel.textColor = [UIColor colorWithHex:@"#909090"];
        self.isQueryType = NO;
    }
    
    //隐藏左右两边切换车辆按钮
    self.leftCarButton.hidden = YES;
    self.rightCarButton.hidden = YES;
    BYLog(@"self.isQueryType --------------------- %zd",self.isQueryType);
    if (self.FirstLoad == NO || self.isNaviPush || self.userLocation.location) {//当是选中设备模式则正常连接,不是的话则要先获取到定位信息再连接
        [self.countButton setTitle:@"正在刷新..." forState:UIControlStateNormal];
        [self loadDeviceData];
    }
    
    _controlRefreshDuration = [BYSaveTool getRefreshDurationIntegerWithKey:BYControlRefreshDuration];//取出本地刷新间隔
    
    self.mapView.compassPosition = CGPointMake(margin, self.isNaviPush ? BYSCREEN_H - self.mapView.compassSize.width - 15 : BYSCREEN_H - BYTabBarH - self.mapView.compassSize.width - 15);//设置指南针位置
}

#pragma mark 请求地址
-(void)geoDecodeWith:(CLLocationCoordinate2D)coordinate{
    
    if (self.annotations.count == 0 || self.dataSource.count == 0) {
        return ;
    }
    BYAnnotationView * annoView = (BYAnnotationView *) self.selectAnnoView;
    NSInteger index = [self.annotations indexOfObject:self.selectAnnoView.annotation];
    if (index >= self.dataSource.count) {
        index = 0;
    }
    BYControlModel * model = self.dataSource[index];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BYRegeoHttpTool POSTRegeoAddressWithLat:model.lat lng:model.lon success:^(id data) {
            
            if (self.annotations.count == 0 || self.dataSource.count == 0) {
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                for (UIView * view in annoView.paopaoView.subviews) {
                    if ([view isKindOfClass:[BYControlPopView class]]) {
                        NSInteger index = [self.annotations indexOfObject:annoView.annotation];
                        if (index >= self.dataSource.count) {
                            return;
                        }
                        BYControlModel * model = self.dataSource[index];
                        BYControlPopView * pop = (BYControlPopView *)view;
                        if ([model.model isEqualToString:@"013C"]) {
                            pop.address = @"无法获取当前位置";
                        }else{
                            pop.address = [data[@"address"] isEqualToString:@""] ? @"无法获取当前位置" : data[@"address"];
                        }
                        model.shareId = _shareId;
                        pop.model = model;
                        annoView.paopaoView.by_height = model.pop_H;
                        pop.frame = CGRectMake(0, 0, BYS_W_H(245), model.pop_H);
                        [self.mapView mapForceRefresh];
                    }
                }
            });
            BYLog(@"%@",data);
        } failure:^(NSError *error) {
            for (UIView * view in annoView.paopaoView.subviews) {
                if ([view isKindOfClass:[BYControlPopView class]]) {
                    
                    BYControlPopView * pop = (BYControlPopView *)view;
                    pop.address = @"无法获取当前位置";
                }
            }
        }];
    });
}

-(void)initMapView{
    
    //init mapView
    self.mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.mapType = BMKMapTypeStandard;
    self.mapView.showMapScaleBar = YES;
    self.mapView.mapScaleBarPosition = CGPointMake(10, _mapView.frame.size.height - SafeAreaBottomHeight - 40);
    self.view = self.mapView;
    
    //测试
    [self.mapView setZoomLevel:15];
    
//    self.mapView.showsUserLocation = NO;
    
    //    BMKUserTrackingModeNone = 0,             /// 普通定位模式
    //    BMKUserTrackingModeHeading,              /// 定位方向模式
    //    BMKUserTrackingModeFollow,               /// 定位跟随模式
    //    BMKUserTrackingModeFollowWithHeading,    /// 定位罗盘模式
    
    self.mapView.userTrackingMode = BMKUserTrackingModeHeading;
    self.mapView.showsUserLocation = YES;
    [self setUserImage];
    self.mapView.isSelectedAnnotationViewFront = YES;//设定是否总让选中的annotaion置于最前面
}

-(void)initLocationService{
    
//    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:baiduMapKey authDelegate:self];
    //初始化实例
    _locationManager = [[BMKLocationManager alloc] init];
    //设置delegate
    _locationManager.delegate = self;
    //设置返回位置的坐标系类型
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    //设置距离过滤参数
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    //设置预期精度参数
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //设置应用位置类型
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    //设置是否自动停止位置更新
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    //设置是否允许后台定位
    //    _locationManager.allowsBackgroundLocationUpdates = NO;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;

    [_locationManager startUpdatingLocation];
    [_locationManager startUpdatingHeading];
}

#pragma mark -设置定位圆点属性
-(void)setUserImage{
    //用户位置类
    _displayParam = [[BMKLocationViewDisplayParam alloc] init];
    _displayParam.isRotateAngleValid = true;// 跟随态旋转角度是否生效
    _displayParam.isAccuracyCircleShow = false;// 精度圈是否显示
    _displayParam.locationViewImage = [UIImage imageNamed:@"icon-arrow"];// 定位图标名称
    _displayParam.locationViewOffsetX = 0;//定位图标偏移量(经度)
    _displayParam.locationViewOffsetY = 0;// 定位图标偏移量(纬度)
    [_mapView updateLocationViewWithParam:_displayParam]; //调用此方法后自定义定位图层生效
}

-(void)initBaseUI{
    
    if (!self.isNaviPush) {//根据是否为选择设备进来的来判断是否隐藏导航栏
        self.navigationView.hidden = YES;
    }else{
        [self.navigationView setTitle:@"在线监控"];
    }
    
    self.isTabBarNaviHiden = NO;
    self.selectIndex = 0;
    self.FirstLoad = YES;//视图加在完成时设置为第一次请求数据
    
    //添加放大缩小按钮
    [self.mapView addSubview:self.zoomLevelImageView];
    
    //添加左右边按钮,默认隐藏
    [self.mapView addSubview:self.leftCarButton];
    self.leftCarButton.hidden = YES;
    [self.mapView addSubview:self.rightCarButton];
    [self.mapView addSubview:self.searchHighRiskButton];
    self.searchHighRiskButton.hidden = YES;
    self.rightCarButton.hidden = YES;
    
    [self.mapView addSubview:self.countButton];//在视图即将显示的时候添加倒计时button,以便刷新间隔
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repeatLogin) name:BYRepeatLoginKey object:nil];
}

//每当用户登录时都发送一个通知到首页,将第一次加载置为YES,让菊花转起来
-(void)repeatLogin{
    
    self.isRepeatLogin = YES;
    
}

-(void)changeMapType:(UIButton *)button{
    MobClickEvent(@"monitoring_map", @"");
    button.selected = !button.selected;
    self.mapView.mapType = button.selected ? BMKMapTypeSatellite : BMKMapTypeStandard;
}

-(void)changeMeCarLocation:(UIButton *)button{
    button.selected = !button.selected;
    
    CLLocationCoordinate2D coordinate;
    if (button.selected) {
        coordinate = self.userLocation.location.coordinate;
    }else{
        if (self.annotations.count > 0) {
            BMKPointAnnotation * an = self.annotations[self.selectIndex];
            coordinate = an.coordinate;
            [self.mapView selectAnnotation:an animated:YES];
        }
    }
    [self.mapView setCenterCoordinate:coordinate];
}

#pragma mark 前往导航
-(void)gotoBaiduMapActionWithDeviceId:(NSInteger)deviceId{
    
    [BYDeviceDetailHttpTool POSTQueryOtherDevideWithDeviceId:deviceId success:^(id data) {
        
        if (![data isKindOfClass:[NSNull class]]) {
            [self alertShowWithData:data];
        }else{
            [self gotoBaiduMap];
        }
    }];
}

-(void)gotoBaiduMap{
    
    BYControlModel * model = self.dataSource[self.selectIndex];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BYDeviceDetailHttpTool POSTOpenDeviceAlarmWithDeviceId:model.deviceId success:^(id data) {
            
        }];
    });
    
    BMKOpenDrivingRouteOption * drive = [[BMKOpenDrivingRouteOption alloc] init];
    drive.appScheme = @"baidumapsdk1://gps.bycda";//用于调起成功后，返回原应用
    
    BMKPlanNode * start = [[BMKPlanNode alloc]init];//初始化起点节点
    
    start.pt = self.userLocation.location.coordinate;//指定起点经纬度
    drive.startPoint = start;//指定起点
    
    BMKPlanNode* end = [[BMKPlanNode alloc]init];//初始化终点节点
//    BYControlModel * model = self.dataSource[self.selectIndex];
    end.pt = CLLocationCoordinate2DMake(model.lat, model.lon);
    drive.endPoint = end;
    
    //打开地图驾车路线检索,返回错误码
    BMKOpenErrorCode code = [BMKOpenRoute openBaiduMapDrivingRoute:drive];
    
    switch (code) {
        case BMK_OPEN_OPTION_NULL :
            [BYProgressHUD by_showErrorWithStatus:@"导航位置为空"];
            break;
        case BMK_OPEN_ROUTE_START_ERROR:
            [BYProgressHUD by_showErrorWithStatus:@"导航起点有误"];
            break;
        case BMK_OPEN_ROUTE_END_ERROR:
            [BYProgressHUD by_showErrorWithStatus:@"导航终点有误"];
            break;
        case BMK_OPEN_NOT_SUPPORT:
            [BYProgressHUD by_showErrorWithStatus:@"不支持百度导航"];
            break;
        case BMK_OPEN_NETWOKR_ERROR:
            [BYProgressHUD by_showErrorWithStatus:@"网络错误"];
        default:
            break;
    }
}

-(void)alertShowWithData:(id)data{
    
    if (data != nil) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"该设备离线太久，是否切换到其他GPS设备定位" preferredStyle:UIAlertControllerStyleAlert];
        if ([BYObjectTool getIsIpad]){
            
            alertVC.popoverPresentationController.sourceView = self.view;
            alertVC.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
        }
        UIAlertAction *actionOK = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            BYPushNaviModel *pushModel = [[BYPushNaviModel alloc] initWithDictionary:data error:nil];
            
            BYDetailTabBarController * detailTabBarVC = [[BYDetailTabBarController alloc] init];
            detailTabBarVC.selectedIndex = 1;
            detailTabBarVC.model = pushModel;
            [self.navigationController pushViewController:detailTabBarVC animated:YES];
        }];
        
        UIAlertAction *actionCancle = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self gotoBaiduMap];
        }];
        
        [alertVC addAction:actionCancle];
        [alertVC addAction:actionOK];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }else{
        [self gotoBaiduMap];
    }
}

-(void)rightCarAction{//下一台车
    MobClickEvent(@"monitoring_right", @"");
//    BMKPointAnnotation * an = self.annotations[self.selectIndex];
//    [self.mapView deselectAnnotation:an animated:YES];
    self.selectIndex ++;
    self.selectIndex = self.selectIndex > self.dataSource.count - 1 ? 0 : self.selectIndex;
    BMKPointAnnotation * selan = self.annotations[self.selectIndex];
//    BYAnnotationView *annotationview = self.annotationViews[self.selectIndex];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.mapView selectAnnotation:selan animated:YES];
    });
}
-(void)leftCarAction{//上一台车
    
    MobClickEvent(@"monitoring_left", @"");
//    BMKPointAnnotation * an = self.annotations[self.selectIndex];
//    [self.mapView deselectAnnotation:an animated:YES];
    self.selectIndex --;
    self.selectIndex = self.selectIndex < 0 ? self.dataSource.count - 1 : self.selectIndex;
    BYLog(@"%zd",_selectIndex);
    BMKPointAnnotation * selan = self.annotations[self.selectIndex];
    [self.mapView selectAnnotation:selan animated:YES];
}

-(void)zoomInLevel{//放大
    [self.mapView zoomIn];
    BYLog(@"----- level == %f",self.mapView.zoomLevel);
}
-(void)zoomOutLevel{//缩小
    [self.mapView zoomOut];
    BYLog(@"----- level == %f",self.mapView.zoomLevel);
}

//#pragma mark - <textFiledDelegate>
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//    self.selectIndex = 0;
//
//    if (textField.text.length == 0) {
//        [BYProgressHUD by_showErrorWithStatus:@"搜索不能为空"];
//        return YES;
//    }else{
//        self.queryStr = self.searchBar.searchField.text;
//    }
//    [textField resignFirstResponder];
//    self.isQueryType = YES;
//    self.FirstLoad = YES;
//    self.isSearch = YES;
//
//    self.leftCarButton.hidden = YES;
//    self.rightCarButton.hidden = YES;
//
//    [self.totalDatasource removeObjectsInArray:self.dataSource];
//    [self.dataSource removeAllObjects];
//    [self.mapView removeAnnotations:self.carAnnotations];//地图清空车辆标注
//    [self.annotations removeObjectsInArray:self.carAnnotations];//清空所有车辆标注
//    [self.carAnnotations removeAllObjects];
//    [self.annotationViews removeAllObjects];//清空所有气泡
//    [self.fenceAnnotationViews removeAllObjects];
//    [self.countButton cancelTimer];
//    [self loadMonitorDeviceStatus];//发送搜索请求
//    return YES;
//}
//- (BOOL)textFieldShouldClear:(UITextField *)textField{
//    if (self.isQueryType == YES) {
//        [self cleanSearch];
//    }
//    return YES;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length == 1 && range.location == 0 && string.length == 0 && self.isQueryType == YES) {
        [self cleanSearch];
    }
    return YES;
}

-(void)cleanSearch{
    [self.countButton cancelTimer];
    self.isQueryType = NO;
    self.FirstLoad = YES;
    self.selectIndex = 0;
    self.leftCarButton.hidden = YES;
    self.rightCarButton.hidden = YES;
    [self.totalDatasource removeObjectsInArray:self.dataSource];
    [self.dataSource removeAllObjects];//清空所有源数据
    [self.mapView removeAnnotations:self.carAnnotations];//地图清空车辆标注
    [self.annotations removeObjectsInArray:self.carAnnotations];//清空所有车辆标注
    [self.carAnnotations removeAllObjects];
    [self.annotationViews removeAllObjects];//清空所有气泡
    [self.fenceAnnotationViews removeAllObjects];
    BYLog(@"*&***************cleanSearch self.FirstLoad return%zd",self.FirstLoad);
//    [self loadDeviceData];//发送搜索请求
    [self.countButton setTitle:@"正在刷新..." forState:UIControlStateNormal];
    [self loadDeviceData];
}

#pragma mark - <地图代理方法>

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if (![annotation isKindOfClass:[BMKUserLocation class]]){
        if (self.annotations.count == 0 || self.totalDatasource.count == 0) {
            return nil;
        }
        if ([annotation isKindOfClass:[BMKPointAnnotation class]]){
           
            NSInteger index = [self.annotations containsObject:annotation]?[self.annotations indexOfObject:annotation]:0;
            BYControlModel * model = self.totalDatasource[index];
            if (model.type) {
                BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
                
                newAnnotationView.annotation = annotation;
                newAnnotationView.canShowCallout = YES;
                newAnnotationView.image = [UIImage imageNamed:@"icon_risk"];
                newAnnotationView.hidePaopaoWhenSelectOthers = YES;
                return newAnnotationView;
                
            }else{
                if (self.dataSource.count == 0) {
                    return nil;
                }
                BYControlModel * model = self.dataSource[index];
                
                BYAnnotationView * annotationView = [[BYAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
                annotationView.isControlCar = YES;
                annotationView.alarmOrOff = model.iconId;//将状态赋值过去
                annotationView.canShowCallout = YES;
                annotationView.hidePaopaoWhenSelectOthers = YES;
                NSString *carNumStr;
                if (model.carId > 0) {
                    if (model.carNum.length > 0) {
                        carNumStr = model.carNum;
                        carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
                    }else{
                        if (model.carVin.length > 6) {
                            NSRange range = NSMakeRange(model.carVin.length - 6, 6);
                            carNumStr = [NSString stringWithFormat:@"...%@",[model.carVin substringWithRange:range]];
                        }else{
                            carNumStr = model.carVin;
                        }
                    }
                }else{
                    carNumStr = model.sn;
                }
                
                NSString *ownerNameStr = [NSString StringJudgeIsValid:model.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
                
                ownerNameStr = ownerNameStr.length > 4 ? [NSString stringWithFormat:@"%@...",[ownerNameStr substringToIndex:4]] : ownerNameStr;
                annotationView.carNum = [NSString stringWithFormat:@"%@(%@) %@",carNumStr,model.wifi ? @"无线" : @"有线",ownerNameStr];
                
                [self.annotationViews addObject:annotationView];
                //定制popView
                BYControlPopView *popView = [BYControlPopView by_viewFromXib];
                model.shareId = _shareId;
                popView.model = model;
                popView.distance = [self distanceBetweenYouAndMeWithLat:model.lat lng:model.lon];
                
                BYWeakSelf;
                [popView setDeviceDetailBlcok:^(NSInteger tag) {//跳转到设备tabBar
                
                    
                    [weakSelf popToDetailTabBarVcWith:index tag:tag];
                    switch (tag) {
                        case 0:
                             MobClickEvent(@"monitoring_details", @"");
                            break;
                        case 1:
                            MobClickEvent(@"monitoring_real_time", @"");
                            break;
                        case 2:
                            MobClickEvent(@"monitoring_control", @"");
                            break;
                        default:
                            break;
                    }
                }];
                
#pragma mark 轨迹回放
                [popView setGotoReplayControllerBlock:^{
                    MobClickEvent(@"monitoring_history", @"");
                    BYReplayController *replayVC = [[BYReplayController alloc] init];
                    BYControlModel * model = self.dataSource[index];
                    BYPushNaviModel * pushModel = [[BYPushNaviModel alloc] init];
                    pushModel.deviceId = model.deviceId;
                    pushModel.carNum = model.carNum;
                    pushModel.carVin = model.carVin;
                    pushModel.carId = model.carId;
                    pushModel.sn = model.sn;
                    pushModel.wifi = model.wifi;
                    pushModel.model = model.model;
                    pushModel.carStatus = model.carStatus;
                    pushModel.ownerName = model.ownerName;
                    
                    replayVC.myModel = pushModel;
                    [weakSelf.navigationController pushViewController:replayVC animated:YES];
                }];
#pragma mark 导航
                [popView setGotoBaiduMapBlock:^{
                    MobClickEvent(@"monitoring_GPS", @"");
                    if (model.carId > 0) {
                        [weakSelf gotoBaiduMapActionWithDeviceId:model.deviceId];
                    }else{
                        return BYShowError(@"该设备未装车");
                    }
                    
                }];
                
                popView.frame = CGRectMake(0, 0, BYS_W_H(245), model.pop_H);
                
                BMKActionPaopaoView * paopaoView=[[BMKActionPaopaoView alloc] initWithCustomView:popView];
                annotationView.paopaoView = paopaoView;
                
                //计算偏移的宽度
                CGSize carNumSize = [[NSString stringWithFormat:@"%@(%@) %@",carNumStr,model.wifi ? @"无线" : @"有线",ownerNameStr] sizeWithAttributes: @{NSFontAttributeName: BYS_T_F(12)}];
                CGFloat offset_W = (carNumSize.width + 45) / 2 - 12;
                annotationView.centerOffset = CGPointMake(offset_W, - 3);
                annotationView.calloutOffset = CGPointMake(- offset_W, -10);
                
                [popView setDismissBlcok:^{//气泡消失
//                    paopaoView.hidden = annotationView.isSelected;
//                    [annotationView setSelected:NO animated:YES];
                    [self.mapView deselectAnnotation:annotation animated:YES];
                    
                }];
                
                #pragma mark -- 分享
                [popView setGotoShareBlock:^(BYControlModel *model){
                    MobClickEvent(@"monitoring_share", @"");
                    if (model.carId > 0) {
                        BYSendShareController *vc = [[BYSendShareController alloc] init];
                        BYShareCommitParamModel *paramModel = [[BYShareCommitParamModel alloc] init];
                        paramModel.carNum = model.carNum;
                        paramModel.carBrand = model.brand;
                        paramModel.carSet = model.carType;
                        paramModel.carOwnerName = model.ownerName;
                        paramModel.carColor = model.carColor;
                        paramModel.carVin = model.carVin;
                        paramModel.address = model.adress;
                        paramModel.carId = [NSString stringWithFormat:@"%zd",model.carId];
                        NSMutableArray *deviceList = [NSMutableArray array];
                        BYShareCommitDeviceModel *deviceModel = [[BYShareCommitDeviceModel alloc] init];
                        deviceModel.deviceId = [NSString stringWithFormat:@"%zd",model.deviceId];
                        deviceModel.deviceSn = model.sn;
                        deviceModel.deviceType = model.wifi;
                        deviceModel.deviceModel = model.model;
                        deviceModel.alias = model.alias;
                        deviceModel.isSelect = YES;
                        [deviceList addObject:deviceModel];
                        paramModel.deviceShare = deviceList;
                        
                        
                        NSMutableArray *shareMobile = [NSMutableArray array];
                        NSMutableArray *shareLine = [NSMutableArray array];
                        paramModel.shareMobile = shareMobile;
                        paramModel.shareLine = shareLine;
                        vc.paramModel = paramModel;
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    }else{
                        return BYShowError(@"该设备未装车,不能分享");
                    }
                   
                }];
                
#pragma mark --自助装
                [popView setGotoAutoInstallBlock:^{
                    BYInstallDeviceCheckViewController *vc = [[BYInstallDeviceCheckViewController alloc] init];
                    vc.deviceSn = model.sn;
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                
                return annotationView;
            }
        }
    }
    
    return nil;
}

-(void)popToDetailTabBarVcWith:(NSInteger)index tag:(NSInteger)tag{
    
    BYDetailTabBarController * detailTabBarVC = [[BYDetailTabBarController alloc] init];
    BYControlModel * model = self.dataSource[index];
    BYPushNaviModel * pushModel = [[BYPushNaviModel alloc] init];
    pushModel.deviceId = model.deviceId;
    pushModel.carNum = model.carNum;
    pushModel.carVin = model.carVin;
    pushModel.carId = model.carId;
    pushModel.sn = model.sn;
    pushModel.wifi = model.wifi;
    pushModel.model = model.model;
    pushModel.carStatus = model.carStatus;
    pushModel.ownerName = model.ownerName;
    pushModel.batteryNotifier = model.batteryNotifier;
    pushModel.shareId = _shareId;
    detailTabBarVC.selectedIndex = tag;
    detailTabBarVC.model = pushModel;
    [self.navigationController pushViewController:detailTabBarVC animated:YES];
}
#pragma mark 点击选择标注
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
//    for (BYAnnotationView * annoView in self.annotationViews) {
//        annoView.paopaoView.hidden = YES;
//        annoView.selected = NO;
//    }
    
//    view.paopaoView.hidden = NO;
//    BMKPointAnnotation *seleAn = self.annotations[self.selectIndex];
//    [self.mapView deselectAnnotation:seleAn animated:YES];
    if (self.annotations.count == 0 || self.totalDatasource.count == 0) {
        return;
    }
    if ([view isKindOfClass:[BYAnnotationView class]]) {

        BYAnnotationView *cusView = (BYAnnotationView *)view;
        BMKPointAnnotation *an = (BMKPointAnnotation *)cusView.annotation;
        self.selectIndex = [self.annotations indexOfObject:an];
        self.selectAnnoView = self.annotationViews[self.selectIndex];
//        cusView.paopaoView.hidden = NO;
        [self geoDecodeWith:an.coordinate];
        [self.mapView setCenterCoordinate:an.coordinate];
    }
    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
//        BMKPointAnnotation *seleAn = self.annotations[self.selectIndex];
//        [self.mapView deselectAnnotation:seleAn animated:YES];
        BMKPinAnnotationView *pinView = (BMKPinAnnotationView *)view;
        self.selectIndex = [self.annotations indexOfObject:pinView.annotation];
        BYControlModel * model = self.totalDatasource[self.selectIndex];
        BYLog(@"%@",model.name);
        [self drawFenceRegionWithModel:model];
        self.selectIndex = 0;
    }
    BYLog(@"%zd",_selectIndex);
}
-(void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    if ([view isKindOfClass:[BYAnnotationView class]]) {
        BYAnnotationView *cusView = (BYAnnotationView *)view;
//        BMKPointAnnotation *an = (BMKPointAnnotation *)cusView.annotation;
//        self.selectIndex = [self.annotations indexOfObject:an];
//        self.selectAnnoView = self.annotationViews[self.selectIndex];
//        cusView.paopaoView.hidden = YES;
//        [self geoDecodeWith:an.coordinate];
//        [self.mapView setCenterCoordinate:an.coordinate];
    }
}
#pragma mark 根据模型添加围栏
-(void)drawFenceRegionWithModel:(BYControlModel *)model
{
    if (self.polygon) {
        [self.mapView removeOverlay:self.polygon];
    }
    if (self.circle) {
        [self.mapView removeOverlay:self.circle];
    }
    if (model.type == 1) {
        // 添加圆形覆盖物
        NSArray *centerArr = [model.parameter componentsSeparatedByString:@","];
        
        CLLocationCoordinate2D coor;
        coor.latitude  = [centerArr[1] floatValue];
        coor.longitude = [centerArr[0] floatValue];
        self.circle = [BMKCircle circleWithCenterCoordinate:coor radius:model.radius];
        
        [self.mapView addOverlay:self.circle];
    }else{
        // 添加多边形覆盖物
        NSArray *polyArr = [model.parameter componentsSeparatedByString:@"|"];
        NSInteger count = polyArr.count;
        CLLocationCoordinate2D * coords = malloc(sizeof(CLLocationCoordinate2D) * count);
        for (int i = 0 ; i < polyArr.count ; i ++) {
            NSArray *coorArr = [polyArr[i] componentsSeparatedByString:@","];
            coords[i].latitude = [coorArr[1] doubleValue];
            coords[i].longitude = [coorArr[0] doubleValue];
        }
        self.polygon = [BMKPolygon polygonWithCoordinates:coords count:count];
        BYLog(@"fdfdefd");
        [_mapView addOverlay:self.polygon];
        
        free(coords);//释放数组;
    }
}

-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    
    if (self.polygon) {
        [self.mapView removeOverlay:self.polygon];
    }
    if (self.circle) {
        [self.mapView removeOverlay:self.circle];
    }
//    [self.searchBar.searchField resignFirstResponder];
    if (!self.isNaviPush) {
        [self tapMapViewBlank];
    }
}
#pragma mark 地图区域即将改变时会调用此接口
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    self.searchHighRiskButton.hidden = YES;
    
}

- (void)mapView:(BMKMapView *)mapView onDrawMapFrame:(BMKMapStatus*)status{
    
}
#pragma mark 地图区域已经改变，判断围栏区域是否在区域内
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.beenLoadHighRisk = NO;
    if (mapView.zoomLevel >= 12 && self.highRiskSelected) {
        self.searchHighRiskButton.hidden = NO;
//        self.searchHighRiskButton.enabled = YES;
        [self.searchHighRiskButton setTitle:@"点击显示此区域内高危围栏" forState:UIControlStateNormal];
    }else{
        self.searchHighRiskButton.hidden = YES;
    }
    
//    CGFloat centerLongitude = self.mapView.region.center.longitude;
//    CGFloat centerLatitude = self.mapView.region.center.latitude;
//
//    //当前屏幕显示范围的经纬度
//    CLLocationDegrees pointssLongitudeDelta = self.mapView.region.span.longitudeDelta;
//    CLLocationDegrees pointssLatitudeDelta = self.mapView.region.span.latitudeDelta;
//
//    //左上角
//    CGFloat leftUpLong = centerLongitude - pointssLongitudeDelta/2.0;
//    CGFloat leftUpLati = centerLatitude - pointssLatitudeDelta/2.0;
//
//    //右上角
//    CGFloat rightUpLong = centerLongitude + pointssLongitudeDelta/2.0;
//    CGFloat rightUpLati = centerLatitude - pointssLatitudeDelta/2.0;
//
//    //左下角
//    CGFloat leftDownLong = centerLongitude - pointssLongitudeDelta/2.0;
//    CGFloat leftDownlati = centerLatitude + pointssLatitudeDelta/2.0;
//
//    //右下角
//    CGFloat rightDownLong = centerLongitude + pointssLongitudeDelta/2.0;
//    CGFloat rightDownLati = centerLatitude + pointssLatitudeDelta/2.0;
//
//    CLLocationCoordinate2D coords[4] = {0};
//    coords[0].latitude = leftUpLati;
//    coords[0].longitude = leftUpLong;
//    coords[1].latitude = rightUpLati;
//    coords[1].longitude = rightUpLong;
//    coords[2].latitude = rightDownLati;
//    coords[2].longitude = rightDownLong;
//    coords[3].latitude = leftDownlati;
//    coords[3].longitude = leftDownLong;
//    if (self.highRiskItem.selected) {
//        //        [self.mapView removeAnnotations:self.fenceAnnotations];
//        for (NSInteger i = 0; i < self.fenceAnnotations.count; i ++) {
//            BMKPointAnnotation *annotation = self.fenceAnnotations[i];
//
//            if (BMKPolygonContainsCoordinate(annotation.coordinate, coords, 4)) {
//                BYLog(@"在视野内");
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.mapView addAnnotation:annotation];
//                });
//            }else{
//                [self.mapView removeAnnotation:annotation];
//            }
//        }
//    }
    BYLog(@"地图区域已经改变");
}




- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
//    [self.searchBar.searchField resignFirstResponder];
}

-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
        circleView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
        circleView.lineWidth = 0.1;
        
        return circleView;
    }
    if ([overlay isKindOfClass:[BMKPolygon class]]){
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
        polygonView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
        polygonView.lineWidth = 0.5;
        return polygonView;
    }
    return nil;
}


#pragma mark - <定位代理方法>


// 定位SDK中，方向变更的回调
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateHeading:(CLHeading *)heading {
    if (!heading) {
        return;
    }
    if (!self.userLocation) {
        self.userLocation = [[BMKUserLocation alloc] init];
    }
    self.userLocation.heading = heading;
    [self.mapView updateLocationData:self.userLocation];
}

// 定位SDK中，位置变更的回调
- (void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    if (!self.userLocation) {
        self.userLocation = [[BMKUserLocation alloc] init];
    }
    self.userLocation.location = location.location;
    [self.mapView updateLocationData:self.userLocation];
    if (self.isNaviPush == NO && self.FirstLoad == YES && self.mapView.delegate && self.FirstLocate == YES) {//如果是根据定位信息请求数据并且是第一次加载,并且不是搜索的类型,先获取定位信息,再连接webSocket
        [self.countButton setTitle:@"正在刷新..." forState:UIControlStateNormal];
        [self loadDeviceData];
        self.FirstLocate = NO;
    }
}
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//
//    [self.mapView updateLocationData:userLocation];
//
//}

-(CGFloat)distanceBetweenYouAndMeWithLat:(CGFloat)lat lng:(CGFloat)lng{
    
    if (self.userLocation.location) {//当数据加载过来并且已经定位到数据
        BMKMapPoint point1 = BMKMapPointForCoordinate(self.userLocation.location.coordinate);
        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(lat,lng));
        return BMKMetersBetweenMapPoints(point1,point2);
    }
    return 0;
}

// 添加动画Annotation
- (void)addAnnotationsWith:(NSMutableArray *)dataSource{
    
    [self.carAnnotations removeAllObjects];
    [self.annotationViews removeAllObjects];
    [self.annotations removeAllObjects];
    for (NSInteger i = 0; i < dataSource.count; i ++) {
        
        BYControlModel * model = dataSource[i];
        BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(model.lat, model.lon);//lat : 22.509903  lng : 113.950091
        [self.carAnnotations addObject:annotation];
    }
    [self.annotations addObjectsFromArray:self.carAnnotations];
    [self.annotations addObjectsFromArray:self.fenceAnnotations];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addAnnotations:self.carAnnotations];
        [self.mapView addAnnotations:self.fenceAnnotations];
    
        if (self.isQueryType) {
//            BYControlModel *model = self.dataSource[0];
            BMKPointAnnotation * an = self.carAnnotations.firstObject;
//            an.coordinate = CLLocationCoordinate2DMake(model.lat, model.lon);
            [self.mapView selectAnnotation:an animated:YES];
            [self.mapView setCenterCoordinate:an.coordinate];
        }else{
            //设置地图使显示区域显示所有annotations
            [self.mapView showAnnotations:self.carAnnotations animated:YES];
        }
    });
}

#pragma mark - lazy

-(BYSearchBar *)searchBar{
    if (_searchBar == nil) {
        //添加搜索框
        _searchBar = [[BYSearchBar alloc] initWithFrame:CGRectMake(margin, 20 + STATUSBAR_HEIGHT, BYSCREEN_W - 16, BYS_W_H(45))];
        _searchBar.by_y = self.isNaviPush ? BYNavBarMaxH + margin + STATUSBAR_HEIGHT : 20 + STATUSBAR_HEIGHT;
//        _searchBar.searchField.delegate = self;
        
        _searchBar.layer.shadowColor = [UIColor lightGrayColor].CGColor;//shadowColor阴影颜色
        _searchBar.layer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        _searchBar.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        //    self.searchBar.layer.shadowRadius = 8;//阴影半径，默认3
    }
    return _searchBar;
}

-(BYControlHttpParams *)httpParams
{
    if (!_httpParams) {
        _httpParams = [[BYControlHttpParams alloc] init];
    }
    return _httpParams;
}

-(NSMutableArray *)annotations{
    if (_annotations == nil) {
        _annotations = [[NSMutableArray alloc] init];
    }
    return _annotations;
}

-(NSMutableArray *)fenceAnnotations
{
    if (!_fenceAnnotations) {
        _fenceAnnotations = [NSMutableArray array];
    }
    return _fenceAnnotations;
}

-(UIView *)funcItemsBgView{
    if (_funcItemsBgView == nil) {
        
        _funcItemsBgView = [[UIView alloc] init];
        _funcItemsBgView.by_x = BYSCREEN_W - margin - 33;
        _funcItemsBgView.by_y = self.searchBar.by_y + self.searchBar.by_height + margin;
        _funcItemsBgView.by_width = 33;
        _funcItemsBgView.by_height = 33 * 4 + 3 * margin;
        _funcItemsBgView.backgroundColor = [UIColor clearColor];
        
        UIButton * mapTypeItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [mapTypeItem setImage:[UIImage imageNamed:@"control_icon_map"] forState:UIControlStateNormal];
        [mapTypeItem setImage:[UIImage imageNamed:@"control_icon_satellite"] forState:UIControlStateSelected];
        mapTypeItem.frame = CGRectMake(0, 0, 33, 33);
        [mapTypeItem addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventTouchUpInside];
        [_funcItemsBgView addSubview:mapTypeItem];
        
        UIButton * changeMeCarItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [changeMeCarItem setImage:[UIImage imageNamed:@"control_icon_switch"] forState:UIControlStateNormal];
        [changeMeCarItem setImage:[UIImage imageNamed:@"control_iconl_car"] forState:UIControlStateSelected];
        changeMeCarItem.frame = CGRectMake(0, 33 + margin, 33, 33);
        [changeMeCarItem addTarget:self action:@selector(changeMeCarLocation:) forControlEvents:UIControlEventTouchUpInside];
        [_funcItemsBgView addSubview:changeMeCarItem];
        //添加高危按钮
        self.highRiskItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.highRiskItem setImage:[UIImage imageNamed:@"control_icon_high_risk_normal"] forState:UIControlStateNormal];
        [self.highRiskItem setImage:[UIImage imageNamed:@"control_icon_high_risk_selected"] forState:UIControlStateSelected];
        self.highRiskItem.frame = CGRectMake(0, 33 * 2 + 2 * margin, 33, 33);
        [self.highRiskItem addTarget:self action:@selector(openOrCloseHishRisk:) forControlEvents:UIControlEventTouchUpInside];
        [_funcItemsBgView addSubview:self.highRiskItem];
        /*
         if (!_isNaviPush) {
         //        添加高德或百度地图切换按钮
         UIButton * changeMap = [UIButton buttonWithType:UIButtonTypeCustom];
         [changeMap setImage:[UIImage imageNamed:@"control_icon_gaode"] forState:UIControlStateNormal];
         changeMap.frame = CGRectMake(0, _funcItemsBgView.by_height - 33, 33, 33);
         [changeMap addTarget:self action:@selector(changeMapAction) forControlEvents:UIControlEventTouchUpInside];
         [_funcItemsBgView addSubview:changeMap];
         }*/
    }
    return _funcItemsBgView;
}

#pragma mark 打开高危
-(void)openOrCloseHishRisk:(UIButton *)button{
    
    MobClickEvent(@"monitoring_highRisk", @"");
    button.selected = !button.selected;
    self.highRiskSelected = button.selected;
    //如果数据库中找到了该该用户,那么更新状态
    if ([[BYFenceDataBase shareInstance] queryMenWithUserName:[BYSaveTool valueForKey:BYusername]].count) {
        [[BYFenceDataBase shareInstance] updateUserWithControlIsMonitor:button.selected user:[BYSaveTool valueForKey:BYusername]];
    }else{
        [[BYFenceDataBase shareInstance] insertFenceUser:[BYSaveTool valueForKey:BYusername] controlIsMonitor:button.selected trackIsMonitor:NO alarmIsMonitor:NO];
    }
    
    if (self.highRiskSelected == YES) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.noticeLabel.textColor = [UIColor whiteColor];
                self.noticeLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
                self.noticeLabel.frame = CGRectMake((SCREEN_WIDTH - 250) / 2, SCREEN_HEIGHT -SafeAreaBottomHeight - 120, 250, 50);
                self.noticeLabel.text = @"高危点已开启，请放大地图比例尺至5公里内查看！";
                self.noticeView.hidden = NO;
                
            }];
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
        });
        self.isFirstLoadFence = YES;
        
        if (self.mapView.zoomLevel >= 12) {
            self.searchHighRiskButton.hidden = NO;
//            self.searchHighRiskButton.enabled = YES;
            [self.searchHighRiskButton setTitle:@"点击显示此区域内高危围栏" forState:UIControlStateNormal];
        }else{
            self.searchHighRiskButton.hidden = YES;
        }
        
//        [self loadFenceAnnotationsData];
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.noticeLabel.textColor = [UIColor whiteColor];
                self.noticeLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
                self.noticeLabel.frame = CGRectMake((SCREEN_WIDTH - 250) / 2, SCREEN_HEIGHT -SafeAreaBottomHeight - 120, 250, 50);
                self.noticeLabel.text = @"高危点显示已关闭";
                self.noticeView.hidden = NO;
                
            }];
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
        });
        self.searchHighRiskButton.hidden = YES;
        if (self.polygon) {
            [self.mapView removeOverlay:self.polygon];
        }
        if (self.circle) {
            [self.mapView removeOverlay:self.circle];
        }
        [self.mapView removeAnnotations:self.fenceAnnotations];
        [self.totalDatasource removeAllObjects];
        [self.annotations removeObjectsInArray:self.fenceAnnotations];
        [self.fenceAnnotations removeAllObjects];
        [self.fenceDatasource removeAllObjects];
        //        [self.annotationViews removeAllObjects];
        [self.fenceAnnotationViews removeAllObjects];
        [self.totalDatasource addObjectsFromArray:self.dataSource];
        [self.mapView addAnnotations:self.carAnnotations];
        //        [self.mapView addAnnotations:self.fenceAnnotations];
    }
    
    if (self.highRiskSelected == NO) {
        //设置地图使显示区域显示所有annotations
        [self.mapView showAnnotations:self.annotations animated:YES];
    }
    
}

#pragma mark 检索高危点事件
-(void)highRiskView:(UIButton *)button
{
    
//    self.searchHighRiskButton.enabled = NO;
//    if (self.highRiskSelected == YES) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.5 animations:^{
//                self.noticeLabel.text = @"高危区域点已开启";
//                self.noticeView.hidden = NO;
//            }];
//            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
//        });
//        self.isFirstLoadFence = YES;
    if (!self.beenLoadHighRisk) {
        self.beenLoadHighRisk = YES;
        [self loadFenceAnnotationsData];
    }

}

-(void)loadFenceAnnotationsData{
    [BYQueryZoneHttpTool POSTQueryZoneSuccess:^(NSArray * data) {
        
        [self handleFenceDataWithFenceData:data];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)delayMethod
{
    self.noticeView.hidden = YES;
    [self.timer invalidate];
}
#pragma mark 处理围栏数据
-(void)handleFenceData:(BYControlModel *)model{
    
    if (model.type == 1) {//围栏是圆
        NSArray *locationDegreeArr = [model.parameter componentsSeparatedByString:@","];
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.title = model.name;
        annotation.coordinate = CLLocationCoordinate2DMake([locationDegreeArr[1] floatValue], [locationDegreeArr[0] floatValue]);
        [self.fenceAnnotations addObject:annotation];
    }else{//围栏是多边形
        
        if (model.centerLat&&model.centerLon) {
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            annotation.title = model.name;
            annotation.coordinate = CLLocationCoordinate2DMake([model.centerLat floatValue], [model.centerLon floatValue]);
            [self.fenceAnnotations addObject:annotation];
        }else{
            NSArray *centerArr = [model.parameter componentsSeparatedByString:@"|"];
            NSArray *centerDegreeArr = [centerArr[0] componentsSeparatedByString:@","];
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            annotation.title = model.name;
            annotation.coordinate = CLLocationCoordinate2DMake([centerDegreeArr[1] floatValue], [centerDegreeArr[0] floatValue]);
            [self.fenceAnnotations addObject:annotation];
        }
    }
    [self.fenceDatasource addObject:model];
    
}

-(UIButton *)leftCarButton{
    if (_leftCarButton == nil) {
        _leftCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftCarButton setImage:[UIImage imageNamed:@"control_arr_left_left"] forState:UIControlStateNormal];
        [_leftCarButton sizeToFit];
        _leftCarButton.by_x = 0;
        _leftCarButton.by_centerY = BYSCREEN_H / 2;
        [_leftCarButton addTarget:self action:@selector(leftCarAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftCarButton;
}

-(UIButton *)rightCarButton{
    if (_rightCarButton == nil) {
        _rightCarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightCarButton setImage:[UIImage imageNamed:@"control_arr_right"] forState:UIControlStateNormal];
        [_rightCarButton sizeToFit];
        _rightCarButton.by_x = BYSCREEN_W - _rightCarButton.by_width;
        _rightCarButton.by_centerY = BYSCREEN_H / 2;
        [_rightCarButton addTarget:self action:@selector(rightCarAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightCarButton;
}

-(UIButton *)searchHighRiskButton{
    if (!_searchHighRiskButton) {
        _searchHighRiskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchHighRiskButton setTitle:@"点击显示此区域内高危围栏" forState:UIControlStateNormal];
        [_searchHighRiskButton sizeToFit];
        _searchHighRiskButton.by_x = (BYSCREEN_W - 220)/2;
        _searchHighRiskButton.by_y = SCREEN_HEIGHT - SafeAreaBottomHeight - 50;
        _searchHighRiskButton.by_width = 220;
        _searchHighRiskButton.by_height = 40;
        
        _searchHighRiskButton.layer.cornerRadius = 15;
        _searchHighRiskButton.layer.masksToBounds = YES;
        _searchHighRiskButton.backgroundColor = WHITE;
        [_searchHighRiskButton setTitleColor:BYGlobalBlueColor forState:UIControlStateNormal];
        _searchHighRiskButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_searchHighRiskButton addTarget:self action:@selector(highRiskView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchHighRiskButton;
}

-(UIImageView *)zoomLevelImageView{
    if (_zoomLevelImageView == nil) {
        _zoomLevelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-jia"]];
        [_zoomLevelImageView sizeToFit];
        _zoomLevelImageView.userInteractionEnabled = YES;
        
        CGFloat imageW = _zoomLevelImageView.image.size.width;
        CGFloat imageH = _zoomLevelImageView.image.size.height;
        
        _zoomLevelImageView.by_x = BYSCREEN_W - margin - imageW;
        _zoomLevelImageView.by_y = self.isNaviPush ? BYSCREEN_H - imageH - 15 : BYSCREEN_H - BYTabBarH - imageH - 15;
        
        //放大按钮
        UIButton * zoomInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        zoomInButton.frame = CGRectMake(0, 0, imageW, imageH / 2);
        [zoomInButton addTarget:self action:@selector(zoomInLevel) forControlEvents:UIControlEventTouchUpInside];
        //缩小按钮
        UIButton * zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        zoomOutButton.frame = CGRectMake(0, imageH / 2, imageW, imageH / 2);
        [zoomOutButton addTarget:self action:@selector(zoomOutLevel) forControlEvents:UIControlEventTouchUpInside];
        
        [_zoomLevelImageView addSubview:zoomInButton];
        [_zoomLevelImageView addSubview:zoomOutButton];
    }
    return _zoomLevelImageView;
}

-(UIButton *)countButton{
    if (_countButton == nil) {
        _countButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _countButton.frame = CGRectMake(margin, self.searchBar.by_y + self.searchBar.by_height + margin, 95, 30);
        _countButton.backgroundColor = [UIColor whiteColor];
        [_countButton setTitle:@"正在刷新..." forState:UIControlStateNormal];
        [_countButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _countButton.titleLabel.font = BYS_T_F(14);
        _countButton.layer.cornerRadius = 3;
        _countButton.clipsToBounds = YES;
        _countButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _countButton.layer.borderWidth = 1;
        _countButton.userInteractionEnabled = NO;
    }
    return _countButton;
}

-(UIView *)noticeView
{
    if (!_noticeView) {
        UIView *noticeView = [[UIView alloc] init];
        noticeView.backgroundColor = [UIColor clearColor];
        noticeView.frame = CGRectMake(0, 0, self.view.by_width, self.view.by_height);
        [self.mapView addSubview:noticeView];
        _noticeView = noticeView;
    }
    return _noticeView;
}

-(UILabel *)noticeLabel
{
    if (!_noticeLabel) {
        UILabel *noticeLabel = [[UILabel alloc] init];
        noticeLabel.text = @"高危点已开启，请放大地图比例尺至5公里内查看！";
        noticeLabel.textAlignment = NSTextAlignmentCenter;
        noticeLabel.font = [UIFont systemFontOfSize:15];
        noticeLabel.textColor = [UIColor whiteColor];
        noticeLabel.numberOfLines = 0;
        noticeLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [noticeLabel.layer setMasksToBounds:YES];
        [noticeLabel.layer setCornerRadius:5.0];
        noticeLabel.frame = CGRectMake((SCREEN_WIDTH - 250) / 2, SCREEN_HEIGHT -SafeAreaBottomHeight - 120, 250, 50);
        self.noticeView.backgroundColor = [UIColor clearColor];
        [self.noticeView addSubview:noticeLabel];
        _noticeLabel = noticeLabel;
    }
    return _noticeLabel;
}

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
-(NSMutableArray *)fenceDatasource
{
    if (!_fenceDatasource) {
        _fenceDatasource = [NSMutableArray array];
    }
    return _fenceDatasource;
}
-(NSMutableArray *)annotationViews{
    if (_annotationViews == nil) {
        _annotationViews = [[NSMutableArray alloc] init];
    }
    return _annotationViews;
}
-(NSMutableArray *)fenceAnnotationViews
{
    if (!_fenceAnnotationViews) {
        _fenceAnnotationViews = [NSMutableArray array];
    }
    return _fenceAnnotationViews;
}

-(NSMutableArray *)carAnnotations
{
    if (!_carAnnotations) {
        _carAnnotations = [NSMutableArray array];
    }
    return _carAnnotations;
}
-(NSMutableArray *)totalDatasource
{
    if (!_totalDatasource) {
        _totalDatasource = [NSMutableArray array];
    }
    return _totalDatasource;
}

-(void)tapMapViewBlank{
    BYLogFunc;
    self.isTabBarNaviHiden = !self.isTabBarNaviHiden;
    
    BYWeakSelf;
    CGRect tabBarRect = self.tabBarController.tabBar.frame;//tabBar
    CGRect zoomRect = self.zoomLevelImageView.frame;
    CGPoint comPassPostion = self.mapView.compassPosition;
    
    CGRect naviRect = self.tabBarController.navigationView.frame;//naviBar
    CGRect funcItemsRect = self.funcItemsBgView.frame;//右上角功能按钮s
    CGRect countButtonRect = self.countButton.frame;//左上角倒计时按钮
    CGRect searchBarRect = self.searchBar.frame;//搜索框
    
    if (self.isTabBarNaviHiden) {
        if (self.isNaviPush) {//当push进来时,显示了导航栏
            naviRect.origin.y = -BYNavBarMinH;
            funcItemsRect.origin.y -= BYNavBarMinH;
            countButtonRect.origin.y -= BYNavBarMinH;
            searchBarRect.origin.y -= BYNavBarMinH;
        }else{//没有显示导航栏,显示tabBar
            tabBarRect.origin.y = BYSCREEN_H;
            zoomRect.origin.y += BYTabBarH - 9;
            comPassPostion.y += BYTabBarH - 9;
        }
        
    }else{
        if (self.isNaviPush) {
            naviRect.origin.y = BYStatusBarH;
            funcItemsRect.origin.y += BYNavBarMinH;
            countButtonRect.origin.y += BYNavBarMinH;
            searchBarRect.origin.y += BYNavBarMinH;
        }else{
            tabBarRect.origin.y = BYSCREEN_H - BYTabBarH;
            zoomRect.origin.y -= BYTabBarH - 9;
            comPassPostion.y -= BYTabBarH - 9;
        }
    }
    
    [UIView animateWithDuration:BYTabNaviHidenDuration animations:^{
        weakSelf.tabBarController.tabBar.frame = tabBarRect;
        weakSelf.zoomLevelImageView.frame = zoomRect;
        self.mapView.compassPosition = comPassPostion;
        weakSelf.funcItemsBgView.frame = funcItemsRect;
        weakSelf.countButton.frame = countButtonRect;
        weakSelf.tabBarController.navigationView.frame = naviRect;
        weakSelf.searchBar.frame = searchBarRect;
    }];
}

#pragma mark - 加载设备数据
-(void)loadDeviceData{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    if (self.isNaviPush) {//如果是从设备列表选择进来的,区别是选中车辆
        if (self.isQueryType == YES) {
            params[@"queryStr"] = self.queryStr;
            params[@"mark"] = @"0";
        }else{
            params[@"mark"] = @"0";
            params[@"deviceIds"] = self.deviceIdsStr;//@(159202);
        }
    }else{//直接是tabBar点击进来,则区别是附近20台车辆
        if (self.isQueryType == YES) {
            params[@"queryStr"] = self.queryStr;
            params[@"mark"] = @"0";
        }else{
            CLLocationCoordinate2D coordinate = self.userLocation.location.coordinate;
            params[@"mark"] = @"1";
            params[@"lat"] = BYSIMULATOR ? @"22.509903" : [NSString stringWithFormat:@"%6f",coordinate.latitude];
            params[@"lon"] = BYSIMULATOR ? @"113.950091" : [NSString stringWithFormat:@"%6f",coordinate.longitude];
        }
    }
    
 
    [BYMonitorHttpTool POSTMonitorDeviceStatusWithPragrams:params isShare:_shareId.length?1:0 success:^(id data) {
        [self.totalDatasource removeAllObjects];
        [self handleMonitorDeviceStatusData:data];
    } failure:^(NSError *error) {
        
    } showError:YES];
}

-(void)loadMonitorDeviceStatus{
    
    if (self.highRiskSelected == NO) {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        if (self.isNaviPush) {//如果是从设备列表选择进来的,区别是选中车辆
            if (self.isQueryType == YES) {
                params[@"queryStr"] = self.queryStr;
                params[@"mark"] = @"0";
            }else{
                params[@"mark"] = @"0";
                params[@"deviceIds"] = self.deviceIdsStr;//@(159202);
            }
        }else{//直接是tabBar点击进来,则区别是附近20台车辆
            if (self.isQueryType == YES) {
                params[@"queryStr"] = self.queryStr;
                params[@"mark"] = @"0";
            }else{
                CLLocationCoordinate2D coordinate = self.userLocation.location.coordinate;
                params[@"mark"] = @"1";
                params[@"lat"] = BYSIMULATOR ? @"22.509903" : [NSString stringWithFormat:@"%6f",coordinate.latitude];
                params[@"lon"] = BYSIMULATOR ? @"113.950091" : [NSString stringWithFormat:@"%6f",coordinate.longitude];
            }
        }
        
        [BYMonitorHttpTool POSTMonitorDeviceStatusWithPragrams:params isShare:_shareId.length?1:0 success:^(id data) {
            [self.totalDatasource removeAllObjects];
            [self handleMonitorDeviceStatusData:data];
        } failure:^(NSError *error) {
            
        } showError:YES];
        
    }else{

        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            if (self.isNaviPush) {//如果是从设备列表选择进来的,区别是选中车辆
                if (self.isQueryType == YES) {
                    params[@"queryStr"] = self.queryStr;
                    params[@"mark"] = @"0";
                }else{
                    params[@"mark"] = @"0";
                    params[@"deviceIds"] = self.deviceIdsStr;//@(159202);
                }
            }else{//直接是tabBar点击进来,则区别是附近20台车辆
                if (self.isQueryType == YES) {
                    params[@"queryStr"] = self.queryStr;
                    params[@"mark"] = @"0";
                }else{
                    CLLocationCoordinate2D coordinate = self.userLocation.location.coordinate;
                    params[@"mark"] = @"1";
                    params[@"lat"] = BYSIMULATOR ? @"22.509903" : [NSString stringWithFormat:@"%6f",coordinate.latitude];
                    params[@"lon"] = BYSIMULATOR ? @"113.950091" : [NSString stringWithFormat:@"%6f",coordinate.longitude];
                }
            }
            
            [BYMonitorHttpTool POSTMonitorDeviceStatusWithPragrams:params isShare:_shareId.length?1:0 success:^(id data) {
                [self handleMonitorDeviceStatusData:data];
                
            } failure:^(NSError *error) {

            } showError:YES];
        });
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [BYQueryZoneHttpTool POSTQueryZoneSuccess:^(id data) {

                [self handleFenceDataWithFenceData:data];
                
            } failure:^(NSError *error) {

            }];
        });
    }
}

-(void)handleMonitorDeviceStatusData:(id)data{
    [self.dataSource removeAllObjects];
    BYLog(@"*&***************handleMonitorDeviceStatusData self.FirstLoad return%zd",self.FirstLoad);
    self.isRepeatLogin = NO;
    NSArray * tempArr = [[NSArray alloc] init];
    if ([data isKindOfClass:[NSArray class]]) {//判断过来的数据是否是数组
        tempArr = data;
        
        BYLog(@"tempArrCount : %zd",tempArr.count);
        
        if (tempArr.count == 0) {//如果数组长度为0
            //添加左右两边切换车辆按钮
            self.leftCarButton.hidden = YES;
            self.rightCarButton.hidden = YES;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [UIView animateWithDuration:0.5 animations:^{
//                    self.noticeLabel.text = @"没有该车辆信息";
//                    self.noticeView.hidden = NO;
//                }];
//                _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
//            });
            
        }else{//数组长度不为0
            [BYProgressHUD by_dismiss];
        }
    }else if([data isKindOfClass:[NSNull class]]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                
                self.noticeLabel.textColor = [UIColor colorWithHex:@"#323232"];
                self.noticeLabel.backgroundColor = [UIColor whiteColor];
                self.noticeLabel.frame = CGRectMake(self.view.by_width / 2 - 100, SCREEN_HEIGHT - SafeAreaBottomHeight - 100, 200, 60);
                NSMutableAttributedString *hogan1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共查询到0条结果"]];
                
                [hogan1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(4, hogan1.length - 3 - 4)];
                [hogan1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#3AAAF4"] range:NSMakeRange(4, hogan1.length - 3 - 4)];
                self.noticeLabel.attributedText = hogan1;
                
                self.noticeView.hidden = NO;
            }];
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
            BYWeakSelf;
            [self.countButton startWithTime:_controlRefreshDuration zeroBlock:^{//开始倒计时
                [weakSelf loadDeviceData];
            }];
        });
        return;
    }else{
        return;
    }
    
    [self.dataSource removeAllObjects];
    for (NSDictionary * dict in tempArr) {
        BYControlModel * model = [[BYControlModel alloc] initWithDictionary:dict error:nil];
        
        [self.dataSource addObject:model];
        BYLog(@"*&***************self.dataSource.count == %zd",self.dataSource.count);
    }
    
    if (self.isQueryType == YES && self.FirstLoad == YES) {
        //        [BYProgressHUD showWithStatus:[NSString stringWithFormat:@"共查询到%zd条结果",self.dataSource.count]];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{

                self.noticeLabel.textColor = [UIColor colorWithHex:@"#323232"];
                self.noticeLabel.backgroundColor = [UIColor whiteColor];
                self.noticeLabel.frame = CGRectMake((SCREEN_WIDTH - 200) / 2, SCREEN_HEIGHT - SafeAreaBottomHeight - 100, 200, 40);
                NSMutableAttributedString *hogan1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共查询到 %lu 条结果",(unsigned long)self.dataSource.count]];

                [hogan1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(4, hogan1.length - 3 - 4)];
                [hogan1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHex:@"#3AAAF4"] range:NSMakeRange(4, hogan1.length - 3 - 4)];
                self.noticeLabel.attributedText = hogan1;

                self.noticeView.hidden = NO;
            }];
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
        });
    }
    
    [self.totalDatasource removeAllObjects];
    [self.totalDatasource addObjectsFromArray:self.dataSource];
    [self.totalDatasource addObjectsFromArray:self.fenceDatasource];
    
    if (self.FirstLoad == YES) {//第一次请求数据则添加标注并且不是搜索请求
        self.selectIndex = 0;//将第一次请求设置选中下标为0
        [self addAnnotationsWith:self.dataSource];
        self.FirstLoad = NO;//将第一次请求改为NO
        //添加左右两边切换车辆按钮
        dispatch_async(dispatch_get_main_queue(), ^{
            self.leftCarButton.hidden = self.dataSource.count > 1 ? NO : YES;
            self.rightCarButton.hidden = self.dataSource.count > 1 ? NO : YES;
        });
    }else{
        for (BYControlModel * model in self.dataSource) {
            
            NSInteger index = [self.dataSource indexOfObject:model];
            BYLog(@"*&***************self.dataSource.count == %zd",self.dataSource.count);
            
            if (self.annotationViews.count < tempArr.count) {
                BYLog(@"*&***************return%zd",self.FirstLoad);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView removeAnnotations:self.carAnnotations];
                    [self addAnnotationsWith:self.dataSource];
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                BYAnnotationView * annoView = self.annotationViews[index];
                annoView.isControlCar = YES;
                annoView.alarmOrOff = model.iconId;//将状态赋值过去
                
                NSString *carNumStr;
                if (model.carId > 0) {
                    if (model.carNum.length > 0) {
                        carNumStr = model.carNum;
                        carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
                    }else{
                        if (model.carVin.length > 6) {
                            NSRange range = NSMakeRange(model.carVin.length - 6, 6);
                            carNumStr = [NSString stringWithFormat:@"...%@",[model.carVin substringWithRange:range]];
                        }else{
                            carNumStr = model.carVin;
                        }
                    }
                }else{
                    carNumStr = model.sn;
                }
                
                NSString *ownerNameStr = [NSString StringJudgeIsValid:model.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
                ownerNameStr = ownerNameStr.length > 4 ? [NSString stringWithFormat:@"%@...",[ownerNameStr substringToIndex:4]] : ownerNameStr;
                annoView.carNum = [NSString stringWithFormat:@"%@(%@) %@",carNumStr,model.wifi ? @"无线" : @"有线",ownerNameStr];
                annoView.annotation.coordinate = CLLocationCoordinate2DMake(model.lat, model.lon);
                
                for (UIView * view in annoView.paopaoView.subviews) {
                    if ([view isKindOfClass:[BYControlPopView class]]) {
                        
                        BYControlPopView * pop = (BYControlPopView *)view;
                        model.shareId = _shareId;
                        pop.model = model;
                        annoView.paopaoView.by_height = model.pop_H;
                        pop.frame = CGRectMake(0, 0, BYS_W_H(245), model.pop_H);

                        pop.distance = [self distanceBetweenYouAndMeWithLat:model.lat lng:model.lon];
                    }
                }
            });
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            BMKPointAnnotation *selectAnno = self.annotations[self.selectIndex];
            [self geoDecodeWith:selectAnno.coordinate];
            [self.mapView selectAnnotation:selectAnno animated:YES];
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        BMKPointAnnotation *selectAnno = self.annotations[self.selectIndex];
        [self geoDecodeWith:selectAnno.coordinate];
        [self.mapView selectAnnotation:selectAnno animated:YES];
    });
    BYWeakSelf;
    [self.countButton startWithTime:_controlRefreshDuration zeroBlock:^{//开始倒计时
        [weakSelf loadDeviceData];
    }];
}

-(void)handleFenceDataWithFenceData:(NSArray *)data
{
//    if (self.fenceAnnotations.count != data.count) {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView removeAnnotations:self.fenceAnnotations];
    
    
        [self.totalDatasource removeObjectsInArray:self.fenceDatasource];
        [self.fenceDatasource removeAllObjects];
        [self.annotations removeObjectsInArray:self.fenceAnnotations];
        [self.fenceAnnotations removeAllObjects];
        for (NSDictionary *dic in data) {
            BYControlModel *model = [[BYControlModel alloc] initWithDictionary:dic error:nil];
            [self handleFenceData:model];
        }
        [self.totalDatasource addObjectsFromArray:self.fenceDatasource];
        [self.annotations addObjectsFromArray:self.fenceAnnotations];
        
        //判断是否在可视范围
        CGFloat centerLongitude = self.mapView.region.center.longitude;
        CGFloat centerLatitude = self.mapView.region.center.latitude;
        
        //当前屏幕显示范围的经纬度
        CLLocationDegrees pointssLongitudeDelta = self.mapView.region.span.longitudeDelta;
        CLLocationDegrees pointssLatitudeDelta = self.mapView.region.span.latitudeDelta;
        
        //左上角
        CGFloat leftUpLong = centerLongitude - pointssLongitudeDelta/2.0;
        CGFloat leftUpLati = centerLatitude - pointssLatitudeDelta/2.0;
        
        //右上角
        CGFloat rightUpLong = centerLongitude + pointssLongitudeDelta/2.0;
        CGFloat rightUpLati = centerLatitude - pointssLatitudeDelta/2.0;
        
        //左下角
        CGFloat leftDownLong = centerLongitude - pointssLongitudeDelta/2.0;
        CGFloat leftDownlati = centerLatitude + pointssLatitudeDelta/2.0;
        
        //右下角
        CGFloat rightDownLong = centerLongitude + pointssLongitudeDelta/2.0;
        CGFloat rightDownLati = centerLatitude + pointssLatitudeDelta/2.0;
        
        CLLocationCoordinate2D coords[4] = {0};
        coords[0].latitude = leftUpLati;
        coords[0].longitude = leftUpLong;
        coords[1].latitude = rightUpLati;
        coords[1].longitude = rightUpLong;
        coords[2].latitude = rightDownLati;
        coords[2].longitude = rightDownLong;
        coords[3].latitude = leftDownlati;
        coords[3].longitude = leftDownLong;
        NSInteger highRiskNum = 0;
        for (NSInteger i = 0; i < self.fenceAnnotations.count; i ++) {
            BMKPointAnnotation *annotation = self.fenceAnnotations[i];
            if (BMKPolygonContainsCoordinate(annotation.coordinate, coords, 4)) {
                BYLog(@"在视野内");
                highRiskNum ++;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView addAnnotation:annotation];
//                    [self.mapView selectAnnotation:annotation animated:YES];
                });
            }
        }
        
        [self.searchHighRiskButton setTitle:[NSString stringWithFormat:@"该区域共查到%ld个高危围栏",(long)highRiskNum] forState:UIControlStateNormal];
//        self.searchHighRiskButton.enabled = NO;
        
        self.isFirstLoadFence = NO;
    });
    
    
//    }else{
//        [self.totalDatasource addObjectsFromArray:self.fenceDatasource];
//        [self.annotations addObjectsFromArray:self.fenceAnnotations];
//    }
}

-(void)dealloc{
    
    if (self.mapView != nil) {
        self.mapView.delegate = nil;
        self.mapView = nil;
        
    }
    
    if (_searcher != nil) {
        _searcher.delegate = nil;
        _searcher = nil;
    }
    
//    if (_locService != nil) {
//        _locService.delegate = nil;
//        _locService = nil;
//    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BYRepeatLoginKey object:nil];
}

@end

