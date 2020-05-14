//
//  Cell.h
//  DayMatters
//
//  Created by GZX on 2019/12/23.
//  Copyright © 2019 GZX. All rights reserved.
//

#ifndef Cell_h
#define Cell_h

#import <UIKit/UIKit.h>

@interface MyUILabel : UILabel

@end

@interface Cell : UICollectionViewCell
@property int ID;
@property (strong, nonatomic)MyUILabel *content;
@property (strong, nonatomic)UILabel *time;
@property (strong, nonatomic)UILabel *day;
@property (strong, nonatomic)NSDate *concreteTime;
@property BOOL isPast;
@end

#endif /* Cell_h */
