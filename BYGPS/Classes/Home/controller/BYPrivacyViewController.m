//
//  BYPrivacyViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/10/8.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYPrivacyViewController.h"
#import "EasyNavigation.h"
#import <WebKit/WebKit.h>

@interface BYPrivacyViewController ()<WKNavigationDelegate,WKUIDelegate>
@property(nonatomic ,strong) WKWebView *webView;
@end

@implementation BYPrivacyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBase];
    [self.webView  loadRequest:[ NSURLRequest requestWithURL:[NSURL URLWithString:[BYSaveTool objectForKey:BYPrivacyH5Url]]]];
    [self.view addSubview:self.webView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [BYProgressHUD dismiss];
}

-(void)initBase{
    [self.navigationView setTitle:@"隐私政策"];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
#pragma mark -- WKNavigationDelegate

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [BYProgressHUD show];
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [BYProgressHUD dismiss];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    [BYProgressHUD dismiss];
    BYShowError(@"加载失败");
}


- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    BYLog(@"message = %@",message);
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{return nil;}

- (WKWebView *)webView {
    if (!_webView) {
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, MAXWIDTH, MAXHEIGHT - SafeAreaTopHeight)];
        //记得实现对应协议,不然方法不会实现.
        
        _webView.UIDelegate = self;
        
        _webView.navigationDelegate =self;
        
        
        
    }
    return _webView;
}
@end
