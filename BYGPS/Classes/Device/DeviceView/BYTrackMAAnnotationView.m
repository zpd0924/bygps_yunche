//
//  BYTrackMAAnnotationView.m
//  BYGPS
//
//  Created by ZPD on 2017/10/19.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYTrackMAAnnotationView.h"
#import "BYTrackPopView.h"
#import "BYTrackModel.h"

#define self_H BYS_W_H(23)//标注的高度
@interface BYTrackMAAnnotationView()

@property(nonatomic,strong) UIImageView * carImageView;
@property(nonatomic,strong) UILabel * label;

@end

@implementation BYTrackMAAnnotationView

-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.userInteractionEnabled = YES;
    self.bounds = CGRectMake(0.f, 0.f, 200, 23);
    
    //    self.backgroundColor = [UIColor grayColor];
    
    /* Create portrait image view and add to view hierarchy. */
    self.carImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 23)];
    [self addSubview:self.carImageView];
    
    /* Create name label. */
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(23 + 5,
                                                           0,
                                                           200 -23 -5,
                                                           23)];
    self.label.layer.borderWidth = 1;
    self.label.layer.cornerRadius = 3;
    self.label.clipsToBounds = YES;
    self.label.by_y = 0;
    self.label.font = BYS_T_F(12);
    self.label.textColor = [UIColor whiteColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    
    
    //    //    self.backgroundColor = [UIColor whiteColor];
    //
    //    self.imageView.frame = CGRectMake(0, 0, 20, 20);
    ////    self.imageView.by_width = 20;
    ////    self.imageView.by_height = 20;
    //    [self addSubview:self.imageView];
    //
    //    [self addSubview:self.label];
}

-(void)setIsControlCar:(BOOL)isControlCar{
    _isControlCar = isControlCar;
}

-(void)setDirection:(NSInteger)direction{
    
    _direction = direction == 0 ? 360 : direction;
}

-(void)setCarNum:(NSString *)carNum{
    
    CGSize size = [carNum sizeWithAttributes: @{NSFontAttributeName: BYS_T_F(12)}];
    self.bounds = CGRectMake(0, 0, size.width + 45, self_H);
    self.label.text = carNum;
    //    self.label.by_x = CGRectGetMaxX(self.imageView.frame) + 5;
    self.label.by_x = BYS_W_H(20) + 5;
    self.label.by_width = size.width + 20;
    self.label.by_height = self_H;
}

-(void)setAlarmOrOff:(NSInteger)alarmOrOff{
    
    //"alarmOrOff":0在线  1离线  2报警  3启动怠速  4启动行驶  5熄火在线
    NSArray * imageNames = [NSArray array];
    imageNames = _isControlCar ? @[@"car_gray",@"car_gray",@"car_orange",@"car_blue",@"car_green",@"car_red",@"car_gray"] : @[@"arr_gray",@"arr_gray",@"arr_orange",@"arr_blue",@"arr_green",@"arr_red",@"arr_gray"];
    
    NSArray * BgColors = @[@"#929292",@"#929292",@"#f6ae00",@"#3385ff",@"#45be37",@"#ff543e",@"#929292"];
    NSArray * borderColors = @[@"#797979",@"#797979",@"#ce9202",@"#1d72f0",@"#1f9d07",@"#e12e17",@"#797979"];
    
    self.carImageView.image = [UIImage imageNamed:imageNames[alarmOrOff]];
    
    if (!_isControlCar) {
        self.carImageView.by_centerX = self_H / 2;
        self.carImageView.by_centerY = self_H / 2;
        
        CGFloat angle = M_PI * _direction / 180 + 0.0001;//没有角度旋转的时候会出现方向标注位置偏差
        self.carImageView.transform = CGAffineTransformMakeRotation(angle);//改变标注角度
    }else{
        self.carImageView.by_y = self_H / 2 - self.carImageView.image.size.height / 2;
    }
    
    //    [self.imageView sizeToFit];
    
    self.label.backgroundColor = [UIColor colorWithHex:BgColors[alarmOrOff]];
    self.label.layer.borderColor = [UIColor colorWithHex:borderColors[alarmOrOff]].CGColor;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected) {
        return;
    }
    
    if (selected) {
        [self addSubview:self.trackPopView];
    }
    else
    {
        [self.trackPopView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
}

-(void)setAddress:(NSString *)address
{
    self.trackPopView.address = address;
}
-(void)setTrackModel:(BYTrackModel *)trackModel
{
    self.trackPopView.model = trackModel;
    self.trackPopView.by_height = trackModel.pop_H;
    self.trackPopView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x , -CGRectGetHeight(self.trackPopView.bounds) / 2.f + self.calloutOffset.y - 5);
}

-(void)setDistance:(CGFloat)distance
{
    self.trackPopView.distance = distance;
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.trackPopView pointInside:[self convertPoint:point toView:self.trackPopView] withEvent:event];
    }
    
    return inside;
}


-(BYTrackPopView *)trackPopView
{
    if (!_trackPopView) {
        _trackPopView = [BYTrackPopView by_viewFromXib];
        _trackPopView.by_width = BYS_W_H(245);
        BYWeakSelf;
        [_trackPopView setGotoBaiduMapBlock:^{
            if (weakSelf.popGotoBaiduMapBlock) {
                weakSelf.popGotoBaiduMapBlock();
            }
        }];
        [_trackPopView setDismissBlcok:^{
            if (weakSelf.popDismissBlcok) {
                weakSelf.popDismissBlcok();
            }
        }];
        
//        [_trackPopView setSponsorPhotoBlock:^(NSString *address) {
//            if (weakSelf.popSponsorPhotoBlock) {
//                weakSelf.popSponsorPhotoBlock(address);
//            }
//        }];
    }
    return _trackPopView;
}


@end
