//
//  AlarmClockManager.h
//  AlarmClock
//
//  Created by huangyifei on 2019/12/26.
//  Copyright © 2019 huangyifei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlarmClock+CoreDataClass.h"

@class AlarmClockModel;

@interface AlarmClockManager : NSObject

@property (nonatomic, strong) NSMutableArray <AlarmClockModel *>* clockData;

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic, strong) NSFetchRequest *request;
- (void)readData;

- (BOOL)addClockModel:(AlarmClockModel *)model;

- (BOOL)replaceModelAtIndex:(NSUInteger)index withModel:(AlarmClockModel *)model;

- (BOOL)removeClockModel:(AlarmClockModel *)model;

- (BOOL)removeClockAtIndex:(NSInteger)index;

- (BOOL)changeClockSwitchIsOn:(BOOL)isOn WithModel:(AlarmClockModel *)model;

- (void)reciveNotificationWithIdentifer:(NSString *)identifer;

@end

@interface AlarmClockModel : NSObject


@property (nonatomic, copy) NSDate *date;

@property (nonatomic, copy) NSString *timeString;

@property (nonatomic, copy) NSString *clockString;

@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSString *ring;


@property (nonatomic, copy) NSString *repeat;
@property (nonatomic, copy) NSString *identifer;

@property (nonatomic, strong) NSArray *repeats;
@property (nonatomic, strong) NSArray *identifers;

@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign) BOOL isRemindLater;
@property (nonatomic, assign) BOOL isRepeat;

- (void)addUserNotification;

- (void)removeUserNotification;

- (NSDate *)date;

- (void)setDateForTimeClock;

@end
