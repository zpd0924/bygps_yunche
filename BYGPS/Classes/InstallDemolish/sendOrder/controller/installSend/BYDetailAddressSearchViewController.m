//
//  BYDetailAddressSearchViewController.m
//  BYIntelligentAssistant
//
//  Created by 主沛东 on 2019/4/10.
//  Copyright © 2019 BYKJ. All rights reserved.
//

#import "BYDetailAddressSearchViewController.h"
#import "BYChoiceServerAdressViewController.h"
#import "BYDetailSearchHeadView.h"
#import "BYDetailAddressSearchSectionView.h"
#import "BYDetailAddressSearchCell.h"
#import "BYAlertTip.h"
#import "EasyNavigation.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BMKLocationKit/BMKLocationComponent.h>//引入定位功能所有的头文件

@interface BYDetailAddressSearchViewController ()<UITableViewDelegate,UITableViewDataSource,BMKPoiSearchDelegate,BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate,BMKLocationAuthDelegate>

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) BYDetailSearchHeadView *searchHeadView;

@property (nonatomic , strong) BYDetailAddressSearchSectionView *sectionView;

@property(nonatomic,strong) BMKLocationManager * locationManager;


@property (nonatomic , strong) CLLocation *myLocation;


@property(nonatomic, copy) BMKLocatingCompletionBlock completionBlock;

@property (nonatomic , strong) BMKPoiSearch *poiSearch;

@property (nonatomic , strong) BMKPOICitySearchOption *poiSearchOption;

@property (nonatomic , strong) BMKPOINearbySearchOption *poiNearbySearchOption;


@property (nonatomic , strong) BMKGeoCodeSearch *geoCodeSearch;
//
//@property (nonatomic , strong) BMKSuggestionSearchOption *suggestionSearchOption;

@property (nonatomic , strong) NSString *province;

@property (nonatomic , strong) NSString *city;

@property (nonatomic , strong) NSString *area;

@property (nonatomic , strong) NSString *myAddress;


@property (nonatomic , strong) NSMutableArray *dataSource;

@property (nonatomic , assign) int pageIndex;

@property (nonatomic , assign) BOOL isNearby;





@end

@implementation BYDetailAddressSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    _locService.delegate = self;
    _geoCodeSearch.delegate = self;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
//    _locService.delegate = nil;
    _geoCodeSearch.delegate = nil;
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;// 控制是否显示键盘上的工具条
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        [[UITableView appearance] setEstimatedRowHeight:0];
        [[UITableView appearance] setEstimatedSectionFooterHeight:0];
        [[UITableView appearance] setEstimatedSectionHeaderHeight:0];
    }
    [self initUI];
    if (![self isLocationServiceOpen]) {
        [BYAlertTip ShowOnlyAlertWith:@"提示" message:@"请开启GPS定位权限" viewControl:self andSureBack:^{
            
        }];
    }
    [self initLocationService];
}

-(void)initLocationService{
//    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:baiduMapKey authDelegate:self];
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
    //_locationManager.allowsBackgroundLocationUpdates = YES;
    //设置位置获取超时时间
    _locationManager.locationTimeout = 10;
    //设置获取地址信息超时时间
    _locationManager.reGeocodeTimeout = 10;
    
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    [_locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (!error) {
            self.myLocation = location.location;
            [self geoCodeSearchMylocation];
            
        }else{
            
//            [BYAlertTip ShowOnlyAlertWith:@"" message:@"定位失败，请检查是否开启定位后重试！" viewControl:self andSureBack:^{
//
//            }];
            
            self.sectionView.detailAddressLabel.text = [NSString stringWithFormat:@"当前定位地址：定位解析失败"];
            self.sectionView.cityLabel.text = @"定位解析失败，请手动选择城市";
        }
//        self.province = location.rgcData.province;
//        self.city = location.rgcData.city;
//        self.area = location.rgcData.district;
//        self.sectionView.cityStr = [NSString stringWithFormat:@"%@%@%@",self.province,self.city,self.area];
//        self.myAddress = [NSString stringWithFormat:@"%@%@%@%@%@",self.province,self.city,self.area,location.rgcData.street,location.rgcData.streetNumber];
    }];
    
}

- (BOOL)isLocationServiceOpen {
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        return NO;
    } else
        return YES;
}

#pragma mark - <定位代理方法>
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    
    //    [self.mapView updateLocationData:userLocation];
