//
//  VinCameraController.m
//  VinDemo
//
//  Created by ocrgroup on 2017/9/28.
//  Copyright © 2017年 ocrgroup. All rights reserved.
//

#import "VinCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreMotion/CoreMotion.h>
#import "VinSquareView.h"
#import "vinTyper.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "VinManager.h"
//顶部安全区
#define SafeAreaTopHeight (SCREENH == 812.0 ? 44 : 10)
//底部
#define SafeAreaBottomHeight (SCREENH == 812.0 ? 24 : 0)


#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width
#define SCREENRECT [UIScreen mainScreen].bounds


@interface VinCameraController ()<AVCaptureVideoDataOutputSampleBufferDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,VinManagerDelegate>

@property (nonatomic, strong) UIButton * photoBtn;
@property (nonatomic, strong) UIButton * flashBtn;
@property (nonatomic, strong) UIButton * backBtn;
@property (nonatomic, strong) UIButton * changeBtn;
@property (nonatomic,strong) UIButton *photoInBtn;

//"如无法自动识别，请点击拍照按钮保存图像"
@property (nonatomic, strong) UILabel * savePicTipLabel;

//"将框置于VIN码前"
@property (nonatomic, strong) UILabel * centerLabel;

//检测结果和保存成功提示label
@property (nonatomic, strong) UILabel * resultLabel;
//检测的结果图片
@property (nonatomic, strong) UIImageView * resultImageView;
//扫描线
@property (retain ,nonatomic) UIImageView * scanLine;

//方框View
@property (nonatomic, strong) VinSquareView * squareView;
//黑色半透明蒙版
@property (nonatomic, strong) CAShapeLayer * detectLayer;

@property (nonatomic, strong) CMMotionManager * motionManager;

@property (nonatomic, assign) VinPhoneDirection phoneDirection;
/** 横/竖屏 */
@property (nonatomic, assign) BOOL isHorizontal;

//相机相关
@property (nonatomic, strong) AVCaptureSession * captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput * captureInput;
@property (nonatomic, strong) AVCaptureStillImageOutput * captureOutput;
@property (nonatomic, strong) AVCaptureVideoDataOutput * captureDataOutput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer * capturePreviewLayer;
@property (nonatomic, strong) AVCaptureDevice * captureDevice;

@end

@implementation VinCameraController {
    NSString * _authorizationCode;  //公司名 / 授权码
    VinTyper * _vinTyper; //识别核心
    
    BOOL _isCameraAuthor; //是否有打开摄像头权限
    BOOL _isRecognize; //是否识别
    BOOL _flash; //控制闪光灯
    BOOL _isScan; //控制扫描线
    CGPoint _linePoint;//扫描线初始位置
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

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;
    
    //创建识别核心对象
    _vinTyper = [[VinTyper alloc] init];
    
    
    //初始化相机
    [self initCamera];
    //UI
    [self prepareUI];
    //设置默认为传入的系统方向
    self.phoneDirection = self.deviceDirection;
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self moveScanline];
    _isRecognize = YES;
    AVCaptureDevice * camDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //注册通知
    [camDevice addObserver:self forKeyPath:@"adjustingFocus" options:NSKeyValueObservingOptionNew context:nil];
    if (_isFocusPixels) {
        [camDevice addObserver:self forKeyPath:@"lensPosition" options:NSKeyValueObservingOptionNew context:nil];
    }
    if (!self.isOneDirection) {
        [self startMotionManager];
    }
    //监听切换到前台事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveScanline) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [self initRecognizeCore];
    
}



- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.captureDevice removeObserver:self forKeyPath:@"adjustingFocus"];
    if (_isFocusPixels) {
        [self.captureDevice removeObserver:self forKeyPath:@"lensPosition"];
    }
    //停止重力加速检测
    [self.motionManager stopDeviceMotionUpdates];
    //移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //释放核心
    [_vinTyper freeVinTyper];
    _isRecognize = NO;
    [self.captureSession stopRunning];
    
}

#pragma mark - 初始化
//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

//是否可以旋转
- (BOOL)shouldAutorotate {
    return NO;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}


- (void)initRecognizeCore {
    //初始化识别核心
    int nRet = [_vinTyper initVinTyper:_authorizationCode nsReserve:@""];
    if (nRet != 0) {
        [self.captureSession stopRunning];
        NSString *initStr = [NSString stringWithFormat:@"Init Error!Error code:%d",nRet];
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"Tips" message:initStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertV show];
    } else {
        //成功
        int day = [self calculateTheRemainingDaysOfLicenceWithDeadLine:_vinTyper.nsEndTime];
        
        if (day<=7) {
            NSLog(@"⚠️授权还有不到7天到期❗️❗️❗️请及时更换");
        }
        
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
    int day = (int)value / (24 * 3600);
    NSLog(@"还有%d天",day+1);
    return day+1;
}

//初始化相机
- (void)initCamera {
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
    //开启相机
    [self.captureSession startRunning];
    
    
    //判断是否相位对焦
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        AVCaptureDeviceFormat *deviceFormat = self.captureDevice.activeFormat;
        if (deviceFormat.autoFocusSystem == AVCaptureAutoFocusSystemPhaseDetection){
            _isFocusPixels = YES;
        }
    }
