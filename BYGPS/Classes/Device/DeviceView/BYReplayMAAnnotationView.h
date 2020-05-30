//
//  BYReplayMAAnnotationView.h
//  BYGPS
//
//  Created by ZPD on 2017/10/24.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class BYReplayModel;
@class BYParkEventModel;
@class BYReplayPopView;
@class BYReplayStartPopView;
@class BYParkPopView;

@interface BYReplayMAAnnotationView : MAAnnotationView

@property(nonatomic,strong) NSString * imageStr;

@property(nonatomic,strong)UIImageView * imgView;

@property (nonatomic,strong) NSString *address;

@property (nonatomic,strong) BYReplayModel *replayModel;

@property (nonatomic,strong) BYParkEventModel * parkModel;

@property (nonatomic,strong) BYReplayPopView *replayPopView;

@property (nonatomic,strong) BYReplayStartPopView *startPopView;

@property (nonatomic,strong) BYParkPopView *parkPopView;

@property (nonatomic,assign) NSInteger index;

@end
