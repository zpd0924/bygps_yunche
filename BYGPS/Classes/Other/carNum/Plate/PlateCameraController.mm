//
//  PlateCameraController.m
//  PlateDemo
//
//  Created by DXY on 2017/7/13.
//  Copyright © 2017年 DXY. All rights reserved.
//

#import "PlateCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreMotion/CoreMotion.h>
#import "PlateSquareView.h"
#import "SPlate.h"


//顶部安全区
#define SafeAreaTopHeight ((SCREENH == 812.0 || SCREENW == 812.0) ? 34 : 10)
//底部
#define SafeAreaBottomHeight ((SCREENH == 812.0 || SCREENW == 812.0) ? 34 : 0)

#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENRECT [UIScreen mainScreen].bounds

//默认为竖屏
int _recognizeType = 1;

@interface PlateCameraController ()<UIAlertViewDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton * flashButton;

@property (nonatomic, strong) UIButton * backButton;

@property (strong ,nonatomic) UILabel * slideValuelabel;
@property (strong ,nonatomic) UISlider * resizeSlider;
@property (strong ,nonatomic) UILabel * sliderTipLabel;

@property (nonatomic, strong) UILabel * centerTipLabel;

@property (nonatomic, strong) PlateSquareView * squareView;    //方框View

@property (nonatomic, strong) CMMotionManager * motionManager;

//黑色半透明中空蒙版
@property (nonatomic, strong) CAShapeLayer * detectLayer;

//相机相关
@property (nonatomic, strong) AVCaptureSession * captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput * captureInput;
@property (nonatomic, strong) AVCaptureStillImageOutput * captureOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput * captureDataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * capturePreviewLayer;
@property (nonatomic, strong) AVCaptureDevice * captureDevice;

@property (nonatomic, assign) PlateDeviceDirection motionDirection;

/** 横/竖屏 */
@property (nonatomic, assign) BOOL isHorizontal;

@end

@implementation PlateCameraController {
    
    NSString * _authorizationCode;   //授权码 / 授权文件名
    
    SPlate *_sPlate; //识别核心
    
    BOOL _isCameraAuthor; //是否有打开摄像头权限
    BOOL _isRecognize; //是否识别
    BOOL _flash; //控制闪光灯
    NSTimer *_timer; //定时器
    BOOL _isTransform;
    BOOL _isFocusing;//是否正在对焦
    BOOL _isFocusPixels;//是否相位对焦
    GLfloat _FocusPixelsPosition;//相位对焦下镜头位置
    GLfloat _curPosition;//当前镜头位置
    
    
}

- (instancetype)initWithAuthorizationCode:(NSString *)authorizationCode {
    if (self = [super init]) {
        _authorizationCode = authorizationCode;
    }
    return self;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

//是否可以旋转
- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
//    self.navigationController.navigationBarHidden = YES;
    
    //初始化识别核心
    _sPlate = [[SPlate alloc] init];
    //设置重力方向默认为传入的系统方向
    if (self.deviceDirection == UIInterfaceOrientationPortraitUpsideDown) {
        self.motionDirection = kPlateDeviceDirectionUpsideDown;
        self.isHorizontal = NO;
    } else if (self.deviceDirection == UIInterfaceOrientationLandscapeLeft) {
        self.motionDirection = kPlateDeviceDirectionRight;
        self.isHorizontal = YES;
    } else if (self.deviceDirection == UIInterfaceOrientationLandscapeRight) {
        self.motionDirection = kPlateDeviceDirectionLeft;
        self.isHorizontal = YES;
    } else {
        self.motionDirection = kPlateDeviceDirectionUp;
        self.isHorizontal = NO;
    }
    //初始化相机和视图层
    [self initCameraAndLayer];
    
    [self prepareUI];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _isRecognize = YES;
    _isFocusPixels = NO;
    
    //判断是否相位对焦
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        AVCaptureDeviceFormat * deviceFormat = self.captureDevice.activeFormat;
        if (deviceFormat.autoFocusSystem == AVCaptureAutoFocusSystemPhaseDetection){
            _isFocusPixels = YES;
        }
    }
    
    //注册通知
    [self.captureDevice addObserver:self forKeyPath:@"adjustingFocus" options:NSKeyValueObservingOptionNew context:nil];
    if (_isFocusPixels) {
        [self.captureDevice addObserver:self forKeyPath:@"lensPosition" options:NSKeyValueObservingOptionNew context:nil];
    }
    if (!self.isOneDirection) {
        [self startMotionManager];
    }
    //初始化识别核心
    int nRet = [_sPlate initSPlate:_authorizationCode nsReserve:@""];
    
    if (nRet != 0) {
        if (_isCameraAuthor == NO) {
            [self.captureSession stopRunning];
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            NSArray * appleLanguages = [defaults objectForKey:@"AppleLanguages"];
            NSString * systemLanguage = [appleLanguages objectAtIndex:0];
            if (![systemLanguage isEqualToString:@"zh-Hans"]) {
                NSString *initStr = [NSString stringWithFormat:@"Init Error!Error code:%d",nRet];
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"Tips" message:initStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertV show];
            } else {
                NSString *initStr = [NSString stringWithFormat:@"初始化失败!错误代码:%d",nRet];
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:initStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alertV show];
            }
        }
    } else {
        //成功
        int day = [self calculateTheRemainingDaysOfLicenceWithDeadLine:_sPlate.nsEndTime];
        if (day<=15) {
            NSLog(@"⚠️授权还有不到15天到期❗️❗️❗️请及时更换");
        }
    }
    if(![self.captureSession isRunning]) {
        [self.captureSession startRunning];
    }
}

