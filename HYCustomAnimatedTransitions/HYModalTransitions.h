//
//  HYModalTransitions.h
//  HYCustomAnimatedTransitions
//
//  Created by 上官惠阳 on 2018/10/10.
//  Copyright © 2018年 上官惠阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, HYModalTransitionsType) {
    HYModalPresent = 0,//管理Present动画
    HYModalDismiss//管理Dismiss动画
};
NS_ASSUME_NONNULL_BEGIN
@protocol HYModalTransitionsDelegate <NSObject>
@optional
/**present完成的回调**/
- (void)presentCompleteTransition;
@end
@interface HYModalTransitions : NSObject<UIViewControllerAnimatedTransitioning,UIViewControllerTransitioningDelegate>
@property (weak, nonatomic) id <HYModalTransitionsDelegate> delegate;
@property (assign, nonatomic) HYModalTransitionsType transitionsType;
@property (strong, nonatomic) UIViewController *fromVc;
@property (strong, nonatomic) UIViewController *toVc;
@end

NS_ASSUME_NONNULL_END
