//
//  BYAnnotationView.h
//  BYGPS
//
//  Created by miwer on 16/9/8.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>


@interface BYAnnotationView : BMKAnnotationView

@property(nonatomic,strong) NSString * carNum;
@property(nonatomic,assign) NSInteger alarmOrOff;
@property(nonatomic,assign) BOOL isControlCar;
@property(nonatomic,assign) NSInteger direction;

@end
