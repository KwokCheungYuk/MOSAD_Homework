//
//  LanguageCell.m
//  LanguageLearner
//
//  Created by GZX on 2019/9/27.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LanguageCell.h"
#import <Masonry.h>

@interface LanguageCell()

@end

@implementation LanguageCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _image.layer.masksToBounds = YES;
        _image.layer.cornerRadius = 20;
        _image.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_image];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(105, 85));
            make.centerX.equalTo(self);
            make.top.equalTo(self.mas_top).with.offset(40);
        }];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor blackColor];
        [_title setFont: [UIFont systemFontOfSize: 18]];
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 75));
            make.centerX.equalTo(self.image);
            make.top.equalTo(self.image.mas_top).with.offset(-58);
        }];
    }
    return self;
}


@end
