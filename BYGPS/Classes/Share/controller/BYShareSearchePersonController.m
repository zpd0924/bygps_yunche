//
//  BYShareSearchePersonController.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/28.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYShareSearchePersonController.h"
#import "EasyNavigation.h"
#import "BYShareSearchePersonHeadView.h"
#import "BYShareSearchePersonCell.h"
#import "BYCompanyModel.h"
#import "BYShareUserModel.h"
#import "BYNaviSearchBar.h"
#import "BYAddWithoutController.h"

@interface BYShareSearchePersonController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSString *keyWord;
@property(nonatomic,assign) BOOL isHeader;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,strong) BYNaviSearchBar * naviSearchBar;
@end

@implementation BYShareSearchePersonController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationView removeAllLeftButton];
    [self.navigationView removeAllRightButton];
    BYWeakSelf;
    [self.navigationView addRightButtonWithTitle:@"取消" clickCallBack:^(UIView *view) {
        [weakSelf backAction];
    }];
   
}
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseUI];
}
- (void)initBaseUI{
    BYWeakSelf;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH - 80, 30)];
    view.backgroundColor = WHITE;
    self.naviSearchBar = [[BYNaviSearchBar alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W - 80, 30)];
  
    [self.naviSearchBar.searImageBtn setTitleColor:BYGlobalBlueColor forState:UIControlStateNormal];
    self.naviSearchBar.searImageBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.naviSearchBar.searImageBtn setImage:[UIImage imageNamed:@"share_gray"] forState:UIControlStateNormal];
    [self.naviSearchBar.searImageBtn setTitle:@"" forState:UIControlStateNormal];
    self.naviSearchBar.searImageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [view addSubview:self.naviSearchBar];
    [self.navigationView addTitleView:view];
    self.naviSearchBar.searchField.placeholder = @"搜索员工姓名";
    self.naviSearchBar.searchField.delegate = self;
    [self.naviSearchBar.searchField becomeFirstResponder];
    self.naviSearchBar.searchField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.naviSearchBar.searchField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.tableView];
    
     [self.naviSearchBar.searchField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addRefresh];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeySearch;
    [textField resignFirstResponder];
    self.keyWord = textField.text;
    [self loadData];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.keyWord = textField.text;
    [self loadData];
}
- (void)tfEditingChanged:(UITextField *)textFiled{
    if (!textFiled.text.length) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    }
}

-(void)addRefresh{
    
    BYWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.isHeader = YES;
        [weakSelf loadData];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isHeader = NO;
        weakSelf.currentPage += 1;
        [weakSelf loadData];
        
    }];
    
    self.tableView.mj_footer.hidden = YES;//先让footer隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

-(void)loadData{
    if (self.isHeader) {//每次发送网络请求时,都将toolBar关掉
        self.currentPage = 1;
        [self.dataSource removeAllObjects];
    }
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"groupIds"] = @"";
    dict[@"userName"] = self.keyWord;
    if (!self.keyWord.length)
        return;
    [BYRequestHttpTool POSTFindListUserByUserWithGroupParams:dict success:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.isHeader) {//数据请求成功时才将数据清空
                [weakSelf.dataSource removeAllObjects];
            }
            NSArray *array = data;
            weakSelf.dataSource = [[NSArray yy_modelArrayWithClass:[BYCompanyModel class] json:array] mutableCopy];
            weakSelf.tableView.mj_footer.hidden = array.count < 10 ? YES : NO;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            
        });
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return self.dataSource.count;
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    
    BYShareSearchePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYShareSearchePersonCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.paramModel = _paramModel;
    cell.model = self.dataSource[indexPath.row];
    cell.addPersonBlock = ^(BYCompanyModel *model) {
        BYShareUserModel *userModel = [[BYShareUserModel alloc] init];
        userModel.receiveShareUserId = model.userId;
        userModel.receiveShareUserName = model.userName;
        userModel.userName = model.loginName;
        [_paramModel.shareLine addObject:userModel];
        for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[BYAddWithoutController class]]) {
                
    
                BYAddWithoutController *vc = (BYAddWithoutController *)controller;
                
                [weakSelf.navigationController popToViewController:vc animated:YES];
                
            }
            
        }
       
    };
    return cell;
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mrak -- nodata
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"no_order"];
}

- (NSString *)xy_noDataViewMessage {
    return @"未匹配到结果";
}

- (UIColor *)xy_noDataViewMessageColor {
    return BYLabelBlackColor;
}
- (NSNumber *)xy_noDataViewCenterYOffset{
    
    return [NSNumber numberWithInteger:0];
}



#pragma mark -- lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        BYRegisterCell(BYShareSearchePersonCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}



@end
