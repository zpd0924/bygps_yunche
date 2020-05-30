//
//  BYCheckThreeAddressViewController.m
//  BYGPS
//
//  Created by 主沛东 on 2019/4/29.
//  Copyright © 2019 miwer. All rights reserved.
//

#import "BYCheckThreeAddressViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BMKLocationkit/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "EasyNavigation.h"
#import "BYSendWorkHttpTool.h"
#import "BYDeviceModel.h"
#import "BYSameAddDeviceModel.h"
#import "BYSameAddInstallModel.h"
#import "BYSameAddOrderModel.h"
#import "BYSzSamePopView.h"
#import "UILabel+BYCaculateHeight.h"

@interface BYCheckThreeAddressViewController ()<BMKMapViewDelegate,BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKLocationAuthDelegate>

@property(nonatomic,strong) BMKMapView * mapView;//地图
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray *annotations;

@property (nonatomic , strong) BYSameAddDeviceModel *sameAddDeviceModel;
@property (nonatomic , strong) BYSameAddInstallModel *sameAddInstallModel;
@property (nonatomic , strong) BYSameAddOrderModel *sameAddOrderModel;


@property (nonatomic , strong) BMKPointAnnotation *deviceAnnotation;
@property (nonatomic , strong) BMKPointAnnotation *installAnnotation;
@property (nonatomic , strong) BMKPointAnnotation *orderAnnotation;


@end

@implementation BYCheckThreeAddressViewController

//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    self.disableSlidingBackGesture = YES;
//}
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    self.disableSlidingBackGesture = NO;
//
//}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [_mapView viewWillAppear];
//    _mapView.delegate = self;
//    _searcher.delegate = self;
//    _locationManager.delegate = self;
//    _mapView.compassPosition = CGPointMake(8, BYNavBarMaxH + 8);//设置指南针位置
//    [self loadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; //不用时，置nil,释放内存
//    _searcher.delegate = nil;
//    _locationManager.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationView setTitle:@"定位地址"];
    [self initMapView];//初始化mapView
    [self loadData];
}

-(void)initMapView{
    
    //init mapView
    self.mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    self.mapView.mapType = BMKMapTypeStandard;
    self.mapView.showMapScaleBar = YES;
    self.mapView.delegate = self;
    self.mapView.mapScaleBarPosition = CGPointMake(10, _mapView.frame.size.height - 40);
    [self.view addSubview:self.mapView];
    
    //测试
    [_mapView setZoomLevel:15];
    
#pragma mark 添加右上角全景按钮
//    [_mapView addSubview:self.funcItemsBgView];
    
    //添加放大缩小按钮
//    [self.mapView addSubview:self.zoomLevelImageView];
    
//    _mapView.showsUserLocation = NO;
//    _mapView.userTrackingMode = BMKUserTrackingModeHeading;//定位跟随模式
//    _mapView.showsUserLocation = YES;
//    _mapView.isSelectedAnnotationViewFront = YES;//设定是否总让选中的annotaion置于最前面
//    [self setUserImage];
    
    [_mapView isSelectedAnnotationViewFront];
//    [self.mapView addSubview:self.searchHighRiskButton];
//    self.searchHighRiskButton.hidden = YES;
    //      [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.model.lat, self.model.lon) animated:YES];
    
}

-(void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.deviceModel.deviceSn forKey:@"deviceSn"];
    [params setValue:self.orderNo forKey:@"orderNo"];
    [BYSendWorkHttpTool POSTGetSzSameParams:params success:^(id data) {
        self.sameAddDeviceModel = [BYSameAddDeviceModel yy_modelWithDictionary:data];
        self.sameAddInstallModel = [BYSameAddInstallModel yy_modelWithDictionary:data];
        self.sameAddOrderModel = [BYSameAddOrderModel yy_modelWithDictionary:data];
        
        [self.dataSource addObject:self.sameAddDeviceModel];
        [self.dataSource addObject:self.sameAddInstallModel];
        [self.dataSource addObject:self.sameAddOrderModel];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addAnnotatioWithData];
        });
        
    } failure:^(NSError *error) {
        
    }];
    
//    self.sameAddDeviceModel = [[BYSameAddDeviceModel alloc] init];
//    self.sameAddDeviceModel.deviceAddLat = 20.33;
//    self.sameAddDeviceModel.deviceAddLon = 111.33;
//    self.sameAddDeviceModel.deviceAdd = @"设备地址，我也不知道是哪里";
//    self.sameAddDeviceModel.LocationTime = @"2019-04-23 17:43:34";
//    self.sameAddDeviceModel.LocationType = @"wifi";
//
//    self.sameAddInstallModel = [[BYSameAddInstallModel alloc] init];
//    self.sameAddInstallModel.installAdd = @"安装地址，只有技师知道是哪里";
//    self.sameAddInstallModel.installTime = @"2019-05-01 12:30:00";
//    self.sameAddInstallModel.installAddLat = 22.34;
//    self.sameAddInstallModel.installAddLon = 113.34;
//
//    self.sameAddOrderModel = [[BYSameAddOrderModel alloc] init];
//    self.sameAddOrderModel.orderAdd = @"派单地址，派单人员才知道";
//    self.sameAddOrderModel.orderTime = @"2019-05-02 12:21";
//    self.sameAddOrderModel.orderAddLat = 21.32;
//    self.sameAddOrderModel.orderAddLon = 112.33;
//
//    [self.dataSource addObject:self.sameAddOrderModel];
//    [self.dataSource addObject:self.sameAddDeviceModel];
//    [self.dataSource addObject:self.sameAddInstallModel];
//
//    [self addAnnotatioWithData];
    
    
}