//    [_locService stopUserLocationService];
//    [self geoCodeSearchMylocation];
}
- (void)didFailToLocateUserWithError:(NSError *)error;{
    
    self.sectionView.detailAddressLabel.text = [NSString stringWithFormat:@"当前定位地址：定位解析失败"];
    self.sectionView.cityLabel.text = @"定位解析失败，请手动选择城市";
}
#pragma mark - 构造逆地理编码检索参数
-(void)geoCodeSearchMylocation{
//
//
//    BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeoCodeOption.reverseGeoPoint = _locService.userLocation.location.coordinate;
//    // 是否访问最新版行政区划数据（仅对中国数据生效）
////    reverseGeoCodeOption.isLatestAdmin = YES;
//    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
//
//    if (flag) {
//        NSLog(@"逆geo检索发送成功");
//    }  else  {
//        self.sectionView.cityStr = @"定位解析失败，请手动选择城市";
//        NSLog(@"逆geo检索发送失败");
//    }
    
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeOption.location = self.myLocation.coordinate;
    // 是否访问最新版行政区划数据（仅对中国数据生效）
    reverseGeoCodeOption.isLatestAdmin = YES;
    BOOL flag = [self.geoCodeSearch reverseGeoCode: reverseGeoCodeOption];
    if (flag) {
        NSLog(@"逆geo检索发送成功");
    }  else  {
        self.sectionView.detailAddressLabel.text = [NSString stringWithFormat:@"当前定位地址：定位解析失败"];
        self.sectionView.cityLabel.text = @"定位解析失败，请手动选择城市";
//        self.sectionView.cityStr = @"定位解析失败，请手动选择城市";
        NSLog(@"逆geo检索发送失败");
    }
}

/**
 反向地理编码检索结果回调
 
 @param searcher 检索对象
 @param result 反向地理编码检索结果
 @param error 错误码，@see BMKCloudErrorCode
 */

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
//        在此处理正常结果
        self.province = result.addressDetail.province;
        self.city = result.addressDetail.city;
        self.area = result.addressDetail.district;
        self.myAddress = result.address;
        self.sectionView.detailAddressLabel.text = [NSString stringWithFormat:@"当前定位地址：%@",result.address];
        self.sectionView.cityLabel.text = [NSString stringWithFormat:@"%@%@%@",self.province,self.city,self.area];
        self.poiSearchOption.keyword = @"小区";
        self.isNearby = YES;
        [self startSearch];
//        [self.dataSource insertObject:self.myAddress atIndex:0];
    }
    else {
        self.sectionView.detailAddressLabel.text = [NSString stringWithFormat:@"当前定位地址：定位解析失败"];
        self.sectionView.cityLabel.text = @"定位解析失败，请手动选择城市";
//        self.sectionView.cityStr = @"定位解析失败，请手动选择城市";
        self.myAddress = @"定位解析失败";
        NSLog(@"检索失败");
    }
    [self.tableView reloadData];

}

//-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
//    if (error == BMK_SEARCH_NO_ERROR) {
//        在此处理正常结果
//        self.province = result.addressDetail.province;
//        self.city = result.addressDetail.city;
//        self.area = result.addressDetail.district;
//        self.sectionView.cityStr = [NSString stringWithFormat:@"%@%@%@",self.province,self.city,self.area];
//        self.myAddress = result.address;
//        [self.dataSource insertObject:self.myAddress atIndex:0];
//    }
//    else {
//        self.sectionView.cityStr = @"定位解析失败，请手动选择城市";
//        self.myAddress = @"定位解析失败";
//        NSLog(@"检索失败");
//    }
//    [self.tableView reloadData];
//
//}

-(void)startSearch{
    self.pageIndex = 0;
    [self requestMore];
    
}

