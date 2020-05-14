//
//  TodoViewController.m
//  todo
//
//  Created by guojj on 2019/12/23.
//  Copyright © 2019 guojj. All rights reserved.
//

#import "TodoViewController.h"
#import "TaskCell.h"
#import "TaskTableView.h"
#import <Masonry.h>
#import <CoreData/CoreData.h>
#import "Task+CoreDataClass.h"

@interface TodoViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>{
    NSInteger tasksCount;
    NSInteger curInputState;    //0 for add, 1 for modify
    NSInteger selectRowIndex;
    NSInteger isSettingTime;
    CGFloat keyBoardH;
}

@property (nonatomic, strong) UIView *todayPanel;

@property (nonatomic, strong) TaskTableView *taskTableView;

@property (nonatomic, strong) NSArray *ts;

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;

//@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UIView *panel;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) NSString *tempInput;

@property (nonatomic, strong) UIButton *setTimeButton;

@property (nonatomic, strong) UIView *pickDatePanel;

@property (nonatomic, strong) UIDatePicker *datepicker;

@property (nonatomic, strong) NSDate *tempDate;

@property (nonatomic, strong) NSManagedObjectContext *objContext;

@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation TodoViewController

- (void)viewDidLoad {
    [self initData];
    [self getData];
    _tempInput = [[NSString alloc] init];
    _datepicker = [[UIDatePicker alloc] init];
    [_datepicker setDatePickerMode:UIDatePickerModeTime];
    [_datepicker setDate:[self getDefaultDDL]];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    _datepicker.locale = locale;
    isSettingTime = 0;
    self.navigationItem.title = @"我的一天";
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.3;
    self.navigationController.navigationBar.layer.shadowRadius = 2;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2.5);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:20]}];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0/255.0 green:123/255.0 blue:188/255.0 alpha:1.0];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]]];
    [self createTodayPanel];
    [self createTableView];
    [self createAddButton];
    [self createInputField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditing:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)initData {
    //1、创建模型对象
    //获取模型路径
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TimeTO" withExtension:@"momd"];
    //根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    //2、创建持久化存储助理：数据库
    //利用模型对象创建助理对象
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    //数据库的名称和路径
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"Todo.sqlite"];
    NSLog(@"数据库 path = %@", sqlPath);
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
    
    NSError *error = nil;
    //设置数据库相关信息 添加一个持久化存储库并设置存储类型和路径，NSSQLiteStoreType：SQLite作为存储库
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
    
    if (error) {
        NSLog(@"添加数据库失败:%@",error);
    } else {
        NSLog(@"添加数据库成功");
    }
    
    //3、创建上下文 保存信息 操作数据库
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //关联持久化助理
    context.persistentStoreCoordinator = store;
    
    _objContext = context;
}

- (void)getData {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Task"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"ddl" ascending:YES];
    //按日期排序
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    NSError *error;
    _ts = [_objContext executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"获取Task失败");
    } else {
        NSLog(@"获取Task个数:%ld",_ts.count);
    }
}

- (void)createTodayPanel {
    CGFloat navigationBarAndStatusBarHeight = self.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
    _todayPanel = [[UIView alloc] init];
    [self.view addSubview:_todayPanel];
    _todayPanel.backgroundColor = [UIColor whiteColor];
    [_todayPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width * 0.95, self.view.frame.size.height/8));
        make.top.mas_equalTo(self.view.mas_top).with.offset(navigationBarAndStatusBarHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    _todayPanel.layer.shadowColor = [UIColor blackColor].CGColor;
    _todayPanel.layer.shadowRadius = 2;
    _todayPanel.layer.shadowOpacity = 0.3;
    _todayPanel.layer.shadowOffset = CGSizeMake(0.2, 0.2);
    UILabel *dateLabel = [[UILabel alloc] init];
    [_todayPanel addSubview:dateLabel];
    [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width * 0.85, 100));
        make.centerX.mas_equalTo(self.todayPanel.mas_centerX);
        make.top.mas_equalTo(self.todayPanel.mas_top).with.offset((self.view.frame.size.height/8-100)/2);
    }];
    dateLabel.textColor = [UIColor blackColor];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh_cn"]];
    [formatter setDateFormat:@"MM月d日 ccc"];
    NSDate *date = [NSDate date];
    dateLabel.text = [formatter stringFromDate:date];
    
    [dateLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
}

