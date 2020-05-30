//
//  BYGeoSearchTool.h
//  BYGPS
//
//  Created by miwer on 16/9/19.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

@interface BYGeoSearchTool : NSObject

@property(nonatomic,strong) void (^geoDecodeBlock) (NSString * address);

+(void)geoDecodeWith:(CLLocationCoordinate2D)coordinate target:(id)target success:(void (^)(NSString *address))success;

@end
