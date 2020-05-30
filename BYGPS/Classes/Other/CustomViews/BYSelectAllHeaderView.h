//
//  BYSelectAllHeaderView.h
//  BYGPS
//
//  Created by miwer on 16/8/31.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYSelectAllHeaderView : UIView

@property(nonatomic,copy) void (^selectAllBlock) ();
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;

@end
