//
//  BYNoHandleCollectionCell.h
//  BYGPS
//
//  Created by ZPD on 2017/4/25.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYNoHandleCollectionCell : UICollectionViewCell

@property (nonatomic,strong) UIImage *image1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
