//
//  Person.m
//  HW2
//
//  Created by GZX on 2019/9/2.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Person()
@end

@implementation Person

@synthesize name = _name;

-(id)init
{
    self = [super init];
    if(self){
        int random = arc4random() % 3;
        if(random == 0){
            _name = @"张三";
        }
        else if(random == 1){
            _name = @"李四";
        }
        else if(random == 2){
            _name = @"王五";
        }
    }
    return self;
}
@end