-(void)addAnnotatioWithData{
    
    self.deviceAnnotation = [[BMKPointAnnotation alloc] init];
    self.deviceAnnotation.coordinate = CLLocationCoordinate2DMake(self.sameAddDeviceModel.deviceAddLat, self.sameAddDeviceModel.deviceAddLon);
    self.deviceAnnotation.title = @"设备";
    
    self.installAnnotation = [[BMKPointAnnotation alloc] init];
    self.installAnnotation.coordinate = CLLocationCoordinate2DMake(self.sameAddInstallModel.installAddLat, self.sameAddInstallModel.installAddLon);
    self.installAnnotation.title = @"安装";
    
    self.orderAnnotation = [[BMKPointAnnotation alloc] init];
    self.orderAnnotation.coordinate = CLLocationCoordinate2DMake(self.sameAddOrderModel.orderAddLat, self.sameAddOrderModel.orderAddLon);
    self.orderAnnotation.title = @"派单";
    
    [self.mapView addAnnotation:self.deviceAnnotation];
    [self.mapView addAnnotation:self.installAnnotation];
    [self.mapView addAnnotation:self.orderAnnotation];
    
    [self.annotations addObject:self.deviceAnnotation];
    [self.annotations addObject:self.installAnnotation];
    [self.annotations addObject:self.orderAnnotation];
    
    [self.mapView showAnnotations:self.annotations animated:YES];
    
//    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
//    annotation.coordinate = CLLocationCoordinate2DMake(model.lat, model.lon);
    
    
}

#pragma mark - <mapViewDelegate>
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[BMKUserLocation class]]){
        
//        NSInteger index = [self.annotations indexOfObject:annotation];
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.annotation = annotation;
        newAnnotationView.canShowCallout = YES;
        newAnnotationView.hidePaopaoWhenSingleTapOnMap = YES;
        newAnnotationView.hidePaopaoWhenSelectOthers = YES;
        
        BYSzSamePopView *popView = [BYSzSamePopView by_viewFromXib];
        popView.by_width = 250;
        
        if (annotation == self.deviceAnnotation) {
           newAnnotationView.image = [UIImage imageNamed:@"icon_szsame_device"];
            popView.sameDeviceModel = self.sameAddDeviceModel;
            CGFloat carSta_H = [UILabel caculateLabel_HWith:140 Title:self.sameAddDeviceModel.deviceAdd font:13];
            
            popView.by_height = 56 + 6 + 16 + carSta_H + 5;
        }else if(annotation == self.installAnnotation){
            newAnnotationView.image = [UIImage imageNamed:@"icon_szsame_install"];
            popView.sameInstallModel = self.sameAddInstallModel;
            CGFloat carSta_H = [UILabel caculateLabel_HWith:140 Title:self.sameAddInstallModel.installAdd font:13];
            
            popView.by_height = 56 + carSta_H + 5;
        }else{
            newAnnotationView.image = [UIImage imageNamed:@"icon_szsame_order"];
            popView.sameOrderModel = self.sameAddOrderModel;
            CGFloat carSta_H = [UILabel caculateLabel_HWith:140 Title:self.sameAddOrderModel.orderAdd font:13];
            
            popView.by_height = 56 + carSta_H + 5;
        }
        
        [popView setClosePopBlock:^{
            [self.mapView deselectAnnotation:annotation animated:YES];
        }];
        
        
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc] initWithCustomView:popView];
        pView.backgroundColor = [UIColor clearColor];
        pView.frame = popView.frame;
        newAnnotationView.paopaoView = pView;
        
        return newAnnotationView;
        
    }
    return nil;
}

-(void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
//    if ([view isKindOfClass:[BYAnnotationView class]]) {
    
//        BYAnnotationView *cusView = (BYAnnotationView *)view;
        BMKPointAnnotation *an = (BMKPointAnnotation *)view.annotation;
        [self.mapView setCenterCoordinate:an.coordinate];
//    }
}

-(void)dealloc{
    if (_mapView != nil) {
        _mapView = nil;
    }
    
//    if (_searcher != nil) {
//        _searcher = nil;
//    }
//
    //    if (_locService != nil) {
    //        _locService = nil;
    //    }
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(NSMutableArray *)annotations
{
    if (!_annotations) {
        _annotations = [NSMutableArray array];
    }
    return _annotations;
}
@end
