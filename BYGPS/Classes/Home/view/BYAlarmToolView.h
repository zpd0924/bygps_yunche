//
//  BYAlarmToolView.h
//  BYGPS
//
//  Created by miwer on 16/9/20.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYAlarmToolView : UIView

@property(nonatomic,copy) void (^handleBlock) ();

@property(nonatomic,strong) NSString * title;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *handleButtonContraint_W;

@end
