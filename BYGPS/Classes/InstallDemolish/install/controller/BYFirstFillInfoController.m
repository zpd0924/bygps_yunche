//
//  BYFillInfoeController.m
//  父子控制器
//
//  Created by miwer on 2016/12/21.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYFirstFillInfoController.h"
#import "BYInstallHeaderView.h"
#import "BYInstallSectionHeaderView.h"
#import "BYInstallTextFiledCell.h"
#import "BYInstallModel.h"
#import "UIButton+BYFooterButton.h"
#import "BYInstallButtonCell.h"
#import "BYCarNumTextFieldCell.h"
#import "BYColorSelectController.h"
#import "BYCarNumSelectController.h"
#import "BYSecondFillInfoController.h"
#import "BYRegularTool.h"
#import "EasyNavigation.h"

#import "NSString+BYAttributeString.h"

@interface BYFirstFillInfoController ()

@property(nonatomic,strong) NSMutableArray * dataSource;
@property(nonatomic,strong) NSArray * colorSource;

//@property(nonatomic,assign) BOOL isHaveCarNum;//该车是否有车牌

@property (nonatomic,assign) BOOL isFillCarNum;
@property (nonatomic,assign) BOOL isFillVINNum;

@end

@implementation BYFirstFillInfoController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    BYStatusBarLight;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    BYStatusBarDefault;
}


- (instancetype)init
{
    if (@available(iOS 11.0, *)) {
    UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initBase];
    
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initBase{
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationView setTitle:@"录入资料"];
//    self.navigationView.titleLabel.textColor = [UIColor whiteColor];
//    [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
    //    self.isHaveCarNum = YES;//该车有车牌
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (![BYSaveTool isContainsKey:BYInstallCityKey]) {
        [BYSaveTool setValue:@"粤B" forKey:BYInstallCityKey];
    }//默认是粤B
//    BYWeakSelf;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView removeAllLeftButton];
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//    });
    //添加headerView
    UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, 164)];
    self.tableView.tableHeaderView = header;
    
    BYInstallHeaderView * tableHeader = [BYInstallHeaderView by_viewFromXib];
    tableHeader.frame = CGRectMake(0, 64, BYSCREEN_W, 100);
    [header addSubview:tableHeader];
    
    BYInstallModel * model1 = [BYInstallModel createModelWith:@"车牌号" placeholder:@"输入五位英文和数字" isNecessary:NO postKey:@"carNum"];
    BYInstallModel * model2 = [BYInstallModel createModelWith:@"车架号" placeholder:@"请输入17位车架号" isNecessary:NO postKey:@"carVin"];
    BYInstallModel * model3 = [BYInstallModel createModelWith:@"*车主姓名" placeholder:@"请输入车主姓名" isNecessary:YES postKey:@"ownerName"];
    BYInstallModel * model4 = [BYInstallModel createModelWith:@"*车牌品牌" placeholder:@"如:宝马" isNecessary:YES postKey:@"carBrand"];
    BYInstallModel * model5 = [BYInstallModel createModelWith:@"*车辆型号" placeholder:@"如:5系GT" isNecessary:YES postKey:@"carType"];
    BYInstallModel * model6 = [BYInstallModel createModelWith:@"*车牌颜色" placeholder:@"请选择车辆颜色" isNecessary:YES postKey:@"carColor"];
    BYInstallModel * model7 = [BYInstallModel createModelWith:@"业务姓名" placeholder:@"请输入业务员姓名" isNecessary:NO postKey:@"salesMan"];
    
    [self.dataSource addObject:model1];
    [self.dataSource addObject:model2];
    [self.dataSource addObject:model3];
    [self.dataSource addObject:model4];
    [self.dataSource addObject:model5];
    [self.dataSource addObject:model6];
    [self.dataSource addObject:model7];
    
    self.colorSource = @[@"黑色",@"红色",@"深灰色",@"粉红色",@"银灰色",@"紫色",@"白色",@"蓝色",@"香槟色",@"绿色",@"黄色",@"咖啡色",@"橙色",@"多彩色",@"其他"];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYInstallTextFiledCell class]) bundle:nil] forCellReuseIdentifier:@"textFieldCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYInstallButtonCell class]) bundle:nil] forCellReuseIdentifier:@"buttonCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYCarNumTextFieldCell class]) bundle:nil] forCellReuseIdentifier:@"carNumCell"];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYInstallModel * model = self.dataSource[indexPath.row];
    
    if (indexPath.row == 0) {
        BYCarNumTextFieldCell * carTextFieldCell = [tableView dequeueReusableCellWithIdentifier:@"carNumCell"];
        carTextFieldCell.model = model;
        //        carTextFieldCell.carNum = self.isHaveCarNum ? [BYSaveTool valueForKey:BYInstallCityKey] : nil;
        carTextFieldCell.carNum = [BYSaveTool valueForKey:BYInstallCityKey];
        
        __weak typeof(carTextFieldCell) weakCarTextFieldCell= carTextFieldCell;
        [carTextFieldCell setCarNumSelectBlock:^ (NSString * carNum){
            BYCarNumSelectController * carNumVc = [[BYCarNumSelectController alloc] init];
            carNumVc.carNum = carNum;
            
            [carNumVc setCitySelectBlock:^(NSString *provinceAndCity) {
                weakCarTextFieldCell.carNum = provinceAndCity;
                [BYSaveTool setValue:provinceAndCity forKey:BYInstallCityKey];
            }];
            
            [self.navigationController pushViewController:carNumVc animated:YES];
        }];
        
        [carTextFieldCell setShouldEndInputBlock:^(NSString * input) {
            //拼接车牌号
            //            model.subTitle = _isHaveCarNum ? [NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYInstallCityKey],input] : input;
            
            model.subTitle = input.length ? [NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYInstallCityKey],[NSString toUpper:input]] : input;
            model.isFilled = input.length ? YES : NO;
            BYLog(@"%zd",model.isFilled);
        }];
        
        return carTextFieldCell;
    }else if (indexPath.row == 5) {
        BYInstallButtonCell * buttonCell = [tableView dequeueReusableCellWithIdentifier:@"buttonCell"];
        buttonCell.model = model;
        return buttonCell;
    }
    
    BYInstallTextFiledCell * textFieldCell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell"];
    textFieldCell.model = model;
    [textFieldCell setShouldEndInputBlock:^(NSString *input) {
        model.subTitle = indexPath.row == 1 ? [NSString toUpper:input] : input;
        model.isFilled = input.length ? YES : NO;
    }];
    return textFieldCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.row == 5) {
        BYColorSelectController * colorVc = [[BYColorSelectController alloc] init];
        
        [colorVc setColorItemSelectBlock:^(NSInteger tag) {
            BYInstallModel * model = self.dataSource[indexPath.row];
            model.subTitle = self.colorSource[tag];
            [self.tableView reloadData];
        }];
        
        [self.navigationController pushViewController:colorVc animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    BYInstallSectionHeaderView * header = [BYInstallSectionHeaderView by_viewFromXib];
    header.title = @"车辆信息和车主信息";//(❗️车牌号与车架号必填一项)
    //    header.isShowButton = YES;
    //    [header setNoCarNumBlock:^{
    //        self.isHaveCarNum = !self.isHaveCarNum;
    //        BYInstallModel * model = self.dataSource.firstObject;
    //        if (self.isHaveCarNum) {
    //            model.title = @"*车牌号";
    //            model.placeholder = @"输入五位英文和数字";
    //        }else{
    //            model.title = @"*车架号";
    //            model.placeholder = @"输入17位英文和数字";
    //        }
    //        [self.tableView reloadData];
    //    }];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BYS_W_H(50);
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc] init];
    UIButton * button = [UIButton buttonWithMargin:20 backgroundColor:BYGlobalBlueColor title:@"确认,下一步" target:self action:@selector(nextAction)];
    [view addSubview:button];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return BYS_W_H(50);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return BYS_W_H(44);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - lazy
