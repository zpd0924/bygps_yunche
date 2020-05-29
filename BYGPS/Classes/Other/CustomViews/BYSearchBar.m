//
//  BYSearchBar.m
//  BYGPS
//
//  Created by miwer on 16/8/25.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSearchBar.h"

@implementation BYSearchBar

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

-(void)initUI{
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 3;
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_ss_gray"]];
    [imageView sizeToFit];
    imageView.by_centerX = 20;
    imageView.by_centerY = self.by_height / 2;
    [self addSubview:imageView];
//
//    UITextField * textField = [[UITextField alloc] init];
//    textField.by_x = 40;
////    textField.by_centerY = imageView.by_centerY;
//    textField.by_width = BYSCREEN_W - 60;
//    textField.by_height = 30;
//    textField.by_y = (self.by_height - textField.by_height) / 2;
//    textField.placeholder = @"搜索设备号、车牌号、车主姓名";
////    textField.backgroundColor = [UIColor redColor];
//    textField.clearButtonMode = UITextFieldViewModeAlways;
//    textField.returnKeyType = UIReturnKeySearch;
//
////    [textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
////    [textField setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
//    self.searchField = textField;
//    [self addSubview:textField];
    
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.by_x = 40;
    textLabel.by_width = self.frame.size.width - 60;
    textLabel.by_height = 30;
    textLabel.by_y = (self.by_height - textLabel.by_height) / 2;
    textLabel.text = @"搜索设备号、车牌号、车主姓名";
    textLabel.textColor = [UIColor colorWithHex:@"#909090"];

    self.searchLabel = textLabel;
    [self addSubview:textLabel];
    
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchAction)];
    
    [self addGestureRecognizer:tap];
    
    
}

-(void)searchAction{
    if (self.searchBlock) {
        self.searchBlock();
    }
}

@end
