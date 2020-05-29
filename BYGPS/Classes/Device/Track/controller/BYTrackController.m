//
//  BYTrackController.m
//  BYGPS
//
//  Created by miwer on 16/7/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYTrackController.h"

#import "BYReplayController.h"
#import "BYFenceDataBase.h"
#import "BYFenceControl.h"

#import "BYDetailTabBarController.h"
#import "BYLoginViewController.h"
#import "EasyNavigation.h"
#import "BYBaiduParamaController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "NSString+BYAttributeString.h"

#import "BYAlarmModel.h"
#import "BYAnnotationView.h"
#import "BYFenceAnnotationView.h"
#import "BYTrackPopView.h"
#import "BYPushNaviModel.h"
#import "BYTrackModel.h"
#import "UIButton+countDown.h"
#import "BYRegeoHttpTool.h"
#import "BYQueryZoneHttpTool.h"
#import "BYMonitorHttpTool.h"
#import "BYDeviceDetailHttpTool.h"
#import "sys/utsname.h"

//#import "BYCountDownButton.h"
#import "GuideCoverView.h"

static CGFloat const margin = 8;//22.509903, 113.950091

@interface BYTrackController () <BMKMapViewDelegate,BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKLocationAuthDelegate>

@property(nonatomic,strong) BMKMapView * mapView;//地图
@property(nonatomic,strong) BMKLocationManager * locationManager;
@property(nonatomic,strong) BMKPointAnnotation * annotation;
@property(nonatomic,strong) BYAnnotationView * annotationView;
@property(nonatomic,strong) BMKGeoCodeSearch * searcher;
@property (nonatomic,strong) BMKCircle* circle;//圆形图层
@property (nonatomic,strong) BMKPolygon* polygon;//多边形图层
@property(nonatomic,strong) UIView * funcItemsBgView;//右上角功能按钮背景View
@property(nonatomic,strong) UIImageView * zoomLevelImageView;
@property(nonatomic,strong) BYTrackPopView * popView;
@property(nonatomic,strong) UIButton * countButton;
@property(nonatomic,strong) BYPushNaviModel * naviModel;
@property(nonatomic,assign) BOOL isTabBarNaviHiden;
@property(nonatomic,strong) BYTrackModel * model;
@property(nonatomic,assign) NSInteger trackRefreshDuration;
@property(nonatomic,assign) BOOL isFirstLoad;
@property (nonatomic,strong) NSMutableArray *dataSource;//设备数据
@property (nonatomic,strong) NSMutableArray *fenceDatasource;//高危数据二押点数据
@property (nonatomic,strong) NSMutableArray *totalDatasource;//总数据
@property (nonatomic,strong) NSMutableArray *annotations;//设备标注
@property (nonatomic,strong) NSMutableArray *fenceAnnotations;//二押点标注
@property (nonatomic,strong) NSMutableArray *totalAnnotations;//总标注
@property (nonatomic,strong) NSMutableArray *fenceAnnotationViews;
@property (nonatomic,strong) NSMutableArray *locateCoodinates;//定位数据点数组
@property (nonatomic,strong) NSMutableArray *wayLines;//轨迹线数组
@property (nonatomic,assign) BOOL highRiskIsSelected;//高危按钮是否按下
@property (nonatomic,strong) UIButton * highRiskItem;//高危按钮
@property (nonatomic,strong) UIButton * searchHighRiskButton;  //检索高危按钮
@property (nonatomic,strong) NSString *address;
@property (nonatomic,assign) BOOL isFirstLoadFence;
@property(nonatomic ,weak) UIView *noticeView;
@property(nonatomic,weak) UILabel *noticeLabel;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) BMKPolyline * polyline;
@property(nonatomic,strong) id deviceData;
@property (nonatomic,strong) id fenceData;

@property (nonatomic) NSInteger selectedIndex;

@property (nonatomic,assign) NSInteger locateType;//定位模式 1.gps; 2.基站; 3.wifi
@property (nonatomic,assign) BOOL beenLoadHighRisk;

@property (nonatomic, strong) BMKUserLocation *userLocation; //当前位置对象

@end

