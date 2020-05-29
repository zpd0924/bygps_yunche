//
//  BYInstallDeviceCheckBottomView.m
//  BYGPS
//
//  Created by 李志军 on 2018/9/7.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYInstallDeviceCheckBottomView.h"

@implementation BYInstallDeviceCheckBottomView
- (IBAction)addBtnClick:(UIButton *)sender {
    if (self.addBlock) {
        self.addBlock();
    }
}

- (IBAction)nextBtnClick:(UIButton *)sender {
    if (self.nextBlock) {
        self.nextBlock();
    }
}
- (IBAction)phoneBtnClick:(UIButton *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWebView * callWebview = [[UIWebView alloc]init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:075536567158"]]];
        
        [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
    });
}
- (void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    if (self.dataSource.count == 0) {
        self.installCountLabel.text = @"请添加设备";
        self.installCheckLabel.hidden = YES;
        self.phoneBtn.hidden = YES;
        
    }else{
        self.installCheckLabel.hidden = NO;
        self.phoneBtn.hidden = NO;
    }
}
- (void)setIsFit:(BOOL)isFit{
    _isFit = isFit;
    dispatch_async(dispatch_get_main_queue(), ^{
        BYInstallDeviceCheckModel *model = self.dataSource.firstObject;
       
        if (isFit) {
            if (self.dataSource.count == 0) {
                self.installCountLabel.text = @"请添加设备";
                
            }else{
                self.installCountLabel.text = [NSString stringWithFormat:@"本次要安装的%zd台设备在%@",self.dataSource.count,model.group];
                self.installCountLabel.attributedText = [BYObjectTool changeStrWittContext:self.installCountLabel.text ChangeColorText:[NSString stringWithFormat:@"%zd",self.dataSource.count] ChangeColorText:model.group WithColor:BYGlobalBlueColor WithFont:[UIFont systemFontOfSize:19]];
                self.installCheckLabel.text = @"请先联系客服进行核对";
                [self.phoneBtn setTitle:@"0755-36567158" forState:UIControlStateNormal];
                self.nextBtn.enabled = YES;
                [self.nextBtn setBackgroundColor:BYGlobalBlueColor];
            }
           
        }else{
            if (self.dataSource.count == 0) {
                self.installCountLabel.text = @"请添加设备";
                
            }else{
                self.installCountLabel.text = [NSString stringWithFormat:@"本次要安装的%zd台设备所在分组不一致",self.dataSource.count];
                self.installCountLabel.attributedText = [BYObjectTool changeStrWittContext:[NSString stringWithFormat:@"本次要安装的%zd台设备所在分组不一致",self.dataSource.count] ChangeColorText:[NSString stringWithFormat:@"%zd",self.dataSource.count] WithColor:BYGlobalBlueColor WithFont:[UIFont systemFontOfSize:20]];
            }
           
            self.installCheckLabel.text = @"请先联系客服进行核对";
            [self.phoneBtn setTitle:@"0755-36567158" forState:UIControlStateNormal];
            self.nextBtn.enabled = NO;
            [self.nextBtn setBackgroundColor:UIColorHexFromRGB(0x7d7d7d)];
        }
    });
   
}

@end
