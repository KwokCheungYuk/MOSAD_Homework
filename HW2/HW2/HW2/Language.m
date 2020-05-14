//
//  Language.m
//  HW2
//
//  Created by GZX on 2019/9/3.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Language.h"

@interface Language()

@end

@implementation Language

-(id)init
{
    self = [super init];
    if(self){
        self->progress_tour = 0;
        self->progress_unit = 0;
    }
    return self;
}

-(void)learnOneUnit
{
    if(self->progress_unit < 4){
        self->progress_unit ++;
    }
    else{
        self->progress_tour ++;
        self->progress_unit = 1;
    }
    
}

-(NSInteger)getTour
{
    return self->progress_tour;
}

-(NSInteger)getUnit{
    
    return self->progress_unit;
}

-(NSString*)getName
{
    return nil;
}

-(bool)isFinish
{
    if(self->progress_tour == 8 && self->progress_unit == 4){
        return true;
    }
    else return false;
}

@end

@interface English()

@end

@implementation English

-(id)init
{
    self = [super init];
    return self;
}

-(NSString*)getName
{
    return @"英语";
}

@end

@interface Japanese()

@end

@implementation Japanese

-(id)init
{
    self = [super init];
    return self;
}

-(NSString*)getName
{
    return @"日语";
}

@end

@interface German()

@end

@implementation German

-(id)init
{
    self = [super init];
    return self;
}

-(NSString*)getName
{
    return @"德语";
}

@end

@interface Spanish()

@end

@implementation Spanish

-(id)init
{
    self = [super init];
    return self;
}

-(NSString*)getName
{
    return @"西班牙语";
}

@end
