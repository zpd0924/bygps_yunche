//
//  BYReplayController.m
//  BYGPS
//
//  Created by miwer on 16/7/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYReplayController.h"

#import "EasyNavigation.h"
#import "BYPopView.h"
#import "BYAlertView.h"
#import "BYParamsConfigView.h"
#import "BYReplayHttpParams.h"
#import "BYReplayModel.h"
#import "BYParkEventModel.h"
#import "BYDeviceDetailHttpTool.h"
#import "BYDateFormtterTool.h"
#import "BYReplayAnnotationView.h"
#import "BYSliderView.h"
#import "BYReplayPopView.h"
#import "BYReplayStartPopView.h"
#import "BYParkPopView.h"
#import "BYPushNaviModel.h"
#import "BYParkEventController.h"
#import "BYBaiduParamaController.h"
#import "BYRegeoHttpTool.h"
#import "BYQueryZoneHttpTool.h"
#import "BYControlModel.h"
#import "NSString+BYAttributeString.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>//引入定位功能所有的头文件/
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

static CGFloat const margin = 8;//22.509903, 113.950091

@interface BYReplayController () <BMKMapViewDelegate,BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKLocationAuthDelegate>

@property(nonatomic,strong) BMKMapView * mapView;
@property(nonatomic,strong) BMKGeoCodeSearch * searcher;
@property(nonatomic,strong) BMKLocationManager * locationManager;
@property(nonatomic,strong) BMKPolyline * polyline;
@property(nonatomic,strong) BMKPointAnnotation * annotation;
@property(nonatomic,strong) BYReplayAnnotationView * annotationView;
@property(nonatomic,strong) BYReplayPopView * replayPopView;
@property (nonatomic,strong) BYReplayStartPopView * startPopView;
@property (nonatomic,strong) BYParkPopView * parkPopView;
@property(nonatomic,strong) BMKAnnotationView * selectAnnoView;

@property(nonatomic,strong) BYPopView * popView;
@property(nonatomic,strong) BYAlertView * alertView;
@property(nonatomic,strong) BYSliderView * sliderView;

@property (nonatomic,strong) BMKCircle* circle;//圆形图层
@property (nonatomic,strong) BMKPolygon* polygon;//多边形图层

@property(nonatomic,strong) NSMutableArray * annotations;
@property(nonatomic,strong) NSMutableArray * selectArray;//速度选择数组
@property(nonatomic,assign) NSInteger replayTypeIndex;//轨迹回放时间选择
@property(nonatomic,assign) BOOL isGPSSwitch;//gps开关选择
@property(nonatomic,assign) BOOL is5kmSwitch;//是否大于5km开关选择
@property (nonatomic,assign) BOOL isFlameOut;//是否熄火的开关选择
@property(nonatomic,strong) BYReplayHttpParams * httpParams;//用于请求轨迹的参数
@property(nonatomic,assign) NSInteger currentIndex;//当前播放下标
@property(nonatomic,assign) BOOL isReplayRun;

@property (nonatomic,strong) NSMutableArray * totalDataSource;
@property(nonatomic,strong) NSMutableArray * dataSource;
@property (nonatomic,strong) NSMutableArray * parkPointDataSource;

@property (nonatomic,strong) NSMutableArray *fenceAnnotations;//电子围栏标注
@property (nonatomic,strong) NSMutableArray *fenceDatasource;//电子围栏数据

@property(nonatomic,assign) CGFloat replayInterval;
@property(nonatomic,strong) NSArray * replayDurationArr;//回放速度时间数组

@property(nonatomic,strong) UIView * funcItemsBgView;//右上角功能按钮背景View
@property(nonatomic,strong) UIImageView * zoomLevelImageView;//放大缩小按钮
@property (nonatomic,strong) UIButton * highRiskItem;//高危按钮
@property (nonatomic,strong) UIButton * searchHighRiskButton;  //检索高危按钮

@property (nonatomic,assign) CGFloat alertHeight;
@property (nonatomic,assign) CGFloat alertMidHeight;

@property (nonatomic,assign) BOOL isFirstLoad;
@property (nonatomic,assign) BOOL isLoadPark;

@property (nonatomic,assign) BOOL firstLoadFence;

@property(nonatomic ,weak) UIView *noticeView;
@property(nonatomic,weak) UILabel *noticeLabel;
@property(nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) BOOL beenLoadHighRisk;

@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象

@end

@implementation BYReplayController

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

    [self.navigationView removeAllRightButton];
    [self.navigationView setTitle:@"轨迹回放"];
    
    BYWeakSelf;
    [self.navigationView addRightButtonWithImage:[UIImage imageNamed:@"icon_time"] clickCallBack:^(UIView *view) {
        [weakSelf replaySetup];
    }];
    [self.navigationView addRightButtonWithImage:[UIImage imageNamed:@"icon_speed"] clickCallBack:^(UIView *view) {
        [weakSelf selectSpeed];
    }];
    
    if (self.polygon) {
        [self.mapView removeOverlay:self.polygon];
    }
    if (self.circle) {
        [self.mapView removeOverlay:self.circle];
    }
    
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _locationManager.delegate = self;
    
    _mapView.compassPosition = CGPointMake(8, BYSCREEN_H - BYTabBarH - _mapView.compassSize.width - 15);//设置指南针位置
}

