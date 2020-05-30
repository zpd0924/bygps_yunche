//
//  BYMyWorkOrderController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderController.h"
#import "EasyNavigation.h"
#import "UIButton+HNVerBut.h"
#import "BYNaviSearchBar.h"
#import "BYMyAllWorkOrderController.h"
#import "BYMyWaitCheckWorkOrderController.h"
#import "BYMyTimeoutWorkOrderController.h"
#import "BYMyNotTakeWorkOrderController.h"
#import "BYMyCompleteWorkOrderViewController.h"
#import "BYMyWorkOrderScreenViewController.h"
#import "BYScreenParameterModel.h"
#import "BYHomeViewController.h"
#import "BYInstallSendOrderController.h"

@interface BYMyWorkOrderController ()<UITextFieldDelegate>

@property (nonatomic,strong) BYMyAllWorkOrderController *vc1;
@property (nonatomic,strong) BYMyWaitCheckWorkOrderController *vc2;
@property (nonatomic,strong) BYMyTimeoutWorkOrderController *vc3;
@property (nonatomic,strong) BYMyNotTakeWorkOrderController *vc4;
@property (nonatomic,strong) BYMyCompleteWorkOrderViewController *vc5;

@property (nonatomic,strong) BYScreenParameterModel *screenParameterModel;


@end

@implementation BYMyWorkOrderController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
    if (!_model) {
        [self loadData];
    }
   
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}
- (void)setRow:(NSInteger)row{
    _row = row;
    self.selectIndex = row;
}
-(void)backAction{
    if (self.navigationController.viewControllers.count > 3) {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[BYInstallSendOrderController class]]) {
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
        
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 获取工单数量数据
- (void)loadData{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"groupId"] = [BYSaveTool objectForKey:groupId];
    [BYSendWorkHttpTool POSTAppointOrderCountParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.model = [[BYInstallSendOrderCountModel alloc] initWithDictionary:data error:nil];
            weakSelf.vc2.title = [NSString stringWithFormat:@"待审核%zd",weakSelf.model.isNotuditing];
            [weakSelf refreshDisplay];
        });
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- 筛选
- (void)screenBtnClick{
    
    BYWeakSelf;
    BYMyWorkOrderScreenViewController *vc1 = [[BYMyWorkOrderScreenViewController alloc] init];
    vc1.myWorkOrderScreenBlock = ^(BYScreenParameterModel *model) {
        BYLog(@"%@",model);
        weakSelf.vc1.isScreen = YES;
        weakSelf.vc1.model = model;
         weakSelf.selectIndex = 0;
    };
    vc1.view.backgroundColor = [UIColor clearColor];
    vc1.modalPresentationStyle=
    UIModalPresentationOverCurrentContext|UIModalPresentationFullScreen;
    [vc1 setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    vc1.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:vc1 animated:YES completion:^{
        vc1.view.backgroundColor = [UIColor clearColor];
        
    }];
    
}

-(void)initBase{
    [self.navigationView setTitle:@"我的工单"];
    self.view.backgroundColor = BYBigSpaceColor;
//    self.navigationView.titleLabel.textColor = [UIColor whiteColor];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView removeAllLeftButton];
//        BYWeakSelf;
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//    });
    [self setSearchView];
    // 添加所有子控制器
    [self setUpAllViewController];
    
    self.isfullScreen = NO;
   
    
   
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        
        *norColor = [UIColor whiteColor];
        *selColor = [UIColor whiteColor];
        *titleWidth = BYSCREEN_W / 5;
    }];
    
    // 标题渐变
    // *推荐方式(设置标题渐变)
    [self setUpTitleGradient:^(YZTitleColorGradientStyle *titleColorGradientStyle, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor) {
        *norColor = [UIColor blackColor];
        *selColor = BYGlobalBlueColor;
    }];
    
    [self setUpUnderLineEffect:^(BOOL *isUnderLineDelayScroll, CGFloat *underLineH, UIColor *__autoreleasing *underLineColor,BOOL *isUnderLineEqualTitleWidth) {
        
        *underLineColor = BYGlobalBlueColor;
        *isUnderLineDelayScroll = NO;
        //        *isUnderLineEqualTitleWidth = YES;
    }];
    
    self.isfullScreen = NO;
    [self setUpContentViewFrame:^(UIView *contentView) {
        contentView.frame = CGRectMake(0, 50 + SafeAreaTopHeight, MAXWIDTH, MAXHEIGHT - 50 - SafeAreaTopHeight);
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeySearch;    
    [textField resignFirstResponder];
    self.vc1.keyWord = textField.text;
    self.selectIndex = 0;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    self.vc1.keyWord = textField.text;
    self.selectIndex = 0;
}

- (void)setSearchView{
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, MAXWIDTH, 50)];
        view.backgroundColor = WHITE;
        BYNaviSearchBar *search = [[BYNaviSearchBar alloc] initWithFrame:CGRectMake(10, 10, MAXWIDTH - 65, 30)];
    search.searchField.delegate = self;
    search.searchField.placeholder = @"请输入车牌号/车架号";
        UIButton *screenBtn = [UIButton verBut:nil textFont:15 titleColor:[UIColor blackColor] bkgColor:nil];
    [screenBtn setImage:[UIImage imageNamed:@"screenBtn"] forState:UIControlStateNormal];
        [screenBtn addTarget:self action:@selector(screenBtnClick) forControlEvents:UIControlEventTouchUpInside];
        screenBtn.frame = CGRectMake(MAXWIDTH - 50, 0, 50, 50);
        [view addSubview:search];
        [view addSubview:screenBtn];
        [self.view addSubview:view];
    
    
}

// 添加所有子控制器
- (void)setUpAllViewController{
    BYWeakSelf;
    self.vc1.title =@"全部";
    self.vc2.title = [NSString stringWithFormat:@"待审核%zd",_model.isNotuditing];
    self.vc2.myWaitCheckWorkBlock = ^(NSInteger index) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.vc2.title = [NSString stringWithFormat:@"待审核%zd",index];
            weakSelf.selectIndex = 1;
            [weakSelf refreshDisplay];
        });
       
        
    };
    self.vc3.title = @"不通过";
    self.vc4.title = @"待接单";
    self.vc5.title = @"已完成";
    
    [self addChildViewController:self.vc1];
    [self addChildViewController:self.vc2];
    [self addChildViewController:self.vc3];
    [self addChildViewController:self.vc4];
    [self addChildViewController:self.vc5];
}

#pragma mark -- lazy

-(BYMyAllWorkOrderController *)vc1
{
    if (!_vc1) {
        _vc1 = [[BYMyAllWorkOrderController alloc] init];
        _vc1.isOverTime = _isOverTime;
    }
    return _vc1;
}
-(BYMyWaitCheckWorkOrderController *)vc2
{
    if (!_vc2) {
        _vc2 = [[BYMyWaitCheckWorkOrderController alloc] init];
        
    }
    return _vc2;
}
-(BYMyTimeoutWorkOrderController *)vc3
{
    if (!_vc3) {
        _vc3 = [[BYMyTimeoutWorkOrderController alloc] init];
    }
    return _vc3;
}
-(BYMyNotTakeWorkOrderController *)vc4
{
    if (!_vc4) {
        _vc4 = [[BYMyNotTakeWorkOrderController alloc] init];
    }
    return _vc4;
}
-(BYMyCompleteWorkOrderViewController *)vc5
{
    if (!_vc5) {
        _vc5 = [[BYMyCompleteWorkOrderViewController alloc] init];
    }
    return _vc5;
}


@end
