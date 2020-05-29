//
//  BYAlarmSettingController.m
//  BYGPS
//
//  Created by miwer on 16/7/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAlarmSettingController.h"
#import "BYAlarmHttpTool.h"
#import "BYSettingGroup.h"
#import "BYSettingAlarmTypeItem.h"
#import "EasyNavigation.h"

#import "BYSelectAllHeaderView.h"


#define HeaderViewHeight BYS_W_H(46)

@interface BYAlarmSettingController ()

@property(nonatomic,strong) BYSelectAllHeaderView * headerView;

@property(nonatomic,strong) NSString * alarmId;

@property(nonatomic,strong) NSArray * alarmTypeStrs;

@end

@implementation BYAlarmSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    
    if (self.isAlarmSetting) {//是否进入设置界面
        [self loadData];
    }else{
        [self selectAlarmTypes];
    }
}

-(void)selectAlarmTypes{
    
    BYSettingGroup * group = [[BYSettingGroup alloc] init];
    NSMutableArray * mArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 1; i < 29; i ++) {
        if (i == 1 || i == 4 || i == 21 || i == 17 || i == 18 || i == 19||i == 24||i == 25||i == 26 || i == 23) {
            continue;
        }
        BYSettingAlarmTypeItem * item = [[BYSettingAlarmTypeItem alloc] init];
        item.typeValue = 2;//value:1 未选中 2:选中
        
        NSInteger index = i;
        item.typeKey = [NSString stringWithFormat:@"%zd",index];//key:type1
        
        item.title = self.alarmTypeStrs[i-1];
        
        [mArray addObject:item];
    }
    
    group.items = [mArray copy];
    [self.groups addObject:group];
}
-(void)initBase{
    
    [self.navigationView setTitle:self.isAlarmSetting ? @"报警设置" : @"报警类型选择"];
    self.BYTableViewCellStyle = UITableViewCellStyleDefault;

    if (@available(iOS 11.0, *)){
        if ([self.tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    self.tableView.frame = CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight);
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    //  1应急报警 2低电报警 3断电报警 4震动报警 5超速报警 6离省报警 7电子围栏报警 8上线报警 9行驶报警 10停车报警 11开盖报警 12拆机报警 13屏蔽报警 14子母分离报警 15多设备分离报警 16定位分离报警 17@"" 18@"" 19@“”  20剪线报警 21脱离报警 22关机报警 23偏离登记地址  24 25 26 27车架号不一致报警 28翻转报警
    
    self.alarmTypeStrs = @[@"应急报警",@"低电报警",@"断电报警",@"震动报警",@"超速报警",@"离省报警",@"电子围栏报警",@"上线报警",@"行驶报警",@"停车报警",@"开盖报警",@"拆机报警",@"屏蔽报警",@"子母分离报警",@"多设备分离报警",@"单设备定位分离报警",@"",@"",@"",@"剪线报警",@"脱离报警",@"关机报警",@"",@"",@"",@"",@"车架号不一致报警",@"翻转报警"];
    BYWeakSelf;
    [self.navigationView addRightButtonWithTitle:@"保存" clickCallBack:^(UIView *view) {
        [weakSelf saveSetup];
    }];
}

-(void)loadData{
    
    BYWeakSelf;
    [BYAlarmHttpTool POSTAlarmSetSuccess:^(id data) {
        
        BYSettingGroup * group = [[BYSettingGroup alloc] init];
        NSMutableArray * mArray = [[NSMutableArray alloc] init];        
        weakSelf.alarmId = [data[@"id"] stringValue];
        
        for (NSString * key in data) {

            if ([key rangeOfString:@"type"].location != NSNotFound) {

                NSNumber * value = data[key];

                BYSettingAlarmTypeItem * item = [[BYSettingAlarmTypeItem alloc] init];
                item.typeKey = key;//key:type1
                if ([value isKindOfClass:[NSNull class]]) {
                    value = @(1);
                }
                item.typeValue = [value integerValue];//value:1不推送 2:推送

                NSInteger index = [[key substringFromIndex:4] integerValue];
                if (index >= 29) continue;

                
                BYLog(@"%zd",index);
                item.title = self.alarmTypeStrs[index - 1];

                if (index != 1 && index != 4 && index != 21 && index!=17 && index!=18&&index!=19 && index!=24 && index!=25&&index!=26 &&index != 23) {
                    [mArray addObject:item];
                }
            }
        }
        
        group.items = [mArray copy];
        [weakSelf.groups addObject:group];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

- (void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{

    BYSettingGroup *group = self.groups[indexPath.section];
    BYBaseSettingItem *baseItem = group.items[indexPath.row];
    BYSettingAlarmTypeItem * item = (BYSettingAlarmTypeItem *)baseItem;
    
    item.typeValue = item.typeValue == 1 ? 2 : 1;
    
    [self.tableView reloadData];

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    self.headerView = [BYSelectAllHeaderView by_viewFromXib];
    self.headerView.selectAllButton.selected = [self isSelectAll];
    BYWeakSelf;
    [self.headerView setSelectAllBlock:^{
        
        weakSelf.headerView.selectAllButton.selected = !weakSelf.headerView.selectAllButton.selected;
        
        [weakSelf selectAllTypeWith:weakSelf.headerView.selectAllButton.selected];
    }];
    
    return self.headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return HeaderViewHeight;
}

-(void)saveSetup{
    
    BYSettingGroup *group = [self.groups firstObject];
    
    if (self.isAlarmSetting) {//当跳进来是报警设置时
        
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        
        for (BYBaseSettingItem * baseItem in group.items) {
            
            BYSettingAlarmTypeItem * item = (BYSettingAlarmTypeItem *)baseItem;
            
            params[item.typeKey] = [NSString stringWithFormat:@"%zd",item.typeValue];
        }
        
        params[@"id"] = self.alarmId;
        
        [BYAlarmHttpTool POSTUpdateAlarmSetWithParams:params success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [self.navigationController popViewControllerAnimated:YES];
            });
        }];
        
    }else{//当跳进来是报警类型选择时
        
        NSMutableArray * typesResult = [NSMutableArray array];
        for (BYBaseSettingItem * baseItem in group.items) {
            
            BYSettingAlarmTypeItem * item = (BYSettingAlarmTypeItem *)baseItem;
            if (item.typeValue == 2) {
                [typesResult addObject:item.typeKey];
            }
        }
        
        NSString * resultStr = [typesResult componentsJoinedByString:@","];
        
        if (self.typesResultBlock) {
            self.typesResultBlock(resultStr);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)selectAllTypeWith:(BOOL)isSelectAll{
    
    BYSettingGroup *group = [self.groups firstObject];

    for (BYBaseSettingItem * item in group.items) {
        
        BYSettingAlarmTypeItem * alarmTypeItem = (BYSettingAlarmTypeItem *)item;
        alarmTypeItem.typeValue = isSelectAll ? 2 : 1;
    }
    
    [self.tableView reloadData];
}

-(BOOL)isSelectAll{//查询数组是否全部选中
    
    BYSettingGroup *group = [self.groups firstObject];
    for (BYBaseSettingItem *baseItem in group.items) {
        BYSettingAlarmTypeItem * item = (BYSettingAlarmTypeItem *)baseItem;
        if (item.typeValue == 1) {
            return NO;
        }
    }
    return YES;
}


@end
