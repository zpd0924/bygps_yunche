//
//  BYAddWithoutCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYShareUserModel.h"

typedef void(^CellEditEndBlock)(BYShareUserModel *withoutModel);

@interface BYAddWithoutCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) BYShareUserModel *insideModel;
@property (nonatomic,strong) BYShareUserModel *withoutModel;
@property (nonatomic,copy) CellEditEndBlock cellEditEndBlock;
@property (nonatomic,copy) CellEditEndBlock cellDelectBlcok;
@property (nonatomic,assign) BYShareAddType shareAddType;

@end
