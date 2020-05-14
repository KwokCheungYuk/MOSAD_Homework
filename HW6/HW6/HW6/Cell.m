//
//  Cell.m
//  HW6
//
//  Created by GZX on 2019/11/12.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"
#import <Masonry.h>

@interface Cell()

@end

@implementation Cell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_image setContentMode:UIViewContentModeRedraw];
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        [self.contentView addSubview:_image];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.95, 250));
            make.centerX.equalTo(self);
        }];
    }
    return self;
}


@end
