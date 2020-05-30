//
//  BYMyEvaluationViewController.m
//  xsxc
//
//  Created by ZPD on 2018/5/26.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYMyEvaluationViewController.h"
#import "BYMyEvaluationHeadView.h"
#import "BYMyEvaluationCell.h"
#import "BYMyEvaluationSectionHeadView.h"
#import "BYMyEvaluationFooterView.h"
#import "EasyNavigation.h"
#import "BYMyEvaluationModel.h"
#import <MJRefresh.h>
#import "BYMyEvaluationCountOrScoreModel.h"
#import "BYBlankView.h"

@interface BYMyEvaluationViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) BYMyEvaluationHeadView *headView;
@property (nonatomic,strong) BYMyEvaluationFooterView *footerView;
@property (nonatomic,strong) NSMutableArray *dataSource;

@property(nonatomic , assign) NSInteger currentPage;
@property(nonatomic , assign) BOOL isHeader;        //是否是下拉刷新
@property (nonatomic,assign) NSInteger commentType; //查看评论类型（1:全部 2：好评 3：中评 4：差评）
@property (nonatomic ,strong)BYMyEvaluationCountOrScoreModel *countOrScoreModel;

@property (nonatomic,strong) BYBlankView *blankView;
@end

@implementation BYMyEvaluationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initBase];

}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES]
    ;}
-(void)initBase{
    self.view.backgroundColor = BYBigSpaceColor;
    
    [self.navigationView setTitle:@"技师评价"];
    self.view.backgroundColor = BYBigSpaceColor;
//    self.navigationView.titleLabel.textColor = [UIColor whiteColor];
    BYWeakSelf;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView removeAllLeftButton];
//        
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//    });
    self.commentType = 0;
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    BYRegisterCell(BYMyEvaluationCell);
    
    self.headView = [BYMyEvaluationHeadView by_viewFromXib];
//    self.headView.by_height = 155;
    self.headView.isCommitEvaluation = NO;
    
    self.tableView.tableHeaderView = self.headView;
    
    self.footerView = [[BYMyEvaluationFooterView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 50)];
    [_footerView setLoadMoreBlock:^{
        weakSelf.isHeader = NO;
        weakSelf.currentPage += 1;
        [weakSelf loadData];
    }];
    self.tableView.tableFooterView = self.footerView;
    
    [self addRefresh];
    
}
-(void)addRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.isHeader = YES;
        
        [self loadData];
    }];
    
    self.tableView.mj_footer.hidden = YES;//先让footer隐藏
    [self.tableView.mj_header beginRefreshing];//让tableView进来默认加载数据
}


-(void)loadData{
     BYWeakSelf;
    if (self.isHeader) {//每次发送网络请求时,都将toolBar关掉
        self.currentPage = 1;
        [self.dataSource removeAllObjects];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    switch (self.commentType) {
        case 0:
            dict[@"status"] = @(1);
            break;
        case 1:
            dict[@"status"] = @(5);
            break;
        case 2:
            dict[@"status"] = @(4);
            break;
        default:
            dict[@"status"] = @(3);
            break;
    }
    
    dict[@"technicianId"] = @(_technicianId);
    dict[@"pageNum"] = @(self.currentPage);
    
    [BYSendWorkHttpTool POSTevaluateListParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary *dict in data[@"list"]) {
                BYMyEvaluationModel *model = [[BYMyEvaluationModel alloc] initWithDictionary:dict error:nil];
                [weakSelf.dataSource addObject:model];
            }
            weakSelf.countOrScoreModel = [[BYMyEvaluationCountOrScoreModel alloc] initWithDictionary:data[@"stat"] error:nil];
            weakSelf.headView.countOrScoreModel = weakSelf.countOrScoreModel;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYMyEvaluationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYMyEvaluationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BYMyEvaluationModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    // Configure the cell...
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYMyEvaluationModel *model = self.dataSource[indexPath.row];
    BYLog(@"=========%f",model.cell_H);
    return model.cell_H;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 68;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   
    
    BYMyEvaluationSectionHeadView *sectionHead = [BYMyEvaluationSectionHeadView by_viewFromXib];
    sectionHead.countOrScoreModel = _countOrScoreModel;
    sectionHead.by_height = 68;
    sectionHead.selectBtnTag = 501 + self.commentType;
    
    [sectionHead setChangeCommentTypeBlock:^(NSInteger type) {
        self.commentType = type;
        [self.tableView.mj_header beginRefreshing];//让tableView进来默认加载数据
    }];
    
    return sectionHead;
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
    }
    return _tableView;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(BYBlankView *)blankView
{
    if (!_blankView) {
        _blankView = [BYBlankView by_viewFromXib];
        _blankView.title = @"暂无评价";
        _blankView.imgName = @"order_no_data";
        _blankView.frame = self.tableView.frame;
    }
    return _blankView;
}

@end
