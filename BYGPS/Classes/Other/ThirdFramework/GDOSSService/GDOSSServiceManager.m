//
//  CYOssServiceManager.m
//  GDHealth
//
//  Created by michael on 2017/7/29.
//  Copyright © 2017年 Gains. All rights reserved.
//

#import "GDOSSServiceManager.h"
#import <AliyunOSSiOS/OSSService.h>
//#import "AceUserDefaultManager.h"
#import "BYLoginHttpTool.h"

//static NSString *const kEndPoint = @"http://file.hitotem.com";
//static NSString *const accessKeyId = @"LTAIToFIgKUrpC93";
//static NSString *const accessKeySecret = @"oss-cn-shenzhen.aliyuncs.com";
///// MARK: 测试/发布环境标志, 0=develop, 1=product
//#if ISNETWORKWAN
//static NSString *const kBucketName = @"yery-test-oss-01";
//#else
//static NSString *const kBucketName = @"yery-test-oss-01";
//#endif
@implementation GDOSSServiceManager
{
    OSSClient *_client;
    NSString *_callbackAddress; // 服务器回调地址
    OSSPutObjectRequest *_putRequest;
}


/**
 *	获取GDOSSServiceManager单例
 *
 *	@return GDOSSServiceManager单例
 */
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static GDOSSServiceManager *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GDOSSServiceManager alloc] init];
        [sharedInstance initOSSClient];
    });
    
    return sharedInstance;
}


/**
 *	初始化OSSClient
 */
- (void)initOSSClient
{
    /*OSSClient是OSS服务的iOS客户端，它为调用者提供了一系列的方法，可以用来操作，管理存储空间（bucket）和文件（object）等。在使用SDK发起对OSS的请求前，您需要初始化一个OSSClient实例，并对它进行一些必要设置。*/
    
    /*必须设置EndPoint和CredentialProvider,也可以在初始化的时候设置详细的ClientConfiguration*/
    
    // ***** STS鉴权模式 *****
    /*
     如果您期望SDK能自动帮您管理Token的更新，那么，您需要告诉SDK如何获取Token。在SDK的应用中，您需要实现一个回调，这个回调通过您实现的方式去获取一个Federation Token(即StsToken)，然后返回。SDK会利用这个Token来进行加签处理，并在需要更新时主动调用这个回调获取Token
     */
//    id<OSSCredentialProvider> credential = [[OSSFederationCredentialProvider alloc] initWithFederationTokenGetter:^OSSFederationToken * {
//        return [self getFederationToken];
//    }];
    
    id<OSSCredentialProvider> credential = [[OSSCustomSignerCredentialProvider alloc] initWithImplementedSigner:^NSString *(NSString *contentToSign, NSError *__autoreleasing *error) {
        return [BYSaveTool valueForKey:BYSignature];
    }];
    
    // 设置网络参数
    OSSClientConfiguration *conf = [OSSClientConfiguration new];
    // 网络请求遇到异常失败后的重试次数
    conf.maxRetryCount = 0;
    // 网络请求的超时时间
    conf.timeoutIntervalForRequest = 30;
    // 允许资源传输的最长时间
    conf.timeoutIntervalForResource = 10 * 60;
    
    // 实例化OSSClient
    _client = [[OSSClient alloc] initWithEndpoint:[BYSaveTool objectForKey:BYEndpoint] credentialProvider:credential clientConfiguration:conf];
}



/**
 *	获取FederationToken
 *
 *	@return FederationToken
 */
- (OSSFederationToken *)getFederationToken
{
    OSSFederationToken *token = [OSSFederationToken new];

//    token.tAccessKey = accessKeyId;
//    token.tSecretKey = accessKeySecret;
//    token.tToken = [dataDic objectForKey:@"securityToken"];
//    token.expirationTimeInGMTFormat = [dataDic objectForKey:@"expiration"];

    
//    BYLog(@"AccessKey: %@ \n SecretKey: %@ \n Token:%@ expirationTime: %@ \n",
//          token.tAccessKey, token.tSecretKey, token.tToken, token.expirationTimeInGMTFormat);
    
    return token;
}

/**
 *	设置server callback地址
 *
 *	@param address 服务器回调地址
 */
