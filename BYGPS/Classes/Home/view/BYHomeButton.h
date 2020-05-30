//
//  BYHomeButton.h
//  BYGPS
//
//  Created by miwer on 2017/2/8.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    BYBadgeNone,
    BYBadgePoint,
    BYBadgeNumber
    
}BYBadgeShowType;

@interface BYHomeButton : UIButton

@property (nonatomic,assign) NSInteger badgeNum;

+ (BYHomeButton *)createButtonWith:(NSString *)image title:(NSString *)title badgeShowType:(BYBadgeShowType)badgeShowType;

@end
