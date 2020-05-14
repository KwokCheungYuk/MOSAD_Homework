//
//  TarBarController.h
//  LanguageLearner
//
//  Created by GZX on 2019/9/28.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearningViewController.h"
#import "UserViewController.h"

@interface TarBarController : UITabBarController<UITabBarControllerDelegate>
@property (strong, nonatomic)LearningViewController *learnVC;
//@property (strong, nonatomic)UserViewController * USerVC;
@property (nonatomic, strong)NSString *lanTitle;

@end
