//
//  BYSelfServiceInstallFooterView.h
//  BYGPS
//
//  Created by ZPD on 2018/9/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYPhotoModel.h"

@interface BYSelfServiceInstallFooterView : UIView

@property (nonatomic,copy) void(^deleteVinImgBlock)(void);
@property (nonatomic,copy) void(^tapVINImgBgViewCallBack)(void);

@property (nonatomic,strong) BYPhotoModel *photoModel;

@end
