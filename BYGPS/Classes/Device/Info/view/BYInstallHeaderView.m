//
//  BYInstallHeaderView.m
//  父子控制器
//
//  Created by miwer on 2016/12/21.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYInstallHeaderView.h"

@interface BYInstallHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *leftLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stepTwoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *stepThreeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation BYInstallHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
}

-(void)setStepIndex:(NSInteger)stepIndex{
    self.leftLineImageView.image = [UIImage imageNamed:@"bg_current_line"];
    self.stepTwoImageView.image = [UIImage imageNamed:@"two_orange"];
    if (stepIndex == 3) {
        self.titleLabel.text = @"请确认填写的信息是否有误";
        self.rightLineImageView.image = [UIImage imageNamed:@"bg_current_line"];
        self.stepThreeImageView.image = [UIImage imageNamed:@"three_orange"];
    }
}
//bg_current_line  bg_no_line two_gray
- (void)setShowStepIndex:(NSInteger)showStepIndex{
    _showStepIndex = showStepIndex;
    switch (showStepIndex) {
        case 0:
            self.leftLineImageView.image = [UIImage imageNamed:@"bg_no_line"];
            self.rightLineImageView.image = [UIImage imageNamed:@"bg_no_line"];
            self.stepTwoImageView.image = [UIImage imageNamed:@"two_gray"];
            self.stepThreeImageView.image = [UIImage imageNamed:@"three_gray"];
            break;
        case 1:
            self.leftLineImageView.image = [UIImage imageNamed:@"bg_current_line"];
            self.rightLineImageView.image = [UIImage imageNamed:@"bg_no_line"];
            self.stepTwoImageView.image = [UIImage imageNamed:@"two_orange"];
            self.stepThreeImageView.image = [UIImage imageNamed:@"three_gray"];
            break;
        default:
            self.leftLineImageView.image = [UIImage imageNamed:@"bg_current_line"];
            self.rightLineImageView.image = [UIImage imageNamed:@"bg_current_line"];
            self.stepTwoImageView.image = [UIImage imageNamed:@"two_orange"];
            self.stepThreeImageView.image = [UIImage imageNamed:@"three_orange"];
            break;
    }
}

@end
