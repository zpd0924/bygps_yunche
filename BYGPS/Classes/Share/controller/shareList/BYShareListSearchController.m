//
//  BYShareListSearchController.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/12.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYShareListSearchController.h"
#import "EasyNavigation.h"
#import "BYNaviSearchBar.h"
#import "BYReceiveShareCell.h"
#import "BYShareGiveOutCell.h"
#import "BYEditShareController.h"

@interface BYShareListSearchController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) BYNaviSearchBar * naviSearchBar;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property(nonatomic,assign) BOOL isHeader;
@property(nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSString *keyWord;
@end

@implementation BYShareListSearchController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    BYWeakSelf;
    [self.navigationView removeAllLeftButton];
    [self.navigationView removeAllRightButton];
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
    self.view.backgroundColor = UIColorFromToRGB(235, 235, 235);
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-20, 0, MAXWIDTH - 80, 30)];
    view.backgroundColor = WHITE;
    self.naviSearchBar = [[BYNaviSearchBar alloc] initWithFrame:CGRectMake(-20, 0, BYSCREEN_W - 80, 30)];
    self.naviSearchBar.searchBlock = ^{
        [weakSelf select];
    };
    [self.naviSearchBar.searImageBtn setTitleColor:BYGlobalBlueColor forState:UIControlStateNormal];
   
    self.naviSearchBar.isShareSearch = YES;
    [view addSubview:self.naviSearchBar];
    [self.navigationView addTitleView:view];
    self.naviSearchBar.searchField.placeholder = @"请输入车牌号";
    self.naviSearchBar.searchField.delegate = self;
    [self.naviSearchBar.searchField becomeFirstResponder];
    [self tableView];
    [self.naviSearchBar.searchField addTarget:self action:@selector(tfEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self addRefresh];
}
-(void)addRefresh{
    
    BYWeakSelf;
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//        weakSelf.isHeader = YES;
//        [weakSelf loadData];
//    }];
    
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeySearch;
    [textField resignFirstResponder];
    self.keyWord = textField.text;
    self.isHeader = YES;
    [self loadData];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.keyWord = textField.text;
    self.isHeader = YES;
     [self loadData];
}
- (void)tfEditingChanged:(UITextField *)textFiled{
    if (!textFiled.text.length) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
    }
}
-(void)loadData{
    if (!self.keyWord.length){
//        [self.dataSource removeAllObjects];
//        [self.tableView reloadData];
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
         return;
    }
    
    if (self.isHeader) {//每次发送网络请求时,都将toolBar关掉
        self.currentPage = 1;
        [self.dataSource removeAllObjects];
    }
    self.keyWord = [BYObjectTool lowUpdateBig:self.keyWord];
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"currentPage"] = @(self.currentPage);
    dict[@"showCount"] = @(10);
    if ([weakSelf.naviSearchBar.searImageBtn.titleLabel.text isEqualToString:@"车牌号"]) {
        dict[@"carNum"] = self.keyWord;
    }else if ([weakSelf.naviSearchBar.searImageBtn.titleLabel.text isEqualToString:@"车架号"]){
         dict[@"carVin"] = self.keyWord;
    }else{
         dict[@"deviceSn"] = self.keyWord;
    }
    if (_searchType == MySendShareType) {//我发出的
        [BYRequestHttpTool POSTMySendShareListParams:dict success:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.isHeader) {//数据请求成功时才将数据清空
                    [weakSelf.dataSource removeAllObjects];
                }
                NSArray *array = data[@"list"];
                for (NSMutableDictionary *dict in array) {
                    NSMutableDictionary *dictionary = [dict mutableCopy];
                    NSString *deviceShare = [dictionary[@"deviceShare"] isKindOfClass:[NSString class]]?dictionary[@"deviceShare"]:@"";
                    NSString *shareLine =  [dictionary[@"shareLine"] isKindOfClass:[NSString class]]?dictionary[@"shareLine"]:@"";
                    NSString *shareMobile = [dictionary[@"shareMobile"] isKindOfClass:[NSString class]]?dictionary[@"shareMobile"]:@"";
                    if (deviceShare.length) {
                        dictionary[@"deviceShare"] = [weakSelf stringToJSON:deviceShare];
                    }
                    if (shareLine.length) {
                        dictionary[@"shareLine"] = [weakSelf stringToJSON:shareLine];
                    }
                    if (shareMobile.length) {
                        dictionary[@"shareMobile"] = [weakSelf stringToJSON:shareMobile];
                    }
                    BYShareListModel *model = [BYShareListModel yy_modelWithDictionary:dictionary];
                    [weakSelf.dataSource addObject:model];
                    
                }
                weakSelf.tableView.mj_footer.hidden = array.count < 10 ? YES : NO;
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
                
            });
            
            
            
        } failure:^(NSError *error) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }else{//我收到的
        [BYRequestHttpTool POSTMyReceiveShareListParams:dict success:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.isHeader) {//数据请求成功时才将数据清空
                    [weakSelf.dataSource removeAllObjects];
                }
                NSArray *array = data[@"list"];
                for (NSMutableDictionary *dict in array) {
                    NSMutableDictionary *dictionary = [dict mutableCopy];
                    NSString *deviceShare = [dictionary[@"deviceShare"] isKindOfClass:[NSString class]]?dictionary[@"deviceShare"]:@"";
                    NSString *shareLine =  [dictionary[@"shareLine"] isKindOfClass:[NSString class]]?dictionary[@"shareLine"]:@"";
                    NSString *shareMobile = [dictionary[@"shareMobile"] isKindOfClass:[NSString class]]?dictionary[@"shareMobile"]:@"";
                    if (deviceShare.length) {
                        dictionary[@"deviceShare"] = [weakSelf stringToJSON:deviceShare];
                    }
                    if (shareLine.length) {
                        dictionary[@"shareLine"] = [weakSelf stringToJSON:shareLine];
                    }
                    if (shareMobile.length) {
                        dictionary[@"shareMobile"] = [weakSelf stringToJSON:shareMobile];
                    }
                    BYShareListModel *model = [BYShareListModel yy_modelWithDictionary:dictionary];
                    [weakSelf.dataSource addObject:model];
                    
                }
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
    
    
    
}
// 将JSON串转化为数组
- (NSArray *)stringToJSON:(NSString *)jsonStr {
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            }else{
                return nil;
            }
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

