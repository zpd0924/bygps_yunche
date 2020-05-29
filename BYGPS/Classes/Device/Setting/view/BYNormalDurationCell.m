//
//  BYNormalDurationCell.m
//  BYGPS
//
//  Created by miwer on 2017/2/6.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYNormalDurationCell.h"

@interface BYNormalDurationCell ()

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation BYNormalDurationCell

-(void)setSubTitle:(NSString *)subTitle{
    self.subTitleLabel.text = subTitle;
}
-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

@end
