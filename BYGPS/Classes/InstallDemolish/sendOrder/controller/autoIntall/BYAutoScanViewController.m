//
//  BYAutoScanViewController.m
//  BYGPS
//
//  Created by 李志军 on 2018/9/5.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EasyNavigation.h"
#import "BYInstallHeaderView.h"
#import <Masonry.h>
#import "UILabel+HNVerLab.h"
#import "BYHandInputViewController.h"
#import "BYInstallRecordViewController.h"
#import "BYInstallDeviceCheckViewController.h"


@interface BYAutoScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, assign) BOOL isReading;

@property (nonatomic, assign) UIStatusBarStyle originStatusBarStyle;

@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic,strong) UIView *sureBtnView;
@property (nonatomic,strong) UIButton *lightBtn;
@property (nonatomic,assign) BOOL haveClosed;
@property (nonatomic,strong) BYInstallDeviceCheckModel *model;

@end

@implementation BYAutoScanViewController

- (id)init {
    self = [super init];
    if (self) {
        self.scanType = WQCodeScannerTypeAll;
        BYWeakSelf;

    }
    return self;
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)installRecord{
    BYInstallRecordViewController *vc = [[BYInstallRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)dealloc {
    _session = nil;
}


#pragma mark -- 设备检测
- (void)deviceCheck:(NSString *)deviceStr{
    BYWeakSelf;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"deviceSn"] = deviceStr;

    [BYSendWorkHttpTool POSTDeviceCheckParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.model = [BYInstallDeviceCheckModel yy_modelWithDictionary:data];
            if (!weakSelf.model.groupId) {
                BYShowError(@"设备所在组为空");
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _isReading = YES;
                     [self.session startRunning];
                });
                return ;
            }
            if (weakSelf.model.deviceStatus == 2) {
                BYShowError(weakSelf.model.exceptionMsg);
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _isReading = YES;
                     [self.session startRunning];
                });
                return;
            }
            [weakSelf refreshData];
           
        });
      
    } failure:^(NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _isReading = YES;
             [self.session startRunning];
        });
        
    }];
}
- (void)refreshData{
    
//    [self stopRunning];
//    [self.view.layer removeAllAnimations];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.autoScanBlock) {
            self.autoScanBlock(self.model);
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            if (self.model.deviceSn.length) {
                BYInstallDeviceCheckViewController *vc = [[BYInstallDeviceCheckViewController alloc] init];
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
       
    });
   
   
}
- (void)initBase{
    [self.navigationView setTitle:@"自助安装"];
    self.view.backgroundColor = BYBackViewColor;
    BYWeakSelf;
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationView.titleLabel setTextColor:[UIColor whiteColor]];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        [self.navigationView removeAllLeftButton];
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
        [weakSelf.navigationView addRightView:self.sureBtnView clickCallback:^(UIView *view) {
            MobClickEvent(@"self_record", @"");
            [weakSelf installRecord];
        }];
        
    });
    BYInstallHeaderView * tableHeader = [BYInstallHeaderView by_viewFromXib];
    tableHeader.workOrderInfoLabel.text = @"扫描设备";
    tableHeader.carInfoLabel.text = @"录入车辆";
    tableHeader.deviceInfoLabel.text = @"安装设备";
    tableHeader.showStepIndex = 0;
    tableHeader.frame = CGRectMake(0, SafeAreaTopHeight, BYSCREEN_W, 70);
    tableHeader.topNoticeView.hidden = YES;
    tableHeader.topH.constant = -30;
    [self.view addSubview:tableHeader];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.carSn.length) {
        [self deviceCheck:self.carSn];
    }
    
    [self loadCustomView];
    [self initBase];
    
    
    //判断权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{

            if (granted) {
                [self loadScanView];
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [self startRunning];
//                });
            } else {
                NSString *title = @"请在iPhone的”设置-隐私-相机“选项中，允许App访问你的相机";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
                [alertView show];
            }

        });
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//      BYStatusBarLight;
    //判断权限
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (granted) {
//                [self loadScanView];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self startRunning];
                });
            } else {
//                NSString *title = @"请在iPhone的”设置-隐私-相机“选项中，允许App访问你的相机";
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:@"" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//                [alertView show];
            }
            
        });
    }];
    
    
//    self.originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.haveClosed = YES;
    NSString *codeStr = @"";
    switch (_scanType) {
        case WQCodeScannerTypeAll: codeStr = @"二维码/条码"; break;
        case WQCodeScannerTypeQRCode: codeStr = @"二维码"; break;
        case WQCodeScannerTypeBarcode: codeStr = @"设备条码"; break;
        default: break;
    }
    
    //title
    if (self.titleStr && self.titleStr.length > 0) {
        self.titleLabel.text = self.titleStr;
    } else {
        self.titleLabel.text = codeStr;
    }
    
    //tip
    if (self.tipStr && self.tipStr.length > 0) {
        self.tipLabel.text = self.tipStr;
    } else {
        self.tipLabel.text= [NSString stringWithFormat:@"将%@放入框内，即可自动扫描", codeStr];
    }
    
