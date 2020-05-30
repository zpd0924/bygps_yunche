//
//  BYCityListViewController.m
//  carLoanManagerment
//
//  Created by ZPD on 2017/3/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BYCityListViewController.h"
#import "BYCityModel.h"
#import "BYHotCityCell.h"
//#import "BYOrderListHttpTool.h"
#import "EasyNavigation.h"
#import "BYCityDatabase.h"
#import "BYCurrentCityView.h"
#import "BYLocationManager.h"

@interface BYCityListViewController () <UITableViewDelegate,UITableViewDataSource,BYLocationManagerDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataSource;//总数组
@property (nonatomic,strong) NSArray * titleArr;
@property (nonatomic,strong) NSMutableArray * titleSource;//段头和检索数组
@property (nonatomic,strong) NSMutableArray *cityArr;

@property (nonatomic,strong) NSMutableArray *sectionMutArr;//段数组

@property (nonatomic,strong) BYCurrentCityView * currentCityView;
@property (nonatomic,strong) BYLocationManager *locationManager;//定位类

@end

@implementation BYCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBase];
    
    [self getCitys];
    
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initBase{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationView setTitle:@"选择城市"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    BYWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
        [weakSelf.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
        [weakSelf.navigationView removeAllLeftButton];
        [weakSelf.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
            [weakSelf backAction];
        }];
        
    });
    
    
    BYRegisterCell(BYHotCityCell);
    
    [self.view addSubview:self.tableView];
//    self.tableView.contentInset = UIEdgeInsetsMake(BYS_W_H(44), 0, 0, 0);
    
    self.currentCityView = [BYCurrentCityView by_viewFromXib];
    self.currentCityView.frame = CGRectMake(0, BYNavBarMaxH, BYSCREEN_W, BYS_W_H(44));
    self.tableView.tableHeaderView = self.currentCityView;
    //如果当前城市为空,则取定位城市
    NSString * currentCity = [BYSaveTool valueForKey:BYCurrentCityKey];
    if (currentCity.length) {
        self.currentCityView.title = currentCity;
    }else{
        NSString * locationCity = [BYSaveTool valueForKey:BYLocationCityKey];
        if (locationCity.length) {
            if ([locationCity isEqualToString:@"定位失败"] || [locationCity isEqualToString:@"无法定位"]) {
               self.currentCityView.title = @"请选择城市";
            }else{
                self.currentCityView.title = locationCity;
                [BYSaveTool setValue:locationCity forKey:BYCurrentCityKey];
            }
        }else{
            self.currentCityView.title = @"请选择城市";
        }
    }
   
    
    //定位初始化
    _locationManager = [[BYLocationManager alloc] init];
    _locationManager.delegate = self;
    
}

-(void)getCitys{
    
    self.titleSource = [NSKeyedUnarchiver unarchiveObjectWithData:[BYSaveTool objectForKey:@"titleData"]];
    
    if (self.titleSource.count) {
        
        for (NSString * initial in self.titleSource) {
            
            [self.dataSource addObject:[[BYCityDatabase shareInstance] queryCitysWith:initial]];
        }
        
        //插入热门和定位城市
//        [self.titleSource insertObject:@"热门城市" atIndex:0];
        [self.titleSource insertObject:@"定位城市" atIndex:0];

//        [self.dataSource insertObject:self.hotCitys atIndex:0];
        NSString * locationCity = [BYSaveTool valueForKey:BYLocationCityKey];
        [self.dataSource insertObject:@[locationCity.length ? locationCity : @"定位中..."] atIndex:0];
        
    }else{
        
        [self loadData];
    }
}

-(void)loadData{
    
//    [BYOrderListHttpTool POSTCityWithSuccess:^(id dataArr) {
//        self.cityArr = dataArr;
//        [BYProgressHUD showWithStatus:@"首次获取城市列表，请稍等"];
//        [self processData:^(id success) {
//            [BYProgressHUD dismiss];
//            [self.titleSource insertObject:@"定位城市" atIndex:0];
//            NSString * locationCityStr = [BYSaveTool valueForKey:BYLocationCityKey];
//            [self.dataSource insertObject:@[locationCityStr.length ? locationCityStr : @"定位中..."] atIndex:0];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
//        }];
//
//    }];
}

