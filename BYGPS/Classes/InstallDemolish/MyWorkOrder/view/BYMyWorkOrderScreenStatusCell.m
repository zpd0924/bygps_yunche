//
//  BYMyWorkOrderScreenStatusCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYMyWorkOrderScreenStatusCell.h"
#import <Masonry.h>
#import "UILabel+HNVerLab.h"
#import "BYMyWorkOrderScreenStatusColloctionCell.h"

#define margin 5
#define imageW (MAXWIDTH - 80 - 3*margin - 25)/3
#define imageH 44
@interface BYMyWorkOrderScreenStatusCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *spaceView;
@property (nonatomic ,strong) UICollectionView *collection;//!<collectionView
@property (nonatomic ,strong) UICollectionViewFlowLayout *layout;//!<布局


@end

@implementation BYMyWorkOrderScreenStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        
        [self creatUI];
    }
    return self;
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    switch (indexPath.row) {
        case 0:
        {
            self.titleLabel.text = @"工单类型";
        }
            break;
        case 1:
        {
            self.titleLabel.text = @"工单时间";
        }
            break;
        case 2:
        {
            self.titleLabel.text = @"工单进度";
        }
            break;
        default:
        {
            self.titleLabel.text = @"派单用户";
        }
            break;
    }
}
- (void)setTitleArray:(NSArray *)titleArray{
    _titleArray = titleArray;
    [self.collection reloadData];
}

- (void)creatUI{
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.collection];
    [self.contentView addSubview:self.spaceView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15*PXSCALE);
        make.top.mas_equalTo(10*PXSCALEH);
    }];
    [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(10*PXSCALEH);
         make.left.mas_equalTo(15*PXSCALE);
         make.right.mas_equalTo(-8*PXSCALE);
        make.bottom.equalTo(self.contentView);
    }];
    [_spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MAXWIDTH - 100 - 10, 0.5));
        make.bottom.trailing.equalTo(self.contentView);
    }];
}

#pragma mark -- collocation代理
// 告诉系统每组多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _titleArray.count;
    
    
}

// 告诉系统每个Cell如何显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 1.从缓存池中取
    BYMyWorkOrderScreenStatusColloctionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BYMyWorkOrderScreenStatusColloctionCell" forIndexPath:indexPath];
    cell.backgroundColor = UIColorFromToRGB(241, 241, 241);
    cell.model = _titleArray[indexPath.item];
    // 3.返回
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"row = %zd",indexPath.row);
    for (BYMyWorkOrderScreenStatusModel *model in _titleArray) {
        model.isSelect = NO;
    }
    BYMyWorkOrderScreenStatusModel *model = _titleArray[indexPath.item];
    model.isSelect = YES;
    [self.collection reloadData];
    
}

- (UICollectionView *)collection{
    
    if(!_collection){
        
        _collection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        
        _collection.backgroundColor = [UIColor whiteColor];
        
        
        // 设置UICollectionView属性
        //        _collection.bounces = NO;
        _collection.showsVerticalScrollIndicator = NO;
        
        _collection.showsHorizontalScrollIndicator = NO;
        
        
        // 2.设置数据源
        _collection.dataSource = self;
        _collection.delegate = self;
        
        // 3.添加CollectionView到控制器View
        //        [self.imagesCountView addSubview:_collection];
        
        // 4.注册一个UICollectionViewCell
        
        [_collection registerNib:[UINib nibWithNibName:NSStringFromClass([BYMyWorkOrderScreenStatusColloctionCell class]) bundle:nil] forCellWithReuseIdentifier:@"BYMyWorkOrderScreenStatusColloctionCell"];
    }
    
    return _collection;
}


- (UICollectionViewFlowLayout *)layout{
    
    if(!_layout){
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell的尺寸
        _layout.itemSize = CGSizeMake(imageW, imageH);
//         设置垂直方向的间隙
                _layout.minimumLineSpacing = 5;
        // 设置水平方向的间隙, 注意, 系统会自动跳转(可能不准确)
        _layout.minimumInteritemSpacing = margin;
        // 设置整个collectionView的边距
        //        _layout.sectionInset = UIEdgeInsetsMake(0, 60, 0, -60);
        // 设置滚动方向
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
    }
    
    return _layout;
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel verLab:15 textRgbColor:BYLabelGrayColor textAlighment:NSTextAlignmentLeft];
        _titleLabel.text = @"工单类型";
    }
    return _titleLabel;
}
-(UIView *)spaceView
{
    if (!_spaceView) {
        _spaceView = [[UIView alloc] init];
        _spaceView.backgroundColor = BYBigSpaceColor;
    }
    return _spaceView;
}
@end