- (int)calculateTheRemainingDaysOfLicenceWithDeadLine:(NSString *)deadLine {
    //按照日期格式创建日期格式句柄
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    //将日期字符串转换成Date类型
    
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [dateFormatter dateFromString:deadLine];
    //将日期转换成时间戳
    NSTimeInterval start = [startDate timeIntervalSince1970]*1;
    NSTimeInterval end = [endDate timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    //计算具体的天，时，分，秒
    //    int second = (int)value % 60;//秒
    //    int minute = (int)value / 60 % 60;
    //    int hour = (int)value / 3600;
    int day = (int)value / (24 * 3600);
    NSLog(@"还有%d天",day+1);
    //返回string类型的总时长
    return day+1;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //停止重力加速检测
    [self.motionManager stopDeviceMotionUpdates];
    
    _isRecognize = NO;
    [self.captureDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    if (_isFocusPixels) {
        [self.captureDevice removeObserver:self forKeyPath:@"lensPosition"];
    }
    [self.captureSession stopRunning];
    //释放核心
    [_sPlate freeSPlate];
}

#pragma mark - 初始化

//隐藏状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}


//初始化相机和检测视图层
- (void)initCameraAndLayer {
    //判断摄像头是否授权
    _isCameraAuthor = NO;
    AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authorStatus == AVAuthorizationStatusRestricted || authorStatus == AVAuthorizationStatusDenied){
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray * allLanguages = [userDefaults objectForKey:@"AppleLanguages"];
        NSString * preferredLang = [allLanguages objectAtIndex:0];
        if (![preferredLang isEqualToString:@"zh-Hans"]) {
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"Please allow to access your device’s camera in “Settings”-“Privacy”-“Camera”" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alt show];
        }else{
            UIAlertView * alt = [[UIAlertView alloc] initWithTitle:@"未获得授权使用摄像头" message:@"请在 '设置-隐私-相机' 中打开" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alt show];
        }
        _isCameraAuthor = YES;
        return;
    }
    
    //输入设备
    if ([self.captureSession canAddInput:self.captureInput]) {
        [self.captureSession addInput:self.captureInput];
    }
    //输出设备
    if ([self.captureSession canAddOutput:self.captureDataOutput]) {
        [self.captureSession addOutput:self.captureDataOutput];
    }
    //输出设备
    if ([self.captureSession canAddOutput:self.captureOutput]) {
        [self.captureSession addOutput:self.captureOutput];
    }
    //添加预览层
    [self.view.layer addSublayer:self.capturePreviewLayer];
    
    
    
    //判断是否相位对焦
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        AVCaptureDeviceFormat *deviceFormat = _captureDevice.activeFormat;
        if (deviceFormat.autoFocusSystem == AVCaptureAutoFocusSystemPhaseDetection){
            _isFocusPixels = YES;
        }
    }
    
    [self calculateRecognizeArea];
    
    _effectiveScale = 1.0;
}

