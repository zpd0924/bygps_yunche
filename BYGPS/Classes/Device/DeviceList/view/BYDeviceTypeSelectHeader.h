//
//  BYDeviceTypeSelectHeader.h
//  BYGPS
//
//  Created by miwer on 2016/12/12.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYDeviceTypeSelectHeader : UIView

@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;
@property(nonatomic,copy) void (^selectAllBlock) ();
@property(nonatomic,copy) void (^wiredActionBlock) ();
@property(nonatomic,copy) void (^wirelessActionBlock) ();

@end
