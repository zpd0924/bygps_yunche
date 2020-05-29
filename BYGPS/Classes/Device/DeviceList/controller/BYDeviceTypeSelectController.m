//
//  BYDeviceTypeSelectController.m
//  BYGPS
//
//  Created by miwer on 16/8/31.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceTypeSelectController.h"
#import "BYDeviceTypeSelectHeader.h"
#import "BYDeviceTypeCell.h"
#import "BYDeviceListHttpTool.h"
#import "BYDeviceTypeModel.h"
#import "EasyNavigation.h"

@interface BYDeviceTypeSelectController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,strong) BYDeviceTypeSelectHeader * headerView;

@end

@implementation BYDeviceTypeSelectController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBase];
    [self loadAllDeviceType];
}


-(void)loadAllDeviceType{
    
    BYWeakSelf;
    [BYDeviceListHttpTool POSTAllDeviceTypeSuccess:^(id data) {
        [weakSelf.dataSource addObjectsFromArray:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

-(void)initBase{
    
    self.view.backgroundColor = BYGlobalBg;
    
    self.navigationView = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , self.navigationOrginalHeight)];
    [self.view addSubview:self.navigationView];
    [self.navigationView setTitle:@"设备型号"];
    self.navigationView.backgroundColor = [UIColor whiteColor];
    BYWeakSelf;
    [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_close"] clickCallBack:^(UIView *view) {
        [weakSelf dismissAction];
    }];
    [self.navigationView addRightButtonWithTitle:@"确认" clickCallBack:^(UIView *view) {
        [weakSelf sure];
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYDeviceTypeCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYDeviceTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.dataSource[indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    BYDeviceTypeModel * model = self.dataSource[indexPath.row];
    model.isSelect = !model.isSelect;
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    self.headerView.selectAllButton.selected = [self isSelectAll];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.headerView = [BYDeviceTypeSelectHeader by_viewFromXib];
    self.headerView.selectAllButton.selected = [self isSelectAll];
    BYWeakSelf;
    [self.headerView setSelectAllBlock:^{
        weakSelf.headerView.selectAllButton.selected = !weakSelf.headerView.selectAllButton.selected;
        [weakSelf allSelect:weakSelf.headerView.selectAllButton.selected];
        [weakSelf.tableView reloadData];
    }];
    
    [self.headerView setWiredActionBlock:^{
        if (weakSelf.dataSource.count) {
            
            NSMutableArray * types = [NSMutableArray array];
            for (BYDeviceTypeModel * model in weakSelf.dataSource) {
                if (!model.wifi) {
                    [types addObject:@(model.devicetypeid)];
                }
            }
            
            if (weakSelf.typesBlock) {
                weakSelf.typesBlock(types);
            }
            
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    [self.headerView setWirelessActionBlock:^{
        if (weakSelf.dataSource.count) {
            
            NSMutableArray * types = [NSMutableArray array];
            for (BYDeviceTypeModel * model in weakSelf.dataSource) {
                if (model.wifi) {
                    [types addObject:@(model.devicetypeid)];
                }
            }
            
            if (weakSelf.typesBlock) {
                weakSelf.typesBlock(types);
            }
        }
        
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
    
    return self.headerView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BYS_W_H(50);
}

-(void)dismissAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sure{
    
    NSMutableArray * types = [NSMutableArray array];
    for (BYDeviceTypeModel * model in self.dataSource) {
        if (model.isSelect) {
            [types addObject:@(model.devicetypeid)];
        }
    }
    
    if (self.typesBlock) {
        self.typesBlock(types);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)isSelectAll{//查询数组是否全部选中
    for (BYDeviceTypeModel * model in self.dataSource) {
        if (!model.isSelect) {
            return NO;
        }
    }
    return YES;
}

-(void)allSelect:(BOOL)isSelect{//根据header来设置是否选中
    for (BYDeviceTypeModel * model in self.dataSource) {
        model.isSelect = isSelect;
    }
}

#pragma mark - lazy

-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = BYS_W_H(44);
        _tableView.contentInset = UIEdgeInsetsMake(SafeAreaTopHeight, 0, 30, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
