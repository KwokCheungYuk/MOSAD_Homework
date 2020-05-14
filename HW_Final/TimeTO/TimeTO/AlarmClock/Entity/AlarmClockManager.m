//
//  AlarmClockManager.m
//  AlarmClock
//
//  Created by huangyifei on 2019/12/26.
//  Copyright © 2019 huangyifei. All rights reserved.
//

#import "AlarmClockManager.h"
#import "UNNotificationsManager.h"
@implementation AlarmClockManager


- (instancetype)init {
    if (self =[super init]) {
        //1、创建模型对象获、取模型路径
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AlarmClock" withExtension:@"momd"];
        //根据模型文件创建模型对象
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        //2、创建持久化助理、利用模型对象创建助理对象
        NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        //数据库的名称和路径
        NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *sqlPath = [docStr stringByAppendingPathComponent:@"AlarmClockCoreData.sqlite"];
        NSLog(@"path = %@", sqlPath);
        NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
        //设置数据库相关信息
        [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:nil];
        //3、创建上下文
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        //关联持久化助理
        [context setPersistentStoreCoordinator:store];
        self.context = context;
        self.request = [NSFetchRequest fetchRequestWithEntityName:@"AlarmClock"];
    
    }
    return self;
}

- (NSArray <AlarmClock *>*)readAllData {
    // 检索条件制空就是搜索全部
    self.request.predicate = nil;
    return [self.context executeFetchRequest:self.request error:nil];
}
- (NSMutableArray *)clockData {
    if(_clockData == nil) {
        _clockData = [[NSMutableArray alloc] init];
        NSLog(@"initarray");
    }
    return _clockData;
}
- (void)readData {
    self.request.predicate = nil;
    NSArray *dataArray = [self.context executeFetchRequest:self.request error:nil];
    
    if (dataArray.count > 0) {
        for (AlarmClock *alarmClock in dataArray) {
            AlarmClockModel *model = [[AlarmClockModel alloc] init];
            model.date = alarmClock.data;
            model.tag = alarmClock.tag;
            model.ring = alarmClock.ring;
            model.repeat = alarmClock.repeat;
            model.isOn = alarmClock.isOn;
            model.isRemindLater = alarmClock.isRemindLater;
            model.identifer = alarmClock.identifier;
            [model setDateForTimeClock];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            if([model.repeat isEqualToString:@"每天"]) {
                array = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"].mutableCopy;
            } else if([model.repeat isEqualToString:@"工作日"]) {
                array = @[@"周一", @"周二", @"周三", @"周四", @"周五"].mutableCopy;
            } else if([model.repeat isEqualToString:@"周末"]) {
                array = @[@"周六", @"周日"].mutableCopy;
            } else if([model.repeat isEqualToString:@"从不"]){
                array = @[].mutableCopy;
            }else {
                if([model.repeat rangeOfString:@"周一"].location != NSNotFound) {
                    [array addObject:@"周一"];
                }
                if([model.repeat rangeOfString:@"周二"].location != NSNotFound) {
                    [array addObject:@"周二"];
                }
                if([model.repeat rangeOfString:@"周三"].location != NSNotFound) {
                    [array addObject:@"周三"];
                }
                if([model.repeat rangeOfString:@"周四"].location != NSNotFound) {
                    [array addObject:@"周四"];
                }
                if([model.repeat rangeOfString:@"周五"].location != NSNotFound) {
                    [array addObject:@"周五"];
                }
                if([model.repeat rangeOfString:@"周六"].location != NSNotFound) {
                    [array addObject:@"周六"];
                }
                if([model.repeat rangeOfString:@"周日"].location != NSNotFound) {
                    [array addObject:@"周日"];
                }
            }
            model.repeats = [array copy];
            [self.clockData addObject:(AlarmClockModel *)model];
        }
    }else {
        self.clockData = [NSMutableArray array];
    }
    
}

- (BOOL)addClockModel:(AlarmClockModel *)model {
    AlarmClock *alarmClock =[NSEntityDescription insertNewObjectForEntityForName:@"AlarmClock" inManagedObjectContext:self.context];
    alarmClock.data = model.date;
    alarmClock.tag = model.tag;
    alarmClock.ring = model.ring;
    alarmClock.repeat = model.repeat;
    alarmClock.isOn = model.isOn;
    alarmClock.isRemindLater = model.isRemindLater;
    alarmClock.identifier = model.identifer;
    [self.clockData addObject:model];
    [model addUserNotification];
    NSError *error = nil;
    if ([self.context save:&error]) {
        return YES;
    }
    return NO;
}

- (BOOL)replaceModelAtIndex:(NSUInteger)index withModel:(AlarmClockModel *)model{
    [self.clockData[index] removeUserNotification];
    [self.clockData replaceObjectAtIndex:index withObject:model];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"identifier = %@",model.identifer];
    self.request.predicate = pre;
    NSArray *resArray = [self.context executeFetchRequest:self.request error:nil];
    model.identifer = nil;
    model.identifers = nil;
    for (AlarmClock *alarmClock in resArray) {
        alarmClock.data = model.date;
        alarmClock.tag = model.tag;
        alarmClock.ring = model.ring;
        alarmClock.repeat = model.repeat;
        alarmClock.isOn = model.isOn;
        alarmClock.isRemindLater = model.isRemindLater;
        alarmClock.identifier = model.identifer;
    }
    
    [model addUserNotification];
    NSError *error = nil;
    if ([self.context save:&error]) {
        return YES;
    }
    return NO;
}
- (BOOL)removeClockModel:(AlarmClockModel *)model {
    [model removeUserNotification];
    [self.clockData removeObject:model];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"identifier = %@",model.identifer];
    self.request.predicate = pre;
    //返回需要删除的对象数组
    NSArray *deleArray = [_context executeFetchRequest:self.request error:nil];
    //从数据库中删除
    for (AlarmClock *alarmClock in deleArray) {
        [self.context deleteObject:alarmClock];
    }
    NSError *error = nil;
    if ([self.context save:&error]) {
        return YES;
    }
    return NO;
}

