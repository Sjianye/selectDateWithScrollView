//
//  ViewController.m
//  test
//
//  Created by 改车吧 on 16/12/2.
//  Copyright © 2016年 jianye. All rights reserved.
//

#import "ViewController.h"
#import "SelectDateView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    SelectDateView *view = [[SelectDateView alloc] init];
    
    view.frame = CGRectMake(0, 200, [UIScreen mainScreen].bounds.size.width, 60);
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < 12; i ++) {
        NSString *str = [NSString stringWithFormat:@"%d",i + 1];
        [array addObject:str];
    }
    view.dataArray = array;
    view.selectIndex = 12;
    view.selectViewBlock = ^(NSInteger number){
        NSLog(@"%ld",number);
    };
    [self.view addSubview:view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
