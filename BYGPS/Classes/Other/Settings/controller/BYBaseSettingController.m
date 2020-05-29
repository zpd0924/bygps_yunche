//
//  BYBaseSettingController.m
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYBaseSettingController.h"
#import "BYSettingGroup.h"
#import "BYSettingCell.h"
#import "BYSettingArrowItem.h"
#import "BYSettingBlueArrowItem.h"

@interface BYBaseSettingController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation BYBaseSettingController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = BYS_W_H(47);
    self.view.backgroundColor = BYGlobalBg;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSMutableArray *)groups
{
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, BYSCREEN_W, BYSCREEN_H - 64) style:UITableViewStyleGrouped];
//    }
//    return self;
//}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, BYSCREEN_H) style:UITableViewStyleGrouped];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

//- (instancetype)init
//{
//    return [self initWithStyle:UITableViewStyleGrouped];
//}

#pragma mark - tableView数据源
// 返回有多少组
- (NSInteger)numberOfSectionsInTableView:(nonnull UITableView *)tableView{
    return self.groups.count;
}

// 返回每一组有多少行,取出对应的小数组
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BYSettingGroup *group = self.groups[section];
    
    return group.items.count;
}

#pragma mark - <UITableViewDataSource>
- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 创建cell,设置cellStyle
    BYSettingCell *cell = [BYSettingCell cellWithTableView:tableView tableViewCellStyle:self.BYTableViewCellStyle];
    
    // 获取对应的组模型
    BYSettingGroup *group = self.groups[indexPath.section];
    
    // 获取模型
    BYBaseSettingItem *item = group.items[indexPath.row];
    
    // 给cell传递一个模型
    cell.item = item;
    
    return cell;
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
  
    BYSettingGroup *group = self.groups[indexPath.section];
    
    BYBaseSettingItem *item = group.items[indexPath.row];
    
    if ([item isKindOfClass:[BYSettingArrowItem class]]) {
        
        BYSettingArrowItem *arrowItem = (BYSettingArrowItem *)item;
        if (arrowItem.descVc) {
            switch (indexPath.row) {
                case 0:
                    MobClickEvent(@"me_about", @"");
                    break;
                case 1:
                    MobClickEvent(@"me_set", @"");
                    break;
                case 2:
                    MobClickEvent(@"me_phone_binding", @"");
                    break;
                case 3:
                    MobClickEvent(@"set_work_order", @"");
                    break;
                case 4:
                    MobClickEvent(@"set_change_password", @"");
                    break;
                default:
                    break;
            }
            UIViewController *vc =   [[arrowItem.descVc alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
    if ([item isKindOfClass:[BYSettingBlueArrowItem class]]) {

        
        BYSettingBlueArrowItem *blueArrowItem = (BYSettingBlueArrowItem *)item;
        if (blueArrowItem.descVc) {
            
            UIViewController *vc =   [[blueArrowItem.descVc alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    if (item.operationBlock) {
        item.operationBlock();
    }
    
}


@end













