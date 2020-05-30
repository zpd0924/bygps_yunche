//
//  BYSliderView.h
//  播放进度条Demo
//
//  Created by miwer on 16/9/21.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYSliderView : UIView

@property(nonatomic,copy)void (^playOnOffBlock) (BOOL isSelect);//开始与暂停block

@property(nonatomic,copy)void (^sliderBlock) (CGFloat value);//

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UIButton *playOffButton;

@property(nonatomic,assign) NSInteger runDuration;

+(instancetype)createSliderViewWithPalyOnOff:(void (^)(BOOL isSelect))playOnOffBlock sliderChange:(void (^) (CGFloat value))sliderChangeBlock;

@end
