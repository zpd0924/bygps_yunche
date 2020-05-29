//
//  BYReplayAnnotationView.h
//  BYGPS
//
//  Created by miwer on 16/9/23.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapView.h>

@interface BYReplayAnnotationView : BMKAnnotationView

@property(nonatomic,strong) NSString * imageStr;

@property(nonatomic,strong)UIImageView * imageView;

@end