/// 汉字转拼音再转成汉字
-(void)processData:(void (^) (id))success {
    for (int i = 0; i < self.cityArr.count; i ++) {
        BYCityModel *cityModel = self.cityArr[i];
        NSString *str = cityModel.pinyin; //一开始的内容
        if (str.length) {  //下面那2个转换的方法一个都不能少
            NSMutableString *ms = [[NSMutableString alloc] initWithString:str];
            //汉字转拼音
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            }
            //拼音转英文
            if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
                //字符串截取第一位，并转换成大写字母
                NSString *firstStr = [[ms.length>0?ms:@" " substringToIndex:1] uppercaseString];
                //如果不是字母开头的，转为＃
                BOOL isLetter = [self matchLetter:firstStr];
                if (!isLetter)
                    firstStr = @"#";
                
                
                cityModel.initial = firstStr;
                //将城市数据插入到数据库
                [[BYCityDatabase shareInstance] insertCity:cityModel];
                
                //如果还没有索引
                if (self.titleSource.count <= 0) {
                    //保存当前这个做索引
                    [self.titleSource addObject:firstStr];
                }else{
                    //如果索引里面包含了当前这个字母，直接保存数据
                    if (![self.titleSource containsObject:firstStr]) {
                        [self.titleSource addObject:firstStr];
                    }
                }
            }
        }
    }
    
    //将字母排序
    NSArray *compareArray = [self.titleSource sortedArrayUsingSelector:@selector(compare:)];
    self.titleSource = [NSMutableArray arrayWithArray:compareArray];
    
    //判断第一个是不是字母，如果不是放到最后一个
    BOOL isLetter = [self matchLetter:self.titleSource[0]];
    if (!isLetter) {
        //获取数组的第一个元素
        NSString *firstStr = [self.titleSource firstObject];
        //移除第一项元素
        [self.titleSource removeObjectAtIndex:0];
        //插入到最后一个位置
        [self.titleSource insertObject:firstStr atIndex:self.titleSource.count];
    }
    
    //将字母数组存入沙盒
    NSData *titlesData = [NSKeyedArchiver archivedDataWithRootObject:self.titleSource];
    [BYSaveTool setObject:titlesData forKey:@"titleData"];
    
    for (NSString * str in self.titleSource) {
        NSMutableArray *sectionArr = [NSMutableArray array];
        for (BYCityModel * cityModel in self.cityArr) {
            
            if ([cityModel.initial isEqualToString:str]) {
                
                //将城市数据插入到数据库
                [[BYCityDatabase shareInstance] insertCity:cityModel];
                
                [sectionArr addObject:cityModel];
            }
        }
        
        [self.dataSource addObject:sectionArr];
    }
    success(@"成功");
}

#pragma mark - 匹配是不是字母开头
- (BOOL)matchLetter:(NSString *)str {
    //判断是否以字母开头
    NSString *ZIMU = @"^[A-Za-z]+$";
    NSPredicate *regextestA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ZIMU];
    
    if ([regextestA evaluateWithObject:str] == YES)
        return YES;
    else
        return NO;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * tempArr = self.dataSource[indexPath.section];

    if (indexPath.section == 0) {
        BYHotCityCell * cell = [tableView dequeueReusableCellWithIdentifier:BYCellID(BYHotCityCell)];
        [cell setCityCallBack:^(NSString *city) {
            
            if ([city isEqualToString:@"定位失败"] || [city isEqualToString:@"无法定位"]||[city isEqualToString:@"定位中..."]) {
                return;
            }
            
            if (self.cityCallBack) {
                self.cityCallBack(city);
            }self.currentCityView.title = city;
            [BYSaveTool setValue:city forKey:BYCurrentCityKey];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        cell.cityArr = tempArr;
        return cell;
    }else{
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = BYS_T_F(15);
        }
        
        BYCityModel * city = tempArr[indexPath.row];
        cell.textLabel.text = city.shortName;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 0) {
        
        NSArray * tempArr = self.dataSource[indexPath.section];
        BYCityModel * model = tempArr[indexPath.row];
        if (self.cityCallBack) {
            self.cityCallBack(model.shortName);
        }
        
        [BYSaveTool setValue:model.shortName forKey:BYCurrentCityKey];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleSource[section];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    
    UITableViewHeaderFooterView * header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = BYGlobalBg;
    header.textLabel.textColor = BYGrayColor(90);
    header.textLabel.font = BYS_T_F(14);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BYS_W_H(30);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40 + BYS_W_H(35);
    }else{
        return BYS_W_H(44);
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    NSMutableArray * tempArr = [[NSMutableArray alloc] init];
    
    if (self.titleSource.count) {
        
        [tempArr addObjectsFromArray:self.titleSource];
        [tempArr replaceObjectAtIndex:0 withObject:@"定位"];
    }
    return tempArr;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0) {
        return 1;
    }else{
        NSArray * tempArr = self.dataSource[section];
        return tempArr.count;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleSource.count;
}

-(void)closeAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <BYLocationManagerDelegate>
//定位中
-(void)locating{}
//定位成功
- (void)currentLocation:(NSDictionary *)locationDictionary{
    BYLog(@"locationDictionary : %@",locationDictionary);
    
    if (locationDictionary[@"City"]) {
        NSString * city = locationDictionary[@"City"];
        if ([city rangeOfString:@"市"].location != NSNotFound) {
            city = [city substringToIndex:city.length - 1];
        }
        [BYSaveTool setValue:city forKey:BYLocationCityKey];
        
        if (self.dataSource.count > 0) {
            
            self.dataSource[0] = @[city];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
}
//用户拒绝定位
- (void)refuseToUsePositioningSystem:(NSString *)message{
    
//    [BYSaveTool setValue:@"无法定位" forKey:BYLocationCityKey];
    
    if (self.dataSource.count > 0) {
        
        self.dataSource[0] = @[@"无法定位"];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}
//定位失败
- (void)locateFailure:(NSString *)message{

    [BYSaveTool setValue:@"定位失败" forKey:BYLocationCityKey];
    
    if (self.dataSource.count > 0) {
        
        self.dataSource[0] = @[@"定位失败"];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

-(NSMutableArray *)titleSource{
    if (_titleSource == nil) {
        _titleSource = [NSMutableArray array];
    }
    return _titleSource;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
         _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.sectionIndexColor = BYGrayColor(76);
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

-(NSMutableArray *)cityArr{
    if (!_cityArr) {
        _cityArr = [NSMutableArray array];
    }
    return _cityArr;
}

-(NSMutableArray *)sectionMutArr
{
    if (!_sectionMutArr) {
        _sectionMutArr = [NSMutableArray array];
    }
    return _sectionMutArr;
}


@end
