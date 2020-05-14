//
//  AddClockViewController.h
//  AlarmClock
//
//  Created by huangyifei on 2019/12/26.
//  Copyright © 2019 huangyifei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmClockManager.h"

@interface AddClockViewController : UITableViewController

@property (nonatomic, copy) void(^block)(AlarmClockModel *model);

@property (nonatomic, copy) AlarmClockModel *model;

@end
