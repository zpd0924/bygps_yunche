//
//  BYInsideListViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/12.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYInsideListViewController.h"
#import "EasyNavigation.h"
#import "BYDeviceListHttpTool.h"
#import "BYGroupShareNode.h"
#import "BYShareListGroupCell.h"
#import "BYShareListGroupPersonCell.h"
#import "BYInsideListBottomView.h"
#import "BYTreeTableView.h"
#import "BYShareListSearchView.h"
#import "BYShareSearchePersonController.h"
#import "BYShareUserModel.h"
static NSString * const groupCellID = @"BYShareListGroupCell";
@interface BYInsideListViewController ()<UITableViewDelegate,UITableViewDataSource,TreeTableCellDelegate>
@property(nonatomic,strong) NSMutableArray * displaySource;//显示数据源数组

@property (nonatomic,strong) UITableView *tableView;

@property(nonatomic,strong) NSMutableArray * selectGroups;
@property (nonatomic,strong) BYInsideListBottomView *bottomView;
@end

@implementation BYInsideListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
//
    [self loadGroupData];
   
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initBase{
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationView setTitle:@"添加内部接收人"];
    BYWeakSelf;
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        [self.navigationView removeAllLeftButton];
//        [self.navigationView removeAllRightButton];
//
//
//
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//
//    });
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = BYGlobalBg;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYShareListGroupCell class]) bundle:nil] forCellReuseIdentifier:groupCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYShareListGroupPersonCell class]) bundle:nil] forCellReuseIdentifier:@"BYShareListGroupPersonCell"];
    self.tableView.rowHeight = BYS_W_H(45);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    BYShareListSearchView *headView = [BYShareListSearchView by_viewFromXib];
    headView.shareListSearchBlock = ^{
        BYShareSearchePersonController *vc = [[BYShareSearchePersonController alloc] init];
        vc.paramModel = _paramModel;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    headView.frame = CGRectMake(0, SafeAreaTopHeight, MAXWIDTH, 54);
    
    BYInsideListBottomView *bottomView = [BYInsideListBottomView by_viewFromXib];
    bottomView.addBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    self.bottomView = bottomView;
    bottomView.selectedLabel.text = [NSString stringWithFormat:@"已选中%zd人",_paramModel.shareLine.count];
    CGFloat bottomViewH = SafeAreaTopHeight > 64 ?80:50;
    bottomView.frame = CGRectMake(0, MAXHEIGHT - bottomViewH, MAXWIDTH, bottomViewH);
    [self.view addSubview:headView];
    [self.view addSubview:bottomView];
    
}

#pragma mark -- 计算添加用户的数量
- (void)getPersonNumber:(BYShareCommitParamModel *)paramModel{
  
    self.bottomView.selectedLabel.text = [NSString stringWithFormat:@"已选中%zd人",paramModel.shareLine.count];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYGroupShareNode * groupNode = self.displaySource[indexPath.row];
    
    groupNode.isExpand = !groupNode.isExpand;//是否展开
    if (groupNode.username.length)return;//点击的是用户
    if (groupNode.isExpand) {//当前节点是展开状态
        [self getUsers:groupNode withIndexPath:indexPath];
      
        
    }else{//当前节点是合并状态
        
        [self enumerateChildNodesAtGroupNode:groupNode selectType:NO isSelect:NO];
        [self.tableView reloadData];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BYWeakSelf;
    BYGroupShareNode * groupNode = self.displaySource[indexPath.row];
    if (groupNode.username.length) {
        BYShareListGroupPersonCell *groupCell = [tableView dequeueReusableCellWithIdentifier:@"BYShareListGroupPersonCell"];
        groupCell.selectionStyle = UITableViewCellSelectionStyleNone;
        groupCell.paramModel = _paramModel;
        groupCell.personBlock = ^(BYShareCommitParamModel *paramModel){
            [weakSelf getPersonNumber:paramModel];//计算添加的数量
        };
        groupCell.groupNode = groupNode;
        return groupCell;
    }else{
        BYShareListGroupCell * groupCell = [tableView dequeueReusableCellWithIdentifier:groupCellID];
        
        groupCell.isAddCar = YES;
        groupCell.groupNode = groupNode;
        return groupCell;
    }

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.displaySource.count;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}



-(void)loadGroupData{//标越
    
    BYWeakSelf;
    
    [BYRequestHttpTool POSTGroupTreesForShareParams:nil success:^(id data) {
        BYLog(@"%@",data);
        [weakSelf.displaySource addObjectsFromArray:[weakSelf enumerateObjects:data level:0 isSelect:NO]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    } failure:^(NSError *error) {
        
    }];
    
  

}
#pragma mark -- 查询用户
- (void)getUsers:(BYGroupShareNode *)groupNode withIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"groupId"] = @(groupNode.groupId);
    [BYRequestHttpTool POSTFindListUserByGroupIdUserParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            BYLog(@"person = %@",data);
            NSArray *arr = data;
            NSRange range = NSMakeRange(indexPath.row + 1, groupNode.childs.count+arr.count);
            NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            if (groupNode.childs.count >= 0) {//如果当前组下设备数量大于0
                
                NSMutableArray * addArray = [self enumerateObjects:groupNode.childs level:groupNode.level + 1 isSelect:NO];
               
                if (arr.count > 0) {
                    addArray = [self enumeratePersonObjects:arr level:groupNode.level + 1 isSelect:NO dataSouce:addArray];
                }
                 [self.displaySource insertObjects:addArray atIndexes:indexSet];
                [self.tableView reloadData];
                
            }else{
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        });
    } failure:^(NSError *error) {
        
    }];
}

