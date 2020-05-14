//
//  UnitViewController.m
//  HW5
//
//  Created by GZX on 2019/10/29.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnitViewController.h"
#import "QuestionViewController.h"
#import <Masonry.h>

@interface UnitViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)QuestionViewController *questionVC;
@end

@implementation UnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self CreateCol];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(350, 300));
    }];
    [self.view addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.collectionView.mas_top).with.offset(-40);
    }];
    
    self.navigationController.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)CreateCol{
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    layout.itemSize = CGSizeMake(200, 55);
    //创建collectionView 通过一个布局策略layout来创建
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    //注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerClass:[UnitCell class] forCellWithReuseIdentifier:@"cellId"];
    self.collectionView.backgroundColor = [UIColor clearColor];
}


- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setText: @"请选择题目"];
        [_titleLabel setFont: [UIFont systemFontOfSize: 24]];
        [_titleLabel setTextColor: [UIColor blackColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
//返回每个item
- (UnitCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UnitCell *cell = (UnitCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    [cell.title setText: [NSString stringWithFormat:@"Unit %ld",indexPath.section + 1]];
    [cell.title setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    return cell;
}

//每个cell的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);//分别为上、左、下、右
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    //TODO
    _questionVC = [[QuestionViewController alloc]init];
    _questionVC.title = [NSString stringWithFormat:@"Unit%ld",indexPath.section + 1];
    _questionVC.currentUnit = indexPath.section;
    _questionVC.currentQuestion = 0;
    [self.navigationController pushViewController: _questionVC animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    
}


//UICollectionView取消选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UnitCell *cell = (UnitCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 0;
}


//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    return YES ;
}


@end
