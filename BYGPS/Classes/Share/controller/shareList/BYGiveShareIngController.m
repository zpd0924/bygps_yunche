//
//  BYGiveShareIngController.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/12.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYGiveShareIngController.h"
#import "BYShareGiveOutCell.h"
#import "BYEditShareController.h"
#import "BYShareListModel.h"
#import "BYControlH5ViewController.h"
@interface BYGiveShareIngController ()
@property(nonatomic,assign) BOOL isHeader;
@property(nonatomic,assign) NSInteger currentPage;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation BYGiveShareIngController
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
    BYRegisterCell(BYShareGiveOutCell);
    self.tableView.backgroundColor = BYBigSpaceColor;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 200.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAXWIDTH, 10)];
    headView.backgroundColor = UIColorFromToRGB(244, 244, 244);
    self.tableView.tableHeaderView = headView;
        [self addRefresh];
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
    dict[@"currentPage"] = @(self.currentPage);
    dict[@"showCount"] = @(10);
    dict[@"isEnd"] = @"N";
    
    [BYRequestHttpTool POSTMySendShareListParams:dict success:^(id data) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
         
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
            
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf.tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.refreshNumberBlock) {
                    weakSelf.refreshNumberBlock(data[@"page"][@"totalResult"]);
                }
            });
            
          
        });
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
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
    MobClickEvent(@"home_share_give_edit", @"");
    BYWeakSelf;
    BYEditShareController *vc = [[BYEditShareController alloc] init];
    vc.editShareSucessBlock = ^{
        [weakSelf loadData];
    };
    vc.model = [model copy];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 结束
- (void)end:(BYShareListModel *)model sucess:(void (^)(bool isSuccess))success{
     MobClickEvent(@"home_share_give_end", @"");
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"shareId"] = model.shareId;
    [BYRequestHttpTool POSTEndShareParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            success(YES);
            BYShowSuccess(@"结束分享成功");
        });
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
        return self.dataSource.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    
    BYShareGiveOutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYShareGiveOutCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataSource[indexPath.row];
    cell.editBlock = ^{
        [weakSelf edit:self.dataSource[indexPath.row]];
    };
    cell.endBlock = ^{
        [weakSelf end:self.dataSource[indexPath.row] sucess:^(bool isSuccess) {
            [weakSelf.dataSource removeObject:weakSelf.dataSource[indexPath.row]];
            [weakSelf.tableView reloadData];
        }];
    };
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    BYControlH5ViewController *vc = [[BYControlH5ViewController alloc] init];
//    vc.isModel = YES;
//    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mrak -- nodata
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"no_order"];
}

- (NSString *)xy_noDataViewMessage {
    return @"暂无分享数据!";
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
