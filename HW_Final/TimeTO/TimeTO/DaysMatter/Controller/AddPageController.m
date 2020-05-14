//
//  AddPageController.m
//  DayMatters
//
//  Created by GZX on 2019/12/23.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddPageController.h"
#import <Masonry.h>
#import "Entry+CoreDataClass.h"

@interface AddPageController()
@property (nonatomic, strong) UIView *bgView;
//添加事件描述的view
@property (nonatomic, strong) UIView *contentView;
@property (strong, nonatomic) UIImageView *bagImg;
@property (nonatomic, strong) UITextField *contentTextField;
//添加事件时间的view
@property (nonatomic, strong) UIView *targetDayView;
@property (strong, nonatomic) UIImageView *calImg;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *targetDay;
@property (nonatomic, strong) NSDate *selectDate;
//显示选择时间的view
@property (nonatomic, strong) UIView *datePickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) NSDate* conceretDate;
@property BOOL isDisplay;

@property (nonatomic, strong) UIButton *saveBtn;

@property (strong, nonatomic)NSManagedObjectContext* objContext;
@property (strong, nonatomic)NSMutableArray* objDataSource;
@end

@implementation AddPageController

-(void)initDB:(NSManagedObjectContext *)objContext2
   withSource:(NSMutableArray *)data{
    _objContext = objContext2;
    _objDataSource = data;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.contentTextField becomeFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]]];
    self.title = @"添加新日子";
    [self navConfi];
    [self createBgView];
    [self createSaveBtn];
    [self createContentView];
    [self createSelectTimeView];
    _isDisplay = false;
    [self createDPickerView];
}

//导航栏相关设置
-(void)navConfi{
    //设置导航栏背景颜色及标题
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:123.0/255.0 blue:188.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:20]}];
    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self
    action:@selector(saveButtonClicked)];
    [rightButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

-(void)createSaveBtn{
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"保存" forState:UIControlStateNormal];
    btn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [btn1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    //[btn1 setTitle:@"HighLight" forState:UIControlStateHighlighted];
    [btn1.layer setMasksToBounds:YES];
    [btn1.layer setCornerRadius:10];
    [btn1 setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:123.0/255.0 blue:188.0/255.0 alpha:1.0]];
    [btn1 addTarget:self action:@selector(saveButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //获取屏幕的rect
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [_bgView addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.85, 35));
        make.center.equalTo(_bgView);
    }];
}

-(void)saveButtonClicked{
    _conceretDate = _selectDate;
    Entry * entry = [NSEntityDescription
    insertNewObjectForEntityForName:@"Entry"
    inManagedObjectContext:_objContext];
    entry.id = (int)_objDataSource.count;
    while(true){
        bool curIdExist = false;
        for(Entry *e in _objDataSource){
            if(e.id == entry.id){
                curIdExist = true;
                entry.id ++;
                break;
            }
        }
        if(curIdExist == false){
            break;
        }
    }
    if([_contentTextField.text  isEqual: @""]){
        entry.title = @"某天";
    }
    else{
        entry.title = _contentTextField.text;
    }
    entry.time = _conceretDate;
    //   3.保存插入的数据
    NSError *error = nil;
    [_objContext save:&error];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createBgView{
    //获取屏幕的rect
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(screenBounds.size.width * 0.025, statusRect.size.height + navRect.size.height -1 , screenBounds.size.width * 0.95, screenBounds.size.height -statusRect.size.height - navRect.size.height )];
    [_bgView setBackgroundColor:[UIColor colorWithRed:249.0/255.0 green:244.0/255.0 blue:241.0/255.0 alpha:1.0]];
    [self.view addSubview:_bgView];
}

-(void)createContentView{
    //获取屏幕的rect
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , screenBounds.size.width * 0.90, 50 )];
    [_contentView setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];
    _contentView.layer.masksToBounds= YES;
    _contentView.layer.borderWidth = 1;
    _contentView.layer.borderColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:193.0/255.0 alpha:1.0].CGColor;
    
    //图标
    _bagImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_bagImg setContentMode:UIViewContentModeRedraw];
    [_bagImg setImage:[UIImage imageNamed:@"bag.png"]];
    [_contentView addSubview:_bagImg];
    [_bagImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.equalTo(_contentView.mas_left).with.offset(5);
        make.centerY.equalTo(_contentView);
    }];
    
    //输入栏
    _contentTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _contentTextField.placeholder = @"点击这里输入事件名称";
    [_contentTextField setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];
    [_contentView addSubview:_contentTextField];
    [_contentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(210, 35));
        make.left.equalTo(_bagImg.mas_right).with.offset(5);
        make.centerY.equalTo(_contentView);
    }];
    
    [_bgView addSubview:_contentView];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.90, 50 ));
        make.top.equalTo(_bgView.mas_top).with.offset(10);
        make.centerX.equalTo(_bgView);
    }];
}

