//
//  ClockLabel.h
//  Homework Final
//
//  Created by kjhmh2 on 2019/12/25.
//  Copyright © 2019 kjhmh2. All rights reserved.
//

#ifndef ClockLabel_h
#define ClockLabel_h

#import <UIKit/UIKit.h>

@interface ClockLabel : UIView

- (void)updateTime:(NSInteger)time nextTime:(NSInteger)nextTime;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@end


#endif /* ClockLabel_h */