@implementation BYTrackController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //    self.navigationController.by_closePopForTemporary = NO;//进入地图时侧滑手势关闭
    self.disableSlidingBackGesture = YES;
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.disableSlidingBackGesture = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.mapView viewWillAppear];
    
    _mapView.delegate = self;
    _searcher.delegate = self;
    _locationManager.delegate = self;
    _isFirstLoadFence = YES;
    _isFirstLoad = YES;
    self.mapView.compassPosition = CGPointMake(margin, BYSCREEN_H - BYTabBarH - self.mapView.compassSize.width - 15);//设置指南针位置
    [self.tabBarController.navigationView removeAllRightButton];
    [self.tabBarController.navigationView removeAllRightButton];
    [self.tabBarController.navigationView setTitle:@"实时追踪"];
    self.tabBarController.navigationItem.rightBarButtonItems = nil;
    
    BYDetailTabBarController * tabBarVC = (BYDetailTabBarController *)self.tabBarController;
    self.naviModel = tabBarVC.model;
    
    if (![BYSaveTool isContainsKey:BYSelfClassName]) {
        [BYSaveTool setBool:YES forKey:BYSelfClassName];
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYGuideImageView showGuideViewWith:BYSelfClassName touchOriginYScale:0.5];
        });
    }
    if ([BYSaveTool boolForKey:BYMonitorTrackKey]) {
        [self loadMonitorDeviceData];
    }else{
        
    }
    
    
    [self.countButton setTitle:@"正在刷新..." forState:UIControlStateNormal];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    _mapView.delegate = nil; //不用时，置nil,释放内存
    _searcher.delegate = nil;
    _locationManager.delegate = nil;
    
    //    [_mapView removeAnnotations:self.annotations];
    BYWeakSelf;
    if (self.model) {//当加载的数据不为空时即不是第一次加载
        [weakSelf.countButton cancelTimer];//视图消失时关闭倒计时
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([BYSaveTool boolForKey:BYMonitorTrackKey]) {
        [self initMapView];//初始化mapView
        [self initBaseUI];   //初始化UI
        [self initLocationService];//初始化定位服务
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

-(void)initBaseUI{
    self.isFirstLoad = YES;//第一次请求
    self.isTabBarNaviHiden = NO;
    
    //添加右上角功能按钮
    [self.mapView addSubview:self.funcItemsBgView];
    
    //添加放大缩小按钮
    [self.mapView addSubview:self.zoomLevelImageView];
    
    _trackRefreshDuration = [BYSaveTool getRefreshDurationIntegerWithKey:BYTrackRefreshDuration];//先取出刷新间隔
    [self.mapView addSubview:self.countButton];//添加倒计时button
    [self.mapView addSubview:self.searchHighRiskButton];
    self.searchHighRiskButton.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baiduMapNaviChange) name:BYBecomeActiveKey object:nil];
}

//百度地图导航时引起的原本隐藏的导航栏显示出来
-(void)baiduMapNaviChange{
    if (self.isTabBarNaviHiden) {//如果当前是隐藏状态,则都让它显示出来
        [self tapMapViewBlank];
    }
}

-(void)loadLocationTypeDeviceData{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"deviceId"] = @(self.naviModel.deviceId);//@(159202);
    params[@"locateType"] = @(self.locateType);
    
    [BYMonitorHttpTool POSTMonitorRealTimeTrackingWithParams:params success:^(id data) {
        self.model = [[BYTrackModel alloc] initWithDictionary:data error:nil];
        self.locateType = self.model.locateType;
        [self.locateCoodinates addObject:self.model];
        [self creatPolyLineWay];
        [self handleDeviceData:data];
        [self handleFenceDataWithFenceData:self.fenceData];
    } failure:^(NSError *error) {
        
    } showError:YES];
}

-(void)loadMonitorDeviceData{
    BYWeakSelf;
//    if (!self.highRiskItem.selected) {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        params[@"deviceId"] = @(self.naviModel.deviceId);//@(159202);
        params[@"locateType"] = @(self.locateType);
        
        [BYMonitorHttpTool POSTMonitorRealTimeTrackingWithParams:params success:^(id data) {
            self.model = [[BYTrackModel alloc] initWithDictionary:data error:nil];
            self.locateType = self.model.locateType;
            [self.locateCoodinates addObject:self.model];
            [self creatPolyLineWay];
            [weakSelf handleDeviceData:data];
        } failure:^(NSError *error) {
            
        } showError:YES];
//    }else{
//
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSMutableDictionary * params = [NSMutableDictionary dictionary];
//            params[@"deviceId"] = @(self.naviModel.deviceId);//@(159202);
//            params[@"locateType"] = @(self.locateType);
//            [BYMonitorHttpTool POSTMonitorRealTimeTrackingWithParams:params success:^(id data) {
//                BYLog(@"--------------deviceData success");
//                weakSelf.deviceData = data;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.model = [[BYTrackModel alloc] initWithDictionary:data error:nil];
//
//                    self.locateType = self.model.locateType;
//                    [self.locateCoodinates addObject:self.model];
//                    [self creatPolyLineWay];
//                    [self handleDeviceData:self.deviceData];
//                    //                   [self handleFenceDataWithFenceData:self.fenceData];
//                    //                   [self.mapView addAnnotations:self.annotations];
//                });
//
//            } failure:^(NSError *error) {
//
//            } showError:YES];
//        });
//
////        dispatch_async(dispatch_get_global_queue(0, 0), ^{
////            [BYQueryZoneHttpTool POSTQueryZoneSuccess:^(id data) {
////                BYLog(@"--------------fenceData success");
////                weakSelf.fenceData = data;
////                dispatch_async(dispatch_get_main_queue(), ^{
////                    //                   [weakSelf handleDeviceData:self.deviceData];
////                    [weakSelf handleFenceDataWithFenceData:self.fenceData];
////                    //                   [weakSelf.mapView addAnnotations:self.annotations];
////                });
////
////            } failure:^(NSError *error) {
////
////            }];
////        });
//    }
}

