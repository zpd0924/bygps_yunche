//
//  BYShareSearchePersonCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/28.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYCompanyModel.h"
#import "BYShareCommitParamModel.h"
typedef void(^BYShareSearchePersonCellBlock)(BYCompanyModel *model);
@interface BYShareSearchePersonCell : UITableViewCell
@property (nonatomic,strong)BYShareCommitParamModel *paramModel;
@property (nonatomic,strong) BYCompanyModel *model;
@property (nonatomic,copy) BYShareSearchePersonCellBlock addPersonBlock;
@end
