//
//  BYInstallSectionHeaderView.m
//  父子控制器
//
//  Created by miwer on 2016/12/21.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYInstallSectionHeaderView.h"

@interface BYInstallSectionHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//@property (weak, nonatomic) IBOutlet UIButton *noCarNumButton;

@end

@implementation BYInstallSectionHeaderView

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

-(void)setIsShowButton:(BOOL)isShowButton{
//    self.noCarNumButton.hidden = !isShowButton;
}

//- (IBAction)noCarNumAction:(id)sender {
//    if (self.noCarNumBlock) {
//        self.noCarNumBlock();
//    }
//}

@end