//    if (self.direction == kAudioDirectionHorizontal) {
//        [_vinTyper setVinRecognizeType:0];
//    }else{
//        [_vinTyper setVinRecognizeType:1];
//    }
//    //计算设置vin码的检测区域
//
//    [self setVinDetectArea];
}

- (void)setVinDetectArea {
    CGFloat x,y,h,w;
    int left,top,right,bottom;
    if (_isHorizontal) {
        if (SCREENH > SCREENW) {//竖屏锁定下(不考虑正倒)
            //横着拿
            x = self.squareView.squareFrame.origin.y;
            y = self.squareView.squareFrame.origin.x;
            h = self.squareView.squareFrame.size.width;
            w = self.squareView.squareFrame.size.height;
            
            //计算参数
            left = x / SCREENH * 1280;
            top = y / SCREENW * 720;
            right = (x + w) / SCREENH * 1280;
            bottom = (y + h) / SCREENW * 720;
        } else { //横屏锁定下(不考虑左右)
            //横着拿
            x = self.squareView.squareFrame.origin.x;
            y = self.squareView.squareFrame.origin.y;
            h = self.squareView.squareFrame.size.height;
            w = self.squareView.squareFrame.size.width;
            //计算参数
            left = x / SCREENW * 1280;
            top = y / SCREENH * 720;
            right = (x + w) / SCREENW * 1280;
            bottom = (y + h) / SCREENH * 720;
        }
    }else{
        if (SCREENH > SCREENW) {//竖屏锁定下(不考虑正倒)
            //竖着拿
            x = self.squareView.squareFrame.origin.x;
            y = self.squareView.squareFrame.origin.y;
            h = self.squareView.squareFrame.size.height;
            w = self.squareView.squareFrame.size.width;
            //计算参数
            left = x / SCREENW * 720;
            top = y / SCREENH * 1280;
            right = (x + w) / SCREENW * 720;
            bottom = (y + h) / SCREENH * 1280;
        } else { //横屏锁定下(不考虑左右)
            //竖着拿
            x = self.squareView.squareFrame.origin.y;
            y = self.squareView.squareFrame.origin.x;
            h = self.squareView.squareFrame.size.width;
            w = self.squareView.squareFrame.size.height;
            
            //计算参数
            left = x / SCREENH * 720;
            top = y / SCREENW * 1280;
            right = (x + w) / SCREENH * 720;
            bottom = (y + h) / SCREENW * 1280;
        }
        
    }
    
    NSLog(@"left%d top%d right%d bottom%d",left,top,right,bottom);
    [_vinTyper setVinRegionWithLeft:left Top:top Right:right Bottom:bottom];
}

- (void)prepareUI {
    
    //设置检测视图层
    [self.view.layer addSublayer:self.detectLayer];
    self.view.layer.masksToBounds = YES;
    
    [self.view addSubview:self.squareView];
    
    
    [self.view addSubview:self.flashBtn];
    
    [self.view addSubview:self.backBtn];
    
//    [self.view addSubview:self.changeBtn];
    
    [self.view addSubview:self.photoBtn];
    [self.view addSubview:self.photoInBtn];
    
    [self.view addSubview:self.centerLabel];
    
    
    [self.view addSubview:self.resultLabel];
    
    [self.view addSubview:self.savePicTipLabel];
    
    [self.view addSubview:self.scanLine];
    
    [self.view addSubview:self.resultImageView];
    
    if (_isHorizontal) {
        [self frameSetupHorizontal];
    }else{
        [self frameSetupVertical];
    }
    
}

