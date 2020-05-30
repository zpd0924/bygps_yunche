//
//  BYCarTypeViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/26.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYCarTypeViewController.h"
#import "EasyNavigation.h"
#import "BYCarTypeViewBrandCell.h"
#import "BYCarTypeViewModelCell.h"
#import "BYCarTypeBrandModel.h"
#import "BYCarTypeSetModel.h"
#import "BYCarTypeInfoModel.h"
#import "UIButton+HNVerBut.h"
@interface BYCarTypeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView0;
@property (nonatomic,strong) UITableView *tableView1;
@property (nonatomic,strong) UITableView *tableView2;
@property (nonatomic,strong) UIView *countView1;
@property (nonatomic,strong) UIView *countView2;
@property(nonatomic ,strong)NSMutableArray *dataArray; //!<数据源
@property(nonatomic ,strong)NSMutableArray *indexArray; //!<索引数组
@property(nonatomic ,strong)NSMutableDictionary *dataDict; //!<可变字典
@property(nonatomic ,strong)NSMutableArray *dataArray1; //!<数据源
@property(nonatomic ,strong)NSMutableArray *indexArray1; //!<索引数组
@property(nonatomic ,strong)NSMutableDictionary *dataDict1; //!<可变字典
@property(nonatomic ,strong)NSMutableArray *dataArray2; //!<数据源
@property(nonatomic ,strong)NSMutableArray *indexArray2; //!<索引数组
@property(nonatomic ,strong)NSMutableDictionary *dataDict2; //!<可变字典
@property (nonatomic,strong) BYCarTypeBrandModel *model;
@property (nonatomic,strong) NSString *selectSet;///选中车系
@end