-(void)loadData{
    
    [self.dataSource removeAllObjects];
    [self.parkPointDataSource removeAllObjects];
    [self.totalDataSource removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BYDeviceDetailHttpTool POSTReplayListWith:self.httpParams success:^(NSMutableArray *array) {
            [self.totalDataSource removeAllObjects];
            if (array.count == 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 animations:^{
                        self.noticeLabel.text = @"未查询到轨迹记录";
                        self.noticeView.hidden = NO;
                    }];
                    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
                });
            }
            
            [self.dataSource addObjectsFromArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                BYWeakSelf;
                if (weakSelf.dataSource.count >= 1) {
                    [weakSelf createPolyline];//划线
                    
                    weakSelf.sliderView.slider.enabled = YES;
                    weakSelf.sliderView.playOffButton.enabled = YES;
                    [weakSelf.sliderView.slider setMaximumValue:weakSelf.dataSource.count];
                    weakSelf.sliderView.runDuration = weakSelf.dataSource.count * _replayInterval;
                }else{
                    [self.totalDataSource addObjectsFromArray:self.dataSource];
                    [self.totalDataSource addObjectsFromArray:self.parkPointDataSource];
                    [self.totalDataSource addObjectsFromArray:self.fenceDatasource];
                    if (weakSelf.polyline) {//移除原有的绘图，避免在原来轨迹上重画
                        [_mapView removeOverlay:self.polyline];
                        weakSelf.polyline = nil;
                    }
                    if (weakSelf.annotations.count > 0) {
                        [_mapView removeAnnotations:weakSelf.annotations];
                        [weakSelf.annotations removeAllObjects];
                    }
                    for (BYParkEventModel * parkModel in weakSelf.parkPointDataSource) {
                        BMKPointAnnotation * parkAnno = [[BMKPointAnnotation alloc] init];
                        parkAnno.coordinate = CLLocationCoordinate2DMake(parkModel.lat, parkModel.lng);
                        
                        [weakSelf.annotations addObject:parkAnno];
                    }
                    [_mapView addAnnotations:weakSelf.annotations];//将起点,终点,和移动车辆标注添加到地图上
                }
            });
        } failure:^{
            
        }];
    });
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BYDeviceDetailHttpTool POSTListParkingEventWith:self.httpParams success:^(NSMutableArray *array) {

            [self.totalDataSource removeAllObjects];
            [self.parkPointDataSource addObjectsFromArray:array];
            dispatch_async(dispatch_get_main_queue(), ^{
                BYWeakSelf;
                if (weakSelf.dataSource.count >= 1) {
                    [weakSelf createPolyline];//划线
                    weakSelf.sliderView.slider.enabled = YES;
                    weakSelf.sliderView.playOffButton.enabled = YES;
                    [weakSelf.sliderView.slider setMaximumValue:weakSelf.dataSource.count];
                    weakSelf.sliderView.runDuration = weakSelf.dataSource.count * _replayInterval;
                }else{
                    [self.totalDataSource addObjectsFromArray:self.dataSource];
                    [self.totalDataSource addObjectsFromArray:self.parkPointDataSource];
                    [self.totalDataSource addObjectsFromArray:self.fenceDatasource];
                    if (weakSelf.polyline) {//移除原有的绘图，避免在原来轨迹上重画
                        [_mapView removeOverlay:self.polyline];
                        weakSelf.polyline = nil;
                    }
                    if (weakSelf.annotations.count > 0) {
                        [_mapView removeAnnotations:weakSelf.annotations];
                        [weakSelf.annotations removeAllObjects];
                    }
                    for (BYParkEventModel * parkModel in weakSelf.parkPointDataSource) {
                        BMKPointAnnotation * parkAnno = [[BMKPointAnnotation alloc] init];
                        parkAnno.coordinate = CLLocationCoordinate2DMake(parkModel.lat, parkModel.lng);
                        
                        [weakSelf.annotations addObject:parkAnno];
                    }
                    [_mapView addAnnotations:weakSelf.annotations];//将起点,终点,和移动车辆标注添加到地图上
                }
            });
            
        } failure:^{
        }];
    });
}

-(void)createPolyline{
    
    [BYProgressHUD show];
    
    if (self.polyline) {//移除原有的绘图，避免在原来轨迹上重画
        [_mapView removeOverlay:self.polyline];
        self.polyline = nil;
    }
    
    if (self.annotations.count > 0) {
        [_mapView removeAnnotations:self.annotations];
        [self.annotations removeAllObjects];
    }
    
    _currentIndex = 0;//将播放的下标置为0
    [self.sliderView.slider setValue:_currentIndex animated:YES];//滑块值置为0

    CLLocationCoordinate2D * coords = malloc(sizeof(CLLocationCoordinate2D) * self.dataSource.count);
    
    for (BYReplayModel * model in self.dataSource) {
        NSInteger index = [self.dataSource indexOfObject:model];
        
        if (index == 0) {
            self.annotation.coordinate = CLLocationCoordinate2DMake(model.lat, model.lng);
            BMKPointAnnotation * startAnno = [[BMKPointAnnotation alloc] init];
            startAnno.coordinate = CLLocationCoordinate2DMake(model.lat, model.lng);
            
            [self.annotations addObject:startAnno];
            [self.annotations addObject:self.annotation];
            [self.totalDataSource addObject:model];
        }
        
        if (index == self.dataSource.count - 1) {
            BMKPointAnnotation * endAnno = [[BMKPointAnnotation alloc] init];
            endAnno.coordinate = CLLocationCoordinate2DMake(model.lat, model.lng);
            [self.annotations addObject:endAnno];
            [self.totalDataSource addObject:model];
        }
        
        coords[index].latitude = model.lat;
        coords[index].longitude = model.lng;
        [self.totalDataSource addObject:model];
    }
    [self.totalDataSource addObjectsFromArray:self.parkPointDataSource];
    [self.totalDataSource addObjectsFromArray:self.fenceDatasource];
    for (BYParkEventModel * parkModel in self.parkPointDataSource) {
        BMKPointAnnotation * parkAnno = [[BMKPointAnnotation alloc] init];
        parkAnno.coordinate = CLLocationCoordinate2DMake(parkModel.lat, parkModel.lng);
        
        [self.annotations addObject:parkAnno];
    }
    
    [self.annotations addObjectsFromArray:self.fenceAnnotations];
    
    [_mapView addAnnotations:self.annotations];//将起点,终点,和移动车辆标注添加到地图上
    [_mapView selectAnnotation:self.annotation animated:YES];
    
    if (self.polyline == nil) {//轨迹为空时添加
        
        self.polyline = [BMKPolyline polylineWithCoordinates:coords count:self.dataSource.count];
    }
    
    [_mapView addOverlay:self.polyline];
    
    [self mapViewFitPolyline:self.polyline];//让轨迹居中显示;
    
    free(coords);//释放数组;
    [BYProgressHUD dismiss];
}

