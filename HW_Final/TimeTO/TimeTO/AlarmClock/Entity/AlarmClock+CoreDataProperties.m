//
//  AlarmClock+CoreDataProperties.m
//  AlarmClock
//
//  Created by huangyifei on 2019/12/27.
//  Copyright © 2019 huangyifei. All rights reserved.
//
//

#import "AlarmClock+CoreDataProperties.h"

@implementation AlarmClock (CoreDataProperties)

+ (NSFetchRequest<AlarmClock *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"AlarmClock"];
}

@dynamic data;
@dynamic isOn;
@dynamic isRemindLater;
@dynamic repeat;
@dynamic identifier;
@dynamic ring;
@dynamic tag;

@end
