//
//  BYInsideListBottomView.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/12.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BYInsideListBottomBlock)(void);

@interface BYInsideListBottomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;
@property (nonatomic,copy) BYInsideListBottomBlock addBlock;
@end
