//
//  HyMenuButton.h
//  DragDemo
//
//  Created by 胡毅 on 17/2/25.
//  Copyright © 2017年 YANGReal. All rights reserved.
//
#import <UIKit/UIKit.h>

@class HyMenuButton;
@protocol HyMenuButtonDelegate <NSObject>
@optional
- (void)MonitorTouchEventMnueButton:(HyMenuButton *__nonnull)menuButton;
- (void)animationComplete;
@end

@interface HyMenuButton : UIButton

@property (nonatomic, assign) CGFloat duration;

@property (nonatomic, assign) CGFloat smallRadius;

@property (nonatomic, assign) CGFloat bigRadius;

@property (nonatomic, assign, readonly) BOOL smallAnimationComplete;

@property (nonatomic, assign, readonly) BOOL isOpen;

@property (nonatomic, weak,   nullable) id<HyMenuButtonDelegate> delegate;

@property (nonnull, nonatomic, strong)  CATextLayer *textlayer;

@property (nonnull, nonatomic,  copy)  UIBezierPath* customSmallPath;

@property (nonnull, nonatomic,  copy)  UIBezierPath* customBigPath;

@property (nonnull, nonatomic, strong) CALayer     *imageLayer;

- (CGPoint)getCenter;

- (void)smallAnimation;

- (void)smallAnimation2;

- (void)bigAnimation;

- (void)bigAnimation2;

- (void)restorePoint;

@end
