//
//  BYCarTypeViewModelCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/26.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYCarTypeSetModel.h"
#import "BYCarTypeInfoModel.h"
@interface BYCarTypeViewModelCell : UITableViewCell
@property (nonatomic,strong) BYCarTypeSetModel *model1;
@property (nonatomic,strong) BYCarTypeInfoModel *model2;
@end
