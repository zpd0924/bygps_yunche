//
//  BYGroupSearchBar.m
//  BYGPS
//
//  Created by miwer on 16/9/6.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYGroupSearchBar.h"

@implementation BYGroupSearchBar

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
//    self.backgroundColor = [UIColor yellowColor];
    
    self.borderStyle = UITextBorderStyleRoundedRect;
    self.placeholder = @"请输入分组名称";
    self.clearButtonMode = UITextFieldViewModeWhileEditing;

}

@end
