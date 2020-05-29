//
//  BYAlarmPositionController.m
//  BYGPS
//
//  Created by miwer on 16/9/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAlarmPositionController.h"
#import "BYDetailTabBarController.h"
#import "EasyNavigation.h"
#import "BYHomeHttpTool.h"
#import "BYRegeoHttpTool.h"
#import "BYQueryZoneHttpTool.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "BYAlarmModel.h"
#import "BYAnnotationView.h"
#import "BYFenceAnnotationView.h"
#import "BYAlarmPopView.h"
#import "BYPushNaviModel.h"
#import "BYAlarmHttpTool.h"
#import "BYAlertView.h"
#import "BYHandleAlarmView.h"
#import "NSString+BYAttributeString.h"

#import "BYBaiduParamaController.h"

#import "BYFenceControl.h"
#import "BYFenceDataBase.h"

static CGFloat const margin = 8;//22.509903, 113.950091

@interface BYAlarmPositionController () <BMKMapViewDelegate,BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKLocationAuthDelegate>

@property(nonatomic,strong) BMKMapView * mapView;//地图
@property(nonatomic,strong) BMKLocationManager * locationManager;
@property(nonatomic,strong) BMKPointAnnotation * annotation;
@property(nonatomic,strong) BYAnnotationView * annotationView;
@property(nonatomic,strong) BYAnnotationView * selectAnnotationView;
@property(nonatomic,strong) BMKGeoCodeSearch * searcher;

@property(nonatomic,strong) BYAlertView * handleAlertView;
@property(nonatomic,assign) NSInteger selectMarkType;
@property(nonatomic,strong) BYAlarmModel * model;
@property(nonatomic,assign) BOOL isHandleSuccess;//是否处理成功,用来判断能否继续处理
@property(nonatomic,strong) BYAlarmPopView * alarmPopView;
@property(nonatomic,strong) UIView * funcItemsBgView;//右上角功能按钮背景View
@property(nonatomic,strong) UIImageView * zoomLevelImageView;

@property (nonatomic,strong) NSString *address;

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *fenceDatasource;
@property (nonatomic,strong) NSMutableArray *totalDatasource;
@property (nonatomic,strong) NSMutableArray *annotations;
@property (nonatomic,strong) NSMutableArray *fenceAnnotations;
@property (nonatomic,strong) NSMutableArray *totalAnnotations;
@property (nonatomic,strong) NSMutableArray *fenceAnnotationViews;
@property(nonatomic,strong) NSMutableArray * annotationViews;

@property (nonatomic,assign) BOOL highRiskIsSelected;//高危按钮是否按下
@property (nonatomic,strong) UIButton * searchHighRiskButton;  //检索高危按钮
@property (nonatomic,strong) UIButton * highRiskItem;

@property (nonatomic,strong) BMKCircle* circle;
@property (nonatomic,strong) BMKPolygon* polygon;

@property (nonatomic,assign) BOOL isFirstLoadFence;

@property(nonatomic ,weak) UIView *noticeView; 
@property(nonatomic,weak) UILabel *noticeLabel;
@property(nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) BOOL isSeparateAlarm;//是否是分离报警
@property (nonatomic,assign) BOOL beenLoadHighRisk;
@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象

@end

@implementation BYAlarmPositionController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.disableSlidingBackGesture = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.disableSlidingBackGesture = NO;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _searcher.delegate = self;
    _locationManager.delegate = self;
    _mapView.compassPosition = CGPointMake(8, BYNavBarMaxH + 8);//设置指南针位置
     [self loadData];
}

-(void)updateBadgeToServer{
    //当是推送跳转进来时,先将未读数量提交给后台
    [BYHomeHttpTool GETUnreadCountWith:[UIApplication sharedApplication].applicationIconBadgeNumber success:nil];
}

