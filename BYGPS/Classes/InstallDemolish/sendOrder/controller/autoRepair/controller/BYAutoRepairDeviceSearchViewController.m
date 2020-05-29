//
//  BYAutoRepairDeviceSearchViewController.m
//  BYGPS
//
//  Created by ZPD on 2018/12/14.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoRepairDeviceSearchViewController.h"
#import "EasyNavigation.h"
#import "BYNaviSearchBar.h"
#import "BYBlankView.h"

#import "BYAutoRepairDeviceSearchCell.h"

#import "BYAutoServiceHttpTool.h"
#import "BYAutoServiceCarModel.h"
#import "BYAutoServiceDeviceModel.h"
#import "UIButton+HNVerBut.h"
#import "WQCodeScanner.h"


@interface BYAutoRepairDeviceSearchViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) BYNaviSearchBar * naviSearchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageInt;
@property (nonatomic,strong) NSString *searchStr;

@property(nonatomic , strong) BYBlankView *blankView;

@end

@implementation BYAutoRepairDeviceSearchViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;// 控制是否显示键盘上的工具条
    
    BYWeakSelf;
    [self.navigationView removeAllLeftButton];
    [self.navigationView removeAllRightButton];
    
//    [self.navigationView addLeftView:self.leftView clickCallback:^(UIView *view) {
//        [weakSelf select];
//    }];
    
    [self.navigationView addRightButtonWithTitle:@"取消" clickCallBack:^(UIView *view) {
        [weakSelf backAction];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;// 控制是否显示键盘上的工具条
}

-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
}

-(void)initBase{
    self.view.backgroundColor = UIColorHexFromRGB(0xececec);
//    BYWeakSelf;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH - 80, 30)];
    view.backgroundColor = WHITE;
    
    self.naviSearchBar = [[BYNaviSearchBar alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W - 80, 30)];
    self.naviSearchBar.isScan = YES;
    [view addSubview:self.naviSearchBar];
    [self.navigationView addTitleView:view];
    self.naviSearchBar.searchField.placeholder = @"请输入设备号";
    self.naviSearchBar.searchField.delegate = self;
    [self.naviSearchBar.searchField becomeFirstResponder];
    UIButton *scanBtn = [UIButton verBut:nil textFont:15 titleColor:nil bkgColor:nil];
    scanBtn.frame = CGRectMake(MAXWIDTH - 120, 0, 40, 30);
    [scanBtn setImage:[UIImage imageNamed:@"scan"] forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(scanBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:scanBtn];
    
    self.tableView.mj_footer.hidden = YES;
    
    [self.view addSubview:self.tableView];
}

#pragma mark -- 扫一扫
- (void)scanBtnClick:(UIButton *)btn{
//    BYWeakSelf;
//    UIAlertController *alertVc = [BYObjectTool showChangeCarNumberOrVinOrSnAleartCarNumWith:^{
//        [weakSelf carNumScan];
//    } vinNum:^{
//        [weakSelf carVinScan];
//    } SnNum:^{
    [self scanDevice];
//    }];
//    if ([BYObjectTool getIsIpad]) {
//        alertVc.popoverPresentationController.sourceView = self.view;
//        alertVc.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
//    }
//
//    [self presentViewController:alertVc animated:YES completion:nil];
    
}
#pragma mark -- 扫描设备号
- (void)scanDevice{
    BYWeakSelf;
    WQCodeScanner *scanner = [[WQCodeScanner alloc] init];
    scanner.scanType = WQCodeScannerTypeBarcode;
    scanner.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanner animated:YES completion:nil];
    [scanner setResultBlock:^(NSString *value) {
//        [weakSelf.naviSearchBar.searImageBtn setTitle:@"设备号" forState:UIControlStateNormal];
        weakSelf.searchStr = value;
        weakSelf.naviSearchBar.searchField.text = value;
        [weakSelf loadDeviceList];
    }];
}

-(void)loadDeviceList{
    self.tableView.mj_footer.hidden = NO;
    self.pageInt = 1;
    [self loadMoreDeviceList];
}