//横屏布局
- (void)frameSetupHorizontal {
    
    CGFloat ratio = 1;
    
    if (SCREENW < 400) {
        ratio = SCREENW / 414.;
    }
    
    CGFloat width;
    width = 60 * ratio;
    
    
    self.flashBtn.frame = CGRectMake(SCREENW - width - 10, SafeAreaTopHeight, width, width);
    
//    self.changeBtn.frame = CGRectMake(SCREENW * 0.5 - width * 0.5, SafeAreaTopHeight, width, width);
    
    self.backBtn.frame = CGRectMake(10, SafeAreaTopHeight, width, width);
    
    self.photoBtn.frame = CGRectMake(SCREENW * 0.5 - width - 20, SCREENH - width - 10 - SafeAreaBottomHeight, width, width);
    self.photoInBtn.frame = CGRectMake(SCREENW * 0.5 + 20, SCREENH - width - 10 - SafeAreaBottomHeight, width, width);
    
    CGPoint center;
    center.x = SCREENW * 0.5;
    center.y = SCREENH * 0.5;
    
    //"将框置于VIN码前"
    self.centerLabel.frame = CGRectMake(0, 0, 147, 25);
    self.centerLabel.center = center;
    self.centerLabel.layer.cornerRadius = self.centerLabel.frame.size.height / 2;
    self.centerLabel.layer.masksToBounds = YES;
    
    
    //检测结果和保存成功提示label
    self.resultLabel.frame = CGRectMake(0, 0, 355 * ratio, 60 * ratio);
    CGPoint resultLabelCenter = center;
    if (SCREENH > SCREENW) {//竖屏锁定
        resultLabelCenter.x = center.x + self.squareView.squareFrame.size.width / 2 + self.resultLabel.frame.size.height / 2;
    } else {
        resultLabelCenter.y = center.y - self.squareView.squareFrame.size.height / 2 - self.resultLabel.frame.size.height / 2;
    }
    self.resultLabel.center = resultLabelCenter;
    
    //点击拍照之后预览图片
    if (SCREENH > SCREENW) {//竖屏锁定
        self.resultImageView.frame = CGRectMake(0, 0, self.squareView.squareFrame.size.height, self.squareView.squareFrame.size.width);
    } else { //横屏锁定
        self.resultImageView.frame = CGRectMake(0, 0, self.squareView.squareFrame.size.width, self.squareView.squareFrame.size.height);
    }
    self.resultImageView.center = center;
    
    //"如无法自动识别，请点击拍照按钮保存图像"提示label
    self.savePicTipLabel.frame = CGRectMake(0, 0, 300, 25);
    self.savePicTipLabel.layer.cornerRadius = self.savePicTipLabel.frame.size.height / 2;
    self.savePicTipLabel.layer.masksToBounds = YES;
    CGPoint savePicLabelCenter = center;
    if (SCREENW > SCREENH) {
        //横屏锁定(无论左右)
        savePicLabelCenter.y = center.y + self.squareView.squareFrame.size.height / 2 + 10 + self.savePicTipLabel.frame.size.height / 2;
    } else {
        savePicLabelCenter.x = center.x - self.squareView.squareFrame.size.width / 2 - 10 - self.savePicTipLabel.frame.size.height / 2;
    }
    self.savePicTipLabel.center = savePicLabelCenter;
    
    
    //控件旋转
    CGFloat angle = 0;
    if (self.deviceDirection == kVinPhoneDirectionUp) {
        if (self.phoneDirection == kVinPhoneDirectionLeft) {
            angle = M_PI_2;
        } else if (self.phoneDirection == kVinPhoneDirectionRight) {
            angle = -M_PI_2;
        }
    } else if (self.deviceDirection == kVinPhoneDirectionLeft) {
        if (self.phoneDirection == kVinPhoneDirectionLeft) {
            angle = 0;
        } else if (self.phoneDirection == kVinPhoneDirectionRight) {
            angle = M_PI;
        }
    } else if (self.deviceDirection == kVinPhoneDirectionRight) {
        if (self.phoneDirection == kVinPhoneDirectionLeft) {
            angle = M_PI;
        } else if (self.phoneDirection == kVinPhoneDirectionRight) {
            angle = 0;
        }
    } else if (self.deviceDirection == kVinPhoneDirectionUpsideDown) {
        if (self.phoneDirection == kVinPhoneDirectionLeft) {
            angle = -M_PI_2;
        } else if (self.phoneDirection == kVinPhoneDirectionRight) {
            angle = M_PI_2;
        }
    }
    self.scanLine.transform = CGAffineTransformMakeRotation(angle);
    self.resultImageView.transform = CGAffineTransformMakeRotation(angle);
    self.centerLabel.transform = CGAffineTransformMakeRotation(angle);
    self.resultLabel.transform = CGAffineTransformMakeRotation(angle);
    self.savePicTipLabel.transform = CGAffineTransformMakeRotation(angle);
    self.backBtn.transform = CGAffineTransformMakeRotation(angle);
    self.changeBtn.transform = CGAffineTransformMakeRotation(angle);
    self.flashBtn.transform = CGAffineTransformMakeRotation(angle);
    self.photoBtn.transform = CGAffineTransformMakeRotation(angle);
    self.photoInBtn.transform = CGAffineTransformMakeRotation(angle);
    [self moveScanline];
    
}