-(void)loadData{

    BYWeakSelf;
    [BYAlarmHttpTool POSTAlarmPositionWith:self.alarmId success:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data[@"alarm"] != nil) {
                
                self.isSeparateAlarm = YES;
                
                BYAlarmModel *model1 = [[BYAlarmModel alloc] initWithDictionary:data[@"alarm"] error:nil];
                model1.distance = data[@"distance"];
                weakSelf.model = model1;
                [self.dataSource insertObject:model1 atIndex:0];
                
                BYAlarmModel *model2 = [[BYAlarmModel alloc] initWithDictionary:data[@"separation"] error:nil];
                model2.distance = data[@"distance"];
                [self.dataSource addObject:model2];
            }else{
                self.isSeparateAlarm = NO;
                BYAlarmModel * model = [[BYAlarmModel alloc] initWithDictionary:data error:nil];
                weakSelf.model = model;
                [self.dataSource addObject:model];
                
            }
            
            [self.totalDatasource addObjectsFromArray:self.dataSource];
            [weakSelf addAnnotation];//添加标注
            
            if (self.dataSource.count > 1) {
                [self creatAlarmPolyLineWay];
            }
            _isFirstLoadFence = YES;
            if (self.highRiskItem.selected && [BYSaveTool boolForKey:BYMonitorInfo]) {
                [self loadFenceAnnotationsData];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.navigationView setTitle:self.model.carNum.length ?[BYSaveTool boolForKey:BYCarNumberInfo] ? self.model.carNum : [NSString stringWithFormat:@"%@***",[self.model.carNum.length>1?self.model.carNum:@"  " substringToIndex:2]] : self.model.sn];
            });
        });
       
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; //不用时，置nil,释放内存
    _searcher.delegate = nil;
    _locationManager.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

   
    
    [self initMapView];//初始化mapView
    [self initLocationService];//初始化定位服务
    
