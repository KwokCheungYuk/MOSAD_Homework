//
//  AppDelegate.h
//  LanguageLearner
//
//  Created by GZX on 2019/9/27.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationController.h"
#import "ViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NavigationController *navController;
@property (strong, nonatomic) ViewController *vc;

@end

