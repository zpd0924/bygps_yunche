//
//  BYBlankView.h
//  BYGPS
//
//  Created by miwer on 2017/2/20.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYBlankView : UIView

@property(nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * imgName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *distanceContraint;

@end