- (void)replayRun{
    _isLoadPark = YES;
    _currentIndex ++;

    if (!_isReplayRun || _currentIndex >= self.dataSource.count) {
        
        self.sliderView.playOffButton.selected = NO;
        if (_currentIndex >= self.dataSource.count) {
            [self.sliderView.slider setValue:_currentIndex animated:YES];
            _currentIndex --;
            NSString *indexStr = [NSString stringWithFormat:@"共播放了%zd个定位点",self.dataSource.count];
            BYShowSuccess(indexStr);
        }
        [_mapView setCenterCoordinate:self.annotation.coordinate animated:YES];
        return;
    }
    

    [_mapView setCenterCoordinate:self.annotation.coordinate animated:YES];
    
    
    [self.sliderView.slider setValue:_currentIndex animated:YES];
    
    BYReplayModel * model = self.dataSource[_currentIndex];
    
    model.carNum = self.myModel.carNum;
    model.carVin = self.myModel.carVin;
    model.carId = self.myModel.carId;
    model.ownerName = self.myModel.ownerName;
    model.sn = self.myModel.sn;
    self.replayPopView.model = model;
    self.replayPopView.address = @"点击查看";
    _selectAnnoView.paopaoView.by_height = model.pop_H;
    self.replayPopView.by_height = model.pop_H;
    self.annotationView.imageView.transform = CGAffineTransformMakeRotation(model.direction / 180 * M_PI + M_PI);//改变标注角度

    BYWeakSelf;
    [UIView animateWithDuration:_replayInterval animations:^{
    
        BYReplayModel * secModel = weakSelf.dataSource[_currentIndex];
        weakSelf.annotation.coordinate = CLLocationCoordinate2DMake(secModel.lat, secModel.lng);
        
    } completion:^(BOOL finished) {
        
        weakSelf.sliderView.runDuration = (weakSelf.dataSource.count - _currentIndex) * _replayInterval;

        [weakSelf replayRun];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    [_mapView viewWillDisappear];
    
    _mapView.delegate = nil; // 不用时，置nil,释放内存
    _locationManager.delegate = nil;
    _isReplayRun = NO;//当视图即将消失时将轨迹播放暂停,不会卡住主线程
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _alertHeight = BYS_W_H(80 + 160) + 140 + 15;
    _alertMidHeight = 0;
    self.isFirstLoad = YES;
    [self initMapView];//初始化mapView
    [self initBase];//初始化UI
    [self initLocationService];//初始化定位服务
}

-(void)initBase{
    
    self.replayTypeIndex = 0;
    self.isGPSSwitch = NO;
    self.selectArray = [NSMutableArray arrayWithObjects:@(NO),@(NO),@(YES),@(NO),@(NO), nil];
    self.replayDurationArr = @[@1.2,@0.70,@0.30,@0.10,@0.03];
    _replayInterval = [self.replayDurationArr[2] floatValue];
    
    self.disableSlidingBackGesture = NO;
    
    [self.alertView show];//在视图加载完成时弹出参数配置弹窗
    
    if (![BYSaveTool isContainsKey:BYSelfClassName]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYGuideImageView showGuideViewWith:BYSelfClassName touchOriginYScale:0.25];
        });
    }
    
    //添加右上角功能按钮
    [_mapView addSubview:self.funcItemsBgView];
    if (![BYSaveTool boolForKey:BYMonitorInfo]) {
        self.highRiskItem.hidden = YES;
    }else{
        self.highRiskItem.hidden = NO;
    }
    
    [self.mapView addSubview:self.searchHighRiskButton];
    self.searchHighRiskButton.hidden = YES;
}

-(void)initMapView{
    
    //init mapView
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    _mapView.mapType = BMKMapTypeStandard;
    self.view = _mapView;
    
    //测试
    [_mapView setZoomLevel:5];
    
    //添加放大缩小按钮
    [self.mapView addSubview:self.zoomLevelImageView];
    
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = BMKUserTrackingModeHeading;//定位跟随模式
    [self setUserImage];
    _mapView.showsUserLocation = YES;
    _mapView.isSelectedAnnotationViewFront = YES;
    _mapView.showMapScaleBar = YES;
    self.mapView.mapScaleBarPosition = CGPointMake(10, _mapView.frame.size.height - SafeAreaBottomHeight - 40);
    [_mapView addSubview:self.sliderView];
}

#pragma mark -设置定位圆点属性
-(void)setUserImage{
    //用户位置类
    BMKLocationViewDisplayParam* displayParam = [[BMKLocationViewDisplayParam alloc] init];
    displayParam.isRotateAngleValid = true;// 跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = false;// 精度圈是否显示
    displayParam.locationViewImage = [UIImage imageNamed:@"icon-arrow"];// 定位图标名称
    displayParam.locationViewOffsetX = 0;//定位图标偏移量(经度)
    displayParam.locationViewOffsetY = 0;// 定位图标偏移量(纬度)
    [_mapView updateLocationViewWithParam:displayParam]; //调用此方法后自定义定位图层生效
    
}

