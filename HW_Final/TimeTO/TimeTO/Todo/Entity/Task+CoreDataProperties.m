//
//  Task+CoreDataProperties.m
//  
//
//  Created by guojj on 2019/12/27.
//
//

#import "Task+CoreDataProperties.h"

@implementation Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Task"];
}

@dynamic descript;
@dynamic isFinished;
@dynamic ddl;

@end