//竖屏布局
- (void)frameSetupVertical {
    CGFloat ratio = 1;
    
    if (SCREENW < 400) {
        ratio = SCREENW / 414.;
    }
    
    CGFloat width;
    width = 60 * ratio;
    
    
    self.flashBtn.frame = CGRectMake(SCREENW - width - 10, SafeAreaTopHeight, width, width);
    
    self.changeBtn.frame = CGRectMake(SCREENW * 0.5 - width * 0.5, SafeAreaTopHeight, width, width);
    
    self.backBtn.frame = CGRectMake(10, SafeAreaTopHeight, width, width);
    
    self.photoBtn.frame = CGRectMake(SCREENW * 0.5 - width - 20, SCREENH - width - 10 - SafeAreaBottomHeight, width, width);
    self.photoInBtn.frame = CGRectMake(SCREENW * 0.5 + 20, SCREENH - width - 10 - SafeAreaBottomHeight, width, width);
    
    CGPoint center;
    center.x = SCREENW * 0.5;
    center.y = SCREENH * 0.5;
    
    //"将框置于VIN码前"
    self.centerLabel.frame = CGRectMake(0, 0, 147, 25);
    self.centerLabel.center = center;
    self.centerLabel.layer.cornerRadius = self.centerLabel.frame.size.height / 2;
    self.centerLabel.layer.masksToBounds = YES;
    
    //检测结果和保存成功提示label
    self.resultLabel.frame = CGRectMake(0, 0, 355 * ratio, 60 * ratio);
    CGPoint resultLabelCenter = center;
     if (SCREENH > SCREENW) { //竖屏锁定
         resultLabelCenter.y -= self.squareView.squareFrame.size.height / 2 + self.resultLabel.frame.size.height / 2;
     } else { //横屏锁定
         resultLabelCenter.x -= self.squareView.squareFrame.size.width / 2 + self.resultLabel.frame.size.height / 2;
     }
    self.resultLabel.center = resultLabelCenter;
    
    //点击保存的图片预览
    if (SCREENH > SCREENW) { //竖屏锁定
        self.resultImageView.frame = CGRectMake(0, 0, self.squareView.squareFrame.size.width, self.squareView.squareFrame.size.height);
    } else { //横屏锁定
        self.resultImageView.frame = CGRectMake(0, 0, self.squareView.squareFrame.size.height, self.squareView.squareFrame.size.width);
    }
    self.resultImageView.center = center;
    
    //"如无法自动识别，请点击拍照按钮保存图像"提示label
    self.savePicTipLabel.frame = CGRectMake(0, 0, 300, 25);
    self.savePicTipLabel.layer.cornerRadius = self.savePicTipLabel.frame.size.height / 2;
    self.savePicTipLabel.layer.masksToBounds = YES;
    CGPoint safePicLabelCenter = center;
    if (SCREENW > SCREENH) { //横屏锁定
        safePicLabelCenter.x = center.x + self.squareView.squareFrame.size.width / 2 + 10 + self.savePicTipLabel.frame.size.height / 2;
    } else { //竖屏锁定
        safePicLabelCenter.y = center.y + self.squareView.squareFrame.size.height / 2 + 10 + self.savePicTipLabel.frame.size.height / 2;
    }
    self.savePicTipLabel.center = safePicLabelCenter;
    
    
    //控件旋转
    CGFloat angle = 0;
    if (self.deviceDirection == kVinPhoneDirectionUp) {
        if (self.phoneDirection == kVinPhoneDirectionUp) {
            angle = 0;
        } else if (self.phoneDirection == kVinPhoneDirectionUpsideDown) {
            angle = M_PI;
        }
    } else if (self.deviceDirection == kVinPhoneDirectionUpsideDown) {
        if (self.phoneDirection == kVinPhoneDirectionUp) {
            angle = M_PI;
        } else if (self.phoneDirection == kVinPhoneDirectionUpsideDown) {
            angle = 0;
        }
    } else if (self.deviceDirection == kVinPhoneDirectionLeft) {
        if (self.phoneDirection == kVinPhoneDirectionUp) {
            angle = -M_PI_2;
        } else if (self.phoneDirection == kVinPhoneDirectionUpsideDown) {
            angle = M_PI_2;
        }
    } else if (self.deviceDirection == kVinPhoneDirectionRight) {
        if (self.phoneDirection == kVinPhoneDirectionUp) {
            angle = M_PI_2;
        } else if (self.phoneDirection == kVinPhoneDirectionUpsideDown) {
            angle = -M_PI_2;
        }
    }
    
    self.scanLine.transform = CGAffineTransformMakeRotation(angle);
    self.resultImageView.transform = CGAffineTransformMakeRotation(angle);
    self.centerLabel.transform = CGAffineTransformMakeRotation(angle);
    self.resultLabel.transform = CGAffineTransformMakeRotation(angle);
    self.savePicTipLabel.transform = CGAffineTransformMakeRotation(angle);
    self.backBtn.transform = CGAffineTransformMakeRotation(angle);
    self.flashBtn.transform = CGAffineTransformMakeRotation(angle);
    self.changeBtn.transform = CGAffineTransformMakeRotation(angle);
    self.photoBtn.transform = CGAffineTransformMakeRotation(angle);
    
    
    [self moveScanline];
    
}

- (void)clearSubViewsUp {
    
    [self.detectLayer removeFromSuperlayer];
    self.detectLayer = nil;
    
    [self.squareView removeFromSuperview];
    self.squareView = nil;
    [self.flashBtn removeFromSuperview];
    self.flashBtn = nil;
    [self.backBtn removeFromSuperview];
    self.backBtn = nil;
//    [self.changeBtn removeFromSuperview];
//    self.changeBtn = nil;
    [self.photoBtn removeFromSuperview];
    self.photoBtn = nil;
    [self.photoInBtn removeFromSuperview];
    self.photoInBtn = nil;
    [self.centerLabel removeFromSuperview];
    self.centerLabel = nil;
    [self.resultLabel removeFromSuperview];
    self.resultLabel = nil;
    [self.savePicTipLabel removeFromSuperview];
    self.savePicTipLabel = nil;
    [self.scanLine removeFromSuperview];
    self.scanLine = nil;
    [self.resultImageView removeFromSuperview];
    self.resultImageView = nil;
}


//计算检测视图层的空洞layer
- (CAShapeLayer *)getLayerWithHole {
    CGFloat offset = 1.0f;
    if ([UIScreen mainScreen].scale >= 2) {
        offset = 0.5;
    }
    
    CGRect topViewRect = self.squareView.squareFrame;
    
    CGRect centerRect = CGRectInset(topViewRect, -offset, -offset) ;
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
    CAShapeLayer *layerWithHole = [CAShapeLayer layer];
    [layerWithHole setPath:bezierPath.CGPath];
    [layerWithHole setFillRule:kCAFillRuleEvenOdd];
    [layerWithHole setFillColor:[UIColor colorWithWhite:0 alpha:0.35].CGColor];
    
    return layerWithHole;
    
}

