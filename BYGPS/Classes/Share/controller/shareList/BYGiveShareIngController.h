//
//  BYGiveShareIngController.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/12.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RefreshNumberBlock)(NSString *number);

@interface BYGiveShareIngController : UITableViewController
@property (nonatomic,copy) RefreshNumberBlock refreshNumberBlock;
@end












