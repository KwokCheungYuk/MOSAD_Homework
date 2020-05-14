//
//  UserViewController.m
//  LanguageLearner
//
//  Created by GZX on 2019/9/28.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserViewController.h"
#import "NavigationController.h"
#import "ProfileViewController.h"
#import "SettingViewController.h"
#import <Masonry.h>

@interface UserViewController()
@property (strong, nonatomic) UISegmentedControl* SC;
@property (strong, nonatomic) UIButton *btn;
@property (strong, nonatomic) ProfileViewController* leftTableVC;
@property (strong, nonatomic) SettingViewController* rightTableVC;
@end

@implementation UserViewController
/*
static UserViewController *UVC = nil;
+(UserViewController *)getSingleton{
    static UserViewController *manager = nil;
     static dispatch_once_t onceToken ;
        dispatch_once(&onceToken, ^{
            manager = [[UserViewController alloc] init] ;
        }) ;
        
        return manager ;
}
*/

- (void)viewDidLoad {
    _isLog = @"NO";
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createBtn];
    [self createSegment];
    [self addRightTable];
    [self addLeftTable];
}

-(void)createBtn{
    //创建一个btn对象，根据类型创建btn
    //圆角类型btn:UIButtonTypeRoundedRect
    //通过类方法创建buttonWithType：类名加方法名
    self.btn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    //设置button按钮的位置
    self.btn.frame = CGRectMake(0, 0, 0, 0);
    self.btn.layer.cornerRadius = 55.0;
    //设置按钮的文字内容
    //@parameter
    //P1:字符串类型，显示到按钮上的文字
    //P2:设置文字显示的状态类型
    [self.btn setTitle:@"Login" forState:UIControlStateNormal];//正常状态
    
    self.btn.backgroundColor = [UIColor colorWithRed:((float)((0xADEAEA & 0xFF0000) >> 16))/255.0 green:((float)((0xADEAEA & 0xFF00) >> 8))/255.0 blue:((float)(0xADEAEA & 0xFF))/255.0 alpha:1.0];
    //设置按钮文字颜色P1:颜色  P2:状态
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //设置按钮的风格颜色
    [self.btn setTintColor:[UIColor whiteColor]];
    //titilelabel:UIlabel空间
    self.btn.titleLabel.font = [UIFont systemFontOfSize:28];
    //添加到视图中并 显示
    [self.view addSubview:self.btn];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(100);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)createSegment{
    // 初始化，添加分段名，会自动布局
    self.SC = [[UISegmentedControl alloc] initWithItems:@[@"用户信息", @"用户设置"]];
    self.SC.frame = CGRectMake(0, 0, 0, 0);
    // 设置整体的色调
    self.SC.tintColor = [UIColor colorWithRed:((float)((0xADEAEA & 0xFF0000) >> 16))/255.0 green:((float)((0xADEAEA & 0xFF00) >> 8))/255.0 blue:((float)(0xADEAEA & 0xFF))/255.0 alpha:1.0];
    
    // 设置分段名的字体
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:((float)((0xADEAEA & 0xFF0000) >> 16))/255.0 green:((float)((0xADEAEA & 0xFF00) >> 8))/255.0 blue:((float)(0xADEAEA & 0xFF))/255.0 alpha:1.0],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18],NSFontAttributeName ,nil];
    [self.SC setTitleTextAttributes:dic forState:UIControlStateNormal];
    
    // 设置初始选中项
    self.SC.selectedSegmentIndex = 0;
    [self.view addSubview: self.SC];
    [self.SC mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.btn.mas_bottom).with.offset(50);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 28));
    }];
    [self.SC addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
}

-(void) btnClick:(id)sender
{
    if([_isLog isEqualToString:@"NO"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录成功" message:@"欢迎回来"preferredStyle:UIAlertControllerStyleAlert ];
        [self presentViewController:alertController animated:YES completion:nil];
         [self performSelector:@selector(dismiss:) withObject:alertController afterDelay:0.7];
        [self.leftTableVC login ];
        _isLog = @"YES";
        _rightTableVC.isLog = _isLog;
    }
}

- (void)dismiss:(UIAlertController *)alert{
    [alert dismissViewControllerAnimated:YES completion:nil];
}

-(void)change:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        _leftTableVC.tableView.hidden = NO;
        _rightTableVC.tableView.hidden = YES;
        if([_rightTableVC.isLog isEqualToString:@"NO"]){
            _isLog = @"NO";
            [_leftTableVC.tableView reloadData];
        }
    }
    else if (sender.selectedSegmentIndex == 1){
        _rightTableVC.tableView.hidden = NO;
        _leftTableVC.tableView.hidden = YES;
    }
}

-(void)addLeftTable{
    self.leftTableVC = [[ProfileViewController alloc]init];
    [self addChildViewController:self.leftTableVC];
    [self.view addSubview:self.leftTableVC.tableView];
    [self.leftTableVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.SC.mas_bottom).with.offset(501);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 500));
    }];
}

-(void)addRightTable{
    self.rightTableVC = [[SettingViewController alloc]init];
    [self addChildViewController:self.rightTableVC];
    [self.view addSubview:self.rightTableVC.tableView];
    [self.rightTableVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.SC.mas_bottom).with.offset(501);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 500));
    }];
}

@end
