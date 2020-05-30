//
//  VinManager.m
//  VinDemo
//
//  Created by ocrgroup on 2018/3/9.
//  Copyright © 2018年 ocrgroup. All rights reserved.
//

#import "VinManager.h"
#import "vinTyper.h"

@interface VinManager ()<VinCameraDelegate>

@property (nonatomic, strong) VinTyper * vinTyper;

@end


@implementation VinManager

static id _instacetype;

#pragma mark - 单例创建
+ (instancetype)sharedVinManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instacetype = [[super alloc] init];
    });
    return _instacetype;
}

#pragma mark - 功能函数实现
//MARK:视频流预览识别
- (void)recognizeVinCodeByAudioWithController:(UIViewController *)parentController isOneDirectionRecognize:(BOOL)oneDirection isUsePush:(BOOL)usePush andAuthCode:(NSString *)authCode {
    VinCameraController * cameraVC = [[VinCameraController alloc] initWithAuthorizationCode:authCode];
    BYWeakSelf;
    cameraVC.vinPhotoInBlock = ^{
        if (weakSelf.photoInBlcok) {
            weakSelf.photoInBlcok();
        }
    };
    cameraVC.delegate = self;
    cameraVC.isOneDirection = oneDirection;
    cameraVC.deviceDirection = cameraVC.preferredInterfaceOrientationForPresentation - 1;
    if (usePush) {
        [parentController.navigationController pushViewController:cameraVC animated:YES];
    } else {
        cameraVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [parentController presentViewController:cameraVC animated:YES completion:nil];
    }
    
}

//MARK:视频流代理回调
- (void)cameraController:(UIViewController *)cameraController audioRecognizeFinishWithResult:(NSString *)vinCode andVinImage:(UIImage *)vinImage {
    if ([self.delegate respondsToSelector:@selector(cameraController:audioRecognizeFinishWithResult:andVinImage:)]) {
        [self.delegate cameraController:cameraController audioRecognizeFinishWithResult:vinCode andVinImage:vinImage];
    } else {
        NSLog(@"代理方法cameraController:audioRecognizeFinishWithResult:andVinImage:未实现");
    }
}


//MARK:导入/拍照识别
- (void)recognizeVinCodeWithPhoto:(UIImage *)vinImage andAuthCode:(NSString *)authCode {
    int success = [self initRecognizeCoreWithAuthCode:authCode];
    if (success != 0) {
        return ;
    }
    
    vinImage = [self fixOrientation:vinImage];
    
    if (vinImage.size.width > vinImage.size.height) {//横向
        [self.vinTyper setVinRecognizeType:0];
    }else{//纵向
        [self.vinTyper setVinRecognizeType:1];
    }
    
    int bSuccess = [self.vinTyper recognizeVinTyperImage:vinImage];
    
    if ([self.delegate respondsToSelector:@selector(photoRecognizeFinishWithResult:andErrorCode:)]) {
        [self.delegate photoRecognizeFinishWithResult:self.vinTyper.nsResult andErrorCode:bSuccess];
    } else {
        NSLog(@"代理方法photoRecognizeFinishWithResult:andErrorCode:未实现");
    }
    
    [self.vinTyper freeVinTyper];
    
}

//MARK:图片方向修复
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//MARK:初始化识别核心
- (int)initRecognizeCoreWithAuthCode:(NSString *)authCode {
    int nRet = [self.vinTyper initVinTyper:authCode nsReserve:@""];
    if (nRet != 0) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSArray * appleLanguages = [defaults objectForKey:@"AppleLanguages"];
        NSString * systemLanguage = [appleLanguages objectAtIndex:0];
        if (![systemLanguage isEqualToString:@"zh-Hans"]) {
            NSString *initStr = [NSString stringWithFormat:@"Init Error!Error code:%d",nRet];
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"Tips" message:initStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertV show];
        }else{
            NSString *initStr = [NSString stringWithFormat:@"初始化失败!错误代码:%d",nRet];
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:initStr delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertV show];
        }
        
    } else {
        //成功
        int day = [self calculateTheRemainingDaysOfLicenceWithDeadLine:self.vinTyper.nsEndTime];
        
        if (day<=7) {
            NSLog(@"⚠️授权还有不到7天到期❗️❗️❗️请及时更换");
        }
        
    }
    return nRet;
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

//MARK:核心
- (VinTyper *)vinTyper {
    if (!_vinTyper) {
        _vinTyper = [[VinTyper alloc] init];
    }
    return _vinTyper;
}

@end
