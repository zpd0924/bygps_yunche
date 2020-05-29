//
//  BYDeviceListController.m
//  BYGPS
//
//  Created by miwer on 16/8/29.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYDeviceListController.h"

#import "BYDetailTabBarController.h"
#import "EasyNavigation.h"

#import "BYDeviceListHeader.h"
#import "BYAlertView.h"
#import "BYGroupSearchBar.h"
#import "BYNaviSearchBar.h"
#import "BYSearchBar.h"
#import "BYAlarmToolView.h"
#import "WQCodeScanner.h"

#import "BYDeviceTypeSelectController.h"
#import "BYControlViewController.h"

#import "BYDeviceListHttpTool.h"
#import "BYDeviceListHttpParams.h"

#import "BYGroupNode.h"
#import "BYItemNode.h"
#import "BYListGroupCell.h"
#import "BYListItemCell.h"
#import "BYPushNaviModel.h"

#import "BYHomeHttpTool.h"
#import "NSDate+BYDistanceDate.h"
#import "BYControlSearchViewController.h"


static NSString * const groupCellID = @"groupCellID";
static NSString * const itemCellID = @"itemCellID";
static NSInteger const selectItemsCount = 20;
static NSString * const selectItemsTip = @"所选设备不能超过20台";

#define tableHeader_H BYS_W_H(45+40) // 45+40
#define toolView_H BYS_W_H(50)

@interface BYDeviceListController () <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UITableView * tableView;
@property(nonatomic,strong) BYAlertView * alertView;
@property(nonatomic,strong) BYGroupSearchBar * groupSearchBar;
@property(nonatomic,strong) BYDeviceListHeader * listHeader;
@property(nonatomic,strong) BYAlarmToolView * toolView;
@property(nonatomic,strong) BYSearchBar * naviSearchBar;

@property(nonatomic,strong) NSMutableArray * displaySource;//显示的数据
@property(nonatomic,strong) NSMutableArray * controlItems;
@property(nonatomic,strong) BYDeviceListHttpParams * httpParams;

@end

@implementation BYDeviceListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    
    if (![BYSaveTool boolForKey:BYIsReadinessKey]) {
    
        [self showHomeStatusCount];//将首页传过来的数据展示上去
    }
    
    [self loadGroupData];
    
}
-(void)showHomeStatusCount{

    if (self.countDict) {
        
        for (NSInteger i = 100; i < 104; i ++) {
            UIButton * tagButton = nil;
            switch (i) {
                case 100:{
                    tagButton = (UIButton *)[self.listHeader viewWithTag:100];
                    [tagButton setTitle:[NSString stringWithFormat:@"全部(%@)",self.countDict[@"allDevice"]] forState:UIControlStateNormal];
                } break;
                case 101:{
                    tagButton = (UIButton *)[self.listHeader viewWithTag:101];
                    [tagButton setTitle:[NSString stringWithFormat:@"在线(%@)",self.countDict[@"online"]] forState:UIControlStateNormal];
                } break;
                case 102:{
                    tagButton = (UIButton *)[self.listHeader viewWithTag:102];
                    [tagButton setTitle:[NSString stringWithFormat:@"离线(%@)",self.countDict[@"offline"]] forState:UIControlStateNormal];
                } break;
                case 103:{
                    tagButton = (UIButton *)[self.listHeader viewWithTag:103];
                    [tagButton setTitle:[NSString stringWithFormat:@"报警(%@)",self.countDict[@"alarm"]] forState:UIControlStateNormal];
                } break;
                default:
                    break;
            }
        }
    }
}
//将请求过来的数据展示上去
-(void)showLoadStatusCountWithIndex:(NSInteger)index countInt:(NSInteger)countInt{
    //先将头部button取出来
    UIButton * tagButton = (UIButton *)[self.listHeader viewWithTag:100 + index];
    NSString * statusStr = nil;
    switch (index) {
        case 0: {statusStr = @"全部";MobClickEvent(@"device_all", @"");} break;
        case 1: {statusStr = @"在线";MobClickEvent(@"device_online", @"");}break;
        case 2: {statusStr = @"离线";MobClickEvent(@"device_offline", @"");} break;
        case 3: {statusStr = @"报警";MobClickEvent(@"device_alarm", @"");} break;
        default: break;
    }
    [tagButton setTitle:[NSString stringWithFormat:@"%@(%zd)",statusStr,countInt] forState:UIControlStateNormal];
}

