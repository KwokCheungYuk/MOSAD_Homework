//
//  ViewController.m
//  HW2
//
//  Created by GZX on 2019/9/2.
//  Copyright © 2019 GZX. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
//import "Lesson.h"
#import "Language.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Person *person1 = [[Person alloc] init];
    //Lesson *l1 = [[Lesson alloc] init];
    English *english1 = [[English alloc] init];
    Japanese *japanese1 = [[Japanese alloc] init];
    German *german1 = [[German alloc] init];
    Spanish *spanish1 = [[Spanish alloc] init];
    Language *language1 = [[Language alloc] init];
    int random = arc4random() % 4;
    switch (random) {
        case 0:
            language1 = english1;
            break;
        case 1:
            language1 = japanese1;
            break;
        case 2:
            language1 = german1;
            break;
        case 3:
            language1 = spanish1;
            break;
        default:
            break;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    /*
    for(int i = 0; i < 8; i ++){
        for(int j = 0; j < 4; j ++){
            NSTimeInterval interval = 60 * 60 * 24 * (arc4random() % 5 + 1);
            NSString *strTime = [formatter stringFromDate:l1.time];
            NSLog(@"%@ %@ 学习%@ tour %d unit %d", p1.name, strTime, l1.name, l1.tour, l1.unit);
            l1.unit ++;
            l1.time = [l1.time initWithTimeInterval:interval sinceDate:l1.time];
        }
        l1.unit = 1;
        l1.tour ++;
        
    }
     */
    NSDate *startTime = [NSDate date];
    while([language1 isFinish] == false){
        [language1 learnOneUnit];
        NSTimeInterval interval = 60 * 60 * 24 * (arc4random() % 5 + 1);
        NSString *strTime = [formatter stringFromDate:startTime];
         NSLog(@"%@ %@ 学习%@ tour %ld unit %ld", person1.name, strTime, [language1 getName], [language1 getTour], [language1 getUnit]);
        startTime = [startTime initWithTimeInterval:interval sinceDate:startTime];
        
    }
}


@end
