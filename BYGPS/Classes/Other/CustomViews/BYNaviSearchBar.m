//
//  BYNaviSearchBar.m
//  BYGPS
//
//  Created by miwer on 2016/10/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYNaviSearchBar.h"
#import "UIButton+HNVerBut.h"
#import <Masonry.h>

@implementation BYNaviSearchBar

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}
- (void)setIsShareSearch:(BOOL)isShareSearch{
    _isShareSearch = isShareSearch;
    if (isShareSearch) {
    [self.searchField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.by_width - 70);
    }];
    [self.searImageBtn setTitle:@"车牌号" forState:UIControlStateNormal];
    self.searImageBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.searImageBtn setTitleColor:BYGlobalBlueColor forState:UIControlStateNormal];
    [self.searImageBtn setImage:[UIImage imageNamed:@"icon_drop_down_gray"] forState:UIControlStateNormal];
    [self.searchField mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(80);
        make.width.mas_equalTo(self.by_width - 80);
    }];
    [self.searImageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(70);
    }];
    self.backgroundColor = WHITE;
        [self.searchField setBackgroundColor:BYRGBColor(226, 231, 232)];
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        UIImageView *imageview = [[UIImageView alloc] init];
        imageview.image = [UIImage imageNamed:@"share_gray"];
        [view addSubview:imageview];
        [imageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view);
            make.left.mas_equalTo(7);
        }];
        self.searchField.leftView = view;
        self.searchField.leftViewMode = UITextFieldViewModeAlways;
 }
}
- (void)setIsScan:(BOOL)isScan{
    _isScan = isScan;
    if(isScan){
       
        [self.searchField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.by_width - 60);
        }];
    }
}
- (void)setIsCarSearch:(BOOL)isCarSearch{
    _isCarSearch = isCarSearch;
    if (isCarSearch) {
        [self.searImageBtn setTitle:@"车牌号" forState:UIControlStateNormal];
        self.searImageBtn.titleLabel.font = BYS_T_F(14);
        [self.searImageBtn setTitleColor:BYLabelBlackColor forState:UIControlStateNormal];
        [self.searImageBtn setImage:[UIImage imageNamed:@"icon_drop_down_gray"] forState:UIControlStateNormal];
        [self.searchField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(70);
            make.width.mas_equalTo(self.by_width - 90);
        }];
        [self.searImageBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(70);
        }];
    }
}

- (void)searImageBtnClick:(UIButton *)btn{
    if (_isCarSearch) {
        if (self.searchBlock) {
            self.searchBlock();
        }
    }
    if (_isShareSearch) {
        if (self.searchBlock) {
            self.searchBlock();
        }
    }
}

-(void)initUI{
    
    self.backgroundColor = BYRGBColor(226, 231, 232);
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
    
   
    BYButton *searImageBtn = [[BYButton alloc] init];;
    self.searImageBtn = searImageBtn;
    [searImageBtn addTarget:self action:@selector(searImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [searImageBtn setImage:[UIImage imageNamed:@"share_gray"] forState:UIControlStateNormal];
   
    [self addSubview:searImageBtn];
    [searImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.mas_equalTo(5);
//        make.width.mas_equalTo(20);
    }];
    UITextField * textField = [[UITextField alloc] init];
    textField.textColor = BYLabelBlackColor;
//    textField.by_x = 30;
//    //    textField.by_centerY = imageView.by_centerY;
//    textField.by_width = self.by_width - 30;
//    textField.by_height = 25;
//    textField.by_y = (self.by_height - textField.by_height) / 2;
    textField.placeholder = @"搜索设备号、车牌号、车主姓名";
    textField.font = BYS_T_F(14);
//    textField.backgroundColor = [UIColor redColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeySearch;
    
    //    [textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    //    [textField setValue:[UIFont systemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    self.searchField = textField;
    [self addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.width.mas_equalTo(self.by_width - 30);
        make.height.mas_equalTo(25);
        make.top.mas_equalTo((self.by_height - 25)*0.5);
    }];
    
}

@end
