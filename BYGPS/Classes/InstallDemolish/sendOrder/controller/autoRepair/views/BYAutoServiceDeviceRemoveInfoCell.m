//
//  BYAutoServiceDeviceRemoveInfoCell.m
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYAutoServiceDeviceRemoveInfoCell.h"
#import "BYAutoServiceDeviceModel.h"

#import "BYPhotoModel.h"
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowser.h"


@interface BYAutoServiceDeviceRemoveInfoCell ()<SDPhotoBrowserDelegate>

@property (nonatomic,strong) UIButton *seletButton;
@property (nonatomic,assign) NSInteger selectImgIndex;
@property (weak, nonatomic) IBOutlet UIButton *selectRemoveReasonButton;

@end

@implementation BYAutoServiceDeviceRemoveInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

-(void)setDeviceModel:(BYAutoServiceDeviceModel *)deviceModel{
    _deviceModel = deviceModel;
    switch (deviceModel.isRemoved) {
//            1=设备已拆除，解除关联。2=设备未拆除，未解除关联。3=设备未拆除，强制解除关联。
        case 1:
            [self.selectRemoveReasonButton setTitle:@"设备已拆除，解除关联" forState:UIControlStateNormal];
            break;
        case 2:
            [self.selectRemoveReasonButton setTitle:@"设备未拆除，未解除关联" forState:UIControlStateNormal];
            break;
        case 3:
            [self.selectRemoveReasonButton setTitle:@"设备未拆除，强制解除关联" forState:UIControlStateNormal];
            break;
            
        default:
            [self.selectRemoveReasonButton setTitle:@"请选择拆机结果" forState:UIControlStateNormal];
            break;
    }
    
//    self.seletButton = (UIButton *)[self viewWithTag:deviceModel.isRemoved + 1210 - 1];
//    self.seletButton.selected = YES;
//    [self.seletButton setImage:[UIImage imageNamed:@"icon_autoService_remove_select"] forState:UIControlStateNormal];
    
    
    for(UIView *view in [self.imageBgView subviews])
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
    
    CGFloat margin = 10;
    CGFloat width = (kScreenWidth - 2 * margin - 12 * 2) / 3;
    
    for (NSInteger i = 0; i < deviceModel.images.count; i ++) {
        
        //        if (i >= 6) return;//最多只能添加6张
        BYPhotoModel * model = deviceModel.images[i];
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(i%3 * (margin + width), i/3 * (width + 2 * margin + margin), width, width + 2 * margin)];
        //        bgView.backgroundColor = [UIColor redColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        [self.imageBgView addSubview:bgView];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        
        imageView.tag = i + 150;
        imageView.userInteractionEnabled = YES;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        [bgView addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        
        
        if (!model.isP_HImage) {//如果不是占位图
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.fullPath]];
            
            UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
            [deleteButton sizeToFit];
            CGFloat image_W = deleteButton.currentImage.size.width;
            deleteButton.frame = CGRectMake(width - image_W, 0, image_W, image_W);
            
            [imageView addSubview:deleteButton];
            deleteButton.tag = 160 + i;
            [deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            imageView.image = model.image;
            
        }
        
        //        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, width, width, 2 * margin)];
        //        label.textAlignment = NSTextAlignmentCenter;
        //        label.text = titles[i];
        //        label.font = BYS_T_F(12);
        //        [bgView addSubview:label];
    }
    
}

- (IBAction)selectRemoveType:(UIButton *)sender {
    
//    if (self.seletButton == nil) {
//        sender.selected = YES;
//        self.seletButton = sender;
//    }else if (self.seletButton != nil&&self.seletButton == sender){
//        sender.selected = YES;
//    }else if (self.seletButton != sender&&self.seletButton != nil){
//        self.seletButton.selected = NO;
//        [self.seletButton setImage:[UIImage imageNamed:@"icon_autoService_remove_normal"] forState:UIControlStateNormal];
//        sender.selected = YES;
//        self.seletButton = sender;
//    }
//    [self.seletButton setImage:[UIImage imageNamed:@"icon_autoService_remove_select"] forState:UIControlStateNormal];
    
    if (self.selectRemoveTypeBlock) {
        self.selectRemoveTypeBlock();
    }
}


-(void)tapAction:(UITapGestureRecognizer *)tap{
    BYPhotoModel * model = self.deviceModel.images[tap.view.tag - 150];
    if (model.isP_HImage) {
        if (self.imageViewTapBlock) {
            self.imageViewTapBlock(tap.view.tag - 150);
        }
    }else{
        //大图浏览
        SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = tap.view.tag - 150;
        photoBrowser.imageCount = self.deviceModel.photoArr.count;
        photoBrowser.sourceImagesContainerView = self.imageBgView;
        //        self.selectImgIndex = tap.view.tag - 150;
        [photoBrowser show];
        
    }
    
}

-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    BYPhotoModel * model = self.deviceModel.images[index];
    return [NSURL URLWithString:model.fullPath];
}

-(void)deleteImage:(UIButton *)button{
    if (self.deleteImageBlock) {
        self.deleteImageBlock(button.tag - 160);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
