//
//  Clock.h
//  Homework Final
//
//  Created by kjhmh2 on 2019/12/25.
//  Copyright © 2019 kjhmh2. All rights reserved.
//

#ifndef Clock_h
#define Clock_h

#import <UIKit/UIKit.h>

@interface Clock : UIView

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@end

#endif /* Clock_h */
