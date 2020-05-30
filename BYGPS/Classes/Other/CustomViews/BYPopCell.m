//
//  MenuTableViewCell.m
//  PopMenuTableView
//
//  Created by bean on 16/8/2.
//  Copyright © 2016年 bean. All rights reserved.
//

#import "BYPopCell.h"

@implementation BYPopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = [UIColor blackColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 1)];
    lineView.backgroundColor = BYGrayColor(235);
    [self addSubview:lineView];
}

-(void)setTitle:(NSString *)title{
    self.textLabel.text = title;
}

-(void)setIsSelect:(BOOL)isSelect{
    if (isSelect) {
        self.imageView.image = [UIImage imageNamed:@"icon_tick"];
    }else{
        self.imageView.image = [UIImage imageNamed:@"icon_tick_blank"];
    }
}


@end
