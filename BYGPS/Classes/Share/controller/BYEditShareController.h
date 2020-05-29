//
//  BYEditShareController.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/13.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYShareListModel.h"

typedef void(^BYEditShareSucessBlock)(void);

@interface BYEditShareController : UIViewController
@property (nonatomic,strong) BYShareListModel *model;
@property (nonatomic,copy) BYEditShareSucessBlock editShareSucessBlock;
@end