//    if (self.isRemoteNotification) {//如果是推送点击过来,将桌面角标提交到后台
//        [self updateBadgeToServer];
//    }
    
    //  添加观察者，监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //  添加观察者，监听键盘收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)addAnnotation{
    
    for (BYAlarmModel *model in self.dataSource) {
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(model.lat, model.lon);
        [self.annotations addObject:annotation];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addAnnotations:self.annotations];
        [self.mapView showAnnotations:self.annotations animated:YES];
        BMKPointAnnotation *annotation = self.annotations[0];
        [self.mapView selectAnnotation:annotation animated:YES];
    });
}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]){
        
        NSInteger index = [self.annotations indexOfObject:annotation];
        BYAlarmModel * model = self.totalDatasource[index];
        if (model.type) {
            BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
            newAnnotationView.animatesDrop = _isFirstLoadFence;
            
            newAnnotationView.annotation = annotation;
            newAnnotationView.image = [UIImage imageNamed:@"icon_risk"];
            return newAnnotationView;
        }else{
            BYAnnotationView *annotationView = [[BYAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation"];
            
            annotationView.isControlCar = YES;
            annotationView.alarmOrOff = 5;//将状态赋值过去
            
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

            annotationView.carNum =[NSString stringWithFormat:@"%@(%@)",carNumStr,model.wifi ? @"无线" : @"有线"];
            //定制popView
            BYAlarmPopView *alarmPopView = [BYAlarmPopView by_viewFromXib];
            alarmPopView.model = model;
            
            BYWeakSelf;
            [alarmPopView setPresentcBlock:^{
                
                if (model.expired) {
                    return BYShowError(@"设备已过期，请续费");
                }
                
                BYDetailTabBarController * detailTabBarVC = [[BYDetailTabBarController alloc] init];
                BYPushNaviModel * pushModel = [[BYPushNaviModel alloc] init];
                pushModel.deviceId = [model.deviceId integerValue];
                pushModel.carNum = model.carNum;
                pushModel.carVin = model.carVin;
                pushModel.sn = model.sn;
                pushModel.wifi = model.wifi;
                pushModel.model = model.model;
                pushModel.carId =  model.carId;
                pushModel.batteryNotifier = model.batteryNotifier;
                
                detailTabBarVC.model = pushModel;
                detailTabBarVC.selectedIndex = 1;
                [weakSelf.navigationController pushViewController:detailTabBarVC animated:YES];
                
            }];
            
            [alarmPopView setAlarmHandelBlock:^{
                
                if (model.processingUserId.length || _isHandleSuccess) {
                    return [BYProgressHUD by_showErrorWithStatus:@"该报警已处理"];
                }
                
                if (model.reviceTime.length) {
                    return [BYProgressHUD by_showErrorWithStatus:@"该报警已恢复"];
                }
                [weakSelf.handleAlertView show];
            }];
#pragma mark 发起现拍
            
            alarmPopView.frame = CGRectMake(0, 0, model.sn.length > 11 ?  BYS_W_H(280) : BYS_W_H(220), model.pop_H);
            BMKActionPaopaoView * paopaoView=[[BMKActionPaopaoView alloc] initWithCustomView:alarmPopView];
            
            annotationView.paopaoView = paopaoView;
            //计算偏移的宽度
            CGSize carNumSize = [[NSString stringWithFormat:@"%@(%@)",carNumStr,model.wifi ? @"无线" : @"有线"] sizeWithAttributes: @{NSFontAttributeName: BYS_T_F(12)}];
            CGFloat offset_W = (carNumSize.width + 45) / 2 - 12;
            annotationView.centerOffset = CGPointMake(offset_W, - 3);
            annotationView.calloutOffset = CGPointMake(- offset_W, - 5);
            
            [self.annotationViews addObject:annotationView];
            
            return annotationView;
        }
    }
    return nil;
}

-(void)initMapView{
    
    //init mapView
    self.mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.mapType = BMKMapTypeStandard;
    self.mapView.showMapScaleBar = YES;
    self.mapView.mapScaleBarPosition = CGPointMake(10, _mapView.frame.size.height - 40);
    [self.view addSubview:self.mapView];
    
    //测试
    [_mapView setZoomLevel:15];
    
#pragma mark 添加右上角全景按钮
    [_mapView addSubview:self.funcItemsBgView];
    
    //添加放大缩小按钮
    [self.mapView addSubview:self.zoomLevelImageView];
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeHeading;//定位跟随模式
    _mapView.showsUserLocation = YES;
    _mapView.isSelectedAnnotationViewFront = YES;//设定是否总让选中的annotaion置于最前面
    [self setUserImage];
    
    [_mapView isSelectedAnnotationViewFront];
    [self.mapView addSubview:self.searchHighRiskButton];
    self.searchHighRiskButton.hidden = YES;
//      [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.model.lat, self.model.lon) animated:YES];
    
}

-(void)zoomAlarmInLevel{//放大
    BYLog(@"%f",self.mapView.zoomLevel);
    [self.mapView zoomIn];
}
-(void)zoomAlarmOutLevel{//缩小
    BYLog(@"%f",self.mapView.zoomLevel);
    [self.mapView zoomOut];
}

#pragma mark -设置定位圆点属性
-(void)setUserImage{
    //用户位置类
    BMKLocationViewDisplayParam* displayParam = [[BMKLocationViewDisplayParam alloc] init];
    displayParam.isRotateAngleValid = true;// 跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;// 精度圈是否显示
    displayParam.locationViewImage = [UIImage imageNamed:@"icon-arrow"];
    displayParam.locationViewOffsetX = 0;//定位图标偏移量(经度)
    displayParam.locationViewOffsetY = 0;// 定位图标偏移量(纬度)
    [_mapView updateLocationViewWithParam:displayParam]; //调用此方法后自定义定位图层生效
}

-(void)geoDecodeWith:(double)lat lon:(double)lon{
    
    if ([BYSaveTool boolForKey:BYNowCheckCreatKey]) {
        if (![BYSaveTool isContainsKey:@"BYAlarmPositionController"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [BYGuideImageView showGuideViewWith:@"BYAlarmPositionController" touchOriginYScale:0.7];
            });
        }//加载完数据后加载蒙版
    }
    
    BYAnnotationView *annoView =(BYAnnotationView *)self.selectAnnotationView;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BYRegeoHttpTool POSTRegeoAddressWithLat:lat lng:lon success:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                for (UIView * view in annoView.paopaoView.subviews) {
                    if ([view isKindOfClass:[BYAlarmPopView class]]) {
                        NSInteger index = [self.annotations indexOfObject:annoView.annotation];
                        if (index >= self.dataSource.count) {
                            return;
                        }
                        BYAlarmModel * model = self.dataSource[index];
                        BYAlarmPopView * pop = (BYAlarmPopView *)view;
                        //                    pop.model = model;
                        if ([model.model isEqualToString:@"013C"]) {
                            pop.address = @"无法获取当前位置";
                        }else{
                            pop.address = [data[@"address"] isEqualToString:@""] ? @"无法获取当前位置" : data[@"address"];
                        }
                        pop.model = model;
                        
                        annoView.paopaoView.by_height = model.pop_H;
                        self.selectAnnotationView.paopaoView.by_height = model.pop_H;
                        pop.frame = CGRectMake(0, 0, BYS_W_H(245), model.pop_H);
                        [self.mapView mapForceRefresh];
                        
                    }
                }
            });

        } failure:^(NSError *error) {
            for (UIView * view in self.annotationView.paopaoView.subviews) {
                if ([view isKindOfClass:[BYAlarmPopView class]]) {
                    BYAlarmPopView * pop = (BYAlarmPopView *)view;
                    pop.address = @"无法获取当前位置";
                }
            }
        }];
    });
}

