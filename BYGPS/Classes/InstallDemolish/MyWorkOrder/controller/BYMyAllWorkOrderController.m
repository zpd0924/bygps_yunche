//
//  BYMyAllWorkOrderController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyAllWorkOrderController.h"
#import "BYMyWorkOrderCell.h"
#import "BYMyWorkOrderDetailController.h"
#import "BYNaviSearchBar.h"
#import "UIButton+HNVerBut.h"
#import "BYMyWorkOrderScreenViewController.h"
#import "BYMyEvaluationCommitViewController.h"
#import "BYMyAllWorkOrderModel.h"
#import "BYWorkMessageController.h"
#import "BYCheckWorkOrderViewController.h"
#import "BYMyEvaluationViewController.h"


@interface BYMyAllWorkOrderController ()
@property(nonatomic,assign) BOOL isHeader;
@property(nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation BYMyAllWorkOrderController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
}
- (void)initBase{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
     BYRegisterCell(BYMyWorkOrderCell);
    self.tableView.backgroundColor = BYBigSpaceColor;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 200.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addRefresh];
    
}

#pragma mark -- 筛选刷新
- (void)setModel:(BYScreenParameterModel *)model{
    _model = model;
    if (_isScreen) {
        [self loadData];
    }
}
#pragma makr --- 搜索关键字
- (void)setKeyWord:(NSString *)keyWord{
    _keyWord = keyWord;
    self.isScreen = NO;
     [self loadData];
}

-(void)addRefresh{
    
    BYWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.isHeader = YES;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];//让tableView进来默认加载数据
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isHeader = NO;
        weakSelf.currentPage += 1;
        [weakSelf loadData];
        
    }];
    
    self.tableView.mj_footer.hidden = YES;//先让footer隐藏
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
    if (_isScreen) {
        if (_model.isOperation) {
            dict[@"groupId"] = [BYSaveTool objectForKey:groupId];
            dict[@"pageNum"] = @(self.currentPage);
            dict[@"serviceType"] = @(_model.serviceType);
            if (_model.status)
            dict[@"status"] = @(_model.status);
            if(_model.isOvertimes)
            dict[@"isOvertimes"] = @(_model.isOvertimes);
            if (_model.startTime.length)
            dict[@"startTime"] = _model.startTime;
            if(_model.endTime.length)
            dict[@"endTime"] = _model.endTime;
            dict[@"type"] = @(_model.type);
        }else{
            dict[@"groupId"] = [BYSaveTool objectForKey:groupId];
            dict[@"pageNum"] = @(self.currentPage);
            dict[@"type"] = @(0);
        }
        
    }else{
        dict[@"groupId"] = [BYSaveTool objectForKey:groupId];
        dict[@"pageNum"] = @(self.currentPage);
        dict[@"type"] = @(0);
        if (_keyWord.length) {
            dict[@"content"] = _keyWord;
        }
        if (_isOverTime) {
             dict[@"isOvertimes"] = @(1);
        }
    }
    
        [BYSendWorkHttpTool POSTOrderListParams:dict success:^(id data) {
           
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.isHeader) {//数据请求成功时才将数据清空
                    [weakSelf.dataSource removeAllObjects];
                }
                NSArray *array = data[@"list"];
                for (NSDictionary *dict in array) {
                    BYMyAllWorkOrderModel *model = [[BYMyAllWorkOrderModel alloc] initWithDictionary:dict error:nil];
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

#pragma mark -- cell上 按钮点击
- (void)cellClick:(NSString *)name cellModelWith:(BYMyAllWorkOrderModel *)model{
    if ([name isEqualToString:@"撤回"]) {
        [self cannelOrder:model];
    }else if ([name isEqualToString:@"审核"]){
        [self auditing:model];
    }else if ([name isEqualToString:@"编辑"]){
        BYWorkMessageController *vc = [[BYWorkMessageController alloc] init];
        
        switch (model.serviceType) {
            case 1:
                vc.titleLabelStr = @"编辑安装派单";
                vc.sendOrderType = BYWorkSendOrderType;
                break;
            case 2:
                vc.titleLabelStr = @"编辑检修派单";
                vc.sendOrderType = BYRepairSendOrderType;
                break;
            default:
                vc.titleLabelStr = @"编辑拆机派单";
                vc.sendOrderType = BYUnpackSendOrderType;
                break;
        }
        vc.isEdit = YES;
        vc.orderNo = model.orderNo;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([name isEqualToString:@"技师评价"]){//技师评价
     BYMyEvaluationCommitViewController *vc = [[BYMyEvaluationCommitViewController alloc] init];
        vc.technicianId = model.technicianId;
        vc.orderNo = model.orderNo;
     [self.navigationController pushViewController:vc animated:YES];
       
    }else if ([name isEqualToString:@"查看评价"]){
        BYMyEvaluationViewController *vc = [[BYMyEvaluationViewController alloc] init];
        vc.technicianId = model.technicianId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark -- 撤回接口
- (void)cannelOrder:(BYMyAllWorkOrderModel *)model{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"orderNo"] = model.orderNo;
    [BYSendWorkHttpTool POSTCannelOrderParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYShowSuccess(@"撤回成功");
            [weakSelf.dataSource removeObject:model];
            [weakSelf.tableView reloadData];
        });
       
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 审核接口
- (void)auditing:(BYMyAllWorkOrderModel *)model{
    BYWeakSelf;
    BYCheckWorkOrderViewController *vc = [[BYCheckWorkOrderViewController alloc] init];
    vc.checkWorkOrderBlock = ^(BYMyAllWorkOrderModel *model) {
        [weakSelf loadData];
    };
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    BYMyAllWorkOrderModel *model = self.dataSource[indexPath.row];
    BYMyWorkOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMyWorkOrderCell" forIndexPath:indexPath];
    cell.cellBlock = ^(NSString *name) {
        dispatch_async(dispatch_get_main_queue(), ^{
             [weakSelf cellClick:name cellModelWith:model];
        });
       
    };
    cell.model = self.dataSource[indexPath.row];
        return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BYMyAllWorkOrderModel *model = self.dataSource[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (model.status >= 5)
        return;
    BYMyWorkOrderDetailController *vc = [[BYMyWorkOrderDetailController alloc] init];
    vc.orderNo = model.orderNo;
    vc.orderStatus = model.status;
    if (model.status == 6) {
        return BYShowError(@"此单为异常单，请联系本公司客服处理");
    }
    ///服务类别 1:安装,2:检修,3:拆机
    switch (model.serviceType) {
        case 1:
            vc.sendOrderType = BYWorkSendOrderType;
            break;
        case 2:
            vc.sendOrderType = BYRepairSendOrderType;
            break;
        case 3:
            vc.sendOrderType = BYUnpackSendOrderType;
            break;
        default:
            break;
    }
   
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mrak -- nodata
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"no_order"];
}

- (NSString *)xy_noDataViewMessage {
    return @"暂无工单!";
}

- (UIColor *)xy_noDataViewMessageColor {
    return BYLabelBlackColor;
}
- (NSNumber *)xy_noDataViewCenterYOffset{

    return [NSNumber numberWithInteger:0];
}

#pragma mark -- lazy
    -(NSMutableArray *)dataSource
    {
        if (!_dataSource) {
            _dataSource = [NSMutableArray array];
        }
        return _dataSource;
    }


@end
