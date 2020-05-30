//
//  BYAddWithoutController.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYAddWithoutController.h"
#import "BYAddWithoutCell.h"
#import "EasyNavigation.h"
#import "BYShareUserModel.h"
#import "UIButton+HNVerBut.h"
#import "BYInsideListViewController.h"


@interface BYAddWithoutController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *addView;
@end

@implementation BYAddWithoutController

- (void)backAction{
    if (_shareAddType == BYInsideType) {//内部人员判断
          [self.navigationController popViewControllerAnimated:YES];
    }else{//外部人员判断
          [self.navigationController popViewControllerAnimated:YES];
    }
  
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationView setTitle:_shareAddType==1?@"外部人员":@"内部员工"];
    [self initBase];
    //默认增加一条数据
     if (_shareAddType == BYWithoutType) {
         if (_paramModel.shareMobile.count == 0) {
              [self add];
         }
        
    }
}
- (void)initBase{
    self.view.backgroundColor = UIColorRGB(244, 244, 244, 1.0);
    BYWeakSelf;
    [self.view addSubview:self.bottomView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.navigationView.titleLabel setTextColor:UIColorHexFromRGB(0x333333)];
        [weakSelf.navigationView setNavigationBackgroundColor:WHITE];
        [weakSelf.navigationView removeAllLeftButton];
        
        [weakSelf.navigationView addRightView:self.addView clickCallback:^(UIView *view) {
            [weakSelf add];
        }];
        [weakSelf.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left"] clickCallBack:^(UIView *view) {
            [weakSelf backAction];
        }];
        
    });
    
    [self.view addSubview:self.tableView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark -- 增加人员
- (void)add{
 
    
    BYWeakSelf;
    if (_shareAddType == BYInsideType) {//内部人员添加
        
        if (_paramModel.shareLine.count >= 50) {
            BYShowError(@"最多只能添加50人");
            return;
        }
        BYInsideListViewController *vc = [[BYInsideListViewController alloc] init];
        vc.paramModel = _paramModel;
        vc.insideListAddPersonBlock = ^(BYShareCommitParamModel *paramModel) {//选中的内部员工
            [weakSelf.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else{//外部人员添加
        
        if (_paramModel.shareMobile.count >= 50) {
            BYShowError(@"最多只能添加50人");
            return;
        }
        BYShareUserModel *model = [[BYShareUserModel alloc] init];
        [_paramModel.shareMobile addObject:model];
    }
    [self.tableView reloadData];
}
#pragma mark -- 保存
- (void)saveBtn{
    if (_shareAddType == BYInsideType) {//内部人员判断
    
        NSMutableArray *insideArr = [NSMutableArray array];
        NSMutableArray *tempUserIdArr = [NSMutableArray array];
         NSMutableArray *tempUserNameArr = [NSMutableArray array];
         NSMutableArray *tempLoginNameArr = [NSMutableArray array];
        for (BYShareUserModel *model in _paramModel.shareLine) {
    
            [insideArr addObject:model.receiveShareUserId];
        }
        //去除重复的外部人员
        for (int i = 0; i<_paramModel.shareLine.count; i++) {
            BYShareUserModel *model = _paramModel.shareLine[i];
            if (![tempUserIdArr containsObject:insideArr[i]]) {
                [tempUserIdArr addObject:model.receiveShareUserId];
                [tempUserNameArr addObject:model.receiveShareUserName];
                [tempLoginNameArr addObject:model.userName];
            }
        }
        NSMutableArray *arr = [NSMutableArray array];
         for (int i = 0; i<tempUserIdArr.count; i++)  {
            BYShareUserModel *userModel = [[BYShareUserModel alloc] init];
            userModel.receiveShareUserId = tempUserIdArr[i];
            userModel.receiveShareUserName = tempUserNameArr[i];
             userModel.userName = tempLoginNameArr[i];
            [arr addObject:userModel];
        }
        self.paramModel.shareLine = arr;

    }else{//外部人员判断
        NSMutableArray *mobileArr = [NSMutableArray array];
        NSMutableArray *tempArr = [NSMutableArray array];
        for (BYShareUserModel *model in _paramModel.shareMobile) {
            if (model.mobile.length == 0) {
                BYShowError(@"还有用户没有填写手机号码");
                return;
            }
            if (!model.isValid) {
                BYShowError(@"有手机号码格式不正确");
                return;
            }
            [mobileArr addObject:model.mobile];
        }
        
        //去除重复的外部人员
        for (int i = 0; i<_paramModel.shareMobile.count; i++) {
            BYShareUserModel *model = _paramModel.shareMobile[i];
            if (![tempArr containsObject:mobileArr[i]]) {
                [tempArr addObject:model.mobile];
            }
        }
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *mobile in tempArr) {
            BYShareUserModel *model = [[BYShareUserModel alloc] init];
            model.isValid = YES;
            model.mobile = mobile;
            [arr addObject:model];
        }
        self.paramModel.shareMobile = arr;
        
        
    }
  
    if (self.addPersonBlock) {
        self.addPersonBlock(self.paramModel);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- tableview 数据源 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_shareAddType == BYInsideType){
         return _paramModel.shareLine.count;
    }else{
         return _paramModel.shareMobile.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BYWeakSelf;
    BYAddWithoutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BYAddWithoutCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.shareAddType = _shareAddType;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_shareAddType == BYInsideType){
        
        cell.insideModel = _paramModel.shareLine[indexPath.row];
        cell.cellDelectBlcok = ^(BYShareUserModel *model) {
            [weakSelf.paramModel.shareLine removeObject:model];
             [weakSelf.tableView reloadData];
        };
    }else{
        cell.withoutModel = _paramModel.shareMobile[indexPath.row];
        cell.cellEditEndBlock = ^(BYShareUserModel *withoutModel) {
            [weakSelf.paramModel.shareMobile replaceObjectAtIndex:indexPath.row withObject:withoutModel];
            [weakSelf.tableView reloadData];
        };
        cell.cellDelectBlcok = ^(BYShareUserModel *withoutModel) {
            [weakSelf.paramModel.shareMobile removeObject:withoutModel];
             [weakSelf.tableView reloadData];
        };
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (_shareAddType == BYInsideType){//内部
        return 50.0f;
    }else{//外部
        BYShareUserModel *model = _paramModel.shareMobile[indexPath.row];
        if (model.mobile.length && !model.isValid) {
            return 90.0f;
        }else{
            return 50.0f;
        }
    }
  
}


#pragma mark --LAZY

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H - SafeAreaTopHeight - 80) style:UITableViewStylePlain];
        _tableView.backgroundColor = BYBigSpaceColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [UIView new];
        BYRegisterCell(BYAddWithoutCell);
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}


-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, MAXHEIGHT - 80, MAXWIDTH, 80)];
        _bottomView.backgroundColor = BYBigSpaceColor;
        UIButton *btn = [UIButton verBut:@"保存" textFont:17 titleColor:WHITE bkgColor:BYGlobalBlueColor];
        btn.layer.cornerRadius = 6.0f;
        btn.layer.masksToBounds = YES;
        btn.frame = CGRectMake(10, 20, MAXWIDTH - 20, 40);
        [btn addTarget:self action:@selector(saveBtn) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:btn];
        
        
    }
    return _bottomView;
}
#pragma mrak -- nodata
- (UIImage *)xy_noDataViewImage {
    return [UIImage imageNamed:@"no_order"];
}

- (NSString *)xy_noDataViewMessage {
    return @"还没有添加人员哦!请点击右上角添加！";
}

- (UIColor *)xy_noDataViewMessageColor {
    return BYLabelBlackColor;
}
- (NSNumber *)xy_noDataViewCenterYOffset{
    
    return [NSNumber numberWithInteger:0];
}
-(UIView *)addView
{
    if (!_addView) {
        _addView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        UILabel *label = [UILabel verLab:15 textRgbColor:BYGlobalBlueColor textAlighment:NSTextAlignmentCenter];
        label.text = @"添加";
        [_addView addSubview:label];
        label.frame = _addView.bounds;
    }
    return _addView;
}

@end
