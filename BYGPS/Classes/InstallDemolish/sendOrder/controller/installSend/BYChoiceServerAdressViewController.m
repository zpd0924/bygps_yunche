//
//  BYChoiceServerAdressViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYChoiceServerAdressViewController.h"
#import "EasyNavigation.h"
#import "BYChoiceServerAdressCell.h"
#import <Masonry.h>
#import "BYChoiceServerAdressModel.h"
#import "BYChoiceServerAdressCityModel.h"
#import "BYChoiceServerAdressAreaModel.h"
#import "BYChoiceServerAdressHeadView.h"

@interface BYChoiceServerAdressViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource1;
@property (nonatomic,strong) NSMutableArray *dataSource2;
@property (nonatomic,strong) NSMutableArray *dataSource3;
@property (nonatomic,weak) BYChoiceServerAdressHeadView *headView;
@property (nonatomic,assign) NSInteger index;

@property (nonatomic,strong) NSString *pId;
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *areaId;
@property (nonatomic,strong) NSString *pName;
@property (nonatomic,strong) NSString *cityName;
@property (nonatomic,strong) NSString *areaName;
@property (nonatomic,strong) NSString *currentFirstCode;
@end

@implementation BYChoiceServerAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
    [self getProvinceList];
    self.index = 0;
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBase{
    [self.navigationView setTitle:@"服务地区"];
    self.automaticallyAdjustsScrollViewInsets = NO;
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
    [self.view addSubview:self.tableView];
    _headView = [BYChoiceServerAdressHeadView by_viewFromXib];
    _headView.provinceBlock = ^{
        weakSelf.index = 0;
        [weakSelf.tableView reloadData];
    };
    _headView.cityBlock = ^{
        weakSelf.index = 1;
        [weakSelf.tableView reloadData];
    };
    _headView.areaBlock = ^{
       weakSelf.index = 2;
        [weakSelf.tableView reloadData];
    };
    _headView.provinceLine.hidden = NO;
    _headView.cityLine.hidden = YES;
    _headView.areaLine.hidden = YES;
    
    _headView.provinceBtn.selected = YES;
    _headView.provinceBtn.hidden = NO;
    _headView.cityBtn.hidden = YES;
    _headView.areaBtn.hidden = YES;
    self.tableView.tableHeaderView = _headView;
    
}

#pragma mark -- 获取省
- (void)getProvinceList{
    if (self.dataSource1.count)
        return;
    BYWeakSelf;
    [BYSendWorkHttpTool POSTGetProvinceParams:nil success:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dataSource1 = [[NSArray yy_modelArrayWithClass:[BYChoiceServerAdressModel class] json:data] mutableCopy];
            [weakSelf getFirstCode:weakSelf.dataSource1];
            [weakSelf.tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 获取市
- (void)getCityList:(NSString *)province{
    
    [self.dataSource2 removeAllObjects];
        BYWeakSelf;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"pId"] = province;
        [BYSendWorkHttpTool POSTGetCityParams:dict success:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.dataSource2 = [[NSArray yy_modelArrayWithClass:[BYChoiceServerAdressCityModel class] json:data] mutableCopy];
                [weakSelf getFirstCode:weakSelf.dataSource2];
                [weakSelf.tableView reloadData];
            });
            
        } failure:^(NSError *error) {
            
        }];
    
    
   
}
#pragma mark -- 获取区
- (void)getAreaList:(NSString *)city{
   
    [self.dataSource3 removeAllObjects];
        BYWeakSelf;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[@"cid"] = city;
        [BYSendWorkHttpTool POSTGetAreaParams:dict success:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.dataSource3 = [[NSArray yy_modelArrayWithClass:[BYChoiceServerAdressAreaModel class] json:data] mutableCopy];
                [weakSelf getFirstCode:weakSelf.dataSource3];
                [weakSelf.tableView reloadData];
            });
            
        } failure:^(NSError *error) {
            
        }];
    
   
}