-(void)selectSpeed{
    
    [self.popView showMenuWithAnimation:YES];
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

#pragma mark - <定位代理方法>

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

//#pragma mark - <定位代理方法>
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//
//
//}

-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    NSInteger index = [self.annotations indexOfObject:annotation];
    if (index < ((self.dataSource.count > 0 ? 3 : 0 )+ self.parkPointDataSource.count)) {
        BYReplayAnnotationView * annotationView = nil;
        if (self.dataSource.count >= 1) {
            switch (index) {
                case 0:{
                    annotationView = [[BYReplayAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"start"];
                    annotationView.imageStr = @"icon_star";
                    
                    self.startPopView = [BYReplayStartPopView by_viewFromXib];
                    self.startPopView.by_width = 250;
                    self.startPopView.startModel = self.dataSource[0];
                    self.startPopView.name = @"历史轨迹开始";
                    BMKActionPaopaoView * paopaoView=[[BMKActionPaopaoView alloc] initWithCustomView:self.startPopView];
                    
                    annotationView.calloutOffset = CGPointMake(0, - 5);
                    annotationView.paopaoView = paopaoView;
                    annotationView.canShowCallout = YES;
                    annotationView.hidePaopaoWhenSelectOthers = YES;
                }
                    break;
                case 1:{
                    annotationView = [[BYReplayAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"move"];
                    annotationView.imageStr = @"icon_arr_map";
                    
                    //定制popView
                    self.replayPopView  = [BYReplayPopView by_viewFromXib];
                    self.replayPopView.deviceModel = self.myModel.model;
                    
                    BYReplayModel * model = self.dataSource[_currentIndex];
                    model.carNum = self.myModel.carNum;
                    model.carVin = self.myModel.carVin;
                    model.carId = self.myModel.carId;
                    model.sn = self.myModel.sn;
                    model.ownerName = self.myModel.ownerName;
                    
                    BMKPointAnnotation *mapAnno = [[BMKPointAnnotation alloc] init];
                    mapAnno.coordinate = CLLocationCoordinate2DMake(model.lat, model.lng);
                    
                    self.replayPopView.model = model;
                    BYWeakSelf;
                    [self.replayPopView setGetAddressBlock:^{
                        BYReplayModel * model = weakSelf.dataSource[_currentIndex];
                        [weakSelf geoDecodeWithLat:model.lat lon:model.lng];
                    }];
                    
                    self.replayPopView.frame = CGRectMake(0, 0, BYS_W_H(275), BYS_W_H(150));
                    BMKActionPaopaoView * paopaoView=[[BMKActionPaopaoView alloc] initWithCustomView:self.replayPopView];
                    
                    annotationView.calloutOffset = CGPointMake(0, - 5);
                    
                    annotationView.paopaoView = paopaoView;
                    annotationView.canShowCallout = YES;
                    annotationView.hidePaopaoWhenSelectOthers = YES;
                    self.annotationView = annotationView;
                    self.annotationView.imageView.transform = CGAffineTransformMakeRotation(model.direction / 180 * M_PI + M_PI);//改变标注角度
                }
                    break;
                case 2:{
                    annotationView = [[BYReplayAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"end"];
                    annotationView.imageStr = @"icon_end";
                    
                    self.startPopView = [BYReplayStartPopView by_viewFromXib];
                    self.startPopView.by_width = 250;
                    self.startPopView.startModel = self.dataSource.lastObject;
                    self.startPopView.name = @"历史轨迹结束";
                    BMKActionPaopaoView * paopaoView=[[BMKActionPaopaoView alloc] initWithCustomView:self.startPopView];
                    
                    annotationView.calloutOffset = CGPointMake(0, - 5);
                    annotationView.paopaoView = paopaoView;
                    annotationView.canShowCallout = YES;
                    annotationView.hidePaopaoWhenSelectOthers = YES;
                }
                    break;
                default:{
                    annotationView = [[BYReplayAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"park"];
                    annotationView.imageStr = @"icon_star-4";
                    
                    self.parkPopView = [BYParkPopView by_viewFromXib];
                    BYParkEventModel * model = self.parkPointDataSource[index - 3];
                    self.parkPopView.parkModel = model;
                    self.parkPopView.frame = CGRectMake(0, 0, BYS_W_H(257), model.pop_H);
                    BMKActionPaopaoView * paopaoView=[[BMKActionPaopaoView alloc] initWithCustomView:self.parkPopView];
                    
                    annotationView.calloutOffset = CGPointMake(0, - 5);
                    annotationView.paopaoView = paopaoView;
                    annotationView.canShowCallout = YES;
                    annotationView.hidePaopaoWhenSelectOthers = YES;
                }
                    break;
            }
        }else{
            
            annotationView = [[BYReplayAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"park"];
            annotationView.imageStr = @"icon_star-4";
            
            self.parkPopView = [BYParkPopView by_viewFromXib];
            BYParkEventModel * model = self.parkPointDataSource[index];
            self.parkPopView.parkModel = model;
            self.parkPopView.frame = CGRectMake(0, 0, BYS_W_H(257), model.pop_H);
            BMKActionPaopaoView * paopaoView=[[BMKActionPaopaoView alloc] initWithCustomView:self.parkPopView];
            
            annotationView.calloutOffset = CGPointMake(0, - 5);
            annotationView.paopaoView = paopaoView;
            annotationView.canShowCallout = YES;
            annotationView.hidePaopaoWhenSelectOthers = YES;
        }
        return annotationView;
    }else{
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.animatesDrop = self.firstLoadFence;
        
        newAnnotationView.annotation = annotation;
        newAnnotationView.image = [UIImage imageNamed:@"icon_risk"];
        newAnnotationView.canShowCallout = YES;
        newAnnotationView.hidePaopaoWhenSelectOthers = YES;
        return newAnnotationView;
    }
}

#pragma mark 点击选择标注
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{

    _selectAnnoView = view;
    view.paopaoView.hidden = NO;
    if (![view isKindOfClass:[BMKPinAnnotationView class]]) {
        [self.mapView setCenterCoordinate:view.annotation.coordinate];
    }

    for (UIView * subV in view.paopaoView.subviews) {
        if ([subV isKindOfClass:[BYReplayStartPopView class]]) {
            [self geoDecodeWithLat:view.annotation.coordinate.latitude lon:view.annotation.coordinate.longitude];
        }
    }
    NSInteger index = [self.annotations indexOfObject:view.annotation];
    if (self.highRiskItem.selected) {
        if (index >= (self.dataSource.count > 0 ? 3 : 0 + self.parkPointDataSource.count) && index < self.totalDataSource.count) {
            BYControlModel * model = self.fenceDatasource[index -((self.dataSource.count > 0 ? 3 : 0) + self.parkPointDataSource.count)];
            [self drawFenceRegionWithModel:model];
        }
    }
}

-(void)geoDecodeWithLat:(CGFloat)lat lon:(CGFloat)lon{
    
    BMKAnnotationView * annoView = _selectAnnoView;
    [BYRegeoHttpTool POSTRegeoAddressWithLat:lat lng:lon success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (UIView * view in annoView.paopaoView.subviews) {
                if ([view isKindOfClass:[BYReplayStartPopView class]]) {
                    NSInteger index = [self.annotations indexOfObject:annoView.annotation];
                    BYReplayModel * model;
                    if (index == 2) {
                        model = self.dataSource[self.dataSource.count - 1];
                    }else{
                        model = self.dataSource[index];
                    }
                    
                    BYReplayStartPopView * pop = (BYReplayStartPopView *)view;
                    pop.address = [data[@"address"] isEqualToString:@""] ? @"无法获取当前位置" : data[@"address"];
                    pop.startModel = model;
                    pop.name = index == 0 ? @"历史轨迹开始" : @"历史轨迹结束";
                    annoView.paopaoView.by_height = model.pop_H;
                    
                }else if([view isKindOfClass:[BYReplayPopView class]]){
                    BYReplayModel * model = self.dataSource[_currentIndex];
                    model.carNum = self.myModel.carNum;
                    model.carVin = self.myModel.carVin;
                    model.carId = self.myModel.carId;
                    model.sn = self.myModel.sn;
                    model.ownerName = self.myModel.ownerName;
                    
                    self.replayPopView.model = model;
                    self.replayPopView.address = [data[@"address"] isEqualToString:@""] ? @"无法获取当前位置" : data[@"address"];
                    annoView.paopaoView.by_height = model.pop_H;
                    self.replayPopView.by_height = model.pop_H;
                    
                    [self.mapView mapForceRefresh];
                    
                }
            }
        });
        BYLog(@"%@",data);
    } failure:^(NSError *error) {
        for (UIView * view in annoView.paopaoView.subviews) {
            if ([view isKindOfClass:[BYReplayStartPopView class]]) {
                
                BYReplayStartPopView * pop = (BYReplayStartPopView *)view;
                pop.address = @"无法获取当前位置";
            }
        }
    }];
}

#pragma mark 接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
//    if (error == BMK_SEARCH_NO_ERROR) {
    
        BMKAnnotationView * annoView = _selectAnnoView;
        [BYRegeoHttpTool POSTRegeoAddressWithLat:annoView.annotation.coordinate.latitude lng:annoView.annotation.coordinate.longitude success:^(id data) {
            
            for (UIView * view in annoView.paopaoView.subviews) {
                if ([view isKindOfClass:[BYReplayStartPopView class]]) {
                    NSInteger index = [self.annotations indexOfObject:annoView.annotation];
                    BYReplayModel * model;
                    if (index == 2) {
                        model = self.dataSource[self.dataSource.count - 1];
                    }else{
                        model = self.dataSource[index];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        BYReplayStartPopView * pop = (BYReplayStartPopView *)view;
                        pop.address = [data[@"address"] isEqualToString:@""] ? @"无法获取当前位置" : data[@"address"];
                        pop.startModel = model;
                        pop.name = index == 0 ? @"历史轨迹开始" : @"历史轨迹结束";
                        annoView.paopaoView.by_height = model.pop_H;
                    });
                }else if([view isKindOfClass:[BYReplayPopView class]]){
                    BYReplayModel * model = self.dataSource[_currentIndex];
                    model.carNum = self.myModel.carNum;
                    model.carVin = self.myModel.carVin;
                    model.carId = self.myModel.carId;
                    model.sn = self.myModel.sn;
                    model.ownerName = self.myModel.ownerName;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.replayPopView.model = model;
                        self.replayPopView.address = [data[@"address"] isEqualToString:@""] ? @"无法获取当前位置" : data[@"address"];
                        [self.mapView mapForceRefresh];
                    });
                }
            }
            BYLog(@"%@",data);
        } failure:^(NSError *error) {
            for (UIView * view in annoView.paopaoView.subviews) {
                if ([view isKindOfClass:[BYReplayStartPopView class]]) {
                    
                    BYReplayStartPopView * pop = (BYReplayStartPopView *)view;
                    pop.address = @"无法获取当前位置";
                }
            }
        }];
        
