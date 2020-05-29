//
//  BYCarNumSelectController.m
//  父子控制器
//
//  Created by miwer on 2016/12/22.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYCarNumSelectController.h"
#import "BYProvinceCell.h"
#import "BYCityCell.h"
#import "EasyNavigation.h"

@interface BYCarNumSelectController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *provinceTableView;
@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

@property(nonatomic,strong) NSArray * provinceSource;
@property(nonatomic,strong) NSArray * citySource;

@property(nonatomic,strong) NSString * province;
@property(nonatomic,strong) NSString * city;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConsH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConsH1;

@end

@implementation BYCarNumSelectController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    BYStatusBarLight;
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initBase];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)initBase{
   
//    dispatch_async(dispatch_get_main_queue(), ^{
         [self.navigationView setTitle:@"选择车牌"];
//        [self.navigationView removeAllLeftButton];
//        [self.navigationView setNavigationBackgroundColor:BYGlobalBlueColor];
//        self.navigationView.titleLabel.textColor = [UIColor whiteColor];
//        BYWeakSelf;
//        [self.navigationView addLeftButtonWithImage:[UIImage imageNamed:@"icon_arr_left_white"] clickCallBack:^(UIView *view) {
//            [weakSelf backAction];
//        }];
//    });
    self.topConsH.constant = SafeAreaTopHeight;
    self.topConsH1.constant = SafeAreaTopHeight;
    if (@available(iOS 11.0, *)) {
    
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    
    } else {
    
//         Fallback on earlier versions
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.citySource = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J",@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    self.provinceSource = @[@"苏",@"鲁",@"浙",@"川",@"皖",@"豫",@"粤",@"鄂",@"湘",@"吉",@"沪",@"渝",@"云",@"晋",@"蒙",@"贵",@"京",@"陕",@"冀",@"赣",@"辽",@"津",@"桂",@"闽",@"黑",@"新",@"琼",@"甘",@"青",@"宁",@"藏"];
    
    _province = [self.carNum.length>0?self.carNum:@" " substringToIndex:1];
    [self.provinceTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.provinceSource indexOfObject:_province] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    _city = [self.carNum substringFromIndex:1];
    [self.cityTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self.citySource indexOfObject:_city] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
 
    [self.provinceTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYProvinceCell class]) bundle:nil] forCellReuseIdentifier:@"provinceCell"];
    [self.cityTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BYCityCell class]) bundle:nil] forCellReuseIdentifier:@"cityCell"];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == self.provinceTableView) {
        
        BYProvinceCell * provinceCell = [tableView dequeueReusableCellWithIdentifier:@"provinceCell"];
        provinceCell.province = self.provinceSource[indexPath.row];
        return provinceCell;
    }else{
        BYCityCell * cityCell = [tableView dequeueReusableCellWithIdentifier:@"cityCell"];
        cityCell.title = self.citySource[indexPath.row];
        return cityCell;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableView == self.provinceTableView ? self.provinceSource.count : self.citySource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.provinceTableView) {
        _province = self.provinceSource[indexPath.row];
        if (_city.length && _province.length && ![_province isEqualToString:@" "]) {
            if (self.citySelectBlock) {
                self.citySelectBlock([NSString stringWithFormat:@"%@%@",_province,_city]);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        
        _city = self.citySource[indexPath.row];
        if (_city.length && _province.length && ![_province isEqualToString:@" "]) {
            if (self.citySelectBlock) {
                self.citySelectBlock([NSString stringWithFormat:@"%@%@",_province,_city]);
            }
            
            [self.navigationController popViewControllerAnimated:YES];
        }
       
    }
}

@end



