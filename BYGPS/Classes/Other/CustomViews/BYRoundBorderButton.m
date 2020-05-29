//
//  BYRoundBorderButton.m
//  BYGPS
//
//  Created by miwer on 16/9/13.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYRoundBorderButton.h"

@implementation BYRoundBorderButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    self.layer.cornerRadius = 10;
    self.clipsToBounds = YES;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1;
}


@end
