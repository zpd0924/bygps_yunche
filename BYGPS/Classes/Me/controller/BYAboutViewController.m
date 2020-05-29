//
//  BYAboutViewController.m
//  BYGPS
//
//  Created by miwer on 16/7/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAboutViewController.h"
#import "BYSettingGroup.h"
#import "BYSettingArrowItem.h"
#import "BYSettingNoneItem.h"
#import "BYAboutHeaderView.h"
#import "BYHomeHttpTool.h"
#import "BYAboutFooterView.h"
#import "WXApiManager.h"
#import "WXApiRequestHandler.h"
#import "EasyNavigation.h"

@interface BYAboutViewController ()

@property (nonatomic) enum WXScene currentScene;

@end

@implementation BYAboutViewController
@synthesize currentScene = _currentScene;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBase];
    
    [self setupGroup];
}

-(void)initBase{
    
    [self.navigationView setTitle:@"关于"];
    self.BYTableViewCellStyle = UITableViewCellStyleDefault;
//    self.tableView.scrollEnabled = NO;
    if (@available(iOS 11.0, *)) {
        
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.tableView.contentInset = UIEdgeInsetsMake(SafeAreaTopHeight, 0, 0, 0);
        //        BYLog(@"%f",SafeAreaTopHeight);
        
    } else {
        self.tableView.contentInset = UIEdgeInsetsMake(SafeAreaTopHeight, 0, 0, 0);
        // Fallback on earlier versions
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
//    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, BYSCREEN_W, SafeAreaTopHeight)];
//    self.tableView.tableHeaderView = head;
    
    BYAboutFooterView *footerView = [BYAboutFooterView by_viewFromXib];
    footerView.by_height = 370;
    
    [footerView setShareToWXBlock:^{
        if ([WXApi isWXAppInstalled]) {
                _currentScene = WXSceneSession;
            
                [WXApiRequestHandler sendLinkURL:@"http://www.cdagps.com/appMove/download" TagName:@"【标越科技】汽车金融风控专家！" Title:@"【标越科技】汽车金融风控专家！" Description:@"24小时实时监控，随时随地掌握车辆状况。立即下载>>" ThumbImage:[UIImage imageNamed:@"icon_29"] InScene:_currentScene];
            //                                    [WXApiRequestHandler sendText:text
            //                                                          InScene:_currentScene];
            }else{
                BYShowError(@"请先安装微信");
            }
    }];
    
    [footerView setPhoneBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWebView * callWebview = [[UIWebView alloc]init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:075536567158"]]];
            
            [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
        });
        
    }];
    
    footerView.backgroundColor = BYGlobalBg;
    
//    self.tableView.tableFooterView = footerView;
}

-(void)setupGroup{
    BYSettingGroup * group = [[BYSettingGroup alloc] init];
    
    BYSettingNoneItem * item1 = [[BYSettingNoneItem alloc] init];
    item1.title = [NSString stringWithFormat:@"软件版本: v%@",BYLocalVersion];

//    BYSettingNoneItem * item2 = [[BYSettingNoneItem alloc] init];
//    item2.title = @"更新时间: 2017-04-05";
    
//    BYSettingNoneItem * item3 = [[BYSettingNoneItem alloc] init];
//    item3.title = @"官方网址: http://www.vvsmart.com";
    
//    BYSettingNoneItem * item4 = [[BYSettingNoneItem alloc] init];
//    item4.title = @"微信服务: 车贷GPS";
    
//    BYSettingNoneItem * item5 = [[BYSettingNoneItem alloc] init];
//    item5.title = @"服务热线: 0755-86581010";
    
    group.items = @[item1];
    [self.groups addObject:group];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return [BYAboutHeaderView by_viewFromXib];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return BYS_W_H(150);
}


@end









