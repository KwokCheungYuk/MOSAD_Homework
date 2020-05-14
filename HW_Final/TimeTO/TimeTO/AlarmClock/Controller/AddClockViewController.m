//
//  AddClockViewController.m
//  AlarmClock
//
//  Created by huangyifei on 2019/12/26.
//  Copyright © 2019 huangyifei. All rights reserved.
//

#import "AddClockViewController.h"
#import "BaseTableViewController.h"

@interface AddClockViewController ()
@property (weak, nonatomic) IBOutlet UIDatePicker *dataPicker;
@property (weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UISwitch *laterSwitch;

@end

@implementation AddClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    
    [self.dataPicker setValue:[UIColor blackColor] forKey:@"textColor"];
    self.dataPicker.backgroundColor = [UIColor whiteColor];
    
    [self or_reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.tableView reloadData];
}

- (void)or_reloadData {
    
    if (!_model) {
        _model = [AlarmClockModel new];
    }else {
        self.dataPicker.date = _model.date;
        self.repeatLabel.text = _model.repeat;
        self.tagLabel.text = _model.tag;
        self.musicLabel.text = _model.ring;
        self.laterSwitch.on = _model.isRemindLater;
    }

    [self.tableView reloadData];
}

- (IBAction)action_backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)action_saveBtn:(id)sender {
    
    self.model.date = _dataPicker.date;
    [self.model setDateForTimeClock];
    _model.ring = _musicLabel.text;
    _model.tag = _tagLabel.text;
    _model.isRemindLater = _laterSwitch.isOn;
    _model.repeat = _repeatLabel.text;
    _model.isOn = YES;
    _model.isRemindLater = self.laterSwitch.isOn;
    if (self.block) {
        self.block(_model);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    BaseTableViewController *baseVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"musicListVC"]) {
        baseVC.data = self.musicLabel.text;
        baseVC.block = ^(NSString *text) {
            self.model.ring = text;
            self.musicLabel.text = text;
        };
    }else if ([segue.identifier isEqualToString:@"repeatVC"]) {
        baseVC.data = self.model.repeats;
        baseVC.block = ^(NSArray *repeats) {
            self.model.repeats = repeats;
            self.repeatLabel.text = self.model.repeat;
        };
    }else if ([segue.identifier isEqualToString:@"labelVC"]) {
        baseVC.data = self.tagLabel.text;
        baseVC.block = ^(NSString *text) {
            self.model.tag = text;
            self.tagLabel.text = text;
        };
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setModel:(AlarmClockModel *)model {
    _model = model;
    [self or_reloadData];
}



@end
