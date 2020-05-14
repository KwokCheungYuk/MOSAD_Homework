//
//  SettingViewController.h
//  LanguageLearner
//
//  Created by GZX on 2019/9/29.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property NSString *isLog;
@end
