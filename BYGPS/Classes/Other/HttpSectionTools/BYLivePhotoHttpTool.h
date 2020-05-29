//
//  BYLivePhotoHttpTool.h
//  BYGPS
//
//  Created by ZPD on 2017/6/14.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BYLivePhotoHttpTool : NSObject

+(void)POSTSingleImageWithImage:(UIImage *)image Success:(void (^)(id data))success;

+(void)POSTImageWithImageData:(NSData *)img Success:(void (^)(id data))success;

@end
