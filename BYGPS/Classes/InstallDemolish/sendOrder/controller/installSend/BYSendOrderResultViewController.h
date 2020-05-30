//
//  BYSendOrderResultViewController.h
//  BYGPS
//
//  Created by 李志军 on 2018/7/10.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^RightBtnOrLeftBtnBlock)(void);

@interface BYSendOrderResultViewController : UIViewController

@property (nonatomic,strong) NSString *titleStr;

@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (nonatomic,copy) RightBtnOrLeftBtnBlock leftBtnBlock;
@property (nonatomic,copy) RightBtnOrLeftBtnBlock rightBtnBlock;

@property (nonatomic,assign) BYResultType resultType;
@property (nonatomic,assign) BYSendOrderType sendOrderType;

@end
