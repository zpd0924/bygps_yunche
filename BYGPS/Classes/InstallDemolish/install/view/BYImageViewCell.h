//
//  BYImageViewCell.h
//  父子控制器
//
//  Created by miwer on 2016/12/23.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYImageViewCell : UITableViewCell

@property(nonatomic,strong) NSMutableArray * images;

@property (weak, nonatomic) IBOutlet UIView *imageBgView;

@property(nonatomic,copy) void (^imageViewTapBlock) (NSInteger tag);
@property(nonatomic,copy) void (^deleteImageBlock) (NSInteger tag);

@end
