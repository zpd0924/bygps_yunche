//
//  BYKeepDeviceInfoStatusCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYKeepDeviceInfoStatusModel.h"
@interface BYKeepDeviceInfoStatusCell : UICollectionViewCell

@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) BYKeepDeviceInfoStatusModel *model;
@end