//    }else {
//        BMKAnnotationView * annoView = _selectAnnoView;
//        for (UIView * view in annoView.paopaoView.subviews) {
//            if ([view isKindOfClass:[BYReplayStartPopView class]]) {
//                
//                BYReplayStartPopView * pop = (BYReplayStartPopView *)view;
//                pop.address = @"无法获取当前位置";
//            }
//        }
//        BYLog(@"抱歉，未找到结果");
//    }
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
        [self.mapView addOverlay:self.polygon];
        free(coords);//释放数组;
    }
}


-(BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay{
    
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
        polylineView.fillColor = BYRGBColor(47, 168, 246);
        polylineView.strokeColor = BYRGBColor(47, 168, 246);
        polylineView.lineWidth = 2.0;
        return polylineView;
    }
    return nil;
}

-(void)replaySetup{//开始配置
    
    [self.alertView show];
}

#pragma mark - lazy

-(BYPopView *)popView{
    if (!_popView) {
        
        NSArray *onlineTypeSource = @[@"很慢",@"慢",@"普通",@"快",@"很快"];
        
        UIButton * item = [self.navigationView.rightViewArray lastObject];
        CGRect itemFrame = item.frame;
        
        CGFloat width = 105;
        CGFloat x = CGRectGetMinX(itemFrame) + itemFrame.size.width / 2 - width / 2;
        CGFloat y = 64;
        CGFloat height = onlineTypeSource.count * 35 + 10;
        
        BYWeakSelf;
        _popView = [BYPopView createMenuWithFrame:CGRectMake(x, y, width, height) dataSource:onlineTypeSource selectArray:self.selectArray itemsClickBlock:^(NSInteger tag) {
            
            weakSelf.selectArray[tag] = @(NO);
            _replayInterval = [weakSelf.replayDurationArr[tag] floatValue];
        } backViewTap:^{
            _popView = nil;
            
        }];
    }
    return _popView;
}

