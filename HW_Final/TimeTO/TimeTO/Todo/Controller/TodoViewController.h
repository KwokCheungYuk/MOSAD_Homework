//
//  TodoViewController.h
//  todo
//
//  Created by guojj on 2019/12/23.
//  Copyright © 2019 guojj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoViewController : UIViewController

- (void)changeTask:(NSIndexPath*)indexPath checkState:(BOOL)checkState;

@end
