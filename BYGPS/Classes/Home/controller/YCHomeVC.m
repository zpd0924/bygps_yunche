//
//  YCHomeVC.m
//  BYGPS
//
//  Created by 主沛东 on 2019/11/26.
//  Copyright © 2019 miwer. All rights reserved.
//

#import "YCHomeVC.h"
#import "EasyNavigation.h"


@interface YCHomeVC ()

@property (nonatomic,strong) UIImageView *topImgView;

@end

@implementation YCHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationView = [[EasyNavigationView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , self.navigationOrginalHeight)];
    [self.view addSubview:self.navigationView];
    [self.navigationView setTitle:@"云车科技"];
    
}

- (void)setUpUI{
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
