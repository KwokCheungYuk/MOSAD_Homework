//
//  Clock.m
//  Homework Final
//
//  Created by kjhmh2 on 2019/12/25.
//  Copyright © 2019 kjhmh2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry.h>
#import "Clock.h"
#import "ClockItem.h"

@interface Clock ()
 
@property(nonatomic, strong) ClockItem * monthItem;
    
@property(nonatomic, strong) ClockItem * dayItem;
    
@property(nonatomic, strong) ClockItem * hourItem;
    
@property(nonatomic, strong) ClockItem * minuteItem;
    
@property(nonatomic, strong) ClockItem * secondItem;
    
@property(nonatomic, strong) UILabel * label1;

@property(nonatomic, strong) UILabel * label2;

@property(nonatomic, strong) UILabel * label3;

@end

@implementation Clock

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
    [self buildClock];
    [self buildLabel];
    self.backgroundColor = [UIColor colorWithRed: 231/255.0f green: 230/255.0f blue: 230/255.0f alpha:1];
    
    [self addSubview: _monthItem];
    [self addSubview: _dayItem];
    [self addSubview: _hourItem];
    [self addSubview: _minuteItem];
    [self addSubview: _secondItem];
    
    [self addSubview: _label1];
    [self addSubview: _label2];
    [self addSubview: _label3];
}

- (void)buildClock
{
    _monthItem = [[ClockItem alloc] init];
    _monthItem.type = ClockItemTypeMonth;
    
    _dayItem = [[ClockItem alloc] init];
    _dayItem.type = ClockItemTypeDay;
    
    _hourItem = [[ClockItem alloc] init];
    _hourItem.type = ClockItemTypeHour;
    
    _minuteItem = [[ClockItem alloc] init];
    _minuteItem.type = ClockItemTypeMinute;
    
    _secondItem = [[ClockItem alloc] init];
    _secondItem.type = ClockItemTypeSecond;
}

- (void)buildLabel
{
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.textColor = [UIColor blackColor];
    self.label1.font = [UIFont boldSystemFontOfSize: 18];
    [self.label1 setText: @"—"];
    
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.textColor = [UIColor blackColor];
    self.label2.font = [UIFont boldSystemFontOfSize: 28];
    [self.label2 setText: @":"];
    
    self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.label3.textAlignment = NSTextAlignmentCenter;
    self.label3.textColor = [UIColor blackColor];
    self.label3.font = [UIFont boldSystemFontOfSize: 28];
    [self.label3 setText: @":"];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat margin = 0.05 * self.bounds.size.width;
    CGFloat itemW = (self.bounds.size.width - 4 * margin) / 6.8f + 8;
    CGFloat itemH = (self.bounds.size.width - 4 * margin) / 6.8f;
    //NSLog(@"sd: %f %f", self.bounds.size.width, self.bounds.size.height);
    
    [self.monthItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).with.offset(18);
        make.left.mas_equalTo(self.mas_left).with.offset(margin);
        make.size.mas_equalTo(CGSizeMake(itemW, itemH));
    }];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthItem.mas_top);
        make.left.mas_equalTo(self.monthItem.mas_right);
        make.size.mas_equalTo(CGSizeMake(itemW / 2, itemH));
    }];
    [self.dayItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthItem.mas_top);
        make.left.mas_equalTo(self.label1.mas_right);
        make.size.mas_equalTo(CGSizeMake(itemW, itemH));
    }];
    [self.hourItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthItem.mas_top);
        make.left.mas_equalTo(self.dayItem.mas_right).with.offset(margin);
        make.size.mas_equalTo(CGSizeMake(itemW, itemH));
    }];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthItem.mas_top);
        make.left.mas_equalTo(self.hourItem.mas_right);
        make.size.mas_equalTo(CGSizeMake(itemW / 2, itemH));
    }];
    [self.minuteItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthItem.mas_top);
        make.left.mas_equalTo(self.hourItem.mas_right).with.offset(margin);
        make.size.mas_equalTo(CGSizeMake(itemW, itemH));
    }];
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthItem.mas_top);
        make.left.mas_equalTo(self.minuteItem.mas_right);
        make.size.mas_equalTo(CGSizeMake(itemW / 2, itemH));
    }];
    [self.secondItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.monthItem.mas_top);
        make.left.mas_equalTo(self.minuteItem.mas_right).with.offset(margin);
        make.size.mas_equalTo(CGSizeMake(itemW, itemH));
    }];
}

- (void)setDate:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components: unitFlags fromDate:date];
    _monthItem.time = dateComponent.month;
    _dayItem.time = dateComponent.day;
    _hourItem.time = dateComponent.hour;
    _minuteItem.time = dateComponent.minute;
    _secondItem.time = dateComponent.second;
}

- (void)setFont:(UIFont *)font
{
    _monthItem.font = font;
    _dayItem.font = font;
    _hourItem.font = font;
    _minuteItem.font = font;
    _secondItem.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _monthItem.textColor = textColor;
    _dayItem.textColor = textColor;
    _hourItem.textColor = textColor;
    _minuteItem.textColor = textColor;
    _secondItem.textColor = textColor;
}
@end