-(void)loadMoreDeviceList{
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setValue:self.carModel.carGroupId forKey:@"carGroupId"];
    [paraDic setValue:self.searchStr forKey:@"sn"];
    [paraDic setValue:@(self.pageInt) forKey:@"pageNo"];
    [paraDic setValue:@(10) forKey:@"pageSize"];
    
    [BYAutoServiceHttpTool POSTQuickRepairDeviceSearchWithParams:paraDic success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
        });
        
        if (self.pageInt <= 1) {
            [self.dataSource removeAllObjects];
        }
        
        self.pageInt ++;
        
        for (NSDictionary *dic in data[@"list"]) {
            BYAutoServiceDeviceModel *deviceModel = [[BYAutoServiceDeviceModel alloc] initWithDictionary:dic error:nil];
            
            [self.dataSource addObject:deviceModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (self.dataSource.count) {
                if (self.blankView) {
                    [self.blankView removeFromSuperview];
                }
                self.tableView.hidden = NO;
                [self.tableView reloadData];
            }else{
                [self.view addSubview:self.blankView];
                [self.tableView reloadData];
            }
            NSArray *tempArray = data[@"list"];
            
            if (tempArray.count < 10 && tempArray.count > 0) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else if(tempArray.count == 0){
                self.tableView.mj_footer.hidden = YES;
            }
//            [self.tableView reloadData];
        });
        
        
        
        
    } failure:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer endRefreshing];
            self.tableView.mj_footer.hidden = YES;
        });
    }];
    
    
}

-(void)deviceCheckWithSn:(BYAutoServiceDeviceModel *)deviceModel{
    
    NSMutableDictionary *paraDic = [[NSMutableDictionary alloc] init];
    [paraDic setValue:deviceModel.deviceSn forKey:@"deviceSn"];
    
    [BYAutoServiceHttpTool POSTQuickDeviceCheckWithParams:paraDic success:^(id data) {
        
        if ([data[@"deviceStatus"] integerValue] == 1) {
            if (self.deviceSnSearchBlock) {
                self.deviceSnSearchBlock(deviceModel);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
               [self.navigationController popViewControllerAnimated:YES];
            });
        
        }else{
            BYShowError(data[@"exceptionMsg"]);
        }
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYAutoRepairDeviceSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoRepairDeviceSearchCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BYAutoServiceDeviceModel *deviceModel = self.dataSource[indexPath.section];
    cell.deviceModel = deviceModel;
    BYWeakSelf;
    [cell setAddDeviceBlock:^{
        
        [weakSelf deviceCheckWithSn:deviceModel];
        
    }];
    
    // Configure the cell...
    
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor clearColor];
    return view;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (_isSearch) {
        return 10;
//    }else{
//        return 0;
//    }
}


#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeySearch;
    if (textField.text.length == 0) {
        [BYProgressHUD by_showErrorWithStatus:@"搜索内容不能为空"];
        return YES;
    }
//    if (self.scanType == carNumScanType) {
//        if (![BYRegularTool isValidCarNum:textField.text]) {
//            [BYProgressHUD by_showErrorWithStatus:@"输入的车牌号错误"];
//            return YES;
//        }
//
//    }
//    else if (self.scanType == vinNumScanType){
//        if (textField.text.length <= 5) {
//            [BYProgressHUD by_showErrorWithStatus:@"至少需要输入6个字符搜索"];
//            return YES;
//        }
//    }else{
        if (textField.text.length <= 5) {
            [BYProgressHUD by_showErrorWithStatus:@"至少需要输入6个字符搜索"];
            return YES;
        }
//    }
    
    [textField resignFirstResponder];
//    self.isSearch = YES;
    textField.text = [textField.text uppercaseString];
    self.searchStr = textField.text;
    [self loadDeviceList];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    //    if (self.isQueryType == YES) {
    //        [self cleanSearch];
    //    }
    [self.dataSource removeAllObjects];
    [self.tableView reloadData];
    self.tableView.mj_footer.hidden = YES;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location <= 0) {
        [self.dataSource removeAllObjects];
        [self.tableView reloadData];
        self.tableView.mj_footer.hidden = YES;
    }
    return YES;
}


#pragma mark --LAZY

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = UIColorHexFromRGB(0xececec);
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        BYRegisterCell(BYAutoRepairDeviceSearchCell);
//        BYRegisterCell(BYAutoServiceDeviceRepairInfoCell);
//        BYRegisterCell(BYAutoServiceDeviceRepairCheckCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self loadMoreDeviceList];
        }];
        
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(BYBlankView *)blankView{
    if (_blankView == nil) {
        _blankView = [BYBlankView by_viewFromXib];
        _blankView.title = @"未匹配到结果";
        _blankView.imgName = @"auto_noData";
        _blankView.frame = self.tableView.frame;
    }
    return _blankView;
}



@end