- (void)createTableView {
    _taskTableView = [[TaskTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
    _taskTableView.delegate = self;
    _taskTableView.dataSource = self;
    _taskTableView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:1.0];
    _taskTableView.layer.shadowColor = [UIColor blackColor].CGColor;
    _taskTableView.layer.shadowRadius = 2;
    _taskTableView.layer.shadowOpacity = 0.3;
    _taskTableView.layer.shadowOffset = CGSizeMake(0.2, 0.2);
    _taskTableView.layer.cornerRadius = 5.0;
    _taskTableView.layer.masksToBounds = YES;
    _taskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_taskTableView];
    [_taskTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width * 0.95, self.view.frame.size.height*0.8));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.todayPanel.mas_bottom).with.offset(-5);
    }];
    //点击空白部分退出编辑
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBlankSpace)];
    _tap.cancelsTouchesInView = NO;
    [_taskTableView addGestureRecognizer:_tap];
}

- (void)createAddButton {
    _rightButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask)];
    [_rightButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = _rightButtonItem;
    
    _panel = [[UIView alloc] init];
    _panel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_panel];
    [_panel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, 400));
        make.top.mas_equalTo(self.view.mas_bottom).with.offset(-80);
    }];
    
//    _addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [_addButton.layer setCornerRadius:10.0];
//    _addButton.layer.shadowColor = [UIColor blackColor].CGColor;
//    _addButton.layer.shadowRadius = 2;
//    _addButton.layer.shadowOpacity = 0.3;
//    _addButton.layer.shadowOffset = CGSizeMake(0, 0.2);
//    [_addButton setTitle:@"+ 添加任务" forState:UIControlStateNormal];
//    [_addButton setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:123.0/255.0 blue:188.0/255.0 alpha:1.0]];
//    [_addButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
//    //[_addButton.layer setMasksToBounds:YES];
//    [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_addButton addTarget:self action:@selector(addTask) forControlEvents:UIControlEventTouchUpInside];
//    [_panel addSubview:_addButton];
//    [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        int width = self.view.frame.size.width;
//        make.size.mas_equalTo(CGSizeMake(width*0.85, 45));
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-60);
//    }];
}

- (void)createInputField {
    _textField = [[UITextField alloc] init];
    _textField.delegate = self;
    _textField.backgroundColor = [UIColor whiteColor];
    
    _setTimeButton = [[UIButton alloc] init];
    //[_setTimeButton setBackgroundColor:[UIColor redColor]];
    [_setTimeButton setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_setTimeButton setImage:[UIImage imageNamed:@"设置时间"] forState:UIControlStateNormal];
}

//点击 addButton
- (void)addTask {
    NSLog(@"创建任务");
    [_rightButtonItem setEnabled:NO];
    //[_addButton removeTarget:self action:@selector(addTask) forControlEvents:UIControlEventTouchUpInside];
    [_taskTableView setAllowsSelection:NO];
    curInputState = 0;
    _textField.placeholder = @"添加任务...";
    [_textField setText:_tempInput];
    [_panel addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        int width = self.view.frame.size.width - 40;
        make.size.mas_equalTo(CGSizeMake(width-30, 50));
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-20);
        make.left.equalTo(self.view.mas_left).with.offset(self.view.frame.size.width/2-width/2);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditing:) name:UIKeyboardWillShowNotification object:nil];
    [_textField becomeFirstResponder];//直接进入编辑
    [_panel addSubview:_setTimeButton];
    [_setTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.equalTo(self.textField.mas_right).with.offset(10);
        make.centerY.equalTo(self.textField.mas_centerY);
    }];
    [_setTimeButton addTarget:self action:@selector(setTime) forControlEvents:UIControlEventTouchUpInside];
}