-(void)loadFenceData{
    [BYQueryZoneHttpTool POSTQueryZoneSuccess:^(id data) {
        BYLog(@"--------------fenceData success");
        self.fenceData = data;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleFenceDataWithFenceData:self.fenceData];
            //            [self.mapView addAnnotations:self.annotations];
        });
        
    } failure:^(NSError *error) {
        
    }];
}
-(void)handleFenceDataWithFenceData:(NSArray *)data
{
    
    BYLog(@"_------------------in handleFenceDataWithFenceData");
//    if (self.fenceDatasource.count != data.count) {
    
        [self.mapView removeAnnotations:self.fenceAnnotations];
        [self.totalDatasource removeObjectsInArray:self.fenceDatasource];
        [self.fenceDatasource removeAllObjects];
        [self.annotations removeObjectsInArray:self.fenceAnnotations];
        [self.fenceAnnotations removeAllObjects];
        
        for (NSDictionary *dic in data) {
            BYTrackModel *model = [[BYTrackModel alloc] initWithDictionary:dic error:nil];
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
                BYWeakSelf;
                highRiskNum ++;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.mapView addAnnotation:annotation];
                });
            }
        }

        CLLocationCoordinate2D coordinate;
        if (self.fenceDatasource.count) {
            BMKPointAnnotation * an = self.annotations[self.dataSource.count];
            coordinate = an.coordinate;
            [self.mapView selectAnnotation:an animated:YES];
        }
        self.isFirstLoadFence = NO;
    self.searchHighRiskButton.hidden = NO;
    [self.searchHighRiskButton setTitle:[NSString stringWithFormat:@"该区域共查到%ld个高危围栏",(long)highRiskNum] forState:UIControlStateNormal];
//    }else{
//        [self.totalDatasource addObjectsFromArray:self.fenceDatasource];
//        [self.annotations addObjectsFromArray:self.fenceAnnotations];
//    }
}

-(void)handleDeviceData:(id)data{
    
    //    [self.annotations removeObject:self.annotation];
    [self.dataSource removeAllObjects];
    [self.totalDatasource removeAllObjects];
    
    [self.dataSource addObject:self.model];
    [self.totalDatasource addObjectsFromArray:self.dataSource];
    [self.totalDatasource addObjectsFromArray:self.fenceDatasource];
    
    if ([self.model.model isEqualToString:@"013C"]) {
        self.address = @"无法获取当前位置";
        self.popView.address = self.address;
        self.popView.model = self.model;
        self.annotationView.paopaoView.by_height = self.model.pop_H;
        self.popView.frame = CGRectMake(0, 0, BYS_W_H(250), self.model.pop_H);
        [self.mapView mapForceRefresh];
    }else{
        [self geoDecodeWith:self.model.lat lon:self.model.lon];//解析地理位置
    }
    
    self.annotationView.isControlCar = NO;
    self.annotationView.direction = self.model.direction;//将方向也设置上去
    self.annotationView.alarmOrOff = self.model.iconId;//将状态赋值过去
    
    NSString *carNumStr;
    if (self.model.carId > 0) {
        if (self.model.carNum.length > 0) {
            carNumStr = self.model.carNum;
            carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
        }else{
            if (self.model.carVin.length > 6) {
                NSRange range = NSMakeRange(self.model.carVin.length - 6, 6);
                carNumStr = [NSString stringWithFormat:@"...%@",[self.model.carVin substringWithRange:range]];
            }else{
                carNumStr = self.model.carVin;
            }
        }
    }else{
        carNumStr = self.model.sn;
    }
    
    NSString *ownerNameStr = [NSString StringJudgeIsValid:self.model.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
    
    ownerNameStr = ownerNameStr.length > 4 ? [NSString stringWithFormat:@"%@...", [ownerNameStr substringToIndex:4]] : ownerNameStr;
    self.annotationView.carNum = [NSString stringWithFormat:@"%@(%@) %@",carNumStr,self.model.wifi ? @"无线" : @"有线",ownerNameStr];
    //当已经添加标注时,则刷新数据和标注坐标
    dispatch_async(dispatch_get_main_queue(), ^{
        self.annotation.coordinate = CLLocationCoordinate2DMake(self.model.lat, self.model.lon);
        self.popView.model = self.model;//将数据添加到气泡上
        self.popView.address = self.address;
        self.popView.model = self.model;//将数据添加到气泡上
        self.annotationView.paopaoView.by_height = self.model.pop_H;
        self.popView.frame = CGRectMake(0, 0, BYS_W_H(250), self.model.pop_H);
        [self.mapView mapForceRefresh];
//        self.annotationView.paopaoView.hidden = NO;
        
    });
       [self updateDistance];//计算我俩距离
    //   BYWeakSelf;
    [self.annotations removeObject:self.annotation];
    [self.annotations insertObject:self.annotation atIndex:0];
    BYWeakSelf;
    if (self.isFirstLoad == YES) {
        
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.model.lat, self.model.lon) animated:YES];//地图标注居中
        //标注组添加标志
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView addAnnotation:self.annotation];//添加标注
            [self.mapView selectAnnotation:self.annotation animated:YES];
        });
        self.isFirstLoad = NO;//将第一次请求改NO
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.model.lat, self.model.lon) animated:YES];//地图标注居中
            [self.mapView addAnnotation:self.annotation];
        });
    }
    
    [self.countButton startWithTime:_trackRefreshDuration zeroBlock:^{
        [weakSelf loadMonitorDeviceData];
    }];
}

