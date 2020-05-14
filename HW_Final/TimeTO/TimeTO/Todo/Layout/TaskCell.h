//
//  TaskCell.h
//  todo
//
//  Created by guojj on 2019/12/24.
//  Copyright © 2019 guojj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

@interface TaskCell : UITableViewCell{
    BOOL checkState;
}

@property (nonatomic, strong) UIView *v;

@property (nonatomic, strong) UIButton *checkBox;

@property (nonatomic, strong) UILabel *descript;

@property (nonatomic, strong) UILabel *ddl;

-(void)setCheckStateTo:(BOOL)checkState animate:(BOOL)animate;

-(BOOL)getCheckState;

-(void)showSelected;

-(void)showDeselected;

@end
