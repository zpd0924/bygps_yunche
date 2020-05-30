//
//  BYReplayStartPopView.h
//  BYGPS
//
//  Created by ZPD on 2017/8/22.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYReplayModel;
@interface BYReplayStartPopView : UIView

@property (nonatomic,strong) BYReplayModel *startModel;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * address;

@end
