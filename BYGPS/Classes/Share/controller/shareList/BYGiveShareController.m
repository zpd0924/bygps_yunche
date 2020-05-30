//
//  BYGiveShareController.m
//  BYGPS
//
//  Created by 李志军 on 2018/12/11.
//  Copyright © 2018 miwer. All rights reserved.
//

#import "BYGiveShareController.h"
#import "EasyNavigation.h"
#import "BYGiveShareIngController.h"
#import "BYGiveShareDatedController.h"
#import "BYShareListSearchController.h"
#import "BYShareListModel.h"
@interface BYGiveShareController ()
@property(nonatomic ,strong) BYGiveShareIngController * vc1;
@property (nonatomic,strong) BYGiveShareDatedController *vc2;
@end

@implementation BYGiveShareController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    BYStatusBarLight;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    BYStatusBarDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initBase];
    [self loadIngData];
    [self loadEndData];
}

//获取发出的分享数量 -- 进行中的
-(void)loadIngData{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"currentPage"] = @(1);
    dict[@"showCount"] = @(10);
    dict[@"isEnd"] = @"N";
    [BYRequestHttpTool POSTMySendShareListParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{

            weakSelf.vc1.title = [NSString stringWithFormat:@"进行中(%@)",data[@"page"][@"totalResult"]];
            [weakSelf refreshDisplay];
        });
    } failure:^(NSError *error) {
    }];
    
}
//获取发出的分享数量 -- 进行中的
-(void)loadEndData{
   
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"currentPage"] = @(1);
    dict[@"showCount"] = @(10);
    dict[@"isEnd"] = @"Y";
    [BYRequestHttpTool POSTMySendShareListParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakSelf.vc2.title = [NSString stringWithFormat:@"已过期(%@)",data[@"page"][@"totalResult"]];
            [weakSelf refreshDisplay];
        });
    } failure:^(NSError *error) {
    }];
    
}



-(void)initBase{
    [self.navigationView setTitle:@"发出的分享"];
    self.view.backgroundColor = UIColorFromToRGB(244, 244, 244);
    self.navigationView.titleLabel.textColor = [UIColor whiteColor];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView removeAllLeftButton];
        BYWeakSelf;
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
        [self.navigationView addRightButtonWithImage:[UIImage imageNamed:@"share_gray"] clickCallBack:^(UIView *view) {
            BYShareListSearchController *vc = [[BYShareListSearchController alloc] init];
             vc.searchType = MySendShareType;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
    });
    
    // 添加所有子控制器
    [self setUpAllViewController];
    
    self.isfullScreen = YES;
    
    [self setUpTitleEffect:^(UIColor *__autoreleasing *titleScrollViewColor, UIColor *__autoreleasing *norColor, UIColor *__autoreleasing *selColor, UIFont *__autoreleasing *titleFont, CGFloat *titleHeight, CGFloat *titleWidth) {
        
        *norColor = [UIColor whiteColor];
        *selColor = [UIColor whiteColor];
        *titleWidth = BYSCREEN_W / 2;
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
    
    self.isfullScreen = YES;
}

-(void)setVCTitle:(NSString *)number{
    
    self.vc1.title = [NSString stringWithFormat:@"进行中(%@)",number];
     self.selectIndex = 0;
    [self refreshDisplay];
}
-(void)setVCTitle1:(NSString *)number{
    
    
    self.vc2.title = [NSString stringWithFormat:@"已过期(%@)",number];
     self.selectIndex = 1;
    [self refreshDisplay];
}

// 添加所有子控制器
- (void)setUpAllViewController{
    self.vc1.title = @"进行中(0)";
    [self addChildViewController:self.vc1];
    
    self.vc2.title = @"已过期(0)";
    [self addChildViewController:self.vc2];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    
  
}

-(BYGiveShareIngController *)vc1
{
    if (!_vc1) {
        _vc1 = [[BYGiveShareIngController alloc] init];
        BYWeakSelf;
        _vc1.refreshNumberBlock = ^(NSString *number) {
           
            [weakSelf setVCTitle:number];
            
        };
    }
    return _vc1;
}

-(BYGiveShareDatedController *)vc2
{
    if (!_vc2) {
        _vc2 = [[BYGiveShareDatedController alloc] init];
        BYWeakSelf;
        _vc2.refreshNumberBlock = ^(NSString *number) {
           
            [weakSelf setVCTitle1:number];
           
        };
    }
    return _vc2;
}


@end
