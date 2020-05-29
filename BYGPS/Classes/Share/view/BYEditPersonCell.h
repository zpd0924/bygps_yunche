//
//  BYEditPersonCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/13.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYShareUserModel.h"

typedef void(^BYEditPersonBlock)(BYShareUserModel *model);

@interface BYEditPersonCell : UITableViewCell
@property (nonatomic,strong) BYShareUserModel *model;
@property (nonatomic,copy) BYEditPersonBlock deletPersonBlock;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