#pragma mark 接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        
    }else {
        BYLog(@"抱歉,未找到结果");
    }
}

-(void)initLocationService{
    
    //初始化BMKLocationService
    
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
}
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//
//    [_mapView updateLocationData:userLocation];
//}

-(BYAlertView *)handleAlertView{//处理弹窗
    if (_handleAlertView == nil) {
        _handleAlertView = [BYAlertView viewFromNibWithTitle:@"报警处理" message:nil];
        
        _handleAlertView.alertHeightContraint.constant = BYS_W_H(80 + 100 + 45) + 108;
        _handleAlertView.alertWidthContraint.constant = BYS_W_H(230);
        
        BYHandleAlarmView * alarmView = [BYHandleAlarmView by_viewFromXib];
        alarmView.frame = _handleAlertView.contentView.bounds;
        
        self.selectMarkType = 0;//设置初始选中的类型
        BYWeakSelf;
        [alarmView setItemBlock:^(NSInteger tag) {//实现contentViewBlock
            weakSelf.selectMarkType = tag;
            
        }];
        
        [_handleAlertView.contentView addSubview:alarmView];
        
        __weak typeof(alarmView) weakAlarmView = alarmView;
        [_handleAlertView setSureBlock:^{
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"deviceIds"] = weakSelf.model.deviceId;
            params[@"alarmIds"] = weakSelf.model.alarmId;

            params[@"alarmRemark"] = [weakAlarmView.textView.text isEqualToString:@"请输入处理备注..."] ? @"无备注" : weakAlarmView.textView.text;
            params[@"processingResult"] = @(weakSelf.selectMarkType + 1);
            
            [BYAlarmHttpTool POSTHandleAlarmWithParams:params success:^{
                _isHandleSuccess = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //如果将报警处理了就马上改变按钮的状态
                    weakSelf.alarmPopView.handleType = [NSString stringWithFormat:@"%zd",weakSelf.selectMarkType + 1];
                });

                if (weakSelf.handleAlarmRefreshBlock) {
                    weakSelf.handleAlarmRefreshBlock();
                }
            }];
        }];
        
        [_handleAlertView setCancelBlock:^{
            _handleAlertView = nil;
        }];
    }
    return _handleAlertView;
}

