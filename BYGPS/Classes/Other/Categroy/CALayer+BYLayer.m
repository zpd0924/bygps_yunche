//
//  CALayer+BYLayer.m
//  carLoanManagerment
//
//  Created by ZPD on 2017/3/23.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "CALayer+BYLayer.h"

@implementation CALayer (BYLayer)

- (void)setBorderColorWithUIColor:(UIColor *)color
{
    
    self.borderColor = color.CGColor;
}


-(void)setBorderUIColor:(UIColor*)color

{
    
    self.borderColor = color.CGColor;
    
}

-(UIColor*)borderUIColor

{
    
    return [UIColor colorWithCGColor:self.borderColor];
    
}

@end
