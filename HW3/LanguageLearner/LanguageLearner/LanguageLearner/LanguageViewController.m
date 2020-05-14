//
//  LanguageViewController.m
//  LanguageLearner
//
//  Created by GZX on 2019/9/27.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanguageViewController.h"
#import "LanguageCell.h"
#import "TarBarController.h"
#import <Masonry.h>

@interface LanguageViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)TarBarController* en;
@property (strong, nonatomic)TarBarController* ge;
@property (strong, nonatomic)TarBarController* jp;
@property (strong, nonatomic)TarBarController* sp;
@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self CreateCol];
    [self CreateBar];
    self.title = @"选择语言";
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.titleLabel];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(250, 350));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.collectionView.mas_top).with.offset(-20);
    }];
    
    self.navigationController.delegate = self;
}


-(void)CreateCol{
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小为100*100
    layout.itemSize = CGSizeMake(105, 100);
    //创建collectionView 通过一个布局策略layout来创建
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    //注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerClass:[LanguageCell class] forCellWithReuseIdentifier:@"cellId"];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

-(void)CreateBar{
    _en = [[TarBarController alloc]init];
    _en.navigationItem.title = @"学习英语";
    _en.lanTitle = _en.navigationItem.title;
    _ge = [[TarBarController alloc]init];
    _ge.navigationItem.title = @"学习德语";
    _ge.lanTitle = _ge.navigationItem.title;
    _jp = [[TarBarController alloc]init];
    _jp.navigationItem.title = @"学习日语";
    _jp.lanTitle = _jp.navigationItem.title;
    _sp = [[TarBarController alloc]init];
    _sp.navigationItem.title = @"学习西班牙语";
    _sp.lanTitle = _sp.navigationItem.title;
}



- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setText: @"请选择语言"];
        [_titleLabel setFont: [UIFont systemFontOfSize: 24]];
        [_titleLabel setTextColor: [UIColor blackColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
//返回每个item
int num = 0;
- (LanguageCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LanguageCell *cell = (LanguageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    switch (num) {
        case 0:
            [cell.image setImage:[UIImage imageNamed:@"English.png"]];
            [cell.title setText: @"英语"];
            break;
        case 1:
            [cell.image setImage:[UIImage imageNamed:@"German.png"]];
            [cell.title setText: @"德语"];
            break;
        case 2:
            [cell.image setImage:[UIImage imageNamed:@"Japanese.png"]];
            [cell.title setText: @"日语"];
            break;
        case 3:
            [cell.image setImage:[UIImage imageNamed:@"Spanish.png"]];
            [cell.title setText: @"西班牙语"];
            break;
    }
    [cell.title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    num ++;
    return cell;
}


-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(25, 0, 25, 0);//分别为上、左、下、右
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    //TODO
    //TarBarController* temp = [[TarBarController alloc]init];
    self.navigationController.navigationBar.translucent = NO;
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            [self.navigationController pushViewController: _en animated:YES];
        }
        else{
            [self.navigationController pushViewController: _ge animated:YES];
        }
    }
    else{
        if(indexPath.row == 0){
            [self.navigationController pushViewController: _jp animated:YES];
        }
        else{
            [self.navigationController pushViewController: _sp animated:YES];
        }
    }
}

//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    return YES ;
}

@end