//点击 TaskCell

- (void)changeTask {
    NSLog(@"修改任务");
    [_rightButtonItem setEnabled:NO];
    //[_addButton removeTarget:self action:@selector(addTask) forControlEvents:UIControlEventTouchUpInside];
    [_taskTableView setAllowsSelection:NO];
    curInputState = 1;
    _textField.placeholder = @"修改任务...";
    [_textField setText:_tempInput];
    [_panel addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        int width = self.view.frame.size.width - 40;
        make.size.mas_equalTo(CGSizeMake(width-30, 50));
        make.bottom.mas_equalTo(self.view.mas_bottom).with.offset(-20);
        make.left.equalTo(self.view.mas_left).with.offset(self.view.frame.size.width/2-width/2);
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditing:) name:UIKeyboardWillShowNotification object:nil];
    [_textField becomeFirstResponder];//直接进入编辑
    
    [_panel addSubview:_setTimeButton];
    [_setTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(35, 35));
        make.left.equalTo(self.textField.mas_right).with.offset(10);
        make.centerY.equalTo(self.textField.mas_centerY);
    }];
    [_setTimeButton addTarget:self action:@selector(setTime) forControlEvents:UIControlEventTouchUpInside];
}

- (void)startEditing:(NSNotification *)notification {
    CGRect keyBoardRect = [(notification.userInfo[UIKeyboardFrameEndUserInfoKey]) CGRectValue];
    CGFloat keyBoardHeight = keyBoardRect.size.height;
    keyBoardH = keyBoardHeight;
    //_addButton.alpha = 0.0;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.panel.transform = CGAffineTransformTranslate(self.panel.transform, 0, -(keyBoardHeight-10));
        self.panel.backgroundColor = [UIColor whiteColor];
        self.textField.alpha = 1.0;
        self.setTimeButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        NSLog(@"开始编辑");
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEditing:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)endEditing:(NSNotification *)notification {
    CGRect keyBoardRect = [(notification.userInfo[UIKeyboardFrameBeginUserInfoKey]) CGRectValue];
    CGFloat keyBoardHeight = keyBoardRect.size.height;
    keyBoardH = keyBoardHeight;
    [self.setTimeButton removeFromSuperview];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.panel.transform = CGAffineTransformTranslate(self.panel.transform, 0, (keyBoardHeight-10));
        self.textField.alpha = 0.0;
        self.panel.backgroundColor = [UIColor clearColor];
        //self.addButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.textField removeFromSuperview];
        if (self->isSettingTime == 0) {   //没有在设置时间
            [self.taskTableView setAllowsSelection:YES];
            NSLog(@"设置cell可选");
        }
        NSLog(@"结束编辑");
    }];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startEditing:) name:UIKeyboardWillShowNotification object:nil];
}

//计算默认时间，默认为当天23点59分
- (NSDate *)getDefaultDDL {
    NSDate *now = [NSDate date];
    NSDateComponents *comp = [[NSDateComponents alloc] init];
    NSCalendar *cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [comp setMonth:[cal component:NSCalendarUnitMonth fromDate:now]];
    [comp setDay:[cal component:NSCalendarUnitDay fromDate:now]];
    [comp setHour:23];
    [comp setMinute:59];
    NSDate *defaultDDL = [cal dateFromComponents:comp];
    return defaultDDL;
}

