//
//  BYSureImageCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSureImageCell.h"
#import "UIImage+BYSquareImage.h"

@interface BYSureImageCell ()

@property (weak, nonatomic) IBOutlet UIView *iamgeBgView;


@end

@implementation BYSureImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setImages:(NSMutableArray *)images{

    CGFloat margin = 10;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 6 * margin) / 3;
    
    for (NSInteger i = 0; i < images.count; i ++) {
        
        if (i >= 6) return;//最多只能添加6张
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i%3 * (margin + width), i/3 * (width + margin), width, width)];
        imageView.image = [UIImage squareImageWith:images[i] newSize:width];
        [self.iamgeBgView addSubview:imageView];
    }
}


@end
