//
//  BYDemolishSuccessController.m
//  BYGPS
//
//  Created by miwer on 2017/2/15.
//  Copyright © 2017年 miwer. All rights reserved.
//

#import "BYDemolishSuccessController.h"
#import "EasyNavigation.h"
#import "BYDeviceListController.h"
@interface BYDemolishSuccessController ()

@end

@implementation BYDemolishSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.navigationView setTitle:@"拆机成功"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationView removeAllLeftButton];
    });
    
//    self.navigationItem.leftBarButtonItem = nil;
}
- (IBAction)continueDemolish:(id)sender {
 
    [self.navigationController popToViewController:self animated:YES];

}


@end
