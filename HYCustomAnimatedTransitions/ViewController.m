//
//  ViewController.m
//  HYCustomAnimatedTransitions
//
//  Created by 上官惠阳 on 2018/10/9.
//  Copyright © 2018年 上官惠阳. All rights reserved.
//

#import "ViewController.h"
#import "HYNextViewController.h"
#import "HYTransitions.h"
#import "HYModalTransitions.h"

/***  当前屏幕宽度 */
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width
/***  当前屏幕高度 */
#define kScreenHeight  [[UIScreen mainScreen] bounds].size.height
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((kScreenWidth - 100)/2, (kScreenHeight - 100)/2 - 150, 100, 100);
    btn.backgroundColor = [UIColor yellowColor];
    [btn setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake((kScreenWidth - 100)/2, (kScreenHeight - 100)/2, 100, 100);
    btn1.backgroundColor = [UIColor greenColor];
    [btn1 setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];

    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn2 setImage:[UIImage imageNamed:@"pic"] forState:UIControlStateNormal];
    btn2.frame = CGRectMake((kScreenWidth - 100)/2, (kScreenHeight - 100)/2 + 150, 100, 100);
    btn2.backgroundColor = [UIColor orangeColor];
    [btn2 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}
- (void)clickAction:(UIButton *)btn
{
    //demo1
    HYTransitions *trans = [[HYTransitions alloc] init];
    trans.pushFromView = btn;
    trans.pushToFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    self.navigationController.delegate = trans;

    HYNextViewController *nextVc = [[HYNextViewController alloc] init];
    nextVc.transitions = trans;
    trans.popFromView = nextVc.imageView;
    [self.navigationController pushViewController:nextVc animated:YES];

    //demo2
//    HYNextViewController *nextVc = [[HYNextViewController alloc] init];
//    HYModalTransitions *trans = [[HYModalTransitions alloc] init];
//    trans.fromVc = self;
//    trans.toVc = nextVc;
//    nextVc.modalTrans = trans;
//    [self presentViewController:nextVc animated:YES completion:nil];
}

@end
