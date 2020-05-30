//
//  BYCurrentPhoneBindingController.m
//  BYGPS
//
//  Created by miwer on 2017/4/25.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYCurrentPhoneBindingController.h"
#import "BYBindingPhoneController.h"
#import "BYSaveTool.h"
#import "EasyNavigation.h"
#import "BYLoginHttpTool.h"
#import "BYLoginViewController.h"

@interface BYCurrentPhoneBindingController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BYCurrentPhoneBindingController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = BYGlobalBg;
    [self.navigationView setTitle:@"手机号绑定"];

    NSString *mPhone = [BYSaveTool valueForKey:mobile];
    self.titleLabel.text = mPhone.length > 0 ? [self replaceStringWith:[NSString stringWithFormat:@"绑定手机号：%@",[BYSaveTool valueForKey:mobile]] length:4] : @"";
}

- (IBAction)changePhone:(id)sender {
    BYBindingPhoneController * bindingPhoneVc = [[BYBindingPhoneController alloc] init];
    bindingPhoneVc.isChangePhone = YES;
    [self.navigationController pushViewController:bindingPhoneVc animated:YES];
}
//解绑手机号
- (IBAction)unBindMobile:(id)sender {
    [BYLoginHttpTool POSTUnbindMobileSuccess:^(id data) {
        BYLoginViewController * loginVC = [BYLoginViewController new];
        loginVC.isLogout = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [BYSaveTool removeObjectForKey:BYToken];
            EasyNavigationController * navi = [[EasyNavigationController alloc] initWithRootViewController:loginVC];

            navi.modalPresentationStyle = UIModalPresentationFullScreen;
            [UIApplication sharedApplication].keyWindow.rootViewController = navi;
        });
    }];
}

- (NSString *)replaceStringWith:(NSString *)originalStr length:(NSInteger)length{
    
    NSString * newStr = originalStr;
    
    NSInteger startLocation = originalStr.length - 8;
    
    for (int i = 0; i < length; i++) {
        
        NSRange range = NSMakeRange(startLocation, 1);
        
        newStr = [newStr stringByReplacingCharactersInRange:range withString:@"*"];
        
        startLocation ++;
    }
    
    return newStr;
    
}

@end
