//
//  PrefixHeader.h
//  BYGPS
//
//  Created by miwer on 16/7/19.
//  Copyright © 2016年 miwer. All rights reserved.
//

#ifndef PrefixHeader_h
#define PrefixHeader_h
//分类
#import "UIColor+BYHexColor.h"
#import "UIView+BYFrame.h"
#import "UIBarButtonItem+BYBarButtonItem.h"
#import "UIButton+BYFooterButton.h"
#import "BYProgressHUD.h"
#import "IQKeyboardManager.h"
//#import "UIViewController+BYNavigationExtension.h"
#import "BYGuideImageView.h"
#import "BYSendWorkHttpTool.h"
#import "BYRequestHttpTool.h"
#import <MJRefresh.h>
#import "BYConst.h"
#import "BYSaveTool.h"
#import "BYObjectTool.h"
#import "YYModel.h"
#import <Masonry.h>
#import "UILabel+HNVerLab.h"
#import <UMMobClick/MobClick.h>
// 1.自定义NSLog
#ifdef DEBUG // 开发阶段-DEBUG阶段:使用Log
#define BYLog(...) NSLog(__VA_ARGS__)
#else // 发布阶段-上线阶段:移除Log
#define BYLog(...)
#endif

#define BYLogFunc BYLog(@"%s",__func__);




#define BYIOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define BYSCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define BYSCREEN_H ([UIScreen mainScreen].bounds.size.height)

//#define BYLocalVersion [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]//当前版本号
#define BYLocalVersion @"1.0.0"//当前版本号

#define BYloginPackage @"yunchedaian"

//屏幕尺寸
#define BYiPhone4_OR_4s  (BYSCREEN_H == 480)
#define BYiPhone5_OR_5c_OR_5s  (BYSCREEN_H == 568)
#define BYiPhone6_OR_6s  (BYSCREEN_H == 667)
#define BYiPhone6Plus_OR_6sPlus  (BYSCREEN_H == 736)

#define IOS10 ([UIDevice currentDevice].systemVersion.floatValue >= 10.0)
#define IOS9 ([UIDevice currentDevice].systemVersion.floatValue < 10.0)

// 判断是否为iPhone X 系列  这样写消除了在Xcode10上的警告。
#define IPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

/**
 *导航栏高度
 */
#define SafeAreaTopHeight (IPHONE_X ? 88 : 64)

/**
 *tabbar高度
 */
#define SafeAreaBottomHeight (IPHONE_X ? (49 + 34) : 49)

//字体缩放比例
#define BYScale (BYSCREEN_H/667 > 1 ? 1 : BYSCREEN_H/667)

#define BYS_W_H(n) BYScale*(n)
#define BYS_T_F(n) [UIFont systemFontOfSize:BYScale*(n)]
#define PXSCALE  MAXWIDTH/375.0
#define PXSCALEH  MAXHEIGHT/667.0
#define  MAXWIDTH       [UIScreen mainScreen].bounds.size.width
#define  MAXHEIGHT      [UIScreen mainScreen].bounds.size.height
#define Font(size) [UIFont systemFontOfSize:size/667.0*MAXHEIGHT]

/**
 * RGB 配置颜色
 */
#define    UIColorFromToRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define    UIColorRGB(r, g, b ,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/**
 * 16进制配置颜色
 */
#define UIColorHexFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorHexRGB(rgbValue ,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
// 颜色
// 随机色
#define FYRandomColor [UIColor colorWithRed:arc4random_uniform(255) / 255.0f green:arc4random_uniform(255) / 255.0f blue:arc4random_uniform(255) / 255.0f alpha:1.0f]
// ARGB
#define BYARGBColor(a, r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)/255.0f]
// RGB
#define BYRGBColor(r, g, b) BYARGBColor(255, (r), (g), (b))

#define BYGrayColor(v) BYRGBColor((v), (v), (v))

#define BYGlobalBg BYRGBColor(240,240,240)

#define BYGlobalTextGrayColor [UIColor colorWithHex:@"#4d4d4d"] //主题色灰色

#define BYGlobalBlueColor [UIColor colorWithHex:@"#1B66E5"] //主题色蓝色
#define BYGlobalGreenColor BYRGBColor(23,182,94) //主题绿色
#define BYBigSpaceColor [UIColor colorWithHex:@"#ececec"] //大分割线
#define BYsmallSpaceColor [UIColor colorWithHex:@"#ececec"] //小分割线
#define BYLabelBlackColor [UIColor colorWithHex:@"#333333"] //字体黑颜色
#define BYLabelGrayColor [UIColor colorWithHex:@"#9d9d9d"] //字体灰色
#define BYOrangeColor [UIColor colorWithHex:@"#E74B1A"] //橙色颜色
#define WHITE [UIColor colorWithHex:@"#FFFFFF"] //白色
#define BYBackViewColor BYRGBColor(240,242,246) //浅色背景色
#define BYBtnGrayColor BYRGBColor(219,219,219) //按钮灰色
#define BYWeakSelf __weak typeof(self) weakSelf = self

#define BYSelfClassName NSStringFromClass([self class])

#define BYStatusBarLight [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO]

#define BYStatusBarDefault [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO]

#define BYShowError(error) [BYProgressHUD by_showErrorWithStatus:(error)]

#define BYShowSuccess(data) [BYProgressHUD by_showSuccessWithStatus:(data)]

#define MobClickEvent(eventID,labelName) [MobClick event:eventID label:labelName]

//cell注册
#define BYRegisterCell(cellClass) [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([cellClass class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([cellClass class])];

#define BYCellID(cellClass) NSStringFromClass([cellClass class])


#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//焦距倍数
#define kFocalScale 1.5

//分辨率 与相机分辨率对应：AVCaptureSessionPreset1920x1080
#define kResolutionWidth 1920.0
#define kResolutionHeight 1080.0
//cellName
#define kListCellName @"listcell"

//开发码：开发码和授权文件(smartvisitionocr.lsc)一一对应，替换授权文件需要修改开发码
#define kDevcode @"5REX5ZYZ5BIC5QC"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define kSafeTopHeight ((kScreenHeight==812.0&&kScreenWidth==375.0)? 44:0)

//不隐藏导航栏
#define kSafeTopHasNavHeight ((kScreenHeight==812.0&&kScreenWidth==375.0)? 88:30)
//隐藏掉导航栏
#define kSafeTopNoNavHeight ((kScreenHeight==812.0&&kScreenWidth==375.0)? 44:0)
#define kSafeBottomHeight ((kScreenHeight==812.0&&kScreenWidth==375.0) ? 34:0)
#define kSafeLRX ((kScreenWidth==812.0&&kScreenHeight==375.0) ? 44:0)
#define kSafeBY ((kScreenWidth==812.0&&kScreenHeight==375.0) ? 21:0)

//判断是否是模拟器
#if TARGET_IPHONE_SIMULATOR

#define BYSIMULATOR 1

#elif TARGET_OS_IPHONE

#define BYSIMULATOR 0

#endif






#endif
