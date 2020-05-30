//
//  BYOTSDurationTypeView.h
//  BYGPS
//
//  Created by ZPD on 2017/6/28.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYOTSDurationTypeView : UIView

@property(nonatomic,assign) NSInteger selectType;

@property(nonatomic , assign) NSInteger buttonNum;
@property (nonatomic,strong) NSMutableArray *btnNameArr;

@property(nonatomic,copy) void (^durationTypeBlock)(NSInteger tag, BOOL isSelect);

-(instancetype)initWithFrame:(CGRect)frame btnNameArr:(NSArray *)btnNameArr selectType:(NSInteger )selectType haveTextField:(BOOL)isHaveTextField;

@end