#pragma Mark -- 获取首字母并大写
- (void)getFirstCode:(NSMutableArray *)arr{
    self.currentFirstCode = nil;
    if (arr == self.dataSource1) {
        for (BYChoiceServerAdressModel *model in arr) {
            NSString *titlStr = nil;
            if (model.pName.length) {
                titlStr = [BYObjectTool changeToPinYin:model.pName.mutableCopy];
            }
            NSString* first = [titlStr.length>0?titlStr:@" " substringToIndex:1];
            NSString* sectionTtile = [first uppercaseString];
            model.firstCode = sectionTtile;
           
        }
        //排列
      self.dataSource1 = [[self.dataSource1 sortedArrayUsingComparator:^NSComparisonResult(BYChoiceServerAdressModel *obj1, BYChoiceServerAdressModel *obj2) {
            
            return [obj1.firstCode compare:obj2.firstCode];
            
        }] mutableCopy];
        for (BYChoiceServerAdressModel *model in self.dataSource1) {
            if ([_currentFirstCode isEqualToString:model.firstCode]) {
                model.isHidden = YES;
            }else{
                model.isHidden = NO;
            }
            self.currentFirstCode = model.firstCode;
        }

    }else if(arr == self.dataSource2){
        for (BYChoiceServerAdressCityModel *model in arr) {
            NSString *titlStr = nil;
           
            if (model.cityName.length) {
                titlStr = [BYObjectTool changeToPinYin:model.cityName.mutableCopy];
           
            NSString* first = [titlStr.length>0?titlStr:@" " substringToIndex:1];
            NSString* sectionTtile = [first uppercaseString];
            model.firstCode = sectionTtile;
           
        }
            //排列
            self.dataSource2 = [[self.dataSource2 sortedArrayUsingComparator:^NSComparisonResult(BYChoiceServerAdressModel *obj1, BYChoiceServerAdressModel *obj2) {
                
                return [obj1.firstCode compare:obj2.firstCode];
                
            }] mutableCopy];
            for (BYChoiceServerAdressCityModel *model in self.dataSource2) {
                if ([_currentFirstCode isEqualToString:model.firstCode]) {
                    model.isHidden = YES;
                }else{
                    model.isHidden = NO;
                }
                self.currentFirstCode = model.firstCode;
            }
    }
    }else{
        for (BYChoiceServerAdressAreaModel *model in arr) {
            NSString *titlStr = nil;
            if (model.areaName.length) {
                titlStr = [BYObjectTool changeToPinYin:model.areaName.mutableCopy];
            }
            NSString* first = [titlStr.length>0?titlStr:@" " substringToIndex:1];
            NSString* sectionTtile = [first uppercaseString];
            model.firstCode = sectionTtile;
            
        }
        //排列
        self.dataSource3 = [[self.dataSource3 sortedArrayUsingComparator:^NSComparisonResult(BYChoiceServerAdressModel *obj1, BYChoiceServerAdressModel *obj2) {
            
            return [obj1.firstCode compare:obj2.firstCode];
            
        }] mutableCopy];
        for (BYChoiceServerAdressAreaModel *model in self.dataSource3) {
            if ([_currentFirstCode isEqualToString:model.firstCode]) {
                model.isHidden = YES;
            }else{
                model.isHidden = NO;
            }
            self.currentFirstCode = model.firstCode;
        }
    }
   
   
}

#pragma mark -- tableview 数据源 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_index) {
        case 0:
            return self.dataSource1.count;
            break;
        case 1:
            return self.dataSource2.count;
            break;
        default:
             return self.dataSource3.count;
            break;
    }
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BYWeakSelf;
    BYChoiceServerAdressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYChoiceServerAdressCell" forIndexPath:indexPath];
    switch (_index) {
        case 0:
            cell.model1 = self.dataSource1[indexPath.row];
            break;
        case 1:
            cell.model2 = self.dataSource2[indexPath.row];
            break;
        default:
            cell.model3 = self.dataSource3[indexPath.row];
            break;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  
    
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    switch (_index) {
        case 0:
        {
            BYChoiceServerAdressModel *model1 = _dataSource1[indexPath.row];
            _pId = model1.pid;
            _pName = model1.pName;
            _headView.model = model1;
            [self getCityList:model1.pid];
            _index = 1;
            _headView.index = _index;
            [self.tableView reloadData];
        }
            
            break;
        case 1:
        {
            BYChoiceServerAdressCityModel *model2 = _dataSource2[indexPath.row];
            _cityId = model2.cityId;
            _cityName = model2.cityName;
            _headView.model1 = model2;
            [self getAreaList:model2.cityId];
            _index = 2;
             _headView.index = _index;
            [self.tableView reloadData];
        }
            
            break;
        default:
        {
            BYChoiceServerAdressAreaModel *model3 = _dataSource3[indexPath.row];
            _areaId = model3.areaId;
            _areaName = model3.areaName;
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"pid"] = _pId;
            dict[@"pName"] = _pName;
            dict[@"cityId"] = _cityId;
            dict[@"cityName"] = _cityName;
            dict[@"areaId"] = _areaId;
            dict[@"areaName"] = _areaName;
            if (self.choiceServerAdressBlock) {
                self.choiceServerAdressBlock(dict);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = WHITE;

    UILabel *label = [UILabel verLab:15 textRgbColor:UIColorHexFromRGB(0x9d9d9d) textAlighment:NSTextAlignmentLeft];
    
    [view addSubview:label];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(view);
        make.left.mas_equalTo(12);
    }];
    switch (_index) {
        case 0:
            label.text = @"选择省";
            break;
        case 1:
            label.text = @"选择市";
            break;
        default:
            label.text = @"选择区";
            break;
            break;
    }
    
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
}

#pragma mark -- lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = BYBackViewColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        BYRegisterCell(BYChoiceServerAdressCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}
-(NSMutableArray *)dataSource1
{
    if (!_dataSource1) {
        _dataSource1 = [NSMutableArray array];
    }
    return _dataSource1;
}
-(NSMutableArray *)dataSource2
{
    if (!_dataSource2) {
        _dataSource2 = [NSMutableArray array];
    }
    return _dataSource2;
}
-(NSMutableArray *)dataSource3
{
    if (!_dataSource3) {
        _dataSource3 = [NSMutableArray array];
    }
    return _dataSource3;
}


@end