- (void)calculateRecognizeArea {
    //设置检测范围(是横屏的值)
    CGFloat x,y,h,w;
    int left,top,right,bottom;
    
    x = self.squareView.squareFrame.origin.y;
    y = self.squareView.squareFrame.origin.x;
    h = self.squareView.squareFrame.size.width;
    w = self.squareView.squareFrame.size.height;
    
    //计算参数
    left = x / SCREENH * 1920;
    top = y / SCREENW * 1080;
    right = (x + w) / SCREENH * 1920;
    bottom = (y + h) / SCREENW * 1080;
    
    
    NSLog(@"left:%d,top:%d,right:%d,bottom:%d",left,top,right,bottom);
    //    [_sPlate setRegionWithLeft:622 Top:0 Right:1298 Bottom:1080];
    [_sPlate setRegionWithLeft:left Top:top Right:right Bottom:bottom];
}


- (void)prepareUI {
    
    
    [self.view.layer addSublayer:self.detectLayer];
    self.view.layer.masksToBounds = YES;
    
    [self.view addSubview:self.squareView];
    
    
    [self.view addSubview:self.flashButton];
    
    [self.view addSubview:self.backButton];
    
    
    [self.view addSubview:self.centerTipLabel];
    
    
    [self.view addSubview:self.resizeSlider];
    
    [self.view addSubview:self.slideValuelabel];
    
    [self.view addSubview:self.sliderTipLabel];
    
    
    BOOL especiallyFrameSetup = NO;
    if (!self.isOneDirection) { //不是固定一个方向
        if (self.deviceDirection == UIInterfaceOrientationLandscapeLeft || self.deviceDirection == UIInterfaceOrientationLandscapeRight) { //横屏弹出的时候
            if (self.motionDirection == kPlateDeviceDirectionUp || self.motionDirection == kPlateDeviceDirectionUpsideDown) {//重力加速度测出手机方向为正向和上下颠倒方向时
                especiallyFrameSetup = YES;
            }
        }
    }
    if (especiallyFrameSetup) {
        [self especiallyFrameSetup];
    } else {
        [self frameSetup];
    }
    
    
}

- (void)especiallyFrameSetup {
    CGFloat ratio = 1;
    
    if (SCREENW < 400) {
        ratio = SCREENW / 414.;
    }
    
    CGFloat btnWidth;
    btnWidth = 60 * ratio;
    
    CGFloat x,y;
    if (self.deviceDirection == UIInterfaceOrientationLandscapeRight) {
        //home button right
        x = 10 + SafeAreaTopHeight;
        y = 10;
    } else {
        //home button Left
        x = SCREENW - btnWidth - 10 - SafeAreaBottomHeight;
        y = SCREENH - btnWidth - 10;
    }
    self.flashButton.frame = CGRectMake(x, y, btnWidth, btnWidth);
    
    if (self.deviceDirection == UIInterfaceOrientationLandscapeRight) {
        //home button right
//        x = 10 + SafeAreaTopHeight;
        y = SCREENH - btnWidth - 10;
    } else {
        //home button Left
//        x = SCREENW - btnWidth - 10 - SafeAreaBottomHeight;
        y = 10;
    }
    self.backButton.frame = CGRectMake(x, y, btnWidth, btnWidth);
    
    CGPoint center = CGPointMake(SCREENW * 0.5, SCREENH * 0.5);
    self.centerTipLabel.frame = CGRectMake(0, 0, 210, 40);
    self.centerTipLabel.center = center;
    self.centerTipLabel.layer.cornerRadius = self.centerTipLabel.frame.size.height * 0.5;
    self.centerTipLabel.layer.masksToBounds = YES;
    
    //滑条
    self.resizeSlider.frame = CGRectMake(0, 0, SCREENH - 40, 20);
    CGPoint sliderCenter = center;
    if (self.deviceDirection == UIInterfaceOrientationLandscapeRight) {
        //home button right
        sliderCenter.x = SCREENW - 60 - SafeAreaBottomHeight;
    } else {
        //home button left
        sliderCenter.x = 60 + SafeAreaBottomHeight;
    }
    [self.resizeSlider setCenter:sliderCenter];
    
    //滑条值
    self.slideValuelabel.frame = CGRectMake(0, 0, 320, 20);
    CGPoint valueCenter = center;
    if (self.deviceDirection == UIInterfaceOrientationLandscapeRight) {
        //home button right
        valueCenter.x = SCREENW - 80 - SafeAreaBottomHeight;
    } else {
        //home button left
        valueCenter.x = 80 + SafeAreaBottomHeight;
    }
    
    [self.slideValuelabel setCenter:valueCenter];
    
    //@"拖动滑条可调整拍摄距离"
    self.sliderTipLabel.frame = CGRectMake(0, 0, 320, 60);
    CGPoint sliderTipCenter = center;
    if (self.deviceDirection == UIInterfaceOrientationLandscapeRight) {
        //home button right
        sliderTipCenter.x = SCREENW - 30 - SafeAreaBottomHeight;
    } else {
        //home button left
        sliderTipCenter.x = 30 + SafeAreaBottomHeight;
    }
    
    [self.sliderTipLabel setCenter:sliderTipCenter];
    
    CGFloat angle = 0;
    if (self.deviceDirection == UIInterfaceOrientationLandscapeRight) {
        //home button right
        if (self.motionDirection == kPlateDeviceDirectionUp) {
            angle = -M_PI_2;
        } else {
            angle = M_PI_2;
        }
    } else {
        //home button right
        if (self.motionDirection == kPlateDeviceDirectionUp) {
            angle = M_PI_2;
        } else {
            angle = -M_PI_2;
        }
    }
    self.centerTipLabel.transform = CGAffineTransformMakeRotation(angle);
    self.sliderTipLabel.transform = CGAffineTransformMakeRotation(angle);
    self.resizeSlider.transform = CGAffineTransformMakeRotation(angle);
    self.slideValuelabel.transform = CGAffineTransformMakeRotation(angle);
    self.flashButton.transform = CGAffineTransformMakeRotation(angle);
    self.backButton.transform = CGAffineTransformMakeRotation(angle);
    
}

