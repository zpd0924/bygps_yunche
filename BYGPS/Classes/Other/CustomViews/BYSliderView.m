//
//  BYSliderView.m
//  播放进度条Demo
//
//  Created by miwer on 16/9/21.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSliderView.h"

@interface BYSliderView ()

@property (weak, nonatomic) IBOutlet UILabel *intervalLabel;

@end

@implementation BYSliderView

+(instancetype)createSliderViewWithPalyOnOff:(void (^)(BOOL isSelect))playOnOffBlock sliderChange:(void (^) (CGFloat value))sliderChangeBlock{
    
    BYSliderView * sliderView = [BYSliderView by_viewFromXib];
    sliderView.frame = CGRectMake(0, SafeAreaTopHeight, [UIScreen mainScreen].bounds.size.width, BYS_W_H(45));

    sliderView.slider.minimumValue = 0;
    
    sliderView.playOnOffBlock = playOnOffBlock;
    sliderView.sliderBlock = sliderChangeBlock;

    return sliderView;
    
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
//    [self.slider setThumbImage:[UIImage imageNamed:@"icon_play"] forState:UIControlStateNormal];
    
}

- (IBAction)playOffAction:(id)sender {
    
    self.playOffButton.selected = !self.playOffButton.selected;
    
    if (self.playOnOffBlock) {
        self.playOnOffBlock(self.playOffButton.selected);
    }
}

- (IBAction)sliderChangeAction:(UISlider *)slider {
    
    if (self.sliderBlock) {
        self.sliderBlock(slider.value);
    }
}

-(void)setRunDuration:(NSInteger)runDuration{
    
    NSInteger min = runDuration / 60;
    NSInteger second = runDuration % 60;
    self.intervalLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",min,second];
}


@end