-(BYAlertView *)alertView{
    if (_alertView == nil) {
        
        _alertView = [BYAlertView viewFromNibWithTitle:@"参数配置" message:nil];
        _alertView.alertHeightContraint.constant = _alertHeight;
        _alertView.alertWidthContraint.constant = BYS_W_H(250);
        
        BYParamsConfigView * configView = [BYParamsConfigView by_viewFromXib];
        configView.frame = _alertView.contentView.bounds;
        configView.midBgViewContraint_H.constant = _alertMidHeight;
        configView.selectType = self.replayTypeIndex;//将上次选择的类型设置上去
        configView.GPSSwitchView.on = self.isGPSSwitch;
        configView.fiveSwitchView.on = self.is5kmSwitch;
        configView.flameOutSwitchView.on = self.isFlameOut;
        configView.startTime = self.httpParams.startTime;
        configView.endTime = self.httpParams.endTime;
        
        __weak typeof(configView) weakConfigView = configView;
        __weak typeof(_alertView) weakAlertView = _alertView;
        BYWeakSelf;
        [configView setDateItemsBlock:^(NSInteger tag, BOOL isSelect) {
            
            weakSelf.replayTypeIndex = tag;

            if (tag == 4) {
                if (isSelect == YES) {
                    weakConfigView.midBgViewContraint_H.constant = BYS_W_H(80);
                    weakAlertView.alertHeightContraint.constant = BYS_W_H(80 + 80 + 160) + 140 + 15;
                    _alertHeight = BYS_W_H(80 + 80 + 160) + 140 + 15;
                    _alertMidHeight = BYS_W_H(80);
                    
                }else if (isSelect == NO){
                    weakConfigView.midBgViewContraint_H.constant = 0;
                    weakAlertView.alertHeightContraint.constant = BYS_W_H(80 + 160) + 140 + 15;
                    _alertHeight = BYS_W_H(80 + 160) + 140 + 15;
                    _alertMidHeight = 0;
                }
                
                [UIView animateWithDuration:0.3 animations:^{
                    [weakConfigView layoutIfNeeded];
                    [weakAlertView layoutIfNeeded];
                }];
            }
        }];
        
        [_alertView setSureBlock:^{
            _alertView = nil;
            weakSelf.isLoadPark = YES;
            _isReplayRun = NO;//当请求新的轨迹时,将之前播放的轨迹先暂停
            NSString * start = nil;
            NSString * end = nil;
            
            switch (weakSelf.replayTypeIndex) {
                    
                case 0:{//当天
                    weakSelf.httpParams.stopKM = NO;
                    start = [BYDateFormtterTool getResultDateStr:0 formatStr:BYDateFormatMorningType];
                    end = [BYDateFormtterTool getResultDateStr:0 formatStr:BYDateFormatNormalType];
                }
                    break;
                case 1:{//昨天
                    weakSelf.httpParams.stopKM = NO;
                    start = [BYDateFormtterTool getResultDateStr:1 formatStr:BYDateFormatMorningType];
                    end = [BYDateFormtterTool getResultDateStr:1 formatStr:BYDateFormatNightType];
                }
                    break;
                case 2:{//近七天
                    weakSelf.httpParams.stopKM = NO;
                    start = [BYDateFormtterTool getResultDateStr:7 formatStr:BYDateFormatNormalType];
                    end = [BYDateFormtterTool getResultDateStr:0 formatStr:BYDateFormatNormalType];
                }
                    break;
                case 3:{//五公里
                    weakSelf.httpParams.stopKM = YES;
                }
                    break;
                case 4:{//自定义
                    weakSelf.httpParams.stopKM = NO;
                    start = [weakConfigView.startTimeButton.titleLabel.text stringByAppendingString:@":00"];
                    end = [weakConfigView.endTimeButton.titleLabel.text stringByAppendingString:@":00"];
                }
                default:
                    break;
            }
            
            weakSelf.httpParams.deviceid = weakSelf.myModel.deviceId;
            weakSelf.httpParams.sn = weakSelf.myModel.sn;
            weakSelf.httpParams.startTime = start;
            weakSelf.httpParams.endTime = end;
            weakSelf.httpParams.gps = !weakConfigView.GPSSwitchView.isOn;
            weakSelf.httpParams.speed = weakConfigView.fiveSwitchView.isOn;
            weakSelf.httpParams.flameOut = weakConfigView.flameOutSwitchView.isOn;
            weakSelf.isGPSSwitch = weakConfigView.GPSSwitchView.isOn;
            weakSelf.is5kmSwitch = weakConfigView.fiveSwitchView.isOn;
            weakSelf.isFlameOut = weakConfigView.flameOutSwitchView.isOn;
            
            [weakSelf loadData];
        }];
        
        [_alertView setCancelBlock:^{
            _alertView = nil;
            if (weakSelf.isFirstLoad) {
                weakSelf.isLoadPark = NO;
                weakSelf.isFirstLoad = NO;
            }
        }];
        
        [_alertView.contentView addSubview:configView];
    }
    return _alertView;
}

-(BYSliderView *)sliderView{
    
    if (_sliderView == nil) {
        BYWeakSelf;
        _sliderView = [BYSliderView createSliderViewWithPalyOnOff:^(BOOL isSelect) {//暂停与开始
            if (_currentIndex == weakSelf.dataSource.count) {//当轨迹播放完事点击播放按钮将重新播放
                _currentIndex = 0;
            }
            
            _isReplayRun = isSelect;
            if (weakSelf.dataSource.count > 0) {
                [weakSelf replayRun];
            }
            
        } sliderChange:^(CGFloat value) {//滑动滑块
            
            _currentIndex = (NSInteger)value;
            
            if (_currentIndex >= weakSelf.dataSource.count){
                _currentIndex -- ;
                return ;
            }
            
            BYReplayModel * model = weakSelf.dataSource[_currentIndex];
            weakSelf.annotation.coordinate = CLLocationCoordinate2DMake(model.lat, model.lng);
            [_mapView setCenterCoordinate:self.annotation.coordinate animated:YES];
            model.carNum = weakSelf.myModel.carNum;
            model.carVin = weakSelf.myModel.carVin;
            model.carId = weakSelf.myModel.carId;
            model.sn = weakSelf.myModel.sn;
            model.ownerName = weakSelf.myModel.ownerName;
            self.replayPopView.model = model;
            self.replayPopView.address = @"点击查看";
            _selectAnnoView.paopaoView.by_height = model.pop_H;
            self.replayPopView.by_height = model.pop_H;
            self.annotationView.imageView.transform = CGAffineTransformMakeRotation(model.direction / 180 * M_PI + M_PI);//改变标注角度
            
            _sliderView.runDuration = (weakSelf.dataSource.count - _currentIndex) * _replayInterval;//将时间也改变
        }];
        _sliderView.playOffButton.enabled = NO;
        _sliderView.slider.enabled = NO;//默认没有加载到数据时是不能移动和播放的
    }
    return _sliderView;
}

