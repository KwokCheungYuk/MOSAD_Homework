//
//  TarBarController.m
//  LanguageLearner
//
//  Created by GZX on 2019/9/28.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TarBarController.h"

@interface TarBarController()

@end

@implementation TarBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self createBar];
}

-(void)createBar{
    // 通过appearance统一设置UITabbarItem的文字属性
    NSMutableDictionary * attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont  systemFontOfSize:14.0];  // 设置文字大小
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];  // 设置文字的前景色
    
    NSMutableDictionary * selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    UITabBarItem * item = [UITabBarItem appearance];  // 设置appearance
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    _learnVC = [[LearningViewController alloc]init];
    _learnVC.tabBarItem.tag = 101;
    _learnVC.tabBarItem.title = @"学习";
    _learnVC.tabBarItem.image = [[UIImage imageNamed:@"learn1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _learnVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"learn2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_learnVC.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [_learnVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0,3)];
    [self addChildViewController:_learnVC];
    
    UserViewController* _USerVC = [[UserViewController alloc]init];
    //UserViewController* _USerVC = [UserViewController getSingleton];
    _USerVC.tabBarItem.tag = 102;
    _USerVC.tabBarItem.title = @"用户";
    _USerVC.tabBarItem.image = [[UIImage imageNamed:@"user1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _USerVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"user2.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [_USerVC.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0,3)];
    [self addChildViewController:_USerVC];
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"%ld", viewController.tabBarItem.tag);
    if(viewController.tabBarItem.tag == 101){
        self.navigationItem.title = _lanTitle;
    }
    else if(viewController.tabBarItem.tag == 102){
        self.navigationItem.title = @"个人档案";
    }
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    UIViewController *tbselect=tabBarController.selectedViewController;
    if([tbselect isEqual:viewController]){
        return NO;
    }
    return YES;
}

@end
