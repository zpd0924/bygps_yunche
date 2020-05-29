//
//  BYWorkMessageCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/9.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYWorkMessageCell.h"
#import "UILabel+HNVerLab.h"
#import <Masonry.h>
#import "BYSwitchView.h"
#import "BYPickView.h"
#import "BYHotContactPersonModel.h"
#import "UIButton+HNVerBut.h"
#import <ContactsUI/ContactsUI.h>

@interface BYWorkMessageCell()<UITextFieldDelegate,CNContactPickerDelegate>

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *infoLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) BYSwitchView *switchView;
@property (nonatomic,strong) UIImageView *moreImageView;
@property (nonatomic,strong) UIButton *contactBtn;
@property (nonatomic,strong) UIView *spaceView;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *placeArray;
@property (nonatomic,strong) NSMutableArray *hotContactPersonArray;
@property (nonatomic,strong) UIViewController *cf_viewController;
@end
@implementation BYWorkMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self creatUI];
    }
    return self;
}

- (void)setWorkMessageModel:(BYWorkMessageModel *)workMessageModel{
    _workMessageModel = workMessageModel;
    if (_indexPath.section == 0) {
        switch (_indexPath.row) {
            case 0:
                self.rightLabel.text = workMessageModel.sendCompany;
                break;
            case 1:
                self.textField.text = workMessageModel.serverAdress;
                break;
            default:
                self.textField.text = workMessageModel.detailAdress;
                break;
        }
        
    }else{
        
        switch (_indexPath.row) {
            case 0:
                [self.switchView selectIndex:workMessageModel.sendType];
                
                
                break;
            case 1:
                if (workMessageModel.sendType) {
                    self.moreImageView.hidden = YES;
                    self.textField.text = @"系统自动分配技师,不可点击";
                }else{
                    self.textField.text = workMessageModel.serverName;
                }
                break;
            case 2:
            {
                switch (workMessageModel.uninstallReson) {
                    case 1:
                        self.textField.text = @"清货拆机";
                        break;
                    case 2:
                        self.textField.text = @"关联错误";
                        break;
                    case 3:
                        self.textField.text = @"悔货拆机";
                        break;
                    default:
                       
                        break;
                }
                
                [self.switchView selectIndex:[[BYSaveTool valueForKey:BYNeedToAudit] integerValue] == 2 ? !workMessageModel.isCheck : ![[BYSaveTool valueForKey:BYNeedToAudit] integerValue]];
            }
               
                break;
            default:
                self.textField.text = workMessageModel.contacts;
                break;
        }
        
    }
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
   
    if (indexPath.row == 3) {
        self.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
    }else{
        NSString *str = self.titleArray[indexPath.section][indexPath.row];
        if (str.length > 0) {
             self.titleLabel.attributedText = [BYObjectTool setTextColor:self.titleArray[indexPath.section][indexPath.row] FontNumber:[UIFont systemFontOfSize:15] AndRange:NSMakeRange(0, 1) AndColor:BYOrangeColor];
        }
       
    }
    self.textField.placeholder = self.placeArray[indexPath.section][indexPath.row];
    [self cellLayout];
    
}

//派单类型 or 是否需要审核
- (void)switchViewClick:(NSInteger)index{
    BYLog(@"%zd----%zd",index,_indexPath.row);
    if (_indexPath.section == 1) {
        if (_indexPath.row == 0) {
            if (self.messageCellBlock) {
                self.messageCellBlock(sendType, [NSString stringWithFormat:@"%zd",index]);
            }
        }else{
            if (self.messageCellBlock) {
                self.messageCellBlock(checkType, [NSString stringWithFormat:@"%zd",index]);
            }
        }
    }
  
}


