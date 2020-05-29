//
//  BYFenceAnnotationView.m
//  BYGPS
//
//  Created by ZPD on 2017/8/16.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYFenceAnnotationView.h"
#import "BYControlModel.h"

#define self_H BYS_W_H(23)//标注的高度
@interface BYFenceAnnotationView ()

@property(nonatomic,strong) UIImageView * imageView;

@end
@implementation BYFenceAnnotationView
-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setIsControlCar:(BOOL)isControlCar{
    _isControlCar = isControlCar;
}

-(void)setupUI{
    
    //    self.backgroundColor = [UIColor whiteColor];
    self.bounds = CGRectMake(0, 0, 45, self_H);
    self.imageView.image = [UIImage imageNamed:@"icon_risk"];
    self.imageView.by_centerX = self_H / 2;
    self.imageView.by_y = self_H / 2 - self.imageView.image.size.height / 2;
    [self.imageView sizeToFit];
    [self addSubview:self.imageView];
}

-(void)setModel:(BYControlModel *)model
{

}
#pragma mark - lazy
-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.by_x = 0;
    }
    return _imageView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