-(void)requestMore{
    if (self.city.length <= 0) {
        [BYAlertTip ShowOnlySureAlertWith:nil message:@"定位失败，请先选择省市区" sureTitle:@"确定" viewControl:self andSureBack:^{
            
        }];
        return;
    }
    
    if (self.isNearby) {
        //初始化请求参数类BMKNearbySearchOption的实例
//        BMKPOINearbySearchOption *nearbyOption = [[BMKPOINearbySearchOption alloc] init];
        //检索关键字，必选
        self.poiNearbySearchOption.keywords = @[@"小区"];
        //检索中心点的经纬度，必选
        self.poiNearbySearchOption.location = self.myLocation.coordinate;
        //检索半径，单位是米。
        self.poiNearbySearchOption.radius = 1500;
        //检索分类，可选。
//        nearbyOption.tags = @[@"美食"];
        //是否严格限定召回结果在设置检索半径范围内。默认值为false。
//        self.poiNearbySearchOption.isRadiusLimit = NO;
        //POI检索结果详细程度
        //nearbyOption.scope = BMK_POI_SCOPE_BASIC_INFORMATION;
        //检索过滤条件，scope字段为BMK_POI_SCOPE_DETAIL_INFORMATION时，filter字段才有效
        //nearbyOption.filter = filter;
        //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
        self.poiNearbySearchOption.scope = BMK_POI_SCOPE_DETAIL_INFORMATION;
        self.poiNearbySearchOption.pageIndex = self.pageIndex;
        //单次召回POI数量，默认为10条记录，最大返回20条。
        self.poiNearbySearchOption.pageSize = 20;
        
        BOOL flag = [self.poiSearch poiSearchNearBy:self.poiNearbySearchOption];
        if (flag) {
            NSLog(@"POI周边检索成功");
        } else {
            NSLog(@"POI周边检索失败");
        }
    }else{
        //区域名称(市或区的名字，如北京市，海淀区)，最长不超过25个字符，必选
        self.poiSearchOption.city = [NSString stringWithFormat:@"%@",self.city];
        ///是否请求门址信息列表，默认为YES
        //    self.poiSearchOption.requestPoiAddressInfoList = YES;
        //分页页码，默认为0，0代表第一页，1代表第二页，以此类推
        self.poiSearchOption.pageIndex = self.pageIndex;
        //单次召回POI数量，默认为10条记录，最大返回20条
        self.poiSearchOption.pageSize = 20;
        self.poiSearchOption.scope = BMK_POI_SCOPE_DETAIL_INFORMATION;
        BOOL flag = [self.poiSearch poiSearchInCity:self.poiSearchOption];
        if(flag) {
            NSLog(@"POI城市内检索成功");
        } else {
            NSLog(@"POI城市内检索失败");
        }
    }
    
    
    
}

#pragma mark - BMKPoiSearchDelegate
/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误码，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPOISearchResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{
//-(void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult *)poiResult errorCode:(BMKSearchErrorCode)errorCode{

    if (errorCode == BMK_OPEN_NO_ERROR) {
        
        if (self.pageIndex == 0) {
            [self.dataSource removeAllObjects];
        }
        
        self.pageIndex ++;
        //在此处理正常结果
        NSLog(@"检索结果返回成功：%@",poiResult.poiInfoList);
        [self.tableView.mj_footer endRefreshing];

        if (poiResult.poiInfoList.count < 20) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        [self.dataSource addObjectsFromArray:poiResult.poiInfoList];
        
        [self.tableView reloadData];
        
    }
    else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
        NSLog(@"检索词有歧义");
    } else {
        NSLog(@"其他检索结果错误码相关处理");
    }
}


-(void)initUI{
    [self.navigationView setTitle:@"选择详细地址"];
    self.myAddress = @"定位中";
    [self.view addSubview:self.tableView];
    BYRegisterCell(BYDetailAddressSearchCell);
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
//        make.top.mas_equalTo(SafeAreaTopHeight);
//    }];
    
    self.tableView.tableHeaderView = self.searchHeadView;
    [self.searchHeadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(BYSCREEN_W, 64));

    }];
    BYWeakSelf;
    [self.searchHeadView setSearchBlock:^(NSString * _Nonnull searchStr) {
        weakSelf.poiSearchOption.keyword = searchStr;
        weakSelf.isNearby = NO;
        [weakSelf startSearch];
        [weakSelf.view endEditing:YES];
    }];
    
    [self.searchHeadView setInputIngSearchBlock:^(NSString * _Nonnull searchStr) {
        
        weakSelf.poiSearchOption.keyword = searchStr;
        weakSelf.isNearby = NO;
        [weakSelf startSearch];

    }];
    
    [self.sectionView setChangeCityBlock:^{
        //        选择省市区
        BYChoiceServerAdressViewController *cityVC = [[BYChoiceServerAdressViewController alloc] init];
//        cityVC.isServiceArea = NO;
        [cityVC setChoiceServerAdressBlock:^(NSDictionary * _Nonnull dict) {
            weakSelf.province = [dict valueForKey:@"pName"];
            weakSelf.city = [dict valueForKey:@"cityName"];
            weakSelf.area = [dict valueForKey:@"areaName"];
            weakSelf.sectionView.cityLabel.text = [NSString stringWithFormat:@"%@%@%@",weakSelf.province,weakSelf.city,weakSelf.area];
        }];
        [weakSelf.navigationController pushViewController:cityVC animated:YES];
    }];
    
    self.tableView.mj_footer.hidden = YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYDetailAddressSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYDetailAddressSearchCell" forIndexPath:indexPath];
