//
//  FirstPageController.m
//  Homework Final
//
//  Created by kjhmh2 on 2019/12/25.
//  Copyright © 2019 kjhmh2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Masonry.h>
#import "FirstPageController.h"
#import "MessageCell.h"
#import "Clock.h"

@interface FirstPageController()

@property(nonatomic, strong) Clock * clock;

@property(nonatomic, strong) NSTimer * timer;

@property(nonatomic, strong) UITableView * tableView;

@property(nonatomic, strong) UIView * backView;

@property NSArray * store;

@property int month;

@property int day;

@end

@implementation FirstPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]]];
    
    [self CreateClock];
    [self CreateTableView];
    [self CreateBackView];
    [self navConfi];
    [self getTime];
    [self getData];
    
    [self.view addSubview: self.backView];
    [self.view addSubview: self.clock];
    [self.view addSubview: self.tableView];
    self.navigationItem.title = @"历史上的今天";
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.clock mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(100);
        make.left.equalTo(self.view).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width - 40, 80));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.clock.mas_bottom).with.offset(20);
        make.left.equalTo(self.view).with.offset(20);
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width - 40, self.view.bounds.size.height - 250));
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(40);
        make.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(self.view.bounds.size.width - 20, self.view.bounds.size.height - 80));
    }];
}

- (void)CreateClock
{
    self.clock = [[Clock alloc] init];
    self.clock.date = [NSDate date];
    self.clock.layer.cornerRadius = 5.0f;
    self.clock.layer.masksToBounds = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimeLabel) userInfo:nil repeats:true];
}

- (void)CreateTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 250) style:UITableViewStyleGrouped];
    self.tableView.layer.cornerRadius = 5.0f;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.backgroundColor = [UIColor colorWithRed: 250.0/255.0 green: 246.0/255.0 blue: 242.0/255.0 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)CreateBackView
{
    self.backView = [[UIView alloc] init];
    //self.backView.backgroundColor = [UIColor colorWithRed: 250.0/255.0 green: 246.0/255.0 blue: 242.0/255.0 alpha:1.0];
    self.backView.backgroundColor = [UIColor whiteColor];
    self.backView.layer.cornerRadius = 5.0f;
    self.backView.layer.masksToBounds = YES;
}

//导航栏相关设置
-(void)navConfi
{
    //设置导航栏背景颜色及标题
   self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:123.0/255.0 blue:188.0/255.0 alpha:1.0];
   [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
   NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:20]}];
    /*
   UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
   action:@selector(addButtonClicked)];
   [rightButtonItem setTintColor:[UIColor whiteColor]];
   self.navigationItem.rightBarButtonItem = rightButtonItem;
     */
}

- (void)updateTimeLabel
{
    self.clock.date = [NSDate date];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)getTime
{
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    self.month = (int) [dateComponent month];
    self.day = (int) [dateComponent day];
}

- (void)getData
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://www.jiahengfei.cn:33550/port/history?dispose=detail&key=jiahengfei&month=%d&day=%d", self.month, self.day]]];

    [request setHTTPMethod:@"GET"];

    NSString *appStartRequestStr = [NSString stringWithFormat:@""];

    [request setHTTPBody:[appStartRequestStr dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLSession *urlSession = [NSURLSession sharedSession];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    NSURLSessionDataTask *urlSessionDataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error == nil)
        {
            //NSString * text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            //NSLog(@"Data = %@", text);
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:&error];
            self.store = [dic valueForKey:@"data"];
            dispatch_semaphore_signal(semaphore);
        }
    }];
    [urlSessionDataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

#pragma mark UITableViewDataSource
// 每个section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.store.count;
}

// section的个数，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [NSString stringWithFormat: @"cell%ld", indexPath.row];
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier: cellID];
    if (cell == nil)
        cell = [[MessageCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellID];
    NSDictionary *dic = self.store[indexPath.row];
    //NSLog(@"%@", dic);
    [cell.year setText: [dic valueForKey:@"year"]];
    [cell.detail setText: [dic valueForKey:@"title"]];
    [cell.lunar setText: [dic valueForKey:@"lunar"]];
    NSString * picUrl = [dic valueForKey:@"pic"];
    if ([picUrl isEqualToString: @""])
    {
        //NSLog(@"NOPE");
    }
    else
    {
        NSData *imageData = [NSData dataWithContentsOfURL: [NSURL URLWithString: picUrl]];
        [cell.pic setImage: [UIImage imageWithData: imageData]];
    }
    return cell;
}

#pragma mark UITableViewDelegate
// 高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.store[indexPath.row];
    NSString * picUrl = [dic valueForKey:@"pic"];
    if ([picUrl isEqualToString: @""])
    {
        return 100;
    }
    return 250;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

// 点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[_tableView reloadData];
}

@end