//监听对焦
-(void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"adjustingFocus"]){
        _isFocusing = [[change objectForKey:NSKeyValueChangeNewKey] isEqualToNumber:[NSNumber numberWithInt:1]];
    }
    if([keyPath isEqualToString:@"lensPosition"]){
        _FocusPixelsPosition = [[change objectForKey:NSKeyValueChangeNewKey] floatValue];
    }
}


//移动扫描线
-(void)moveScanline{
    [self.scanLine setCenter:_linePoint];
    if (self.deviceDirection == kVinPhoneDirectionUp) {//手机正向状态弹出
        if (self.phoneDirection == kVinPhoneDirectionLeft) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.x -= self.squareView.squareFrame.size.width;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if (self.phoneDirection == kVinPhoneDirectionRight) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.x += self.squareView.squareFrame.size.width;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if(self.phoneDirection == kVinPhoneDirectionUp) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.y += self.squareView.squareFrame.size.height;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if (self.phoneDirection == kVinPhoneDirectionUpsideDown) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.y -= self.squareView.squareFrame.size.height;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }
    } else if(self.deviceDirection == kVinPhoneDirectionUpsideDown) {//手机倒向状态弹出
        if (self.phoneDirection == kVinPhoneDirectionLeft) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.x += self.squareView.squareFrame.size.width;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if (self.phoneDirection == kVinPhoneDirectionRight) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.x -= self.squareView.squareFrame.size.width;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if(self.phoneDirection == kVinPhoneDirectionUp) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.y -= self.squareView.squareFrame.size.height;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if (self.phoneDirection == kVinPhoneDirectionUpsideDown) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.y += self.squareView.squareFrame.size.height;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }
    } else if(self.deviceDirection == kVinPhoneDirectionLeft) {//手机左向状态弹出(homeButton在右侧)
        if (self.phoneDirection == kVinPhoneDirectionLeft) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.y += self.squareView.squareFrame.size.height;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if (self.phoneDirection == kVinPhoneDirectionRight) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.y -= self.squareView.squareFrame.size.height;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if(self.phoneDirection == kVinPhoneDirectionUp) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.x += self.squareView.squareFrame.size.width;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if (self.phoneDirection == kVinPhoneDirectionUpsideDown) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.x -= self.squareView.squareFrame.size.width;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }
    } else if(self.deviceDirection == kVinPhoneDirectionRight) {//手机右向状态弹出(homeButton在左侧)
        if (self.phoneDirection == kVinPhoneDirectionLeft) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.y -= self.squareView.squareFrame.size.height;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if (self.phoneDirection == kVinPhoneDirectionRight) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.y += self.squareView.squareFrame.size.height;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if(self.phoneDirection == kVinPhoneDirectionUp) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.x -= self.squareView.squareFrame.size.width;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }else if (self.phoneDirection == kVinPhoneDirectionUpsideDown) {
            [UIView animateWithDuration:2.5f delay:0.0f options:UIViewAnimationOptionRepeat animations:^{
                CGPoint center = _linePoint;
                center.x += self.squareView.squareFrame.size.width;
                [self.scanLine setCenter:center];
            } completion:^(BOOL finished) {
            }];
        }
    }
}

#pragma mark - AVCaptureSession delegate
//从缓冲区获取图像数据进行识别
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if(_isFocusing){
        return ;
    }
    
    
    if (!_isRecognize) {
        return ;
    }
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    
    if(_curPosition == _FocusPixelsPosition) {
        //开始识别
        int bSuccess = [_vinTyper recognizeVinTyper:baseAddress Width:(int)width Height:(int)height];
        //识别成功
        if(bSuccess == 0) {
            //震动
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//            SystemSoundID soundID=8787;
//            AudioServicesPlayAlertSound(soundID);
            //显示区域图像
            [self performSelectorOnMainThread:@selector(showResultAndImage:) withObject:_vinTyper.resultImg waitUntilDone:NO];
            _isRecognize = NO;
        }
    }else{
        _curPosition=_FocusPixelsPosition;
    }
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
}

//显示结果跟图像
-(void)showResultAndImage:(UIImage *)image {
    if ([self.delegate respondsToSelector:@selector(cameraController:audioRecognizeFinishWithResult:andVinImage:)]) {
        [self.delegate cameraController:self audioRecognizeFinishWithResult:_vinTyper.nsResult andVinImage:_vinTyper.resultImg];
    } else {
        NSLog(@"代理方法cameraController:audioRecognizeFinishWithResult:andVinImage:未实现");
    }
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
        if (self.phoneDirection != kVinPhoneDirectionUp) {
            NSLog(@"正");
            self.phoneDirection = kVinPhoneDirectionUp;
        }
        
    }else if(y >= x && y>0.6 && z>-0.7){
        //上下颠倒
        if (self.phoneDirection != kVinPhoneDirectionUpsideDown) {
            NSLog(@"倒");
            self.phoneDirection = kVinPhoneDirectionUpsideDown;
        }
    } else if(y < x && x>0.7 && z>-0.7){
        //右横屏
        if (self.phoneDirection != kVinPhoneDirectionRight) {
            NSLog(@"右");
            self.phoneDirection = kVinPhoneDirectionRight;
        }
    }else if (y >= x && x<=-0.6 && z > -0.7){
        //左横屏
        if (self.phoneDirection != kVinPhoneDirectionLeft) {
            NSLog(@"左");
            self.phoneDirection = kVinPhoneDirectionLeft;
        }
    }
}

