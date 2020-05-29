//
//  BYAlertTip.m
//  xsxc
//
//  Created by 李志军 on 2018/7/3.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYAlertTip.h"

@implementation BYAlertTip
//!<标题 提示 取消 确认自定义
+(void)ShowAlertWith:(NSString*)title message:(NSString*)message withCancelTitle:(NSString *)cancelTitle withSureTitle:(NSString *)sureTitle viewControl:(UIViewController*)control andSureBack:(BackSure)BackSure andCancelBack:(BackCancel)BackCancel{
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cacnle = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        BackCancel();
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BackSure();
    }];
    
    [ac addAction:cacnle];
    [ac addAction:sure];
    
    if ([[[UIDevice currentDevice] systemVersion]integerValue] >=8.3) {
        [cacnle setValue:[UIColor colorWithHex:@"#333333"] forKey:@"titleTextColor"];
        [sure setValue:BYGlobalBlueColor forKey:@"titleTextColor"];
        
    }
    if ([BYObjectTool getIsIpad]){
        
        ac.popoverPresentationController.sourceView = control.view;
        ac.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
    }
    [control presentViewController:ac animated:YES completion:^{
        
    }];
    
    
//    UIView *subView1 = ac.view.subviews.firstObject;
//    UIView *subView2 = subView1.subviews.firstObject;
//    UIView *subView3 = subView2.subviews.firstObject;
//    UIView *subView4 = subView3.subviews.firstObject;
//    UIView *subView5 = subView4.subviews.firstObject;
//    if (subView5.subviews.count > 1) {
//        UILabel *messageLab = subView5.subviews[1];
//        messageLab.textAlignment = NSTextAlignmentLeft;
//    }
   
    
    
}
+ (void)ShowOnlyAlertWith:(NSString *)title message:(NSString *)message viewControl:(UIViewController *)control andSureBack:(BackSure)block {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    
    [ac addAction:sure];
    if ([[[UIDevice currentDevice] systemVersion]integerValue] >=8.3) {
        [sure setValue:BYGlobalBlueColor forKey:@"titleTextColor"];
        
    }
    if ([BYObjectTool getIsIpad]){
        
        ac.popoverPresentationController.sourceView = control.view;
        ac.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
    }
    [control presentViewController:ac animated:YES completion:^{
        
    }];
}
+ (UIAlertController *)ShowOnlySureAlertWith:(NSString *)title message:(NSString *)message sureTitle:(NSString *)sureTitle viewControl:(UIViewController *)control andSureBack:(BackSure)block {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:sureTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        block();
    }];
    
    if ([[[UIDevice currentDevice] systemVersion]integerValue] >=8.3) {
        
        [sure setValue:BYGlobalBlueColor forKey:@"titleTextColor"];
        
    }
    [ac addAction:sure];
    
    
    [control presentViewController:ac animated:YES completion:^{
        
    }];
    if ([BYObjectTool getIsIpad]){
        
        ac.popoverPresentationController.sourceView = control.view;
        ac.popoverPresentationController.sourceRect =   CGRectMake(100, 100, 1, 1);
    }
    return ac;
}
@end