-(UIView *)funcItemsBgView{
    
    if (_funcItemsBgView == nil) {
        
        _funcItemsBgView = [[UIView alloc] init];
        _funcItemsBgView.by_x = BYSCREEN_W - margin - 33;
        _funcItemsBgView.by_y = SafeAreaTopHeight + margin + BYS_W_H(45);
        _funcItemsBgView.by_width = 33;
        _funcItemsBgView.by_height = 33 * 4 + 3 * margin;
        _funcItemsBgView.backgroundColor = [UIColor clearColor];
        
        UIButton * parkEventItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [parkEventItem setImage:[UIImage imageNamed:@"icon_gj_Parking"] forState:UIControlStateNormal];
        parkEventItem.frame = CGRectMake(0, 0, 33, 33);
        [parkEventItem addTarget:self action:@selector(gotoParkEventVC) forControlEvents:UIControlEventTouchUpInside];
        [_funcItemsBgView addSubview:parkEventItem];
        
        UIButton * mapTypeItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [mapTypeItem setImage:[UIImage imageNamed:@"control_icon_map"] forState:UIControlStateNormal];
        [mapTypeItem setImage:[UIImage imageNamed:@"control_icon_satellite"] forState:UIControlStateSelected];
        mapTypeItem.frame = CGRectMake(0, 33 + margin, 33, 33);
        [mapTypeItem addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventTouchUpInside];
        [_funcItemsBgView addSubview:mapTypeItem];
        
        UIButton * gotoPanoramaViewItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [gotoPanoramaViewItem setImage:[UIImage imageNamed:@"control_icon_panorama"] forState:UIControlStateNormal];
        gotoPanoramaViewItem.frame = CGRectMake(0,  33 * 2 + 2 * margin, 33, 33);
        [gotoPanoramaViewItem addTarget:self action:@selector(goToBaiduPanoramaView) forControlEvents:UIControlEventTouchUpInside];
        [_funcItemsBgView addSubview:gotoPanoramaViewItem];
        
        //添加高危按钮
        self.highRiskItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.highRiskItem setImage:[UIImage imageNamed:@"control_icon_high_risk_normal"] forState:UIControlStateNormal];
        [self.highRiskItem setImage:[UIImage imageNamed:@"control_icon_high_risk_selected"] forState:UIControlStateSelected];
        self.highRiskItem.frame = CGRectMake(0, 33 * 3 + 3 * margin, 33, 33);
        [self.highRiskItem addTarget:self action:@selector(openOrCloseHishRisk:) forControlEvents:UIControlEventTouchUpInside];
        [_funcItemsBgView addSubview:self.highRiskItem];
    }
    return _funcItemsBgView;
}

-(void)gotoParkEventVC{
    if (!self.isLoadPark) {
        return BYShowError(@"播放轨迹后，才可以查看停车事件");
    }
    BYParkEventController *parkVC = [[BYParkEventController alloc] init];
    [parkVC setSelectedRowCallBack:^(NSInteger index){
        if (self.dataSource.count >= 1) {
            index = index + 3;
        }else{
            index = index;
        }
        BMKPointAnnotation * an = self.annotations[index];
        
        [self.mapView selectAnnotation:an animated:YES];
        [self.mapView setCenterCoordinate:an.coordinate animated:YES];
        
    }];
    parkVC.model = self.myModel;
    parkVC.beginTime = self.httpParams.startTime;
    parkVC.endTime = self.httpParams.endTime;
    parkVC.parkDatasource = self.parkPointDataSource;
    [self.navigationController pushViewController:parkVC animated:YES];
}

-(void)changeMapType:(UIButton *)button{
    
    button.selected = !button.selected;
    self.mapView.mapType = button.selected ? BMKMapTypeSatellite : BMKMapTypeStandard;
}

#pragma mark 前往实景地图
-(void)goToBaiduPanoramaView{
    BYBaiduParamaController *panoramaVC = [[BYBaiduParamaController alloc] init];
    panoramaVC.lat = self.annotation.coordinate.latitude;
    panoramaVC.lon = self.annotation.coordinate.longitude;
//    panoramaVC.address = self.address;
    
    NSString *carNumStr;
    if (self.myModel.carId > 0) {
        if (self.myModel.carNum.length > 0) {
            carNumStr = self.myModel.carNum;
            carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
        }else{
            if (self.myModel.carVin.length > 6) {
                NSRange range = NSMakeRange(self.myModel.carVin.length - 6, 6);
                carNumStr = [NSString stringWithFormat:@"...%@",[self.myModel.carVin substringWithRange:range]];
            }else{
                carNumStr = self.myModel.carVin;
            }
        }
    }else{
        carNumStr = @"未装车";
    }
    
    //    NSString *carNumStr = [NSString StringJudgeIsValid:self.model.carNum isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
    NSString *ownerNameStr = [NSString StringJudgeIsValid:self.myModel.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
    panoramaVC.titleStr = [NSString stringWithFormat:@"%@ %@",carNumStr,ownerNameStr];
    [self.navigationController pushViewController:panoramaVC animated:YES];
}


#pragma mark 打开高危
-(void)openOrCloseHishRisk:(UIButton *)button{
    button.selected = !button.selected;
    if (button.selected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.noticeLabel.text = @"高危点已开启，请放大地图比例尺至5公里内查看！";
                self.noticeView.hidden = NO;
            }];
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
        });
        self.firstLoadFence = YES;
//        [self loadFenceAnnotationsData];
        
        if (self.mapView.zoomLevel >= 12) {
            self.searchHighRiskButton.hidden = NO;
            [self.searchHighRiskButton setTitle:@"点击显示此区域内高危围栏" forState:UIControlStateNormal];
        }else{
            self.searchHighRiskButton.hidden = YES;
        }
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
        [self.totalDataSource removeAllObjects];
        [self.annotations removeObjectsInArray:self.fenceAnnotations];
        [self.fenceAnnotations removeAllObjects];
        [self.fenceDatasource removeAllObjects];
        [self.totalDataSource addObjectsFromArray:self.dataSource];
    }
}