- (void)keyBoardDidShow:(NSNotification*)notifiction {
    
    if (self.handleAlertView && self.handleAlertView.alert.by_centerY == BYSCREEN_H / 2) {
        
        // 取得键盘的动画时间,这样可以在视图上移的时候更连贯
        double duration = [[notifiction.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        CGRect frame = self.handleAlertView.alert.frame;
        frame.origin.y -= 120;
        [UIView animateWithDuration:duration animations:^{
            
            self.handleAlertView.alert.frame = frame;
        }];
    }
}

- (void)keyBoardDidHide:(NSNotification*)notification {
    if (self.handleAlertView) {
        
        CGRect frame = self.handleAlertView.alert.frame;
        frame.origin.y += 120;
        [UIView animateWithDuration:0.1 animations:^{
            
            self.handleAlertView.alert.frame = frame;
        }];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if (_mapView != nil) {
        _mapView = nil;
    }
    
    if (_searcher != nil) {
        _searcher = nil;
    }
    
//    if (_locService != nil) {
//        _locService = nil;
//    }
}

-(UIView *)funcItemsBgView{
    
    if (_funcItemsBgView == nil) {
        
        _funcItemsBgView = [[UIView alloc] init];
        _funcItemsBgView.by_x = BYSCREEN_W - margin - 33;
        _funcItemsBgView.by_y = BYNavBarMaxH + margin + STATUSBAR_HEIGHT;
        _funcItemsBgView.by_width = 33;
        _funcItemsBgView.by_height = 33 * 2 + margin;
        _funcItemsBgView.backgroundColor = [UIColor clearColor];

#pragma mark 添加全景按钮
        UIButton * gotoPanoramaViewItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [gotoPanoramaViewItem setImage:[UIImage imageNamed:@"control_icon_panorama"] forState:UIControlStateNormal];
        gotoPanoramaViewItem.frame = CGRectMake(0, 0, 33, 33);
        [gotoPanoramaViewItem addTarget:self action:@selector(goToBaiduPanoramaView) forControlEvents:UIControlEventTouchUpInside];
        [_funcItemsBgView addSubview:gotoPanoramaViewItem];
        
#pragma mark 添加高危按钮
        self.highRiskItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.highRiskItem setImage:[UIImage imageNamed:@"control_icon_high_risk_normal"] forState:UIControlStateNormal];
        [self.highRiskItem setImage:[UIImage imageNamed:@"control_icon_high_risk_selected"] forState:UIControlStateSelected];
        self.highRiskItem.frame = CGRectMake(0, _funcItemsBgView.by_height - 33, 33, 33);
        [self.highRiskItem addTarget:self action:@selector(openOrCloseHishRisk:) forControlEvents:UIControlEventTouchUpInside];
        if ([BYSaveTool boolForKey:BYMonitorInfo]) {
            [_funcItemsBgView addSubview:self.highRiskItem];
        }
        
    }
    return _funcItemsBgView;
}
#pragma mark 前往实景地图
-(void)goToBaiduPanoramaView{
    
    NSInteger index = [self.annotationViews indexOfObject:self.selectAnnotationView];
    for (UIView * view in self.selectAnnotationView.paopaoView.subviews) {
        if ([view isKindOfClass:[BYAlarmPopView class]]) {
            BYAlarmModel * model = self.dataSource[index];
            BYAlarmPopView * pop = (BYAlarmPopView *)view;
            BYBaiduParamaController *panoramaVC = [[BYBaiduParamaController alloc] init];
            panoramaVC.lat = model.lat;
            panoramaVC.lon = model.lon;
            panoramaVC.address = pop.address;
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
                carNumStr = @"未装车";
            }
            
            NSString *ownerNameStr = [NSString StringJudgeIsValid:model.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
            panoramaVC.titleStr = [NSString stringWithFormat:@"%@ %@",carNumStr,ownerNameStr];
            [self.navigationController pushViewController:panoramaVC animated:YES];
        }
        
    }
    
}

#pragma mark 打开高危
-(void)openOrCloseHishRisk:(UIButton *)button{
    button.selected = !button.selected;
    self.highRiskIsSelected = button.selected;
    //如果数据库中找到了该该用户,那么更新状态
    if ([[BYFenceDataBase shareInstance] queryMenWithUserName:[BYSaveTool valueForKey:BYusername]].count) {
        [[BYFenceDataBase shareInstance] updateUserWithAlarmIsMonitor:button.selected user:[BYSaveTool valueForKey:BYusername]];
    }else{
        [[BYFenceDataBase shareInstance] insertFenceUser:[BYSaveTool valueForKey:BYusername] controlIsMonitor:NO trackIsMonitor:NO alarmIsMonitor:button.selected];
    }
    
    if (self.highRiskIsSelected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.noticeLabel.text = @"高危点已开启，请放大地图比例尺至5公里内查看！";
                self.noticeView.hidden = NO;
            }];
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
        });
        
        //        _isFirstLoadFence = YES;
        if (self.mapView.zoomLevel >= 12) {
            self.searchHighRiskButton.hidden = NO;
        }else{
            self.searchHighRiskButton.hidden = YES;
        }