-(void)createPolyline{
    
    if (self.polyline) {//移除原有的绘图，避免在原来轨迹上重画
        [self.mapView removeOverlay:self.polyline];
        self.polyline = nil;
    }
    
    CLLocationCoordinate2D coords[2] = {0};
    coords[0].latitude = self.model.lat;
    coords[0].longitude = self.model.lon;
    coords[1] = self.userLocation.location.coordinate;
    
    BYWeakSelf;
    //构建BMKPolyline,使用分段颜色索引，其对应的BMKPolylineView必须设置colors属性
    self.polyline = [BMKPolyline polylineWithCoordinates:coords count:2];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addOverlay:self.polyline];
    });
}
#pragma mark 画路径
-(void)creatPolyLineWay{
    if (self.locateCoodinates.count < 2) {
        return;
    }
    CLLocationCoordinate2D * coords = malloc(sizeof(CLLocationCoordinate2D) * 2);
    BYTrackModel *startM = self.locateCoodinates[self.locateCoodinates.count - 2];
    BYTrackModel *endM = self.locateCoodinates[self.locateCoodinates.count - 1];
    
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
    [self.wayLines addObject:wayLine];
    BYWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mapView addOverlay:wayLine];
    });
    free(coords);//释放数组;
}

#pragma mark - <mapViewDelegate>
-(BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    
    if (![annotation isKindOfClass:[BMKUserLocation class]]){
        
        NSInteger index = [self.annotations indexOfObject:annotation];
        
        BYTrackModel * model = self.totalDatasource[index];
        if (model.type) {
            BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
            //         newAnnotationView.animatesDrop = self.isFirstLoadFence;
            
            newAnnotationView.annotation = annotation;
            newAnnotationView.image = [UIImage imageNamed:@"icon_risk"];
            newAnnotationView.hidePaopaoWhenSelectOthers = YES;
            return newAnnotationView;
        }else{
            
            self.annotationView = [[BYAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotationView"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.annotationView.isControlCar = NO;
                self.annotationView.direction = self.model.direction;//将方向也设置上去
                self.annotationView.alarmOrOff = self.model.iconId;//将状态赋值过去
                
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
                    carNumStr = self.model.sn;
                }
                
                NSString *ownerNameStr = [NSString StringJudgeIsValid:self.model.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
                
                ownerNameStr = ownerNameStr.length > 4 ? [NSString stringWithFormat:@"%@...", [ownerNameStr substringToIndex:4]] : ownerNameStr;
                self.annotationView.carNum = [NSString stringWithFormat:@"%@(%@) %@",carNumStr,model.wifi ? @"无线" : @"有线",ownerNameStr];
                //定制popView
                
                self.popView = [BYTrackPopView by_viewFromXib];
                
                self.popView.address = self.address;
                self.popView.model = self.model;
                //            GPS 基站 WIFI:
                //            026 036
                //
                //            GPS 基站
                //            011 013 015 018 019 027 038
                if ([self.model.model isEqualToString:@"026"] || [self.model.model isEqualToString:@"036"]||[self.model.model isEqualToString:@"027W"] || [self.model.model isEqualToString:@"027WL"] || [self.model.model isEqualToString:@"029"] || [self.model.model isEqualToString:@"026LB"] || [self.model.model isEqualToString:@"035W"] || [self.model.model isEqualToString:@"013MW"] ||[self.model.model isEqualToString:@"015W"] || [self.model.model isEqualToString:@"G1-043WF"] ) {
                    self.popView.buttonItems = @[@"GPS",@"基站",@"WIFI"];
                }else if([self.model.model isEqualToString:@"G1-041W"]||[self.model.model isEqualToString:@"G2-042WF"]){
                    self.popView.buttonItems = @[@"基站",@"WIFI"];
                }else{
                    self.popView.buttonItems = @[@"GPS",@"基站"];
                }
                if([self.model.model isEqualToString:@"G1-041W"]||[self.model.model isEqualToString:@"G2-042WF"]){
                    self.popView.selectedIndex = self.locateType - 2;
                }else{
                    self.popView.selectedIndex = self.locateType - 1;
                }
                
                
                CGFloat pop_W = BYS_W_H(250);
                //计算自适应高度
                //            self.popView.address = self.address;
                self.popView.frame = CGRectMake(0, 0, pop_W, self.model.pop_H);
                
                BMKActionPaopaoView * paopaoView=[[BMKActionPaopaoView alloc] initWithCustomView:self.popView];
                paopaoView.height = self.model.pop_H;
                [self.mapView mapForceRefresh];
                BYWeakSelf;
                [self.popView setDismissBlcok:^{//气泡消失
//                    paopaoView.hidden = weakSelf.annotationView.isSelected;
//                    [weakSelf.annotationView setSelected:NO animated:YES];
                    [weakSelf.mapView deselectAnnotation:annotation animated:YES];
                }];
#pragma mark 发起现拍

#pragma mark 导航
                [self.popView setGotoBaiduMapBlock:^{
                    //               [weakSelf gotoBaiduMapAction];
                    MobClickEvent(@"real_time_GPS", @"");
                    if (model.carId > 0) {
                        [weakSelf gotoBaiduMapActionWithDeviceId:model.deviceId];
                    }else{
                        return BYShowError(@"该设备未装车");
                    }
                }];
#pragma mark 轨迹回放
                [self.popView setGotoReplayBlock:^{
                    MobClickEvent(@"real_time_playback", @"");
                    BYReplayController *replayVC = [[BYReplayController alloc] init];
                    replayVC.myModel = weakSelf.naviModel;
                    [weakSelf.navigationController pushViewController:replayVC animated:YES];
                }];
                
                [self.popView setGetLocationChangeBlock:^(NSInteger type) {
                    if([weakSelf.model.model isEqualToString:@"G1-041W"]||[self.model.model isEqualToString:@"G2-042WF"]){
                        weakSelf.locateType = type + 1;
                    }else{
                        weakSelf.locateType = type;
                    }
                    
                    [weakSelf changeAnnotationLocateWithType:type];
                }];
                self.annotationView.paopaoView = paopaoView;
                
                //计算偏移的宽度
                CGSize carNumSize = [[NSString stringWithFormat:@"%@(%@) %@",carNumStr,model.wifi ? @"无线" : @"有线",ownerNameStr] sizeWithAttributes: @{NSFontAttributeName: BYS_T_F(12)}];
                CGFloat offset_W = (carNumSize.width + 45) / 2 - 6;
                self.annotationView.centerOffset = CGPointMake(offset_W, - 3);
                self.annotationView.calloutOffset = CGPointMake(- offset_W, - 5);
                self.annotationView.hidePaopaoWhenSelectOthers = YES;
                self.annotationView.canShowCallout = YES;
                [self.mapView selectAnnotation:annotation animated:YES];
//                [self.annotationView setSelected:YES animated:YES];
            });
            
            return self.annotationView;
            
        }
    }
    return nil;
}

