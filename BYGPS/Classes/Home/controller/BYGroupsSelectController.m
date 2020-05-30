//
//  BYGroupsSelectController.m
//  BYGPS
//
//  Created by miwer on 16/10/8.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYGroupsSelectController.h"
#import "EasyNavigation.h"
#import "BYDeviceListHttpTool.h"
#import "BYGroupNode.h"
#import "BYListGroupCell.h"

static NSString * const groupCellID = @"groupCellID";

@interface BYGroupsSelectController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray * displaySource;//显示数据源数组

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray * selectGroups;

@end

@implementation BYGroupsSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    
    [self loadGroupData];
}

-(void)initBase{
    [self.navigationView setTitle:@"分组选择"];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = BYGlobalBg;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYListGroupCell class]) bundle:nil] forCellReuseIdentifier:groupCellID];
    self.tableView.rowHeight = BYS_W_H(44);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    BYWeakSelf;
    [self.navigationView addRightButtonWithTitle:@"确认" clickCallBack:^(UIView *view) {
        [weakSelf sureAction];
    }];
}

-(void)sureAction{//确定按钮 -> 遍历
    
    for (BYGroupNode * node in self.displaySource) {
        if (node.isSelect) {
            
            [self.selectGroups addObject:[NSString stringWithFormat:@"%zd",node.groupId]];
        }
    }
    
    NSString * groupIdsStr = [self.selectGroups componentsJoinedByString:@","];
    if (self.groupIdsStrBlock) {
        self.groupIdsStrBlock(groupIdsStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYGroupNode * groupNode = self.displaySource[indexPath.row];

    groupNode.isExpand = !groupNode.isExpand;//是否展开
    
    if (groupNode.isExpand) {//当前节点是展开状态
        
        NSRange range = NSMakeRange(indexPath.row + 1, groupNode.childs.count);
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:range];

        if (groupNode.childs.count > 0) {//如果当前组下设备数量大于0
            
            NSMutableArray * addArray = [self enumerateObjects:groupNode.childs level:groupNode.level + 1 isSelect:NO];
            [self.displaySource insertObjects:addArray atIndexes:indexSet];
            
            [self.tableView reloadData];
            
        }else{
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }else{//当前节点是合并状态
        
        [self enumerateChildNodesAtGroupNode:groupNode selectType:NO isSelect:NO];
        [self.tableView reloadData];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYGroupNode * groupNode = self.displaySource[indexPath.row];

    BYListGroupCell * groupCell = [tableView dequeueReusableCellWithIdentifier:groupCellID];
    groupCell.groupNode = groupNode;
    
    BYWeakSelf;
    //左边选中按钮block
    [groupCell setSelectGroupBlock:^(BOOL isSelect) {
        
        groupNode.isSelect = isSelect;
        
        //改变该节点下的所有子节点选中状态
//        [weakSelf enumerateChildNodesAtGroupNode:groupNode selectType:YES isSelect:isSelect];
        
        //改变该节点下的所有父节点的选中状态
//        [weakSelf enumerateParentNodesAtGroupNode:groupNode isSelect:isSelect];
        
        [weakSelf.tableView reloadData];
    }];
    
    return groupCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.displaySource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(void)loadGroupData{//标越
    
    BYWeakSelf;
    [BYDeviceListHttpTool POSTGroupListWith:nil success:^(id data, NSInteger typeIndex, NSInteger countInt) {
        
        [weakSelf.displaySource addObjectsFromArray:[weakSelf enumerateObjects:data level:0 isSelect:NO]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    }];
}

//根据子节点找到其父节点并进行选中状态改变
-(void)enumerateParentNodesAtGroupNode:(BYGroupNode *)childNode isSelect:(BOOL)isSelect{
    
    if (childNode.level == 0) {//如果是根节点,直接返回
        return;
    }
    
    NSInteger index = [self.displaySource indexOfObject:childNode];//开始位置下标
    
    for (NSInteger i = index - 1; i >= 0; i --) {
        
        BYGroupNode * parentNode = [self.displaySource objectAtIndex:i];
        
        if (childNode.parentId == parentNode.groupId) {//如果找到父节点的groupId,则修改选中状态
            
            if (isSelect == NO) {//如果是反选,则要判断父节点是否要选中
                
                for (NSInteger j = i + 1; j < self.displaySource.count; j ++) {
                    BYGroupNode * sameLevelNode = [self.displaySource objectAtIndex:j];
                    
                    if (sameLevelNode.level < childNode.level) {//如果level > groupNode.level,则跳出循环,表示不是同级的节点
                        break;
                    }
                    
                    if (sameLevelNode.isSelect && sameLevelNode.level == childNode.level) return;//如果同级的节点是选中并且level = child.level
                }
            }
            
            parentNode.isSelect = isSelect;
            
            if (parentNode.level == 0) {//如果找到根节点,直接返回
                return;
            }
            
            [self enumerateParentNodesAtGroupNode:parentNode isSelect:isSelect];//递归寻找父节点
        }
    }
}

//遍历子节点list
-(NSMutableArray *)enumerateObjects:(id)data level:(NSInteger)level isSelect:(BOOL)isSelect{
    
    NSMutableArray * tempArr = [NSMutableArray array];
    
    for (NSDictionary * dict in data) {
        
        BYGroupNode * groupNode = [[BYGroupNode alloc] initWithDictionary:dict error:nil];
        groupNode.isExpand = NO;
        groupNode.level = level;
        groupNode.isGroup = YES;
        groupNode.isSelect = isSelect;
        
        [tempArr addObject:groupNode];
        
    }
    return tempArr;
}

//遍历displaySource父节点下的所有子节点(包括孙节点)
-(void)enumerateChildNodesAtGroupNode:(BYGroupNode *)groupNode selectType:(BOOL)selectType isSelect:(BOOL)isSelect{
    
    NSInteger startIndex = [self.displaySource indexOfObject:groupNode];//开始位置下标
    
    NSInteger endIndex = startIndex;//结束位置下标
    
    //开始下标加1开始遍历
    for (NSInteger i = startIndex+1; i<self.displaySource.count; i++) {
        
        BYGroupNode * baseNode = [self.displaySource objectAtIndex:i];//取出下标为i的节点
        
        if (baseNode.level <= groupNode.level) {//如果level <= groupNode.level,则跳出循环
            break;
        }
        
        if (baseNode.level > groupNode.level) {//如果level比父节点小
            endIndex++;//结束位置下标加1
            
            if (selectType) {//如果是选择类型,则子节点都改为选中状态
                
                baseNode.isSelect = isSelect;
                
            }else{//如果是展开类型,则修改展开状态
                baseNode.isExpand = NO;
            }
        }
    }
    
    if (endIndex > startIndex) {
        
        if (!selectType) {//如果不是选择类型
            
            [self.displaySource removeObjectsInRange:NSMakeRange(startIndex+1, endIndex-startIndex)];
        }
    }
}

#pragma mark - lazy
-(NSMutableArray *)displaySource{
    if (_displaySource == nil) {
        _displaySource = [[NSMutableArray alloc] init];
    }
    return _displaySource;
}
-(NSMutableArray *)selectGroups{
    if (_selectGroups == nil) {
        _selectGroups = [[NSMutableArray alloc] init];
    }
    return _selectGroups;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight - 20, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight + 20) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end