- (BOOL)removeClockAtIndex:(NSInteger)index {
    return [self removeClockModel:self.clockData[index]];
}

- (BOOL)changeClockSwitchIsOn:(BOOL)isOn WithModel:(AlarmClockModel *)model {
    model.isOn = isOn;
    isOn ? [model addUserNotification] : [model removeUserNotification];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"identifier = %@",model.identifer];
    self.request.predicate = pre;
    NSArray *resArray = [self.context executeFetchRequest:self.request error:nil];
    for (AlarmClock *alarmClock in resArray) {
        alarmClock.isOn = model.isOn;
    }
    NSError *error = nil;
    if ([self.context save:&error]) {
        return YES;
    }
    return NO;
}
- (void)reciveNotificationWithIdentifer:(NSString *)identifer {
    [self.clockData enumerateObjectsUsingBlock:^(AlarmClockModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (([identifer hasPrefix:obj.identifer] || [obj.identifer isEqualToString:identifer]) && obj.repeat.length == 0) {
            [self changeClockSwitchIsOn:NO WithModel:obj];
        }
        
    }];
}
@end

@implementation AlarmClockModel
#pragma mark -- private
- (void)setDateForTimeClock {
    NSDateFormatter *format = [self getFormatter];
    NSString *dateString = [format stringFromDate:_date];
    
    if ([dateString containsString:@"上午"] || [dateString containsString:@"下午"]) {
        self.timeString = [dateString substringToIndex:2];
        self.clockString = [dateString substringFromIndex:2];
    } else {
        self.timeString = dateString;
        self.clockString = @"";
    }
    
    
    
}

- (NSDateFormatter *)getFormatter {
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"ah:mm";
    format.AMSymbol = @"上午";
    format.PMSymbol = @"下午";
    return format;
}

- (void)addUserNotification {
    
    if ([self.repeat isEqualToString:@"每天"]) {
        [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound soundNamed:self.ring]] dateComponents:[UNNotificationsManager componentsEveryDayWithDate:self.date] identifer:self.identifer isRepeat:self.isRepeat completionHanler:^(NSError *error) {
            NSLog(@"add error %@", error);
        }];
    }else if (self.repeats.count == 0) {
        [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"时钟" subTitle:nil body:nil sound:[UNNotificationSound soundNamed:self.ring]] dateComponents:[UNNotificationsManager componentsWithDate:self.date] identifer:self.identifer isRepeat:self.isRepeat completionHanler:^(NSError *error) {
            NSLog(@"add error %@", error);
        }];
    }else {
        [self.repeats enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger week = 0;
            if ([obj containsString:@"周日"]) {
                week = 1;
            }else if([obj containsString:@"周一"]){
                week = 2;
            }else if([obj containsString:@"周二"]){
                week = 3;
            }else if([obj containsString:@"周三"]){
                week = 4;
            }else if([obj containsString:@"周四"]){
                week = 5;
            }else if([obj containsString:@"周五"]){
                week = 6;
            }else if([obj containsString:@"周六"]){
                week = 7;
            }
            [UNNotificationsManager addNotificationWithContent:[UNNotificationsManager contentWithTitle:@"闹钟" subTitle:nil body:nil sound:[UNNotificationSound soundNamed:self.ring]] weekDay:week date:self.date identifer:self.identifers[idx] isRepeat:YES completionHanler:^(NSError *error) {
                NSLog(@"add error %@", error);
            }];
        }];
    }
    
    
}

- (void)removeUserNotification {
    [UNNotificationsManager removeNotificationWithIdentifer:self.identifer];
    if (self.identifers.count > 0) {
        [UNNotificationsManager removeNotificationWithIdentifers:self.identifers];
    }
}


- (NSString *)identifer {
    if (_identifer == nil) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyyMMddhhmmss";
        
        NSString *identifer = [format stringFromDate:[NSDate date]];
        _identifer = self.isRemindLater ? [NSString stringWithFormat:@"isLater%@",identifer] : identifer;
    }
    return _identifer;
}

- (NSArray *)identifers {
    if (_identifers == nil) {
        NSMutableArray *idenArray = [NSMutableArray array];
        [self.repeats enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [idenArray addObject:[self.identifer stringByAppendingString:obj]];

            NSLog(@"modelidentifier %@", [self.identifer stringByAppendingString:obj]);
        }];
        _identifers = [idenArray copy];
    }
    return _identifers;
}

- (void)setRepeats:(NSArray *)repeatStrs {
    _repeats = repeatStrs;
    NSMutableArray *repeatArray = [NSMutableArray array];
    [repeatStrs enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [repeatArray addObject:obj];
    }];
    
    if (self.repeats.count > 0) {
        NSString *str = [repeatArray componentsJoinedByString:@""];
        self.repeat = str;
        if (str.length == 14) {
            self.repeat = @"每天";
        }else if ([str containsString:@"周日"] && [str containsString:@"周六"] && str.length == 4) {
            self.repeat = @"周末";
            NSLog(@"%ld", repeatStrs.count);
        }else if (![str containsString:@"周日"] && ![str containsString:@"周六"] && str.length == 10) {
            self.repeat = @"工作日";
        }

    }else {
        self.repeat = @"永不";
    }
    
}
- (BOOL)isRepeat {
    if (self.repeats.count <= 0) {
        return NO;
    }else {
        return YES;
    }
}
@end
