//
//  BYOrderPushViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/20.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYOrderPushViewController.h"
#import "EasyNavigation.h"
#import "BYOrderPushCell.h"
#import "BYOrderPushModel.h"

@interface BYOrderPushViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,assign) NSInteger overTimeOrder;//0关 1开
@property (nonatomic,assign) NSInteger waitOrder;//0关 1开
@property (nonatomic,assign) NSInteger takeInOrder;//0关 1开
@property (nonatomic,strong) BYOrderPushModel *model;
@end

@implementation BYOrderPushViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self lookPush];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BYBigSpaceColor;
     [self.navigationView setTitle:@"工单推送"];
    [self.view addSubview:self.tableView];
   
}

#pragma mark -- 设置工单接口
- (void)setPush:(void (^)(void))success{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"type30"] = @(_model.type30);
    dict[@"type31"] = @(_model.type31);
    dict[@"type36"] = @(_model.type36);
    [BYSendWorkHttpTool POSPushSetParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYShowSuccess(@"设置成功");
            success();
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark -- 查询工单推送状态接口
- (void)lookPush{
    BYWeakSelf;
    
    [BYSendWorkHttpTool POSLookPushParams:nil success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYLog(@"%@",data);
            weakSelf.model = [BYOrderPushModel yy_modelWithDictionary:data];
            if (!weakSelf.model.type30)
                weakSelf.model.type30 = 1;
            if (!weakSelf.model.type31)
                weakSelf.model.type31 = 1;
            if (!weakSelf.model.type36)
                weakSelf.model.type36 = 1;
            [weakSelf.tableView reloadData];
        });
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BYWeakSelf;
    BYOrderPushCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYOrderPushCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     cell.model = self.model;
    cell.indexPath = indexPath;
    cell.overTimeOrderBlock = ^(NSInteger on) {
        weakSelf.overTimeOrder = on;
        if (on) {
            weakSelf.model.type30 = 2;
        }else{
            weakSelf.model.type30 = 1;
        }
        [weakSelf setPush:^(void) {
//          [BYSaveTool setBool:on forKey:@"overTimeOrder"];
           
           
        }];
    };
    cell.waitOrderBlock = ^(NSInteger on) {
         weakSelf.waitOrder = on;
        if (on) {
            weakSelf.model.type31 = 2;
        }else{
            weakSelf.model.type31 = 1;
        }
        [weakSelf setPush:^(void) {
//            [BYSaveTool setBool:on forKey:@"overTimeOrder"];
        }];
//         [BYSaveTool setBool:on forKey:@"waitOrder"];
    };
    cell.takeInOrderBlock = ^(NSInteger on) {
        weakSelf.takeInOrder = on;
        if (on) {
            weakSelf.model.type36 = 2;
        }else{
            weakSelf.model.type36 = 1;
        }
        [weakSelf setPush:^(void) {
            //            [BYSaveTool setBool:on forKey:@"overTimeOrder"];
        }];
        //         [BYSaveTool setBool:on forKey:@"waitOrder"];
    };
   
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 46;
}



#pragma mark -- lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = BYBigSpaceColor;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        BYRegisterCell(BYOrderPushCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"超时工单提醒",@"待审核工单提醒",@"技师接单提醒"];
    }
    return _titleArray;
}


@end
