//
//  NavigationController.m
//  HW5
//
//  Created by GZX on 2019/10/29.
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


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //修改返回文字
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [super pushViewController:viewController animated:animated];
}
 

@end

