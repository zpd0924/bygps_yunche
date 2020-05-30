//
//  BYBlankView.m
//  BYGPS
//
//  Created by miwer on 2017/2/20.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYBlankView.h"

@interface BYBlankView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

@end

@implementation BYBlankView

-(void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}


-(void)setImgName:(NSString *)imgName
{
    self.imgView.image = [UIImage imageNamed:imgName];
}

@end
