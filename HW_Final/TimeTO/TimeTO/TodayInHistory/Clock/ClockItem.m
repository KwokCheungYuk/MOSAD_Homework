//
//  ClockItem.m
//  Homework Final
//
//  Created by kjhmh2 on 2019/12/25.
//  Copyright © 2019 kjhmh2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry.h>
#import "ClockItem.h"
#import "ClockLabel.h"

@interface ClockItem ()

@property(nonatomic, strong) ClockLabel * leftLabel;

@property(nonatomic, strong) ClockLabel * rightLabel;

@property(nonatomic, strong) UIView * line;

@property NSInteger lastLeftTime;

@property NSInteger lastRightTime;

@property BOOL firstSetTime;
@end

@implementation ClockItem

- (instancetype)init
{
    if (self = [super init])
    {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    [self buildLabel];
    
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor colorWithRed: 231/255.0f green: 230/255.0f blue: 230/255.0f alpha:1];
    self.backgroundColor = [UIColor colorWithRed: 231/255.0f green: 230/255.0f blue: 230/255.0f alpha:1];
    
    [self addSubview: self.leftLabel];
    [self addSubview: self.rightLabel];
    [self addSubview: self.line];
    
    _lastLeftTime = -1;
    _lastRightTime = -1;
}

- (void)buildLabel
{
    self.leftLabel = [[ClockLabel alloc] init];
    self.leftLabel.backgroundColor = [UIColor whiteColor];
    
    self.rightLabel = [[ClockLabel alloc] init];
    self.rightLabel.backgroundColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin = self.bounds.size.width * 0.1;
    CGFloat labelW = (self.frame.size.width - margin) / 2.0f;
    CGFloat labelH = self.frame.size.height;
    /*
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.size.mas_equalTo(CGSizeMake(20, 40));
    }];
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.leftLabel.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(20, 40));
    }];
    */
    self.leftLabel.frame = CGRectMake(0, 0, labelW, labelH);
    self.rightLabel.frame = CGRectMake(labelW + margin, 0, labelW, labelH);
    
    self.layer.cornerRadius = self.bounds.size.height / 10.0f;
    self.layer.masksToBounds = true;
    
    _line.bounds = CGRectMake(0, 0, self.bounds.size.width, 2);
    _line.center = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
}

- (void)setTime:(NSInteger)time
{
    _time = time;
    [self configLeftTimeLabel: time / 10];
    [self configRightTimeLabel: time % 10];
}

- (void)configLeftTimeLabel:(NSInteger)time
{
    if (_lastLeftTime == time && _lastLeftTime != -1)
    {
        return;
    }
    _lastLeftTime = time;
    NSInteger current = 0;
    switch (self.type)
    {
        case ClockItemTypeMonth:
            current = time == 0 ? 1 : time - 1;
            break;
        case ClockItemTypeDay:
            current = time == 0 ? 3 : time - 1;
            break;
        case ClockItemTypeHour:
            current = time == 0 ? 2 : time - 1;
            break;
        case ClockItemTypeMinute:
            current = time == 0 ? 5 : time - 1;
            break;
        case ClockItemTypeSecond:
            current = time == 0 ? 5 : time - 1;
            break;
        default:
            break;
    }
    [_leftLabel updateTime: current nextTime:time];
}

- (void)configRightTimeLabel:(NSInteger)time
{
    if (_lastRightTime == time && _lastRightTime != -1)
    {
        return;
    }
    _lastRightTime = time;
    NSInteger current = 0;
    switch (self.type)
    {
        case ClockItemTypeMonth:
            current = time == 0 ? 2 : time - 1;
            break;
        case ClockItemTypeDay:
            current = time == 0 ? 9 : time - 1;
            break;
        case ClockItemTypeHour:
            current = time == 0 ? 4 : time - 1;
            break;
        case ClockItemTypeMinute:
            current = time == 0 ? 9 : time - 1;
            break;
        case ClockItemTypeSecond:
            current = time == 0 ? 9 : time - 1;
            break;
        default:
            break;
    }
    [_rightLabel updateTime:current nextTime:time];
}

#pragma mark Setter
- (void)setFont:(UIFont *)font
{
    _leftLabel.font = font;
    _rightLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _leftLabel.textColor = textColor;
    _rightLabel.textColor = textColor;
}

@end

