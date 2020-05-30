//
//  BYChoiceEngineerViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYChoiceEngineerViewController.h"
#import "EasyNavigation.h"
#import "BYCityListViewController.h"
#import "BYChoiceEngineerCell.h"
#import "BYNaviSearchBar.h"
#import "UIButton+HNVerBut.h"
#import "UILabel+HNVerLab.h"
#import "BYEvaluationStarView.h"
#import <Masonry.h>
#import "BYButton.h"
#import "BYLocationManager.h"



@interface BYChoiceEngineerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,BYLocationManagerDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property(nonatomic ,strong)NSMutableArray *dataArray; //!<数据源
@property(nonatomic ,strong)NSMutableArray *indexArray; //!<索引数组
@property(nonatomic ,strong)NSMutableDictionary *dataDict; //!<可变字典
@property (nonatomic,strong) UIView *searchView;
@property (nonatomic,strong) UIView *sureBtnView;
@property (nonatomic,strong) UIView *engineerView;
@property (nonatomic,strong) UIView *topHeadView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,weak) UILabel *serviceAdressLabel;
@property (nonatomic,strong) BYEvaluationStarView *evaluationStarView;


@property (nonatomic,strong) BYLocationManager *locationManager;//定位类
@property(nonatomic , assign) NSInteger currentPage;
@property(nonatomic , assign) BOOL isHeader;        //是否是下拉刷新
@property (nonatomic,weak) BYButton *cityBtn;
@property (nonatomic,strong) NSString *searchStr;//搜索字段
@property (nonatomic,strong) BYChoiceEngineerModel *model;//选择的技师模型
@property (nonatomic,weak) UILabel *starLabel;///选中技师评级
@property (nonatomic,weak) UILabel *nickName;///选中技师姓名
@end

@implementation BYChoiceEngineerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //定位初始化
//    _locationManager = [[BYLocationManager alloc] init];
//    _locationManager.delegate = self;
    [self initBase];
    [self getData:nil];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initBase{
    [self.navigationView setTitle:@"选择技师"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    BYWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
        [weakSelf.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
        [weakSelf.navigationView removeAllLeftButton];
       
        [weakSelf.navigationView addRightView:self.sureBtnView clickCallback:^(UIView *view) {
//            BYChoiceEngineerModel *model = [[BYChoiceEngineerModel alloc] init];
//            model.ID = 12;
//            model.nickName = @"xiaoli";
            if (self.choiceServerBlock) {
                self.choiceServerBlock(weakSelf.model);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        [weakSelf.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
            [weakSelf backAction];
        }];
        
    });
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.topView];
    self.serviceAdressLabel.text = [NSString stringWithFormat:@"%@ 服务技师：",_serviceAdress];
    self.tableView.tableHeaderView = self.topHeadView;
    self.topHeadView.frame = CGRectMake(0, 0, MAXWIDTH, 55);
    self.engineerView.hidden = YES;
    
}
#pragma mark -- 点击城市
//- (void)cityBtnClick:(UIButton *)btn{
//    BYWeakSelf;
//    btn.selected = !btn.selected;
//    BYCityListViewController *cityVC = [BYCityListViewController new];
//    [cityVC setCityCallBack:^(NSString *city) {
//
//    }];
//    [self.navigationController pushViewController:cityVC animated:YES];
//}

#pragma mark -- 搜索技师
- (void)getData:(NSString *)keyWord{
    BYWeakSelf;
    if (!_areaId.length) {
        BYShowError(@"该区域没有服务技师");
        return;
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"areaId"] = _areaId;
    dict[@"groupId"] = [BYSaveTool objectForKey:groupId];
    if (keyWord.length) {
        dict[@"content"] = keyWord;
    }
    [self.dataArray removeAllObjects];
    [BYSendWorkHttpTool POSTTechnicianParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.dataArray = [[NSArray yy_modelArrayWithClass:[BYChoiceEngineerModel class] json:data] mutableCopy];
            
            [weakSelf sort];
        });
       
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 排序
- (void)sort{
    [self.indexArray removeAllObjects];
    [self.dataDict removeAllObjects];
    for (BYChoiceEngineerModel* model in self.dataArray) {
        
        NSMutableString* titlStr = [NSMutableString stringWithString:model.nickName.length == 0?@" ":model.nickName];
        titlStr = [BYObjectTool changeToPinYin:titlStr];
        NSString* first = [titlStr.length>0?titlStr:@" " substringToIndex:1];
        NSString* sectionTtile = [first uppercaseString];
        if (![self.indexArray containsObject:sectionTtile] && [BYObjectTool isInLetter:sectionTtile]) {
            [self.indexArray addObject:sectionTtile];
        }
        NSArray* keyArray = [self.dataDict allKeys];
        if (![keyArray containsObject:sectionTtile]) {
            if ([BYObjectTool isInLetter:sectionTtile]) { //26个字母内
                self.dataDict[sectionTtile] = [NSMutableArray arrayWithObject:model];
            }else if (![keyArray containsObject:@"#"]) {
                self.dataDict[@"#"] =  [NSMutableArray arrayWithObject:model];
            }else {
                NSMutableArray* valueArray =  self.dataDict[@"#"];
                [valueArray addObject:model];
                self.dataDict[@"#"] = valueArray;
            }
            
        }else {
            if ([BYObjectTool isInLetter:sectionTtile]) { //26个字母内
                NSMutableArray* valueArray =  self.dataDict[sectionTtile];
                [valueArray addObject:model];
                self.dataDict[sectionTtile] = valueArray;
            }else {//如果不是26个字母则归为#
                NSMutableArray* valueArray =  self.dataDict[@"#"];
                [valueArray addObject:model];
                self.dataDict[@"#"] = valueArray;
            }
        }
    }
    
    //索引排列
    [self.indexArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];//升序
    }];
    NSArray* keyArray = [self.dataDict allKeys];
    if ([keyArray containsObject:@"#"]) {
        [self.indexArray insertObject:@"#" atIndex:0];
    }
    
    [self.tableView reloadData];
}

