//
//  ProfileViewController.m
//  LanguageLearner
//
//  Created by GZX on 2019/9/29.
//  Copyright © 2019 GZX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProfileViewController.h"

@interface ProfileViewController()

@end
@implementation ProfileViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ID"];
    }
    return _tableView;
}

//配置每个section(段）有多少row（行） cell
//默认只有一个section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

//配置多个section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;//8段
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if(indexPath.row == 0){
        cell.textLabel.text = @"用户名";
    }
    else{
        cell.textLabel.text = @"邮箱";
    }
    cell.detailTextLabel.text = @"未登录";
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    return cell;
}

-(void)login{
    self.tableView.visibleCells[0].detailTextLabel.text = @"Kwok_CheungYuk";
    self.tableView.visibleCells[1].detailTextLabel.text = @"691215689@qq.com";
}


@end