-(void)createSelectTimeView{
    //获取屏幕的rect
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    _targetDayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_targetDayView setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];
    _targetDayView.layer.masksToBounds= YES;
    _targetDayView.layer.borderWidth = 1;
    _targetDayView.layer.borderColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:193.0/255.0 alpha:1.0].CGColor;
    
    //图标
    _calImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [_calImg setContentMode:UIViewContentModeRedraw];
    [_calImg setImage:[UIImage imageNamed:@"calendar.png"]];
    [_targetDayView addSubview:_calImg];
    [_calImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.equalTo(_targetDayView.mas_left).with.offset(5);
        make.top.equalTo(_targetDayView.mas_top).with.offset(5);
    }];
    
    //UILabel目标日
    _targetDay = [[UILabel alloc]initWithFrame:CGRectMake(0,0,0,0)];
    _targetDay.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    _targetDay.textColor = [UIColor colorWithRed:138.0/255.0 green:126.0/255.0 blue:126.0/255.0 alpha:1.0];
    _targetDay.text = @"目标日";
    [_targetDayView addSubview:_targetDay];
    [_targetDay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(100, 35));
        make.left.equalTo(_calImg.mas_right).with.offset(5);
        make.top.equalTo(_calImg.mas_top).with.offset(-2);
    }];
    
    //设置时间的Label
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0,0,0)];
    _timeLabel.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    _selectDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:(@"yyyy-MM-dd")];
    NSMutableString *dateStr = [NSMutableString stringWithString: [formatter stringFromDate:_selectDate]];
    NSString *weekStr = [self weekdayStringFromDate:_selectDate];
    _selectDate = [formatter dateFromString:dateStr];
    [dateStr appendFormat:@"   %@", weekStr];
    _timeLabel.text = dateStr;
    _timeLabel.textColor = [UIColor colorWithRed:29.0/255.0 green:128.0/255.0 blue:230.0/255.0 alpha:1.0];
    _timeLabel.font = [UIFont boldSystemFontOfSize:20];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    [_targetDayView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(200, 30));
        make.centerX.equalTo(_targetDayView);
        make.bottom.equalTo(_targetDayView.mas_bottom).with.offset(-5);
    }];
    
    
    [_bgView addSubview:_targetDayView];
    [_targetDayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.90, 65 ));
        make.top.equalTo(_contentView.mas_bottom).with.offset(10);
        make.centerX.equalTo(_bgView);
    }];
    //给View添加点击手势
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(displayPicker:)];
    [_targetDayView addGestureRecognizer:tapGesture];
    //需要点击的次数
    [tapGesture setNumberOfTapsRequired:1];
    
}

-(void)displayPicker:(UITapGestureRecognizer *)gesture{
    //隐藏键盘
    [self.view endEditing:YES];
    if(_isDisplay == false){
        //TODO:弹出时间选择
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^ {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            self->_datePickerView.transform = CGAffineTransformTranslate(self->_datePickerView.transform, 0, -screenBounds.size.height * 0.38);
        } completion:^(BOOL finished) {
                        
        }];
        _isDisplay = true;
    }
    else{
        [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^ {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            self->_datePickerView.transform = CGAffineTransformTranslate(self->_datePickerView.transform, 0, screenBounds.size.height * 0.38);
        } completion:^(BOOL finished) {
                        
        }];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^ {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            self->_datePickerView.transform = CGAffineTransformTranslate(self->_datePickerView.transform, 0, -screenBounds.size.height * 0.38);
        } completion:^(BOOL finished) {
                        
        }];
    }
}

-(void)createDPickerView{
    //获取屏幕的rect
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    _datePickerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _datePickerView.backgroundColor = [UIColor whiteColor];
    //_datePickerView.layer.borderWidth = 1;
    //_datePickerView.layer.borderColor = [UIColor grayColor].CGColor;
    //_datePickerView.layer.shadowColor = [UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1.0].CGColor;
    _datePickerView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _datePickerView.layer.shadowOffset = CGSizeMake(0, -2);
    _datePickerView.layer.shadowOpacity = 1;
    _datePickerView.layer.shadowRadius = 5;
    
    //创建描述的label
    _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    _descriptionLabel.text = @"选择未来日期倒数，选择过去日期正数";
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    //_descriptionLabel.font = [UIFont systemFontOfSize:20];
    _descriptionLabel.textColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
    [_datePickerView addSubview:_descriptionLabel];
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width, 30));
        make.top.equalTo(_datePickerView.mas_top).with.offset(10);
        make.centerX.equalTo(_datePickerView);
    }];
    
    //创建datePicker
    _datePicker =[ [UIDatePicker alloc]initWithFrame:CGRectMake(0,0,0,0)];
    _datePicker.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1.0];
    _datePicker.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    _datePicker.layer.shadowOffset = CGSizeMake(0, 0);
    _datePicker.layer.shadowOpacity = 1;
    _datePicker.layer.shadowRadius = 5;
    _datePicker.layer.borderWidth = 0.5;
    _datePicker.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _datePicker.layer.cornerRadius = 5;
    _datePicker.layer.masksToBounds = YES;
    
    //设置地区: zh-中国
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    //设置日期模式(Displays month, day, and year depending on the locale setting)
    _datePicker.datePickerMode = UIDatePickerModeDate;
    // 设置当前显示时间
    [_datePicker setDate:[NSDate date] animated:YES];
    //监听DataPicker的滚动
    [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [_datePickerView addSubview:_datePicker];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.95, screenBounds.size.height * 0.28));
        make.top.equalTo(_descriptionLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(_datePickerView);
    }];
    
    [self.view addSubview:_datePickerView];
    [_datePickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width, screenBounds.size.height * 0.38));
        make.top.equalTo(self.view.mas_bottom);
        make.centerX.equalTo(self.view);
    }];
}

- (void)dateChange:(UIDatePicker *)datePicker {
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-d";

    NSString *dateStr = [formatter  stringFromDate:datePicker.date];
    _selectDate = [formatter dateFromString:dateStr];
    NSString *weekStr = [self weekdayStringFromDate:datePicker.date];
    NSMutableString *resultStr = [[NSMutableString alloc]initWithFormat:@"%@   %@", dateStr, weekStr];
    _timeLabel.text = resultStr;
}

//计算星期
-(NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

@end
