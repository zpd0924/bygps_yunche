//
//  BYListItemCell.h
//  BYGPS
//
//  Created by miwer on 16/9/2.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYItemNode;

@interface BYListItemCell : UITableViewCell

@property(nonatomic,copy)void (^selectItemBlock) (BOOL isSelect);

@property(nonatomic,copy) void (^selectCarBlock) ();

@property(nonatomic,strong) BYItemNode * itemNode;

@end
