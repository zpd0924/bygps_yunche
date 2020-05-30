//
//  BYAutoServiceDeviceRepairInfoCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/13.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceDeviceRepairInfoCell.h"
#import "BYAutoDeviceRepairDeviceModel.h"

#import "BYPhotoModel.h"
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowser.h"

#define margin 10

@interface BYAutoServiceDeviceRepairInfoCell ()<SDPhotoBrowserDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *installPositionTextField;
@property (weak, nonatomic) IBOutlet UIView *installImgBgView;
@property (weak, nonatomic) IBOutlet UIImageView *intallImgView;

@property (weak, nonatomic) IBOutlet UIView *repairImgBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *installImgBgViewConstraintWidth;
@property (nonatomic,assign) BOOL installTap;

@property (nonatomic,strong) UIButton *installDeleteButton;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UILabel *repairTipTitleLabel;

@end

@implementation BYAutoServiceDeviceRepairInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.installImgBgViewConstraintWidth.constant = (kScreenWidth - 2 * margin - 12 * 2) / 3;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(installTapAction:)];
    [self.installImgBgView addGestureRecognizer:tap];
    
    self.installImgBgView.layer.cornerRadius = 5.0;
    self.installImgBgView.layer.masksToBounds = YES;
    
    CGFloat width = (kScreenWidth - 2 * margin - 12 * 2) / 3;
    self.installDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.installDeleteButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [self.installDeleteButton sizeToFit];
    CGFloat image_W = self.installDeleteButton.currentImage.size.width;
    self.installDeleteButton.frame = CGRectMake(width - image_W, 0, image_W, image_W);
 
    
    self.installPositionTextField.delegate = self;
    
    
    self.checkInstallButton.layer.cornerRadius = 15.0;
    self.checkInstallButton.layer.masksToBounds = YES;
    self.checkInstallButton.layer.borderWidth = 1;
    self.checkInstallButton.layer.borderColor = UIColorHexFromRGB(0x0FA9F5).CGColor;
}

-(void)setModel:(BYAutoDeviceRepairDeviceModel *)model{
    _model = model;
//    if (model.repairType == 1) {
//        self.installPositionTextField.text = model.installPosition.length > 0 ? model.installPosition : model.oldInstallPosition;
//    }else{
        self.installPositionTextField.text = model.installPosition;
//    }
    
    
    CGFloat width = (kScreenWidth - 2 * margin - 12 * 2) / 3;

    [self.installDeleteButton addTarget:self action:@selector(deleInstallImg:) forControlEvents:UIControlEventTouchUpInside];
    if (model.installImgModel.isP_HImage) {
        self.intallImgView.image = model.installImgModel.image;
        [self.installDeleteButton removeFromSuperview];
    }else{
        [self.installImgBgView addSubview:self.installDeleteButton];
        [self.intallImgView sd_setImageWithURL:[NSURL URLWithString:model.installImgModel.fullPath]];
    }
    
    for(UIView *view in [self.repairImgBgView subviews])
    {
        [view removeFromSuperview];
    }
    
    //    NSArray * titles = nil;
    //    switch (images.count) {
    //        case 3: titles = @[@"*设备号+车牌号",@"*具体安装位置",@"上传图片"]; break;
    //        case 4: titles = @[@"*设备号+车牌号",@"*具体安装位置",@"图片1",@"上传图片"]; break;
    //        case 5: titles = @[@"*设备号+车牌号",@"*具体安装位置",@"图片1",@"图片2",@"上传图片"]; break;
    //        case 6: titles = @[@"*设备号+车牌号",@"*具体安装位置",@"图片1",@"图片2",@"图片3",@"上传图片"]; break;
    //        case 7: titles = @[@"*设备号+车牌号",@"*具体安装位置",@"图片1",@"图片2",@"图片3",@"图片4",@"上传图片"]; break;
    //        default:
    //            break;
    //    }
    
    
    
    
    for (NSInteger i = 0; i < model.images.count; i ++) {
        
        //        if (i >= 6) return;//最多只能添加6张
        BYPhotoModel * photoModel = model.images[i];
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(i%3 * (margin + width), i/3 * (width + 2 * margin + margin), width, width + 2 * margin)];
        //        bgView.backgroundColor = [UIColor redColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        [self.repairImgBgView addSubview:bgView];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        
        imageView.tag = i + 150;
        imageView.userInteractionEnabled = YES;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        [bgView addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        
        
        if (!photoModel.isP_HImage) {//如果不是占位图
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:photoModel.fullPath]];
            
            UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
            [deleteButton sizeToFit];
            CGFloat image_W = deleteButton.currentImage.size.width;
            deleteButton.frame = CGRectMake(width - image_W, 0, image_W, image_W);
            
            [imageView addSubview:deleteButton];
            deleteButton.tag = 160 + i;
            [deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            imageView.image = photoModel.image;
            
        }
    }
}

-(void)setRepairScheme:(NSInteger)repairScheme{
    _repairScheme = repairScheme;
    self.tipLabel.text = repairScheme == 1 ? @"（非必传，最多6张）" : @"（必传，最多6张）";
    self.repairTipTitleLabel.text = repairScheme == 1 ? @"其他图片" : @"Vin和设备合照";
}


-(void)tapAction:(UITapGestureRecognizer *)tap{
    BYPhotoModel * model = self.model.images[tap.view.tag - 150];
    if (model.isP_HImage) {
        if (self.imageViewTapBlock) {
            self.imageViewTapBlock(tap.view.tag - 150);
        }
    }else{
        //大图浏览
        SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = tap.view.tag - 150;
        photoBrowser.imageCount = self.model.photoArr.count;
        photoBrowser.sourceImagesContainerView = self.repairImgBgView;
        //        self.selectImgIndex = tap.view.tag - 150;
        self.installTap = NO;
        [photoBrowser show];
        
    }
    
}

-(void)installTapAction:(UITapGestureRecognizer *)tap{
    if (self.model.installImgModel.isP_HImage) {
        if (self.installImgViewTapBlock) {
            self.installImgViewTapBlock();
        }
    }else{
        //大图浏览
        SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = 0;
        photoBrowser.imageCount = 1;
        photoBrowser.sourceImagesContainerView = self.installImgBgView;
        //        self.selectImgIndex = tap.view.tag - 150;
        self.installTap = YES;
        [photoBrowser show];
    }
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    if (self.installTap) {
        
        return [NSURL URLWithString:self.model.installImgModel.fullPath];
    }else{
        BYPhotoModel * model = self.model.images[index];
        return [NSURL URLWithString:model.fullPath];
    }
    
}

-(void)deleteImage:(UIButton *)button{
    if (self.deleteImageBlock) {
        self.deleteImageBlock(button.tag - 160);
    }
}

-(void)deleInstallImg:(UIButton *)button{
    if (self.installImgViewDeleteBlock) {
        self.installImgViewDeleteBlock();
    }
}
#pragma mark -- 查看安装示意图
- (IBAction)checkInstallConfirm:(id)sender {
    
    if (self.checkInstallConfirmBlock) {
        self.checkInstallConfirmBlock();
    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

    if (self.recentDevicePositionInputBlock) {
        self.recentDevicePositionInputBlock(textField.text);
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
