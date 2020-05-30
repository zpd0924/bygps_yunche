//
//  VinManager.h
//  VinDemo
//
//  Created by ocrgroup on 2018/3/9.
//  Copyright © 2018年 ocrgroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VinCameraController.h"

typedef void(^PhotoInBlcok)(void);

@protocol VinManagerDelegate <NSObject>


/**
 导入/拍照识别回调
 
 @param vinCode 识别结果
 @param errorCode 错误码
 */
- (void)photoRecognizeFinishWithResult:(NSString *)vinCode andErrorCode:(int)errorCode;


/**
 视频流识别回调
 
 @param cameraController 自定义相机控制器
 @param vinCode 识别结果
 @param vinImage vin码图片
 */
- (void)cameraController:(UIViewController *)cameraController audioRecognizeFinishWithResult:(NSString *)vinCode andVinImage:(UIImage *)vinImage;

@end

@interface VinManager : NSObject

@property (nonatomic,copy) PhotoInBlcok photoInBlcok;

/**
 回调代理
 */
@property (nonatomic, weak) id <VinManagerDelegate> delegate;


/**
 单例全局访问点
 
 @return 对象实例
 */
+ (instancetype)sharedVinManager;

/**
 拍照/导入识别
 
 @param vinImage 需要识别的图像
 @param authCode 授权文件名
 */
- (void)recognizeVinCodeWithPhoto:(UIImage *)vinImage andAuthCode:(NSString *)authCode;


/**
 视频流预览识别
 
 @param parentController 当前控制器(self)
 @param oneDirection 是否只固定一个方向识别(YES-只当前系统方向可识别 NO-四个方向都可识别)
 @param usePush 是否使用push弹出控制器 [YES-push NO-modal(模态弹出)]
 @param authCode 授权文件名
 */
- (void)recognizeVinCodeByAudioWithController:(UIViewController *)parentController isOneDirectionRecognize:(BOOL)oneDirection isUsePush:(BOOL)usePush andAuthCode:(NSString *)authCode;


@end
