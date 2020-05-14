//
//  QuestionViewController.m
//  HW5
//
//  Created by GZX on 2019/10/29.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuestionViewController.h"
#import <Masonry.h>

@interface QuestionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UINavigationControllerDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)UIButton *ConfirmBtn;
@property (strong, nonatomic)UIButton *GoOnBtn;
@property (strong, nonatomic)__block NSArray *question;
@property (strong, nonatomic)__block NSArray *choices;
@property (strong, nonatomic)__block NSString *message;
@property (strong, nonatomic)__block NSString *correct;
@property (strong, nonatomic)NSString* answer;
@property (strong, nonatomic)UIView *display;
@property (nonatomic, strong) UILabel *displayAnswer;
@property BOOL isConfirm;
@property(strong, nonatomic) NSIndexPath* select;
@property (strong, nonatomic)NSMutableArray *totalRight;
@property(strong, nonatomic) FinishingViewController *FVC;
@end

@implementation QuestionViewController

- (void)viewDidLoad {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    _isConfirm = NO;
    
    _totalRight = [[NSMutableArray alloc]initWithCapacity:4];
    
    [self GetAllData];
    
    [self CreateCol];
    
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(350, 350));
    }];
    
    [self.view addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.collectionView.mas_top).with.offset(-40);
    }];
    
    //初始化显示答案的view
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    _display = [[UIView alloc]initWithFrame:CGRectMake(0, screenBounds.size.height, screenBounds.size.width, screenBounds.size.height * 0.3)];
    _displayAnswer = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenBounds.size.width, 30)];
    [_displayAnswer setTextColor:[UIColor whiteColor]];
    _displayAnswer.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
    [_display addSubview:_displayAnswer];
    [_displayAnswer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_display.mas_top).with.offset(10);
        make.left.mas_equalTo(_display.mas_left).with.offset(10);
    }];
    [self.view addSubview: _display];
    
    //初始化按钮
    [self CreateBtn];
    
    self.navigationController.delegate = self;
}


//从服务器GET数据
-(void) GetAllData{
    //用信号量会卡住不动
    /*
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    //发起一个get请求
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession =[NSURLSession sessionWithConfiguration:defaultConfigObject delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"https://service-p12xr1jd-1257177282.ap-beijing.apigateway.myqcloud.com/release/HW5_api?unit=%lu", self.currentUnit]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    __block NSArray *list;
    NSURLSessionDataTask *dataTask = [delegateFreeSession dataTaskWithRequest:request
                                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error == nil){
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            list = dic.allValues;
                //[self setDate:((NSDictionary*)list[0][1])];
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    [dataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"%@", list[0][1]);
     */
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://service-p12xr1jd-1257177282.ap-beijing.apigateway.myqcloud.com/release/HW5_api?unit=%lu", self.currentUnit]]];

    [request setHTTPMethod:@"GET"];

    NSString *appStartRequestStr = [NSString stringWithFormat:@""];

    [request setHTTPBody:[appStartRequestStr dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *urlSessionDataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)

    {
        if(error == nil)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            NSArray *list = dic.allValues;
            //NSLog(@"data = %@",dic);
            self->_question = [((NSDictionary*)list[0][self->_currentQuestion]) objectForKey:@"question"];
            self->_choices = [((NSDictionary*)list[0][self->_currentQuestion]) objectForKey:@"choices"];
           
        }
        dispatch_semaphore_signal(semaphore);

    }];

    [urlSessionDataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

//将答案POST到服务器
-(void)PostData{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"https://service-p12xr1jd-1257177282.ap-beijing.apigateway.myqcloud.com/release/HW5_api"]]];

    [request setHTTPMethod:@"POST"];
    NSDictionary *dic = @{@"unit": [NSString stringWithFormat: @"%lu", _currentUnit],
                          @"question": [NSString stringWithFormat: @"%lu", _currentQuestion],
                          @"answer": _answer};
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLSession *urlSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *urlSessionDataTask = [urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)

    {
        if(error == nil)
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self->_message = [dict valueForKey:@"message"];
            self->_correct = [dict valueForKey:@"data"];
           
        }
        dispatch_semaphore_signal(semaphore);

    }];

    [urlSessionDataTask resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

-(void)CreateCol{
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    layout.itemSize = CGSizeMake(285, 55);
    //创建collectionView 通过一个布局策略layout来创建
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    //注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerClass:[ChoiceCell class] forCellWithReuseIdentifier:@"cellId"];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

//创建“确定”和“继续”按钮
-(void)CreateBtn{
    _ConfirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 285, 45)];
    //0:不响应事件 1:响应事件
    _ConfirmBtn.tag = 0;
    [_ConfirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    _ConfirmBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_ConfirmBtn.layer setMasksToBounds:YES];
    [_ConfirmBtn.layer setCornerRadius:15];
    [_ConfirmBtn setBackgroundColor:[UIColor grayColor]];
    [_ConfirmBtn addTarget:self action:@selector(Confirm) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_ConfirmBtn];
    [_ConfirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(285, 45));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-40);
    }];
    
    _GoOnBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 285, 45)];
    [_GoOnBtn setTitle:@"继续" forState:UIControlStateNormal];
    _GoOnBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_GoOnBtn.layer setMasksToBounds:YES];
    [_GoOnBtn.layer setCornerRadius:15];
    [_GoOnBtn setBackgroundColor:[UIColor colorWithRed:103.0/255.0 green:200.0/255.0 blue:90.0/255.0 alpha:1.0]];
    [_GoOnBtn addTarget:self action:@selector(GoOn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_GoOnBtn];
    [_GoOnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(285, 45));
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-40);
    }];
    [_GoOnBtn setHidden:YES];
}