-(void)changeAnnotationLocateWithType:(NSInteger)type{
    
    [self.mapView removeOverlays:self.wayLines];
    [self.wayLines removeAllObjects];
    [self.locateCoodinates removeAllObjects];
    [self.countButton cancelTimer];
    [self.countButton setTitle:@"正在刷新..." forState:UIControlStateNormal];
    
    //   self.isFirstLoad = YES;
    [self loadLocationTypeDeviceData];
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
//    if (self.highRiskIsSelected) {
//        [self.mapView removeAnnotations:self.fenceAnnotations];
//        for (NSInteger i = 0; i < self.fenceAnnotations.count; i ++) {
//            BMKPointAnnotation *annotation = self.fenceAnnotations[i];
//
//            if (BMKPolygonContainsCoordinate(annotation.coordinate, coords, 4)) {
//                BYLog(@"在视野内");
//                BYWeakSelf;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.mapView addAnnotation:annotation];
//                });
//            }
//        }
//    }
//    BYLog(@"地图区域已经改变");
}


- (void)mapView:(BMKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    
    //    [self updateDistance];
}

-(void)updateDistance{
    if (self.model && self.userLocation.location) {//当数据加载过来并且已经定位到数据
        BMKMapPoint point1 = BMKMapPointForCoordinate(self.userLocation.location.coordinate);
        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(self.model.lat,self.model.lon));
        
        [self createPolyline];
        self.popView.distance = BMKMetersBetweenMapPoints(point1,point2);
    }
}

-(void)initMapView{
    
    self.mapView.mapType = BMKMapTypeStandard;
    self.mapView.showMapScaleBar = YES;
    self.mapView.mapScaleBarPosition = CGPointMake(10, _mapView.frame.size.height - SafeAreaBottomHeight - 40);
    [self.view addSubview: self.mapView];
    
    //测试
    [self.mapView setZoomLevel:15];
    
    self.mapView.userTrackingMode = BMKUserTrackingModeHeading;
    [self setUserImage];
    /**
     BMKUserTrackingModeNone = 0,             /// 普通定位模式
     BMKUserTrackingModeHeading,              /// 定位方向模式
     BMKUserTrackingModeFollow,               /// 定位跟随模式
     BMKUserTrackingModeFollowWithHeading,    /// 定位罗盘模式
     */
    self.mapView.showsUserLocation = YES;
    
    self.mapView.isSelectedAnnotationViewFront = YES;//设定是否总让选中的annotaion置于最前面
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
    [self.mapView updateLocationViewWithParam:displayParam]; //调用此方法后自定义定位图层生效
}