- (void)setCallbackAddress:(NSString *)address
{
    _callbackAddress = address;
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
- (void)asyncUploadObjectWithfileName:(NSString *)fileName objectData:(NSData *)objectData localFilePath:(NSString *)filePath uploadProgress:(GDUploadProgressBlock)uploadProgress completionHandler:(GDUploadCompletionBlock)completionHandler
{
    if (!fileName || fileName.length == 0) {
        return;
    }
    
    _putRequest = [OSSPutObjectRequest new];
    // --- 必填字段 ---
    _putRequest.bucketName = [BYSaveTool objectForKey:BYbucket];
    /*
     OSS服务是没有文件夹这个概念的，所有元素都是以文件来存储，但给用户提供了创建模拟文件夹的方式。创建模拟文件夹本质上来说是创建了一个名字以“/”结尾的文件，对于这个文件照样可以上传下载,只是控制台会对以“/”结尾的文件以文件夹的方式展示。
     如，在上传文件时，如果把ObjectKey写为"folder/subfolder/file"，即是模拟了把文件上传到folder/subfolder/下的file文件。注意，路径默认是”根目录”，不需要以’/‘开头。
     Object 命名规范：
     1.使用 UTF-8 编码。
     2.长度必须在 1-1023 字节之间。
     3.不能以“/”或者“\”字符开头。
     */
    _putRequest.objectKey = fileName;
    // 上传Object可以直接上传OSSData，或者通过NSURL上传一个文件
    // 数据总长度
    NSUInteger totalBytes = 0;
    if (objectData) {
        _putRequest.uploadingData = objectData;
        totalBytes = objectData.length;
    } else {
        _putRequest.uploadingFileURL = [NSURL fileURLWithPath:filePath];
        totalBytes = [NSData dataWithContentsOfFile:filePath].length;
    }
    // --- 可选字段，可不设置 ---
    /*上传时可以显式指定ContentType，如果没有指定，SDK会根据文件名或者上传的ObjectKey自动判断。另外，上传Object时如果设置了Content-Md5，那么OSS会用之检查消息内容是否与发送时一致。SDK提供了方便的Base64和MD5计算方法。*/
    // 设置Content-Type，可选
    //_putRequest.contentType = @"application/octet-stream";
    // 设置MD5校验，可选
    //_putRequest.contentMd5 = [OSSUtil base64Md5ForFilePath:filePath]; // 如果是文件路径
    // put.contentMd5 = [OSSUtil base64Md5ForData:imageData]; // 如果是二进制数据
    // 进度设置，可选
    _putRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        // 当前上传段长度、当前已经上传总长度、一共需要上传的总长度
        //AceLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (uploadProgress) {
                CGFloat progress = 0.0;
                if (totalBytesExpectedToSend > 0) {
                    progress = totalByteSent / (totalBytesExpectedToSend * 1.0);
                    // 0.0 - 1.0
                    progress = MIN(1.0, MAX(0.0, progress));
                }
                uploadProgress(progress, (NSUInteger)bytesSent, (NSUInteger)totalByteSent, (NSUInteger)totalBytesExpectedToSend);
            }
        });
    };
    // 服务器回调，可选
    /*
     客户端在上传Object时可以指定OSS服务端在处理完上传请求后，通知您的业务服务器，在该服务器确认接收了该回调后将回调的结果返回给客户端。因为加入了回调请求和响应的过程，相比简单上传，使用回调通知机制一般会导致客户端花费更多的等待时间。(更多信息请查看最下方注释部分的“关于上传回调”)
     */
    if (_callbackAddress) {
        _putRequest.callbackParam = @{@"callbackUrl": _callbackAddress,
                                      @"callbackBody": @"filename=${object}" // callbackBody可自定义传入的信息
                                     };
    }
    
    OSSTask *task = [_client putObject:_putRequest];
    [task continueWithBlock:^id(OSSTask *task) {
        OSSPutObjectResult *result = task.result;
        // 查看server callback是否成功
        if (!task.error) {
            BYLog(@"upload image success!");
            BYLog(@"server callback : %@", result.serverReturnJsonString);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandler) {
                    completionHandler(nil, fileName, totalBytes);
                }
            });
        } else {
            // 注意：取消上传也属于失败
            BYLog(@"upload image failed, error = %@", task.error);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandler) {
                    completionHandler(task.error, fileName, totalBytes);
                }
            });
        }
        _putRequest = nil;
        
        return nil;
    }];
}

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    BYLog(@"didReceiveChallenge: challenge.protectionSpace = %@", challenge.protectionSpace);
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = nil;
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        if (credential) {
            disposition = NSURLSessionAuthChallengeUseCredential;
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}


/*
 // ********** 关于上传回调 **********
 （阿里云说明网址：https://help.aliyun.com/document_detail/31853.html?spm=5176.doc31852.2.8.hjQgYz）
 OSS在上传文件完成的时候可以提供回调（Callback）给应用服务器。您只需要在发送给OSS的请求中携带相应的Callback参数，即能实现回调。现在支持CallBack的API 接口有：PutObject、PostObject、CompleteMultipartUpload。
 上传回调的一种典型应用场景是与授权第三方上传同时使用，客户端在上传文件到OSS的时候指定到服务器端的回调，当客户端的上传任务在OSS执行完毕之后，OSS会向应用服务器端主动发起HTTP请求进行回调，这样服务器端就可以及时得到上传完成的通知从而可以完成诸如数据库修改等操作，当回调请求接收到服务器端的响应之后OSS才会将状态返回给客户端。
 OSS在向应用服务器发送POST回调请求的时候，会在POST请求的body中包含一些参数来携带特定的信息，这些参数有两种，一种是系统定义的参数，如Bucket名称、Object名称等；另外一种就是自定义的参数，您可以在发送带回调的请求给OSS的时候根据应用逻辑的需要指定这些参数。您可以通过使用自定义参数来携带一些和应用逻辑相关的信息，比如发起请求的用户id等。
 具体使用自定义参数的方法可以参考https://help.aliyun.com/document_detail/31989.html?spm=5176.doc31853.2.1.GZ5Eqs
 注意:
 目前只有大陆地区支持上传回调功能。
 目前只有简单上传(PutObject)、表单上传(PostObject)、分片上传完成（Complete Multipart Upload）操作支持上传回调功能
 */


@end
