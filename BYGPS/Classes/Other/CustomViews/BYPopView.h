//
//  MenuView.h
//  PopMenuTableView
//
//  Created by bean on 16/8/1.
//  Copyright © 2016年 bean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYPopView : UIView

/** 10、三角形距离屏幕右边的间距(若不设置，默认为20) */
@property (nonatomic, assign) CGFloat triangleRightMargin;

/** 9、三角形相对于keyWindow的y值,也就是相对于屏幕顶部的y值(若不设置，默认为64) */
@property (nonatomic, assign) CGFloat triangleY;

/** 6、菜单条离屏幕右边的间距(若不设置，默认为10) */
@property (nonatomic, assign) CGFloat menuRightMargin;

@property(nonatomic,copy) void (^itemClickBlock) (NSInteger row);
@property(nonatomic,copy) void (^maskViewClickBlock) ();

/**
 *  menu
 *
 *  @param frame            菜单frame
 *  @param target           将在在何控制器弹出
 *  @param dataSource       菜单项内容
 *  @param itemsClickBlock  点击某个菜单项的blick
 *  @param backViewTapBlock 点击背景遮罩的block
 *
 *  @return 返回创建对象
 */
+ (BYPopView *)createMenuWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource selectArray:(NSMutableArray *)selectArray itemsClickBlock:(void (^)(NSInteger))itemsClickBlock backViewTap:(void (^)())backViewTapBlock;
/**
 *  展示菜单
 *
 *  @param isShow YES:展示  NO:隐藏
 */
- (void)showMenuWithAnimation:(BOOL)isShow;


@end
