//
//  BYReplayAnnotationView.m
//  BYGPS
//
//  Created by miwer on 16/9/23.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYReplayAnnotationView.h"

@interface BYReplayAnnotationView ()

@end

@implementation BYReplayAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
    
    }
    return self;
}

-(void)setImageStr:(NSString *)imageStr{
    
    _imageStr = imageStr;
    UIImage * image = [UIImage imageNamed:_imageStr];
    [self setBounds:CGRectMake(0, 0, image.size.width, image.size.height)];
    self.imageView.frame = self.bounds;
    self.imageView.image = image;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    
//    UIImage * image = [UIImage imageNamed:_imageStr];
//    CGSize imageSize = image.size;
//    [self setBounds:CGRectMake(0, 0, imageSize.width, imageSize.height)];
//    self.imageView.frame = self.bounds;
//}


@end