-(void)geoDecodeWith:(double)lat lon:(double)lon{
    
    [BYRegeoHttpTool POSTRegeoAddressWithLat:self.model.lat lng:self.model.lon success:^(id data) {
        //      BYWeakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([data[@"address"] isEqualToString:@""]) {
                self.address = @"无法获取当前位置";
                self.popView.address = self.address;
            }else{
                self.address = data[@"address"];
                self.popView.address = self.address;
            }
            self.popView.model = self.model;
            self.annotationView.paopaoView.by_height = self.model.pop_H;
            self.popView.frame = CGRectMake(0, 0, BYS_W_H(250), self.model.pop_H);
            [self.mapView mapForceRefresh];
        });
        BYLog(@"address == %@",data[@"address"]);
    } failure:^(NSError *error) {
        
    }];
}

//接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    
    if (error == BMK_SEARCH_NO_ERROR) {
        if (result.address.length <=0) {
            self.popView.address = @"无法获取当前位置";
            self.popView.subAddress = @"无法获取当前位置";
        }else{
            self.popView.subAddress = result.address;
            //           self.popView.model = self.model;
        }
        //        BYLog(@"%@",result.addressDetail.district);
    }
    else {
        self.popView.subAddress = @"无法获取当前位置";
        NSLog(@"抱歉，未找到结果");
    }
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
        if (overlay == self.polyline) {
            BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
            polylineView.lineWidth = 1;
            polylineView.strokeColor = [UIColor colorWithHex:@"#6CDD8D"];
            /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
            polylineView.colors = [NSArray arrayWithObjects:[UIColor purpleColor], [UIColor redColor], [UIColor blueColor], nil];
            return polylineView;
        }else{
            BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
            polylineView.lineWidth = 3;
            polylineView.strokeColor = [UIColor colorWithHex:@"#6CDD8D"];
            /// 使用分段颜色绘制时，必须设置（内容必须为UIColor）
            polylineView.colors = [NSArray arrayWithObjects:[UIColor blueColor], [UIColor blueColor], [UIColor blueColor], nil];
            return polylineView;
        }
    }
    return nil;
}

-(void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    
    [self tapMapViewBlank];
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

-(void)zoomInLevel{//放大
    BYLog(@"%f",self.mapView.zoomLevel);
    [self.mapView zoomIn];
}
-(void)zoomOutLevel{//缩小
    BYLog(@"%f",self.mapView.zoomLevel);
    [self.mapView zoomOut];
}
-(void)changeMapType:(UIButton *)button{
    button.selected = !button.selected;
    self.mapView.mapType = button.selected ? BMKMapTypeSatellite : BMKMapTypeStandard;
}

-(void)changeMeCarLocation:(UIButton *)button{
    button.selected = !button.selected;
    
    CLLocationCoordinate2D coordinate;
    if (button.selected) {
        coordinate = self.userLocation.location.coordinate;
        
    }else{
        [self.mapView selectAnnotation:self.annotation animated:YES];
        coordinate = CLLocationCoordinate2DMake(self.model.lat, self.model.lon);
    }
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coordinate, BMKCoordinateSpanMake(0.02f,0.02f));
    BMKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
}
#pragma mark前往百度地图
-(void)gotoBaiduMapActionWithDeviceId:(NSInteger)deviceId{
    
    //    if (!self.dataSource.count) {
    //        return [BYProgressHUD by_showErrorWithStatus:@"没有可导航的车辆"];
    //    }
    
    [BYDeviceDetailHttpTool POSTQueryOtherDevideWithDeviceId:deviceId success:^(id data) {
        
        if (![data isKindOfClass:[NSNull class]]) {
            [self alertShowWithData:data];
        }else{
            [self gotoBaiduMap];
        }
    }];
    
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

-(void)gotoBaiduMap{//前往百度地图
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BYDeviceDetailHttpTool POSTOpenDeviceAlarmWithDeviceId:self.model.deviceId success:^(id data) {
            
        }];
    });
    
    BMKOpenDrivingRouteOption * drive = [[BMKOpenDrivingRouteOption alloc] init];
    drive.appScheme = @"baidumapsdk1://gps.bycda";//用于调起成功后，返回原应用
    
    BMKPlanNode * start = [[BMKPlanNode alloc]init];//初始化起点节点
    start.pt = self.userLocation.location.coordinate;//指定起点经纬度
    drive.startPoint = start;//指定起点
    
    BMKPlanNode * end = [[BMKPlanNode alloc]init];//初始化终点节点
    end.pt = CLLocationCoordinate2DMake(self.model.lat, self.model.lon);
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
#pragma mark 前往实景地图
-(void)goToBaiduPanoramaView{
    
    BYBaiduParamaController *panoramaVC = [[BYBaiduParamaController alloc] init];
    panoramaVC.lat = self.model.lat;
    panoramaVC.lon = self.model.lon;
    panoramaVC.address = self.address;
    
    NSString *carNumStr;
    if (self.model.carId > 0) {
        if (self.model.carNum.length > 0) {
            carNumStr = self.model.carNum;
            carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
        }else{
            if (self.model.carVin.length > 6) {
                NSRange range = NSMakeRange(self.model.carVin.length - 6, 6);
                carNumStr = [NSString stringWithFormat:@"...%@",[self.model.carVin substringWithRange:range]];
            }else{
                carNumStr = self.model.carVin;
            }
        }
    }else{
        carNumStr = @"未装车";
    }
    
    NSString *ownerNameStr = [NSString StringJudgeIsValid:self.model.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
    ownerNameStr = ownerNameStr.length > 4 ? [NSString stringWithFormat:@"%@...",[ownerNameStr substringToIndex:4]] : ownerNameStr;
    
    if (self.model.carId > 0) {
        panoramaVC.titleStr = [NSString stringWithFormat:@"%@ %@",carNumStr,ownerNameStr];
    }else{
        panoramaVC.titleStr = carNumStr;
    }
    [self.navigationController pushViewController:panoramaVC animated:YES];
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
    [self updateDistance];
}
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
//
//    [self.mapView updateLocationData:userLocation];
//    [self updateDistance];
//}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    view.paopaoView.hidden = NO;//让气泡显示出来
    NSInteger index = [self.annotations indexOfObject:view.annotation];
    if (self.highRiskItem.selected) {
        if (index >= self.dataSource.count && index <= self.totalDatasource.count) {
            view = (BYFenceAnnotationView *)view;
            
            BYTrackModel * model = self.totalDatasource[index];
            [self drawFenceRegionWithModel:model];
//            view.paopaoView.hidden = NO;
            
        }
    }
}

