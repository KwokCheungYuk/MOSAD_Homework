//
//  BaseTableViewController.h
//  AlarmClock
//
//  Created by huangyifei on 2019/12/26.
//  Copyright © 2019 huangyifei. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

@property (nonatomic, copy) void(^block)(id data);

@property (nonatomic, copy) id data;

- (void)action_backItem;

@end