-(NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

-(void)nextAction{
    
    [self.view endEditing:YES];
    
    BYInstallModel * model0 = self.dataSource[0];
    BYInstallModel * model1 = self.dataSource[1];
    
    if (!model0.isFilled && !model1.isFilled) {
        return [BYProgressHUD by_showErrorWithStatus:@"车牌号与车架号必填一项"];
    }
    
    //先判断是否所有必填数据都已经填了
    for (BYInstallModel * model in self.dataSource) {
        
        NSInteger index = [self.dataSource indexOfObject:model];

        if (index == 0) {
            if (model.isFilled) {
                if (![BYRegularTool validateCarNum:model.subTitle letterNum:4] && ![BYRegularTool validateCarNum:model.subTitle letterNum:5]) {
                    return [BYProgressHUD by_showErrorWithStatus:@"请输入正确的车牌号"];
                }
            }
        }else if (index == 1) {
            if (model.isFilled) {
                if (![BYRegularTool validateVIN:model.subTitle]) {
                    return [BYProgressHUD by_showErrorWithStatus:@"请输入正确的车架号"];
                }
            }
        }else{
            //如果输入内容长度大于20
            if (model.subTitle.length > 20) {
                NSString * resultTitle = model.isNecessary ? [model.title substringFromIndex:1] : model.title;
                
                return [BYProgressHUD by_showErrorWithStatus:[NSString stringWithFormat:@"%@长度不能大于20",resultTitle]];
            }
            //如果是必传和输入内容为空
            if (model.isNecessary && !model.subTitle.length) {
                if ([model.title rangeOfString:@"颜色"].location != NSNotFound) {
                    return [BYProgressHUD by_showErrorWithStatus:[NSString stringWithFormat:@"请选择%@",[model.title substringFromIndex:1]]];
                    
                }else{
                    return [BYProgressHUD by_showErrorWithStatus:[NSString stringWithFormat:@"请输入%@",[model.title substringFromIndex:1]]];
                }
            }
        }
        
        BYLog(@"title : %@ - subtitle : %@",model.title,model.subTitle);
        
    }
    
    BYSecondFillInfoController * secondVc = [[BYSecondFillInfoController alloc] init];
    secondVc.carInfoData = [NSMutableArray array];
    secondVc.carInfoData = self.dataSource;
    secondVc.deviceId = self.deviceId;
    secondVc.isWirless = self.isWirless;
    [self.navigationController pushViewController:secondVc animated:YES];
}




@end
