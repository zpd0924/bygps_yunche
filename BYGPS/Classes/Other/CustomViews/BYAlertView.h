//
//  AlertView.h
//  MyAlertView
//
//  Created by miwer on 16/8/1.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYAlertView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *alert;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertHeightContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertWidthContraint;

@property(nonatomic,copy)void (^sureBlock)();
@property(nonatomic,copy)void (^cancelBlock)();

+(BYAlertView *)viewFromNibWithTitle:(NSString *)title message:(NSString *)message;

- (void)show;

@end
