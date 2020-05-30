//
//  BYLookMoreView.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/16.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LookMoreBtnBlock)();

@interface BYLookMoreView : UIView

@property (nonatomic,copy) LookMoreBtnBlock lookMoreBtnBlock;

@end
