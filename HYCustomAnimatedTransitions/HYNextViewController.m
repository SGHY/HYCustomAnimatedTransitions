//
//  HYNextViewController.m
//  HYCustomAnimatedTransitions
//
//  Created by 上官惠阳 on 2018/10/9.
//  Copyright © 2018年 上官惠阳. All rights reserved.
//

#import "HYNextViewController.h"

@interface HYNextViewController ()<HYTransitionsDelegate,HYModalTransitionsDelegate>

@end

@implementation HYNextViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
    // Do any additional setup after loading the view.
}
- (void)setTransitions:(HYTransitions *)transitions
{
    _transitions = transitions;
    transitions.delegate = self;
}
- (void)setModalTrans:(HYModalTransitions *)modalTrans
{
    _modalTrans = modalTrans;
    modalTrans.delegate = self;
}
- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic"]];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
        _imageView = imageView;
    }
    return _imageView;
}
#pragma mark -- HYTransitionsDelegate
- (void)pushCompleteTransition
{
    self.imageView.frame = self.transitions.pushToFrame;
    [self.view addSubview:self.imageView];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width - 80, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"侧滑退出";
    [self.view addSubview:label];
}
#pragma mark -- HYModalTransitionsDelegate
- (void)presentCompleteTransition
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width - 80, 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"侧滑退出";
    [self.view addSubview:label];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
