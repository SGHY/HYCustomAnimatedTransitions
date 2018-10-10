//
//  HYTransitions.h
//  HYCustomAnimatedTransitions
//
//  Created by 上官惠阳 on 2018/10/9.
//  Copyright © 2018年 上官惠阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HYTransitionsType) {
    HYTransitionsPush = 0,//管理push动画
    HYTransitionsPop//管理pop动画
};
@protocol HYTransitionsDelegate <NSObject>
@optional
/**push完成的回调**/
- (void)pushCompleteTransition;
@end
@interface HYTransitions : NSObject<UIViewControllerAnimatedTransitioning,UINavigationControllerDelegate>
@property (weak, nonatomic) id <HYTransitionsDelegate> delegate;
/**从pushFromView这个视图push到下一个界面**/
@property (strong, nonatomic) UIView *pushFromView;
/**pushFromView这个视图移动到pushToFrame这个位置**/
@property (assign, nonatomic) CGRect pushToFrame;
/**从popFromView这个视图pop出**/
@property (strong, nonatomic) UIView *popFromView;
@end

