//
//  TaskTableView.m
//  todo
//
//  Created by guojj on 2019/12/26.
//  Copyright © 2019 guojj. All rights reserved.
//

#import "TaskTableView.h"
#import <Masonry.h>

@interface TaskTableView ()

@end


@implementation TaskTableView

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subV in self.subviews)
    {
        if ([subV isKindOfClass:NSClassFromString(@"_UITableViewCellSwipeContainerView")]) {
            for (UIView *subView in subV.subviews) {
                if ([subView isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
                {
                    NSLog(@"find UISwipeActionPullView");
                    [subView setBackgroundColor:[UIColor clearColor]];
                    for (UIView *view in subView.subviews)
                    {
                        if ([view isKindOfClass:[UIButton class]])
                        {
                            UIButton *btn = (UIButton *)view;
                            [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                            [btn setBackgroundColor:[UIColor redColor]];subView.layer.shadowColor = [UIColor blackColor].CGColor;
                            btn.layer.shadowRadius = 2;
                            btn.layer.shadowOpacity = 0.3;
                            btn.layer.shadowOffset = CGSizeMake(0, 0.25);
                            btn.layer.cornerRadius = 10.0;
                            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                                make.height.mas_equalTo(60);
                                make.centerX.mas_equalTo(subView.mas_centerX).with.offset(10);
                                make.centerY.mas_equalTo(subView.mas_centerY);
                            }];
                            //[btn.titleLabel setBackgroundColor:[UIColor blackColor]];
                            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                            [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
                            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                            for (UIView *v in view.subviews)
                            {
                                if ([v isKindOfClass:[UIView class]])
                                {
                                    v.layer.cornerRadius = 10.0;
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

@end