//点击设置日期按钮
- (void)setTime {
    self.tabBarController.tabBar.hidden = YES;
    self->isSettingTime = 1;
    [_taskTableView removeGestureRecognizer:_tap];
    _tempInput = _textField.text;
    [_textField resignFirstResponder];
    _pickDatePanel = [[UIView alloc] init];
    [self.view addSubview:_pickDatePanel];
    _pickDatePanel.backgroundColor = [UIColor whiteColor];
    [_pickDatePanel mas_makeConstraints:^(MASConstraintMaker *make) {
        NSLog(@"%lf",self->keyBoardH);
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width, self->keyBoardH+60));
        make.top.mas_equalTo(self.view.frame.size.height);
    }];
    [_pickDatePanel addSubview:_datepicker];
    [_datepicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.view.frame.size.width - 20, self->keyBoardH-30));
        make.centerX.mas_equalTo(self.pickDatePanel.mas_centerX);
        make.centerY.mas_equalTo(self.pickDatePanel.mas_centerY);
    }];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.layer.cornerRadius = 5.0;
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    doneButton.backgroundColor = [UIColor colorWithRed:223/255.0 green:226/255.0 blue:230/255.0 alpha:1.0];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_pickDatePanel addSubview:doneButton];
    [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65, 35));
        make.top.mas_equalTo(self.pickDatePanel.mas_top).with.offset(10);
        make.right.mas_equalTo(self.pickDatePanel.mas_right).with.offset(-15);
    }];
    [doneButton addTarget:self action:@selector(didSetTime) forControlEvents:UIControlEventTouchUpInside];
    
    //调出面板
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.pickDatePanel.transform = CGAffineTransformTranslate(self.pickDatePanel.transform, 0, -self->keyBoardH-60);
    } completion:^(BOOL finished) {
        NSLog(@"时间面板打开");
    }];
    
    NSLog(@"点击设置时间按钮");
}

//点击时间设置完成按钮
- (void)didSetTime {
    self.tabBarController.tabBar.hidden = NO;
    self->isSettingTime = 0;
    [_taskTableView addGestureRecognizer:_tap];
    _tempDate = _datepicker.date;
    NSLog(@"选择时间 %@",_tempDate);
    //关闭面板
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.pickDatePanel.transform = CGAffineTransformTranslate(self.pickDatePanel.transform, 0, 300);
    } completion:^(BOOL finished) {
        NSLog(@"时间面板关闭");
        [self.pickDatePanel removeFromSuperview];
    }];
    if (curInputState == 0) {
        [self addTask];
    }
    else if (curInputState == 1) {
        [self changeTask];
    }
    NSLog(@"完成时间设置");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"touchesBegan");
    [self touchBlankSpace];
}

- (void)touchBlankSpace {
    if (self->curInputState == 1) {
        [_taskTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:selectRowIndex inSection:0] animated:YES];
        TaskCell *cell = [_taskTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectRowIndex inSection:0]];
        [cell showDeselected];
        NSLog(@"showDeselected, tableAllowSelection:%d",_taskTableView.allowsSelection);
        [_datepicker setDate:[self getDefaultDDL]];
        self.tempInput = @"";
    }
    else if (self->curInputState == 0) {
        self.tempDate = [self.datepicker date];
        self.tempInput = self.textField.text;
    }
    [_rightButtonItem setEnabled:YES];
    //[_addButton addTarget:self action:@selector(addTask) forControlEvents:UIControlEventTouchUpInside];
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_taskTableView setAllowsSelection:YES];
    NSLog(@"curInputState=%ld",curInputState);
    NSLog(@"%@",_tempInput);
    _tempInput = textField.text;
    _tempDate = [_datepicker date];
    BOOL doSomething = NO;
    if (curInputState == 0) {
        if (_tempInput.length > 0) {    //add
            doSomething = YES;
            //插入数据
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"Task" inManagedObjectContext:_objContext];
            Task *task = [[Task alloc] initWithEntity:entity insertIntoManagedObjectContext:_objContext];
            task.ddl = _tempDate;
            task.descript = _tempInput;
            task.isFinished = NO;
            __autoreleasing NSError *error;
            [_objContext save:&error];
            //更新数组
            [self getData];
            if (error) {
                NSLog(@"[添加任务失败]");
            } else {
                NSLog(@"[添加任务成功]descript:%@, ddl:%@, isFinished:%d",task.descript,task.ddl,task.isFinished);
            }
        }
    }
    else if (curInputState == 1) {  //modify
        doSomething = YES;
        Task *task = [_ts objectAtIndex:selectRowIndex];
        task.descript = _tempInput;
        task.ddl = _tempDate;
        TaskCell *cell = [_taskTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectRowIndex inSection:0]];
        [cell showDeselected];
        __autoreleasing NSError *error;
        [_objContext save:&error];
        //更新数组
        [self getData];
        if (!error) {
            NSLog(@"[修改任务]descript:%@, ddl:%@, isFinished:%d",task.descript,task.ddl,task.isFinished);
        }
    }
    [_taskTableView reloadData];
    _tempInput = @"";
    [_datepicker setDate:[self getDefaultDDL]];
    [textField resignFirstResponder];
    if (doSomething && NSFoundationVersionNumber > NSFoundationVersionNumber10_0) {
        UIImpactFeedbackGenerator *feedBackGen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [feedBackGen impactOccurred];
    }
    [_rightButtonItem setEnabled:YES];
    //[_addButton addTarget:self action:@selector(addTask) forControlEvents:UIControlEventTouchUpInside];
    return YES;
}

