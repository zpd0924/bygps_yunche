//
//  BYLookBigImageViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYLookBigImageViewController.h"
#import "UIButton+HNVerBut.h"
#import "BYUnderlineButtonView.h"
#import "SDPhotoBrowser.h"
@interface BYLookBigImageViewController ()<SDPhotoBrowserDelegate>
@property (nonatomic,strong) BYUnderlineButtonView *underLineButton;
@property (nonatomic,strong) NSArray *photoArr;
@end

@implementation BYLookBigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorHexFromRGB(0x000000);
    [self getData];
}

- (void)initBase{
    
    UIButton *dismissBtn = [UIButton verBut:@"╳" textFont:15 titleColor:nil bkgColor:nil];
    [dismissBtn addTarget:self action:@selector(dismissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.with.mas_equalTo(40);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(50);
    }];
    
    BYUnderlineButtonView *underLineButton = nil;
    if (self.photoArr.count >2) {
        underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"安装位置图片",@"设备合照",@"设备合照"]];
    }else{
        underLineButton = [[BYUnderlineButtonView alloc] initWithItems:@[@"安装位置图片",@"设备合照"]];
    }
    [underLineButton addTarget:self action:@selector(changeTheVision:)];
    underLineButton.isBigLookImages = YES;
    
    //大图浏览
    SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
//    photoBrowser.currentImageIndex = tag;
    photoBrowser.imageCount = 2;
    photoBrowser.sourceImagesContainerView = self.view;
    
    [photoBrowser show];
    
    [photoBrowser addSubview:self.underLineButton];
    [underLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MAXWIDTH, 30));
        make.centerX.equalTo(photoBrowser);
        make.top.mas_equalTo(100);
    }];
    UIView *line = [[UIView alloc] init];
    line.hidden = YES;
    line.backgroundColor = WHITE;
    [photoBrowser addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(2, 20));
        make.center.equalTo(underLineButton);
    }];
    
}

#pragma makr -- 查看装机图片接口
- (void)getData{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"orderNo"] = @"123";
    dict[@"sn"] = @"123";
    [BYSendWorkHttpTool POSTCheckInstallImgParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *str = data[@"url"];
            weakSelf.photoArr = [str componentsSeparatedByString:@","];
             [weakSelf initBase];
        });
    } failure:^(NSError *error) {
        
    }];
}


-(void)changeTheVision:(UIButton *)sender{
 
 
}

- (void)dismissBtnClick{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 返回临时占位图片（即原来的小图）
//- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
//
//    BYPhotoModel * model = self.images[index];
//    return model.image;
//}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
   
    return [NSURL URLWithString:@"https://gss0.bdstatic.com/70cFsjip0QIZ8tyhnq/img/logo-zhidao.gif"];
}




-(NSArray *)photoArr
{
    if (!_photoArr) {
        _photoArr = [NSArray array];
    }
    return _photoArr;
}


@end
