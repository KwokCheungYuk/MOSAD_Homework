//
//  ViewController.m
//  HW6
//
//  Created by GZX on 2019/11/12.
//  Copyright © 2019 GZX. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"
#import <Masonry.h>

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic)UICollectionView *collectionView;
@property dispatch_queue_t downloadQueue;
@property (strong, nonatomic)NSMutableArray *urls;
@property BOOL clickLoad;
@property BOOL clickClear;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Pictures";
    _urls = [[NSMutableArray alloc]initWithCapacity:5];
    [_urls addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574077045884&di=ae6076bb09057919e94264d38d28f167&imgtype=0&src=http%3A%2F%2Fww2.sinaimg.cn%2Fmw690%2Faae48400gw1erm7bn6qz0j20i80dowio.jpg"];
    [_urls addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574076959542&di=2fee56e2be9b2fe6103a21d7b1e43f76&imgtype=0&src=http%3A%2F%2Fgss0.baidu.com%2F-Po3dSag_xI4khGko9WTAnF6hhy%2Fzhidao%2Fpic%2Fitem%2F96dda144ad345982a9b982f10df431adcbef84a5.jpg"];
    [_urls addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574076966822&di=382a0c1af8a9c36b7e4e4fc748974307&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201901%2F17%2F20190117162433_jFA5P.jpeg"];
    [_urls addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574077005513&di=e856dfb1c30f1b6b2687f2260b0798d1&imgtype=0&src=http%3A%2F%2Fwww.52tian.net%2Ffile%2Fimage%2F20150926%2F20150926140013441344.jpg"];
    [_urls addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574077670633&di=d9165700474967cedb966c5a2781ac53&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201509%2F21%2F20150921202700_dTQGn.thumb.700_0.jpeg"];
    [_urls addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1574077730864&di=b5f21365b724e5099604fc0adadf143c&imgtype=0&src=http%3A%2F%2Fn.sinaimg.cn%2Fsinacn22%2F707%2Fw904h603%2F20180902%2F0d87-hiqtcam9544956.jpg"]; _downloadQueue=dispatch_queue_create("image_downloader",DISPATCH_QUEUE_CONCURRENT);
    _clickLoad = false;
    _clickClear = false;
    [self CreateCol];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    //获取状态栏的rect
    CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
    //获取导航栏的rect
    CGRect navRect = self.navigationController.navigationBar.frame;
    [self.view addSubview:self.collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).with.offset(statusRect.size.height + navRect.size.height);
        make.size.mas_equalTo(CGSizeMake(screenBounds.size.width, screenBounds.size.height * 0.80));
    }];
    [self createBtn];
}

-(void)CreateCol{
    //创建一个layout布局类
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    //设置布局方向为垂直流布局
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //设置每个item的大小
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    layout.itemSize = CGSizeMake(screenBounds.size.width * 0.95, 250);
    //创建collectionView 通过一个布局策略layout来创建
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    //注册collectionViewCell
    //注意，此处的ReuseIdentifier 必须和 cellForItemAtIndexPath 方法中 一致 均为 cellId
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"cellId"];
    self.collectionView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:247.0/255.0 alpha:1.0];
}

//返回分区个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 6;
}

//返回每个分区的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

//返回每个item
- (Cell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = (Cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    //获取沙盒cache路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    // 拼接图片的路径
    NSString *imageFilePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat: @"%lu",indexPath.section]];
    
    NSFileManager* fm= [NSFileManager defaultManager];

    if(_clickLoad == true){
        //cell.image.backgroundColor = [UIColor whiteColor];
        if([fm fileExistsAtPath:imageFilePath] == NO){
            NSLog(@"no exits");
            [cell.image setImage:[UIImage imageNamed:@"loading.png"]];
            dispatch_async(_downloadQueue,^{
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"%@",self->_urls[indexPath.section]]];
                NSData*imageData=[NSData dataWithContentsOfURL:url];
                dispatch_async(dispatch_get_main_queue(),^{
                    [cell.image setImage:[UIImage imageWithData:imageData]];
                    [UIImageJPEGRepresentation([UIImage imageWithData:imageData], 1.0) writeToFile:imageFilePath  atomically:YES];
                });
            });
        }
        else{
            NSLog(@"exits");
            [cell.image setImage:[UIImage imageWithContentsOfFile:imageFilePath]];
        }
    }
    if(_clickClear == true){
        [cell.image setImage:nil];
    }
    return cell;
}

//每个cell的距离
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 15, 0);//分别为上、左、下、右
}

//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath{
    return NO ;
}

-(void)createBtn{
    UIButton* clearBtn =  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [clearBtn setTitle:@"清空" forState:UIControlStateNormal];
    clearBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [clearBtn.layer setMasksToBounds:YES];
    [clearBtn.layer setCornerRadius:10];
     [clearBtn setBackgroundColor:[UIColor colorWithRed:103.0/255.0 green:200.0/255.0 blue:90.0/255.0 alpha:1.0]];
    [clearBtn addTarget:self action:@selector(ClearData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 40));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
        make.centerX.equalTo(self.view);
    }];
    
    UIButton* loadBtn =  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [loadBtn setTitle:@"加载" forState:UIControlStateNormal];
    loadBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [loadBtn.layer setMasksToBounds:YES];
    [loadBtn.layer setCornerRadius:10];
     [loadBtn setBackgroundColor:[UIColor colorWithRed:103.0/255.0 green:200.0/255.0 blue:90.0/255.0 alpha:1.0]];
    [loadBtn addTarget:self action:@selector(LoadData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loadBtn];
    [loadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 40));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
        make.right.equalTo(clearBtn.mas_left).with.offset(-15);
    }];
    
    UIButton* deleteCacheBtn =  [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [deleteCacheBtn setTitle:@"删除缓存" forState:UIControlStateNormal];
    deleteCacheBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [deleteCacheBtn.layer setMasksToBounds:YES];
    [deleteCacheBtn.layer setCornerRadius:10];
     [deleteCacheBtn setBackgroundColor:[UIColor colorWithRed:103.0/255.0 green:200.0/255.0 blue:90.0/255.0 alpha:1.0]];
    [deleteCacheBtn addTarget:self action:@selector(DeleteCache) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteCacheBtn];
    [deleteCacheBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110, 40));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-20);
        make.left.equalTo(clearBtn.mas_right).with.offset(15);
    }];
}

-(void)LoadData{
    _clickLoad = true;
    _clickClear = false;
    [_collectionView reloadData];
    
}

-(void)ClearData{
    _clickLoad = false;
    _clickClear = true;
    [_collectionView reloadData];
}

-(void)DeleteCache{
    _clickLoad = false;
    _clickClear = false;
    //获取沙盒cache路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    NSFileManager* fm= [NSFileManager defaultManager];
    for(int i = 0; i < [_urls count]; i ++){
        NSString *imageFilePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat: @"%d",i]];
        [fm removeItemAtPath:imageFilePath error:nil];
    }
}
@end