//        [self loadFenceAnnotationsData];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
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
        [self.totalDatasource addObjectsFromArray:self.dataSource];
        [self.mapView addAnnotations:self.annotations];
    }
    
    if (!self.highRiskIsSelected) {
        //设置地图使显示区域显示所有annotations
        [self.mapView showAnnotations:self.annotations animated:YES];
    }
}

#pragma mark 高危按钮事件
-(void)highRiskView:(UIButton *)button
{
    if (!self.beenLoadHighRisk) {
        self.beenLoadHighRisk = YES;
        [self loadFenceAnnotationsData];
    }
//    button.selected = !button.selected;
//    self.highRiskIsSelected = button.selected;
//    //如果数据库中找到了该该用户,那么更新状态
//    if ([[BYFenceDataBase shareInstance] queryMenWithUserName:[BYSaveTool valueForKey:BYusername]].count) {
//        [[BYFenceDataBase shareInstance] updateUserWithAlarmIsMonitor:button.selected user:[BYSaveTool valueForKey:BYusername]];
//    }else{
//        [[BYFenceDataBase shareInstance] insertFenceUser:[BYSaveTool valueForKey:BYusername] controlIsMonitor:NO trackIsMonitor:NO alarmIsMonitor:button.selected];
//    }
//
//    if (self.highRiskIsSelected) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.5 animations:^{
//                self.noticeLabel.text = @"高危区域点已开启";
//                self.noticeView.hidden = NO;
//            }];
//            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
//        });
//
////        _isFirstLoadFence = YES;
//        [self loadFenceAnnotationsData];
//    }else{
//
//        if (self.polygon) {
//            [self.mapView removeOverlay:self.polygon];
//        }
//        if (self.circle) {
//            [self.mapView removeOverlay:self.circle];
//        }
//        [self.mapView removeAnnotations:self.fenceAnnotations];
//        [self.totalDatasource removeAllObjects];
//        [self.annotations removeObjectsInArray:self.fenceAnnotations];
//        [self.fenceAnnotations removeAllObjects];
//        [self.fenceDatasource removeAllObjects];
//        [self.totalDatasource addObjectsFromArray:self.dataSource];
//        [self.mapView addAnnotations:self.annotations];
//    }
//
//    if (!self.highRiskIsSelected) {
//        //设置地图使显示区域显示所有annotations
//        [self.mapView showAnnotations:self.annotations animated:YES];
//    }
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
        noticeLabel.textColor = [UIColor whiteColor];
        noticeLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [noticeLabel.layer setMasksToBounds:YES];
        [noticeLabel.layer setCornerRadius:5.0];
        noticeLabel.numberOfLines = 0;
        noticeLabel.frame = CGRectMake((SCREEN_WIDTH - 250) / 2, SCREEN_HEIGHT - 120, 250, 50);
        self.noticeView.backgroundColor = [UIColor clearColor];
        [self.noticeView addSubview:noticeLabel];
        _noticeLabel = noticeLabel;
    }
    return _noticeLabel;
}

-(void)delayMethod
{
    self.noticeView.hidden = YES;
    [self.timer invalidate];
}


-(void)loadFenceAnnotationsData
{
    [BYQueryZoneHttpTool POSTQueryZoneSuccess:^(id data) {
        
        [self handleFenceDataWithFenceData:data];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)handleFenceDataWithFenceData:(NSArray *)data{
    
    [self.mapView removeAnnotations:self.fenceAnnotations];
    [self.totalDatasource removeObjectsInArray:self.fenceDatasource];
    [self.fenceDatasource removeAllObjects];
    [self.annotations removeObjectsInArray:self.fenceAnnotations];
    [self.fenceAnnotations removeAllObjects];
    
    for (NSDictionary *dic in data) {
        BYAlarmModel *model = [[BYAlarmModel alloc] initWithDictionary:dic error:nil];
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
            });
            
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.mapView addAnnotations:self.annotations];
//        CLLocationCoordinate2D coordinate;
//        if (self.fenceDatasource.count) {
//            BMKPointAnnotation * an = self.annotations[self.dataSource.count];
//            coordinate = an.coordinate;
//            [self.mapView selectAnnotation:an animated:YES];
            _isFirstLoadFence = NO;
            self.searchHighRiskButton.hidden = NO;
            [self.searchHighRiskButton setTitle:[NSString stringWithFormat:@"该区域共查到%ld个高危围栏",(long)highRiskNum] forState:UIControlStateNormal];
//        }
    });
}

