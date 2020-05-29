//
//  BYReplayMAAnnotationView.m
//  BYGPS
//
//  Created by ZPD on 2017/10/24.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYReplayMAAnnotationView.h"
#import "BYReplayPopView.h"
#import "BYReplayStartPopView.h"
#import "BYParkPopView.h"
#import "BYReplayModel.h"
#import "BYParkEventModel.h"

@interface BYReplayMAAnnotationView ()

//@property (nonatomic,strong) BYReplayModel * model;

@property (nonatomic,strong) UIView * callOutView;

@end

@implementation BYReplayMAAnnotationView

-(id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        
        self.imgView = [[UIImageView alloc] init];
        [self addSubview:self.imgView];
        
    }
    return self;
}

-(void)setIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            self.startPopView.name = @"历史轨迹开始";
            self.startPopView.address = self.address;
            self.startPopView.startModel = self.replayModel;
            self.startPopView.by_height = self.replayModel.pop_H;
            self.startPopView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x , -CGRectGetHeight(self.startPopView.bounds) / 2.f + self.calloutOffset.y);
            self.callOutView = self.startPopView;
            //start
            break;
            
        case 1:
            
            self.replayPopView.model = self.replayModel;
//            self.replayPopView.by_height = self.replayModel.pop_H;
            self.replayPopView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x , -CGRectGetHeight(self.replayPopView.bounds) / 2.f + self.calloutOffset.y);
            self.callOutView = self.replayPopView;
            //move
            break;
            
        case 2:
            self.startPopView.name = @"历史轨迹结束";
            
            self.startPopView.address = self.address;
            self.startPopView.startModel = self.replayModel;
            self.startPopView.by_height = self.replayModel.pop_H;
            self.startPopView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x , -CGRectGetHeight(self.startPopView.bounds) / 2.f + self.calloutOffset.y);
            self.callOutView = self.startPopView;
            //end
            break;
            
        default:
            
            self.parkPopView.parkModel = self.parkModel;
            self.parkPopView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x , -CGRectGetHeight(self.parkPopView.bounds) / 2.f + self.calloutOffset.y);
//            self.parkPopView.by_height = self.parkModel.pop_H;
            self.callOutView = self.parkPopView;
            //park
            break;
    }
}

//-(void)setReplayModel:(BYReplayModel *)replayModel
//{
//    self.replayPopView.model = replayModel;
//    self.replayPopView.by_height = replayModel.pop_H;
//}

//-(void)setParkModel:(BYParkEventModel *)parkModel
//{
//    self.parkPopView.parkModel = parkModel;
//    self.parkPopView.by_height = parkModel.pop_H;
//}


-(void)setImageStr:(NSString *)imageStr{
    
    _imageStr = imageStr;
    UIImage * image = [UIImage imageNamed:_imageStr];
    [self setBounds:CGRectMake(0, 0, image.size.width, image.size.height)];
    self.imgView.frame = self.bounds;
    self.imgView.image = image;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected) {
        return;
    }
    
    if (selected) {
        [self addSubview:self.callOutView];
    }
    else
    {
        [self.callOutView removeFromSuperview];
    }
    [super setSelected:selected animated:animated];
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
        inside = [self.callOutView pointInside:[self convertPoint:point toView:self.callOutView] withEvent:event];
    }
    
    return inside;
}

-(BYReplayStartPopView *)startPopView
{
    if (!_startPopView) {
        _startPopView = [BYReplayStartPopView by_viewFromXib];
        _startPopView.by_width = 250;
    }
    return _startPopView;
}

-(BYReplayPopView *)replayPopView
{
    if (!_replayPopView) {
        _replayPopView = [BYReplayPopView by_viewFromXib];
        _replayPopView.by_height = BYS_W_H(130);
        _replayPopView.by_width = BYS_W_H(227);
    }
    return _replayPopView;
}

-(BYParkPopView *)parkPopView
{
    if (!_parkPopView) {
        _parkPopView = [BYParkPopView by_viewFromXib];
        _parkPopView.by_width = BYS_W_H(257);
    }
    return _parkPopView;
}

@end