//根据子节点找到其父节点并进行选中状态改变
-(void)enumerateParentNodesAtGroupNode:(BYGroupShareNode *)childNode isSelect:(BOOL)isSelect{
    
    if (childNode.level == 0) {//如果是根节点,直接返回
        return;
    }
    
    NSInteger index = [self.displaySource indexOfObject:childNode];//开始位置下标
    
    for (NSInteger i = index - 1; i >= 0; i --) {
        
        BYGroupShareNode * parentNode = [self.displaySource objectAtIndex:i];
        
        if (childNode.parentId == parentNode.groupId) {//如果找到父节点的groupId,则修改选中状态
            
            if (isSelect == NO) {//如果是反选,则要判断父节点是否要选中
                
                for (NSInteger j = i + 1; j < self.displaySource.count; j ++) {
                    BYGroupShareNode * sameLevelNode = [self.displaySource objectAtIndex:j];
                    
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
        NSString *ID = dict[@"id"];
        BYGroupShareNode * groupNode = [[BYGroupShareNode alloc] initWithDictionary:dict error:nil];
        groupNode.isExpand = NO;
        groupNode.level = level;
        groupNode.isGroup = YES;
        groupNode.isSelect = isSelect;
        groupNode.groupId = [ID integerValue];
        
        [tempArr addObject:groupNode];
        
    }
    return tempArr;
}

//遍历子节点用户list
-(NSMutableArray *)enumeratePersonObjects:(id)data level:(NSInteger)level isSelect:(BOOL)isSelect dataSouce:(NSMutableArray *)dataSouce{
    
  
    
    for (NSDictionary * dict in data) {
        
        BYGroupShareNode * groupNode = [[BYGroupShareNode alloc] initWithDictionary:dict error:nil];
        groupNode.isExpand = NO;
        groupNode.level = level;
        groupNode.isGroup = NO;
        groupNode.isSelect = isSelect;
        groupNode.loginName = dict[@"loginName"];
        groupNode.username = dict[@"nickName"];
        groupNode.userId = dict[@"id"];
        [dataSouce addObject:groupNode];
        
    }
    return dataSouce;
}

//遍历displaySource父节点下的所有子节点(包括孙节点)
-(void)enumerateChildNodesAtGroupNode:(BYGroupShareNode *)groupNode selectType:(BOOL)selectType isSelect:(BOOL)isSelect{
    
    NSInteger startIndex = [self.displaySource indexOfObject:groupNode];//开始位置下标
    
    NSInteger endIndex = startIndex;//结束位置下标
    
    //开始下标加1开始遍历
    for (NSInteger i = startIndex+1; i<self.displaySource.count; i++) {
        
        BYGroupShareNode * baseNode = [self.displaySource objectAtIndex:i];//取出下标为i的节点
        
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
        CGFloat bottomViewH = SafeAreaTopHeight > 64 ?80:50;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight+54, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight-54 - bottomViewH) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}





@end
