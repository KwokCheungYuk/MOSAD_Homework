//
//  AppDelegate.h
//  TimeTO
//
//  Created by GZX on 2019/12/27.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

