//
//  BYLivePhotoHttpTool.m
//  BYGPS
//
//  Created by ZPD on 2017/6/14.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYLivePhotoHttpTool.h"
#import "BYNetworkHelper.h"
#import "BYSaveTool.h"


static NSString * const uploadImageUrl = @"image/upload.do";

@implementation BYLivePhotoHttpTool

+(void)POSTSingleImageWithImage:(UIImage *)image Success:(void (^)(id))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [[BYNetworkHelper sharedInstance] POSTUploadsingleImageUrl:uploadImageUrl params:params image:image success:^(id data) {
        [BYProgressHUD by_dismiss];
        if (success) {
            success(data);
        }
    }];
}

+(void)POSTImageWithImageData:(NSData *)img Success:(void (^)(id))success
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"file"] = img;
    [[BYNetworkHelper sharedInstance] POST:uploadImageUrl params:params success:^(id data) {
        
    } failure:^(NSError *error) {
        
    } showError:YES];
}


@end
