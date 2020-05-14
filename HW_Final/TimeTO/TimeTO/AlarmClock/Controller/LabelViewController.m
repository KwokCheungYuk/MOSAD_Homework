//
//  LabelViewController.m
//  AlarmClock
//
//  Created by huangyifei on 2019/12/26.
//  Copyright © 2019 huangyifei. All rights reserved.
//

#import "LabelViewController.h"

@interface LabelViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textfield;

@end

@implementation LabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"标签";
    self.tableView.contentInset = UIEdgeInsetsMake(200, 0, 0, 0);
    
    if (self.data) {
        self.textfield.text = self.data;
    }
    
}

#pragma mark -- override
- (void)action_backItem {
    
    if (self.block) {
        self.block(self.textfield.text);
    }
    [super action_backItem];
}

@end