- (void)frameSetup {
    CGFloat ratio = 1;
    
    if (SCREENW < 400) {
        ratio = SCREENW / 414.;
    }
    
    CGFloat width;
    width = 60 * ratio;
    self.backButton.frame = CGRectMake(10, SafeAreaTopHeight, width, width);
    
    self.flashButton.frame = CGRectMake(SCREENW - width - 10, SafeAreaTopHeight, width, width);
    
    
    CGPoint center = CGPointMake(SCREENW * 0.5, SCREENH * 0.5);
    
    self.resizeSlider.frame = CGRectMake(0, 0, SCREENW - 40, 20);
    CGPoint sliderCenter = center;
    sliderCenter.y = SCREENH - 60 - SafeAreaBottomHeight;
    [self.resizeSlider setCenter:sliderCenter];
    NSLog(@"slider:%@",NSStringFromCGRect(self.resizeSlider.frame));
    
    self.slideValuelabel.frame = CGRectMake(0, 0, 320, 20);
    CGPoint valueCenter = center;
    valueCenter.y = SCREENH - 80 - SafeAreaBottomHeight;
    [self.slideValuelabel setCenter:valueCenter];
    
    
    self.sliderTipLabel.frame = CGRectMake(0, 0, 320, 60);
    CGPoint sliderTipCenter = center;
    sliderTipCenter.y = SCREENH - 30 - SafeAreaBottomHeight;
    [self.sliderTipLabel setCenter:sliderTipCenter];
    
    
    self.centerTipLabel.frame = CGRectMake(0, 0, 210, 40);
    self.centerTipLabel.center = center;
    self.centerTipLabel.layer.cornerRadius = self.centerTipLabel.frame.size.height * 0.5;
    self.centerTipLabel.layer.masksToBounds = YES;
    
    
    
    
    CGFloat angle = 0;
    CGFloat sliderAngle = 0;
    if (self.deviceDirection == UIInterfaceOrientationPortrait) {
        if (self.motionDirection == kPlateDeviceDirectionLeft) {
            angle = M_PI_2;
        } else if (self.motionDirection == kPlateDeviceDirectionRight) {
            angle = -M_PI_2;
        } else if (self.motionDirection == kPlateDeviceDirectionUp) {
            sliderAngle = 0;
            angle = 0;
        } else if (self.motionDirection == kPlateDeviceDirectionUpsideDown) {
            angle = M_PI;
            sliderAngle = M_PI;
        }
    } else if (self.deviceDirection == UIInterfaceOrientationLandscapeRight) {
        if (self.motionDirection == kPlateDeviceDirectionLeft) {
            angle = 0;
            sliderAngle = 0;
        } else if (self.motionDirection == kPlateDeviceDirectionRight) {
            angle = M_PI;
            sliderAngle = M_PI;
        } else if (self.motionDirection == kPlateDeviceDirectionUp) {
            angle = -M_PI_2;
        } else if (self.motionDirection == kPlateDeviceDirectionUpsideDown) {
            angle = M_PI_2;
        }
    } else if (self.deviceDirection == UIInterfaceOrientationLandscapeLeft) {
        if (self.motionDirection == kPlateDeviceDirectionLeft) {
            angle = M_PI;
            sliderAngle = M_PI;
        } else if (self.motionDirection == kPlateDeviceDirectionRight) {
            angle = 0;
            sliderAngle = 0;
        } else if (self.motionDirection == kPlateDeviceDirectionUp) {
            angle = M_PI_2;
        } else if (self.motionDirection == kPlateDeviceDirectionUpsideDown) {
            angle = -M_PI_2;
        }
    } else if (self.deviceDirection == UIInterfaceOrientationPortraitUpsideDown) {
        if (self.motionDirection == kPlateDeviceDirectionLeft) {
            angle = -M_PI_2;
        } else if (self.motionDirection == kPlateDeviceDirectionRight) {
            angle = M_PI_2;
        } else if (self.motionDirection == kPlateDeviceDirectionUp) {
            angle = M_PI;
        } else if (self.motionDirection == kPlateDeviceDirectionUpsideDown) {
            angle = 0;
            sliderAngle = 0;
        }
    }
    self.centerTipLabel.transform = CGAffineTransformMakeRotation(angle);
    self.backButton.transform = CGAffineTransformMakeRotation(angle);
    self.flashButton.transform = CGAffineTransformMakeRotation(angle);
    
    self.sliderTipLabel.transform = CGAffineTransformMakeRotation(sliderAngle);
    self.slideValuelabel.transform = CGAffineTransformMakeRotation(sliderAngle);
    self.resizeSlider.transform = CGAffineTransformMakeRotation(sliderAngle);
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"adjustingFocus"]){
        _isFocusing =[[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
    }
    if([keyPath isEqualToString:@"lensPosition"]){
        _FocusPixelsPosition =[[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    }
}

//从缓冲区获取图像数据进行识别
#pragma mark - AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    UIImage * srcImage = [self imageFromSampleBuffer:sampleBuffer];
    
    if(srcImage.size.width != 1920){
        [self.captureSession beginConfiguration];
        [self.captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
        [self.captureSession commitConfiguration];
    }else{
        if (_isRecognize == YES) {
            if(self.effectiveScale != 1.0){
                srcImage = [self cutImage:srcImage];
            }
            //开始识别
            int bSuccess = [_sPlate recognizeSPlateImage:srcImage Type:_recognizeType];
            if(bSuccess == 0) {
                //震动
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                //显示区域图像
                [self performSelectorOnMainThread:@selector(showResultAndImage:) withObject:_sPlate.plateImg waitUntilDone:NO];
                _isRecognize = NO;
            }
        }
    }
    
}



//显示结果跟图像
- (void)showResultAndImage:(UIImage *)image {
    if ([self.delegate respondsToSelector:@selector(cameraController:recognizePlateSuccessWithResult:plateColor:andPlateImage:)]) {
        [self.delegate cameraController:self recognizePlateSuccessWithResult:_sPlate.nsPlateNo plateColor:_sPlate.nsPlateColor andPlateImage:image];
    } else {
        NSLog(@"recognizePlateSuccessWithResult:plateColor:andPlateImage:");
    }
}

#pragma mark - 点击事件

//闪光灯按钮点击事件
- (void)flashClick {
    
    if (![self.captureDevice hasTorch]) {
        //NSLog(@"no torch");
    }else{
        [self.captureDevice lockForConfiguration:nil];
        if(!_flash){
            [self.captureDevice setTorchMode: AVCaptureTorchModeOn];
            [self.flashButton setImage:[UIImage imageNamed:@"ImageResource.bundle/flash_off"] forState:UIControlStateNormal];
            _flash = YES;
        }else{
            [self.captureDevice setTorchMode: AVCaptureTorchModeOff];
            [self.flashButton setImage:[UIImage imageNamed:@"ImageResource.bundle/flash_on"] forState:UIControlStateNormal];
            _flash = NO;
        }
        [self.captureDevice unlockForConfiguration];
    }
}


//返回按钮点击事件
- (void)backClick {
    
    if ([self.delegate respondsToSelector:@selector(backButtonClickWithPlateCameraController:)]) {
        [self.delegate backButtonClickWithPlateCameraController:self];
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    _effectiveScale = slider.value;
    self.slideValuelabel.text = [NSString stringWithFormat:@"%.1f x", slider.value];
    [CATransaction begin];
    [CATransaction setAnimationDuration:.025];
    
    CGFloat angle = 0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wenum-compare"
    //Home键在左，则为M_PI_2；Home键在右，则为-M_PI_2
    if (self.deviceDirection == UIDeviceOrientationLandscapeRight) {
        angle = M_PI_2;
    } else if (self.deviceDirection == UIDeviceOrientationLandscapeLeft) {
        angle = -M_PI_2;
    } else if(self.deviceDirection == UIDeviceOrientationPortraitUpsideDown) {
        angle = M_PI;
    }
    
#pragma clang diagnostic pop
    self.capturePreviewLayer.affineTransform = CGAffineTransformIdentity;
    self.capturePreviewLayer.affineTransform = CGAffineTransformMakeRotation(angle);
    self.capturePreviewLayer.affineTransform = CGAffineTransformScale(self.capturePreviewLayer.affineTransform, self.effectiveScale, self.effectiveScale);
    [CATransaction commit];
}


#pragma mark - Motion

- (void)startMotionManager {
    self.motionManager.deviceMotionUpdateInterval = 1 / 15.0;
    if (self.motionManager.deviceMotionAvailable) {
        //        NSLog(@"Device Motion Available");
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler: ^(CMDeviceMotion *motion, NSError *error){
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
            
        }];
    } else {
        //        NSLog(@"No device motion on device.");
        [self setMotionManager:nil];
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion {
    
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    double z = deviceMotion.gravity.z;
    //设置横竖屏识别的变化
    
    //    NSLog(@"x:%.3lf，y:%.3lf，z:%lf",x,y,z);
    if (y < x && y<=-0.7 && z>-0.7) {
        //正竖屏
        if (self.motionDirection != kPlateDeviceDirectionUp) {
            NSLog(@"正");
            self.motionDirection = kPlateDeviceDirectionUp;
        }
        
    }else if(y >= x && y>0.6 && z>-0.7){
        //上下颠倒
        if (self.motionDirection != kPlateDeviceDirectionUpsideDown) {
            NSLog(@"倒");
            self.motionDirection = kPlateDeviceDirectionUpsideDown;
        }
    } else if(y < x && x>0.7 && z>-0.7){
        //右横屏
        if (self.motionDirection != kPlateDeviceDirectionRight) {
            NSLog(@"右");
            self.motionDirection = kPlateDeviceDirectionRight;
        }
    }else if (y >= x && x<=-0.6 && z > -0.7){
        //左横屏
        if (self.motionDirection != kPlateDeviceDirectionLeft) {
            NSLog(@"左");
            self.motionDirection = kPlateDeviceDirectionLeft;
        }
    }
}


#pragma mark - 图像处理

- (UIImage *)imageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    // Get a CMSampleBuffer‘s Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationUp];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    //    image = [PlateCameraViewController image:image rotation:UIImageOrientationRight];
    return (image);
}

#pragma mark 旋转图像
+ (UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation {
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width / rect.size.height;
            scaleX = rect.size.height / rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width / rect.size.height;
            scaleX = rect.size.height / rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage * newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}

- (UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size {
    
    // 得到图片上下文，指定绘制范围
    UIGraphicsBeginImageContext(size);
    
    CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(),kCGInterpolationHigh);
    // 将图片按照指定大小绘制
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前图片上下文中导出图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    CGImageRelease(newImageRef);
    //返回剪裁后的图片
    return newImage;
}

- (UIImage *)cutImage:(UIImage *)image {
    int nW = image.size.width;
    int nH = image.size.height;
    CGRect cutRect = CGRectMake(nW / (self.effectiveScale * 2), nH / (self.effectiveScale * 2), nW / self.effectiveScale, nH / self.effectiveScale);
    image = [self imageFromImage:image inRect:cutRect];
    image = [self image:image scaleToSize:CGSizeMake(nW, nH)];
    return image;
}

#pragma mark - Setter

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wenum-compare"
- (void)setDeviceDirection:(UIInterfaceOrientation)deviceDirection {
    _deviceDirection = deviceDirection;
    if (deviceDirection == UIDeviceOrientationPortrait) {
        self.isHorizontal = NO;
        _recognizeType = 1;
    } else if (deviceDirection == UIDeviceOrientationLandscapeLeft) {
        self.isHorizontal = YES;
        _recognizeType = 0;
    } else if (deviceDirection == UIDeviceOrientationLandscapeRight) {
        self.isHorizontal = YES;
        _recognizeType = 2;
    } else if (deviceDirection == UIDeviceOrientationPortraitUpsideDown) {
        self.isHorizontal = NO;
        _recognizeType = 3;
    }
}
#pragma clang diagnostic pop

- (void)setMotionDirection:(PlateDeviceDirection)motionDirection {
    _motionDirection = motionDirection;
    if (motionDirection == kPlateDeviceDirectionUp) {
        self.isHorizontal = NO;
        _recognizeType = 1;
    } else if (motionDirection == kPlateDeviceDirectionLeft) {
        self.isHorizontal = YES;
        _recognizeType = 0;
    } else if (motionDirection == kPlateDeviceDirectionRight) {
        self.isHorizontal = YES;
        _recognizeType = 2;
    } else if (motionDirection == kPlateDeviceDirectionUpsideDown) {
        self.isHorizontal = NO;
        _recognizeType = 3;
    }
}

- (void)setIsHorizontal:(BOOL)isHorizontal {
    _isHorizontal = isHorizontal;
    [self clearSubViewsUp];
    
    [self prepareUI];
    
    [self calculateRecognizeArea];
}

- (void)clearSubViewsUp {
    
    [self.detectLayer removeFromSuperlayer];
    self.detectLayer = nil;
    
    [self.squareView removeFromSuperview];
    self.squareView = nil;
    [self.flashButton removeFromSuperview];
    self.flashButton = nil;
    [self.backButton removeFromSuperview];
    self.backButton = nil;
    [self.slideValuelabel removeFromSuperview];
    self.slideValuelabel = nil;
    [self.sliderTipLabel removeFromSuperview];
    self.sliderTipLabel = nil;
    [self.centerTipLabel removeFromSuperview];
    self.centerTipLabel = nil;
    
    [self.resizeSlider removeFromSuperview];
    self.resizeSlider = nil;
    
}

- (CAShapeLayer *)getLayerWithHole {
    //设置检测视图层
    CAShapeLayer *layerWithHole = [CAShapeLayer layer];
    
    CGFloat offset = 1.0f;
    if ([UIScreen mainScreen].scale >= 2) {
        offset = 0.5;
    }
    
    CGRect centerFrame = self.squareView.squareFrame;
    CGRect centerRect = CGRectInset(centerFrame, -offset, -offset) ;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(SCREENRECT), CGRectGetMinY(SCREENRECT))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(SCREENRECT), CGRectGetMaxY(SCREENRECT))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(SCREENRECT), CGRectGetMaxY(SCREENRECT))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(SCREENRECT), CGRectGetMinY(SCREENRECT))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(SCREENRECT), CGRectGetMinY(SCREENRECT))];
    [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(centerRect), CGRectGetMinY(centerRect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(centerRect), CGRectGetMaxY(centerRect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(centerRect), CGRectGetMaxY(centerRect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(centerRect), CGRectGetMinY(centerRect))];
    [bezierPath addLineToPoint:CGPointMake(CGRectGetMinX(centerRect), CGRectGetMinY(centerRect))];
    [layerWithHole setPath:[bezierPath CGPath]];
    [layerWithHole setFillRule:kCAFillRuleEvenOdd];
    [layerWithHole setFillColor:[UIColor colorWithWhite:0 alpha:0.35].CGColor];
    return layerWithHole;
}

#pragma mark - 懒加载


#pragma mark Motion
- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 1/15.0;
    }
    return _motionManager;
}


