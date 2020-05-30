//
//  BYAboutFooterView.m
//  BYGPS
//
//  Created by ZPD on 2017/7/20.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYAboutFooterView.h"
#import "CopyLabel.h"


@interface BYAboutFooterView ()
@property (weak, nonatomic) IBOutlet UIButton *WXShareButton;
@property (weak, nonatomic) IBOutlet UIImageView *wxImgView;
@property (weak, nonatomic) IBOutlet CopyLabel *wxLabel;

@property (nonatomic , strong) UIImageView *wxImgView1;


@end

@implementation BYAboutFooterView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if (![BYSaveTool boolForKey:BYWXIsStall]) {
        self.WXShareButton.hidden = YES;
    }
    
    self.wxImgView1 = [[UIImageView alloc] initWithFrame:CGRectMake((BYSCREEN_W -  BYSCREEN_W / 3) / 2, 110, BYSCREEN_W / 3, BYSCREEN_W / 3)];
    self.wxImgView1.image = [UIImage imageNamed:@"Official Accounts"];
    [self addSubview:self.wxImgView1];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress)];
    self.wxImgView1.userInteractionEnabled = YES;
    [self.wxImgView1 addGestureRecognizer:longTap];
    
    
    CopyLabel *label = [[CopyLabel alloc] initWithFrame:CGRectMake(0, 110 + BYSCREEN_W / 3 + 15, BYSCREEN_W, 25)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = UIColorHexFromRGB(0x323232);
    label.text = @"搜索微信公众号：标越科技";
    [self addSubview:label];
//    label = (CopyLabel *)self.wxLabel;
    
}

// 长按事件
- (void)longPress {
    UIPasteboard * paste = [UIPasteboard generalPasteboard];
    paste.string = @"标越科技";
    BYShowSuccess(@"已经复制标越科技");

}

- (IBAction)shareWXClick:(id)sender {
    MobClickEvent(@"about_share", @"");
    if (self.shareToWXBlock) {
        self.shareToWXBlock();
    }
}
- (IBAction)phoneCallClick:(id)sender {
    MobClickEvent(@"about_phone", @"");
    if (self.phoneBlock) {
        self.phoneBlock();
    }
}

@end
