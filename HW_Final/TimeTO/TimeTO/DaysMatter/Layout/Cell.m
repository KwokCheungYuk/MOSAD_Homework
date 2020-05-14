//
//  Cell.m
//  DayMatters
//
//  Created by GZX on 2019/12/23.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cell.h"
#import <Masonry.h>

@interface MyUILabel()

@end

@implementation MyUILabel

- (void)drawTextInRect:(CGRect)rect {
//文字距离上下左右边框都有10单位的间隔
CGRect newRect = CGRectMake(rect.origin.x + 10, rect.origin.y + 10, rect.size.width - 20, rect.size.height -20);

[super drawTextInRect:newRect];

}

@end

@interface Cell()

@end

@implementation Cell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        _content=[ [MyUILabel alloc]initWithFrame:CGRectMake(25,50,250,35 )];
        _content.layer.masksToBounds = YES;
        _content.layer.cornerRadius = 8.0;
        _content.backgroundColor = [UIColor whiteColor];
        _content.text = @"某事还有";
        _content.font = [UIFont systemFontOfSize:16];
        //获取屏幕的rect
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        [self.contentView addSubview:_content];
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).with.offset((self.contentView.frame.size.width-(250+48.5+40))/2);
               //make.top.equalTo(self.contentView.mas_top).with.offset(15);
            
            make.size.mas_equalTo(CGSizeMake(250, 35));
        }];
        _day=[ [UILabel alloc]initWithFrame:CGRectMake(0,0,25,35 )];
        _day.layer.masksToBounds = YES;
        _day.layer.cornerRadius = 6.0;
        _day.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:137.0/255.0 blue:217.0/255.0 alpha:1.0];
        _day.text = @"天";
        _day.font = [UIFont boldSystemFontOfSize:16];
        _day.textColor = [UIColor whiteColor];
        _day.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_day];
        [self.day mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.content.mas_right).with.offset(48.5);
            make.top.equalTo(self.content.mas_top);
            make.size.mas_equalTo(CGSizeMake(40, 35));
        }];
        _time=[ [UILabel alloc]initWithFrame:CGRectMake(0,0,50,35 )];
        _time.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:158.0/255.0 blue:245.0/255.0 alpha:1.0];
        _time.text = @"24";
        _time.textColor = [UIColor whiteColor];
        _time.font =  [UIFont fontWithName: @"Arial-BoldMT" size:24];
        _time.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.content.mas_right).with.offset(-8);
            make.top.equalTo(self.content.mas_top);
            make.size.mas_equalTo(CGSizeMake(60, 35));
        }];
    }
    return self;
}

@end
