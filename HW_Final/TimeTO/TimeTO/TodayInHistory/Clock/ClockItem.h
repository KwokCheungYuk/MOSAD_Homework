//
//  ClockItem.h
//  Homework Final
//
//  Created by kjhmh2 on 2019/12/25.
//  Copyright © 2019 kjhmh2. All rights reserved.
//

#ifndef ClockItem_h
#define ClockItem_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ClockItemType) {
    ClockItemTypeMonth = 0,
    ClockItemTypeDay,
    ClockItemTypeHour,
    ClockItemTypeMinute,
    ClockItemTypeSecond,
};

@interface ClockItem : UIView

@property (nonatomic, assign) ClockItemType type;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIColor *textColor;

@end

#endif /* ClockItem_h */
