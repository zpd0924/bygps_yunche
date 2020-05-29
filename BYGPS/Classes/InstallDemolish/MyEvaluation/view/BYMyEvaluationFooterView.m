//
//  BYMyEvaluationFooterView.m
//  xsxc
//
//  Created by ZPD on 2018/5/30.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYMyEvaluationFooterView.h"

@implementation BYMyEvaluationFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setUpContentView];
    }
    return self;
}

-(void)setUpContentView{
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    moreButton.by_x = self.bounds.size.width / 2 - 150 / 2;
    moreButton.by_centerY = self.bounds.size.height / 2 - 30 / 2;
    moreButton.by_width = 150;
    moreButton.by_height = 30;
    
    moreButton.layer.cornerRadius = 15;
    moreButton.clipsToBounds = YES;
    moreButton.layer.borderWidth = 1;
    moreButton.layer.borderColor = [UIColor colorWithHex:@"#efefef"].CGColor;
    
    [moreButton setTitle:@"更多评价" forState:UIControlStateNormal];
    [moreButton setTitleColor:BYGlobalBlueColor forState:UIControlStateNormal];
    moreButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [moreButton addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:moreButton];
}

-(void)loadMore:(UIButton *)button{
    if (self.loadMoreBlock) {
        self.loadMoreBlock();
    }
}

@end
