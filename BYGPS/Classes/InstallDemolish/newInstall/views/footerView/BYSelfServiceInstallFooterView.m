//
//  BYSelfServiceInstallFooterView.m
//  BYGPS
//
//  Created by ZPD on 2018/9/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYSelfServiceInstallFooterView.h"
#import "SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"


@interface BYSelfServiceInstallFooterView ()<SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIView *vinImgBgView;
@property (weak, nonatomic) IBOutlet UIImageView *vinImgView;

@property (nonatomic,strong) UIButton *vinImgDeleteButton;

@end

@implementation BYSelfServiceInstallFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)awakeFromNib{
    [super awakeFromNib];
    
    CGFloat width = 107;
    
    self.vinImgDeleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.vinImgDeleteButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [self.vinImgDeleteButton sizeToFit];
    CGFloat image_OrderW = self.vinImgDeleteButton.currentImage.size.width;
    self.vinImgDeleteButton.frame = CGRectMake(width - image_OrderW, 0, image_OrderW, image_OrderW);
    
    self.vinImgDeleteButton.tag = 502;
    [self.vinImgDeleteButton addTarget:self action:@selector(deleteImg:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    if (tap.view.tag == 603) {
        if (!self.photoModel.isP_HImage) {
            //大图浏览
            SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
            photoBrowser.delegate = self;
            photoBrowser.currentImageIndex = 0;
            photoBrowser.imageCount = 1;
            photoBrowser.sourceImagesContainerView = self.vinImgBgView;
            [photoBrowser show];
        }else{
            if (self.tapVINImgBgViewCallBack) {
                self.tapVINImgBgViewCallBack();
            }
        }
    }
}

-(void)setPhotoModel:(BYPhotoModel *)photoModel{
    _photoModel = photoModel;
    CGFloat width = 107;
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
    [self.vinImgBgView addSubview:bgView];
    if (photoModel.isP_HImage) {
        self.vinImgView.image = photoModel.image;
    }else{
        NSString *endPoint = [BYSaveTool valueForKey:BYOssDomainUrl];
        if ([[endPoint substringWithRange:NSMakeRange(endPoint.length - 1, 1)] isEqualToString:@"/"]) {
            [self.vinImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[BYSaveTool valueForKey:BYOssDomainUrl],photoModel.imageAddress]]];
        }else{
            [self.vinImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[BYSaveTool valueForKey:BYOssDomainUrl],photoModel.imageAddress]]];
        }
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.vinImgBgView addGestureRecognizer:tap];
    
    if (!photoModel.isP_HImage) {//如果不是占位图
        
        [self.vinImgBgView addSubview:self.vinImgDeleteButton];
        [self bringSubviewToFront:self.vinImgDeleteButton];
    }else{
        [self.vinImgDeleteButton removeFromSuperview];
    }
}
-(void)deleteImg:(UIButton *)button{
    
    if (self.deleteVinImgBlock) {
        self.deleteVinImgBlock();
    }
    
    [self.vinImgDeleteButton removeFromSuperview];
    self.vinImgView.image = self.photoModel.image;
    //    [self.imags removeObjectAtIndex:(self.imags.count > 1 ? button.tag - 501 : 0)];
}


-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{

    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[BYSaveTool valueForKey:BYOssDomainUrl],self.photoModel.imageAddress]];

}



@end
