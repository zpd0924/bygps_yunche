//
//  BYShareListSearchView.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/27.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BYShareListSearchBlock)(void);

@interface BYShareListSearchView : UIView
@property (nonatomic,copy) BYShareListSearchBlock shareListSearchBlock;
@end