#pragma mark 画路径
-(void)creatAlarmPolyLineWay{
    if (self.dataSource.count < 2) {
        return;
    }
    CLLocationCoordinate2D * coords = malloc(sizeof(CLLocationCoordinate2D) * 2);
    BYAlarmModel *startM = self.dataSource[self.dataSource.count - 2];
    BYAlarmModel *endM = self.dataSource[self.dataSource.count - 1];
    
    coords[0].latitude = startM.lat;
    coords[0].longitude = startM.lon;
    
    coords[1].latitude = endM.lat;
    coords[1].longitude = endM.lon;
    
    NSArray *colorIndexs = [NSArray arrayWithObjects:
                            [NSNumber numberWithInt:2],
                            [NSNumber numberWithInt:0],
                            [NSNumber numberWithInt:1],
                            [NSNumber numberWithInt:2], nil];
    
    BMKPolyline *wayLine = [BMKPolyline polylineWithCoordinates:coords count:2 textureIndex:colorIndexs];
    BYWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.mapView addOverlay:wayLine];
    });
    free(coords);//释放数组;
}

#pragma mark 处理围栏数据
-(void)handleFenceData:(BYAlarmModel *)model{
    if (model.type == 1) {//围栏是圆
        NSArray *locationDegreeArr = [model.parameter componentsSeparatedByString:@","];
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.title = model.name;
        annotation.coordinate = CLLocationCoordinate2DMake([locationDegreeArr[1] floatValue], [locationDegreeArr[0] floatValue]);
        [self.fenceAnnotations addObject:annotation];
    }else{//围栏是多边形
        
        if (model.centerLat) {
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
    
    if ([overlay isKindOfClass:[BMKPolyline class]]) {

        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.lineWidth = 1;
        polylineView.strokeColor = [UIColor redColor];
        /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
        polylineView.colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor redColor], [UIColor redColor], nil];
        return polylineView;
    }
    
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    if ([view isKindOfClass:[BYAnnotationView class]]) {
        BYAnnotationView *cusView = (BYAnnotationView *)view;
        
        NSInteger index = [self.annotations indexOfObject:cusView.annotation];
        self.selectAnnotationView = self.annotationViews[index];
        cusView.paopaoView.hidden = NO;
        [self geoDecodeWith:cusView.annotation.coordinate.latitude lon:cusView.annotation.coordinate.longitude];
          [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(cusView.annotation.coordinate.latitude, cusView.annotation.coordinate.longitude) animated:YES];
    }
    if ([view isKindOfClass:[BMKPinAnnotationView class]]) {
        BMKPinAnnotationView *pinView = (BMKPinAnnotationView *)view;
        NSInteger index = [self.annotations indexOfObject:pinView.annotation];
        BYAlarmModel * model = self.totalDatasource[index];
        [self drawFenceRegionWithModel:model];
    }
}

-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    
    if (self.polygon) {
        [self.mapView removeOverlay:self.polygon];
    }
    if (self.circle) {
        [self.mapView removeOverlay:self.circle];
    }   
}

#pragma mark 根据模型添加围栏
-(void)drawFenceRegionWithModel:(BYAlarmModel *)model
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
#pragma mark 地图区域即将改变时会调用此接口
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    self.searchHighRiskButton.hidden = YES;
    
}

#pragma mark  地图区域已经改变，判断围栏区域是否在区域内
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.beenLoadHighRisk = NO;
    if (mapView.zoomLevel >= 12 && self.highRiskItem.selected) {
        self.searchHighRiskButton.hidden = NO;
        [self.searchHighRiskButton setTitle:@"点击显示此区域内高危围栏" forState:UIControlStateNormal];
    }else{
        self.searchHighRiskButton.hidden = YES;
    }
