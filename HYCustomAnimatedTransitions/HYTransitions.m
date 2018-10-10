//
//  HYTransitions.m
//  HYCustomAnimatedTransitions
//
//  Created by 上官惠阳 on 2018/10/9.
//  Copyright © 2018年 上官惠阳. All rights reserved.
//

#import "HYTransitions.h"

@interface HYTransitions ()
@property (assign, nonatomic) HYTransitionsType transitionsType;
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *percentDrivenTransition;
@property (strong, nonatomic) UINavigationController *navigationController;
@end
@implementation HYTransitions
- (void)dealloc
{
    NSLog(@"delloc ------ %@",self);
}
#pragma mark -- UIViewControllerAnimatedTransitioning
//指定转场动画持续的时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.55;
}
//转场动画的具体内容  
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.transitionsType == HYTransitionsPush) {
        [self pushAnimation:transitionContext];
    }else if (self.transitionsType == HYTransitionsPop){
        [self popAnimation:transitionContext];
    }
}
#pragma mark -- privateMothods
- (void)pushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //1.获取动画的源控制器和目标控制器
    //UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    //2.创建一个pushFromView的截图，并把pushFromView隐藏，造成使用户以为移动的就是pushFromView的假象
    UIView *snapshotView = [self.pushFromView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [containerView convertRect:self.pushFromView.frame fromView:self.pushFromView.superview];
    self.pushFromView.hidden = YES;

    //3.设置目标控制器的位置，并把透明度设为0，在后面的动画中慢慢显示出来变为1
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];
    toVc.view.alpha = 0;

    //4.都添加到 containerView 中。注意顺序不能错了
    [containerView addSubview:toVc.view];
    [containerView addSubview:snapshotView];

    //5.执行动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        snapshotView.frame = self.pushToFrame;
        toVc.view.alpha = 1;
    } completion:^(BOOL finished) {
        self.pushFromView.hidden = NO;
        [snapshotView removeFromSuperview];

        //一定要记得动画完成后执行此方法，让系统管理 navigation
        [transitionContext completeTransition:YES];
        //拿到navigationController
        self.navigationController = toVc.navigationController;
        //在toVc.view上添加侧滑手势
        [self addPanGesAtView:toVc.view];
        if (self.delegate && [self.delegate respondsToSelector:@selector(pushCompleteTransition)]) {
            [self.delegate pushCompleteTransition];
        }
    }];
}
- (void)popAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    //1.获取动画的源控制器和目标控制器
    UIViewController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];

    //2.创建一个popFromView的截图，并把popFromView隐藏，造成使用户以为移动的就是popFromView的假象
    UIView *snapshotView = [self.popFromView snapshotViewAfterScreenUpdates:NO];
    snapshotView.frame = [containerView convertRect:self.popFromView.frame fromView:self.popFromView.superview];
    self.popFromView.hidden = YES;
    self.pushFromView.hidden = YES;

    //3.设置目标控制器的位置
    toVc.view.frame = [transitionContext finalFrameForViewController:toVc];

    //4.都添加到 containerView 中。注意顺序不能错了
    [containerView insertSubview:toVc.view belowSubview:fromVc.view];
    [containerView addSubview:snapshotView];

    //5.执行动画
    CGRect popToFrame = [containerView convertRect:self.pushFromView.frame fromView:self.pushFromView.superview];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        snapshotView.frame = popToFrame;
        fromVc.view.alpha = 0;
    } completion:^(BOOL finished) {
        self.pushFromView.hidden = NO;
        self.popFromView.hidden = NO;
        [snapshotView removeFromSuperview];

        //一定要记得动画完成后执行此方法，让系统管理 navigation
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}
#pragma mark -- 添加
- (void)addPanGesAtView:(UIView *)view
{
    UIScreenEdgePanGestureRecognizer *panGes = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    panGes.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:panGes];
}
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)panGes
{
    UIView *view = panGes.view;
    CGFloat progress = [panGes translationInView:view].x / [UIScreen mainScreen].bounds.size.width;
    if (panGes.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [UIPercentDrivenInteractiveTransition new];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (panGes.state == UIGestureRecognizerStateChanged){
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    }else if (panGes.state == UIGestureRecognizerStateCancelled || panGes.state == UIGestureRecognizerStateEnded){
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        }else{
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
    }
}
#pragma mark -- UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        self.transitionsType = HYTransitionsPush;
        return self;
    }else if(operation == UINavigationControllerOperationPop){
        self.transitionsType = HYTransitionsPop;
        return self;
    }
    return nil;
}
- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if (self.transitionsType == HYTransitionsPop) {
        return self.percentDrivenTransition;
    }
    return nil;
}
@end
