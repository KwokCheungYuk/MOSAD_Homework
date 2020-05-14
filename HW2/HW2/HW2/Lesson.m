//
//  Lesson.m
//  HW2
//
//  Created by GZX on 2019/9/2.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lesson.h"

@interface Lesson()

@end

@implementation Lesson

@synthesize name = _name;
@synthesize time = _time;
@synthesize tour = _tour;
@synthesize unit = _unit;

-(id)init
{
    self = [super init];
    if(self){
        int random = arc4random() % 4;
        if(random == 0){
            _name = @"英语";
        }
        else if(random == 1){
            _name = @"日语";
        }
        else if(random == 2){
            _name = @"德语";
        }
        else if(random == 3){
            _name = @"西班牙语";
        }
        _time = [NSDate date];
        _tour = 1;
        _unit = 1;
    }
    return self;
}

@end

