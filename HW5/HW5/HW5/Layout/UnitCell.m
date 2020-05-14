//
//  UnitCell.m
//  HW5
//
//  Created by GZX on 2019/10/29.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnitCell.h"
#import <Masonry.h>

@interface UnitCell()

@end

@implementation UnitCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        //创建渐变效果
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 200, 55);
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 1);
        gradientLayer.locations = @[@(0.0),@(1.0)];//渐变点
        [gradientLayer setColors:@[(id)[[UIColor blueColor] CGColor],(id)[[UIColor greenColor] CGColor]]];//渐变数组
               
        
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        //设置圆角
        _image.layer.masksToBounds = YES;
        _image.layer.cornerRadius = 15;
        //添加渐变效果
         [_image.layer addSublayer:gradientLayer];
        [self.contentView addSubview:_image];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(200, 55));
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        [_image addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(75, 55));
            make.centerX.equalTo(self.image);
            make.centerY.equalTo(self.image);
        }];
    }
    return self;
}


@end