#pragma mark 根据模型添加围栏
-(void)drawFenceRegionWithModel:(BYTrackModel *)model
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

#pragma mark - lazy
//@property (nonatomic,strong) NSMutableArray *fenceDatasource;
//@property (nonatomic,strong) NSMutableArray *totalDatasource;
//@property (nonatomic,strong) NSMutableArray *annotations;
//@property (nonatomic,strong) NSMutableArray *fenceAnnotations;
//@property (nonatomic,strong) NSMutableArray *totalAnnotations;
//@property (nonatomic,strong) NSMutableArray *fenceAnnotationViews;

-(BMKMapView *)mapView
{
    if (_mapView == nil) {
        _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    }
    return _mapView;
    
}
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

-(NSMutableArray *)locateCoodinates
{
    if (!_locateCoodinates) {
        _locateCoodinates = [NSMutableArray array];
    }
    return _locateCoodinates;
}

-(NSMutableArray *)wayLines
{
    if (!_wayLines) {
        _wayLines = [NSMutableArray array];
    }
    return _wayLines;
}

-(UIView *)funcItemsBgView{
    
    if (_funcItemsBgView == nil) {
        
        _funcItemsBgView = [[UIView alloc] init];
        _funcItemsBgView.by_x = BYSCREEN_W - margin - 33;
        _funcItemsBgView.by_y = SafeAreaTopHeight + margin;
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
        
#pragma mark 添加全景按钮
        UIButton * gotoPanoramaViewItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [gotoPanoramaViewItem setImage:[UIImage imageNamed:@"control_icon_panorama"] forState:UIControlStateNormal];
        gotoPanoramaViewItem.frame = CGRectMake(0,  33 * 2 + 2 * margin, 33, 33);
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

#pragma mark 打开高危
-(void)openOrCloseHishRisk:(UIButton *)button{
    
    button.selected = !button.selected;
    self.highRiskIsSelected = button.selected;
    
    //如果数据库中找到了该该用户,那么更新状态
    if ([[BYFenceDataBase shareInstance] queryMenWithUserName:[BYSaveTool valueForKey:BYusername]]) {
        [[BYFenceDataBase shareInstance] updateUserWithTrackIsMonitor:button.selected user:[BYSaveTool valueForKey:BYusername]];
    }else{
        [[BYFenceDataBase shareInstance] insertFenceUser:[BYSaveTool valueForKey:BYusername] controlIsMonitor:NO trackIsMonitor:button.selected alarmIsMonitor:NO];
    }
    
    if (self.highRiskItem.selected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.5 animations:^{
                self.noticeLabel.text = @"高危点已开启，请放大地图比例尺至5公里内查看！";
                self.noticeView.hidden = NO;
            }];
            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
        });
        self.isFirstLoadFence = YES;
        //      [self.countButton cancelTimer];
        //      [self.countButton setTitle:@"正在刷新..." forState:UIControlStateNormal];
//        [self loadFenceData];
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
        self.isFirstLoadFence = NO;
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
        self.fenceData = nil;
        [self.totalDatasource addObjectsFromArray:self.dataSource];
    }
}

