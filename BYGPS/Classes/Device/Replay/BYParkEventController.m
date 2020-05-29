//
//  BYParkEventController.m
//  BYGPS
//
//  Created by ZPD on 2017/8/7.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYParkEventController.h"
#import "BYParkEventCell.h"
#import "BYParkEventHeaderView.h"
#import "BYParkEventSectionView.h"
#import "BYBlankView.h"
#import "BYParkEventModel.h"
#import "BYPushNaviModel.h"
#import "NSString+BYAttributeString.h"
#import "EasyNavigation.h"

@interface BYParkEventController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic , strong) BYBlankView *blankView;
@property (nonatomic,strong)  UITableView *tableView;

@end

@implementation BYParkEventController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationView setTitle:@"停车事件"];
    
    [self.view addSubview:self.tableView];
    if (@available(iOS 11.0, *)) {
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        // Fallback on earlier versions
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"BYParkEventCell" bundle:nil] forCellReuseIdentifier:@"BYParkEventCell"];
    BYParkEventHeaderView *headerView = [BYParkEventHeaderView by_viewFromXib];
    headerView.sn = self.model.sn;
    
    NSString *carNumStr;
    if (self.model.carId > 0) {
        if (self.model.carNum.length > 0) {
            carNumStr = self.model.carNum;
            carNumStr = [NSString StringJudgeIsValid:carNumStr isValid:[BYSaveTool boolForKey:BYCarNumberInfo] subIndex:2];
        }else{
            if (self.model.carVin.length > 6) {
                NSRange range = NSMakeRange(self.model.carVin.length - 6, 6);
                carNumStr = [NSString stringWithFormat:@"...%@",[self.model.carVin substringWithRange:range]];
            }else{
                carNumStr = self.model.carVin;
            }
        }
    }else{
        carNumStr = @"未装车";
    }
    NSString *ownerNameStr = [NSString StringJudgeIsValid:self.model.ownerName isValid:[BYSaveTool boolForKey:BYCarOwnerInfo] subIndex:1];
    
    ownerNameStr = ownerNameStr.length > 4 ? [NSString stringWithFormat:@"%@...",[ownerNameStr substringToIndex:4]] : ownerNameStr;
    if (self.model.carId > 0) {
        headerView.carNumName = [NSString stringWithFormat:@"%@ %@",carNumStr,ownerNameStr];
    }else{
        headerView.carNumName = carNumStr;
    }
    headerView.by_height = BYS_W_H(40);
    self.tableView.tableHeaderView = headerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.estimatedRowHeight = 85.0f;//推测高度，必须有，可以随便写多少
    self.tableView.rowHeight =UITableViewAutomaticDimension;//iOS8之后默认就是这个值，可以省略
    
    //当数据源为空时显示空白view
    if (self.parkDatasource.count) {
        
        if (self.blankView) {
            [self.blankView removeFromSuperview];
        }
    }else{
        [self.view addSubview:self.blankView];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parkDatasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYParkEventCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYParkEventCell" forIndexPath:indexPath];
    BYParkEventModel *parkModel = self.parkDatasource[indexPath.row];
    cell.parkModel = parkModel;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    BYParkEventSectionView *sectionView = [BYParkEventSectionView by_viewFromXib];
    sectionView.beginTime = self.beginTime;
    sectionView.endTime = self.endTime;
    return sectionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return BYS_W_H(60);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedRowCallBack) {
        
        self.selectedRowCallBack(indexPath.row);
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark lazy
-(NSMutableArray *)parkDatasource
{
    if (!_parkDatasource) {
        _parkDatasource = [NSMutableArray array];
    }
    return _parkDatasource;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight)];
        _tableView.delegate =self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
-(BYBlankView *)blankView{
    if (_blankView == nil) {
        _blankView = [BYBlankView by_viewFromXib];
        _blankView.title = @"暂无停车数据";
        _blankView.imgName = @"noParkData";
        _blankView.frame = self.tableView.frame;
    }
    return _blankView;
}

@end