- (void)cellLayout{
    if (_indexPath.section == 0) {
        if (_indexPath.row == 2) {
            self.rightLabel.hidden = YES;
            self.textField.hidden = NO;
            if (self.sendOrderType == BYWorkSendOrderType) {
                self.textField.enabled = ![BYSaveTool boolForKey:sameAdd];
            }
            self.switchView.hidden = YES;
            self.moreImageView.hidden = YES;
            self.contactBtn.hidden = YES;
        }else if (_indexPath.row == 1){
            self.rightLabel.hidden = YES;
            self.textField.hidden = NO;
            self.textField.enabled = NO;
            self.switchView.hidden = YES;
            self.moreImageView.hidden = NO;
            self.contactBtn.hidden = YES;
            [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-45);
            }];
        }else{
            self.rightLabel.hidden = NO;
            self.textField.hidden = YES;
            self.switchView.hidden = YES;
            self.moreImageView.hidden = YES;
            self.contactBtn.hidden = YES;
        }
        
    }else{
        switch (_indexPath.row) {
            case 0:
            {
                self.rightLabel.hidden = YES;
                self.textField.hidden = YES;
                self.switchView.hidden = NO;
                self.switchView.enableClick = YES;
                self.switchView.leftBtn.hidden = NO;
                self.switchView.rightBtn.hidden = NO;
                [self.switchView.leftBtn setTitle:@"指派" forState:UIControlStateNormal];
                [self.switchView.rightBtn setTitle:@"抢单" forState:UIControlStateNormal];
                self.moreImageView.hidden = YES;
                self.contactBtn.hidden = YES;
            }
                break;
            case 1:
            {
                self.rightLabel.hidden = YES;
                self.textField.hidden = NO;
                self.switchView.hidden = YES;
                self.moreImageView.hidden = NO;
                self.contactBtn.hidden = YES;
                _textField.text = @"请选择服务技师";
//                _textField.textColor = UIColorHexFromRGB(0x999999);
                _textField.enabled = NO;
                [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-45);
                }];
            }
                break;
            case 2:
            {
                if (_sendOrderType == BYUnpackSendOrderType) {
                    self.rightLabel.hidden = YES;
                    self.textField.hidden = NO;
                    self.switchView.hidden = YES;
                    self.moreImageView.hidden = NO;
                    self.contactBtn.hidden = YES;
                    _textField.text = @"请选择拆机原因";
//                    _textField.textColor = UIColorHexFromRGB(0x999999);
                    _textField.enabled = NO;
                    [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(-45);
                    }];
                }else{
                    self.rightLabel.hidden = YES;
                    self.textField.hidden = YES;
                    self.switchView.hidden = NO;
                    if ([[BYSaveTool valueForKey:BYNeedToAudit] integerValue] == 2) {
                        self.switchView.enableClick = YES;
                        self.switchView.leftBtn.hidden = NO;
                        self.switchView.rightBtn.hidden = NO;
                        [self.switchView.leftBtn setTitle:@"是" forState:UIControlStateNormal];
                        [self.switchView.rightBtn setTitle:@"否" forState:UIControlStateNormal];
                    }else if ([[BYSaveTool valueForKey:BYNeedToAudit] integerValue] == 0){
//                        [self.switchView.leftBtn setTitle:@"是" forState:UIControlStateNormal];
                        self.switchView.leftBtn.hidden = YES;
                        self.switchView.enableClick = NO;
                        [self.switchView.rightBtn setTitle:@"否" forState:UIControlStateNormal];
                    }else{
                        [self.switchView.leftBtn setTitle:@"是" forState:UIControlStateNormal];
//                        [self.switchView.rightBtn setTitle:@"否" forState:UIControlStateNormal];
                        self.switchView.rightBtn.hidden = YES;
                        self.switchView.enableClick = NO;
                    }
                    
                    self.moreImageView.hidden = YES;
                    self.contactBtn.hidden = YES;
                    self.infoLabel.hidden = NO;
                }
                
               
            }
                break;
            default:
            {
                self.rightLabel.hidden = YES;
                self.textField.hidden = NO;
                self.switchView.hidden = YES;
                self.moreImageView.hidden = YES;
                self.contactBtn.hidden = NO;
                [_textField mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(-45);
                }];
            }
                break;
        }
        
    }
}

