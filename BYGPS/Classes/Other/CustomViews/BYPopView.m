//
//  popView.m
//  PopMenuTableView
//
//  Created by bean on 16/8/1.
//  Copyright © 2016年 bean. All rights reserved.
//

#import "BYPopView.h"
#import "BYPopCell.h"
#import "BYDropTriangleView.h"

#define TriangleViewDefaultSize CGSizeMake(18, 10)

@interface BYPopView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * dataSource;
@property(nonatomic,strong) NSMutableArray * selectArray;
@property(nonatomic,strong) UIView * popAlertView;
@property(nonatomic,assign) NSInteger arrCount;

@property(nonatomic,strong) BYDropTriangleView * triangleView;

@end

@implementation BYPopView

- (void)setUpUIWithFrame:(CGRect)frame{
    
    self.triangleY = 64;
    self.triangleRightMargin = 20;
    self.menuRightMargin = 10;
    
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.popAlertView = [[UIView alloc] initWithFrame:frame];
    self.popAlertView.backgroundColor = [UIColor clearColor];
    self.popAlertView.layer.cornerRadius = 10;
    self.popAlertView.clipsToBounds = YES;
    self.popAlertView.layer.anchorPoint = CGPointMake(0.5, 0);
    self.popAlertView.layer.position = CGPointMake(frame.origin.x + frame.size.width / 2, frame.origin.y);
    self.popAlertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self addSubview:self.popAlertView];
    
    self.triangleView.frame =  CGRectMake(frame.size.width - frame.size.width / 2 - TriangleViewDefaultSize.width / 2, 0, TriangleViewDefaultSize.width, TriangleViewDefaultSize.height);
        
    [self.popAlertView addSubview:self.triangleView];

    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.triangleView.frame), frame.size.width, 35 * self.dataSource.count);
        
    [self.popAlertView addSubview:self.tableView];
    
}

+ (BYPopView *)createMenuWithFrame:(CGRect)frame dataSource:(NSArray *)dataSource selectArray:(NSMutableArray *)selectArray itemsClickBlock:(void (^)(NSInteger))itemsClickBlock backViewTap:(void (^)())backViewTapBlock{
    
    BYPopView *popView = [[BYPopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    popView.dataSource = dataSource;
    popView.selectArray = selectArray;
    popView.itemClickBlock = itemsClickBlock;
    popView.maskViewClickBlock = backViewTapBlock;
    popView.arrCount = selectArray.count;
    [popView setUpUIWithFrame:frame];

    return popView;
}

- (void)showMenuWithAnimation:(BOOL)isShow{
    
    [UIView animateWithDuration:0.25 animations:^{
        if (isShow) {
            self.popAlertView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }else{
            self.popAlertView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        }
    } completion:^(BOOL finished) {
        if (!isShow) {
            [self removeFromSuperview];
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showMenuWithAnimation:NO];
    if (self.maskViewClickBlock) {
        self.maskViewClickBlock();
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BYPopCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.title = self.dataSource[indexPath.row];
    cell.isSelect = [self.selectArray[indexPath.row] boolValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.itemClickBlock) {
        self.itemClickBlock(indexPath.row);
    }
    
    [self.selectArray removeAllObjects];
    for (NSInteger i = 0; i < self.arrCount; i ++) {
        [self.selectArray addObject:@(NO)];
    }
    self.selectArray[indexPath.row] = @(YES);
    [self.tableView reloadData];
    
    [self showMenuWithAnimation:NO];
    if (self.maskViewClickBlock) {
        self.maskViewClickBlock();
    }
    
}

#pragma mark - lazy
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.bounces = NO;
        _tableView.rowHeight = 35;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.cornerRadius = 10;
        _tableView.clipsToBounds = YES;
        [_tableView registerClass:[BYPopCell class] forCellReuseIdentifier:@"cell"];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

-(BYDropTriangleView *)triangleView{
    if (_triangleView == nil) {
        _triangleView = [[BYDropTriangleView alloc] init];
        _triangleView.backgroundColor = [UIColor clearColor];
    }
    return _triangleView;
}

@end











