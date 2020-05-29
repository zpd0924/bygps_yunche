//
//  BYMyEvaluationCell.m
//  xsxc
//
//  Created by ZPD on 2018/5/30.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYMyEvaluationCell.h"
#import "UIImage+BYSquareImage.h"
#import "UIImageView+WebCache.h"
#import "BYMyEvaluationModel.h"
#import "SDPhotoBrowser.h"
#import "BYDateFormtterTool.h"
#import "BYEvaluationStarView.h"
#import "BYMyEvaluationImagesCell.h"
#import <Masonry.h>

#define margin 10
#define imageWH (BYSCREEN_W - 40 - 20) / 3
@interface BYMyEvaluationCell ()<SDPhotoBrowserDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *allImgBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBgHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimelabel;
@property (weak, nonatomic) IBOutlet UILabel *carModelLabel;
@property (weak, nonatomic) IBOutlet UILabel *evaluationLabel;
@property (weak, nonatomic) IBOutlet UIView *statView;

@property (nonatomic,strong) BYEvaluationStarView *evaluationStarView;
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;

@property(nonatomic,strong) UIView *imgBgView;
@property (nonatomic ,strong) UICollectionView *collection;//!<collectionView
@property (nonatomic ,strong) UICollectionViewFlowLayout *layout;//!<布局

//@property (nonatomic,strong) UIView *

@end

@implementation BYMyEvaluationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    [self.statView addSubview:self.evaluationStarView];
    [self.allImgBgView addSubview:self.collection];
    BYWeakSelf;
    
    [_collection mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.leading.top.bottom.equalTo(weakSelf.allImgBgView);
    }];
  
}

-(void)setModel:(BYMyEvaluationModel *)model
{
    _model = model;
    
    [self.headImgView sd_setImageWithURL:[NSURL URLWithString:model.portrait] placeholderImage:[UIImage imageNamed:@"icon_mine_placeholderHead"]];
    self.nameLabel.text = model.isAnonymous?@"匿名":model.commentUserName;
//    self.creatTimelabel.text = [BYDateFormtterTool getResultDateStrWithMS:model.creatTime formatStr:BYDateFormatNormalType];
    self.creatTimelabel.text = model.commentTime;
    self.evaluationLabel.text = model.commentContent;
    self.evaluationLabel.font = Font(14);
    self.evaluationStarView.lightCount = (int)model.compositeScore;

    
    
    if (model.compositeScore >= 4.5 && model.compositeScore <= 5.0) {
        self.starCountLabel.text = [NSString stringWithFormat:@"%zd.0高",model.compositeScore];
    }else if(model.compositeScore < 4.5 && model.compositeScore >= 3){
        self.starCountLabel.text = [NSString stringWithFormat:@"%zd.0中",model.compositeScore];
    }else{
        if(!model.compositeScore){
            self.starCountLabel.text = [NSString stringWithFormat:@"%zd",model.compositeScore];
        }else{
            self.starCountLabel.text = [NSString stringWithFormat:@"%zd.0差",model.compositeScore];
        }
        
    }
    
   
    self.allImgBgView.hidden = NO;
    NSArray *images = [NSArray array];
    if (model.commentImg.length) {
        images = [model.commentImg componentsSeparatedByString:@","];
    }
    model.cell_H = 90.f*PXSCALEH;
    model.cell_H = model.cell_H + [self calculateRowHeight:model.commentContent fontSize:14] ;

    self.imgBgHeightConstraint.constant = ((images.count + 2)/3) *(imageWH + margin);
    
    model.cell_H =  30*PXSCALEH + model.cell_H + self.imgBgHeightConstraint.constant;
    [self.collection reloadData];
}


- (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize{
    
    CGSize textMaxSize =  CGSizeMake(BYSCREEN_W - 40*PXSCALE, MAXFLOAT);
    CGSize textRealSize = [string boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:Font(fontSize)} context:nil].size;
    
 
    return textRealSize.height;
}



#pragma mark -- collocation代理
// 告诉系统每组多少个
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

  return  [_model.commentImg componentsSeparatedByString:@","].count;
    
    
}

// 告诉系统每个Cell如何显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 1.从缓存池中取
    BYMyEvaluationImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    
    // 2.使用
    cell.indexPath = indexPath;
    cell.imagesArray = [_model.commentImg componentsSeparatedByString:@","];
    cell.imageURL = [_model.commentImg componentsSeparatedByString:@","][indexPath.item];
    // 3.返回
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
        //大图浏览
    
        SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
        photoBrowser.delegate = self;
        photoBrowser.currentImageIndex = indexPath.item;
        photoBrowser.imageCount = [_model.commentImg componentsSeparatedByString:@","].count;
//        photoBrowser.sourceImagesContainerView = self;
    
        [photoBrowser show];
    
}


-(NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return [NSURL URLWithString:[BYObjectTool imageStr:[_model.commentImg componentsSeparatedByString:@","][index]]];
}

-(BYEvaluationStarView*)evaluationStarView
{
    if (!_evaluationStarView) {
      _evaluationStarView = [[BYEvaluationStarView alloc] initWithFrame:CGRectMake(0, 0, self.statView.frame.size.width, self.statView.frame.size.height)];
    }
    return _evaluationStarView;
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
        [_collection registerClass:[BYMyEvaluationImagesCell class] forCellWithReuseIdentifier:@"cell"];
    }
    
    return _collection;
}


- (UICollectionViewFlowLayout *)layout{
    
    if(!_layout){
        
        _layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置cell的尺寸
        _layout.itemSize = CGSizeMake(imageWH, imageWH);
        // 设置垂直方向的间隙
        //        _layout.minimumLineSpacing = 50;
        // 设置水平方向的间隙, 注意, 系统会自动跳转(可能不准确)
        _layout.minimumInteritemSpacing = margin;
        // 设置整个collectionView的边距
        //        _layout.sectionInset = UIEdgeInsetsMake(0, 60, 0, -60);
        // 设置滚动方向
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
    }
    
    return _layout;
}

@end
