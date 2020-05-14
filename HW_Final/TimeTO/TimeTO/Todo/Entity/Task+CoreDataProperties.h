//
//  Task+CoreDataProperties.h
//  
//
//  Created by guojj on 2019/12/27.
//
//

#import "Task+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Task (CoreDataProperties)

+ (NSFetchRequest<Task *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *descript;
@property (nonatomic) BOOL isFinished;
@property (nullable, nonatomic, copy) NSDate *ddl;

@end

NS_ASSUME_NONNULL_END
