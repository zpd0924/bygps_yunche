//
//  BYInsideListViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/12.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYShareCommitParamModel.h"

typedef void(^BYInsideListAddPersonBlock)(BYShareCommitParamModel *paramModel);

@interface BYInsideListViewController : UIViewController
@property (nonatomic,strong)BYShareCommitParamModel *paramModel;
@property (nonatomic,copy) BYInsideListAddPersonBlock insideListAddPersonBlock;
@end
