//
//  TaskCell.m
//  todo
//
//  Created by guojj on 2019/12/24.
//  Copyright © 2019 guojj. All rights reserved.
//

#import "TaskCell.h"
#import "TodoViewController.h"

@interface TaskCell ()

//@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation TaskCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.layer.masksToBounds = NO;
        self->checkState = NO;
        [self createView];
        [self createCheckBox];
        [self createDDL];
        [self createDescript];
    }
    return self;
}

- (void)createView {
    _v = [[UIView alloc] init];
    _v.backgroundColor = [UIColor whiteColor];
    _v.layer.masksToBounds = YES;
    _v.layer.shadowColor = [UIColor blackColor].CGColor;
    _v.layer.shadowRadius = 2;
    _v.layer.shadowOpacity = 0.4;
    _v.layer.shadowOffset = CGSizeMake(0, 1);
    _v.layer.cornerRadius = 10.0;
    [self.contentView addSubview:_v];
    [_v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.contentView.frame.size.width+30, self.contentView.frame.size.height+20));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)showSelected {
    _v.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:0.7];
}

- (void)showDeselected {
    _v.backgroundColor = [UIColor whiteColor];
}

- (void)createCheckBox {
    _checkBox = [[UIButton alloc] init];
    [_checkBox setImage:[[UIImage imageNamed:@"未完成"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [[_checkBox imageView] setTintColor:[UIColor grayColor]];
    [_checkBox setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_checkBox addTarget:self action:@selector(switchCheckState) forControlEvents:UIControlEventTouchUpInside];
    [self.v addSubview:_checkBox];
    [_checkBox mas_makeConstraints:^(MASConstraintMaker *make) {
        CGFloat d = self.frame.size.height-8;
        make.size.mas_equalTo(CGSizeMake(d, d));
        make.left.mas_equalTo(self.v.mas_left).with.offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
}

- (void)createDescript {
    _descript = [[UILabel alloc] init];
    [_descript setFont:[UIFont systemFontOfSize:20.0]];
    [self.v addSubview:_descript];
    [_descript mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, self.frame.size.height));
        make.left.mas_equalTo(self.checkBox.mas_right).with.offset(10);
        //make.bottom.mas_equalTo(self.ddl.mas_top).with.offset(0);
        make.centerY.mas_equalTo(self.v.mas_centerY).with.offset(-8);
    }];
}

- (void)createDDL {
    _ddl = [[UILabel alloc] init];
    [_ddl setFont:[UIFont systemFontOfSize:13.0]];
    [_ddl setTextColor:[UIColor systemGrayColor]];
    [self.v addSubview:_ddl];
    [_ddl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.frame.size.width, 25));
        //make.size.mas_equalTo(CGSizeMake(20, 20));
        make.left.mas_equalTo(self.checkBox.mas_right).with.offset(10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).with.offset(12);
    }];
}

//翻转勾选状态
- (void)switchCheckState {
    if (NSFoundationVersionNumber > NSFoundationVersionNumber10_0) {
        UIImpactFeedbackGenerator *feedBackGen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [feedBackGen impactOccurred];
    }
    if (self->checkState == NO) {//从未完成改已完成
        self->checkState = YES;
    }
    else if (self->checkState == YES){//从已完成改未完成
        self->checkState = NO;
    }
    UITableView *tableView = (UITableView*)[self superview];
    NSIndexPath *indexPath = [tableView indexPathForCell:self];
    TodoViewController *tvc = [self getViewController];
    [tvc changeTask:indexPath checkState:self->checkState];
}

- (TodoViewController*)getViewController {
    for (UIView* cur = [self superview]; cur; cur = cur.superview) {
        UIResponder *curResponder = [cur nextResponder];
        if ([curResponder isKindOfClass:[TodoViewController class]]) {
            return (TodoViewController*)curResponder;
        }
    }
    return nil;
}

//设置勾选状态，在 TodoViewController 中调用
- (void)setCheckStateTo:(BOOL)checkState animate:(BOOL)animate{
    NSLog(@"setCheckStateTo%d",checkState);
    self->checkState = checkState;
    NSInteger textLength = _descript.text.length;
    if (checkState == YES) {
        //添加删除线
        NSMutableAttributedString *astr = [[NSMutableAttributedString alloc] initWithString:_descript.text];
        [astr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, textLength)];
        [astr addAttribute:NSBaselineOffsetAttributeName value:@(NSUnderlineStyleSingle) range:(NSMakeRange(0, textLength))];
        [astr addAttribute:NSForegroundColorAttributeName value:[UIColor systemGrayColor] range:(NSMakeRange(0, textLength))];
        [_descript setAttributedText:astr];
        //设置图片
        [_checkBox setImage:[[UIImage imageNamed:@"已完成"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        if (animate) {
            UIImageView *imageView = _checkBox.imageView;
            imageView.transform = CGAffineTransformMakeScale(0, 0);
            [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.2 animations: ^{
                    // key frame 0
                    imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
                }];
                [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.2 animations: ^{
                    // key frame 1
                    imageView.transform = CGAffineTransformMakeScale(1, 1);
                }];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    else if (checkState == NO) {
        //去掉删除线
        NSString *text = _descript.text;
        [_descript removeFromSuperview];
        [self createDescript];
        [_descript setText:text];
        //[_descript setAttributedText:nil];
        //设置图片
        [_checkBox setImage:[[UIImage imageNamed:@"未完成"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    }
}

- (BOOL)getCheckState {
    return checkState;
}

@end
