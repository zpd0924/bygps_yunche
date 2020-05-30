//
//  BYOTSWeakCell.h
//  BYGPS
//
//  Created by ZPD on 2017/6/29.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYOTSWeakCell : UITableViewCell

@property (nonatomic,strong) NSString *title;
@property (nonatomic,assign) BOOL isSelect;

@property (weak, nonatomic) IBOutlet UIView *separateView;

@end
