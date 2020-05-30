//
//  BYAddMoreHeaderView.h
//  BYGPS
//
//  Created by bean on 16/7/30.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYAddMoreHeaderView : UIView

@property(nonatomic,strong) NSString * mostCount;

@property (weak, nonatomic) IBOutlet UIButton *addMoreButton;

@property(copy,nonatomic)void (^ addMoreBlock) ();

@end
