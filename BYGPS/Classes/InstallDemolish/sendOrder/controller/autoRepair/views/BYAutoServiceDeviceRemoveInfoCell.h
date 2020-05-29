//
//  BYAutoServiceDeviceRemoveInfoCell.h
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BYAutoServiceDeviceModel;
@interface BYAutoServiceDeviceRemoveInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *imageBgView;

@property (nonatomic,strong) BYAutoServiceDeviceModel *deviceModel;

@property (nonatomic,copy) void(^selectRemoveTypeBlock)(void);

@property(nonatomic,copy) void (^imageViewTapBlock) (NSInteger tag);
@property(nonatomic,copy) void (^deleteImageBlock) (NSInteger tag);

@end
