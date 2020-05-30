//
//  BYMyEvaluationImagesCell.m
//  xsxc
//
//  Created by 李志军 on 2018/7/3.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYMyEvaluationImagesCell.h"
#import <Masonry.h>
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowser.h"

@interface BYMyEvaluationImagesCell()<SDPhotoBrowserDelegate>
@property(nonatomic ,strong)UIImageView *backImageView;

@end
@implementation BYMyEvaluationImagesCell
- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if(self){
        
//        self.backgroundColor = [UIColor blackColor];
        [self creatUI];
    }
    
    return self;
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    
    
}



- (void)creatUI{
    
    
    [self.contentView addSubview:self.backImageView];
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(self.contentView);
    }];
}

- (void)setImageURL:(NSString *)imageURL{
    _imageURL = imageURL;
    _backImageView.tag = 1100 + _indexPath.item;
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:[BYObjectTool imageStr:imageURL]] placeholderImage:nil];
}
- (UIImageView *)backImageView{
    
    if(!_backImageView){
        
        _backImageView = [[UIImageView alloc] init];
        _backImageView.userInteractionEnabled = YES;
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
        // 裁剪超出imageView边框的部分
        _backImageView.clipsToBounds = YES;
        _backImageView.userInteractionEnabled = YES;
        //        _backImageView.contentMode = UIViewContentModeScaleAspectFit
        ;
        
    }
    
    return _backImageView;
}
@end
