//
//  HyRoundShapeLayer.m
//  HyRoundMenuViewDemo
//
//  Created by 胡毅 on 17/2/27.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyRoundShapeLayer.h"

@implementation HyRoundShapeLayer

- (void)setPath:(CGPathRef)path
{
    
    CABasicAnimation *opacity = [self opacityAnimation:0 fromValue:1];
    [self addAnimation:opacity forKey:opacity.keyPath];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [super setPath:path];
        CABasicAnimation *opacity1 = [self opacityAnimation:1 fromValue:0];
        [self addAnimation:opacity1 forKey:opacity1.keyPath];
    });
    
}

- (CABasicAnimation *)opacityAnimation:(CGFloat)opacity fromValue:(CGFloat)fromValue;
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue=[NSNumber numberWithFloat:fromValue];
    animation.toValue=[NSNumber numberWithFloat:opacity];
    animation.duration=0.2;
    animation.autoreverses=NO;
    animation.repeatCount=0;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    return animation;
}

@end
