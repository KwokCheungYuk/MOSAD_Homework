//
//  MessageCell.m
//  Homework Final
//
//  Created by kjhmh2 on 2019/12/25.
//  Copyright © 2019 kjhmh2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry.h>
#import "MessageCell.h"

@implementation MessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
    if (self)
    {
        self.year = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.year.textAlignment = NSTextAlignmentCenter;
        [self.year setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        
        self.lunar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.lunar.textAlignment = NSTextAlignmentLeft;
        
        self.detail = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.detail.textAlignment = NSTextAlignmentLeft;
        self.detail.lineBreakMode = NSLineBreakByWordWrapping;
        self.detail.numberOfLines = 0;
        
        self.pic = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        self.backgroundColor = [UIColor colorWithRed: 250.0/255.0 green: 246.0/255.0 blue: 242.0/255.0 alpha:1.0];
        [self.contentView addSubview: self.year];
        [self.contentView addSubview: self.lunar];
        [self.contentView addSubview: self.detail];
        [self.contentView addSubview: self.pic];
        
        
        [self.year mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width / 2, 20));
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left);
        }];
        
        [self.lunar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width / 2, 20));
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.year.mas_right);
        }];
        
        [self.detail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width / 2, 80));
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.year.mas_right);
        }];
        
        [self.pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width / 2, 100));
            make.top.equalTo(self.detail.mas_bottom);
            make.left.equalTo(self.year.mas_right);
        }];
        
    }
    return self;
}

- (void)setFrame: (CGRect)frame
{
  frame.size.height -= 0;  //cell之间的间距
  [super setFrame:frame];
}

@end

