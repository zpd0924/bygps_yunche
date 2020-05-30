//
//  BYBelongCompanyViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYBelongCompanyViewController : UIViewController
@property(nonatomic,strong) void (^groupIdsStrBlock) (NSString *groupIdsStr);
@end
