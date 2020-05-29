//
//  BYEditShareController.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/13.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYEditShareController.h"
#import "EasyNavigation.h"
#import "BYEditShareCell.h"
#import "BYShareUserModel.h"
#import "BYAlertTip.h"
@interface BYEditShareController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation BYEditShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationView setTitle:@"编辑分享"];
   
    [self initBase];
}
- (void)initBase{
    [self.view addSubview:self.tableView];
    BYWeakSelf;
   
   
}
- (void)setModel:(BYShareListModel *)model{
    _model = model;
    
}

#pragma mark -- 编辑
- (void)edit:(BYShareListModel *)model{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"id"] = model.shareId;
    dict[@"shareTime"] = model.shareTime;
    dict[@"sendCommand"] = model.sendCommand;
    dict[@"checkAlarm"] = model.checkAlarm;
    //内部人员
    NSMutableArray *shareLineArr = [NSMutableArray array];
    for (BYShareUserModel *userModel in model.shareLine) {
        NSMutableDictionary *shareLineDict = [NSMutableDictionary dictionary];
        shareLineDict[@"receiveShareUserId"] = userModel.receiveShareUserId;
        shareLineDict[@"receiveShareUserName"] = userModel.receiveShareUserName;
        [shareLineArr addObject:shareLineDict];
    }
       //外部人员
     NSMutableArray *shareMobileArr = [NSMutableArray array];
    for (BYShareUserModel *userModel in model.shareMobile) {
       
        NSMutableDictionary *shareMobileDict = [NSMutableDictionary dictionary];
        shareMobileDict[@"mobile"] = userModel.mobile;
        [shareMobileArr addObject:shareMobileDict];
    }

    NSData *shareLineData=[NSJSONSerialization dataWithJSONObject:shareLineArr options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *shareLineJsonStr=[[NSString alloc]initWithData:shareLineData encoding:NSUTF8StringEncoding];
     dict[@"shareLine"] = shareLineJsonStr;
    
    NSData *shareMobileData=[NSJSONSerialization dataWithJSONObject:shareMobileArr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *shareMobileJsonStr=[[NSString alloc]initWithData:shareMobileData encoding:NSUTF8StringEncoding];
   dict[@"shareMobile"] = shareMobileJsonStr;
    
    
    
    BYWeakSelf;
    [BYRequestHttpTool POSTUpdateShareParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                BYShowSuccess(@"编辑成功");
            });
           
            if (weakSelf.editShareSucessBlock) {
                weakSelf.editShareSucessBlock();
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    
    BYEditShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYEditShareCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.editShareBlock = ^(BYShareListModel *model) {
        [BYAlertTip ShowAlertWith:@"确定要修改分享设置吗？" message:nil withCancelTitle:@"取消" withSureTitle:@"确定" viewControl:self andSureBack:^{
           [weakSelf edit:model];
        } andCancelBack:^{
            
        }];
       
    };
    cell.refreshShareBlock = ^{
        [weakSelf.tableView reloadData];
    };
   
    cell.model = _model;
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


#pragma mark --LAZY

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = BYBigSpaceColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 200.0f;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        BYRegisterCell(BYEditShareCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
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
