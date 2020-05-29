//
//  BYChoiceServerAdressHeadView.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/24.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYChoiceServerAdressModel.h"
#import "BYChoiceServerAdressCityModel.h"
#import "BYChoiceServerAdressAreaModel.h"
typedef void(^BYChoiceServerAdressHeadViewBlock)(void);
@interface BYChoiceServerAdressHeadView : UIView
@property (weak, nonatomic) IBOutlet UIButton *provinceBtn;
@property (weak, nonatomic) IBOutlet UIView *provinceLine;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;
@property (weak, nonatomic) IBOutlet UIView *cityLine;
@property (weak, nonatomic) IBOutlet UIButton *areaBtn;
@property (weak, nonatomic) IBOutlet UIView *areaLine;
@property (nonatomic,copy) BYChoiceServerAdressHeadViewBlock provinceBlock;
@property (nonatomic,copy) BYChoiceServerAdressHeadViewBlock cityBlock;
@property (nonatomic,copy) BYChoiceServerAdressHeadViewBlock areaBlock;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) BYChoiceServerAdressModel *model;
@property (nonatomic,strong) BYChoiceServerAdressCityModel *model1;
@property (nonatomic,strong) BYChoiceServerAdressAreaModel *model2;
@end
