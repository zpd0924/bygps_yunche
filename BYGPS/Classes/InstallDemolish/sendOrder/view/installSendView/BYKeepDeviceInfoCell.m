//
//  BYKeepDeviceInfoCell.m
//  BYGPS
//
//  Created by 李志军 on 2018/7/17.
//  Copyright © 2018年 miwer. All rights reserved.
//

#import "BYKeepDeviceInfoCell.h"
#import "BYKeepDeviceInfoStatusCell.h"
#import <Masonry.h>
#import "BYKeepDeviceInfoStatusModel.h"

#define margin 10
#define imageW (BYSCREEN_W - 120 - 3*margin) / 4
#define imageH 25
@interface BYKeepDeviceInfoCell()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *countView;

@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic,strong) UICollectionView *colloctionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSMutableArray *dataSource;


@property (weak, nonatomic) IBOutlet UILabel *wifiOrWiredDeviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *devieceTypeLabel;

@property (weak, nonatomic) IBOutlet UITextView *textView;


@end
@implementation BYKeepDeviceInfoCell
- (IBAction)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
     _model.isSelect = sender.selected;
    if (self.keepDeviceInfoBlock) {
        self.keepDeviceInfoBlock(_model);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectBtn.selected = YES;
    self.countView.backgroundColor = [UIColor clearColor];
    [self.countView addSubview:self.colloctionView];
    [_colloctionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.leading.equalTo(self.countView);
    }];
    self.heightCons.constant = 70;
    self.textView.delegate = self;
   
}

- (void)setModel:(BYDeviceModel *)model{
    _model = model;
    switch (model.deviceType) {
        case 0:
            self.wifiOrWiredDeviceLabel.text = @"有线设备";
            self.devieceTypeLabel.hidden = NO;
            break;
        case 1:
            self.wifiOrWiredDeviceLabel.text = @"无线设备";
            self.devieceTypeLabel.hidden = NO;
            break;
        default:
            self.wifiOrWiredDeviceLabel.text = @"其他设备";
            self.devieceTypeLabel.hidden = YES;
            break;
    }
    if (model.deviceType == 3) {
        self.devieceTypeLabel.hidden = YES;
       
    }else{
        if (!model.deviceId) {
           self.devieceTypeLabel.hidden = YES;
        }else{
            self.devieceTypeLabel.hidden = NO;
        }
    }
    self.deviceStatusLabel.text = model.deviceProvider;
    self.deviceNumberLabel.text = model.deviceSn;
    if (model.isSelect) {
        self.selectBtn.selected = YES;
    }else{
        self.selectBtn.selected = NO;
    }
    //1=离线,2=在线不定位,3=在线行驶,4=在线静止,5=报警
    switch (model.status) {
        case 1:
            self.devieceTypeLabel.text = [NSString stringWithFormat:@"%@%zd天",@"离线",model.days];
            self.devieceTypeLabel.textColor = UIColorHexFromRGB(0xa3a3a3);
            break;
        case 2:
            self.devieceTypeLabel.text = @"在线不定位";
            self.devieceTypeLabel.textColor = UIColorHexFromRGB(0xff8040);
            break;
        case 3:
            self.devieceTypeLabel.text = @"在线行驶";
            self.devieceTypeLabel.textColor = UIColorHexFromRGB(0x11ac0d);
            break;
        case 4:
            self.devieceTypeLabel.text = @"在线静止";
            self.devieceTypeLabel.textColor = UIColorHexFromRGB(0x1533cf);
            break;
        default:
            self.devieceTypeLabel.text = @"报警";
            self.devieceTypeLabel.textColor = UIColorHexFromRGB(0xff0101);
            break;
    }
//    if (model.resonDetail.length)
    self.textView.text = model.resonDetail.length <= 0 ? @"请输入详细描述" : model.resonDetail;
    if ([self.textView.text isEqualToString:@"请输入详细描述"]) {
        self.textView.textColor = UIColorHexFromRGB(0x999999);
    }else{
        self.textView.textColor = UIColorHexFromRGB(0x333333);
    }
    [self initBaseData];
}



- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length<1) {
        
        textView.text = @"请输入详细描述";
        self.textView.textColor = UIColorHexFromRGB(0x999999);
    }
    
    if (![textView.text isEqualToString:@"请输入详细描述"] && textView.text.length) {
        
    }
    _model.resonDetail = textView.text;
    if (self.keepDeviceInfoBlock) {
        self.keepDeviceInfoBlock(_model);
    }
}


- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"请输入详细描述"]) {
        
        textView.text = @"";
        self.textView.textColor = UIColorHexFromRGB(0x333333);
    }
}
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 50) {
        BYShowError(@"最多可输入50个字符");
         textView.text = [textView.text substringToIndex:50];
        return;
    }
}

- (void)initBaseData{
    [self.dataSource removeAllObjects];
    for (int i = 0; i<self.titleArray.count; i++) {
        BYKeepDeviceInfoStatusModel *model = [[BYKeepDeviceInfoStatusModel alloc] init];
        model.resonStr = self.titleArray[i];
        if (_model.serviceReson == i+1) {
             model.isSelect = YES;
        }else{
             model.isSelect = NO;
        }
       
        [self.dataSource addObject:model];
    }
    [self.colloctionView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BYKeepDeviceInfoStatusCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BYKeepDeviceInfoStatusCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = self.dataSource[indexPath.item];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
   
    BYKeepDeviceInfoStatusModel *model = self.dataSource[indexPath.item];
    CGSize size =[model.resonStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    
    return CGSizeMake(size.width+10, 30.f);
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     BYKeepDeviceInfoStatusModel *model = self.dataSource[indexPath.item];
    for (BYKeepDeviceInfoStatusModel *model in self.dataSource) {
        model.isSelect = NO;
    }
    model.isSelect = YES;
    _model.serviceReson = indexPath.item + 1;
    if (self.keepDeviceInfoBlock) {
        self.keepDeviceInfoBlock(_model);
    }
    [self.colloctionView reloadData];
}

-(UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        // 0.创建layout对象
        _layout = [[UICollectionViewFlowLayout alloc] init];
        
        // 设置cell的尺寸
//        _layout.itemSize = CGSizeMake(imageW, imageH);

//        _layout.minimumInteritemSpacing = 9;
//        _layout.minimumLineSpacing = margin;
//        // 设置整个collectionView的边距
//        _layout.sectionInset = UIEdgeInsetsMake(2, 2, 2, 2);
        // 设置滚动方向
            _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return _layout;
}
-(UICollectionView *)colloctionView
{
    if (!_colloctionView) {
        _colloctionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _colloctionView.backgroundColor = [UIColor clearColor];
        
        
        // 设置UICollectionView属性
        _colloctionView.bounces = YES;
        _colloctionView.showsVerticalScrollIndicator = NO;
        _colloctionView.showsHorizontalScrollIndicator = NO;
        
        // 2.设置数据源
        _colloctionView.dataSource = self;
        _colloctionView.delegate = self;
         [_colloctionView registerNib:[UINib nibWithNibName:NSStringFromClass([BYKeepDeviceInfoStatusCell class]) bundle:nil] forCellWithReuseIdentifier:@"BYKeepDeviceInfoStatusCell"];
    }
    return _colloctionView;
}


-(NSArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = @[@"设备不上线",@"设备不定位",@"设备没电",@"其他"];
    }
    return _titleArray;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
