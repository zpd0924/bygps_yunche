//
//  BYShareListGroupCell.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/27.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BYGroupShareNode;
@interface BYShareListGroupCell : UITableViewCell
@property(nonatomic,copy)void (^selectGroupBlock) (BOOL isSelect);

@property(nonatomic,strong) BYGroupShareNode * groupNode;
@property (nonatomic,assign) BOOL isAddCar;
@end
