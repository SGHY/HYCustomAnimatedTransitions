//
//  HYNextViewController.h
//  HYCustomAnimatedTransitions
//
//  Created by 上官惠阳 on 2018/10/9.
//  Copyright © 2018年 上官惠阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYTransitions.h"
#import "HYModalTransitions.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYNextViewController : UIViewController
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) HYTransitions *transitions;
@property (strong, nonatomic) HYModalTransitions *modalTrans;
@end

NS_ASSUME_NONNULL_END
