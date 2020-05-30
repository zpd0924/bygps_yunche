//
//  BYAnnotationView.m
//  BYGPS
//
//  Created by miwer on 16/9/8.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYAnnotationView.h"

#define self_H BYS_W_H(23)//标注的高度

@interface BYAnnotationView ()

@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) UILabel * label;

@end

@implementation BYAnnotationView

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
//    self.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.imageView];
    
    [self addSubview:self.label];
}

-(void)setIsControlCar:(BOOL)isControlCar{
    _isControlCar = isControlCar;
}

-(void)setDirection:(NSInteger)direction{
    
    _direction = direction == 0 ? 360 : direction;
}

-(void)setCarNum:(NSString *)carNum{
    _carNum = carNum;
    CGSize size = [carNum sizeWithAttributes: @{NSFontAttributeName: BYS_T_F(12)}];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.bounds = CGRectMake(0, 0, size.width + 45, self_H);
        self.label.text = carNum;
        self.label.by_x = CGRectGetMaxX(self.imageView.frame) + 5;
        self.label.by_width = size.width + 20;
        self.label.by_height = self_H;
    });
}

-(void)setAlarmOrOff:(NSInteger)alarmOrOff{
    
    _alarmOrOff = alarmOrOff;
    dispatch_async(dispatch_get_main_queue(), ^{
        //"alarmOrOff":0在线  1离线灰色  2在线不定位橙色  3在线行驶蓝色  4在线静止绿色  5报警红色
        NSArray * imageNames = [NSArray array];
        imageNames = self.isControlCar ? @[@"car_gray",@"car_gray",@"car_orange",@"car_blue",@"car_green",@"car_red",@"car_gray"] : @[@"arr_gray",@"arr_gray",@"arr_orange",@"arr_blue",@"arr_green",@"arr_red",@"arr_gray"];
    
        NSArray * BgColors = @[@"#929292",@"#929292",@"#f6ae00",@"#3385ff",@"#45be37",@"#ff543e",@"#929292"];
        NSArray * borderColors = @[@"#797979",@"#797979",@"#ce9202",@"#1d72f0",@"#1f9d07",@"#e12e17",@"#797979"];
    
        self.imageView.image = [UIImage imageNamed:imageNames[alarmOrOff]];
    

        if (!self.isControlCar) {
            self.imageView.by_centerX = self_H / 2;
            self.imageView.by_centerY = self_H / 2;
        
            CGFloat angle = M_PI * _direction / 180 + 0.0001;//没有角度旋转的时候会出现方向标注位置偏差
            self.imageView.transform = CGAffineTransformMakeRotation(angle);//改变标注角度
        }else{
            self.imageView.by_y = self_H / 2 - self.imageView.image.size.height / 2;
        }
    
        [self.imageView sizeToFit];
        self.label.backgroundColor = [UIColor colorWithHex:BgColors[alarmOrOff]];
        self.label.layer.borderColor = [UIColor colorWithHex:borderColors[alarmOrOff]].CGColor;
    });
}

#pragma mark - lazy
-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.by_x = 0;
    }
    return _imageView;
}
-(UILabel *)label{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        _label.layer.borderWidth = 1;
        _label.layer.cornerRadius = 3;
        _label.clipsToBounds = YES;
        _label.by_y = 0;
        _label.font = BYS_T_F(12);
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        
//        _label.layer.shadowColor = [UIColor redColor].CGColor;//shadowColor阴影颜色
//        _label.layer.shadowOffset = CGSizeMake(2,2);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        _label.layer.shadowOpacity = 0.8;//阴影透明度，默认0
    }
    return _label;
}


@end