#pragma mark - 点击事件

//返回按钮点击事件
- (void)backBtnClick {
    if ([self.delegate respondsToSelector:@selector(backButtonClickWithVinCamera:)]) {
        [self.delegate backButtonClickWithVinCamera:self];
    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)photoBtnClick {
    if (_isRecognize) {
        [self captureImage];
    }
}

//打开相册
- (void)photoInBtnClick{
        BYLog(@"打开相册");
    bool isPhotoLibraryAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
    if (isPhotoLibraryAvailable){
        if (self.vinPhotoInBlock) {
            self.vinPhotoInBlock();
        }
        [self dismissViewControllerAnimated:NO completion:nil];
    }
  
}



- (void)captureImage {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) { break; }
    }
    
    //get UIImage
    [self.captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        if (imageSampleBuffer == NULL) {
            NSLog(@"VinCamera:imageSampleBuffer is NULL");
            return ;
        }
        _isRecognize = NO;
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        UIImage *tempImage = [[UIImage alloc] initWithData:imageData];
        UIImage *fullImage = [UIImage imageWithCGImage:tempImage.CGImage scale:1.0 orientation:UIImageOrientationUp];
        
        //裁切vin码区域
        CGRect rcVin = CGRectZero;
        
        CGFloat x = self.squareView.squareFrame.origin.x;
        CGFloat y = self.squareView.squareFrame.origin.y;
        CGFloat width = self.squareView.squareFrame.size.width;
        CGFloat height = self.squareView.squareFrame.size.height;
        
        UIImage *rotateImage;
        if (SCREENH > SCREENW) {  //竖屏锁定(无论正倒)
            if (self.phoneDirection == kVinPhoneDirectionUp) {
                rcVin = CGRectMake(x * 720 / SCREENW, y * 1280/SCREENH, width * 720/SCREENW, height*1280/SCREENH);
                rotateImage = [VinCameraController image:fullImage rotation:UIImageOrientationRight];
            }else if (self.phoneDirection == kVinPhoneDirectionRight) {
                rcVin = CGRectMake(y*1280/SCREENH, x*720/SCREENW, height*1280/SCREENH, width*720/SCREENW);
                rotateImage = [VinCameraController image:fullImage rotation:UIImageOrientationDown];
            }else if (self.phoneDirection == kVinPhoneDirectionUpsideDown) {
                rcVin = CGRectMake(x * 720 / SCREENW, y * 1280/SCREENH, width * 720/SCREENW, height*1280/SCREENH);
                rotateImage = [VinCameraController image:fullImage rotation:UIImageOrientationLeft];
            }else if (self.phoneDirection == kVinPhoneDirectionLeft) {
                rcVin = CGRectMake(y*1280/SCREENH, x*720/SCREENW, height*1280/SCREENH, width*720/SCREENW);
                rotateImage = [VinCameraController image:fullImage rotation:UIImageOrientationUp];
            }
        } else { //横屏锁定(无论左右)
            if (self.phoneDirection == kVinPhoneDirectionUp) {
                rcVin = CGRectMake(y * 720/SCREENH, x * 1280 / SCREENW, height*720/SCREENH, width * 1280/SCREENW);
                rotateImage = [VinCameraController image:fullImage rotation:UIImageOrientationRight];
            }else if (self.phoneDirection == kVinPhoneDirectionRight) {
                rcVin = CGRectMake(x*1280/SCREENW, y*720/SCREENH, width*1280/SCREENW, height*720/SCREENH);
                rotateImage = [VinCameraController image:fullImage rotation:UIImageOrientationDown];
            }else if (self.phoneDirection == kVinPhoneDirectionUpsideDown) {
                rcVin = CGRectMake(y * 720/SCREENH, x * 1280 / SCREENW, height*720/SCREENH, width * 1280/SCREENW);
                rotateImage = [VinCameraController image:fullImage rotation:UIImageOrientationLeft];
            }else if (self.phoneDirection == kVinPhoneDirectionLeft) {
                rcVin = CGRectMake(x*1280/SCREENW, y*720/SCREENH, width*1280/SCREENW, height*720/SCREENH);
                rotateImage = [VinCameraController image:fullImage rotation:UIImageOrientationUp];
            }
        }
        
        CGImageRef imageRef = rotateImage.CGImage;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rcVin);
        UIGraphicsBeginImageContext(rcVin.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, rcVin, subImageRef);
        UIImage *vinImage = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        CGImageRelease(subImageRef);
        
        //保存图像到相册
        UIImageWriteToSavedPhotosAlbum(vinImage, self, nil, NULL);
        self.resultImageView.image = vinImage;
        self.resultLabel.text = @"图像已保存至相册";
        self.centerLabel.hidden = YES;
        self.scanLine.hidden = YES;
    }];
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
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
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
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}

