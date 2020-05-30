//
//  BYFenceAnnotationView.h
//  BYGPS
//
//  Created by ZPD on 2017/8/16.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>

@class BYControlModel;
@class BYTrackModel;

@interface BYFenceAnnotationView : BMKAnnotationView

@property (nonatomic,strong) BYControlModel *model;
@property (nonatomic,strong) BYTrackModel *tracModel;
@property(nonatomic,strong) NSString * carNum;
@property(nonatomic,assign) NSInteger alarmOrOff;
@property(nonatomic,assign) BOOL isControlCar;
@property(nonatomic,assign) NSInteger direction;

@end
