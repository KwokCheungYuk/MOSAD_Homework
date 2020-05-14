//
//  RepeatViewController.m
//  AlarmClock
//
//  Created by huangyifei on 2019/12/26.
//  Copyright © 2019 huangyifei. All rights reserved.
//

#import "RepeatViewController.h"

@interface RepeatViewController ()

@property (nonatomic, strong) NSMutableArray *weekdays;

@end

@implementation RepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"重复";
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    
    if (self.data) {
        _weekdays = [NSMutableArray arrayWithArray:self.data];
        if ([_weekdays containsObject:@"周日"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"周一"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"周二"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"周三"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"周四"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"周五"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        if ([_weekdays containsObject:@"周六"]) {
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }

    }


}

- (void)action_backItem {
    if (self.block) {
        self.block(self.weekdays);
    }
    [super action_backItem];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.weekdays removeObject:cell.textLabel.text];
    }else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.weekdays addObject:cell.textLabel.text];
    }
}

- (NSMutableArray *)weekdays {
    if (!_weekdays) {
        _weekdays = [NSMutableArray array];
    }
    return _weekdays;
}

 

@end