//闪光灯按钮点击事件
- (void)flashBtnClick{
    
    if (!self.captureDevice.hasTorch) {
        //NSLog(@"no torch");
    }else{
        [self.captureDevice lockForConfiguration:nil];
        if(!_flash){
            [self.captureDevice setTorchMode: AVCaptureTorchModeOn];
            [self.flashBtn setImage:[UIImage imageNamed:@"ImageResource1.bundle/flash_off"] forState:UIControlStateNormal];
            _flash = YES;
        }
        else{
            [self.captureDevice setTorchMode: AVCaptureTorchModeOff];
            [self.flashBtn setImage:[UIImage imageNamed:@"ImageResource1.bundle/flash_on"] forState:UIControlStateNormal];
            _flash = NO;
        }
        [self.captureDevice unlockForConfiguration];
    }
    
}

//横屏 / 竖屏 切换  X 暂时不用这个功能
//拍照扫描切换  ← 这个
- (void)changeBtnClick {
    
    _isRecognize = YES;
    self.resultLabel.text = @"";
    self.centerLabel.hidden = NO;
    self.resultImageView.image = nil;
    if (!self.captureSession.isRunning) {
        [self.captureSession startRunning];
    }
    [self moveScanline];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 懒加载

#pragma mark - Setter
- (void)setIsHorizontal:(BOOL)isHorizontal {
    _isHorizontal = isHorizontal;
    [self clearSubViewsUp];
    
    [self prepareUI];
    
    [self setVinDetectArea];
}

- (void)setPhoneDirection:(VinPhoneDirection)phoneDirection {
    _phoneDirection = phoneDirection;
    _isRecognize = YES;
    if (_phoneDirection==kVinPhoneDirectionLeft) {
        self.isHorizontal = YES;
        [_vinTyper setVinRecognizeType:0];
    }else if (_phoneDirection==kVinPhoneDirectionRight){
        self.isHorizontal = YES;
        [_vinTyper setVinRecognizeType:2];
    }else if (_phoneDirection==kVinPhoneDirectionUp){
        self.isHorizontal = NO;
        [_vinTyper setVinRecognizeType:1];
    }else if (_phoneDirection==kVinPhoneDirectionUpsideDown){
        self.isHorizontal = NO;
        [_vinTyper setVinRecognizeType:3];
    }
}

#pragma mark - Getter

#pragma mark 相机相关

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        //创建会话层,视频浏览分辨率为1280*720
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
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
        NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
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
        NSString * formatKey = (NSString *)kCVPixelBufferPixelFormatTypeKey;
        NSNumber * value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary * videoSettings = [NSDictionary dictionaryWithObject:value forKey:formatKey];
        [_captureDataOutput setVideoSettings:videoSettings];
    }
    return _captureDataOutput;
}

- (AVCaptureVideoPreviewLayer *)capturePreviewLayer {
    if (!_capturePreviewLayer) {
        _capturePreviewLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
        CGFloat angle = 0;
        //Home键在左，则为M_PI_2；Home键在右，则为-M_PI_2
        if (self.deviceDirection == kVinPhoneDirectionRight) {
            angle = M_PI_2;
        } else if (self.deviceDirection == kVinPhoneDirectionLeft) {
            angle = -M_PI_2;
        } else if(self.deviceDirection == kVinPhoneDirectionUpsideDown) {
            angle = M_PI;
        }
        _capturePreviewLayer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);
        _capturePreviewLayer.frame = CGRectMake(0, 0, SCREENW, SCREENH);
        _capturePreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _capturePreviewLayer;
}

- (AVCaptureDevice *)captureDevice {
    if (!_captureDevice) {
        NSArray * deviceArr = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice * device in deviceArr)
        {
            if (device.position == AVCaptureDevicePositionBack){
                _captureDevice = device;
                _captureInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
            }
        }
    }
    return _captureDevice;
}

#pragma mark Motion
- (CMMotionManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [[CMMotionManager alloc] init];
        _motionManager.deviceMotionUpdateInterval = 1/15.0;
    }
    return _motionManager;
}