#pragma mark -- 数据源 代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString* sectionTitle = self.indexArray[section];
    NSMutableArray* araray = self.dataDict[sectionTitle];
    return araray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* sectionTitle = self.indexArray[indexPath.section];
    NSMutableArray* array = self.dataDict[sectionTitle];
    BYChoiceEngineerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYChoiceEngineerCell"];
    cell.model = array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString* sectionTitle = self.indexArray[indexPath.section];
    NSMutableArray* array = self.dataDict[sectionTitle];
    for (NSString *str in self.indexArray) {
        for (BYChoiceEngineerModel *model in self.dataDict[str]) {
            model.isSelect = NO;
        }
    }
    BYChoiceEngineerModel *model = array[indexPath.row];
    model.isSelect = YES;
    self.model = model;
    self.topHeadView.frame = CGRectMake(0, 0, MAXWIDTH, 110);
    self.engineerView.hidden = NO;
    self.nickName.text = model.nickName;
    self.starLabel.text = [NSString stringWithFormat:@"%zd星",model.compositeScore];
    self.evaluationStarView.lightCount = (int)model.compositeScore;
    [self.tableView reloadData];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return self.indexArray[section];
    
}


- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.indexArray;
}

//索引列点击事件
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;}

#pragma mark -- 搜索代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
   
    self.searchStr = textField.text;
    [self getData:textField.text];
    return YES;
}


#pragma mrak -- nodata
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"no_order"];
}

- (NSString *)xy_noDataViewMessage {
    return @"该区域暂无技师";
}

- (UIColor *)xy_noDataViewMessageColor {
    return BYLabelBlackColor;
}
- (NSNumber *)xy_noDataViewCenterYOffset{
    
    return [NSNumber numberWithInteger:0];
}

#pragma mark ---------------------------------------懒加载---------------------------------------
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight + 35, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight - 35) style:UITableViewStylePlain];
        _tableView.backgroundColor = BYBackViewColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        BYRegisterCell(BYChoiceEngineerCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
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
-(UIView *)searchView
{
    if (!_searchView) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH, 55)];
        _searchView.backgroundColor = WHITE;
        BYNaviSearchBar *naviSearchBar = [[BYNaviSearchBar alloc] initWithFrame:CGRectMake(12, 12.5, BYSCREEN_W - 24, 30)];
        naviSearchBar.searchField.placeholder = @"请输入技师名称/手机号";
        naviSearchBar.searchField.delegate = self;
        [_searchView addSubview:naviSearchBar];
