//
//  BY036DurationTypeView.m
//  BYGPS
//
//  Created by ZPD on 2017/12/14.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BY036DurationTypeView.h"
#import "BY036DurationCell.h"
#import "BY036DurationModel.h"

@interface BY036DurationTypeView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;

//@property (nonatomic,strong) NSMutableArray *durationArr;

@end

@implementation BY036DurationTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.tableView.frame = frame;
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self;
        
//        NSArray *titleArr = @[@"1小时",@"2小时",@"3小时",@"4小时",@"6小时",@"8小时",@"12小时",@"1天",@"2天",@"3天",@"4天",@"5天",@"6天",@"7天",@"8天",@"9天",@"10天",@"11天",@"12天",@"13天",@"14天",@"15天"];
//
//        for (NSInteger i = 0 ; i < titleArr.count; i ++) {
//            BY036DurationModel *model = [[BY036DurationModel alloc] init];
//            model.title = titleArr[i];
//            if (i == 0) {
//                model.seleted = YES;
//            }
//            [self.durationArr addObject:model];
//        }
        self.tableView.showsVerticalScrollIndicator = YES;
        self.tableView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        [self.tableView flashScrollIndicators];
        BYRegisterCell(BY036DurationCell);
        [self addSubview:self.tableView];
    }
    return self;
}

-(void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    [self.tableView reloadData];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BY036DurationCell *cell = [tableView dequeueReusableCellWithIdentifier:BYCellID(BY036DurationCell) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BY036DurationModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (BY036DurationModel *model in self.dataSource) {
        model.seleted = NO;
    }
    BY036DurationModel *model = self.dataSource[indexPath.row];
    model.seleted = YES;
    [self.tableView reloadData];
    if (self.durationTypeSelectedBlock) {
        self.durationTypeSelectedBlock(indexPath.row, YES);
    }
}


-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

//-(NSMutableArray *)durationArr
//{
//    if (!_durationArr) {
//        _durationArr = [NSMutableArray array];
//    }
//    return _durationArr;
//}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
}


@end
