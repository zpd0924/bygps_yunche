//
//  BYSelectDeviceDemolishCell.m
//  父子控制器
//
//  Created by miwer on 2016/12/28.
//  Copyright © 2016年 miwer. All rights reserved.
//

#import "BYSelectDeviceCell.h"
#import "BYAppointmentDeviceModel.h"
#import "BYDemolishDeviceModel.h"
#import "UIImageView+WebCache.h"
#import "SDPhotoBrowser.h"
#import "UILabel+BYCaculateHeight.h"
#import "BYNoHandleCollectionCell.h"

@interface BYSelectDeviceCell () <SDPhotoBrowserDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong) UIView *imgBgView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *installPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *installMarkLabel;
@property (weak, nonatomic) IBOutlet UIView *imageLabelBgView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLabelContraint_H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBgViewContraint_H;

@end

@implementation BYSelectDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setUpViewBase];
}

-(void)setUpViewBase{
    self.collectionHeightConstraint.constant = BYS_W_H(107);
    [self.photoCollectionView registerNib:[UINib nibWithNibName:@"BYNoHandleCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"BYNoHandleCollectionCell"];
    self.imgBgView = self.photoCollectionView;
}

-(void)setMarkBgV_H:(CGFloat)markBgV_H{
}

- (IBAction)selectDevice:(UIButton *)sender {
    
    self.selectButton.selected = !sender.selected;

    if (self.selectDeviceBlock) {
        self.selectDeviceBlock(self.selectButton.selected);
    }
}

-(void)setIsHidenImageBgView:(BOOL)isHidenImageBgView{

    self.imageLabelBgView.hidden = isHidenImageBgView;
}

-(void)setAppointmentModel:(BYAppointmentDeviceModel *)appointmentModel{
    
    self.selectButton.selected = appointmentModel.isSelect;
    NSString * wirelessStr = appointmentModel.wifi ? @"无线" : @"有线";
    [self.selectButton setTitle:[NSString stringWithFormat:@"%@(%@ %@)",appointmentModel.sn,appointmentModel.model,wirelessStr] forState:UIControlStateNormal];
}

-(void)setDemolishModel:(BYDemolishDeviceModel *)demolishModel{
    _demolishModel = demolishModel;
    
    //根据备注长度来计算备注高度
    
    CGFloat remark_H = [UILabel caculateLabel_HWith:BYSCREEN_W - 60 Title:[NSString stringWithFormat:@"安装备注: %@",demolishModel.remark.length > 0 ? demolishModel.remark : @""] font:BYS_W_H(11)];
    demolishModel.mark_H = 17 + BYS_W_H(11) + remark_H;
    self.bottomLabelContraint_H.constant = demolishModel.mark_H;
    self.selectButton.selected = demolishModel.isSelect;
    NSString * wirelessStr = demolishModel.wifi ? @"无线" : @"有线";
    [self.selectButton setTitle:[NSString stringWithFormat:@"%@(%@ %@)",demolishModel.sn,demolishModel.model,wirelessStr] forState:UIControlStateNormal];
    
    self.installPositionLabel.text = [NSString stringWithFormat:@"安装位置: %@",demolishModel.installPosition];
    self.installMarkLabel.text = [NSString stringWithFormat:@"安装备注: %@",demolishModel.remark.length > 0 ? demolishModel.remark : @""];
    
}

-(void)setImgArr:(NSMutableArray *)imgArr{
    _imgArr = imgArr;
    if (imgArr.count > 2) {
        self.collectionHeightConstraint.constant = BYS_W_H(107) * 2 + BYS_W_H(5);
    }
    [self.photoCollectionView reloadData];
}

//有多少个item
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imgArr.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BYNoHandleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BYNoHandleCollectionCell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[BYSaveTool valueForKey:baseImageUrl],self.imgArr[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"loading_pic"]];
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //大图浏览
    SDPhotoBrowser * photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.row;
    photoBrowser.imageCount = self.imgArr.count;
    photoBrowser.sourceImagesContainerView = self.imgBgView;
    [photoBrowser show];
    BYLog(@"img == %zd",indexPath.row);
}

#pragma mark - photobrowser代理方法


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",[BYSaveTool valueForKey:baseImageUrl],self.imgArr[index]]];
}




//UICollectionViewCell的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(BYS_W_H(100), BYS_W_H(107));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return BYS_W_H(7.5);
}

-(UIView *)imageBgView{
    if (_imgBgView == nil) {
        _imgBgView = [[UIView alloc] init];
    }
    return _imgBgView;
}


@end

