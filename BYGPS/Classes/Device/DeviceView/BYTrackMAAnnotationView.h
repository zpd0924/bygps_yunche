//
//  BYTrackMAAnnotationView.h
//  BYGPS
//
//  Created by ZPD on 2017/10/19.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@class BYTrackModel;
@class BYTrackPopView;

@interface BYTrackMAAnnotationView : MAAnnotationView
@property(nonatomic,strong) NSString * carNum;
@property(nonatomic,assign) NSInteger alarmOrOff;
@property(nonatomic,assign) BOOL isControlCar;
@property(nonatomic,assign) NSInteger direction;

@property (nonatomic,strong) BYTrackModel *trackModel;

@property(nonatomic,strong) NSString * address;

@property(nonatomic,assign) CGFloat distance;//我俩距离

@property (nonatomic,strong) BYTrackPopView *trackPopView;

//@property(nonatomic,copy) void (^popDeviceDetailBlcok) (NSInteger tag);

@property(nonatomic,copy) void (^popDismissBlcok) ();

@property (nonatomic,copy) void (^popGotoBaiduMapBlock)();

@property (nonatomic,copy) void(^popSponsorPhotoBlock)(NSString * address);

@end