//    [self startRunning];
    [self.session startRunning];
    BYLog(@"3333333333333");
    _isReading = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    BYStatusBarDefault;
    [self stopRunning];
    self.haveClosed = NO;
    [super viewWillDisappear:animated];
    [self.view.layer removeAllAnimations];
}

- (void)loadScanView {
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session addInput:input];
    [self.session addOutput:output];
    //设置扫码支持的编码格式
    switch (self.scanType) {
        case WQCodeScannerTypeAll:
            output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode,
                                         AVMetadataObjectTypeEAN13Code,
                                         AVMetadataObjectTypeEAN8Code,
                                         AVMetadataObjectTypeUPCECode,
                                         AVMetadataObjectTypeCode39Code,
                                         AVMetadataObjectTypeCode39Mod43Code,
                                         AVMetadataObjectTypeCode93Code,
                                         AVMetadataObjectTypeCode128Code,
                                         AVMetadataObjectTypePDF417Code];
            break;
            
        case WQCodeScannerTypeQRCode:
            output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
            break;
            
        case WQCodeScannerTypeBarcode:
            output.metadataObjectTypes=@[AVMetadataObjectTypeEAN13Code,
                                         AVMetadataObjectTypeEAN8Code,
                                         AVMetadataObjectTypeUPCECode,
                                         AVMetadataObjectTypeCode39Code,
                                         AVMetadataObjectTypeCode39Mod43Code,
                                         AVMetadataObjectTypeCode93Code,
                                         AVMetadataObjectTypeCode128Code,
                                         AVMetadataObjectTypePDF417Code];
            break;
            
        default:
            break;
    }
    
    AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
}

- (void)loadCustomView {
    self.view.backgroundColor = [UIColor blackColor];
    
    CGRect rc = [[UIScreen mainScreen] bounds];
    //rc.size.height -= 50;
    _width = rc.size.width * 0.1;
    //height = rc.size.height * 0.2;
    _height = (rc.size.height - (rc.size.width - _width * 2))/2;
    
    CGFloat alpha = 0.5;
    
    //最上部view
    UIView* upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rc.size.width, _height)];
    upView.alpha = alpha;
    upView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, _height, _width, rc.size.height - _height * 2)];
    leftView.alpha = alpha;
    leftView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:leftView];
    
    //中间扫描区域
    UIImageView *scanCropView=[[UIImageView alloc] initWithFrame:CGRectMake(_width, _height, rc.size.width - _width - _width, rc.size.height - _height - _height)];
    scanCropView.image=[UIImage imageNamed:@"二维码"];
    scanCropView. backgroundColor =[ UIColor clearColor ];
    scanCropView.userInteractionEnabled = YES;
    [ self.view addSubview :scanCropView];
    
    
   
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(rc.size.width - _width, _height, _width, rc.size.height - _height * 2)];
    rightView.alpha = alpha;
    rightView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:rightView];
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, rc.size.height - _height, rc.size.width, _height)];
    downView.alpha = alpha;
    downView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:downView];
    
    UILabel *tipLabel1 = [UILabel verLab:15 textRgbColor:BYGlobalBlueColor textAlighment:NSTextAlignmentCenter];
    tipLabel1.text = @"请先扫描设备";
    [self.view addSubview:tipLabel1];
    [tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(scanCropView.mas_bottom).offset(10);
    }];
    
    //用于说明的label
    self.tipLabel= [[UILabel alloc] init];
    self.tipLabel.backgroundColor = [UIColor clearColor];
//    self.tipLabel.frame=CGRectMake(_width, rc.size.height - _height, rc.size.width - _width * 2, 40);
    self.tipLabel.numberOfLines=0;
    self.tipLabel.textColor=[UIColor whiteColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    self.tipLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(tipLabel1.mas_bottom).offset(4);
    }];
    
    //手电筒按钮
    UIButton *lightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lightBtn = lightBtn;
    [lightBtn setImage:[UIImage imageNamed:@"light"] forState:UIControlStateNormal];
    //    [lightBtn sizeToFit];
    //    lightBtn.by_x = (rc.size.width - _width - _width) / 2 - BYS_W_H(24);
    //    lightBtn.by_y = scanCropView.by_height - 60;
    //    lightBtn.by_width = BYS_W_H(48);
    //    lightBtn.by_height = BYS_W_H(48);
    [lightBtn addTarget:self action:@selector(lightOnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightBtn];
    [lightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(-30);
        make.top.equalTo(_tipLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(23, 28));
    }];
    
    UILabel *lightTipLabel = [[UILabel alloc] init];
    
    lightTipLabel.text = @"轻触点亮";
    lightTipLabel.textAlignment = NSTextAlignmentCenter;
    lightTipLabel.font = [UIFont systemFontOfSize:13];
    lightTipLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:lightTipLabel];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lightOnAction1)];
    lightTipLabel.userInteractionEnabled = YES;
    [lightTipLabel addGestureRecognizer:tap1];
    [lightTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lightBtn);
        make.top.equalTo(lightBtn.mas_bottom).offset(3);
    }];
    
    UIButton *handBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [handBtn setImage:[UIImage imageNamed:@"点击"] forState:UIControlStateNormal];
    [handBtn addTarget:self action:@selector(handBtnOnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:handBtn];
    [handBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).offset(30);
        make.top.equalTo(_tipLabel.mas_bottom).offset(10);
    }];
    
    UILabel *handTipLabel = [[UILabel alloc] init];
    
    handTipLabel.text = @"手动录入";
    handTipLabel.textAlignment = NSTextAlignmentCenter;
    handTipLabel.font = [UIFont systemFontOfSize:13];
    handTipLabel.textColor = [UIColor whiteColor];
    handTipLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handBtnOnAction)];
    [handTipLabel addGestureRecognizer:tap];
    [self.view addSubview:handTipLabel];
    [handTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(handBtn);
        make.top.equalTo(handBtn.mas_bottom).offset(3);
    }];
    //画中间的基准线
    //    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake (_width, _height, rc.size.width - 2 * _width, 5)];
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake (_width, rc.size.height/2, rc.size.width - 2 * _width, 5)];
//    self.lineImageView.hidden = YES;
    
    self.lineImageView.image = [UIImage imageNamed:@"code_scanner_line"];
    [self.view addSubview:self.lineImageView];
    
    
    //标题
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, rc.size.width - 50 - 50, 44)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.titleLabel];
    
