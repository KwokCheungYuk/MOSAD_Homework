//
//  HomepageController.m
//  DayMatters
//
//  Created by GZX on 2019/12/23.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomepageController.h"
#import "Cell.h"
#import "AddPageController.h"
#import "DetailPageController.h"
#import "Entry+CoreDataClass.h"
#import <CoreData/CoreData.h>
#import <Masonry.h>

@interface HomepageController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
    @property (strong, nonatomic)UICollectionView *collectionView;
    @property (strong, nonatomic)NSManagedObjectContext* objContext;
    @property (strong, nonatomic)NSMutableArray* objDataSource;
    @property BOOL isLoad;
@end

@implementation HomepageController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"更新数据");
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    NSArray *resArray = [_objContext executeFetchRequest:request error:nil];
    _objDataSource = [NSMutableArray arrayWithArray:resArray];
    [_collectionView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"load%@", _isLoad?@"yew":@"no");
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]]];
    self.navigationItem.title = @"Days Matter";
    [self navConfi];
    [self createSqlite];
    [self CreateCol];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.view addSubview:self.collectionView];
}

//导航栏相关设置
-(void)navConfi{
    //设置导航栏背景颜色及标题
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0/255.0 green:123.0/255.0 blue:188.0/255.0 alpha:1.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:20]}];
    self.navigationController.navigationBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, 2.5);
    self.navigationController.navigationBar.layer.shadowOpacity = 0.3;
    UIBarButtonItem* rightButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
    action:@selector(addButtonClicked)];
    [rightButtonItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

//创建数据库
- (void)createSqlite{
    
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
    NSString *sqlPath = [docStr stringByAppendingPathComponent:@"DaysMatter.sqlite"];
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
    
    _objContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //关联持久化助理
    _objContext.persistentStoreCoordinator = store;
}

-(void)addButtonClicked{
    NSLog(@"add entry");
    AddPageController *add = [[AddPageController alloc]init];
    [add initDB:_objContext withSource:_objDataSource];
    add.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:add animated:true];
}

-(void)CreateCol{
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //获取屏幕的rect
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    //设置每个item的大小
    layout.itemSize = CGSizeMake(screenBounds.size.width * 0.95, 35);
    //创建collectionView 通过一个布局策略layout来创建
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(screenBounds.size.width * 0.025, statusRect.size.height + navRect.size.height -1 , screenBounds.size.width * 0.95, screenBounds.size.height -statusRect.size.height - navRect.size.height ) collectionViewLayout:layout];
    //注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"cellId"];
    self.collectionView.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:239.0/255.0 blue:237.0/255.0 alpha:1.0];
}
//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _objDataSource.count;
}

//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

//返回每个item
- (Cell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = (Cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    //TODO:从数据库获取数据赋值给cell
    NSDate *date1 = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSMutableString *dateStr = [NSMutableString stringWithString: [dateFormatter stringFromDate:date1]];
    NSDate *curDate = [dateFormatter dateFromString:dateStr];
    Entry* entry = _objDataSource[indexPath.section];
    cell.ID = entry.id;
    cell.concreteTime = entry.time;
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:curDate toDate:cell.concreteTime options:0];
    NSInteger dayInt = delta.day;
    if(delta.day >= 0){
        cell.isPast = false;
    }
    else{
        cell.isPast = true;
        dayInt = -dayInt;
    }
    cell.time.text = [[NSString alloc]initWithFormat:@"%lu",dayInt];
    if(dayInt < 10000){
        cell.time.font =  [UIFont fontWithName: @"Arial-BoldMT" size:24];
    }
    if(dayInt >= 10000 && dayInt < 100000){
        cell.time.font =  [UIFont fontWithName: @"Arial-BoldMT" size:20];
    }
    else if(dayInt >= 100000){
        cell.time.font =  [UIFont fontWithName: @"Arial-BoldMT" size:16];
    }
    if(cell.isPast == false){
        //倒数
        //设置颜色
        cell.day.backgroundColor = [UIColor colorWithRed:44.0/255.0 green:137.0/255.0 blue:217.0/255.0 alpha:1.0];
        cell.time.backgroundColor = [UIColor colorWithRed:63.0/255.0 green:158.0/255.0 blue:245.0/255.0 alpha:1.0];
        //设置显示的内容
        if(delta.day == 0){
            cell.content.text = [[NSString alloc]initWithFormat:@"%@%@",entry.title,@"就是今天"];
        }
        else{
            cell.content.text = [[NSString alloc]initWithFormat:@"%@%@",entry.title,@"还有"];
        }
    }
    else{
        //正数
        //设置颜色
        cell.day.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:116.0/255.0 blue:0.0/255.0 alpha:1.0];
        cell.time.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:148.0/255.0 blue:19.0/255.0 alpha:1.0];
        //设置显示的内容
        cell.content.text = [[NSString alloc]initWithFormat:@"%@%@",entry.title,@"已经"];
    }
    cell.layer.shadowColor = [UIColor grayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(1, 1);
    cell.layer.shadowRadius = 0.5;
    cell.layer.shadowOpacity = 0.5;
    
    return cell;
}

//每个cell的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(7.5, 0, 7.5, 0);//分别为上、左、下、右
}

//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    return YES ;
}

//UICollectionViewCell被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    //TODO
    NSLog(@"cell%lu clicked",indexPath.section);
    Cell *cell = (Cell *)[collectionView cellForItemAtIndexPath:indexPath];
    DetailPageController *d1 = [[DetailPageController alloc]init];
    [d1 initData:cell withContext:_objContext];
    d1.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:d1 animated:YES];
}

@end