#pragma mark 高危按钮事件
-(void)highRiskView:(UIButton *)button
{
//    button.selected = !button.selected;
//    self.highRiskIsSelected = button.selected;
    
//    //如果数据库中找到了该该用户,那么更新状态
//    if ([[BYFenceDataBase shareInstance] queryMenWithUserName:[BYSaveTool valueForKey:BYusername]]) {
//        [[BYFenceDataBase shareInstance] updateUserWithTrackIsMonitor:button.selected user:[BYSaveTool valueForKey:BYusername]];
//    }else{
//        [[BYFenceDataBase shareInstance] insertFenceUser:[BYSaveTool valueForKey:BYusername] controlIsMonitor:NO trackIsMonitor:button.selected alarmIsMonitor:NO];
//    }
    
    if (!self.beenLoadHighRisk) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.5 animations:^{
//                self.noticeLabel.text = @"高危区域点已开启";
//                self.noticeView.hidden = NO;
//            }];
//            _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(delayMethod) userInfo:nil repeats:NO];
//        });
//        self.isFirstLoadFence = YES;
        //      [self.countButton cancelTimer];
        //      [self.countButton setTitle:@"正在刷新..." forState:UIControlStateNormal];
        self.beenLoadHighRisk = YES;
        [self loadFenceData];
    }
//    else{
//        self.isFirstLoadFence = NO;
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
//        self.fenceData = nil;
//        [self.totalDatasource addObjectsFromArray:self.dataSource];
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
        noticeLabel.frame = CGRectMake((SCREEN_WIDTH - 250) / 2, SCREEN_HEIGHT -SafeAreaBottomHeight - 120, 250, 50);
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
    self.timer = nil;
}

-(void)loadFenceAnnotationsData{
    [BYQueryZoneHttpTool POSTQueryZoneSuccess:^(NSArray * data) {
        [self handleFenceDataWithFenceData:data];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark 处理围栏数据
-(void)handleFenceData:(BYTrackModel *)model{
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

-(UIImageView *)zoomLevelImageView{
    if (_zoomLevelImageView == nil) {
        
        _zoomLevelImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-jia"]];
        [_zoomLevelImageView sizeToFit];
        _zoomLevelImageView.userInteractionEnabled = YES;
        
        CGFloat imageW = _zoomLevelImageView.image.size.width;
        CGFloat imageH = _zoomLevelImageView.image.size.height;
        
        _zoomLevelImageView.by_x = BYSCREEN_W - margin - imageW;
        _zoomLevelImageView.by_y = BYSCREEN_H - BYTabBarH - imageH - 15;
        
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
        _countButton.frame = CGRectMake(margin, SafeAreaTopHeight + margin, 85, 30);
        _countButton.backgroundColor = [UIColor whiteColor];
        [_countButton setTitle:[NSString stringWithFormat:@"%zd秒后刷新",_trackRefreshDuration] forState:UIControlStateNormal];
        [_countButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _countButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _countButton.layer.cornerRadius = 3;
        _countButton.clipsToBounds = YES;
        _countButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _countButton.layer.borderWidth = 1;
        _countButton.userInteractionEnabled = NO;
    }
    return _countButton;
}

-(UIButton *)searchHighRiskButton
{
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

-(void)tapMapViewBlank{
    
    if (self.polygon) {
        [self.mapView removeOverlay:self.polygon];
    }
    if (self.circle) {
        [self.mapView removeOverlay:self.circle];
    }
    
    self.isTabBarNaviHiden = !self.isTabBarNaviHiden;
    
    BYWeakSelf;
    CGRect tabBarRect = self.tabBarController.tabBar.frame;//tabBar
    CGRect naviRect = self.tabBarController.navigationView.frame;//naviBar
    CGRect funcItemsRect = self.funcItemsBgView.frame;//右上角功能按钮s
    CGRect countButtonRect = self.countButton.frame;//左上角倒计时按钮
    CGRect zoomRect = self.zoomLevelImageView.frame;
    CGPoint comPassPostion = self.mapView.compassPosition;
    
    if (self.isTabBarNaviHiden) {
        tabBarRect.origin.y = BYSCREEN_H;
        naviRect.origin.y = -BYNavBarMinH;
        funcItemsRect.origin.y -= BYNavBarMinH - STATUSBAR_HEIGHT;
        countButtonRect.origin.y -= BYNavBarMinH - STATUSBAR_HEIGHT;
        zoomRect.origin.y += BYTabBarH - 9;
        comPassPostion.y += BYTabBarH - 9;
    }else{
        funcItemsRect.origin.y += BYNavBarMinH - STATUSBAR_HEIGHT;
        countButtonRect.origin.y += BYNavBarMinH - STATUSBAR_HEIGHT;
        tabBarRect.origin.y = BYSCREEN_H - BYTabBarH;
        naviRect.origin.y = BYStatusBarH;
        zoomRect.origin.y -= BYTabBarH - 9;
        comPassPostion.y -= BYTabBarH - 9;
    }
    
    [UIView animateWithDuration:BYTabNaviHidenDuration animations:^{
        weakSelf.tabBarController.tabBar.frame = tabBarRect;
        weakSelf.tabBarController.navigationView.frame = naviRect;
        weakSelf.funcItemsBgView.frame = funcItemsRect;
        weakSelf.zoomLevelImageView.frame = zoomRect;
        weakSelf.countButton.frame = countButtonRect;
        self.mapView.compassPosition = comPassPostion;
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BYBecomeActiveKey object:nil];
    
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


@end

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//
//    if ([self.tabBarController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.tabBarController.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }//当进入地图页面时,把侧滑手势关闭
//}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    if ([self.tabBarController.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.tabBarController.navigationController.interactivePopGestureRecognizer.enabled = YES;
//    }//当进入地图页面时,把侧滑手势开启
//}
