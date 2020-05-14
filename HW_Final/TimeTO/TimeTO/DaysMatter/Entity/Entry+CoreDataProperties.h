//
//  Entry+CoreDataProperties.h
//  TimeTO
//
//  Created by GZX on 2019/12/27.
//  Copyright © 2019 GZX. All rights reserved.
//
//

#import "Entry+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Entry (CoreDataProperties)

+ (NSFetchRequest<Entry *> *)fetchRequest;

@property (nonatomic) int32_t id;
@property (nullable, nonatomic, copy) NSDate *time;
@property (nullable, nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
