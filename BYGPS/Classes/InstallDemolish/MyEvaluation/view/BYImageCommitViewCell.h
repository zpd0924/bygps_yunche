//
//  BYImageCommitViewCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/18.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYImageCommitViewCell : UITableViewCell
@property(nonatomic,strong) NSMutableArray * images;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *imageBgView;

@property(nonatomic,copy) void (^imageViewTapBlock) (NSInteger tag);
@property(nonatomic,copy) void (^deleteImageBlock) (NSInteger tag);
@property(nonatomic,copy) void (^isNoNameBlock) (NSInteger index);
@end
