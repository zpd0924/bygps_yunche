//
//  BYAutoServiceSearchViewController.h
//  BYGPS
//
//  Created by ZPD on 2018/12/11.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYAutoServiceConstant.h"
#import "BYNaviSearchBar.h"

typedef enum : NSUInteger {
    carNumScanType,
    vinNumScanType,
    deviceScanType,
} ScanType;




@interface BYAutoServiceSearchViewController : UIViewController

@property (nonatomic,assign) BYFunctionType functionType;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,assign) ScanType scanType;
@property (nonatomic,strong) NSString *keyWord;//搜索关键字
@property(nonatomic,strong) BYNaviSearchBar * naviSearchBar;

@end
