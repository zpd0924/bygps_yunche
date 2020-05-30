//
//  BYShareSearchePersonHeadView.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/28.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYCompanyModel.h"
typedef void(^BYShareSearchePersonHeadViewBlock)(NSString *keyWord);

@interface BYShareSearchePersonHeadView : UIView
@property (nonatomic,copy) BYShareSearchePersonHeadViewBlock backBlock;
@property (nonatomic,copy) BYShareSearchePersonHeadViewBlock selectBlock;
@end