#pragma mark 相机相关

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        //创建会话层
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
    }
    return _captureSession;
}

- (AVCaptureDeviceInput *)captureInput {
    if (!_captureInput) {
        _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice error:nil];
    }
    return _captureInput;
    
}

- (AVCaptureStillImageOutput *)captureOutput {
    if (!_captureOutput) {
        //创建、配置输出
        _captureOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
        [_captureOutput setOutputSettings:outputSettings];
    }
    return _captureOutput;
}

- (AVCaptureVideoDataOutput *)captureDataOutput {
    if (!_captureDataOutput) {
        _captureDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        _captureDataOutput.alwaysDiscardsLateVideoFrames = YES;
        dispatch_queue_t queue;
        queue = dispatch_queue_create("cameraQueue", NULL);
        [_captureDataOutput setSampleBufferDelegate:self queue:queue];
        NSString* formatKey = (NSString*)kCVPixelBufferPixelFormatTypeKey;
        NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:formatKey];
        [_captureDataOutput setVideoSettings:videoSettings];
    }
    return _captureDataOutput;
}

- (AVCaptureVideoPreviewLayer *)capturePreviewLayer {
    if (!_capturePreviewLayer) {
        _capturePreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
        CGFloat angle = 0;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wenum-compare"
        //Home键在左，则为M_PI_2；Home键在右，则为-M_PI_2
        if (self.deviceDirection == UIDeviceOrientationLandscapeRight) {
            angle = M_PI_2;
        } else if (self.deviceDirection == UIDeviceOrientationLandscapeLeft) {
            angle = -M_PI_2;
        } else if(self.deviceDirection == UIDeviceOrientationPortraitUpsideDown) {
            angle = M_PI;
        }
        
#pragma clang diagnostic pop
        _capturePreviewLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);
        _capturePreviewLayer.frame = CGRectMake(0, 0, SCREENW, SCREENH);
        _capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _capturePreviewLayer;
}

