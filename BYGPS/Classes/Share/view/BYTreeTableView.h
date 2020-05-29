//
//  BYTreeTableView.h
//  BYGPS
//
//  Created by 李志军 on 2018/12/27.
//  Copyright © 2018 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Node;

@protocol TreeTableCellDelegate <NSObject>

-(void)cellClick : (Node *)node;

@end
@interface BYTreeTableView : UITableView
@property (nonatomic , weak) id<TreeTableCellDelegate> treeTableCellDelegate;

-(instancetype)initWithFrame:(CGRect)frame withData : (NSArray *)data;
@end
