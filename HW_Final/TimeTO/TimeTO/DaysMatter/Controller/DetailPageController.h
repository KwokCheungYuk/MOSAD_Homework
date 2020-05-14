//
//  DetailPageController.h
//  DayMatters
//
//  Created by GZX on 2019/12/24.
//  Copyright © 2019 GZX. All rights reserved.
//

#ifndef DetailPageController_h
#define DetailPageController_h


#endif /* DetailPageController_h */
#import <UIKit/UIKit.h>
#import "Cell.h"

@interface DetailPageController : UIViewController
-(void)initData:(Cell*)cell
    withContext:(NSManagedObjectContext*)objContext2;

@end
