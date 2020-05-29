//
//  BYGroupsSelectController.h
//  BYGPS
//
//  Created by miwer on 16/10/8.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYGroupsSelectController : UIViewController

@property(nonatomic,strong) void (^groupIdsStrBlock) (NSString *groupIdsStr);

@end
