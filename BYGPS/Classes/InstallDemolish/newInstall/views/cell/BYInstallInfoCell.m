//
//  BYInstallInfoCell.m
//  BYIntelligentAssistant
//
//  Created by ZPD on 2018/7/17.
//  Copyright © 2018年 BYKJ. All rights reserved.
//

#import "BYInstallInfoCell.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"

@interface BYInstallInfoCell ()<SDPhotoBrowserDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *devicePositionTextField;
@property (weak, nonatomic) IBOutlet UILabel *deviceSnLabel;
@property (nonatomic,strong) UIButton *installPositionDeleteButton;
@property (nonatomic,strong) NSMutableArray *imags;

@property (nonatomic,assign) NSInteger selectIndex;

@end

@implementation BYInstallInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.devicePositionTextField.delegate = self;
    

//    self.devicePositionTextField.enabled = self.isRecorrectInfo ? NO : YES;

    CGFloat width = 107;
    
    self.installPositionDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.installPositionDeleteButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [self.installPositionDeleteButton sizeToFit];
    CGFloat image_OrderW = self.installPositionDeleteButton.currentImage.size.width;
    self.installPositionDeleteButton.frame = CGRectMake(width - image_OrderW, 0, image_OrderW, image_OrderW);
    
    self.installPositionDeleteButton.tag = 502;
    [self.installPositionDeleteButton addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
}

//-(void)tapInputDeviceId{
//
//    if (self.inputDeviceIdCallBack) {
//        self.inputDeviceIdCallBack();
//    }
//}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (self.inputInstallNumBlock) {
        self.inputInstallNumBlock(textField.text);
    }
    return YES;
}


-(void)deleteImg:(UIButton *)button{
    
    if (self.installInfoDeleteImgCallBack) {
        self.installInfoDeleteImgCallBack(button.tag - 500);
    }
    self.deviceModel.positionIsP_HImage = YES;
    self.positionImgView.image = self.deviceModel.positionUploadImg;
    [self.installPositionDeleteButton removeFromSuperview];
//    [self.imags removeObjectAtIndex:(self.imags.count > 1 ? button.tag - 501 : 0)];
}

-(void)setDeviceModel:(BYSelfServiceInstallDeviceModel *)deviceModel{

    [self.imags removeAllObjects];
    _deviceModel = deviceModel;
    NSString *deviceTypeTitle;
    switch ([deviceModel.deviceType integerValue]) {
        case 0:
            deviceTypeTitle =[NSString stringWithFormat:@"有线设备(%@)",deviceModel.alias];

            break;
        case 1:
            deviceTypeTitle = [NSString stringWithFormat:@"无线设备(%@)",deviceModel.alias];

            break;
        case 3:
            deviceTypeTitle = [NSString stringWithFormat:@"其他设备(%@)",deviceModel.alias];

            break;

        default:
            break;
    }
    self.deviceTypeTitleLabel.text = deviceTypeTitle;
    self.deviceSnLabel.text = deviceModel.deviceSn;

    self.devicePositionTextField.text = deviceModel.devicePosition;

    CGFloat width = 107;
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [self.positionImgBgView addSubview:bgView];
    if (deviceModel.positionIsP_HImage) {
        self.positionImgView.image = deviceModel.positionUploadImg;
    }else{
        NSString *endPoint = [BYSaveTool valueForKey:BYOssDomainUrl];
        
        if ([[endPoint substringWithRange:NSMakeRange(endPoint.length - 1, 1)] isEqualToString:@"/"]) {
            [self.positionImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYOssDomainUrl],deviceModel.imgUrl]]];
        }else{
            [self.positionImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[BYSaveTool valueForKey:BYOssDomainUrl],deviceModel.imgUrl]]];
        }
        
    }

//    if (!deviceModel.positionIsP_HImage) {
//
//        [self.imags insertObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:kEndPoint],deviceModel.deviceImg]] atIndex:0];
//    }

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.positionImgBgView addGestureRecognizer:tap];

    if (!deviceModel.positionIsP_HImage) {//如果不是占位图

        [self.positionImgBgView addSubview:self.installPositionDeleteButton];
        [self bringSubviewToFront:self.installPositionDeleteButton];
    }else{
        [self.installPositionDeleteButton removeFromSuperview];
    }

    //    安装位置示意图
    UIView * bgView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [self.positionPlaceholdImgBgView addSubview:bgView1];

    [self.positionPlaceholdImgView sd_setImageWithURL:[NSURL URLWithString:deviceModel.positionPlaceHoldImgUrl]];

    
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.positionPlaceholdImgBgView addGestureRecognizer:tap1];

}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    if (tap.view.tag == 601) {
        if (!self.deviceModel.positionIsP_HImage) {
            //大图浏览
            SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
            photoBrowser.delegate = self;
            photoBrowser.currentImageIndex = 0;
            photoBrowser.imageCount = 1;
            photoBrowser.sourceImagesContainerView = self.positionImgBgView;
            self.selectIndex = 1;
            [photoBrowser show];
        }else{
            if (self.tapInstallPositionImgBgViewCallBack) {
                self.tapInstallPositionImgBgViewCallBack();
            }
        }
    }
    if (tap.view.tag == 602) {
        //大图浏览
        SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = 0;
        photoBrowser.imageCount = 1;
        photoBrowser.sourceImagesContainerView = self.positionPlaceholdImgBgView;
        self.selectIndex = 2;
        [photoBrowser show];
    }
}
- (IBAction)scanClick:(id)sender {
//    if (self.isRecorrectInfo) {
//        return;
//    }
    if (self.scanDeviceIdCallBack) {
        self.scanDeviceIdCallBack();
    }
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (self.selectIndex == 1) {
        return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[BYSaveTool valueForKey:BYOssDomainUrl],self.deviceModel.imgUrl]];
    }else{
        return [NSURL URLWithString:self.deviceModel.positionPlaceHoldImgUrl];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSMutableArray *)imags{
    if (!_imags) {
        _imags = [NSMutableArray array];
    }
    return _imags;
}

@end
