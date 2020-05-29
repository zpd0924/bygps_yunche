//
//  BYEvaluationStarView.m
//  xsxc
//
//  Created by ZPD on 2018/5/30.
//  Copyright © 2018年 主沛东. All rights reserved.
//

#import "BYEvaluationStarView.h"

@interface BYEvaluationStarView ()

@property (nonatomic,assign) CGFloat starWH;

@property (strong, nonatomic) NSMutableArray *stars;

@end

@implementation BYEvaluationStarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setUpContentView];
    }
    return self;
}

- (void)setUpContentView{
    //星星之间的间隔
    CGFloat margin = 2;
    _allCount = 5;
    _starWH = self.frame.size.height;
    
    for (int i = 0; i < _allCount; i++) {
        CGFloat x = (_starWH + margin) * i;
        
        UIImageView *starImgView = [[UIImageView alloc] init];
        starImgView.by_x = x;
        starImgView.by_y = 0;
        
//        if (i < _lightCount) {
//            starImgView.image = [UIImage imageNamed:@"icon_evaluation_star_light"];
//        }else{
            starImgView.image = [UIImage imageNamed:@"icon_evaluation_star_normal"];
//        }
        [starImgView sizeToFit];
        [self addSubview:starImgView];
        
        [self.stars addObject:starImgView];
        
    }
}

-(void)setLightCount:(int)lightCount{
    for (int i = 0; i < self.stars.count; i ++) {
        UIImageView *starImgView = [self.stars objectAtIndex:i];
        if (i < lightCount) {
            if(_isSmallStar){
                starImgView.image = [UIImage imageNamed:@"icon_evaluation_star_light_small"];
            }else{
                starImgView.image = [UIImage imageNamed:@"icon_evaluation_star_light"];
            }
        
                    }else{
                        if(_isSmallStar){
                             starImgView.image = [UIImage imageNamed:@"icon_evaluation_star_normal_small"];
                        }else{
                             starImgView.image = [UIImage imageNamed:@"icon_evaluation_star_normal"];
                        }
                        
       
        }
    }
}

-(NSMutableArray *)stars{
    if (!_stars) {
        _stars = [NSMutableArray array];
    }
    return _stars;
}

@end
