//
//  BYReceivedListController.m
//  父子控制器
//
//  Created by miwer on 2016/12/16.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYReceivedListController.h"
#import "BYReceivingModel.h"
#import "RecivingCell.h"
#import "DeviceItem.h"
#import "BYInstallDemolishHttpTool.h"
#import <MJRefresh.h>
#import "BYBlankView.h"

@interface BYReceivedListController ()

@property(nonatomic,strong) NSMutableArray * dataSorce;
@property(nonatomic,assign) NSInteger currentPage;
@property(nonatomic,assign) BOOL isHeader;//是否为下拉刷新
@property(nonatomic,strong) BYBlankView * blankView;

@end

@implementation BYReceivedListController

-(instancetype)init{
    if (@available(iOS 11.0, *)) {
        
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
    } else {
        
        // Fallback on earlier versions
        
    }
    return [self initWithStyle:UITableViewStyleGrouped];
}

-(void)addRefresh{
    
    BYWeakSelf;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.isHeader = YES;
        [weakSelf loadData];
    }];
    [self.tableView.mj_header beginRefreshing];//让tableView进来默认加载数据
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.isHeader = NO;
        weakSelf.currentPage += 1;
        [weakSelf loadData];
    }];
    
    self.tableView.mj_footer.hidden = YES;//先让footer隐藏
}

-(void)loadData{
    if (self.isHeader) {//每次发送网络请求时,都将toolBar关掉
        self.currentPage = 1;
    }

    //已抢单列表中穿2(已抢单)和4(已完成)
    [BYInstallDemolishHttpTool POSTLoadOrderListWithStatus:@"2,4" page:self.currentPage success:^(NSMutableArray * array) {
        
        if (self.isHeader) {//数据请求成功时才将数据清空
            [self.dataSorce removeAllObjects];
        }
        
        BYLog(@"array : %@",array);
        [self.dataSorce addObjectsFromArray:array];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //如果当前加载的数量小于20则隐藏footer,就不会重复出现上拉加载
            
            self.tableView.mj_footer.hidden = array.count < 20 ? YES : NO;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];

            //当数据源为空时显示空白view
            if (self.dataSorce.count) {
                
                if (self.blankView) {
                    [self.blankView removeFromSuperview];
                }
            }else{
                [self.view addSubview:self.blankView];
            }
            
            [self.tableView reloadData];

        });
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RecivingCell class]) bundle:nil] forCellReuseIdentifier:@"cell"];
    self.tableView.backgroundColor = BYGlobalBg;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self addRefresh];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYReceivingModel * model = self.dataSorce[indexPath.row];

    CGFloat row_H = BYS_W_H(100) + 16 + (model.list.count + 2) * BYS_W_H(22);
    
    return model.statu == 4 && model.recycleFlag != 2 ? row_H - BYS_W_H(40) : row_H;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecivingCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BYReceivingModel * model = self.dataSorce[indexPath.row];
    cell.model = model;
    [cell setCallBlcok:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (model.phone.length > 0) {
                NSMutableString * str = [[NSMutableString alloc] initWithFormat:@"tel:%@",model.phone];
                UIWebView * callWebview = [[UIWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }else{
                BYShowError(@"技师没有预留手机号码，无法拨打");
            }
            
        });
            }];
    
    [cell setRightActionBlcok:^(BOOL isCancel){//取消接单或确认订单
        [BYInstallDemolishHttpTool POSTOrderHandleWithType:isCancel ? BYDemolishOrderCancel : BYDemolishOrderSure orderId:model.orderId success:^(id data) {
            //取消接单或确认订单后重新刷新列表
            self.isHeader = YES;
            [self loadData];
        }];
    }];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSorce.count;
}

-(NSMutableArray *)dataSorce{
    if (_dataSorce == nil) {
        _dataSorce = [NSMutableArray array];
    }
    return _dataSorce;
}
-(BYBlankView *)blankView{
    if (_blankView == nil) {
        _blankView = [BYBlankView by_viewFromXib];
        _blankView.title = @"您还没有已接订单哦";
        _blankView.frame = self.tableView.frame;
    }
    return _blankView;
}

@end
