//
//  BYChoiceServerAdressCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYChoiceServerAdressModel.h"
#import "BYChoiceServerAdressCityModel.h"
#import "BYChoiceServerAdressAreaModel.h"

@interface BYChoiceServerAdressCell : UITableViewCell
@property (nonatomic,strong) BYChoiceServerAdressModel *model1;
@property (nonatomic,strong) BYChoiceServerAdressCityModel *model2;
@property (nonatomic,strong) BYChoiceServerAdressAreaModel *model3;
@end