@implementation BYCarTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self initBase];
    [self getCarBrandList];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)initBase{
    [self.navigationView setTitle:@"选择车型"];
    self.view.backgroundColor = BYBigSpaceColor;
    BYWeakSelf;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        [self.navigationView removeAllLeftButton];
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//        
//    });
    [self.view addSubview:self.tableView0];
    [self.view addSubview:self.countView1];
    [self.view addSubview:self.countView2];
   
}
#pragma mark -- tableview1收起
- (void)countview1BtnClick{
    [UIView animateWithDuration:0.25 animations:^{
        self.countView1.transform =CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.countView2.transform =CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark -- tableview2收起
- (void)countview2BtnClick{
    [UIView animateWithDuration:0.25 animations:^{
        self.countView2.transform =CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark --滑动消失
- (void)countView2Swip{
    [UIView animateWithDuration:0.25 animations:^{
        self.countView2.transform =CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
- (void)countView1Swip{
    [UIView animateWithDuration:0.25 animations:^{
        self.countView1.transform =CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.countView2.transform =CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark -- 请求品牌
- (void)getCarBrandList{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"token"] = @"8862c50471b1bacfa4ab2d0f335f1956";
    [BYSendWorkHttpTool POSTCarBrandParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dataArray = [[NSArray yy_modelArrayWithClass:[BYCarTypeBrandModel class] json:data] mutableCopy];
            BYCarTypeBrandModel *otherModel = [[BYCarTypeBrandModel alloc] init];
            otherModel.brand_id = 0;
            otherModel.brand_name = @"其他";
            otherModel.initial = @"#";
            [weakSelf.dataArray insertObject:otherModel atIndex:(NSUInteger)0];
            [weakSelf sortCarBrandList:weakSelf.dataArray];
        });
       
    } failure:^(NSError *error) {
        
    }];
}
- (void)sortCarBrandList:(NSMutableArray *)arr{
    for (BYCarTypeBrandModel *model in arr) {
        
//        if (![self.indexArray containsObject:model.initial] && [BYObjectTool isInLetter:model.initial]) {
        if (![self.indexArray containsObject:model.initial]) {
            [self.indexArray addObject:model.initial];
        }
        NSArray* keyArray = [self.dataDict allKeys];
        if (![keyArray containsObject:model.initial]) {
            if ([BYObjectTool isInLetter:model.initial]) { //26个字母内
                self.dataDict[model.initial] = [NSMutableArray arrayWithObject:model];
            }else if (![keyArray containsObject:@"#"]) {
                self.dataDict[@"#"] =  [NSMutableArray arrayWithObject:model];
            }else {
                NSMutableArray* valueArray =  self.dataDict[@"#"];
                [valueArray addObject:model];
                self.dataDict[@"#"] = valueArray;
            }
            
        }else {
            if ([BYObjectTool isInLetter:model.initial]) { //26个字母内
                NSMutableArray* valueArray =  self.dataDict[model.initial];
                [valueArray addObject:model];
                self.dataDict[model.initial] = valueArray;
            }else {//如果不是26个字母则归为#
                NSMutableArray* valueArray =  self.dataDict[@"#"];
                [valueArray addObject:model];
                self.dataDict[@"#"] = valueArray;
            }
        }
    }
    [self.tableView0 reloadData];
}
#pragma mark -- 请求车系
- (void)getCarSetList:(NSString *)brandId{
    BYWeakSelf;
    [self.dataArray1 removeAllObjects];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"token"] = @"8862c50471b1bacfa4ab2d0f335f1956";
    dict[@"brandid"] = @([brandId integerValue]);
    [UIView animateWithDuration:0.25 animations:^{
        self.countView1.transform =CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
       
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.countView2.transform =CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    if ([brandId integerValue] == 0) {
        if (self.carTypeViewBlock) {
            self.carTypeViewBlock(_model.brand_name,@"",@"");
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [BYSendWorkHttpTool POSTCarSetParams:dict success:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.dataArray1 = [[NSArray yy_modelArrayWithClass:[BYCarTypeSetModel class] json:data] mutableCopy];
                BYCarTypeSetModel *otherCarTypeModel = [[BYCarTypeSetModel alloc] init];
                otherCarTypeModel.series_id = @"0";
                otherCarTypeModel.series_name = @"其他";
                otherCarTypeModel.series_group_name = @"其他";
                [weakSelf.dataArray1 insertObject:otherCarTypeModel atIndex:0];
                [weakSelf sortCarSetList:weakSelf.dataArray1];
            });
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}
- (void)sortCarSetList:(NSMutableArray *)arr{
    [self.indexArray1 removeAllObjects];
    [self.dataDict1 removeAllObjects];
    for (BYCarTypeSetModel *model in arr) {
        
        if (![self.indexArray1 containsObject:model.series_group_name]) {
            [self.indexArray1 addObject:model.series_group_name];
        }
        NSArray* keyArray = [self.dataDict1 allKeys];
        if (![keyArray containsObject:model.series_group_name]) {
        
                self.dataDict1[model.series_group_name] = [NSMutableArray arrayWithObject:model];
           
            
        }else {
           
                NSMutableArray* valueArray =  self.dataDict1[model.series_group_name];
                [valueArray addObject:model];
                self.dataDict1[model.series_group_name] = valueArray;
         
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.countView1.transform = CGAffineTransformMakeTranslation(-MAXWIDTH + MAXWIDTH*0.5, 0);
    }];
    [self.tableView1 reloadData];
}
#pragma mark -- 请求车详细信息
- (void)getCarInfoList:(NSString *)seriesId{
    [self.dataArray2 removeAllObjects];
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"token"] = @"8862c50471b1bacfa4ab2d0f335f1956";
    dict[@"typeId"] = @([seriesId integerValue]);
    if ([seriesId integerValue] == 0) {
        if (self.carTypeViewBlock) {
            self.carTypeViewBlock(_model.brand_name,self.selectSet,@"");
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [BYSendWorkHttpTool POSTCarInfoParams:dict success:^(id data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.dataArray2 = [[NSArray yy_modelArrayWithClass:[BYCarTypeInfoModel class] json:data] mutableCopy];
                BYCarTypeInfoModel *otherInfoModel = [[BYCarTypeInfoModel alloc] init];
                otherInfoModel.model_name = @"其他";
                otherInfoModel.model_price = @"无";
                otherInfoModel.model_year = @"无";
                [weakSelf.dataArray2 insertObject:otherInfoModel atIndex:0];
                [weakSelf sortCarInfoList:weakSelf.dataArray2];
            });
            
        } failure:^(NSError *error) {
            
        }];
    }
    
}

- (void)sortCarInfoList:(NSMutableArray *)arr{
    [self.indexArray2 removeAllObjects];
    [self.dataDict2 removeAllObjects];
    for (BYCarTypeInfoModel *model in arr) {
        
        if (![self.indexArray2 containsObject:model.model_year]) {
            [self.indexArray2 addObject:model.model_year];
        }
        NSArray* keyArray = [self.dataDict2 allKeys];
        if (![keyArray containsObject:model.model_year]) {
            
            self.dataDict2[model.model_year] = [NSMutableArray arrayWithObject:model];
            
            
        }else {
            
            NSMutableArray* valueArray =  self.dataDict2[model.model_year];
            [valueArray addObject:model];
            self.dataDict2[model.model_year] = valueArray;
            
        }
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.countView1.transform = CGAffineTransformMakeTranslation(-MAXWIDTH*0.75, 0);
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.countView2.transform = CGAffineTransformMakeTranslation(-MAXWIDTH*0.5, 0);
    }];
    [self.tableView2 reloadData];
}
#pragma mark -- tableview 数据源 代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableView0) {
        return self.indexArray.count;
    }else if (tableView == self.tableView1){
        return self.indexArray1.count;
    }else{
        return self.indexArray2.count;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView0) {
        NSString* sectionTitle = self.indexArray[section];
        NSMutableArray* araray = self.dataDict[sectionTitle];
        return araray.count;
    }else if (tableView == self.tableView1){
        NSString* sectionTitle = self.indexArray1[section];
        NSMutableArray* araray = self.dataDict1[sectionTitle];
        return araray.count;
    }else{
        NSString* sectionTitle = self.indexArray2[section];
        NSMutableArray* araray = self.dataDict2[sectionTitle];
        return araray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    if (tableView == self.tableView0) {
        NSString* sectionTitle = self.indexArray[indexPath.section];
        NSMutableArray* array = self.dataDict[sectionTitle];
        BYCarTypeViewBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYCarTypeViewBrandCell"];
        cell.model = array[indexPath.row];
        return cell;
    }else if (tableView == self.tableView1){
        NSString* sectionTitle = self.indexArray1[indexPath.section];
        NSMutableArray* array = self.dataDict1[sectionTitle];
        BYCarTypeViewModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYCarTypeViewModelCell"];
        cell.model1 = array[indexPath.row];
        return cell;
    }else{
        NSString* sectionTitle = self.indexArray2[indexPath.section];
        NSMutableArray* array = self.dataDict2[sectionTitle];
        BYCarTypeViewModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYCarTypeViewModelCell"];
        cell.model2 = array[indexPath.row];
        return cell;
    }
   
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView0) {
        NSString* sectionTitle = self.indexArray[indexPath.section];
        NSMutableArray* array = self.dataDict[sectionTitle];
        BYCarTypeBrandModel *model = array[indexPath.row];
        self.model = model;
        [self getCarSetList:model.brand_id];
    }else if (tableView == self.tableView1){
        NSString* sectionTitle = self.indexArray1[indexPath.section];
        NSMutableArray* array = self.dataDict1[sectionTitle];
        BYCarTypeSetModel *model = array[indexPath.row];
        self.selectSet = model.series_name;
        [self getCarInfoList:model.series_id];
    }else{
        NSString* sectionTitle = self.indexArray2[indexPath.section];
        NSMutableArray* array = self.dataDict2[sectionTitle];
        BYCarTypeInfoModel *model = array[indexPath.row];
        if (self.carTypeViewBlock) {
            self.carTypeViewBlock(_model.brand_name,self.selectSet,model.model_name);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tableView0) {
        return self.indexArray[section];
    }else if (tableView == self.tableView1){
        return self.indexArray1[section];
    }else{
        return self.indexArray2[section];
    }
    
    
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView0) {
        return self.indexArray;
    }else{
        return nil;
    }
    
}

//索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;}

#pragma mark -- lazy
-(UITableView *)tableView0{
    if (_tableView0 == nil) {
        _tableView0 = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView0.backgroundColor = BYBigSpaceColor;
        _tableView0.dataSource = self;
        _tableView0.delegate = self;
        _tableView0.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView0.dataSource = self;
        _tableView0.estimatedRowHeight = 80.0f;
        _tableView0.rowHeight = UITableViewAutomaticDimension;
        [_tableView0 registerNib:[UINib nibWithNibName:NSStringFromClass([BYCarTypeViewBrandCell class]) bundle:nil] forCellReuseIdentifier:@"BYCarTypeViewBrandCell"];
        if (@available(iOS 11.0, *)) {
            _tableView0.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView0;
}
-(UITableView *)tableView1{
    if (_tableView1 == nil) {
        _tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(1, 40, BYSCREEN_W - 80, BYSCREEN_H - SafeAreaTopHeight - 40) style:UITableViewStylePlain];
        _tableView1.backgroundColor = BYBackViewColor;
        _tableView1.dataSource = self;
        _tableView1.delegate = self;
        _tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView1.dataSource = self;
        _tableView1.estimatedRowHeight = 80.0f;
        _tableView1.rowHeight = UITableViewAutomaticDimension;
        [_tableView1 registerNib:[UINib nibWithNibName:NSStringFromClass([BYCarTypeViewModelCell class]) bundle:nil] forCellReuseIdentifier:@"BYCarTypeViewModelCell"];
        if (@available(iOS 11.0, *)) {
            _tableView1.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView1;
}
-(UITableView *)tableView2{
    if (_tableView2 == nil) {
        _tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(1, 40, BYSCREEN_W*0.5, BYSCREEN_H - SafeAreaTopHeight -40) style:UITableViewStylePlain];
        _tableView2.backgroundColor = BYBigSpaceColor;
        _tableView2.dataSource = self;
        _tableView2.delegate = self;
        _tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView2.dataSource = self;
        _tableView2.estimatedRowHeight = 80.0f;
        _tableView2.rowHeight = UITableViewAutomaticDimension;
        [_tableView2 registerNib:[UINib nibWithNibName:NSStringFromClass([BYCarTypeViewModelCell class]) bundle:nil] forCellReuseIdentifier:@"BYCarTypeViewModelCell"];
        if (@available(iOS 11.0, *)) {
            _tableView2.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView2;
}

- (NSMutableArray *)dataArray{
    
    if(!_dataArray){
        
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}
///索引数组
- (NSMutableArray *)indexArray {
    if (!_indexArray) {
        _indexArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _indexArray;
}

- (NSMutableDictionary *)dataDict {
    if (!_dataDict) {
        _dataDict  =[NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dataDict;
}
- (NSMutableArray *)dataArray1{
    
    if(!_dataArray1){
        
        _dataArray1 = [NSMutableArray array];
    }
    
    return _dataArray1;
}
///索引数组
- (NSMutableArray *)indexArray1 {
    if (!_indexArray1) {
        _indexArray1 = [NSMutableArray arrayWithCapacity:0];
    }
    return _indexArray1;
}

- (NSMutableDictionary *)dataDict1 {
    if (!_dataDict1) {
        _dataDict1  =[NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dataDict1;
}

- (NSMutableArray *)dataArray2{
    
    if(!_dataArray2){
        
        _dataArray2 = [NSMutableArray array];
    }
    
    return _dataArray2;
}
///索引数组
- (NSMutableArray *)indexArray2 {
    if (!_indexArray2) {
        _indexArray2 = [NSMutableArray arrayWithCapacity:0];
    }
    return _indexArray2;
}

- (NSMutableDictionary *)dataDict2 {
    if (!_dataDict2) {
        _dataDict2  =[NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _dataDict2;
}
-(UIView *)countView1
{
    if (!_countView1) {
        _countView1 = [[UIView alloc] initWithFrame:CGRectMake(MAXWIDTH, SafeAreaTopHeight, MAXWIDTH - 80, MAXHEIGHT - SafeAreaTopHeight)];
        _countView1.backgroundColor = WHITE;
        UIButton *btn = [UIButton verBut:@"收起" textFont:15 titleColor:UIColorHexFromRGB(0x333333) bkgColor:nil];
        [btn setImage:[UIImage imageNamed:@"packUp"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(countview1BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_countView1 addSubview:btn];
        btn.frame = CGRectMake(1, 0, 70, 40);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, MAXHEIGHT - SafeAreaTopHeight)];
        line.backgroundColor = UIColorHexFromRGB(0xd3d2d2);
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(countView1Swip)];
        // 轻扫方向:默认是右边
        
        [_countView1 addGestureRecognizer:swipe];
        [_countView1 addSubview:line];
        [_countView1 addSubview:self.tableView1];
        
    }
    return _countView1;
}
-(UIView *)countView2
{
    if (!_countView2) {
        _countView2 = [[UIView alloc] initWithFrame:CGRectMake(MAXWIDTH, SafeAreaTopHeight, MAXWIDTH - 80, MAXHEIGHT - SafeAreaTopHeight)];
        _countView2.backgroundColor = WHITE;
        UIButton *btn = [UIButton verBut:@"收起" textFont:15 titleColor:UIColorHexFromRGB(0x333333) bkgColor:nil];
        [btn setImage:[UIImage imageNamed:@"packUp"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(countview2BtnClick) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(1, 0, 70, 40);
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, MAXHEIGHT - SafeAreaTopHeight)];
        line.backgroundColor = UIColorHexFromRGB(0xd3d2d2);
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(countView2Swip)];
        // 轻扫方向:默认是右边
        
        [_countView2 addGestureRecognizer:swipe];
        [_countView2 addSubview:line];
        [_countView2 addSubview:btn];
        [_countView2 addSubview:self.tableView2];
    }
    return _countView2;
}

@end
