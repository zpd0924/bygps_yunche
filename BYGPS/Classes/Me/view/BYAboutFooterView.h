//
//  BYAboutFooterView.h
//  BYGPS
//
//  Created by ZPD on 2017/7/20.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYAboutFooterView : UIView

@property (nonatomic,copy) void(^shareToWXBlock)();
@property (nonatomic,copy) void(^phoneBlock)();

@end
