//
//  ViewController.m
//  AlarmClock
//
//  Created by huangyifei on 2019/12/26.
//  Copyright © 2019 huangyifei. All rights reserved.
//

#import "HomeViewController.h"
#import "AlarmClockCell.h"
#import "AlarmClockManager.h"
#import "AddClockViewController.h"


@interface HomeViewController ()<UITableViewDelegate, UITableViewDataSource, AlarmClockCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *leftButton;
@property (nonatomic, weak) IBOutlet UIButton *rightButton;
@property (nonatomic, strong) AlarmClockManager *alarmClockManager;

@end

@implementation HomeViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReciveNotification:) name:@"didReciveNotification" object:nil];
    self.tableView.tableFooterView = [UIView new];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]]];
    self.navigationController.navigationBar.translucent = YES;
    
    
   // self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (AlarmClockManager *)alarmClockManager {
    if(_alarmClockManager == nil) {
        _alarmClockManager = [[AlarmClockManager alloc] init];
        [_alarmClockManager readData];
    }
    return _alarmClockManager;
}
- (void)didReciveNotification:(NSNotification *)notif {
    [self.alarmClockManager reciveNotificationWithIdentifer:notif.userInfo[@"idf"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)action_editBtn:(UIBarButtonItem *)sender {
    if(self.tableView.editing) {
        [self.leftButton setTitle:@"编辑" forState:UIControlStateNormal];
        self.rightButton.enabled = YES;
    } else {
        [self.leftButton setTitle:@"完成" forState:UIControlStateNormal];
        self.rightButton.enabled = NO;
    }
    [self.tableView setEditing:!self.tableView.editing animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nav = segue.destinationViewController;
    
    AddClockViewController *vc = (AddClockViewController *)nav.topViewController;
    if ([segue.identifier isEqualToString:@"addPresentVCIdf"]) {
        vc.block = ^(AlarmClockModel *model){
            [self.alarmClockManager addClockModel:model];
            [self.tableView reloadData];
        };
    }else {
        vc.model = self.alarmClockManager.clockData[self.tableView.indexPathForSelectedRow.row];
        vc.block = ^(AlarmClockModel *model){
            [self.alarmClockManager replaceModelAtIndex:self.tableView.indexPathForSelectedRow.row withModel:model];
            [self.tableView reloadData];
        };
    }
}


#pragma mark -- UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.alarmClockManager.clockData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AlarmClockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmClockCell" forIndexPath:indexPath];
    cell.model = self.alarmClockManager.clockData[indexPath.row];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.tableView.editing) return;
    [self performSegueWithIdentifier:@"editPresentVCIdf" sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.alarmClockManager removeClockAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)alarmCell:(AlarmClockCell *)cell switch:(UISwitch *)switchControl didSelectedAtIndexpath:(NSIndexPath *)indexpath {
    [self.alarmClockManager changeClockSwitchIsOn:switchControl.isOn WithModel:self.alarmClockManager.clockData[indexpath.row]];
}
@end
