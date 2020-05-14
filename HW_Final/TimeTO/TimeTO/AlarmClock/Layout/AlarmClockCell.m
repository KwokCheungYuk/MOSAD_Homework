//
//  AlarmClockCell.m
//  Alarm_Clock_UserNotifications
//
//  Created by 欧阳荣 on 2017/5/22.
//  Copyright © 2017年 欧阳荣. All rights reserved.
//

#import "AlarmClockCell.h"

@implementation AlarmClockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setModel:(AlarmClockModel *)model {
    
    _model = model;
    self.timeLabel.text = model.clockString;
    self.timeTextLabel.text = model.timeString;
    self.timeSwitch.on = model.isOn;
    if (model.repeat.length > 0 && ![model.repeat isEqualToString:@"永不"]) {
        self.timeTagLabel.text = [NSString stringWithFormat:@"%@，%@", model.tag,model.repeat];
    }else {
        self.timeTagLabel.text = model.tag;
    }
}

- (IBAction)action_switch:(UISwitch *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alarmCell:switch:didSelectedAtIndexpath:)]) {
        [self.delegate alarmCell:self switch:self.timeSwitch didSelectedAtIndexpath:self.indexPath];
    }
}

@end
