//
//  AlarmClock+CoreDataProperties.h
//  AlarmClock
//
//  Created by huangyifei on 2019/12/27.
//  Copyright © 2019 huangyifei. All rights reserved.
//
//

#import "AlarmClock+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface AlarmClock (CoreDataProperties)

+ (NSFetchRequest<AlarmClock *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSDate *data;
@property (nonatomic) BOOL isOn;
@property (nonatomic) BOOL isRemindLater;
@property (nullable, nonatomic, copy) NSString *repeat;
@property (nullable, nonatomic, copy) NSString *identifier;
@property (nullable, nonatomic, copy) NSString *ring;
@property (nullable, nonatomic, copy) NSString *tag;

@end

NS_ASSUME_NONNULL_END
