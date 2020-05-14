//
//  MessageCell.h
//  Homework Final
//
//  Created by kjhmh2 on 2019/12/25.
//  Copyright © 2019 kjhmh2. All rights reserved.
//

#ifndef MessageCell_h
#define MessageCell_h

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) UILabel * year;

@property (nonatomic, strong) UILabel * lunar;

@property (nonatomic, strong) UILabel * detail;

@property (nonatomic, strong) UIImageView * pic;

@end

#endif /* MessageCell_h */
