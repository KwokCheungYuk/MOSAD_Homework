//
//  MusicViewController.m
//  AlarmClock
//
//  Created by huangyifei on 2019/12/26.
//  Copyright © 2019 huangyifei. All rights reserved.
//

#import "MusicViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface MusicViewController () {
    SystemSoundID _currentID;
    NSInteger _row;
}

@property (nonatomic, strong) NSArray *musicList;
@property (nonatomic, strong) AVPlayer *player;


@end

@implementation MusicViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"铃声";
    
    _musicList = @[@"ring1.caf",
                   @"ring2.caf",
                   @"ring3.caf",
                   @"ring4.caf",
                   @"ring5.caf",
                   @"ring6.caf"];
    
    if (self.data) {
        _row = [_musicList indexOfObject:self.data];
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _musicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdf"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIdf"];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.tintColor = [UIColor darkGrayColor];
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (indexPath.row == _row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    cell.textLabel.text = _musicList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.accessoryType = UITableViewCellAccessoryNone;
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (self.block) {
        self.block(_musicList[indexPath.row]);
    }

    [self playWithIndex:indexPath.row];
}

- (void)playWithIndex:(NSInteger)index {

    NSURL *url = [[NSBundle mainBundle] URLForAuxiliaryExecutable:_musicList[index]];
    
    AVPlayerItem *playerItem = [[AVPlayerItem alloc]initWithURL:url];
    // 播放当前资源
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    [self.player play];
    
    //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player pause];

}

- (AVPlayer *)player {
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
        _player.volume = 1.0; // 默认最大音量
    }
    return _player;
}


@end
