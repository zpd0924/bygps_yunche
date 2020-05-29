//
//  BYBaiduParamaController.m
//  BYGPS
//
//  Created by ZPD on 2017/8/1.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYBaiduParamaController.h"
#import <BaiduPanoSDK/BaiduPanoramaView.h>
#import "NSDictionary+Str.h"
#import "EasyNavigation.h"
#import "BYRegeoHttpTool.h"

@interface BYBaiduParamaController ()<BaiduPanoramaViewDelegate>

@property (nonatomic,strong) BaiduPanoramaView *panoramaView;//百度全景
@property (nonatomic,assign) BOOL isFirstLoad;
@property (nonatomic,strong) UILabel *addressLabel;
@property (nonatomic,strong) UIImageView *blankImgView;

@end

@implementation BYBaiduParamaController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationView setTitle:self.titleStr];
    [self.navigationView setNavigationBackgroundColor:BYGlobalTextGrayColor];
    [self setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationView.titleLabel.textColor = [UIColor whiteColor];
    [self geoDecodeWithLat:self.lat lon:self.lon];
    self.isFirstLoad = YES;
    [self customPanoramaView];
}

-(void)geoDecodeWithLat:(CGFloat)lat lon:(CGFloat)lon{
    
    [BYRegeoHttpTool POSTRegeoAddressWithLat:lat lng:lon success:^(id data) {
        self.address = [data[@"address"] isEqualToString:@""] ? @"无法获取当前位置" : data[@"address"];

        BYLog(@"%@",data);
    } failure:^(NSError *error) {
        
    }];
}

-(void)customPanoramaView
{
    CGRect frame = CGRectMake(0, 0, BYSCREEN_W, BYSCREEN_H);
    
    // key 为在百度LBS平台上统一申请的接入密钥ak 字符串
    self.panoramaView = [[BaiduPanoramaView alloc] initWithFrame:frame key:baiduMapKey];
    // 为全景设定一个代理
    self.panoramaView.delegate = self;
    [self.view addSubview:self.panoramaView];
    self.addressLabel.frame = CGRectMake(0, BYSCREEN_H - 60, BYSCREEN_W, 60);
    [self.view addSubview:self.addressLabel];
    
    // 设定全景的清晰度， 默认为middle
    [self.panoramaView setPanoramaImageLevel:ImageDefinitionMiddle];
    // 设定全景的pid， 这是指定显示某地的全景，也可以通过百度坐标进行显示全景
    [self.panoramaView setPanoramaWithLon:self.lon lat:self.lat];
}
#pragma mark - panorama view delegate

- (void)panoramaDidLoad:(BaiduPanoramaView *)panoramaView descreption:(NSString *)jsonStr {
    BYLog(@"%@",jsonStr);
    if (self.blankImgView) {
        [self.blankImgView removeFromSuperview];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithJsonString:jsonStr];
    NSString *address = dict[@"Rname"];
    self.addressLabel.text = address.length > 0 ? address : @"未知道路";
}

- (void)panoramaLoadFailed:(BaiduPanoramaView *)panoramaView error:(NSError *)error {
    BYLog(@"%@",error.userInfo);
    
    if (self.blankImgView) {
        self.blankImgView.image = [UIImage imageNamed:@"Urban-background"];
        self.addressLabel.text = self.address;
    } 
}

- (UIImage *) imageWithFrame:(CGRect)frame alphe:(CGFloat)alphe {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIColor *redColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alphe];
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [redColor CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(UILabel *)addressLabel
{
    if (!_addressLabel) {
        UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, BYSCREEN_H - 30, BYSCREEN_W, 30)];
        addressLabel.textColor = [UIColor whiteColor];
        addressLabel.textAlignment = NSTextAlignmentCenter;
        addressLabel.numberOfLines = 0;
        addressLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.view addSubview:addressLabel];
        _addressLabel = addressLabel;
    }
    return _addressLabel;
}

-(UIImageView *)blankImgView
{
    if (!_blankImgView) {
        _blankImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, BYSCREEN_H)];
        _blankImgView.image = [UIImage imageNamed:@"Urban-background"];
        [self.view addSubview:_blankImgView];
        [self.view addSubview:self.addressLabel];
    }
    return _blankImgView;
}

@end
