//
//  BYGuideImageView.m
//  BYGPS
//
//  Created by miwer on 2016/12/13.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYGuideImageView.h"
#import "sys/utsname.h"

@interface BYGuideImageView ()

@property(strong,nonatomic) BYGuideImageView * imageView;
@property(nonatomic,strong) UIButton * button;
@property(nonatomic,strong) NSString * imageName;

@end

@implementation BYGuideImageView

+(void)showGuideViewWith:(NSString *)imageName touchOriginYScale:(CGFloat)touchOriginYScale{
    
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;

    BYGuideImageView * imageView = [[BYGuideImageView alloc] init];
    imageView.userInteractionEnabled = YES;
    imageView.frame = keyWindow.bounds;
    imageView.image = [UIImage imageNamed:imageName];
    
    imageView.imageView = imageView;
    imageView.imageName = imageName;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame = CGRectMake(0, BYSCREEN_H * (CGFloat)touchOriginYScale, BYSCREEN_W, 100);
//    button.backgroundColor = [UIColor yellowColor];
    [button addTarget:self action:@selector(touchDismiss:) forControlEvents:UIControlEventTouchUpInside];
    
    imageView.button = button;
    
    [imageView addSubview:button];
    
//    [keyWindow addSubview:imageView];
    
    [BYSaveTool setBool:YES forKey:imageName];
}

+(void)touchDismiss:(UIButton *)button{
    
    //判断是否为设备列表页,如果是的话要切换图片和按钮位置;
    BYGuideImageView * imageView = (BYGuideImageView *)button.superview;
    if ([imageView.imageName isEqualToString:@"BYDeviceListControllerSelect"]) {
        imageView.imageView.image = [UIImage imageNamed:@"BYDeviceListControllerReset"];
        button.frame = CGRectMake(0, BYSCREEN_H / 5, BYSCREEN_W, 100);
        imageView.imageName = @"BYDeviceListControllerReset";
        return;
    }
    //判断是否为首页现拍检查,如果是的话要切换图片和按钮位置;
    if ([imageView.imageName isEqualToString:@"CheckPhoto"]) {
        imageView.imageView.image = [UIImage imageNamed:@"MyTask"];
        button.frame = CGRectMake(0, BYSCREEN_H * 0.55, BYSCREEN_W, 100);
        imageView.imageName = @"MyTask";
        return;
    }
    
    //判断是否为现拍检查未拍照,如果是的话要切换图片和按钮位置;
    if ([imageView.imageName isEqualToString:@"BYCheckPhotoViewControllerNoTake"]) {
        imageView.imageView.image = [UIImage imageNamed:@"BYCheckPhotoViewControllerBeenTake"];
        button.frame = CGRectMake(0, BYSCREEN_H * 0.4, BYSCREEN_W, 100);
        imageView.imageName = @"BYCheckPhotoViewControllerBeenTake";
        return;
    }
    
    //判断是否为轨迹回放，如果是的话要切换图片和按钮位置;
    if ([imageView.imageName isEqualToString:@"BYReplayController"]) {
        imageView.imageView.image = [UIImage imageNamed:@"BYReplayControllerPark"];
        button.frame = CGRectMake(0, BYSCREEN_H * 0.4, BYSCREEN_W, 100);
        imageView.imageName = @"BYReplayControllerPark";
        return;
    }
    
    //判断是否为监控页，如果是的话要切换图片和按钮位置;
    if ([BYSaveTool boolForKey:BYMonitorInfo]) {
        if ([imageView.imageName isEqualToString:@"BYControlViewController"]) {
        
            struct utsname systemInfo;
            uname(&systemInfo);
            NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
            if ([deviceString isEqualToString:@"iPhone6,1"] || [deviceString isEqualToString:@"iPhone6,2"]) {
                imageView.imageView.image = [UIImage imageNamed:@"BYControlViewControllerGaowei2"];
                button.frame = CGRectMake(0, BYSCREEN_H * 0.5, BYSCREEN_W, 100);
                imageView.imageName = @"BYControlViewControllerGaowei2";
            }else{
                imageView.imageView.image = [UIImage imageNamed:@"BYControlViewControllerGaowei2"];
                button.frame = CGRectMake(0, BYSCREEN_H * 0.5, BYSCREEN_W, 100);
                imageView.imageName = @"BYControlViewControllerGaowei2";
            }
            return;
        }
    }
    
    if ([imageView.imageName isEqualToString:@"BYTrackController"]) {
        imageView.imageView.image = [UIImage imageNamed:@"BYTrackControllerLBS"];
        button.frame = CGRectMake(0, BYSCREEN_H * 0.5, BYSCREEN_W, 100);
        imageView.imageName = @"BYTrackControllerLBS";
        return;
    }
    
    if ([imageView.imageName isEqualToString:@"BYTrackControllerLBS"]) {
        imageView.imageView.image = [UIImage imageNamed:@"BYTrackControllerWIFI"];
        button.frame = CGRectMake(0, BYSCREEN_H * 0.55, BYSCREEN_W, 100);
        imageView.imageName = @"BYTrackControllerWIFI";
        return;
    }
    
    if ([imageView.imageName isEqualToString:@"BYTrackControllerWIFI"]) {
        imageView.imageView.image = [UIImage imageNamed:@"BYTrackControllerPhoto"];
        button.frame = CGRectMake(0, BYSCREEN_H * 0.8, BYSCREEN_W, 100);
        imageView.imageName = @"BYTrackControllerPhoto";
        return;
    }

    
    [UIView animateWithDuration:0.2 animations:^{
        button.superview.alpha = 0;
    } completion:^(BOOL finished) {
        
        [button.superview removeFromSuperview];
    }];
}

- (NSString*)deviceVersion
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    return deviceString;
}

@end
