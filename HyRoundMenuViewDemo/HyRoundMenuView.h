//
//  HyRoundMenuView.h
//  Test_Circle_Arranged
//
//  Created by 胡毅 on 17/2/24.
//  Copyright © 2017年 Hy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HyRoundMenuModel.h"

typedef enum : NSUInteger {
    
    HyRoundMenuViewAnimationTypeValue1 = 0,
    HyRoundMenuViewAnimationTypeValue2 = 1,
    
} HyRoundMenuViewAnimationType;

typedef enum : NSUInteger {
    
    HyRoundMenuViewBackgroundViewTypeBlur NS_ENUM_AVAILABLE_IOS(9_0) = 0,
    HyRoundMenuViewBackgroundViewTypeCustomColors = 1,
    
} HyRoundMenuViewBackgroundViewType;

@class HyRoundMenuView;

@protocol HyRoundMenuViewDelegate <NSObject>

@optional

- (void)roundMenuView:(HyRoundMenuView* __nonnull)roundMenuView dragAfterModel:(HyRoundMenuModel* __nonnull)model;

- (void)roundMenuView:(HyRoundMenuView* __nonnull)roundMenuView didSelectRoundMenuModel:(HyRoundMenuModel* __nonnull)model;

@end


@interface HyRoundMenuView : UIControl

@property (nonatomic, assign) BOOL allowDrag;           //Default YES

@property (nonatomic, assign) BOOL allowAdsorption;     //Default YES

@property (nonatomic, assign) BOOL allowEffect3D;       //Default YES

@property (nonatomic, weak,  nullable) id<HyRoundMenuViewDelegate> delegate;

@property (nonatomic, strong, nonnull) NSArray <HyRoundMenuModel *>* dataSources;

@property (nonatomic, assign) HyRoundMenuViewAnimationType animationType;

// **********************************************************************************************
// ******************************* bigRadius/smallRadius 必须等于4 ********************************
// ************ Bezier的大小必须和smallRadius*2的大小一样   建议用【PaintCode】来画想要的图形 ************
// **********************************************************************************************

@property (nonatomic, nullable, weak) UIBezierPath *customBigShapeBezierPath; //默认 圆形

@property (nonatomic, assign) CGFloat smallRadius; //Default 30.f

@property (nonatomic, assign) CGFloat bigRadius;   //Default 120.f

@property (nonatomic, copy  , nonnull) UIColor *shapeColor;

@property (nonatomic, assign) UIBlurEffectStyle blurEffectStyle;

@property (nonatomic, nonnull, copy  ) UIColor *customBackgroundViewColor;

@property (nonatomic, assign) HyRoundMenuViewBackgroundViewType backgroundViewType;

+(__nonnull instancetype) shareInstance;

@end