//点击“确定”按钮的事件
-(void)Confirm{
    if(_ConfirmBtn.tag == 1){
        _isConfirm = YES;
        [_ConfirmBtn setHidden:YES];
        [_GoOnBtn setHidden:NO];
        [self PostData];
        _displayAnswer.text = [NSString stringWithFormat:@"正确答案: %@", _correct];
        [_totalRight addObject:_message];
        if([_message isEqualToString:@"wrong"]){
            [_GoOnBtn setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:63.0/255.0 blue:51.0/255.0 alpha:1.0]];
            [_display setBackgroundColor:[UIColor colorWithRed:237.0/255.0 green:127.0/255.0 blue:128.0/255.0 alpha:1.0]];
        }
        else{
            [_display setBackgroundColor:[UIColor colorWithRed:144.0/255.0 green:238.0/255.0 blue:144.0/255.0 alpha:1.0]];

        }
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^ {
            CGRect screenBounds = [[UIScreen mainScreen] bounds];
            self->_display.transform = CGAffineTransformTranslate(self->_display.transform, 0, -screenBounds.size.height * 0.3);
        } completion:^(BOOL finished) {
                        
        }];
    }
}

//点击“继续”按钮的事件
-(void)GoOn{
    if(_currentQuestion < 3){
        _isConfirm = NO;
        _ConfirmBtn.tag = 0;
        [_ConfirmBtn setBackgroundColor:[UIColor grayColor]];
        [_ConfirmBtn setHidden:NO];
        [_GoOnBtn setHidden:YES];
        [_GoOnBtn setBackgroundColor:[UIColor colorWithRed:103.0/255.0 green:200.0/255.0 blue:90.0/255.0 alpha:1.0]];
        //刷新数据
        _currentQuestion ++;
        [self GetAllData];
        [_collectionView reloadData];
        [_titleLabel setText:[NSString stringWithFormat: @"%@", _question]];
    }
    else{
        //TODO: finish
        _FVC = [[FinishingViewController alloc]init];
        _FVC.totalRight = _totalRight;
        [self.navigationController pushViewController: _FVC animated:YES];
    }
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^ {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];
        self->_display.transform = CGAffineTransformTranslate(self->_display.transform, 0, screenBounds.size.height * 0.3);
    } completion:^(BOOL finished) {
                    
    }];
}

- (UILabel *)titleLabel {
    if(_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        //得到的题目赋值给label
        [_titleLabel setText: [NSString stringWithFormat: @"%@", _question]];
        [_titleLabel setFont: [UIFont systemFontOfSize: 20]];
        [_titleLabel setTextColor: [UIColor blackColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _titleLabel;
}


//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 4;
}
//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
//返回每个item
- (ChoiceCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChoiceCell *cell = (ChoiceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    //将得到的choicef赋值给对应的cell
    [cell.choice setText: [NSString stringWithFormat:@"%@",_choices[indexPath.section]]];
    [cell.choice setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    cell.layer.borderWidth = 0;
    cell.choice.textColor = [UIColor blackColor];
    return cell;
}


//每个cell的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, 0, 15, 0);//分别为上、左、下、右
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    //TODO
    self.navigationController.navigationBar.translucent = NO;
    ChoiceCell *cell = (ChoiceCell *)[collectionView cellForItemAtIndexPath:indexPath];
    _select = indexPath;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor colorWithRed:103.0/255.0 green:200.0/255.0 blue:90.0/255.0 alpha:1.0].CGColor;
    cell.choice.textColor = [UIColor colorWithRed:103.0/255.0 green:200.0/255.0 blue:90.0/255.0 alpha:1.0];
    [_ConfirmBtn setBackgroundColor:[UIColor colorWithRed:103.0/255.0 green:200.0/255.0 blue:90.0/255.0 alpha:1.0]];
    _ConfirmBtn.tag = 1;
    _answer = cell.choice.text;
}

//UICollectionView取消选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    ChoiceCell *cell = (ChoiceCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 0;
    cell.choice.textColor = [UIColor blackColor];
}


//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    if(_isConfirm == NO){
        return YES ;
    }
    else{
        return NO;
    }
}

@end