///手机通讯录
- (void)contactTap{
    
    [BYProgressHUD by_show];
    //让用户给权限,没有的话会被拒的各位
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error) {
                 BYShowError(@"您未开启通讯录权限,请前往设置中心开启");
            }else
            {
                NSLog(@"用户已授权限");
                CNContactPickerViewController * picker = [CNContactPickerViewController new];
                picker.delegate = self;
                // 加载手机号
                picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
                picker.modalPresentationStyle = UIModalPresentationFullScreen;
                [self.cf_viewController presentViewController:picker  animated:YES completion:nil];
            }
        }];
        [BYProgressHUD by_dismiss];
    }
    
    if (status == CNAuthorizationStatusAuthorized) {
        
        //有权限时
        CNContactPickerViewController * picker = [CNContactPickerViewController new];
        if (@available(iOS 11.0, *)) {
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
        }
        picker.navigationController.navigationBar.translucent = NO;
        picker.delegate = self;
        picker.displayedPropertyKeys = @[CNContactPhoneNumbersKey];
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.cf_viewController presentViewController: picker  animated:YES completion:nil];
       
    }
    else{
        NSLog(@"您未开启通讯录权限,请前往设置中心开启");
        BYShowError(@"您未开启通讯录权限,请前往设置中心开启");
//        [BYProgressHUD by_dismiss];
    }

}
///常用联系人
- (void)commonUserContactTap{
    if (!self.hotContactPersonArray.count) {
         [self getHotContactPerson];
    }
   
}
- (void)commonUserContactTap1{
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (BYHotContactPersonModel *model in self.hotContactPersonArray) {
        [arr addObject:[NSString stringWithFormat:@"%@,%@",model.personName,model.telNo]];
    }
    BYPickView * pickView = [[BYPickView alloc] initWithpickViewWith:@"选择联系人" dataSource:arr currentTitle:arr.firstObject];
   
    BYWeakSelf;
    [pickView setSurePickBlock:^(NSString *currentStr) {
        if (self.messageCellBlock) {
            self.messageCellBlock(contactsType,currentStr);
        }
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_indexPath.row == 3) {
        [self commonUserContactTap];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_indexPath.row == 2) {
        if (self.messageCellBlock) {
            self.messageCellBlock(detailAdressType,textField.text);
        }
    }else{
        if (self.messageCellBlock) {
            self.messageCellBlock(contactsType,textField.text);
        }
    }
}

//- (void)textFieldChange:(UITextField *)textField{
//    if (_indexPath.row == 2) {
//        if (self.messageCellBlock) {
//            self.messageCellBlock(detailAdressType,textField.text);
//        }
//    }else{
//        if (self.messageCellBlock) {
//            self.messageCellBlock(contactsType,textField.text);
//        }
//    }
//}

#pragma mark -- 获取常用联系人
- (void)getHotContactPerson{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"groupId"] = [BYSaveTool objectForKey:groupId];
    BYWeakSelf;
    [weakSelf.hotContactPersonArray removeAllObjects];
    [BYSendWorkHttpTool POSTHotContactPersonParams:dict success:^(id data) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.hotContactPersonArray = [[NSArray yy_modelArrayWithClass:[BYHotContactPersonModel class] json:data] mutableCopy];
            if (!weakSelf.hotContactPersonArray.count)
                return ;
            [weakSelf commonUserContactTap1];
        });
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark -- CNContactPickerDelegate
/**
 逻辑:  在该代理方法中会调出手机通讯录界面, 选中联系人的手机号, 会将联系人姓名以及手机号赋值给界面上的TEXT1和TEXT2两个UITextFiled上.
 功能: 调用手机通讯录界面, 获取联系人姓名以及电话号码.
 */
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty {
    [BYProgressHUD by_dismiss];
    CNContact *contact = contactProperty.contact;
    
    NSLog(@"%@",contactProperty);
    NSLog(@"givenName: %@, familyName: %@", contact.givenName, contact.familyName);
    
    if (![contactProperty.value isKindOfClass:[CNPhoneNumber class]]) {
        NSLog(@"提示用户选择11位的手机号");
        return;
    }
    
    CNPhoneNumber *phoneNumber = contactProperty.value;
    NSString * Str = phoneNumber.stringValue;
    NSCharacterSet *setToRemove = [[ NSCharacterSet characterSetWithCharactersInString:@"0123456789"]invertedSet];
    NSString *phoneStr = [[Str componentsSeparatedByCharactersInSet:setToRemove]componentsJoinedByString:@""];
    if (phoneStr.length != 11) {
        
        NSLog(@"提示用户选择11位的手机号");
    }
    
    NSLog(@"phoneStr = %@",phoneStr);
    if (self.messageCellBlock) {
        self.messageCellBlock(contactsType,[NSString stringWithFormat:@"%@%@,%@",contact.familyName.length?contact.familyName:@"",contact.givenName,phoneStr]);
    }
}

