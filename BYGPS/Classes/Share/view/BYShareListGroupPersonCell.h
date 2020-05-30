//
//  BYShareListGroupPersonCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/29.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYGroupShareNode,BYShareCommitParamModel;

typedef void(^BYShareListGroupPersonBlock)(BYShareCommitParamModel *paramModel);
@interface BYShareListGroupPersonCell : UITableViewCell
@property(nonatomic,copy)void (^selectGroupBlock) (BOOL isSelect);

@property(nonatomic,strong) BYGroupShareNode * groupNode;
@property (nonatomic,assign) BOOL isAddCar;
@property (nonatomic,copy) BYShareListGroupPersonBlock personBlock;
@property (nonatomic,strong)BYShareCommitParamModel *paramModel;

@end
