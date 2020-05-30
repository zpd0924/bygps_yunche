//
//  GDObjectUploadManager.h
//  GDHealth
//
//  Created by michael on 2017/7/29.
//  Copyright © 2017年 Gains. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GDOSSServiceManager.h"

typedef NS_ENUM(NSInteger, GDUploadObjectType) {
    GDUploadObjectTypeUnknown,
    GDUploadObjectTypeUserStudent,  // 图片
    GDUploadObjectTypeVoice,//声音
    GDUploadObjectTypeVideo,//视频
    
};

typedef NS_ENUM(NSInteger, GDUploadImageCompressionMode) {
    GDUploadImageCompressionModeDefault, // 默认：中清晰度:最大300K，压缩系数最大0.5
    GDUploadImageCompressionModeLowDefinition,  // 低清晰度:压缩系数0.1，分
    GDUploadImageCompressionModeHighDefinition,  // 高清晰度:最大1M
    GDUploadImageCompressionModeOriginal,  // 原图
};

@interface GDObjectUploadManager : NSObject


/**
 *  上传单张图片到OSS
 *
 *  @param imgType              图片类型（如用户头像等，根据类型创建不同的文件路径，具体见下面文件命名规则）
 *  @param image                UIImage对象
 *  @param compressionMode      是否需要高清品质（是否高清压缩方式会不一样，高清时，目标压缩大小暂时是1M）
 *  @param uploadProgress       上传进度回调（当前上传段长度、当前已经上传总长度、一共需要上传的总长度，单位：字节）
 *  @param completionHandler    上传完成回调（错误信息、文件名、文件总长度。当错误为空时，文件名需上传到我们的服务器）
 */
+ (void)uploadImageWithImgType:(GDUploadObjectType)imgType image:(UIImage *)image compressionMode:(GDUploadImageCompressionMode)compressionMode uploadProgress:(GDUploadProgressBlock)uploadProgress completionHandler:(GDUploadCompletionBlock)completionHandler;

/**
 *  上传语音到OSS
 *
 *  @param voiceFileName          本地语音文件
 *  @param uploadProgress    上传进度回调（当前上传段长度、当前已经上传总长度、一共需要上传的总长度，单位：字节）
 *  @param completionHandler 上传完成回调（错误信息、文件名、文件总长度。当错误为空时，文件名需上传到我们的服务器）
 */
+ (void)uploadVoiceWithVoiceFileName:(NSString *)voiceFileName uploadProgress:(GDUploadProgressBlock)uploadProgress completionHandler:(GDUploadCompletionBlock)completionHandler;
@end
