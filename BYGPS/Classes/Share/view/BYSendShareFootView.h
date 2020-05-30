//
//  BYSendShareFootView.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BYSendShareFootViewGoToShareBlock)(NSString *remark);

@interface BYSendShareFootView : UIView
@property (nonatomic,copy) BYSendShareFootViewGoToShareBlock goToShareBlock;
@end