- (void)creatUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.infoLabel];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.textField];
    [self.contentView addSubview:self.switchView];
    [self.contentView addSubview:self.moreImageView];
    [self.contentView addSubview:self.contactBtn];
    [self.contentView addSubview:self.spaceView];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(20);
    }];
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom);
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-20);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
        make.left.mas_equalTo(90);
    }];
    [_switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(140, 30));
    }];
    [_moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.mas_equalTo(-20);
    }];
    [_contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.width.height.mas_equalTo(40);
    }];
    [_spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(MAXWIDTH - 20, 0.5));
        make.bottom.trailing.equalTo(self.contentView);
    }];
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel verLab:15 textRgbColor:BYLabelBlackColor textAlighment:NSTextAlignmentLeft];
        _titleLabel.text = @"派单公司";
    }
    return _titleLabel;
}
-(UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [UILabel verLab:11 textRgbColor:UIColorHexFromRGB(0x999999) textAlighment:NSTextAlignmentLeft];
        _infoLabel.hidden = YES;
        _infoLabel.text = @"(是否需要审核技师安装情况)";
    }
    return _infoLabel;
}
-(UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [UILabel verLab:15 textRgbColor:BYLabelBlackColor textAlighment:NSTextAlignmentRight];
        _rightLabel.text = @"一点科技有限公司";
    }
    return _rightLabel;
}
-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        _textField.textColor = BYLabelBlackColor;
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.placeholder = @"请输入详细地址";
//        [_textField setValue:UIColorHexFromRGB(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
//        [_textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
-(UIImageView *)moreImageView
{
    if (!_moreImageView) {
        _moreImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_icon_right"]];
        
    }
    return _moreImageView;
}
-(UIButton *)contactBtn
{
    if (!_contactBtn) {
        _contactBtn = [UIButton verBut:nil textFont:15 titleColor:nil bkgColor:nil];
        [_contactBtn addTarget:self action:@selector(contactTap) forControlEvents:UIControlEventTouchUpInside];
        [_contactBtn setImage:[UIImage imageNamed:@"workOrder_contacts"] forState:UIControlStateNormal];
    }
    return _contactBtn;
}

-(BYSwitchView *)switchView
{
    if (!_switchView) {
        BYWeakSelf;
        _switchView = [[BYSwitchView alloc] initWithItems:@[@"指派",@"抢单"]];
        _switchView.switchViewBlock = ^(NSInteger index) {
            [weakSelf switchViewClick:index];
        };
        _switchView.layer.cornerRadius = 15;
        _switchView.layer.masksToBounds = YES;
        _switchView.layer.borderColor = [UIColor whiteColor].CGColor;
        _switchView.layer.borderWidth = 0.5;
    }
    return _switchView;
}
-(UIView *)spaceView
{
    if (!_spaceView) {
        _spaceView = [[UIView alloc] init];
        _spaceView.backgroundColor = BYsmallSpaceColor;
    }
    return _spaceView;
}

-(NSArray *)titleArray
{
    if (!_titleArray) {
        if (_sendOrderType == BYUnpackSendOrderType) {
             _titleArray = @[@[@"*派单公司",@"*服务地区",@"*详细地址"],@[@"*派单类型",@"*服务技师",@"*拆机原因",@" 联系人"]];
        }else if(_sendOrderType == BYRepairSendOrderType){
            _titleArray = @[@[@"*派单公司",@"*服务地区",@"*详细地址"],@[@"*派单类型",@"*服务技师",@"*是否需要审核",@" 联系人"]];
        }else{
             _titleArray = @[@[@"*派单公司",@"*服务地区",@"*详细地址"],@[@"*派单类型",@"*服务技师",@"*是否需要审核",@" 联系人"]];
        }
       
    }
    return _titleArray;
}
-(NSArray *)placeArray
{
    if (!_placeArray) {
        if(_sendOrderType == BYUnpackSendOrderType){
            _placeArray = @[@[@"",@"请选择服务地区",@"请输入详细地址:如道路/门牌号等"],@[@"",@"请选择服务技师",@"请选择拆机原因",@" 输入格式：姓名，手机号"]];
        }else if(_sendOrderType == BYRepairSendOrderType){
            _placeArray = @[@[@"",@"请选择服务地区",@"请输入详细地址:如道路/门牌号等"],@[@"",@"请选择服务技师",@"",@" 输入格式：姓名，手机号"]];
        }else{
            _placeArray = @[@[@"",@"请选择服务地区",[BYSaveTool boolForKey:sameAdd] ? @"请选择详细地址" : @"请输入详细地址:如道路/门牌号等"],@[@"",@"请选择服务技师",@"",@" 输入格式：姓名，手机号"]];
        }
        
    }
    return _placeArray;
}
-(NSMutableArray *)hotContactPersonArray
{
    if (!_hotContactPersonArray) {
        _hotContactPersonArray = [NSMutableArray array];
    }
    return _hotContactPersonArray;
}
- (UIViewController*)cf_viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController * )nextResponder;
        }
    }
    return nil;
}
@end
