//
//  BYAutoServiceViewController.m
//  BYGPS
//
//  Created by ZPD on 2018/12/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceViewController.h"
#import "EasyNavigation.h"
#import "BYAutoScanViewController.h"

#import "BYAutoServiceSearchViewController.h"

#import "BYAutoServiceTableViewCell.h"

#import "BYAutoServiceModel.h"
#import "BYAutoServiceHeadView.h"

@interface BYAutoServiceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSourceArr;
@property (nonatomic,strong) BYAutoServiceHeadView *headView;


@end

@implementation BYAutoServiceViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    [self initDataBase];
}

-(void)initBase{
    [self.navigationView setTitle:@"自助装拆修"];
    BYWeakSelf;
    self.view.backgroundColor = BYBackViewColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.backgroundColor = UIColorHexFromRGB(0xececec);
    [self.view addSubview:self.tableView];
    BYRegisterCell(BYAutoServiceTableViewCell);
    self.headView.by_height = BYS_W_H(130);
    self.headView.by_width = SCREEN_WIDTH;
    self.tableView.tableHeaderView = self.headView;
    [self.headView.autoInstallBtn addTarget:self action:@selector(autoInstallClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.headView.autoRemoveBtn addTarget:self action:@selector(autoRemoveClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.headView.autoRepairBtn addTarget:self action:@selector(autoRepairClicked) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)autoInstallClicked{
    MobClickEvent(@"home_self_install",@"");
    BYAutoScanViewController *vc = [[BYAutoScanViewController alloc] init];
    vc.scanType = WQCodeScannerTypeBarcode;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)autoRemoveClicked{
    MobClickEvent(@"home_self_dismantle",@"");
    BYAutoServiceSearchViewController *vc =   [[BYAutoServiceSearchViewController alloc] init];
    vc.functionType = BYFunctionTypeRemove;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)autoRepairClicked{
    MobClickEvent(@"home_self_repair",@"");
    BYAutoServiceSearchViewController *vc =   [[BYAutoServiceSearchViewController alloc] init];
    vc.functionType = BYFunctionTypeRepair;
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)initDataBase{
    
    BYAutoServiceModel *model1 = [BYAutoServiceModel itemWithImage:@"icon_autoService_install" title:@"自助安装"];
    model1.descVc = [BYAutoScanViewController class];
    
    BYAutoServiceModel *model2 = [BYAutoServiceModel itemWithImage:@"icon_autoService_remove" title:@"自助拆机"];
    model2.descVc = [BYAutoServiceSearchViewController class];
    model2.functionType = BYFunctionTypeRemove;
    
    BYAutoServiceModel *model3 = [BYAutoServiceModel itemWithImage:@"icon_autoService_repair" title:@"自助检修"];
    model3.descVc = [BYAutoServiceSearchViewController class];
    model3.functionType = BYFunctionTypeRepair;
    
    [self.dataSourceArr addObject:model1];
    [self.dataSourceArr addObject:model2];
    [self.dataSourceArr addObject:model3];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYAutoServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYAutoServiceTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.model = self.dataSourceArr[indexPath.row];
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            MobClickEvent(@"home_self_install",@"");
            break;
        case 1:
            MobClickEvent(@"home_self_dismantle",@"");
            break;
        default:
            MobClickEvent(@"home_self_repair",@"");
            break;
    }
    
    BYAutoServiceModel *model = self.dataSourceArr[indexPath.row];
    
    if (indexPath.row == 0) {
        BYAutoScanViewController *vc = [[BYAutoScanViewController alloc] init];
        vc.scanType = WQCodeScannerTypeBarcode;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        BYAutoServiceSearchViewController *vc =   [[BYAutoServiceSearchViewController alloc] init];
        vc.functionType = model.functionType;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return BYS_W_H(130);
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return self.headView;
}


#pragma mark --LAZY

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 5)];
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}


-(NSMutableArray *)dataSourceArr{
    if (!_dataSourceArr) {
        _dataSourceArr = [NSMutableArray array];
    }
    return _dataSourceArr;
}

-(BYAutoServiceHeadView *)headView{
    if (!_headView) {
        _headView = [BYAutoServiceHeadView by_viewFromXib];
        
    }
    return _headView;
}


@end
