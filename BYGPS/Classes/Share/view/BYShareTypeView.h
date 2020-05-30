//
//  BYShareTypeView.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/11.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^BYShareTypeBlock)(BYSharePlatformType platformType);
@interface BYShareTypeView : UIView
- (void)show;
-(void)hideView;
@property (nonatomic,copy) BYShareTypeBlock shareTypeBlock;
@end
