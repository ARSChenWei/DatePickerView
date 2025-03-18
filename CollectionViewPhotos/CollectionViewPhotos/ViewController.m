//
//  ViewController.m
//  CollectionViewPhotos
//
//  Created by 陈威 on 16/5/6.
//  Copyright © 2016年 ZiGuangMeiShiYun. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionVliew.h"
#import "CWLayout.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface ViewController ()
@property(nonatomic,strong)MyCollectionVliew * CollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.CollectionView = [[MyCollectionVliew alloc]initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 120) collectionViewLayout:[[CWLayout alloc]init]];
    [self.view addSubview:self.CollectionView];
    
    UIButton * button = [[UIButton alloc]init];
    button.frame = CGRectMake(0, 250, 100, 100);
    [button setTitle:@"查看数据源" forState:0];
    [button addTarget:self action:@selector(ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    
    NSLog(@"测试github的桌面客户端");
    NSLog(@"点击测试英文Git客户端");
    
    
    
    NSLog(@"github测试地址");
}

-(void)ButtonClick
{
    NSLog(@"~~~~~~查看照片数据源:%d",self.CollectionView.PhotoArray.count);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