-(void)highRiskView:(UIButton *)button{

    if (!self.beenLoadHighRisk) {
        self.beenLoadHighRisk = YES;
        [self loadFenceAnnotationsData];
    }
    
//    button.selected = !button.selected;
//    if (button.selected) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.5 animations:^{
//                self.noticeLabel.text = @"高危区域点已开启";
//                self.noticeView.hidden = NO;
//            }];
//            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
//        });
//        self.firstLoadFence = YES;
//        [self loadFenceAnnotationsData];
//    }else{
//        if (self.polygon) {
//            [self.mapView removeOverlay:self.polygon];
//        }
//        if (self.circle) {
//            [self.mapView removeOverlay:self.circle];
//        }
//        [self.mapView removeAnnotations:self.fenceAnnotations];
//        [self.totalDataSource removeAllObjects];
//        [self.annotations removeObjectsInArray:self.fenceAnnotations];
//        [self.fenceAnnotations removeAllObjects];
//        [self.fenceDatasource removeAllObjects];
//        [self.totalDataSource addObjectsFromArray:self.dataSource];
//    }
}
#pragma mark 加载二押点
-(void)loadFenceAnnotationsData{
    [BYQueryZoneHttpTool POSTQueryZoneSuccess:^(NSArray * data) {
        
        [self handleFenceDataWithFenceData:data];
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)handleFenceDataWithFenceData:(NSArray *)data
{
    
//    if (self.fenceAnnotations.count != data.count) {
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView removeAnnotations:self.fenceAnnotations];
        [self.totalDataSource removeObjectsInArray:self.fenceDatasource];
        [self.fenceDatasource removeAllObjects];
        [self.annotations removeObjectsInArray:self.fenceAnnotations];
        [self.fenceAnnotations removeAllObjects];
        for (NSDictionary *dic in data) {
            BYControlModel *model = [[BYControlModel alloc] initWithDictionary:dic error:nil];
            [self handleFenceData:model];
        }
        [self.totalDataSource addObjectsFromArray:self.fenceDatasource];
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
        self.searchHighRiskButton.hidden = NO;
        [self.searchHighRiskButton setTitle:[NSString stringWithFormat:@"该区域共查到%ld个高危围栏",(long)highRiskNum] forState:UIControlStateNormal];
        //    }else{
        //        [self.totalDataSource addObjectsFromArray:self.fenceDatasource];
        //        [self.annotations addObjectsFromArray:self.fenceAnnotations];
        //    }
        self.firstLoadFence = NO;
    });
}
#pragma mark 地图区域即将改变时会调用此接口
- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    
    self.searchHighRiskButton.hidden = YES;
    
}
#pragma mark 地图区域已经改变，判断围栏区域是否在区域内
-(void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.beenLoadHighRisk = NO;
    if (mapView.zoomLevel >= 12 && self.highRiskItem.selected) {
        self.searchHighRiskButton.hidden = NO;
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
////    if (self.highRiskIsSelected) {
//        [self.mapView removeAnnotations:self.fenceAnnotations];
//        for (NSInteger i = 0; i < self.fenceAnnotations.count; i ++) {
//            BMKPointAnnotation *annotation = self.fenceAnnotations[i];
//
//            if (BMKPolygonContainsCoordinate(annotation.coordinate, coords, 4)) {
//                BYLog(@"在视野内");
//                BYWeakSelf;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.mapView addAnnotation:annotation];
//                });
//            }
//        }
////    }
//    BYLog(@"地图区域已经改变");
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


-(void)delayMethod
{
    self.noticeView.hidden = YES;
    [self.timer invalidate];
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

-(void)zoomInLevel{//放大
    [self.mapView zoomIn];
}
-(void)zoomOutLevel{//缩小
    [self.mapView zoomOut];
}

-(BMKPointAnnotation *)annotation{
    if (_annotation == nil) {
        _annotation = [[BMKPointAnnotation alloc] init];
    }
    return _annotation;
}

-(BYReplayHttpParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYReplayHttpParams alloc] init];

        self.httpParams.speed = YES;
        self.httpParams.sn = self.myModel.sn;
        self.httpParams.deviceid = self.myModel.deviceId;//118703//159311
        self.httpParams.startTime = [self formatterWithFormatterStr:@"yyyy-MM-dd 00:00:00"];
        self.httpParams.endTime = [self formatterWithFormatterStr:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _httpParams;
}

-(NSMutableArray *)totalDataSource{
    if (!_totalDataSource) {
        _totalDataSource = [NSMutableArray array];
    }
    return _totalDataSource;
}

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(NSMutableArray *)parkPointDataSource
{
    if (!_parkPointDataSource) {
        _parkPointDataSource = [NSMutableArray array];
    }
    return _parkPointDataSource;
}

-(NSMutableArray *)fenceDatasource
{
    if (!_fenceDatasource) {
        _fenceDatasource = [NSMutableArray array];
    }
    return _fenceDatasource;
}

-(NSMutableArray *)fenceAnnotations
{
    if (!_fenceAnnotations) {
        _fenceAnnotations = [NSMutableArray array];
    }
    return _fenceAnnotations;
}

-(NSMutableArray *)annotations{
    if (_annotations == nil) {
        _annotations = [[NSMutableArray alloc] init];
    }
    return _annotations;
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
        noticeLabel.frame = CGRectMake((SCREEN_WIDTH - 250) / 2, SCREEN_HEIGHT -SafeAreaBottomHeight - 120, 250, 50);
        self.noticeView.backgroundColor = [UIColor clearColor];
        [self.noticeView addSubview:noticeLabel];
        _noticeLabel = noticeLabel;
    }
    return _noticeLabel;
}
-(UIButton *)searchHighRiskButton{
    if (!_searchHighRiskButton) {
        _searchHighRiskButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchHighRiskButton setTitle:@"点击显示此区域内高危围栏" forState:UIControlStateNormal];
        [_searchHighRiskButton sizeToFit];
        _searchHighRiskButton.by_x = (BYSCREEN_W - 220)/2;
        _searchHighRiskButton.by_y = SCREEN_HEIGHT - SafeAreaBottomHeight - 50;
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


//根据polyline设置地图范围
- (void)mapViewFitPolyline:(BMKPolyline *) polyline {
    CGFloat ltX, ltY, rbX, rbY;
    if (polyline.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyline.points[0];
    ltX = pt.x, ltY = pt.y;
    rbX = pt.x, rbY = pt.y;
    for (int i = 1; i < polyline.pointCount; i++) {
        BMKMapPoint pt = polyline.points[i];
        if (pt.x < ltX) {
            ltX = pt.x;
        }
        if (pt.x > rbX) {
            rbX = pt.x;
        }
        if (pt.y > ltY) {
            ltY = pt.y;
        }
        if (pt.y < rbY) {
            rbY = pt.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(ltX , ltY);
    rect.size = BMKMapSizeMake(rbX - ltX, rbY - ltY);
    [_mapView setVisibleMapRect:rect];
    _mapView.zoomLevel -= 0.5;
}

//将经纬度转化为屏幕坐标,再判断该点是否在屏幕上,不在的话就让该点居中
-(BOOL)coorIsInScreenWith:(CLLocationCoordinate2D)coor{
    
    CGPoint point = [_mapView convertCoordinate:coor toPointToView:_mapView];
    
    CGRect screenRect = CGRectMake(0, 64 + BYS_W_H(55), BYSCREEN_W, BYSCREEN_H - 49 - 64 - BYS_W_H(55));
    
    return CGRectContainsPoint(screenRect,point);//判断该点是否在屏幕内
}

-(NSString *)formatterWithFormatterStr:(NSString *)formatterStr{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterStr];
    NSString * selectDate = [formatter stringFromDate:[NSDate date]];
    
    return selectDate;
}

-(void)dealloc{
    
    if (_mapView != nil) {
        _mapView = nil;
    }
    
//    if (_locService != nil) {
//        _locService = nil;
//    }
}



@end