#pragma mark -- 编辑
- (void)edit:(BYShareListModel *)model{
    BYWeakSelf;
    BYEditShareController *vc = [[BYEditShareController alloc] init];
    vc.editShareSucessBlock = ^{
        [weakSelf loadData];
    };
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 结束
- (void)end:(BYShareListModel *)model sucess:(void (^)(bool isSuccess))success{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"shareId"] = model.shareId;
    [BYRequestHttpTool POSTEndShareParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(YES);
        });
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -- 选择车牌 车架 或者设备
- (void)select{
    BYWeakSelf;
        UIAlertController *alertVc = [BYObjectTool showChangeCarNumberOrVinOrSnAleartCarNumWith:^{
            [weakSelf.naviSearchBar.searImageBtn setTitle:@"车牌号" forState:UIControlStateNormal];
             weakSelf.naviSearchBar.searchField.placeholder = @"请输入车牌号";
        } vinNum:^{
            [weakSelf.naviSearchBar.searImageBtn setTitle:@"车架号" forState:UIControlStateNormal];
             weakSelf.naviSearchBar.searchField.placeholder = @"请输入车架号";
        } SnNum:^{
            [weakSelf.naviSearchBar.searImageBtn setTitle:@"设备号" forState:UIControlStateNormal];
             weakSelf.naviSearchBar.searchField.placeholder = @"请输入设备号";
        }];
        if ([BYObjectTool getIsIpad]){
            
            alertVc.popoverPresentationController.sourceView = self.view;
            alertVc.popoverPresentationController.sourceRect =  CGRectMake(100, 100, 1, 1);
        }
        [self presentViewController:alertVc animated:YES completion:nil];
}
#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return self.dataSource.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    
    if (_searchType == MySendShareType) {
        BYShareGiveOutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYShareGiveOutCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.editBlock = ^{
            [weakSelf edit:self.dataSource[indexPath.row]];
        };
        cell.endBlock = ^{
            [weakSelf end:self.dataSource[indexPath.row] sucess:^(bool isSuccess) {
                [weakSelf.dataSource removeObject:weakSelf.dataSource[indexPath.row]];
                [weakSelf.tableView reloadData];
            }];
        };
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }else{
        
        BYReceiveShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYReceiveShareCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
   
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mrak -- nodata
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"no_order"];
}

- (NSString *)xy_noDataViewMessage {
    return @"未匹配到结果!";
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
        BYRegisterCell(BYReceiveShareCell);
        BYRegisterCell(BYShareGiveOutCell);
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
