//
//  BYAutoServiceRemoveConclusionCell.h
//  BYGPS
//
//  Created by ZPD on 2018/12/12.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYRemoveConclusionModel;
@interface BYAutoServiceRemoveConclusionCell : UITableViewCell

@property (nonatomic,strong) BYRemoveConclusionModel *conclusionModel;

@property (weak, nonatomic) IBOutlet UIButton *removeReasonButton;

@property (nonatomic,copy) void(^removeReasonBlock)(void);

@end
