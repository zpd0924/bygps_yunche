//
//  BYNaviSearchBar.h
//  BYGPS
//
//  Created by miwer on 2016/10/26.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYButton.h"

typedef void(^BYNaviSearchBlock)(void);

@interface BYNaviSearchBar : UIView
@property (nonatomic,strong) BYButton *searImageBtn;
@property(nonatomic,strong) UITextField * searchField;
///是否有扫一扫
@property (nonatomic,assign) BOOL isScan;
///是否是车辆搜索
@property (nonatomic,assign) BOOL isCarSearch;
///是否是分享搜索
@property (nonatomic,assign) BOOL isShareSearch;
@property (nonatomic,copy) BYNaviSearchBlock searchBlock;
@end