//    if (indexPath.row == 0) {
//        cell.titleLabel.text = @"定位位置";
//        cell.addressLabel.text = self.myAddress;
//        cell.locationImgView.hidden = NO;
//        cell.leftconstraintW.constant = 27;
//    }else{
        BMKPoiInfo *info = self.dataSource[indexPath.row];
        cell.titleLabel.text = info.name;
        cell.addressLabel.text = info.address;
        cell.locationImgView.hidden = YES;
        cell.leftconstraintW.constant = 12;
//    }
    return cell;
 
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        if ([self.myAddress isEqualToString: @"定位解析失败"] || [self.myAddress isEqualToString:@"定位中"]) {
//
//        }else{
//            NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
//            [infoDic setValue:self.myAddress forKey:@"detailAddress"];
//            [infoDic setValue:@(self.myLocation.coordinate.latitude) forKey:@"latitude"];
//            [infoDic setValue:@(self.myLocation.coordinate.longitude) forKey:@"longitude"];
//            [infoDic setValue:self.province forKey:@"province"];
//            [infoDic setValue:self.city forKey:@"city"];
//            [infoDic setValue:self.area forKey:@"area"];
//            if (self.detailAddressBlock) {
//                self.detailAddressBlock(infoDic);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }else{
        BMKPoiInfo *info = self.dataSource[indexPath.row];
        NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
        [infoDic setValue:info.address forKey:@"detailAddress"];
        [infoDic setValue:@(info.pt.latitude) forKey:@"latitude"];
        [infoDic setValue:@(info.pt.longitude) forKey:@"longitude"];
        [infoDic setValue:self.province forKey:@"province"];
        [infoDic setValue:self.city forKey:@"city"];
        [infoDic setValue:self.area forKey:@"area"];
        if (self.detailAddressBlock) {
            self.detailAddressBlock(infoDic);
        }
        [self.navigationController popViewControllerAnimated:YES];
//    }
    
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BYWeakSelf;
    [self.sectionView setSelectAddressBlock:^{
        if ([self.myAddress isEqualToString: @"定位解析失败"] || [self.myAddress isEqualToString:@"定位中"]) {
            
        }else{
            NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
            [infoDic setValue:weakSelf.myAddress forKey:@"detailAddress"];
            [infoDic setValue:@(weakSelf.myLocation.coordinate.latitude) forKey:@"latitude"];
            [infoDic setValue:@(weakSelf.myLocation.coordinate.longitude) forKey:@"longitude"];
            [infoDic setValue:weakSelf.province forKey:@"province"];
            [infoDic setValue:weakSelf.city forKey:@"city"];
            [infoDic setValue:weakSelf.area forKey:@"area"];
            if (weakSelf.detailAddressBlock) {
                weakSelf.detailAddressBlock(infoDic);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    return self.sectionView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 80;
}




#pragma mark - setter/getter
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 8)];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 60)];
        
        BYWeakSelf;
//        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
////            [weakSelf requestData];
//        }];
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//
            [weakSelf requestMore];

        }];
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

-(BYDetailSearchHeadView *)searchHeadView{
    if (!_searchHeadView) {
        _searchHeadView = [BYDetailSearchHeadView by_viewFromXib];
        _searchHeadView.by_x = 0;
        _searchHeadView.by_y = 0;
        _searchHeadView.by_height = 64;
        _searchHeadView.by_width = BYSCREEN_W;
//        _searchHeadView.searchTextField.placeholder = @"请输入车牌号/车架号查询";
        
    }
    return _searchHeadView;
}
-(BYDetailAddressSearchSectionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [BYDetailAddressSearchSectionView by_viewFromXib];
        _sectionView.by_x = 0;
        _sectionView.by_y = 0;
        _sectionView.by_width = BYSCREEN_W;
        _sectionView.by_height = 80;
        
    }
    return _sectionView;
}

-(BMKPoiSearch *)poiSearch{
    if (!_poiSearch) {
        _poiSearch = [[BMKPoiSearch alloc] init];
        _poiSearch.delegate = self;
    }
    return _poiSearch;
}


-(BMKPOICitySearchOption *)poiSearchOption{
    if (!_poiSearchOption) {
        _poiSearchOption = [[BMKPOICitySearchOption alloc] init];
    }
    return _poiSearchOption;
}

-(BMKPOINearbySearchOption *)poiNearbySearchOption{
    
    if (!_poiNearbySearchOption) {
        _poiNearbySearchOption = [[BMKPOINearbySearchOption alloc] init];
    }
    return _poiNearbySearchOption;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


@end

