//
//  BYRegeoHttpTool.h
//  BYGPS
//
//  Created by ZPD on 2017/6/16.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYRegeoHttpTool : NSObject

+(void)POSTRegeoAddressWithLat:(CGFloat)lat lng:(CGFloat)lng success:(void (^)(id data))success failure:(void (^)(NSError *error))failure;

@end
