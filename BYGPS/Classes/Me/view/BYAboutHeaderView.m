//
//  BYAboutHeaderView.m
//  BYGPS
//
//  Created by miwer on 16/7/27.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAboutHeaderView.h"

@interface BYAboutHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;

@end

@implementation BYAboutHeaderView

-(void)setCodeImage:(UIImage *)codeImage{
    self.codeImageView.image = codeImage;
}

@end
