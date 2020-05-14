//
//  LearningViewController.m
//  LanguageLearner
//
//  Created by GZX on 2019/9/28.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LearningViewController.h"

@interface LearningViewController(){
    NSMutableArray  *_professionArray;//cell模型数组
    NSMutableArray  *_selectArray;    //已选中的cell数组
}
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation LearningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     _selectArray = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 0.06* self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ID"];
    }
    return _tableView;
}

//配置每个section(段）有多少row（行） cell
//默认只有一个section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

//配置多个section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 8;//8段
}


//每行显示什么东西
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //给每个cell设置ID号（重复利用时使用）
    NSString *cellID = [NSString stringWithFormat:@"Cell%ld%ld", indexPath.section, indexPath.row];
    
    //从tableView的一个队列里获取一个cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    //判断队列里面是否有这个cell 没有自己创建，有直接使用
    if (cell == nil) {
        //没有,创建一个
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"unit %ld", indexPath.row + 1];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryCheckmark){
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return indexPath;
    
}

//某个cell被点击
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消选择
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 30;
    }
    return 20;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"TOUR %ld", section + 1];
    
}

@end