- (void)changeTask:(NSIndexPath *)indexPath checkState:(BOOL)checkState {
    NSInteger row = indexPath.row;
    Task *task = [_ts objectAtIndex:row];
    task.isFinished = checkState;
    __autoreleasing NSError *error;
    [_objContext save:&error];
    //更新数组
    [self getData];
    TaskCell *cell = [_taskTableView cellForRowAtIndexPath:indexPath];
    [cell setCheckStateTo:checkState animate:YES];
    //[_taskTableView reloadData];
    if (!error) {
        NSLog(@"[修改任务]descript:%@, ddl:%@, isFinished:%d",task.descript,task.ddl,task.isFinished);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _ts.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    TaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (cell == nil) {
        cell = [[TaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
    }
    Task *task = [_ts objectAtIndex:row];
    //设置任务
    cell.descript.text = task.descript;
    //设置时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"H时m分"];
    NSDate *date = task.ddl;
    [cell.ddl setText:[formatter stringFromDate:date]];
    [cell setCheckStateTo:task.isFinished animate:NO];
    return cell;
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        //弹出提示框确认是否删除
        NSLog(@"[正在进行删除操作]curInputState = %ld",self->curInputState);
        if (NSFoundationVersionNumber > NSFoundationVersionNumber10_0) {
            UIImpactFeedbackGenerator *feedBackGen = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleSoft];
            [feedBackGen impactOccurred];
        }
        if (self->curInputState == 1) {
            self.tempDate = [self getDefaultDDL];
            self.tempInput = @"";
        }
        else if (self->curInputState == 0) {
            self.tempDate = [self.datepicker date];
            self.tempInput = self.textField.text;
        }
        Task *task = [self.ts objectAtIndex:indexPath.row];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"将永久删除\"%@\"",task.descript] preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *doDelete = [UIAlertAction actionWithTitle:@"删除任务" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.objContext deleteObject:[self.ts objectAtIndex:indexPath.row]];
            __autoreleasing NSError *error;
            [self.objContext save:&error];
            if (error) {
                NSLog(@"删除失败");
            } else {
                NSLog(@"删除成功");
            }
            [self getData];
            [self.taskTableView reloadData];
        }];
        UIAlertAction *doCancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertVC addAction:doDelete];
        [alertVC addAction:doCancle];
        if (self->isSettingTime == 1) {
            self->isSettingTime = 0;
            [self didSetTime];
        }
        [self presentViewController:alertVC animated:YES completion:nil];
        completionHandler (YES);
    }];
    [deleteRowAction setTitle:@"删除"];
    [deleteRowAction setBackgroundColor:[UIColor redColor]];
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskCell *cell = [_taskTableView cellForRowAtIndexPath:indexPath];
    [cell showSelected];
    selectRowIndex = indexPath.row;
    NSLog(@"选中任务:%ld",selectRowIndex);
    Task *task = [_ts objectAtIndex:selectRowIndex];
    _tempInput = task.descript;
    [_datepicker setDate:task.ddl];
    [self changeTask];
}

@end
