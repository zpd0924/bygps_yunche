//
//  BYEvaluateImageViewCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYEvaluateImageViewCell.h"
#import "BYPhotoModel.h"

@implementation BYEvaluateImageViewCell

-(void)setImages:(NSMutableArray *)images{
    
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
    CGFloat width = (BYSCREEN_W - 4 * margin - 10) / 3;
    
    for (NSInteger i = 0; i < images.count; i ++) {
        
        //        if (i >= 6) return;//最多只能添加6张
        BYPhotoModel * model = images[i];
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(i%3 * (margin + width), i/3 * (width + 2 * margin + margin), width, width + 2 * margin)];
        //        bgView.backgroundColor = [UIColor redColor];
        bgView.layer.cornerRadius = 5;
        bgView.layer.masksToBounds = YES;
        [self.imageBgView addSubview:bgView];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, width)];
        imageView.image = model.image;
        imageView.tag = i + 150;
        imageView.userInteractionEnabled = YES;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        [bgView addSubview:imageView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        
        
        if (!model.isP_HImage) {//如果不是占位图
            
            UIButton * deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteButton setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
            [deleteButton sizeToFit];
            CGFloat image_W = deleteButton.currentImage.size.width;
            deleteButton.frame = CGRectMake(width - image_W, 0, image_W, image_W);
            
            [imageView addSubview:deleteButton];
            deleteButton.tag = 160 + i;
            [deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        //        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, width, width, 2 * margin)];
        //        label.textAlignment = NSTextAlignmentCenter;
        //        label.text = titles[i];
        //        label.font = BYS_T_F(12);
        //        [bgView addSubview:label];
    }
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    if (self.imageViewTapBlock) {
        self.imageViewTapBlock(tap.view.tag - 150);
    }
}

-(void)deleteImage:(UIButton *)button{
    if (self.deleteImageBlock) {
        self.deleteImageBlock(button.tag - 160);
    }
}


@end