-(void)loadItemDataWithGroupId:(NSInteger)groupId index:(NSInteger)index isSelect:(BOOL)isSelect{
    
    BYWeakSelf;
    [BYDeviceListHttpTool POSTDeviceListWithGroupId:groupId params:self.httpParams success:^(id data) {

        BYGroupNode * groupNode = weakSelf.displaySource[index];
        groupNode.flag = NO;
        [groupNode.childs removeAllObjects];
        [groupNode.childs addObjectsFromArray:data];

        NSRange range = NSMakeRange(index + 1, groupNode.childs.count);
        NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        NSMutableArray * addArr = [weakSelf enumerateObjects:groupNode.childs level:groupNode.level + 1 isSelect:isSelect];
        groupNode.childs = addArr;//将遍历过的数组替换掉没遍历过的数组
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.displaySource insertObjects:groupNode.childs atIndexes:indexSet];
            [weakSelf.tableView reloadData];
        });
    }];
}
//获取分组信息
-(void)loadGroupData{//标越
    
    [self.controlItems removeAllObjects];
    [self toolViewAnimateWith:NO model:nil];
    
    BYWeakSelf;
    [BYDeviceListHttpTool POSTGroupListWith:self.httpParams success:^(id data, NSInteger typeIndex, NSInteger countInt) {
        
        if (![BYSaveTool isContainsKey:@"BYDeviceListControllerSelect"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
               [BYGuideImageView showGuideViewWith:@"BYDeviceListControllerSelect" touchOriginYScale:0.33];
            });
        }//加载完数据后加载蒙版
        BYLog(@"%@",data);
        [weakSelf.displaySource removeAllObjects];

        [weakSelf.displaySource addObjectsFromArray:[weakSelf enumerateObjects:data level:0 isSelect:NO]];
        
        __strong typeof(weakSelf)strongSelf = weakSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (typeIndex >= 0 && ![BYSaveTool boolForKey:BYIsReadinessKey]) {
                [strongSelf showLoadStatusCountWithIndex:typeIndex countInt:countInt];
            }
            
            [weakSelf.tableView reloadData];
        });
    }];
}

//遍历子节点list
-(NSMutableArray *)enumerateObjects:(id)data level:(NSInteger)level isSelect:(BOOL)isSelect{
    
    NSMutableArray * tempArr = [NSMutableArray array];
    
    for (id childData in data) {
        
        if ([childData isKindOfClass:[BYBaseNode class]]) {//如果已经序列化过了就直接添加到数组
            [tempArr addObject:childData];
        }else{
            NSDictionary * dict = (NSDictionary *)childData;
            if ([dict[@"sn"] isKindOfClass:[NSNull class]]) {
                BYGroupNode * groupNode = [[BYGroupNode alloc] initWithDictionary:dict error:nil];
                groupNode.flag = 1;
                groupNode.isExpand = NO;
                groupNode.level = level;
                groupNode.isGroup = YES;
                groupNode.isSelect = isSelect;
                
                [tempArr addObject:groupNode];
            }else{
                
                BYItemNode * itemNode = [[BYItemNode alloc] initWithDictionary:dict error:nil];
                itemNode.isExpand = NO;
                itemNode.level = level;
                itemNode.isGroup = NO;
                if (itemNode.expired) {
                    itemNode.isSelect = NO;
                }else{
                    itemNode.isSelect = isSelect;
                }
                [tempArr addObject:itemNode];
            }
        }
    }
    return tempArr;
}