//
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
//        [self.mapView removeAnnotations:self.fenceAnnotations];
//        for (NSInteger i = 0; i < self.fenceAnnotations.count; i ++) {
//            BMKPointAnnotation *annotation = self.fenceAnnotations[i];
//
//            if (BMKPolygonContainsCoordinate(annotation.coordinate, coords, 4)) {
//                BYLog(@"在视野内");
//                [self.mapView addAnnotation:annotation];
//            }
//        }
//    }
//    BYLog(@"地图区域已经改变");
}


#pragma mark lazy

-(BMKPointAnnotation *)annotation{
    if (_annotation == nil) {
        _annotation = [[BMKPointAnnotation alloc] init];
    }
    return _annotation;
}
-(NSMutableArray *)annotations
{
    if (!_annotations) {
        _annotations = [NSMutableArray array];
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
-(NSMutableArray *)totalAnnotations
{
    if (!_totalAnnotations) {
        _totalAnnotations = [NSMutableArray array];
    }
    return _totalAnnotations;
}

-(NSMutableArray *)fenceAnnotationViews
{
    if (!_fenceAnnotationViews) {
        _fenceAnnotationViews = [NSMutableArray array];
    }
    return _fenceAnnotationViews;
}

-(NSMutableArray *)annotationViews{
    if (_annotationViews == nil) {
        _annotationViews = [[NSMutableArray alloc] init];
    }
    return _annotationViews;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
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

-(NSMutableArray *)totalDatasource
{
    if (!_totalDatasource) {
        _totalDatasource = [NSMutableArray array];
    }
    return _totalDatasource;
}

-(UIImageView *)zoomLevelImageView{
    if (_zoomLevelImageView == nil) {
        
        _zoomLevelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-jia"]];
        [_zoomLevelImageView sizeToFit];
        _zoomLevelImageView.userInteractionEnabled = YES;
        
        CGFloat imageW = _zoomLevelImageView.image.size.width;
        CGFloat imageH = _zoomLevelImageView.image.size.height;
        
        _zoomLevelImageView.by_x = BYSCREEN_W - margin - imageW;
        _zoomLevelImageView.by_y = BYSCREEN_H - imageH - 15;
        
        //放大按钮
        UIButton * zoomInButton = [UIButton buttonWithType:UIButtonTypeCustom];
        zoomInButton.frame = CGRectMake(0, 0, imageW, imageH / 2);
        [zoomInButton addTarget:self action:@selector(zoomAlarmInLevel) forControlEvents:UIControlEventTouchUpInside];
        //缩小按钮
        UIButton * zoomOutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        zoomOutButton.frame = CGRectMake(0, imageH / 2, imageW, imageH / 2);
        [zoomOutButton addTarget:self action:@selector(zoomAlarmOutLevel) forControlEvents:UIControlEventTouchUpInside];
        
        [_zoomLevelImageView addSubview:zoomInButton];
        [_zoomLevelImageView addSubview:zoomOutButton];
        
    }
    return _zoomLevelImageView;
}

-(UIButton *)searchHighRiskButton{
    if (!_searchHighRiskButton) {
        _searchHighRiskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchHighRiskButton setTitle:@"点击显示此区域内高危围栏" forState:UIControlStateNormal];
        [_searchHighRiskButton sizeToFit];
        _searchHighRiskButton.by_x = (BYSCREEN_W - 220)/2;
        _searchHighRiskButton.by_y = SCREEN_HEIGHT - 50;
        _searchHighRiskButton.by_width = 220;
        _searchHighRiskButton.by_height = 30;
        
        _searchHighRiskButton.layer.cornerRadius = 15;
        _searchHighRiskButton.layer.masksToBounds = YES;
        _searchHighRiskButton.backgroundColor = WHITE;
        [_searchHighRiskButton setTitleColor:BYGlobalBlueColor forState:UIControlStateNormal];
        _searchHighRiskButton.titleLabel.font = [UIFont systemFontOfSize:13];;
        [_searchHighRiskButton addTarget:self action:@selector(highRiskView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchHighRiskButton;
}

@end