//    tew addSubview:backButton];
}

-(void)lightOnAction:(UIButton *)button{
    button.selected = ! button.selected;
    
    [self turnTorchOn:button.selected];
}
- (void)lightOnAction1{
    self.lightBtn.selected = !self.lightBtn.selected;
     [self turnTorchOn:self.lightBtn.selected];
}

-(void)handBtnOnAction{
    MobClickEvent(@"self_hand", @"");
    BYWeakSelf;
    BYHandInputViewController *vc = [[BYHandInputViewController alloc] init];
    vc.handInputBlock = ^(BYInstallDeviceCheckModel *model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.autoScanBlock) {
                self.autoScanBlock(model);
                [self.navigationController popViewControllerAnimated:NO];
            }else{
                if (model.deviceSn.length) {
                    BYInstallDeviceCheckViewController *vc = [[BYInstallDeviceCheckViewController alloc] init];
                    vc.model = model;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
            
        });
    };
    [self.navigationController pushViewController:vc animated:YES];
    

}
-(void)turnTorchOn:(BOOL) on{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch] && [device hasFlash]) {
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            } else{
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            
            [device unlockForConfiguration];
        }else{
            BYShowError(@"启动手电筒失败");
        }
    }else{
        BYShowError(@"没有闪光设备");
    }
}

- (void)startRunning {
    if (self.session) {
        _isReading = YES;
        
        [self.session startRunning];
        [self moveUpAndDownLine];
        
        //        _timer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats: YES];
    }
}

- (void)stopRunning {
//    if ([_timer isValid]) {
//        [_timer invalidate];
//        _timer = nil ;
//    }
    
    [self.session stopRunning];
}

- (void)pressBackButton {
    UINavigationController *nvc = self.navigationController;
    if (nvc) {
        if (nvc.viewControllers.count == 1) {
            [nvc dismissViewControllerAnimated:YES completion:nil];
        } else {
            [nvc popViewControllerAnimated:NO];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


//二维码的横线移动
- (void)moveUpAndDownLine {
    CGRect frame = self.lineImageView.frame;
    frame.origin.y = _height;
    self.lineImageView.frame = frame;
    BYWeakSelf;
    [UIView animateWithDuration:1.5 animations:^{
        CGRect frame = weakSelf.lineImageView.frame;
        frame.origin.y = _height + weakSelf.lineImageView.frame.size.width - 5;
        weakSelf.lineImageView.frame = frame;
    } completion:^(BOOL finished) {
        if (_haveClosed) {
            [weakSelf moveUpAndDownLine];
        }else{
            return ;
        }
        
    }];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!_isReading) {
          BYLog(@"2222222222222222222");
             BYLog(@"isReading = %zd",_isReading);
        }else{
            if (metadataObjects.count > 0) {
                _isReading = NO;
                 [self.session stopRunning];
                AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
                NSString *result = metadataObject.stringValue;
                
                if (self.resultBlock) {
                    self.resultBlock(result?:@"");
                }
                if (result.length == 0) {
                    BYShowError(@"设备编码识别失败,请手动输入");
                    return;
                }
                BYLog(@"11111111111111111111111111");
                BYLog(@"isReading = %zd",_isReading);
                [self deviceCheck:result];
            }
        }
      
    });
   
}

-(UIView *)sureBtnView
{
    if (!_sureBtnView) {
        _sureBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
        UILabel *label = [UILabel verLab:15 textRgbColor:BYLabelBlackColor textAlighment:NSTextAlignmentCenter];
        label.text = @"安装记录";
        [_sureBtnView addSubview:label];
        label.frame = _sureBtnView.bounds;
    }
    return _sureBtnView;
}
-(AVCaptureSession *)session
{
    if (!_session) {
        //初始化链接对象
        _session = [[AVCaptureSession alloc]init];
        //高质量采集率
        [_session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    return _session;
}

@end
