//
//  BYControlH5ViewController.m
//  BYGPS
//
//  Created by 李志军 on 2019/1/3.
//  Copyright © 2019 miwer. All rights reserved.
//

#import "BYControlH5ViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
@interface BYControlH5ViewController ()<WKNavigationDelegate,WKScriptMessageHandler,WKUIDelegate,UINavigationControllerDelegate>
@property(nonatomic ,strong) WKWebView *webView;
@end

@implementation BYControlH5ViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
 
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
  
}
- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *encodeModel = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(__bridge CFStringRef)self.model.model,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    NSString *url = nil;
    if (self.model.shareId.length) {
         url = [NSString stringWithFormat:@"%@?token=%@&deviceId=%zd&model=%@&shareId=%@",[BYSaveTool objectForKey:BYH5Url],[BYSaveTool objectForKey:BYToken],self.model.deviceId,encodeModel,self.model.shareId];
    }else{
         url = [NSString stringWithFormat:@"%@?token=%@&deviceId=%zd&model=%@",[BYSaveTool objectForKey:BYH5Url],[BYSaveTool objectForKey:BYToken],self.model.deviceId,encodeModel];
    }
   
    
    BYLog(@"url = %@",url);
    
    NSString *decodeString = [BYObjectTool encodeParameter:url];
    BYLog(@"decodeString = %@",decodeString);
    [self.webView  loadRequest:[ NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    [self.view addSubview:self.webView];
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
    if ([message.name isEqualToString:@"methodName"]) {
        if (_isModel) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
             [self.navigationController popViewControllerAnimated:YES];
        }
       
    }else if([message.name isEqualToString:@"umeng"]){
        MobClickEvent(message.body, @"");
    }
    
    
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{return nil;}

- (WKWebView *)webView {
    if (!_webView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        config.preferences = [[WKPreferences alloc] init];
        
        config.preferences.minimumFontSize = 10;
        
        config.preferences.javaScriptEnabled = YES;
        
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        
        config.userContentController = [[WKUserContentController alloc] init];
        
        config.processPool = [[WKProcessPool alloc] init];
        [config.userContentController addScriptMessageHandler:self name:@"methodName"];
        [config.userContentController addScriptMessageHandler:self name:@"umeng"];
        
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                    
                                      configuration:config];
        
        //记得实现对应协议,不然方法不会实现.
        
        _webView.UIDelegate = self;
        
        _webView.navigationDelegate =self;
        
        
        
    }
    return _webView;
}


@end
