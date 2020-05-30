//
//  GDObjectUploadManager.m
//  GDHealth
//
//  Created by michael on 2017/7/29.
//  Copyright © 2017年 Gains. All rights reserved.
//

#import "GDObjectUploadManager.h"
#import "UIImage+Process.h"
//#import "AceUserDefaultManager.h"

@implementation GDObjectUploadManager

/**
 *  上传单张图片到OSS
 *
 *  @param imgType              图片类型（如用户头像等，根据类型创建不同的文件路径，具体见下面文件命名规则）
 *  @param image                UIImage对象
 *  @param compressionMode      是否需要高清品质（是否高清压缩方式会不一样，高清时，目标压缩大小暂时是1M）
 *  @param uploadProgress       上传进度回调（当前上传段长度、当前已经上传总长度、一共需要上传的总长度，单位：字节）
 *  @param completionHandler    上传完成回调（错误信息、文件名、文件总长度。当错误为空时，文件名需上传到我们的服务器）
 */
+ (void)uploadImageWithImgType:(GDUploadObjectType)imgType image:(UIImage *)image compressionMode:(GDUploadImageCompressionMode)compressionMode uploadProgress:(GDUploadProgressBlock)uploadProgress completionHandler:(GDUploadCompletionBlock)completionHandler
{
    // 异步压缩图片
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 不同的压缩方式的处理
        NSData *imageData;
        switch (compressionMode) {
            case GDUploadImageCompressionModeDefault:
            {
                imageData = [image getImageDataByScalingCroppingAndCompressImageWithMaxSize:300*1024 maxCompression:0.5];
            }
                break;
                
            case GDUploadImageCompressionModeLowDefinition:
            {
                imageData = [image getImageDataByScalingCroppingAndCompressImageWithMaxSize:100*1024 maxCompression:0.1];
            }
                
            case GDUploadImageCompressionModeHighDefinition:
            {
                imageData = [image getImageDataByScalingCroppingAndCompressImageWithMaxSize:1024*1024 maxCompression:0.5];
            }
                break;
                
            case GDUploadImageCompressionModeOriginal:
            {
                imageData = UIImageJPEGRepresentation(image, 1.0);
            }
                break;
        }
        // 根据图片类型以一定的规则来命名文件
        NSString *fileName = [self getFileNameWithObjectType:imgType];
        // 回到主线程发起上传OSS请求
        dispatch_async(dispatch_get_main_queue(), ^{
            [self asyncUploadObjectWithfileName:fileName objectData:imageData localFilePath:nil uploadProgress:uploadProgress completionHandler:completionHandler];
        });
        
//    });
    
}
/**
 *  上传语音到OSS
 *
 *  @param voiceFileName          本地语音文件
 *  @param uploadProgress    上传进度回调（当前上传段长度、当前已经上传总长度、一共需要上传的总长度，单位：字节）
 *  @param completionHandler 上传完成回调（错误信息、文件名、文件总长度。当错误为空时，文件名需上传到我们的服务器）
 */
+ (void)uploadVoiceWithVoiceFileName:(NSString *)voiceFileName uploadProgress:(GDUploadProgressBlock)uploadProgress completionHandler:(GDUploadCompletionBlock)completionHandler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 异步读取NSData
        NSData *voiceData = [NSData dataWithContentsOfFile:voiceFileName];
        // 根据Object类型以一定的规则来命名文件
        NSString *fileName = [self getFileNameWithObjectType:GDUploadObjectTypeVoice];
        // 回到主线程发起上传OSS请求
        dispatch_async(dispatch_get_main_queue(), ^{
            [self asyncUploadObjectWithfileName:fileName objectData:voiceData localFilePath:nil uploadProgress:uploadProgress completionHandler:completionHandler];
        });
    });
    
}


/**
 *	异步上传Object
 *
 *	@param fileName             objectKey
 *  @param objectData           二进制（与filePath二选一传值）
 *	@param filePath             路径（与objectData二选一传值）
 *  @param uploadProgress       上传进度回调（当前上传段长度、当前已经上传总长度、一共需要上传的总长度，单位：字节）
 *	@param completionHandler    完成回调（错误、文件名、总长度。当error有值时，失败，否则成功）
 */
+ (void)asyncUploadObjectWithfileName:(NSString *)fileName objectData:(NSData *)objectData localFilePath:(NSString *)filePath uploadProgress:(GDUploadProgressBlock)uploadProgress completionHandler:(GDUploadCompletionBlock)completionHandler
{
    GDOSSServiceManager *manager = [GDOSSServiceManager sharedManager];
    // 先回调一下总大小
    if (uploadProgress) {
        uploadProgress(0.0, 0, 0, objectData.length);
    }
    // 异步上传图片
    [manager asyncUploadObjectWithfileName:fileName objectData:objectData localFilePath:filePath uploadProgress:uploadProgress completionHandler:completionHandler];
}


#pragma mark - ********** helper **********
/// 根据图片类型获取文件名
+ (NSString *)getFileNameWithObjectType:(GDUploadObjectType)objType
{
    /*
     OSS服务是没有文件夹这个概念的，所有元素都是以文件来存储，但给用户提供了创建模拟文件夹的方式。创建模拟文件夹本质上来说是创建了一个名字以“/”结尾的文件，对于这个文件照样可以上传下载,只是控制台会对以“/”结尾的文件以文件夹的方式展示。
     如，在上传文件时，如果把ObjectKey写为"folder/subfolder/file"，即是模拟了把文件上传到folder/subfolder/下的file文件。注意，路径默认是”根目录”，不需要以’/‘开头。
     Object 命名规范：
     1.使用 UTF-8 编码。
     2.长度必须在 1-1023 字节之间。
     3.不能以“/”或者“\”字符开头。
     */
    
    /*
     ----- 文件名统一命名格式 -----
     1.用户头像 UserHead/yyyyMMddHHmmssSSS.jeg 如：UserHead/.jpg
     */
    
    NSString *fileName;
    // yyyyMMddHHmmssSSS
    NSTimeInterval totalMilliseconds = [[NSDate date] timeIntervalSince1970] * 1000.0;
    BYLog(@"totalMilliseconds = %f", totalMilliseconds);
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:totalMilliseconds / 1000.0];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyyMMddHHmmssSSS";
    NSString *timeStr = [dateFormatter stringFromDate:currentDate];
    switch (objType) {
        case GDUploadObjectTypeUserStudent: // 学生用户
            fileName = [NSString stringWithFormat:@"%@%d.jpg", timeStr,[self getRandomNumberWithFrom]];
            break;
        case GDUploadObjectTypeVoice: // 学生声音
            fileName = [NSString stringWithFormat:@"Student/%@/%@/%@.wav", @"User", @"anzhuang", timeStr];
            break;
        case GDUploadObjectTypeVideo: // 学生视频
            fileName = [NSString stringWithFormat:@"Student/%@/%@/%@.mp4", @"User", @"anzhuang", timeStr];
            break;
          
        case GDUploadObjectTypeUnknown:
            break;
    }
    
     fileName = [NSString stringWithFormat:@"%@/%@",[BYSaveTool objectForKey:BYImgeBucket],fileName];
    return fileName;
}


/// 获取某个范围内的随机整数
+ (int)getRandomNumberWithFrom
{
   int from = 0;
   int to = 9999;
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
