//
//  Entry+CoreDataProperties.m
//  TimeTO
//
//  Created by GZX on 2019/12/27.
//  Copyright © 2019 GZX. All rights reserved.
//
//

#import "Entry+CoreDataProperties.h"

@implementation Entry (CoreDataProperties)

+ (NSFetchRequest<Entry *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
}

@dynamic id;
@dynamic time;
@dynamic title;

@end
