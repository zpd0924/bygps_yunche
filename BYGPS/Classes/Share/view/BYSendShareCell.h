//
//  BYSendShareCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/10.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYShareCommitParamModel.h"
@interface BYSendShareCell : UITableViewCell
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,strong) BYShareCommitParamModel *paramModel;
@end
