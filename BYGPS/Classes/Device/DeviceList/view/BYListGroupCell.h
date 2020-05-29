//
//  BYListGroupCell.h
//  BYGPS
//
//  Created by miwer on 16/9/1.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYGroupNode;

@interface BYListGroupCell : UITableViewCell

@property(nonatomic,copy)void (^selectGroupBlock) (BOOL isSelect);

@property(nonatomic,strong) BYGroupNode * groupNode;
@property (nonatomic,assign) BOOL isAddCar;

@end
