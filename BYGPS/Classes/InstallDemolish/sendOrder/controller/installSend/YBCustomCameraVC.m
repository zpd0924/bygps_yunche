
//
//  YBCustomCameraVC.m
//  YBCustomCamera
//
//  Created by wyb on 2017/5/8.
//  Copyright © 2017年 中天易观. All rights reserved.
//

#import "YBCustomCameraVC.h"
#import "BYSendWorkHttpTool.h"
#import <Masonry.h>
#import "YBCustomCameraView.h"
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight  [UIScreen mainScreen].bounds.size.height

//导入相机框架
#import <AVFoundation/AVFoundation.h>
//将拍摄好的照片写入系统相册中，所以我们在这里还需要导入一个相册需要的头文件iOS8
#import <Photos/Photos.h>

@interface YBCustomCameraVC ()<UIAlertViewDelegate>

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

//照片输出流
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;

// ------------- UI --------------
//拍照按钮
@property (nonatomic)UIButton *photoButton;
//闪光灯按钮
@property (nonatomic)UIButton *flashButton;
//聚焦
@property (nonatomic)UIView *focusView;
//是否开启闪光灯
@property (nonatomic)BOOL isflashOn;


@end

@implementation YBCustomCameraVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    if ( [self checkCameraPermission]) {
        
        [self customCamera];
        [self initSubViews];
        
        [self focusAtPoint:CGPointMake(0.5, 0.5)];
        
    }
    
   
    
}

- (void)customCamera
{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc]init];
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        
        [self.session setSessionPreset:AVCaptureSessionPreset1280x720];
        
    }
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
        
    }
   
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    
    //修改设备的属性，先加锁
    if ([self.device lockForConfiguration:nil]) {
        
        //闪光灯自动
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        //解锁
        [self.device unlockForConfiguration];
        
        
    }
    
}

- (void)initSubViews
{
    UIButton *btn = [UIButton new];
    btn.frame = CGRectMake(5, 20, 40, 40);
    [btn setImage:[UIImage imageNamed:@"back_camera_btn"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
    self.photoButton = [UIButton new];
    self.photoButton.frame = CGRectMake(KScreenWidth/2.0-30, KScreenHeight-100, 60, 60);
    [self.photoButton setImage:[UIImage imageNamed:@"photograph"] forState:UIControlStateNormal];
     [self.photoButton addTarget:self action:@selector(shutterCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photoButton];
    
    self.focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    self.focusView.layer.borderWidth = 1.0;
    self.focusView.layer.borderColor = [UIColor greenColor].CGColor;
    [self.view addSubview:self.focusView];
    self.focusView.hidden = YES;
    
   
    
    
    
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.flashButton setImage:[UIImage imageNamed:@"flash_camera_btn"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"flash_camera_sel_btn"] forState:UIControlStateSelected];
    self.flashButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.flashButton sizeToFit];
    [ self.flashButton addTarget:self action:@selector(FlashOn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview: self.flashButton];
    [_flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(btn);
        make.right.mas_equalTo(-10);
    }];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    [self drawShapeRect];
}
#pragma mark 绘制矩形
- (void)drawShapeRect
{
    YBCustomCameraView *countView = [YBCustomCameraView by_viewFromXib];
    countView.backgroundColor = [UIColor clearColor];
    if (_index == 1) {
        countView.tipLabel.text = @"请对准车牌号";
    }else{
        countView.tipLabel.text = @"请对准前面挡风玻璃、汽车、铭牌或行驶证上的车架号";
    }
    [self.view addSubview:countView];
    [countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MAXWIDTH - 30, _index == 1?150:90));
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(135);
    }];
}

- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    // focusPoint 函数后面Point取值范围是取景框左上角（0，0）到取景框右下角（1，1）之间,按这个来但位置就是不对，只能按上面的写法才可以。前面是点击位置的y/PreviewLayer的高度，后面是1-点击位置的x/PreviewLayer的宽度
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );
    
    if ([self.device lockForConfiguration:nil]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            //曝光量调节
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        _focusView.center = point;
        _focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            _focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                _focusView.hidden = YES;
            }];
        }];
    }
    
}

- (void)FlashOn:(UIButton *)btn{
    btn.selected = !btn.selected;
    if ([_device hasTorch]) {
        
        
        [_device lockForConfiguration:nil];
        if (!_isflashOn) {
            [_device setTorchMode: AVCaptureTorchModeOn];
            _isflashOn = YES;
        }else{
            [_device setTorchMode: AVCaptureTorchModeOff];
            _isflashOn = NO;
        }
        [_device unlockForConfiguration];
    }
    
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}


#pragma mark- 拍照
- (void)shutterCamera
{
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection ==  nil) {
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
       
        if (imageDataSampleBuffer == nil) {
            return;
        }
        
        NSData *imageData =  [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        [self saveImageWithImage:imageData];
        
        
    }];
    
}
/**
 * 上传
 */
- (void)saveImageWithImage:(NSData *)imageData {
    
    BYWeakSelf;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (_index == 1) {
        dict[@"typeId"] = @(19);
    }else{
        dict[@"typeId"] = @(2007);
    }
    
    
        [BYSendWorkHttpTool POSCarNumberOrVinParams:dict withImage:imageData success:^(id data) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                BYLog(@"%@",data);
                NSString *code = data[@"code"];
                if ([code integerValue] != 10000000) {
                    BYShowError(data[@"msg"]);
                    [weakSelf disMiss];
                    return ;
                }
                NSString *status = data[@"message"][@"status"];
                if ([status integerValue]) {
                    BYShowError(data[@"message"][@"value"]);
                    [weakSelf disMiss];
                    return ;
                }
                NSArray *arr = data[@"data"][@"cardsinfo"];
                if (arr.count) {
                    NSDictionary *dict = arr.firstObject;
                    NSArray *arr1 = dict[@"items"];
                    if (weakSelf.index == 1) {
                        if (weakSelf.carNumberBlock) {
                            weakSelf.carNumberBlock(arr1.firstObject[@"content"]);
                        }
                    }else{
                        if (weakSelf.vinBlock) {
                            weakSelf.vinBlock(arr1.firstObject[@"content"]);
                        }
                    }
                    
                    
                }else{
                    BYShowError(@"识别失败");
                }
                [weakSelf disMiss];
            });
           
        } failure:^(NSError *error) {
//            BYShowError(@"请求失败");
             [weakSelf disMiss];
        }];
   

    
   
}




- (void)disMiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark- 检测相机权限
- (BOOL)checkCameraPermission
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        alertView.tag = 100;
        [alertView show];
        return NO;
    }
    else{
        return YES;
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 100) {
        
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            [[UIApplication sharedApplication] openURL:url];
            
        }
    }
    
    if (buttonIndex == 1 && alertView.tag == 100) {
        
        [self disMiss];
    }
    
}

@end