- (AVCaptureDevice *)captureDevice {
    if (!_captureDevice) {
        NSArray *deviceArr = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in deviceArr)
        {
            if (device.position == AVCaptureDevicePositionBack){
                _captureDevice = device;
                _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            }
        }
    }
    return _captureDevice;
}


#pragma mark UI

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"ImageResource.bundle/back_btn"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)flashButton {
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashButton setImage:[UIImage imageNamed:@"ImageResource.bundle/flash_on"] forState:UIControlStateNormal];
        [_flashButton addTarget:self action:@selector(flashClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashButton;
}

- (UILabel *)slideValuelabel {
    if (!_slideValuelabel) {
        _slideValuelabel = [[UILabel alloc] init];
        _slideValuelabel.text = @"1.0 x";
        _slideValuelabel.numberOfLines = 0;
        _slideValuelabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        _slideValuelabel.textColor = [UIColor greenColor];
        _slideValuelabel.textAlignment = NSTextAlignmentCenter;
    }
    return _slideValuelabel;
}

- (UISlider *)resizeSlider {
    if (!_resizeSlider) {
        _resizeSlider = [[UISlider alloc] init];
        _resizeSlider.minimumValue = 1.0;// 设置最小值
        _resizeSlider.maximumValue = 3.0;// 设置最大值
        _resizeSlider.value = 1.0;// 设置初始值
        _resizeSlider.continuous = YES;// 设置可连续变化
        [_resizeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _resizeSlider;
}

- (UILabel *)sliderTipLabel {
    if (!_sliderTipLabel) {
        _sliderTipLabel = [[UILabel alloc] init];
        _sliderTipLabel.text = @"拖动滑条可调整拍摄距离";
        _sliderTipLabel.numberOfLines = 0;
        _sliderTipLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        _sliderTipLabel.textColor = [UIColor whiteColor];
        _sliderTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _sliderTipLabel;
}

- (UILabel *)centerTipLabel {
    if (!_centerTipLabel) {
        _centerTipLabel = [[UILabel alloc] init];
        _centerTipLabel.text = @"请将车牌置于框内";
        _centerTipLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _centerTipLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        _centerTipLabel.textColor = [UIColor whiteColor];
        _centerTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _centerTipLabel;
}

- (PlateSquareView *)squareView {
    if (!_squareView) {
        _squareView = [[PlateSquareView alloc] initWithFrame:SCREENRECT andIsHorizontal:self.isHorizontal];
        _squareView.backgroundColor = [UIColor clearColor];
    }
    return _squareView;
}

- (CAShapeLayer *)detectLayer {
    if (!_detectLayer) {
        //设置检测视图层
        _detectLayer = [self getLayerWithHole];
    }
    return _detectLayer;
}

@end