//        BYButton *cityBtn = [[BYButton alloc] init];
//        self.cityBtn = cityBtn;
//        [cityBtn addTarget:self action:@selector(cityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [cityBtn setTitle:@"城市" forState:UIControlStateNormal];
//        [cityBtn setTitleColor:BYGlobalBlueColor forState:UIControlStateNormal];
//        cityBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//
//        [cityBtn setImage:[UIImage imageNamed:@"icon_arr_drop_down"] forState:UIControlStateNormal];
//        [cityBtn setImage:[UIImage imageNamed:@"icon_arr_drop_up"] forState:UIControlStateSelected];
//        cityBtn.frame = CGRectMake(MAXWIDTH - 80, 0, 80, 60);
//        [_searchView addSubview:cityBtn];
    }
    return _searchView;
}
-(UIView *)sureBtnView
{
    if (!_sureBtnView) {
        _sureBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UILabel *label = [UILabel verLab:15 textRgbColor:WHITE textAlighment:NSTextAlignmentCenter];
        label.text = @"确认";
        [_sureBtnView addSubview:label];
        label.frame = _sureBtnView.bounds;
    }
    return _sureBtnView;
}
-(UIView *)engineerView
{
    if (!_engineerView) {
        _engineerView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, MAXWIDTH, 55)];
        UIView *spaceView = [[UIView alloc] init];
        spaceView.backgroundColor = BYBigSpaceColor;
        _engineerView.backgroundColor = WHITE;
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choiceEngineer_sel"]];
        UILabel *label = [UILabel verLab:15 textRgbColor:BYGlobalBlueColor textAlighment:NSTextAlignmentLeft];
        self.nickName = label;
        label.text = @"";
        UILabel *starLabel = [UILabel verLab:15 textRgbColor:BYGlobalBlueColor textAlighment:NSTextAlignmentLeft];
        self.starLabel = starLabel;
        starLabel.text = @"0星";
        UILabel *cityLabel = [UILabel verLab:15 textRgbColor:BYGlobalBlueColor textAlighment:NSTextAlignmentLeft];
        cityLabel.hidden = YES;
        cityLabel.text = @"";
        [_engineerView addSubview:spaceView];
        [_engineerView addSubview:imageView];
        [_engineerView addSubview:label];
        [_engineerView addSubview:self.evaluationStarView];
        [_engineerView addSubview:starLabel];
        [_engineerView addSubview:cityLabel];
        [_evaluationStarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(80, 15));
            make.left.equalTo(label);
            make.bottom.mas_equalTo(-9);
        }];
        [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(MAXWIDTH, 0.5));
            make.top.trailing.leading.equalTo(_engineerView);
        }];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_engineerView);
            make.left.mas_equalTo(12);
            make.width.height.mas_equalTo(20);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(9);
            make.left.equalTo(imageView.mas_right).offset(15);
        }];
       
        [starLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_evaluationStarView);
            make.left.equalTo(self.evaluationStarView.mas_right).offset(8);
        }];
        [cityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_engineerView);
            make.left.equalTo(starLabel.mas_right).offset(18);
        }];
        
        
    }
    return _engineerView;
}
-(UIView *)topHeadView
{
    if (!_topHeadView) {
        _topHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH, 110)];
        _topHeadView.backgroundColor = WHITE;
        [_topHeadView addSubview:self.searchView];
        [_topHeadView addSubview:self.engineerView];
    }
    return _topHeadView;
}
-(BYEvaluationStarView*)evaluationStarView
{
    if (!_evaluationStarView) {
        _evaluationStarView = [[BYEvaluationStarView alloc] initWithFrame:CGRectMake(100, 20, 80, 15)];
        _evaluationStarView.isSmallStar = YES;
        _evaluationStarView.lightCount = 0;
        _evaluationStarView.allCount = 5;
      

    }
    return _evaluationStarView;
}
-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, MAXWIDTH, 35)];
        _topView.backgroundColor = BYBackViewColor;
        UILabel *label = [UILabel verLab:15 textRgbColor:UIColorHexFromRGB(0x333333) textAlighment:NSTextAlignmentLeft];
        self.serviceAdressLabel = label;
        [_topView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_topView);
            make.left.mas_equalTo(20);
        }];
    }
    return _topView;
}
@end
