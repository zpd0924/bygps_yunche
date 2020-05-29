//
//  BYGuideImageView.h
//  BYGPS
//
//  Created by miwer on 2016/12/13.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYGuideImageView : UIImageView

@property (nonatomic,copy) void(^dismissCallBack)(void);

+(void)showGuideViewWith:(NSString *)imageName touchOriginYScale:(CGFloat)touchOriginYScale;

@end
