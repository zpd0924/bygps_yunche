//
//  CYOssServiceManager.h
//  GDHealth
//
//  Created by michael on 2017/7/29.
//  Copyright © 2017年 Gains. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^GDUploadProgressBlock) (CGFloat progress, NSUInteger bytesSent, NSUInteger totalBytesSent, NSUInteger totalBytesExpectedToSend);
typedef void (^GDUploadCompletionBlock) (NSError *error, NSString *fileName, NSUInteger totalBytesExpectedToSend);

@interface GDOSSServiceManager : NSObject <NSURLSessionDelegate>


/**
 *	获取GDOSSServiceManager单例
 *
 *	@return GDOSSServiceManager单例
 */
+ (instancetype)sharedManager;


/**
 *	设置server callback地址
 *
 *	@param address 服务器回调地址
 */
- (void)setCallbackAddress:(NSString *)address;


/**
 *	异步上传Object
 *
 *	@param fileName             objectKey
 *  @param objectData           二进制（与filePath二选一传值）
 *	@param filePath             路径（与objectData二选一传值）
 *  @param uploadProgress       上传进度回调（当前上传段长度、当前已经上传总长度、一共需要上传的总长度，单位：字节）
 *	@param completionHandler    完成回调（错误、文件名、总长度。当error有值时，失败，否则成功）
 */
- (void)asyncUploadObjectWithfileName:(NSString *)fileName objectData:(NSData *)objectData localFilePath:(NSString *)filePath uploadProgress:(GDUploadProgressBlock)uploadProgress completionHandler:(GDUploadCompletionBlock)completionHandler;


@end