#pragma mark UI相关
- (UIButton *)flashBtn {
    if (!_flashBtn) {
        _flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashBtn setImage:[UIImage imageNamed:@"ImageResource1.bundle/flash_on"] forState:UIControlStateNormal];
        [_flashBtn addTarget:self action:@selector(flashBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashBtn;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"ImageResource1.bundle/back_btn"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (VinSquareView *)squareView {
    if (!_squareView) {
        _squareView = [[VinSquareView alloc] initWithIsHorizontal:self.isHorizontal];
        NSLog(@"self.isHorizontal%d",self.isHorizontal);
        _squareView.backgroundColor = [UIColor clearColor];
    }
    return _squareView;
}

- (UILabel *)centerLabel {
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.text = @"将框置于VIN码前";
        _centerLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _centerLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        _centerLabel.textColor = [UIColor whiteColor];
        _centerLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _centerLabel;
}


- (UILabel *)resultLabel {
    if (!_resultLabel) {
        CGFloat ratio = SCREENH / 568.0;
        int nSize = 22;
        if(ratio>1.0) nSize = 30;
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.text = @"";
        _resultLabel.font = [UIFont fontWithName:@"Helvetica" size:nSize];
        _resultLabel.textColor = [UIColor greenColor];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _resultLabel;
}

- (UILabel *)savePicTipLabel {
    if (!_savePicTipLabel) {
        _savePicTipLabel = [[UILabel alloc] init];
        _savePicTipLabel.text = @"如无法自动识别，请点击拍照按钮保存图像";
        _savePicTipLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _savePicTipLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        _savePicTipLabel.textColor = [UIColor whiteColor];
        _savePicTipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _savePicTipLabel;
}

- (UIImageView *)resultImageView {
    if (!_resultImageView) {
        _resultImageView = [[UIImageView alloc] init];
        _resultImageView.image = nil;
        
    }
    return _resultImageView;
}

- (UIImageView *)scanLine {
    if (!_scanLine) {
        CGFloat ratio = 1;
        
        if (SCREENW < 400) {
            ratio = SCREENW / 414.;
        }
        if (_isHorizontal) {
            if (SCREENW > SCREENH) {//横屏锁定
                _scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.squareView.squareFrame.size.width, 3 * ratio)];
            } else {//竖屏锁定
                _scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.squareView.squareFrame.size.height, 3 * ratio)];
            }
        }else{
            if (SCREENW > SCREENH) {//横屏锁定
                _scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.squareView.squareFrame.size.height, 3 * ratio)];
            } else {//竖屏锁定
                _scanLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.squareView.squareFrame.size.width, 3 * ratio)];
            }
        }
        _scanLine.image = [UIImage imageNamed:@"ImageResource1.bundle/scan_line"];
        
        CGPoint center;
        center.x = SCREENW * 0.5;
        center.y = SCREENH * 0.5;
        CGPoint top = center;
        if (self.deviceDirection == kVinPhoneDirectionUp) { //设备在正向状态弹出
            if (self.phoneDirection == kVinPhoneDirectionRight) {
                top.x -= self.squareView.squareFrame.size.width / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionLeft){
                top.x += self.squareView.squareFrame.size.width / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionUp){
                top.y -= self.squareView.squareFrame.size.height / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionUpsideDown){
                top.y += self.squareView.squareFrame.size.height / 2;
            }
        } else if (self.deviceDirection == kVinPhoneDirectionUpsideDown) { //设备在倒向状态弹出
            if (self.phoneDirection == kVinPhoneDirectionRight) {
                top.x += self.squareView.squareFrame.size.width / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionLeft){
                top.x -= self.squareView.squareFrame.size.width / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionUp){
                top.y += self.squareView.squareFrame.size.height / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionUpsideDown){
                top.y -= self.squareView.squareFrame.size.height / 2;
            }
        } else if (self.deviceDirection == kVinPhoneDirectionLeft) { //设备左向状态弹出(home button在右侧)
            if (self.phoneDirection == kVinPhoneDirectionRight) {
                top.y += self.squareView.squareFrame.size.height / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionLeft){
                top.y -= self.squareView.squareFrame.size.height / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionUp){
                top.x -= self.squareView.squareFrame.size.width / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionUpsideDown){
                top.x += self.squareView.squareFrame.size.width / 2;
            }
        } else if (self.deviceDirection == kVinPhoneDirectionRight) { //设备右向状态弹出(home button在左侧)
            if (self.phoneDirection == kVinPhoneDirectionRight) {
                top.y -= self.squareView.squareFrame.size.height / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionLeft){
                top.y += self.squareView.squareFrame.size.height / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionUp){
                top.x += self.squareView.squareFrame.size.width / 2;
            }else if(self.phoneDirection == kVinPhoneDirectionUpsideDown){
                top.x -= self.squareView.squareFrame.size.width / 2;
            }
        }
        [self.scanLine setCenter:top];
        _linePoint = self.scanLine.center;
        
        
    }
    return _scanLine;
}

- (UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [[UIButton alloc] init];
        [_changeBtn setImage:[UIImage imageNamed:@"ImageResource1.bundle/change_btn"] forState:UIControlStateNormal];
        [_changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeBtn;
}

- (UIButton *)photoBtn {
    if (!_photoBtn) {
        _photoBtn = [[UIButton alloc] init];
        [_photoBtn setImage:[UIImage imageNamed:@"ImageResource1.bundle/take_pic_btn"] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(photoBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoBtn;
}

- (UIButton *)photoInBtn {
    if (!_photoInBtn) {
        _photoInBtn = [[UIButton alloc] init];
        [_photoInBtn setImage:[UIImage imageNamed:@"ImageResource1.bundle/take_in_btn"] forState:UIControlStateNormal];
        [_photoInBtn addTarget:self action:@selector(photoInBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoInBtn;
}


- (CAShapeLayer *)detectLayer {
    if (!_detectLayer) {
        //设置检测视图层
        _detectLayer = [self getLayerWithHole];
        
    }
    return _detectLayer;
}

- (void)dealloc {
    NSLog(@"dealloc");
}

@end