-(void)initBase{
    
    self.naviSearchBar = [[BYSearchBar alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W * 0.65, 30)];
    self.naviSearchBar.backgroundColor = BYRGBColor(226, 231, 232);
    self.naviSearchBar.searchLabel.font = BYS_T_F(12);
    [self.navigationView addTitleView:self.naviSearchBar];
    BYWeakSelf;
    [self.naviSearchBar setSearchBlock:^{
        MobClickEvent(@"device_search", @"");
        BYControlSearchViewController *searchVC = [[BYControlSearchViewController alloc] init];
        searchVC.type = 2;
        [searchVC setSearchCallBack:^(NSString *searchStr) {
            if (searchStr.length > 0) {
                weakSelf.naviSearchBar.searchLabel.text = searchStr;
                weakSelf.naviSearchBar.searchLabel.textColor = [UIColor colorWithHex:@"#323232"];
            }else{
                weakSelf.naviSearchBar.searchLabel.text = @"搜索设备号、车牌号、车主姓名";
                weakSelf.naviSearchBar.searchLabel.textColor = [UIColor colorWithHex:@"#909090"];
            }

            if (searchStr.length > 0) {
                weakSelf.queryStr = searchStr;
                weakSelf.httpParams.groupName = nil;
                weakSelf.httpParams.deviceTypeIds = nil;
                weakSelf.httpParams.queryStr = searchStr;//当搜索时,其他条件都置为空,除了状态
                [weakSelf loadGroupData];//发送搜索请求
            }else{
                weakSelf.httpParams = nil;
                weakSelf.queryStr = nil;
                weakSelf.listHeader.isResetAll = YES;
                [weakSelf loadGroupData];
            }
        }];
        [weakSelf.navigationController pushViewController:searchVC animated:YES];
    }];
    [self.navigationView addRightButtonWithImage:[UIImage imageNamed:@"scan"] clickCallBack:^(UIView *view) {
        MobClickEvent(@"device_scan", @"");
        [weakSelf scanDeviceSN];
    }];
    [self.navigationView addRightButtonWithTitle:@"重置" clickCallBack:^(UIView *view) {
         MobClickEvent(@"device_rest", @"");
        [weakSelf resetAction];
    }];
    
    self.tableView.backgroundColor = BYGlobalBg;
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 120, 0);

    //tableViewHeader
    self.listHeader = [BYDeviceListHeader by_viewFromXib];
    self.listHeader.frame = CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, tableHeader_H);
    
    //选择在线类型
    [self.listHeader setOnlineTypeBlock:^(NSInteger onlineTag) {
        
        switch (onlineTag) {
            case 0: {
                weakSelf.httpParams.online = nil;
                weakSelf.httpParams.alarm = nil;
            }
                break;
            case 1:{
                weakSelf.httpParams.online = @"1";
                weakSelf.httpParams.alarm = nil;
            }
                break;
            case 2:{
                weakSelf.httpParams.online = @"0";
                weakSelf.httpParams.alarm = nil;
            }
                break;
            case 3:{
                weakSelf.httpParams.online = nil;
                weakSelf.httpParams.alarm = @"1";
            }
                break;
            default:
                break;
        }
        
        [weakSelf loadGroupData];
    }];
    
    //跳转到设备类型选择页面
    [self.listHeader setDeviceTypeSelectBlock:^{
        BYDeviceTypeSelectController * typeVC = [[BYDeviceTypeSelectController alloc] init];
        
        [typeVC setTypesBlock:^(NSMutableArray * types) {//设备类型数组回传

            weakSelf.httpParams.deviceTypeIds = types;
            
            [weakSelf loadGroupData];
            
        }];
        
        EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:typeVC];
        navi.modalPresentationStyle = UIModalPresentationFullScreen;
        [weakSelf presentViewController:navi animated:YES completion:nil];
        MobClickEvent(@"device_type", @"");
    }];
    
    //  添加观察者，监听键盘弹出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    //  添加观察者，监听键盘收起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    //  添加安装和拆机成功的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(demolishInstallSuccess:) name:BYDemolishInstallSuccessNotifiKey object:nil];

    //跳转到分组选择页面
    [self.listHeader setGroupSelectBlock:^{
        [weakSelf.alertView show];
        MobClickEvent(@"device_group", @"");
    }];
    
    [self.view addSubview:self.listHeader];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYListGroupCell class]) bundle:nil] forCellReuseIdentifier:groupCellID];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYListItemCell class]) bundle:nil] forCellReuseIdentifier:itemCellID];
    
}
#pragma mark -- 扫描设备号
-(void)scanDeviceSN{
    WQCodeScanner *scanner = [[WQCodeScanner alloc] init];
    scanner.scanType = WQCodeScannerTypeBarcode;
    scanner.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:scanner animated:YES completion:nil];
    [scanner setResultBlock:^(NSString *value) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [BYDeviceListHttpTool POSTQueryDeviceBySN:value Success:^(id data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BYDetailTabBarController * tabBarVC = [[BYDetailTabBarController alloc] init];
                    BYPushNaviModel * pushModel = [[BYPushNaviModel alloc] init];
                    pushModel.deviceId = [data[@"deviceId"] integerValue];
                    tabBarVC.model = pushModel;
                    tabBarVC.selectedIndex = 0;
                
                    [self.navigationController pushViewController:tabBarVC animated:YES];
                });
            }];
        });
    }];
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BYBaseNode * baseNode = self.displaySource[indexPath.row];
    
    BYWeakSelf;
    if (baseNode.isGroup) {//当前节点是组
        
        BYListGroupCell * groupCell = [tableView dequeueReusableCellWithIdentifier:groupCellID];
        groupCell.groupNode = (BYGroupNode *)baseNode;
        
        //左边选中按钮block
        [groupCell setSelectGroupBlock:^(BOOL isSelect) {
            
            //处理选中设备个数判断
            BYGroupNode * numberNode = (BYGroupNode *)baseNode;
            NSInteger number = weakSelf.controlItems.count + numberNode.number;
            
            if (isSelect) {//如果是选中状态并且选中组下的设备 + 已选设备个数大于20, 则直接返回, 并不能被选中
                if (number > selectItemsCount) {//如果当前组下的设备加上已选设备大于20台
                    numberNode.isSelect = NO;
                    [BYProgressHUD by_showErrorWithStatus:selectItemsTip];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    return ;
                }
                
                if (numberNode.flag && numberNode.number > 0 && numberNode.childs.count <= 0) {
                    numberNode.isSelect = NO;
                    [BYProgressHUD by_showErrorWithStatus:@"请先展开组再选择"];
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    return ;
                }
            }
            
            baseNode.isSelect = isSelect;
            
            //根据选中状态,找出该节点下的所有设备并添加和删除self.controlItems中的items
            [weakSelf findItemsAtParentNode:(BYGroupNode *)baseNode isSelect:isSelect];
            
            //改变该节点下的所有子节点选中状态
            [weakSelf enumerateChildNodesAtGroupNode:(BYGroupNode *)baseNode selectType:YES isSelect:isSelect];
            
            //改变该节点下的所有父节点的选中状态
            [weakSelf enumerateParentNodesAtGroupNode:baseNode isSelect:isSelect];
            
            [weakSelf.tableView reloadData];
        }];
        
        return groupCell;
        
    }else{//当前节点是设备
        
        BYListItemCell * itemCell = [tableView dequeueReusableCellWithIdentifier:itemCellID];
        BYItemNode * itemNode = (BYItemNode *)baseNode;
        itemCell.itemNode = itemNode;
        
        [itemCell setSelectItemBlock:^(BOOL isSelect) {//选中cell block实现
            
            if (isSelect) {//如果是选中
                if (itemNode.expired) {
                    itemNode.isSelect = NO;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    return BYShowError(@"服务期已到期，请联系客服");
                }
                if (weakSelf.controlItems.count == selectItemsCount) {//如果选中的数量已经达到20台,则选中状态改为NO
                    [BYProgressHUD by_showErrorWithStatus:selectItemsTip];
                    
                    itemNode.isSelect = NO;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    return ;
                    
                }else{
                    [weakSelf toolViewAnimateWith:YES model:itemNode];
                }
            }else{
                [weakSelf toolViewAnimateWith:NO model:itemNode];
            }
        
            baseNode.isSelect = isSelect;
            [weakSelf enumerateParentNodesAtGroupNode:baseNode isSelect:isSelect];
            [weakSelf.tableView reloadData];
        }];
        
        [itemCell setSelectCarBlock:^{
            
            if (itemNode.expired) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                return BYShowError(@"服务期已到期，请联系客服");
            }
            
            BYDetailTabBarController * detailTabVC = [[BYDetailTabBarController alloc] init];
            
            BYPushNaviModel * pushModel = [[BYPushNaviModel alloc] init];
            pushModel.deviceId = [itemNode.deviceId integerValue];
            pushModel.carNum = itemNode.carNum;
            pushModel.carVin = itemNode.carVin;
            pushModel.carId = itemNode.carId;
            pushModel.sn = itemNode.sn;
            pushModel.wifi = itemNode.wifi;
            pushModel.model = itemNode.model;
            pushModel.ownerName = itemNode.ownerName;

            detailTabVC.model = pushModel;
            [weakSelf.navigationController pushViewController:detailTabVC animated:YES];
        }];
        
        return itemCell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYBaseNode * baseNode = self.displaySource[indexPath.row];
    
    if (baseNode.isGroup) {//当前是节点是组
        
        BYGroupNode * groupNode = (BYGroupNode *)baseNode;
        groupNode.isExpand = !groupNode.isExpand;//是否展开

        if (groupNode.isExpand) {//当前节点是展开状态
            
            NSRange range = NSMakeRange(indexPath.row + 1, groupNode.childs.count);
            NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            
            if (groupNode.flag) {//如果flag为1,要先判断底下是设备还是组,如果是组则说明需要发送请求,如果是设备就不需要
                
                if (groupNode.childs.count == 0) {//如果数组为空,直接请求
//                    if (groupNode.childs.count > 0) {
                        [self loadItemDataWithGroupId:groupNode.groupId index:indexPath.row isSelect:groupNode.isSelect];
//                    }else{
//                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                    }
                }else{
                    id firstItem = [groupNode.childs firstObject];//取第一个元素
                    
                    if ([firstItem isKindOfClass:[NSDictionary class]]) {//如果是字典类型说明没有序列化过
                        NSDictionary * lastItem = [groupNode.childs lastObject];
                        
                        if (![firstItem[@"sn"] isKindOfClass:[NSNull class]] && ![lastItem[@"sn"] isKindOfClass:[NSNull class]]) {//通过判断底下list元素中是否包含sn,如果是就说明是设备
                            groupNode.flag = NO;
                            NSMutableArray * addArray = [self enumerateObjects:groupNode.childs level:groupNode.level + 1 isSelect:groupNode.isSelect];
                            groupNode.childs = addArray;
                            [self.displaySource insertObjects:addArray atIndexes:indexSet];
                            
                            [self.tableView reloadData];
                        }else{
                            
                            [self loadItemDataWithGroupId:groupNode.groupId index:indexPath.row isSelect:groupNode.isSelect];
                        }
                    }
                }
            }else{//如果flag为0,说明已经请求过了,并且数据存放在node.list中,直接取出
                if (groupNode.childs.count > 0) {//如果当前组下设备数量大于0
                    id firstItem = [groupNode.childs firstObject];//取第一个元素
                    
                    if ([firstItem isKindOfClass:[NSDictionary class]]) {//如果是字典类型说明没有序列化过
                        
                        NSMutableArray * addArray = [self enumerateObjects:groupNode.childs level:groupNode.level + 1 isSelect:groupNode.isSelect];
                        groupNode.childs = addArray;
                    }
                    
                    [self.displaySource insertObjects:groupNode.childs atIndexes:indexSet];
                    
                    [self.tableView reloadData];
                    
                }else{
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }else{//当前节点是合并状态
            
            [self enumerateChildNodesAtGroupNode:groupNode selectType:NO isSelect:NO];
            [self.tableView reloadData];
        }
    }else{//当前节点是设备
        
        BYItemNode * itemNode = (BYItemNode *)baseNode;
        
        if (itemNode.expired) {
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            return BYShowError(@"服务期已到期，请联系客服");
        }else{
            BYDetailTabBarController * tabBarVC = [[BYDetailTabBarController alloc] init];
            BYPushNaviModel * pushModel = [[BYPushNaviModel alloc] init];
            pushModel.deviceId = [itemNode.deviceId integerValue];
            pushModel.carNum = itemNode.carNum;
            pushModel.carVin = itemNode.carVin;
            pushModel.carId = itemNode.carId;
            pushModel.sn = itemNode.sn;
            pushModel.wifi = itemNode.wifi;
            pushModel.model = itemNode.model;
            pushModel.ownerName = itemNode.ownerName;
            pushModel.batteryNotifier = itemNode.batteryNotifier;
            
            tabBarVC.model = pushModel;
            tabBarVC.selectedIndex = 1;
            [self.navigationController pushViewController:tabBarVC animated:YES];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
}

//根据子节点找到其父节点并进行选中状态改变
-(void)enumerateParentNodesAtGroupNode:(BYBaseNode *)childNode isSelect:(BOOL)isSelect{
    
    if (childNode.level == 0) {//如果是根节点,直接返回
        return;
    }
    
    NSInteger index = [self.displaySource indexOfObject:childNode];//开始位置下标
    
    for (NSInteger i = index - 1; i >= 0; i --) {
        
        BYBaseNode * parentNode = [self.displaySource objectAtIndex:i];
        
        if (childNode.parentId == parentNode.groupId) {//如果找到父节点的groupId,则修改选中状态
 
            if (isSelect == NO) {//如果是反选,则要判断父节点是否要选中
                
                for (NSInteger j = i + 1; j < self.displaySource.count; j ++) {
                    BYBaseNode * sameLevelNode = [self.displaySource objectAtIndex:j];
                    
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

//遍历displaySource父节点下的所有子节点(包括孙节点)
-(void)enumerateChildNodesAtGroupNode:(BYGroupNode *)groupNode selectType:(BOOL)selectType isSelect:(BOOL)isSelect{
    
    NSInteger startIndex = [self.displaySource indexOfObject:groupNode];//开始位置下标
    
    NSInteger endIndex = startIndex;//结束位置下标
    
    //开始下标加1开始遍历
    for (NSInteger i = startIndex+1; i<self.displaySource.count; i++) {
        
        BYBaseNode * baseNode = [self.displaySource objectAtIndex:i];//取出下标为i的节点
        
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.displaySource.count;
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length == 0) {
        [BYProgressHUD by_showErrorWithStatus:@"搜索内容不能为空"];
        return YES;
    }
    [textField resignFirstResponder];
    
    self.httpParams.groupName = nil;
    self.httpParams.deviceTypeIds = nil;
    self.httpParams.queryStr = textField.text;//当搜索时,其他条件都置为空,除了状态
    [self loadGroupData];
    return YES;
}

#pragma mark - 前往设备追踪页面
-(void)resetAction{//点击重置按钮,清空所有查询条件重新加载
    self.naviSearchBar.searchLabel.text = @"搜索设备号、车牌号、车主姓名";
    self.naviSearchBar.searchLabel.textColor = [UIColor colorWithHex:@"#909090"];
    self.httpParams = nil;
    self.queryStr = nil;
    self.listHeader.isResetAll = YES;
    [self loadGroupData];
}

//工具条的显示和隐藏
- (void)toolViewAnimateWith:(BOOL)isSelect model:(BYItemNode *)itemNode{
    
    if (isSelect) {
        [self.controlItems addObject:itemNode.deviceId];
    }else{
        [self.controlItems removeObject:itemNode.deviceId];
    }
    
    self.toolView.title = [NSString stringWithFormat:@"已选(%zd),点击进入监控页面",self.controlItems.count];;
    
    CGRect frame = self.toolView.frame;
    CGFloat originY = BYSCREEN_H - toolView_H;
    frame.origin.y = self.controlItems.count >= 1 ? originY : BYSCREEN_H;
    [UIView animateWithDuration:0.3 animations:^{
        self.toolView.frame = frame;
    }];
}

#pragma mark - lazy
-(BYAlarmToolView *)toolView{
    if (_toolView == nil) {
        _toolView = [BYAlarmToolView by_viewFromXib];
        _toolView.frame = CGRectMake(0, BYSCREEN_H, BYSCREEN_W, toolView_H);
        _toolView.handleButtonContraint_W.constant = BYSCREEN_W / 2 + 10;
        BYWeakSelf;
        [_toolView setHandleBlock:^{//点击弹窗
//            NSMutableArray *deviceIdArr = [NSMutableArray array];
//            for (BYItemNode *itemNode in weakSelf.controlItems) {
//                [deviceIdArr addObject:itemNode.deviceId];
//            }
            

            BYControlViewController * controlVC = [[BYControlViewController alloc] init];
            controlVC.isNaviPush = YES;
            controlVC.deviceIdsStr = [weakSelf.controlItems componentsJoinedByString:@","];
            [weakSelf.navigationController pushViewController:controlVC animated:YES];

            
        }];
        
        [self.view addSubview:_toolView];
    }
    return _toolView;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, tableHeader_H + SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - tableHeader_H) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = BYS_W_H(44);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(BYAlertView *)alertView{
    if (_alertView == nil) {
        _alertView = [BYAlertView viewFromNibWithTitle:@"分组查询" message:nil];
        _alertView.alertHeightContraint.constant = BYS_W_H(170);
        _alertView.alertWidthContraint.constant = BYS_W_H(240);

        CGFloat margin = 10;
        CGFloat textField_H = 35;
        
        self.groupSearchBar = [[BYGroupSearchBar alloc] init];
        
        self.groupSearchBar.by_x = margin;
        self.groupSearchBar.by_y = BYS_W_H(170 - 80) /2 -BYS_W_H(textField_H) / 2;
        self.groupSearchBar.by_width = BYS_W_H(240) - 2 * margin;
        self.groupSearchBar.by_height = BYS_W_H(textField_H);
                
        BYWeakSelf;
        [_alertView setSureBlock:^{
            _alertView = nil;
            if (weakSelf.groupSearchBar.text.length == 0) {
                return [BYProgressHUD by_showErrorWithStatus:@"搜索分组不能为空"];
            }
            weakSelf.httpParams.groupName = weakSelf.groupSearchBar.text;
            [weakSelf loadGroupData];
        }];
        
        [_alertView setCancelBlock:^{
            _alertView = nil;
        }];
        
        [_alertView.contentView addSubview:_groupSearchBar];
    }
    return _alertView;
}

-(NSMutableArray *)displaySource{
    if (_displaySource == nil) {
        _displaySource = [[NSMutableArray alloc] init];
    }
    return _displaySource;
}

-(NSMutableArray *)controlItems{
    if (_controlItems == nil) {
        _controlItems = [[NSMutableArray alloc] init];
    }
    return _controlItems;
}

-(BYDeviceListHttpParams *)httpParams{
    if (_httpParams == nil) {
        _httpParams = [[BYDeviceListHttpParams alloc] init];
    }
    return _httpParams;
}

// 层次遍历 -> 找出组下所有设备
-(void)findItemsAtParentNode:(BYGroupNode *)groupNode isSelect:(BOOL)isSelect{
    
    NSMutableArray * queueArray = [NSMutableArray array];
    if (groupNode.childs.count > 0) {//只遍历list.count大于0的节点
        if (groupNode.isExpand) {//通过当前节点的展开状态来判断所添加的子节点,展开就将选中的子节点添加,合并则将子节点全部添加
            if (!isSelect) {//如果是父节点是选中状态,只添加选中的子节点
                for (BYBaseNode * baseNode in groupNode.childs) {
                    if (baseNode.isSelect) {
                        [queueArray addObject:baseNode];
                    }
                }
            }else{////如果是父节点不是选中状态,添加所有子节点
                [queueArray addObjectsFromArray:groupNode.childs];
            }
        }else{
            id firstItem = [groupNode.childs firstObject];//取出第一个元素判断是否序列化
            if ([firstItem isKindOfClass:[NSDictionary class]]) {
                [queueArray addObjectsFromArray:[self enumerateObjects:groupNode.childs level:groupNode.level+1 isSelect:isSelect]];
//                [self.tableView reloadData];
            }else{//说明已经序列化了,需要改变其状态
                for (BYBaseNode * baseNode in groupNode.childs) {
                    baseNode.isSelect = isSelect;
                }
                [queueArray addObjectsFromArray:groupNode.childs];
            }
        }
    }
    
    while (queueArray.count > 0) {
        
        BYBaseNode * queueNode = [queueArray firstObject];
        BYWeakSelf;
        if (!queueNode.isGroup) {//如果是设备
            BYItemNode * itemNode = (BYItemNode *)queueNode;
//            if (itemNode.expired) {
////                queueNode.isSelect = NO;
////                [weakSelf.tableView reloadData];
////                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                return BYShowError(@"服务期已到期，请联系客服");
//            }
            [self toolViewAnimateWith:isSelect model:itemNode];//点击组时向controlItems添加或删除设备,进而决定toolView的展示和隐藏
            
        }else{//如果是组
            
            BYGroupNode * childGroupNode = (BYGroupNode *)queueNode;
            
            if (childGroupNode.childs.count > 0) {
                
                if (childGroupNode.isExpand) {//通过当前节点的展开状态来判断说添加的子节点,展开就讲选中的子节点添加,合并则将子节点全部添加
                    if (!isSelect) {//如果是父节点是选中状态,只添加选中的子节点
                        for (BYBaseNode * baseNode in childGroupNode.childs) {
                            if (baseNode.isSelect) {
                                [queueArray addObject:baseNode];
                            }
                        }
                    }else{////如果是父节点不是选中状态,添加所有子节点
                        [queueArray addObjectsFromArray:childGroupNode.childs];
                    }
                }else{
                    id firstItem = [childGroupNode.childs firstObject];//取出第一个元素判断是否序列化
                    if ([firstItem isKindOfClass:[NSDictionary class]]) {
                        [queueArray addObjectsFromArray:[self enumerateObjects:childGroupNode.childs level:childGroupNode.level+1 isSelect:isSelect]];
//                        [self.tableView reloadData];
                    }else{//说明已经序列化了,需要改变其状态
                        for (BYBaseNode * baseNode in childGroupNode.childs) {
                            baseNode.isSelect = isSelect;
                        }
                        [queueArray addObjectsFromArray:childGroupNode.childs];
                    }
                }
            }
        }
        [queueArray removeObjectAtIndex:0];
    }
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.naviSearchBar.searchField resignFirstResponder];
//}
//
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.naviSearchBar.searchField resignFirstResponder];
//}

- (void)keyBoardDidShow:(NSNotification *)notifiction {
    
    if (self.alertView && self.alertView.alert.by_centerY == BYSCREEN_H / 2) {
        
        // 取得键盘的动画时间，这样可以在视图上移的时候更连贯
        double duration = [[notifiction.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        CGRect frame = self.alertView.alert.frame;
        frame.origin.y -= BYTextFieldPullUpHeight;
        [UIView animateWithDuration:duration animations:^{
            
            self.alertView.alert.frame = frame;
        }];
    }
}

- (void)keyBoardDidHide:(NSNotification *)notification {
    if (self.alertView) {
        
        CGRect frame = self.alertView.alert.frame;
        frame.origin.y += BYTextFieldPullUpHeight;
        [UIView animateWithDuration:0.1 animations:^{
            
            self.alertView.alert.frame = frame;
        }];
    }
}

-(void)demolishInstallSuccess:(NSNotification *)noti{
    [self loadGroupData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BYDemolishInstallSuccessNotifiKey object:nil];
}

@end
