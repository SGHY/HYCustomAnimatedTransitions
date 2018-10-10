//
//  HYModalTransitions.m
//  HYCustomAnimatedTransitions
//
//  Created by 上官惠阳 on 2018/10/10.
//  Copyright © 2018年 上官惠阳. All rights reserved.
//

#import "HYModalTransitions.h"
@interface HYModalTransitions ()
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *percentDrivenTransition;
@end
@implementation HYModalTransitions
- (void)dealloc
{
    NSLog(@"delloc ------ %@",self);
}
#pragma mark -- UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.transitionsType = HYModalPresent;
    return self;
}
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.transitionsType = HYModalDismiss;
    return self;
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.percentDrivenTransition;
}
- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator
{
    return self.percentDrivenTransition;
}
#pragma mark -- UIViewControllerAnimatedTransitioning
//指定转场动画持续的时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.8;
}
//转场动画的具体内容
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.transitionsType == HYModalPresent) {
        [self presentAnimation:transitionContext];
    }else if (self.transitionsType == HYModalDismiss){
        [self dismissAnimation:transitionContext];
    }
}
#pragma mark -- pravityMethods
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];

    [container insertSubview:toVC.view belowSubview:fromVC.view];

    //改变m34
    CATransform3D transfrom = CATransform3DIdentity;
    transfrom.m34 = -0.002;
    container.layer.sublayerTransform = transfrom;

    //设置anrchPoint 和 position
    CGRect initalFrame = [transitionContext initialFrameForViewController:fromVC];
    toVC.view.frame = initalFrame;
    fromVC.view.frame = initalFrame;
    fromVC.view.layer.anchorPoint = CGPointMake(0, 0.5);
    fromVC.view.layer.position = CGPointMake(0, initalFrame.size.height / 2.0);

    //添加阴影效果
    CAGradientLayer *shadowLayer = [CAGradientLayer layer];
    shadowLayer.colors = @[[UIColor whiteColor],[[UIColor blackColor] colorWithAlphaComponent:0.3]];
    shadowLayer.startPoint = CGPointMake(0, 0.5);
    shadowLayer.endPoint = CGPointMake(1, 0.5);
    shadowLayer.frame = initalFrame;
    UIView *shadow = [[UIView alloc] initWithFrame:initalFrame];
    shadow.backgroundColor = [UIColor clearColor];
    [shadow.layer addSublayer:shadowLayer];
    [fromVC.view addSubview:shadow];
    shadow.alpha = 0;

    //动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        fromVC.view.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);
        shadow.alpha = 1.0;
    } completion:^(BOOL finished) {
        fromVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
        fromVC.view.layer.position = CGPointMake(CGRectGetMidX(initalFrame), CGRectGetMidY(initalFrame));
        fromVC.view.layer.transform = CATransform3DIdentity;
        [shadow removeFromSuperview];

        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        if (!transitionContext.transitionWasCancelled && self.delegate && [self.delegate respondsToSelector:@selector(presentCompleteTransition)]) {
            [self.delegate presentCompleteTransition];
        }
    }];
}
- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *container = [transitionContext containerView];
    [container addSubview:toVC.view];

    //改变m34
    CATransform3D transfrom = CATransform3DIdentity;
    transfrom.m34 = -0.002;
    container.layer.sublayerTransform = transfrom;

    //设置anrchPoint 和 position
    CGRect initalFrame = [transitionContext initialFrameForViewController:fromVC];
    toVC.view.frame = initalFrame;
    toVC.view.layer.anchorPoint = CGPointMake(0, 0.5);
    toVC.view.layer.position = CGPointMake(0, initalFrame.size.height / 2.0);
    toVC.view.layer.transform = CATransform3DMakeRotation(-M_PI_2, 0, 1, 0);

    //添加阴影效果
    CAGradientLayer *shadowLayer = [CAGradientLayer layer];
    shadowLayer.colors = @[[UIColor whiteColor], [[UIColor blackColor] colorWithAlphaComponent:0.3]];
    shadowLayer.startPoint = CGPointMake(0, 0.5);
    shadowLayer.endPoint = CGPointMake(1, 0.5);
    shadowLayer.frame = initalFrame;
    UIView *shadow = [[UIView alloc] initWithFrame:initalFrame];
    shadow.backgroundColor = [UIColor clearColor];
    [shadow.layer addSublayer:shadowLayer];
    [toVC.view addSubview:shadow];
    shadow.alpha = 1;

    //动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        toVC.view.layer.transform = CATransform3DIdentity;
        shadow.alpha = 0;
    } completion:^(BOOL finished) {
        toVC.view.layer.anchorPoint = CGPointMake(0.5, 0.5);
        toVC.view.layer.position = CGPointMake(CGRectGetMidX(initalFrame), CGRectGetMidY(initalFrame));
        [shadow removeFromSuperview];

        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}
- (void)addScreenEdgePanGestureRecognizer:(UIView *)view edges:(UIRectEdge)edges
{
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    edgePan.edges = edges;
    [view addGestureRecognizer:edgePan];
}
- (void)edgePanGesture:(UIScreenEdgePanGestureRecognizer *)edgePan
{
    CGFloat progress = fabs([edgePan translationInView:[UIApplication sharedApplication].keyWindow].x / [UIApplication sharedApplication].keyWindow.bounds.size.width);

    if (edgePan.state == UIGestureRecognizerStateBegan) {
        self.percentDrivenTransition = [UIPercentDrivenInteractiveTransition new];
        if (edgePan.edges == UIRectEdgeRight) {
            [self.fromVc presentViewController:self.toVc animated:YES completion:nil];
        } else if (edgePan.edges == UIRectEdgeLeft) {
            [self.toVc dismissViewControllerAnimated:YES completion:nil];
        }
    } else if (edgePan.state == UIGestureRecognizerStateChanged) {
        [self.percentDrivenTransition updateInteractiveTransition:progress];
    } else if (edgePan.state == UIGestureRecognizerStateCancelled || edgePan.state == UIGestureRecognizerStateEnded) {
        if (progress > 0.5) {
            [self.percentDrivenTransition finishInteractiveTransition];
        } else {
            [self.percentDrivenTransition cancelInteractiveTransition];
        }
        self.percentDrivenTransition = nil;
    }
}
#pragma mark -- setter
- (void)setFromVc:(UIViewController *)fromVc
{
    _fromVc = fromVc;
    fromVc.transitioningDelegate = self;
    [self addScreenEdgePanGestureRecognizer:fromVc.view edges:UIRectEdgeRight];
}
- (void)setToVc:(UIViewController *)toVc
{
    _toVc = toVc;
    toVc.transitioningDelegate = self;
    [self addScreenEdgePanGestureRecognizer:toVc.view edges:UIRectEdgeLeft];
}
@end
