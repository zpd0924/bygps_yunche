//
//  BYAddWithoutController.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYShareCommitParamModel.h"

typedef void(^BYAddPersonBlock)(BYShareCommitParamModel *paramModel);

@interface BYAddWithoutController : UIViewController
@property (nonatomic,assign) BYShareAddType shareAddType;
@property (nonatomic,strong) BYShareCommitParamModel *paramModel;
@property (nonatomic,copy) BYAddPersonBlock addPersonBlock;
@end
