//
//  AddPageController.h
//  DayMatters
//
//  Created by GZX on 2019/12/23.
//  Copyright © 2019 GZX. All rights reserved.
//

#ifndef AddPageController_h
#define AddPageController_h
#import <UIKit/UIKit.h>

@interface AddPageController : UIViewController
-(void)initDB:(NSManagedObjectContext*) objContext2
   withSource:(NSMutableArray*) data;
@end

#endif /* AddPageController_h */
