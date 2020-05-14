//
//  NavigationController.m
//  LanguageLearner
//
//  Created by GZX on 2019/9/28.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NavigationController.h"

@interface NavigationController()

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题视图
    self.navigationItem.titleView = [UIButton buttonWithType:UIButtonTypeContactAdd];
}

/*
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //修改返回文字
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [super pushViewController:viewController animated:animated];
}
*/

@end
