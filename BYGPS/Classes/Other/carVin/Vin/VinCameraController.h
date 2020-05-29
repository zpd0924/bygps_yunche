//
//  VinCameraController.h
//  VinDemo
//
//  Created by ocrgroup on 2017/9/28.
//  Copyright © 2017年 ocrgroup. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^VinPhotoInBlock)(void);

typedef enum : NSUInteger {
    kVinPhoneDirectionUp,
    kVinPhoneDirectionUpsideDown,
    kVinPhoneDirectionLeft,
    kVinPhoneDirectionRight,
} VinPhoneDirection;

@protocol VinCameraDelegate <NSObject>

@required

/**
 识别结果回调

 @param cameraController 自定义相机控制器
 @param vinCode vin码识别结果
 @param vinImage vin码图片
 */
- (void)cameraController:(UIViewController *)cameraController audioRecognizeFinishWithResult:(NSString *)vinCode andVinImage:(UIImage *)vinImage;

@optional

/**
 点击取消回调方法(内部已pop和dismiss,外部无需做,此接口为混合开发项目提供)
 
 @param cameraController 相机控制器
 */
- (void)backButtonClickWithVinCamera:(UIViewController *)cameraController;

@end

@interface VinCameraController : UIViewController

@property (nonatomic, weak) id <VinCameraDelegate> delegate;

@property (nonatomic,copy) VinPhotoInBlock vinPhotoInBlock;

/**
 当前屏幕锁定方向
 */
@property (nonatomic, assign) VinPhoneDirection deviceDirection;

/**
 是否固定一个方向识别
 */
@property (nonatomic, assign) BOOL isOneDirection;

- (instancetype)initWithAuthorizationCode:(NSString *)authorizationCode;

@end
