//
//  BYCodeImageView.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/25.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BYCodeImageBlock)(NSString *codeStr);
@interface BYCodeImageView : UIView
@property (nonatomic, strong) NSString *imageCodeStr;
@property (nonatomic, assign) BOOL isRotation;
@property (nonatomic, copy) BYCodeImageBlock bolck;

-(void)freshVerCode;
@end
