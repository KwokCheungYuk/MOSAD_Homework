//
//  FinishingViewController.m
//  HW5
//
//  Created by GZX on 2019/10/30.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FinishingViewController.h"
#import <Masonry.h>

@interface FinishingViewController()
@property (strong, nonatomic)UIButton *backBtn;
@property (strong, nonatomic)UILabel *correctTxt;
@property (strong, nonatomic)UILabel *displayNum;
@property (strong, nonatomic) UIImageView *NO1;
@property (strong, nonatomic) UIImageView *NO2;
@property (strong, nonatomic) UIImageView *NO3;
@property (strong, nonatomic) UIImageView *NO4;
@property (strong, nonatomic) NSMutableArray *Stars;
@property int correctNum;
@end

@implementation FinishingViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    _Stars = [[NSMutableArray alloc]initWithCapacity:4];
    _correctNum = 0;
    //初始化按钮
    [self CreateBtn];
    
    //创建Stars
    [self CreateStars];
    
    //创建文字
    [self CreateTxt];
    
    //动画开始
    [self BeginAnimation];
}

-(void)CreateBtn{
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 285, 45)];
    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn.layer setMasksToBounds:YES];
    [_backBtn.layer setCornerRadius:15];
    [_backBtn setBackgroundColor:[UIColor colorWithRed:103.0/255.0 green:200.0/255.0 blue:90.0/255.0 alpha:1.0]];
    [_backBtn addTarget:self action:@selector(Back) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(285, 45));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-40);
    }];
}

-(void)Back{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)CreateStars{
    _NO1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Star0.png"]];
    [self.view addSubview:_NO1];
    [_NO1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(self.view);
        make.left.equalTo(self.view).offset(65);
    }];
    [_Stars addObject:_NO1];
    _NO2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Star0.png"]];
    [self.view addSubview:_NO2];
    [_NO2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(self.view);
        make.left.equalTo(_NO1.mas_right).offset(15);
    }];
    [_Stars addObject:_NO2];
    _NO3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Star0.png"]];
    [self.view addSubview:_NO3];
    [_NO3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(self.view);
        make.left.equalTo(_NO2.mas_right).offset(15);
    }];
    [_Stars addObject:_NO3];
    _NO4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Star0.png"]];
    [self.view addSubview:_NO4];
    [_NO4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.equalTo(self.view);
        make.left.equalTo(_NO3.mas_right).offset(15);
    }];
    [_Stars addObject:_NO4];
}

-(void)CreateTxt{
    _displayNum = [[UILabel alloc]init];
    [_displayNum setText: [NSString stringWithFormat:@"%d", _correctNum]];
    [_displayNum setFont: [UIFont systemFontOfSize: 56]];
    [_displayNum setTextColor: [UIColor blackColor]];
    [_displayNum setTextAlignment:NSTextAlignmentCenter];
    [_displayNum setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.view addSubview:_displayNum];
    [_displayNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(_NO1.mas_top).offset(-50);
    }];
    
    _correctTxt = [[UILabel alloc]init];
    [_correctTxt setText: @"正确数"];
    [_correctTxt setFont: [UIFont systemFontOfSize: 32]];
    [_correctTxt setTextColor: [UIColor blackColor]];
    [_correctTxt setTextAlignment:NSTextAlignmentCenter];
    [_correctTxt setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.view addSubview:_correctTxt];
    [_correctTxt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(_displayNum.mas_top).offset(-20);
    }];
}

-(void)BeginAnimation{
    for(int i = 0; i < [_Stars count]; i ++){
        [UIView animateKeyframesWithDuration:1 delay:0.5 +i options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.5 animations: ^{
                // key frame 0
                ((UIImageView*)self->_Stars[i]).transform = CGAffineTransformMakeScale(2, 2);
            }];
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.5 animations: ^{
                // key frame 1
                ((UIImageView*)self->_Stars[i]).transform = CGAffineTransformMakeScale(1, 1);
            }];
        } completion:^(BOOL finished) {
            if( [self->_totalRight[i] isEqual:@"right"]){
                [(UIImageView*)self->_Stars[i] setImage:[UIImage imageNamed:@"Star1.png"]];
                self->_correctNum ++;
                [self->_displayNum setText:[NSString stringWithFormat:@"%d", self->_correctNum]];
            }
        }];
    }
}
@end

