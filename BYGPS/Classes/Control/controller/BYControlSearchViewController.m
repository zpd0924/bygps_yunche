//
//  BYControlSearchViewController.m
//  BYGPS
//
//  Created by ZPD on 2018/4/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYControlSearchViewController.h"
#import "EasyNavigation.h"
#import "MSSAutoresizeLabelFlow.h"
#import "MSSAutoresizeLabelFlowConfig.h"
#import "BYNaviSearchBar.h"
#import "BYSearchHistoryDataBase.h"
#import "NSDictionary+Str.h"
#import "NSString+BYAttributeString.h"
#import "BYHistoryModel.h"

@interface BYControlSearchViewController ()<UITextFieldDelegate>
@property (nonatomic,strong) MSSAutoresizeLabelFlow *flow;
@property(nonatomic,strong) BYNaviSearchBar * naviSearchBar;

@property (nonatomic,strong) NSMutableArray *historyData;

@end

@implementation BYControlSearchViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    BYWeakSelf;
    [self.navigationView removeAllLeftButton];
    [self.navigationView addRightButtonWithTitle:@"取消" clickCallBack:^(UIView *view) {
        [weakSelf backAction];
    }];
}

-(void)backAction{
    if (self.searchCallBack) {
        self.searchCallBack(nil);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *historyMutArr = [[BYSearchHistoryDataBase shareInstance] queryHistoryWithUser:[BYSaveTool valueForKey:BYusername]];
    if (historyMutArr.count) {

        BYHistoryModel *historyModel = historyMutArr[0];
        switch (self.type) {
            case 1:
                self.historyData = [NSMutableArray arrayWithArray:[NSString stringToArrayWithJSONStr:historyModel.controlHistory]];
                break;
            case 2:
                self.historyData = [NSMutableArray arrayWithArray:[NSString stringToArrayWithJSONStr:historyModel.deviceListHistory]];
                break;
            case 3:
                self.historyData = [NSMutableArray arrayWithArray:[NSString stringToArrayWithJSONStr:historyModel.alarmListHistory]];
                break;
                
            default:
                break;
        }
    }
    
    self.naviSearchBar = [[BYNaviSearchBar alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W * 8, 30)];
    [self.navigationView addTitleView:self.naviSearchBar];
    self.naviSearchBar.searchField.delegate = self;
    [self.naviSearchBar.searchField becomeFirstResponder];
    
    UILabel *headLabel = [[UILabel alloc] init];
    headLabel.frame = CGRectMake(10, SafeAreaTopHeight + 5, 100, 25);
    headLabel.text = @"最近搜索";
    headLabel.textColor = [UIColor colorWithHex:@"#323232"];
    headLabel.font = [UIFont systemFontOfSize:14];
    
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.by_x = BYSCREEN_W - 40;
    deleteBtn.by_y = SafeAreaTopHeight + 5;
    [deleteBtn setImage:[UIImage imageNamed:@"icon_search_delete"] forState:UIControlStateNormal];
    [deleteBtn sizeToFit];
    [deleteBtn addTarget:self action:@selector(deleteAllHistory:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:headLabel];
    [self.view addSubview:deleteBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    MSSAutoresizeLabelFlowConfig *config = [MSSAutoresizeLabelFlowConfig shareConfig];
    config.backgroundColor = [UIColor whiteColor];
    config.itemColor = [UIColor colorWithHex:@"#efefef"];
    config.textColor = [UIColor colorWithHex:@"#646464"];
    config.textFont = [UIFont fontWithName:@"Times New Roman" size:15];
//    NSArray *array = @[@"Adele",@"Alicia Keys",@"Ariana Grande",@"Avril Lavigne",@"Beyoncé",@"Britney Spears",@"Celine Dion",@"Katy Perry",@"Rihanna"];
    self.flow = [[MSSAutoresizeLabelFlow alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(headLabel.frame)+5, BYSCREEN_W-20, BYSCREEN_H - 100) titles:self.historyData selectedHandler:^(NSUInteger index, NSString *title) {
        
        if (self.searchCallBack) {
            self.searchCallBack(title);
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        NSLog(@"%lu %@",index,title);
    }];
    [self.view addSubview:self.flow];

}


-(void)deleteAllHistory:(UIButton *)button{
    
    if (self.historyData.count > 0) {
        [self.historyData removeAllObjects];
        if ([[BYSearchHistoryDataBase shareInstance] existHistoryWithUser:[BYSaveTool valueForKey:BYusername]]) {
            switch (self.type) {
                case 1:
                    [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] controlHistory:nil];
                    break;
                case 2:
                    [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] deviceListHistory:nil];
                    break;
                case 3:
                    [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] alarmListHistory:nil];
                    break;
                default:
                    break;
            }
        }
        [self.flow reloadAllWithTitles:self.historyData];
    }
}

#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeySearch;
    if (textField.text.length == 0) {
        [BYProgressHUD by_showErrorWithStatus:@"搜索内容不能为空"];
        return YES;
    }
    [textField resignFirstResponder];

    if (![self.historyData containsObject:textField.text]) {
        [self.historyData insertObject:textField.text atIndex:0];
    }
    if (self.historyData.count > 10) {
        [self.historyData removeLastObject];
    }
    
    
    NSData *historyData = [NSJSONSerialization dataWithJSONObject:self.historyData   options:NSJSONWritingPrettyPrinted error:nil];
    NSString *historyArrStr = [[NSString alloc] initWithData:historyData encoding:NSUTF8StringEncoding];
    
    
    switch (self.type) {
        case 1:
            if ([[BYSearchHistoryDataBase shareInstance] existHistoryWithUser:[BYSaveTool valueForKey:BYusername]]) {
                [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] controlHistory:historyArrStr];
            }else{
                BYHistoryModel *model = [[BYHistoryModel alloc] init];
                
                model.controlHistory = historyArrStr;
                [[BYSearchHistoryDataBase shareInstance] insertUserName:[BYSaveTool valueForKey:BYusername] forHistoryModel:model];
            }
            break;
        case 2:
            if ([[BYSearchHistoryDataBase shareInstance] existHistoryWithUser:[BYSaveTool valueForKey:BYusername]]) {
                [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] deviceListHistory:historyArrStr];
            }else{
                BYHistoryModel *model = [[BYHistoryModel alloc] init];
                
                model.deviceListHistory = historyArrStr;
                [[BYSearchHistoryDataBase shareInstance] insertUserName:[BYSaveTool valueForKey:BYusername] forHistoryModel:model];
            }
            break;
        case 3:
            if ([[BYSearchHistoryDataBase shareInstance] existHistoryWithUser:[BYSaveTool valueForKey:BYusername]]) {
                [[BYSearchHistoryDataBase shareInstance] updateHistoryWithUserName:[BYSaveTool valueForKey:BYusername] alarmListHistory:historyArrStr];
            }else{
                BYHistoryModel *model = [[BYHistoryModel alloc] init];
                model.alarmListHistory = historyArrStr;
                [[BYSearchHistoryDataBase shareInstance] insertUserName:[BYSaveTool valueForKey:BYusername] forHistoryModel:model];
            }
            break;
            
        default:
            break;
    }
    
    if (self.searchCallBack) {
        self.searchCallBack(textField.text);
        [self.navigationController popViewControllerAnimated:YES];
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray *)historyData{
    if (!_historyData) {
        _historyData = [NSMutableArray array];
    }
    return _historyData;
}

@end
