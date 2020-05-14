//
//  DetailPageController.m
//  DayMatters
//
//  Created by GZX on 2019/12/24.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailPageController.h"
#import <Masonry.h>
#import "Entry+CoreDataClass.h"
#import <CoreData/CoreData.h>

@interface DetailPageController()
@property (strong, nonatomic)Cell* cell;
@property (strong, nonatomic) UIView* wholeView;
@property (strong, nonatomic) UIView* confirmView;
@property (strong, nonatomic)NSManagedObjectContext* objContext;
@end

@implementation DetailPageController

-(void)initData:(Cell*)cell
    withContext:(NSManagedObjectContext*)objContext2{
    _cell = cell;
    self.title = @"Days Matter";
    _objContext = objContext2;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self navConfi];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]]];
    [self navConfi];
    [self createWholeView];
    [self createDelBtn];
    [self createConfirmView];
    
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    //还原导航栏设置
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:20]}];
}

//导航栏相关设置
-(void)navConfi{
    //设置导航栏背景颜色及标题

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:183.0/255.0 green:132.0/255.0 blue:61.0/255.0 alpha:1.0],
    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:24]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.translucent = YES;
    
}

-(void)createWholeView{
    //获取屏幕的rect
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    _wholeView = [[UIView alloc] init];
    _wholeView.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    _wholeView.layer.cornerRadius = 10;
    _wholeView.layer.masksToBounds = YES;
    [self.view addSubview:_wholeView];
    [_wholeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.90,screenBounds.size.width * 0.90));
        make.center.equalTo(self.view);
    }];
    [self createDetailLabel];
}

-(void)createDetailLabel{
    UILabel* contentLabel = [[UILabel alloc]init];
    if(_cell.isPast == false){
        //倒数颜色
        contentLabel.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:128.0/255.0 blue:194.0/255.0 alpha:1.0];
    }
    else{
        //正数颜色
        contentLabel.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:128.0/255.0 blue:14.0/255.0 alpha:1.0];
    }
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.font = [UIFont boldSystemFontOfSize:20];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = _cell.content.text;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [_wholeView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.90,screenBounds.size.width * 0.15));
        
    }];
    
    UILabel* dayLabel = [[UILabel alloc]init];
    dayLabel.backgroundColor = [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
    dayLabel.textColor = [UIColor blackColor];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.text = _cell.time.text;
    NSInteger lNumber = [dayLabel.text integerValue];
    if(lNumber < 10000){
        dayLabel.font = [UIFont boldSystemFontOfSize:130];
    }
    else if(lNumber < 100000 && lNumber >= 10000){
        dayLabel.font = [UIFont boldSystemFontOfSize:110];
    }
    else{
        dayLabel.font = [UIFont boldSystemFontOfSize:90];
    }
    [_wholeView addSubview:dayLabel];
    [dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.90,screenBounds.size.width * 0.6));
        make.top.equalTo(contentLabel.mas_bottom);
    }];
    
    UILabel* conceretLabel = [[UILabel alloc]init];
    conceretLabel.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:246.0/255.0 blue:245.0/255.0 alpha:1.0];
    conceretLabel.textColor = [UIColor grayColor];
    conceretLabel.font = [UIFont boldSystemFontOfSize:15];
    conceretLabel.textAlignment = NSTextAlignmentCenter;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableString *dateStr = [NSMutableString stringWithString: [dateFormatter stringFromDate:_cell.concreteTime]];
    NSString *weekStr = [self weekdayStringFromDate:_cell.concreteTime];
    NSMutableString *resultStr = [[NSMutableString alloc]initWithFormat:@"%@   %@", dateStr, weekStr];
    if(_cell.isPast == false){
        //倒数目标日
        conceretLabel.text = [[NSString alloc]initWithFormat:@"目标日：%@",resultStr];
    }
    else{
        //正数起始日
        conceretLabel.text = [[NSString alloc]initWithFormat:@"起始日：%@",resultStr];
    }
    
    [_wholeView addSubview:conceretLabel];
    [conceretLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.90,screenBounds.size.width * 0.15));
        make.bottom.equalTo(_wholeView.mas_bottom);
        
    }];
    
}

-(void)createDelBtn{
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"删除当前事件" forState:UIControlStateNormal];
    btn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [btn1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    //[btn1 setTitle:@"HighLight" forState:UIControlStateHighlighted];
    [btn1.layer setMasksToBounds:YES];
    [btn1.layer setCornerRadius:10];
    [btn1 setBackgroundColor:[UIColor colorWithRed:221.0/255.0 green:78.0/255.0 blue:50.0/255.0 alpha:1.0]];
    [btn1 addTarget:self action:@selector(delButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //获取屏幕的rect
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.85, 35));
        make.centerX.equalTo(self.view);
        make.top.equalTo(_wholeView.mas_bottom).with.offset(40);
    }];
}

-(void)delButtonClicked{
    //获取屏幕的rect
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^ {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        self->_confirmView.transform = CGAffineTransformTranslate(self->_confirmView.transform, 0, -screenBounds.size.height * 0.25);
    } completion:^(BOOL finished) {
                    
    }];
}

-(void)createConfirmView{
    _confirmView = [[UIView alloc]init];
    _confirmView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:237.0/255.0 blue:235.0/255.0 alpha:1.0];
    //获取屏幕的rect
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [self.view addSubview:_confirmView];
    [_confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width, screenBounds.size.height * 0.25));
        make.top.equalTo(self.view.mas_bottom);
    }];
    //确定删除按钮
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"确定删除当前事件" forState:UIControlStateNormal];
    btn1.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [btn1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [btn1 setTitleColor:[UIColor colorWithRed:238.0/255.0 green:237.0/255.0 blue:235.0/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    [btn1.layer setMasksToBounds:YES];
    [btn1.layer setCornerRadius:10];
    [btn1 setBackgroundColor:[UIColor colorWithRed:247.0/255.0 green:78.0/255.0 blue:24.0/255.0 alpha:1.0]];
    [btn1 addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_confirmView addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.9, 45));
        make.top.equalTo(_confirmView.mas_top).with.offset(30);
        make.centerX.equalTo(_confirmView);
    }];
    //取消按钮
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setTitle:@"取消" forState:UIControlStateNormal];
    btn2.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [btn2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [btn2.layer setMasksToBounds:YES];
    [btn2.layer setCornerRadius:10];
    [btn2 setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:243.0/255.0 alpha:1.0]];
    [btn2 addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_confirmView addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
       make.size.mas_equalTo(CGSizeMake(screenBounds.size.width * 0.9, 45));
       make.top.equalTo(btn1.mas_bottom).with.offset(30);
       make.centerX.equalTo(_confirmView);
    }];
    
}

-(void)confirmBtnClicked{
    NSLog(@"delete");
    //创建删除请求
    NSFetchRequest *deleRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    //删除条件
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"id == %d", _cell.ID];
    deleRequest.predicate = pre;
    //返回需要删除的对象数组
    NSArray *deleArray = [_objContext executeFetchRequest:deleRequest error:nil];
    //从数据库中删除
    for (Entry *e in deleArray) {
        [_objContext deleteObject:e];
    }
    NSError *error = nil;
    [_objContext save:&error];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancelBtnClicked{
    //获取屏幕的rect
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^ {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        self->_confirmView.transform = CGAffineTransformTranslate(self->_confirmView.transform, 0, screenBounds.size.height * 0.25);
    } completion:^(BOOL finished) {
                    
    }];
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
