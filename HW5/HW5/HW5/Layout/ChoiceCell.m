//
//  ChoiceCell.m
//  HW5
//
//  Created by GZX on 2019/10/29.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChoiceCell.h"
#import <Masonry.h>

@interface ChoiceCell()

@end

@implementation ChoiceCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.layer.borderWidth = 0;
        self.layer.cornerRadius = 15;
        _choice = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _choice.textAlignment = NSTextAlignmentCenter;
        _choice.textColor = [UIColor blackColor];
        _choice.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        [self.contentView addSubview:_choice];
        [_choice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(285, 55));
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    return self;
}


@end
